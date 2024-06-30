part of 'custom_dropdown.dart';

const _textFieldIcon = Icon(
  Icons.keyboard_arrow_down_rounded,
  color: Colors.black,
  size: 20,
);
const _contentPadding = EdgeInsets.only(left: 10,top: 10);
const _noTextStyle = TextStyle(height: 0);
const _errorBorderSide = BorderSide(color: Colors.redAccent, width: 2);

class _DropDownField extends StatefulWidget {
  final TextEditingController controller;
  final VoidCallback onTap;
  final Function(String)? onChanged;
  final String? hintText;
  final TextStyle? hintStyle;
  final TextStyle? Style;
  final String? errorText;
  final TextStyle? errorStyle;
  final BorderSide? borderSide;
  final BorderSide? errorBorderSide;
  final BorderRadius? borderRadius;
  final Widget? suffixIcon;
  final Color? fillColor;

  const _DropDownField({
    Key? key,
    required this.controller,
    required this.onTap,
    this.onChanged,
    this.suffixIcon,
    this.hintText,
    this.hintStyle,
    this.Style,
    this.errorText,
    this.errorStyle,
    this.borderSide,
    this.errorBorderSide,
    this.borderRadius,
    this.fillColor,
  }) : super(key: key);

  @override
  State<_DropDownField> createState() => _DropDownFieldState();
}

class _DropDownFieldState extends State<_DropDownField> {
  String? prevText;
  bool listenChanges = true;

  @override
  void initState() {
    super.initState();
    if (widget.onChanged != null) {
      widget.controller.addListener(listenItemChanges);
    }
  }

  @override
  void dispose() {
    widget.controller.removeListener(listenItemChanges);
    super.dispose();
  }

  @override
  void didUpdateWidget(covariant _DropDownField oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.onChanged != null) {
      widget.controller.addListener(listenItemChanges);
    } else {
      listenChanges = false;
    }
  }

  void listenItemChanges() {
    if (listenChanges) {
      final text = widget.controller.text;
      if (prevText != null && prevText != text && text.isNotEmpty) {
        widget.onChanged!(text);
      }
      prevText = text;
    }
  }

  @override
  Widget build(BuildContext context) {
    final border = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      borderSide: widget.borderSide ?? BorderSide(color: Colorr.themcolor),
    );

    final errorBorder = OutlineInputBorder(
      borderRadius: widget.borderRadius ?? BorderRadius.circular(12),
      borderSide: widget.errorBorderSide ?? _errorBorderSide,
    );
    return Container(
      height: 40,
      padding: EdgeInsets.only(left: 10,right: 10),
      margin: EdgeInsets.only(top: 5,bottom: 5),
      child: TextFormField(
        controller: widget.controller,
        validator: (val) {
          if (val?.isEmpty ?? false) return widget.errorText ?? '';
          return null;
        },
        onTap: widget.onTap,
        readOnly: true,
        onChanged: widget.onChanged,
        style: widget.Style,
        decoration: InputDecoration(
          isDense: true,
          contentPadding: _contentPadding,
          suffixIcon: widget.suffixIcon ?? _textFieldIcon,
          hintText: widget.hintText,
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(
              color: Colorr.themcolor300,
              width: 2,
            ),
          ),
          labelText: widget.hintText,
          labelStyle: TextStyle(
            fontFamily: "PoppinsR",
            color: Colorr.themcolor,
            fontSize: 13,
            fontWeight: FWeight.fW400,
          ),
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: BorderSide(),
          ),
          hintStyle: TextStyle(color: Colorr.Grey600,fontSize: 14),
          errorStyle: widget.errorText != null ? widget.errorStyle : _noTextStyle,
          enabledBorder: border,
          errorBorder: errorBorder,
          focusedErrorBorder: errorBorder,
        ),
      ),
    );
  }
}
