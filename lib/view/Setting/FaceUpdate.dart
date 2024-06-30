import 'dart:developer';
import 'dart:io';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:attendy/A_SQL_Trigger/api_page.dart';
import 'package:attendy/view/Dashboard/Dashboard.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../../Screens/DrawerOnly/FaceDetectorPainter.dart';
import '../../Screens/DrawerOnly/utils.dart';
import '../../utils/Constant/LocalCustomWidgets.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:quiver/collection.dart';
import 'package:flutter/services.dart';

class Face_update extends StatefulWidget {
  const Face_update({super.key});

  @override
  State<Face_update> createState() => _Face_updateState();
}

class _Face_updateState extends State<Face_update> {
  late File jsonFile;
  dynamic _scanResults;
  CameraController? _camera;
  var interpreter;
  bool _isDetecting = false;
  CameraLensDirection _direction = CameraLensDirection.front;
  dynamic data = [];
  double threshold = 1.0;
  late Directory tempDir;
  List e1 = [];
  bool _faceFound = false;
  final TextEditingController _name = new TextEditingController();

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _initializeCamera();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
  }

  Future loadModel() async {
    try {
      final gpuDelegateV2 = tfl.GpuDelegateV2(
          options: tfl.GpuDelegateOptionsV2(
              isPrecisionLossAllowed: false,
              inferencePreference: tfl.TfLiteGpuInferenceUsage.fastSingleAnswer,
              inferencePriority1: tfl.TfLiteGpuInferencePriority.minLatency,
              inferencePriority2: tfl.TfLiteGpuInferencePriority.auto,
              inferencePriority3: tfl.TfLiteGpuInferencePriority.auto));

      var interpreterOptions = tfl.InterpreterOptions()
        ..addDelegate(gpuDelegateV2);
      interpreter = await tfl.Interpreter.fromAsset('mobilefacenet.tflite',
          options: interpreterOptions);
    } catch (e) {
      print('Failed to load model.$e');
    }
  }

  void _initializeCamera() async {
    await loadModel();
    CameraDescription description = await getCamera(_direction);

    ImageRotation rotation = rotationIntToImageRotation(
      description.sensorOrientation,
    );
    setState(() {});
    _camera =
        CameraController(description, ResolutionPreset.max, enableAudio: false);
    await _camera?.initialize();
    setState(() {});
    await Future.delayed(Duration(milliseconds: 500));
    tempDir = await getApplicationDocumentsDirectory();
    String _embPath = tempDir.path + '/emb.json';
    jsonFile = File(_embPath);
    SharedPreferences prefs = await SharedPreferences.getInstance();
    if (Constants_Usermast.FaceID.isNotEmpty)
      data = Constants_Usermast.FaceID.split(",")
          .map((e) => double.parse(e))
          .toList();

    _camera?.startImageStream((CameraImage image) {
      if (_camera != null) {
        if (_isDetecting) return;
        _isDetecting = true;
        String res;
        dynamic finalResult = Multimap<String, Face>();
        detect(image, _getDetectionMethod(), rotation).then(
              (dynamic result) async {
            if (result.length == 0) {
              _faceFound = false;
            } else {
              _faceFound = true;
            }
            Face face;
            imglib.Image convertedImage =
            _convertCameraImage(image, _direction);
            for (face in result) {
              double x, y, w, h;
              x = (face.boundingBox.left - 10);
              y = (face.boundingBox.top - 10);
              w = (face.boundingBox.width + 10);
              h = (face.boundingBox.height + 10);
              imglib.Image croppedImage = imglib.copyCrop(
                  convertedImage, x.round(), y.round(), w.round(), h.round());
              croppedImage = imglib.copyResizeCropSquare(croppedImage, 112);
              // int startTime = new DateTime.now().millisecondsSinceEpoch;
              res = _recog(croppedImage);
              // int endTime = new DateTime.now().millisecondsSinceEpoch;
              // print("Inference took ${endTime - startTime}ms");
              finalResult.add(res, face);
            }
            setState(() {
              _scanResults = finalResult;
            });
            _isDetecting = false;
          },
        ).catchError(
              (_) {
            _isDetecting = false;
          },
        );
      }
    });
  }

  _getDetectionMethod() {
    final faceDetector = GoogleVision.instance.faceDetector(
      const FaceDetectorOptions(
        mode: FaceDetectorMode.accurate,
      ),
    );
    return faceDetector.processImage;
  }

  Widget _buildResults() {
    const Text noResultsText = const Text('');
    if (_scanResults == null || _camera?.value.isInitialized == false) {
      return noResultsText;
    }
    CustomPainter painter;

    final Size imageSize = Size(
      _camera?.value.previewSize?.height ?? 0,
      _camera?.value.previewSize?.width ?? 0,
    );
    painter = FaceDetectorPainter(imageSize, _scanResults);
    return CustomPaint(
      size: MediaQuery.of(context).size,
      painter: painter,
    );
  }

  Widget _buildImage() {
    if (_camera == null || _camera?.value.isInitialized == false) {
      return Center(
        child: CircularProgressIndicator(),
      );
    }

    return Container(
      constraints: const BoxConstraints.expand(),
      child: _camera == null
          ? const Center(child: null)
          : Stack(
        fit: StackFit.expand,
        children: <Widget>[
          CameraPreview(_camera!),
        ],
      ),
    );
  }

  void _toggleCameraDirection() async {
    if (_direction == CameraLensDirection.back) {
      _direction = CameraLensDirection.front;
    } else {
      _direction = CameraLensDirection.back;
    }

    setState(() {});

    _initializeCamera();
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () {
         Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) {
          return Dashboard();
        },));
         return Future(() => true);
      },
      child: Scaffold(
        appBar: CustomWidgets.appbar(
          title: "Face Update",
          action: [],
          context: context,
          onTap: () {
            Navigator.pushReplacement(context, MaterialPageRoute(
              builder: (context) {
                return Dashboard();
              },
            ));
          },
        ),
        body: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Spacer(),
            Center(
              child: SizedBox(
                  height: MediaQuery.of(context).size.height /2.5,
                  width: MediaQuery.of(context).size.width/1.5,
                  child: Stack(alignment: Alignment.center,
                    children: [
                      _buildImage(),
                      Center(
                        child: Container(
                          height: MediaQuery.of(context).size.height * 0.3,
                          width: MediaQuery.of(context).size.width * 0.7,
                          child: Lottie.asset('assets/Zl4tHCoFwy.json',
                              fit: BoxFit.fill, animate: _faceFound ? true : false),

                        ),
                      )
                    ],
                  )),
            ),
            Spacer(),
            CustomWidgets.confirmButton(
                onTap: () async {
                  if (_faceFound) {

                    api_page.userupdateFaceid(e1);
                    Navigator.pushReplacement(context, MaterialPageRoute(
                      builder: (context) {
                        return Dashboard();
                      },
                    ));
                    CustomWidgets.showToast(
                        context, "Face Update successfully", true);
                  } else {
                    showDialog(
                      context: context,
                      builder: (context) {
                        return AlertDialog(
                          title: Text("No Face Detect"),
                          actions: [
                            CustomWidgets.confirmButton(onTap: () {
                              Navigator.pop(context);
                            }, height: MediaQuery.of(context).size.height * 0.05, width: MediaQuery.of(context).size.width * 0.2, text:"Close")
                          ],
                        );
                      },
                    );
                  }
                },
                height: MediaQuery.of(context).size.height * 0.05,
                width: MediaQuery.of(context).size.width * 0.4,
                text: "Update"),
            CustomWidgets.height(20)
          ],
        ),
        //todo FlotingActionBUtton
        // floatingActionButton: Column(mainAxisAlignment: MainAxisAlignment.end, children: [
        //   FloatingActionButton(
        //     backgroundColor: (_faceFound) ? Colors.blue : Colors.blueGrey,
        //     child: Icon(Icons.add),
        //     onPressed: () {
        //       if (_faceFound) _addLabel();
        //     },
        //     heroTag: null,
        //   ),
        //   SizedBox(
        //     height: 10,
        //   ),
        //   FloatingActionButton(
        //     onPressed: _toggleCameraDirection,
        //     heroTag: null,
        //     child: _direction == CameraLensDirection.back
        //         ? const Icon(Icons.camera_front)
        //         : const Icon(Icons.camera_rear),
        //   ),
        // ]),
      ),
    );
  }

  imglib.Image _convertCameraImage(
      CameraImage image, CameraLensDirection _dir) {
    int width = image.width;
    int height = image.height;
    // imglib -> Image package from https://pub.dartlang.org/packages/image
    var img = imglib.Image(width, height); // Create Image buffer
    const int hexFF = 0xFF000000;
    final int uvyButtonStride = image.planes[1].bytesPerRow;
    final int? uvPixelStride = image.planes[1].bytesPerPixel;
    for (int x = 0; x < width; x++) {
      for (int y = 0; y < height; y++) {
        final int uvIndex = uvPixelStride! * (x / 2).floor() +
            uvyButtonStride * (y / 2).floor();
        final int index = y * width + x;
        final yp = image.planes[0].bytes[index];
        final up = image.planes[1].bytes[uvIndex];
        final vp = image.planes[2].bytes[uvIndex];
        // Calculate pixel color
        int r = (yp + vp * 1436 / 1024 - 179).round().clamp(0, 255);
        int g = (yp - up * 46549 / 131072 + 44 - vp * 93604 / 131072 + 91)
            .round()
            .clamp(0, 255);
        int b = (yp + up * 1814 / 1024 - 227).round().clamp(0, 255);
        // color: 0x FF  FF  FF  FF
        //           A   B   G   R
        img.data[index] = hexFF | (b << 16) | (g << 8) | r;
      }
    }
    var img1 = (_dir == CameraLensDirection.front)
        ? imglib.copyRotate(img, -90)
        : imglib.copyRotate(img, 90);
    return img1;
  }

  String _recog(imglib.Image img) {
    List input = imageToByteListFloat32(img, 112, 128, 128);
    input = input.reshape([1, 112, 112, 3]);
    List output = List.filled(1 * 192, null, growable: false).reshape([1, 192]);
    interpreter.run(input, output);
    output = output.reshape([192]);
    e1 = List.from(output);
    return compare(e1).toUpperCase();
  }

  String compare(List currEmb) {
    if (data.length == 0) return "No Face saved";
    double minDist = 999;
    double currDist = 0.0;
    String predRes = "NOT RECOGNIZED";
    if (data != null) {
      currDist = euclideanDistance(data, currEmb);
      if (currDist <= threshold && currDist < minDist) {
        // Navigator.pushReplacement(context, MaterialPageRoute(
        //   builder: (context) {
        //     return Dashboard();
        //   },
        // ));
      }
    }
    return predRes;
  }

  void _resetFile() {
    data = {};
    jsonFile.deleteSync();
  }

  void _viewLabels() {
    setState(() {
      _camera = null;
    });
    String name;
    var alert =  AlertDialog(
      title:  Text("Saved Faces"),
      content:  ListView.builder(
          padding:  EdgeInsets.all(2),
          itemCount: data.length,
          itemBuilder: (BuildContext context, int index) {
            name = data.keys.elementAt(index);
            return  Column(
              children: <Widget>[
                 ListTile(
                  title:  Text(
                    name,
                    style:  TextStyle(
                      fontSize: 14,
                      color: Colors.grey[400],
                    ),
                  ),
                ),
                 Padding(
                  padding: EdgeInsets.all(2),
                ),
                 Divider(),
              ],
            );
          }),
      actions: <Widget>[
         TextButton(
          child: Text("OK"),
          onPressed: () {
            _initializeCamera();
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  void _addLabel() {
    setState(() {
      _camera = null;
    });
    var alert = new AlertDialog(
      title: new Text("Add Face"),
      content: new Row(
        children: <Widget>[
          new Expanded(
            child: new TextField(
              controller: _name,
              autofocus: true,
              decoration: new InputDecoration(
                  labelText: "Name", icon: new Icon(Icons.face)),
            ),
          )
        ],
      ),
      actions: <Widget>[
        new TextButton(
            child: Text("Save"),
            onPressed: () {
              _handle(_name.text.toUpperCase());
              _name.clear();
              Navigator.pop(context);
            }),
        new TextButton(
          child: Text("Cancel"),
          onPressed: () {
            _initializeCamera();
            Navigator.pop(context);
          },
        )
      ],
    );
    showDialog(
        context: context,
        builder: (context) {
          return alert;
        });
  }

  void _handle(String text) async {
    // data[text] = e1;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("data", json.encode(data));
    // jsonFile.writeAsStringSync(json.encode(data));
    _initializeCamera();
  }
}
