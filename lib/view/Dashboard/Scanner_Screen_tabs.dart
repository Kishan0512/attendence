import 'dart:async';
import 'dart:io';
import 'package:attendy/A_SQL_Trigger/Attendance_api.dart';
import 'package:attendy/A_SQL_Trigger/Con_List.dart';
import 'package:attendy/A_SQL_Trigger/api_page.dart';
import 'package:attendy/utils/Constant/LocalCustomWidgets.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:google_ml_vision/google_ml_vision.dart';
import 'package:lottie/lottie.dart';
import 'package:path_provider/path_provider.dart';
import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';
import 'package:attendy/A_SQL_Trigger/Con_Usermast.dart';
import 'package:image/image.dart' as imglib;
import 'package:tflite_flutter/tflite_flutter.dart' as tfl;
import 'package:quiver/collection.dart';
import '../../Screens/DrawerOnly/utils.dart';
import '../../utils/Constant/Colors.dart';
import '../../utils/Constant/FontWeight.dart';

class Scanner_Screen extends StatefulWidget {
  const Scanner_Screen({Key? key}) : super(key: key);

  @override
  State<Scanner_Screen> createState() => _Scanner_ScreenState();
}

class _Scanner_ScreenState extends State<Scanner_Screen> {
  DateTime now = DateTime.now();
  String _currentTime = '';
  CameraController? _camera;
  var interpreter;
  late File jsonFile;
  dynamic _scanResults;
  bool _faceFound = false;
  bool _isDetecting = false;
  List<dynamic> Attendance = [];
  bool AttandanceDone = true;
  dynamic data = {};
  double threshold = 1.0;
  late Directory tempDir;
  List e1 = [];
  CameraLensDirection _direction = CameraLensDirection.front;

  @override
  void initState() {
    super.initState();
    SystemChrome.setPreferredOrientations(
        [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown]);
    _initializeCamera();
    // Start updating the time every second
    getdata();
  }

  getdata() async {
    Con_List.Users = await api_page.userSelect();
    Timer.periodic(Duration(seconds: 1), (Timer timer) {
      // Get the current time
      DateTime now = DateTime.now();
      // Format the time as "05:26 PM"
      String formattedTime = DateFormat('hh:mm a').format(now);
      _currentTime = formattedTime;
    });
    setState(() {});
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

  Widget build(BuildContext context) {
    String formattedDate = DateFormat('dd MMM yyyy').format(now);
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Constants_Usermast.IOS == true
        ? SingleChildScrollView(
            child: Column(
              children: [
                CupertinoButton(
                  onPressed: () {},
                  padding: EdgeInsets.zero,
                  child: Container(
                    height: height / 2.3,
                    width: width / 1.3,
                    child: Stack(
                      children: [
                        _buildImage(),
                        Center(
                          child: Container(
                            height: 300,
                            width: 300,
                            child: Lottie.asset(
                              'assets/Zl4tHCoFwy.json',
                              fit: BoxFit.fill,
                              animate: _faceFound ? true : false,
                            ),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Text(
                  formattedDate.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "PoppinsM",
                    color: Colorr.themcolor300,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Text(
                  _currentTime,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colorr.themcolor300,
                    fontSize: 20,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                Container(
                  height: height / 3.5,
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: ListView.builder(
                    itemCount: Con_List.Attandance.length,
                    itemBuilder: (context, index) {
                      Con_List.Attandance.sort(
                        (b, a) => a['time']
                            .toString()
                            .compareTo(b['time'].toString()),
                      );
                      return Container(
                        margin: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        height: height / 20,
                        decoration: BoxDecoration(
                          color: CupertinoColors.systemBlue.withOpacity(0.1),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text(
                          Con_List.Attandance[index]['data'],
                          style: TextStyle(
                            color: Colorr.themcolor300,
                            fontSize: 16,
                          ),
                        ),
                      );
                    },
                  ),
                ),
              ],
            ),
          )
        : SingleChildScrollView(
            child: Column(
              children: [
                InkWell(
                  onTap: () {},
                  child: Container(
                    height: height / 2.3,
                    width: width / 1.3,
                    child: Stack(
                      children: [
                        _buildImage(),
                        Center(
                          child: Container(
                            height: 300,
                            width: 300,
                            child: Lottie.asset('assets/Zl4tHCoFwy.json',
                                fit: BoxFit.fill,
                                animate: _faceFound ? true : false),
                          ),
                        )
                      ],
                    ),
                  ),
                ),
                Text(
                  formattedDate.toString(),
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "PoppinsM",
                      color: Colorr.themcolor,
                      fontSize: 16,
                      fontWeight: FWeight.fW500),
                ),
                Text(
                  _currentTime,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Poppins",
                      color: Colorr.themcolor,
                      fontSize: 20,
                      fontWeight: FWeight.fW500),
                ),
                Container(
                  height: height / 3.5,
                  padding: EdgeInsets.all(10),
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(10)),
                  child: ListView.builder(
                    itemCount: Con_List.Attandance.length,
                    itemBuilder: (context, index) {
                      Con_List.Attandance.sort(
                        (b, a) => a['time']
                            .toString()
                            .compareTo(b['time'].toString()),
                      );
                      return Container(
                        margin: EdgeInsets.all(5),
                        alignment: Alignment.center,
                        height: height / 20,
                        decoration: BoxDecoration(
                            color: Colorr.themcolor100,
                            borderRadius: BorderRadius.circular(5)),
                        child: Row(
                          children: [
                            Checkbox(
                              shape: CircleBorder(),
                              value: true,
                              activeColor: Colorr.themcolor,
                              onChanged: (value) {},
                            ),
                            Text(Con_List.Attandance[index]['data'],
                                style: TextStyle(
                                    color: Colorr.themcolor, fontSize: 16)),
                          ],
                        ),
                      );
                    },
                  ),
                )
              ],
            ),
          );
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _camera?.dispose();

    interpreter?.close();
    interpreter = null;
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
    await Future.delayed(Duration(milliseconds: 500));
    tempDir = await getApplicationDocumentsDirectory();
    String _embPath = tempDir.path + '/emb.json';
    jsonFile = new File(_embPath);
    Con_List.Users.forEach((element) {
      if (element['faceId'].toString().isNotEmpty) {
        String name = element['name'];
        String faceIdString = element['faceId'];
        List faceIdList = [];
        faceIdString.split(",").forEach((value) {
          try {
            double parsedValue = double.parse(value.trim());
            faceIdList.add(parsedValue);
          } catch (e) {
            print("Invalid value: $value");
          }
        });
        data[name] = faceIdList;
      }
    });
    // if (Constants_Usermast.FaceID.isNotEmpty) data = Constants_Usermast.FaceID.split(",").map((e) => double.parse(e)).toList();

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
    double minDist = 2;
    double currDist = 0.0;
    String predRes = "NOT RECOGNIZED";
    for (String label in data.keys) {
      currDist = euclideanDistance(data[label], currEmb);
      if (currDist <= threshold && currDist < minDist) {
        predRes = label;
        if (Con_List.Users.firstWhere((e) => e['name'] == label)['employeeId']
            .toString()
            .isNotEmpty) {
          if (Constants_Usermast.statuse == "ADMIN") {
            if (Attendance.isNotEmpty) {
              if (Attendance.where((element) =>
                  element['_id'] ==
                  Con_List.Users.firstWhere(
                          (e) => e['name'] == label)['employeeId']['_id']
                      .toString()).isNotEmpty) {
                String Time = Attendance.where((element) =>
                    element['_id'] ==
                    Con_List.Users.firstWhere(
                            (e) => e['name'] == label)['employeeId']['_id']
                        .toString()).last['Time'].toString();
                DateTime startTime = DateTime.parse(Time);
                DateTime endTime = DateTime.now();
                Duration difference = endTime.difference(startTime);
                int differenceInMinutes = difference.inMinutes;
                if (differenceInMinutes >= 5) {

                  Map data = {
                    "companyId": Constants_Usermast.companyId.toString(),
                    "employeeId": Con_List.Users.firstWhere(
                            (e) => e['name'] == label)['employeeId']['_id']
                        .toString(),
                    // "employeeId": "6488392bfdfc8d1929ad83da",
                    "type": "Attandance",
                    "timeIn": "",
                    "timeOut": "",
                    "overTime": "",
                    "faceId": Con_List.Users.firstWhere(
                            (e) => e['name'] == label)['faceId']
                        .toString()
                  };
                  Attendance_api.AttendanceInsert(data).then((value){
                    if(value==200)
                      {
                    String formattedDate = DateFormat('dd MMM yyyy').format(now);
                    Con_List.Attandance.add({
                      'time': '${DateTime.now()}',
                      'data': "$label $formattedDate $_currentTime"
                    });
                    Attendance.add({
                      "_id": Con_List.Users.firstWhere(
                              (e) => e['name'] == label)['employeeId']['_id']
                          .toString(),
                      "Time": '${DateTime.now()}'
                    });

                      }else{
                      CustomWidgets.showToast(context, "$value can't be pass null value", false);
                    }
                    setState(() {});
                  });

                } else {
                  CustomWidgets.showToast(context,
                      "Please wait ${5 - differenceInMinutes} minutes", false);
                }
              } else {

                Map data = {
                  "companyId": Constants_Usermast.companyId.toString(),
                  "employeeId": Con_List.Users.firstWhere(
                          (e) => e['name'] == label)['employeeId']['_id']
                      .toString(),
                  "type": "Attandance",
                  "timeIn": "",
                  "timeOut": "",
                  "overTime": "",
                  "faceId": Con_List.Users.firstWhere(
                          (e) => e['name'] == label)['faceId']
                      .toString()
                };
                Attendance_api.AttendanceInsert(data).then((value){
                  if(value == 200)
                    {
                  String formattedDate = DateFormat('dd MMM yyyy').format(now);
                  Con_List.Attandance.add({
                    'time': '${DateTime.now()}',
                    'data': "$label $formattedDate $_currentTime"
                  });
                  Attendance.add({
                    "_id": Con_List.Users.firstWhere(
                            (e) => e['name'] == label)['employeeId']['_id']
                        .toString(),
                    "Time": '${DateTime.now()}'
                  });}else{
                    CustomWidgets.showToast(context, "$value can't be pass null value", false);
                  }
                  setState(() {});
                });
              }
            } else {

              Map data = {
                "companyId": Constants_Usermast.companyId.toString(),
                "employeeId": Con_List.Users.firstWhere(
                        (e) => e['name'] == label)['employeeId']['_id']
                    .toString(),
                // "employeeId": "6488392bfdfc8d1929ad83da",
                "type": "Attandance",
                "timeIn": "",
                "timeOut": "",
                "overTime": "",
                "faceId": Con_List.Users.firstWhere(
                        (e) => e['name'] == label)['faceId']
                    .toString()
              };
              Attendance_api.AttendanceInsert(data).then((value){
                if(value == 200)
                  {
                String formattedDate = DateFormat('dd MMM yyyy').format(now);
                Con_List.Attandance.add({
                  'time': '${DateTime.now()}',
                  'data': "$label $formattedDate $_currentTime"
                });
                Attendance.add({
                  "_id": Con_List.Users.firstWhere(
                          (e) => e['name'] == label)['employeeId']['_id']
                      .toString(),
                  "Time": '${DateTime.now()}'
                });}else{
                  CustomWidgets.showToast(context, "$value can't be pass null value", false);
                }
                setState(() {});
              });

            }
          } else {
            if (Constants_Usermast.employeeId.isNotEmpty) {
              if (Constants_Usermast.name == label) {
                if (Attendance.isNotEmpty) {
                  if (Attendance.where((element) =>
                          element['_id'] == Constants_Usermast.employeeId)
                      .isNotEmpty) {
                    String Time = Attendance.where((element) =>
                            element['_id'] == Constants_Usermast.employeeId)
                        .last['Time']
                        .toString();
                    DateTime startTime = DateTime.parse(Time);
                    DateTime endTime = DateTime.now();
                    Duration difference = endTime.difference(startTime);
                    int differenceInMinutes = difference.inMinutes;
                    if (differenceInMinutes >= 5) {
                      Map data = {
                        "companyId": Constants_Usermast.companyId.toString(),
                        "employeeId": Constants_Usermast.employeeId.toString(),
                        "type": "Attandance",
                        "timeIn": "",
                        "timeOut": "",
                        "overTime": "",
                        "faceId": Con_List.Users.firstWhere(
                                (e) => e['name'] == label)['faceId']
                            .toString(),
                      };
                      Attendance_api.AttendanceInsert(data).then((value){
                        if(value == 200)
                          {
                        String formattedDate =
                        DateFormat('dd MMM yyyy').format(now);
                        Con_List.Attandance.add({
                          'time': '${DateTime.now()}',
                          'data': "$label $formattedDate $_currentTime"
                        });
                        Attendance.add({
                          "_id": Con_List.Users.firstWhere(
                                  (e) => e['name'] == label)['employeeId']['_id']
                              .toString(),
                          "Time": '${DateTime.now()}'
                        });}else{
                          CustomWidgets.showToast(context, "$value can't be pass null value", false);
                        }
                        setState(() {});
                      });
                    } else {
                      CustomWidgets.showToast(
                          context,
                          "Please wait ${5 - differenceInMinutes} minutes",
                          false);
                    }
                  } else {
                    if (Constants_Usermast.name == label) {
                      Map data = {
                        "companyId": Constants_Usermast.companyId.toString(),
                        "employeeId": Constants_Usermast.employeeId.toString(),
                        "type": "Attandance",
                        "timeIn": "",
                        "timeOut": "",
                        "overTime": "",
                        "faceId": Con_List.Users.firstWhere(
                                (e) => e['name'] == label)['faceId']
                            .toString(),
                      };
                      Attendance_api.AttendanceInsert(data).then((value){
                        if(value == 200)
                          {
                        String formattedDate =
                        DateFormat('dd MMM yyyy').format(now);
                        Con_List.Attandance.add({
                          'time': '${DateTime.now()}',
                          'data': "$label $formattedDate $_currentTime"
                        });
                        Attendance.add({
                          "_id": Con_List.Users.firstWhere(
                                  (e) => e['name'] == label)['employeeId']['_id']
                              .toString(),
                          "Time": '${DateTime.now()}'
                        });}else{
                          CustomWidgets.showToast(context, "$value can't be pass null value", false);
                        }
                        setState(() {});
                      });
                    }
                  }
                } else {
                  if (Constants_Usermast.name == label) {
                    Map data = {
                      "companyId": Constants_Usermast.companyId.toString(),
                      "employeeId": Constants_Usermast.employeeId.toString(),
                      "type": "Attandance",
                      "timeIn": "",
                      "timeOut": "",
                      "overTime": "",
                      "faceId": Con_List.Users.firstWhere(
                              (e) => e['name'] == label)['faceId']
                          .toString(),
                    };
                    Attendance_api.AttendanceInsert(data).then((value) {
                      if(value == 200)
                        {
                      String formattedDate =
                      DateFormat('dd MMM yyyy').format(now);
                      Con_List.Attandance.add({
                        'time': '${DateTime.now()}',
                        'data': "$label $formattedDate $_currentTime"
                      });
                      Attendance.add({
                        "_id": Con_List.Users.firstWhere(
                                (e) => e['name'] == label)['employeeId']['_id']
                            .toString(),
                        "Time": '${DateTime.now()}'
                      });}else{
                        CustomWidgets.showToast(context, "$value can't be pass null value", false);
                      }
                      setState(() {});
                    });
                  }
                }
              }
            } else {
              CustomWidgets.showToast(
                  context, "Please Contact Administrator", false);
            }
          }
        } else if (Con_List.Users.firstWhere(
                (e) => e['name'] == label)['employeeId']['_id']
            .toString()
            .isEmpty) {
          CustomWidgets.showToast(
              context, "Please Contact Administrator", false);
        }
      }
    }
    return predRes;
  }

  void _handle(String text) async {
    // data[text] = e1;
    // SharedPreferences prefs = await SharedPreferences.getInstance();
    // prefs.setString("data", json.encode(data));
    // jsonFile.writeAsStringSync(json.encode(data));
    _initializeCamera();
  }
}
