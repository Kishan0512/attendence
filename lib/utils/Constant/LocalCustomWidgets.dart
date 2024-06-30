import 'dart:ui';
import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:attendy/utils/Constant/Colors.dart';
import 'package:attendy/utils/Constant/FontWeight.dart';
import 'package:flutter/services.dart';
import 'package:intl/intl.dart';

import 'Tost.dart';
import 'swipe_button.dart';

class CustomWidgets {
  static style() {
    return TextStyle(fontSize: 14);
  }

  static button(
          {double? height,
          double? paddingLeft,
          double? paddingRight,
          double? paddingTop,
          double? paddingBottom,
          radius,
          Color? color,
          textColor,
          required String buttonTitle,
          required VoidCallback onTap}) =>
      GestureDetector(
        onTap: onTap,
        child: Container(
          margin: EdgeInsets.only(
              left: paddingLeft ?? 15,
              right: paddingRight ?? 15,
              top: paddingTop ?? 0,
              bottom: paddingBottom ?? 0),
          height: 40,
          width: double.infinity,
          decoration: BoxDecoration(
              // border: Border.all(color: Colors.black, width: 1),
              color: color,
              borderRadius: BorderRadius.circular(radius ?? 50)),
          child: Center(
            child: Text(
              buttonTitle,
              style: TextStyle(
                color: textColor,
                fontSize: 15,
                fontWeight: FontWeight.w600,
                fontFamily: "Poppins",
              ),
            ),
          ),
        ),
      );

  static bool isValidEmail(String email) {
    final pattern = r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$';
    final regex = RegExp(pattern);
    return regex.hasMatch(email);
  }

  static confirmButton(
      {required void Function() onTap,
      required double height,
      required double width,
      required String text,
      Color? Clr}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Clr == null ? Color(0XFF4A978B) : Clr,
          borderRadius: BorderRadius.circular(30),
        ),
        child: poppinsText(text, Colors.white, 13, FontWeight.w500),
      ),
    );
  }

  static confirmButton1(
      {required void Function() onTap,
      required double height,
      required double width,
      required String text,
      required double textsize,
      Color? Clr,
      Color? txtClr}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height,
        width: width,
        alignment: Alignment.center,
        decoration: BoxDecoration(
          color: Clr == null ? Color(0XFF4A978B) : Clr,
          borderRadius: BorderRadius.circular(5),
        ),
        child: poppinsText(text, txtClr == null ? Colors.white : txtClr,
            textsize, FontWeight.w500),
      ),
    );
  }

  static navigateBack({
    required VoidCallback onPressed,
    required Widget icon,
    Color? color,
    double? iconSize,
    double? splashRadius,
  }) {
    return IconButton(
      onPressed: onPressed,
      icon: icon,
      splashRadius: splashRadius ?? 18,
      iconSize: iconSize ?? 25,
      color: color ?? Colors.white,
    );
  }

  static textField(
      {TextEditingController? controller,
      void Function(dynamic)? onChanged,
      double? height,
      double? textHeight,
      double? width,
      Alignment? Alignment1,
      int? MaxFont,
      String? erroreText,
      double? paddingLeft,
      InputBorder? eorror,
      maxLines,
      double? radius,
      FocusNode? focus,
      double? borderWidth,
      bool? readOnly,
      double? enabledBorderRadius,
      TextAlignVertical? textAlignVertical,
      double? fontSize,
      var borderSide,
      var filled,
      var obscureText,
      var enabledBorder,
      dynamic textAlign,
      keyboardType,
      fontWeight,
      prefixIcon,
      suffixIcon,
      fontFamily,
      suffix,
      prefix,
      required String hintText,
      var label,
      Color? fontColor,
      Color? borderColor,
      Color? fillColor,
      color}) {
    return Container(
      height: height ?? 40,
      width: width,
      alignment: Alignment1 ?? Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
          border: Border.all(
              color: borderColor ?? Colorr.Transparent,
              width: borderWidth ?? 0),
          color: color,
          borderRadius: BorderRadius.circular(0)),
      child: TextField(
        focusNode: focus,
        textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
        obscureText: obscureText ?? false,
        style: TextStyle(color: Colorr.Black, fontSize: 15),
        keyboardType: keyboardType ?? TextInputType.text,
        maxLines: maxLines ?? 1,
        textAlign: textAlign ?? TextAlign.start,
        controller: controller,
        cursorColor: Colorr.themcolor500,
        readOnly: readOnly ?? false,
        onChanged: onChanged,
        maxLength: MaxFont ?? null,

        onEditingComplete: () {},
        decoration: InputDecoration(
            isDense: true,
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colorr.themcolor,
                )),
            errorBorder: eorror,
            errorText: erroreText,
            // errorText: "Enter Valid Email",
            contentPadding: EdgeInsets.only(bottom: 30, left: 10),
            focusedBorder: OutlineInputBorder(
                borderRadius:
                    BorderRadius.circular(enabledBorderRadius ?? 10),
                borderSide: enabledBorder ??
                    BorderSide(
                      color: Colorr.themcolor300,
                      width: 2,
                    )),
            filled: filled,
            fillColor: fillColor,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            suffix: suffix,
            prefix: prefix,
            hintText: hintText,
            labelText: hintText,
            labelStyle: TextStyle(
                fontFamily: "PoppinsR",
                color: Colorr.themcolor,
                fontSize: 13,
                fontWeight: FWeight.fW400),
            hintStyle: TextStyle(
                height: textHeight ?? 3.20,
                fontFamily: fontFamily ?? "PoppinsR",
                color: fontColor ?? Colorr.Grey600,
                fontSize: fontSize ?? 14,
                fontWeight: fontWeight ?? FWeight.fW400),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? 10),
                borderSide: BorderSide(color: Colorr.themcolor))),
      ),
    );
  }

  static Future<bool> CheakConnectionInternetButton() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.
      return true;
    } else if (connectivityResult == ConnectivityResult.none) {
      // I am not connected to any network
      return false;
    } else {
      return false;
    }
  }

  static Future<int> CheakConnectionInternet() async {
    final connectivityResult = await (Connectivity().checkConnectivity());
    if (connectivityResult == ConnectivityResult.mobile ||
        connectivityResult == ConnectivityResult.wifi) {
      // I am connected to a mobile network.
      return 1;
    } else if (connectivityResult == ConnectivityResult.none) {
      // I am not connected to any network
      return 2;
    } else {
      return 2;
    }
  }

  static NoInternetImage(BuildContext context) {
    return Center(
        child: Image.asset(
            height: MediaQuery.of(context).size.height / 6,
            "images/NoInternet.webp"));
  }

  static NoDataImage(BuildContext context) {
    return Center(
        child: Image.asset(
            height: MediaQuery.of(context).size.height / 5,
            "images/NoData.webp"));
  }

  static Circularprogress(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(color: Colorr.themcolor),
    );
  }

  static textFieldIOS({
    void Function()? onTap,
    TextEditingController? controller,
    ValueChanged<String>? onChanged,
    double? height,
    double? textHeight,
    double? width,
    int? MaxFont,
    double? paddingLeft,
    int maxLines = 1,
    double? radius,
    double? borderWidth,
    bool readOnly = false,
    double? enabledBorderRadius,
    TextAlignVertical? textAlignVertical,
    double? fontSize,
    BorderSide? borderSide,
    bool? filled,
    bool obscureText = false,
    BoxDecoration? enabledBorder,
    TextAlign textAlign = TextAlign.start,
    TextInputType? keyboardType,
    FontWeight? fontWeight,
    Widget? prefixIcon,
    Widget? suffixIcon,
    String? fontFamily,
    Widget? suffix,
    Widget? prefix,
    required String hintText,
    String? label,
    Color? fontColor,
    Color? borderColor,
    Color? fillColor,
    Color? color,
  }) {
    return Container(
      height: height ?? 40,
      width: width,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colorr.Grey,
          width: borderWidth ?? 0,
        ),
        color: color,
        borderRadius: BorderRadius.circular(5),
      ),
      child: Padding(
        padding: EdgeInsets.all(2),
        child: CupertinoTextField(
          onTap: onTap,
          textAlignVertical: textAlignVertical ?? TextAlignVertical.center,
          obscureText: obscureText,
          style: TextStyle(color: CupertinoColors.black),
          keyboardType: keyboardType ?? TextInputType.text,
          maxLines: maxLines,
          textAlign: textAlign,
          maxLength: MaxFont ?? null,
          controller: controller,
          cursorColor: Colorr.themcolor,
          readOnly: readOnly,
          onChanged: onChanged,
          placeholder: hintText,
          decoration: BoxDecoration(
            color: fillColor,
            border: Border.all(
              color: Colors.transparent,
            ),
          ),
          prefix: prefix,
          suffix: suffix,
          prefixMode: prefix != null
              ? OverlayVisibilityMode.always
              : OverlayVisibilityMode.never,
          suffixMode: suffix != null
              ? OverlayVisibilityMode.always
              : OverlayVisibilityMode.never,

          // padding: EdgeInsets.only(top: 15, bottom: 10, left: 10),
        ),
      ),
    );
  }

  static DateFormatchange(String Time) {
    DateTime originalDate = DateTime.parse(Time);
    String formattedDate = DateFormat("dd-MM-yyyy").format(originalDate);
    return formattedDate;
  }

  static DateFormatchangeapi(String originalDateStr) {
    DateFormat originalFormat = DateFormat('dd-MM-yyyy');
    DateFormat desiredFormat = DateFormat('yyyy-MM-dd');
    DateTime originalDate = originalFormat.parse(originalDateStr);
    String formattedDate = desiredFormat.format(originalDate);
    return formattedDate;
  }

  static textField1(
      {TextEditingController? controller,
      void Function(dynamic)? onChanged,
      double? height,
      double? textHeight,
      double? width,
      double? paddingLeft,
      maxLines,
      double? radius,
      double? borderWidth,
      bool? readOnly,
      double? enabledBorderRadius,
      TextAlignVertical? textAlignVertical,
      double? fontSize,
      var borderSide,
      var filled,
      var obscureText,
      var enabledBorder,
      dynamic textAlign,
      keyboardType,
      fontWeight,
      prefixIcon,
      suffixIcon,
      fontFamily,
      suffix,
      prefix,
      required String hintText,
      var label,
      Color? fontColor,
      Color? borderColor,
      Color? fillColor,
      color}) {
    return Container(
      height: height ?? 40,
      width: width,
      margin: const EdgeInsets.symmetric(vertical: 5, horizontal: 10),
      decoration: BoxDecoration(
        border: Border.all(
          color: borderColor ?? Colorr.Transparent,
          width: borderWidth ?? 0,
        ),
        color: color,
        borderRadius: BorderRadius.circular(0),
      ),
      child: Padding(
        padding: EdgeInsets.only(
          left: paddingLeft ?? 0,
        ),
        child: TextField(
          textAlignVertical: TextAlignVertical.top,
          obscureText: obscureText ?? false,
          style: TextStyle(color: Colorr.Black),
          keyboardType: keyboardType ?? TextInputType.text,
          maxLines: 3,
          textAlign: TextAlign.left,
          controller: controller,
          cursorColor: Colorr.themcolor500,
          readOnly: readOnly ?? false,
          onChanged: onChanged,
          decoration: InputDecoration(
            enabledBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(10),
                borderSide: BorderSide(
                  color: Colorr.themcolor,
                )),
            focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(enabledBorderRadius ?? 10),
                borderSide: enabledBorder ??
                    BorderSide(
                      color: Colorr.themcolor300,
                      width: 2,
                    )),
            filled: filled,
            fillColor: fillColor,
            prefixIcon: prefixIcon,
            suffixIcon: suffixIcon,
            suffix: suffix,
            prefix: prefix,
            hintText: hintText,
            labelText: hintText,
            labelStyle: TextStyle(
                fontFamily: "PoppinsR",
                color: Colorr.themcolor,
                fontSize: 13,
                fontWeight: FWeight.fW400),
            hintStyle: TextStyle(
                height: textHeight ?? 3.20,
                fontFamily: fontFamily ?? "PoppinsR",
                color: fontColor ?? Colorr.Grey600,
                fontSize: fontSize ?? 14,
                fontWeight: fontWeight ?? FWeight.fW400),
            border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(radius ?? 10),
                borderSide: BorderSide(color: Colorr.themcolor)),
          ),
        ),
      ),
    );
  }

  static container(
      {double? height,
      double? width,
      double? radius,
      borderWidth,
      VoidCallback? onTap,
      dynamic child,
      Color? btnColor,
      shadowColor,
      borderColor}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: height ?? 50,
        width: width,
        decoration: BoxDecoration(
            color: btnColor ?? Colorr.White,
            borderRadius: BorderRadius.circular(radius ?? 50),
            border: Border.all(
                color: borderColor ?? Colorr.themcolor300,
                width: borderWidth ?? 1),
            boxShadow: [
              BoxShadow(
                  color: shadowColor ?? Colorr.themcolor200,
                  blurRadius: 5,
                  spreadRadius: 0.5,
                  offset: const Offset(2, 3))
            ]),
        child: child,
      ),
    );
  }

  static poppinsText(
      String text, Color color, double fontSize, FontWeight fontWeight) {
    return Text(
      text,
      textAlign: TextAlign.center,
      style: TextStyle(
        color: color,
        fontSize: fontSize,
        fontWeight: fontWeight,
        fontFamily: 'Poppins',
      ),
    );
  }

  static height(double height) {
    return SizedBox(
      height: height,
    );
  }

  static width(double width) {
    return SizedBox(
      width: width,
    );
  }

  static themeColorPoppinsText(String text) {
    return CustomWidgets.poppinsText(text, Colorr.themcolor, 15, FWeight.fW600);
  }

  static themePoppinsText(String text) {
    return CustomWidgets.poppinsText(text, Colorr.themcolor, 17, FWeight.fW600);
  }

  static themeColor600PoppinsText(String text) {
    return CustomWidgets.poppinsText(
        text, Colorr.themcolor600, 14, FWeight.fW400);
  }

  static paddingWithDivider() {
    return Padding(
      padding: const EdgeInsets.only(top: 10, bottom: 5),
      child: Divider(
        color: Colorr.themcolor,
        thickness: 1,
      ),
    );
  }

  static divider() {
    return Padding(
      padding: const EdgeInsets.only(top: 5, bottom: 6),
      child: Divider(
        color: Colorr.themcolor,
        thickness: 1,
      ),
    );
  }

  static themeColor500Divider() {
    return Padding(
      padding: const EdgeInsets.only(left: 50, right: 5),
      child: Divider(
        color: Colorr.themcolor200,
        thickness: 1.5,
      ),
    );
  }

  static appbar(
      {required String title,
      required List<Widget> action,
      required BuildContext context,
      required void Function() onTap}) {
    return AppBar(
      backgroundColor: Colorr.themcolor,
      centerTitle: true,
      leading: IconButton(
        splashRadius: 18,
        onPressed: onTap,
        icon: const Icon(Icons.arrow_back_ios_new_outlined),
      ),
      elevation: 0,
      title: poppinsText(title, Colorr.White, 14.5, FWeight.fW600),
      actions: action,
    );
  }

  static appbarIOS({
    required String title,
    required List<Widget> action,
    required BuildContext context,
    required void Function() onTap,
  }) {
    return CupertinoNavigationBar(padding: EdgeInsetsDirectional.zero,
      backgroundColor: Colorr.themcolor,
      middle: Text(
        title,
        style: TextStyle(color: Colorr.White),
      ),
      leading: CupertinoButton(
        padding: EdgeInsets.zero,
        onPressed: onTap,
        child: Icon(
          Icons.arrow_back_ios_new_rounded,
          color: Colorr.White,
          size: 24,
        ),
      ),
      trailing: Row(
        mainAxisSize: MainAxisSize.min,
        children: action,
      ),
    );
  }

  static textFieldWithBoxShadow(
      {required String hintText,
      required bool obscureText,
      required BuildContext context,
      Widget? suffixIcon,
  void Function(String)? Onchanged,
      FocusNode? focusNode,
      required TextEditingController controller}) {
    return Container(
      height: 50,
      width: double.infinity,
      alignment: Alignment.center,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 7),
      padding: const EdgeInsets.only(left: 25),
      decoration: BoxDecoration(
        color: Colorr.White,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          // BoxShadow(
          //     // color: Colorr.themcolor200,
          //     // blurRadius: 1,
          //     // spreadRadius: 0.1,
          //     // offset: const Offset(1, 1)
          // )
        ],
      ),
      child: GestureDetector(
        behavior: HitTestBehavior.opaque,
        onTap: () {
          Focus.of(context).unfocus();
        },
        child: TextFormField(
          style: TextStyle(color: Colorr.themcolor300, fontSize: 18),
          textInputAction: TextInputAction.done,
          focusNode: focusNode,
          onChanged: Onchanged,
          obscureText: obscureText,
          controller: controller,
          decoration: InputDecoration(
            border: InputBorder.none,
            hintText: hintText,
            suffixIcon: suffixIcon,
            hintStyle: TextStyle(color: Colorr.themcolor200, fontSize: 15),
          ),
        ),
      ),
    );
  }

  static textFieldWithBoxShadowIOS({
    required String hintText,
    required bool obscureText,
    Widget? suffixIcon,
    required TextEditingController controller,
  }) {
    return Container(
      height: 50,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 20, vertical: 12),
      decoration: BoxDecoration(
        color: Colorr.White,
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
              color: Colorr.themcolor200,
              blurRadius: 2,
              spreadRadius: 0.2,
              offset: const Offset(1, 2)),
        ],
      ),
      child: CupertinoTextField(
        style: TextStyle(color: Colorr.themcolor300, fontSize: 18),
        padding: const EdgeInsets.only(left: 25),
        textInputAction: TextInputAction.done,
        obscureText: obscureText,
        controller: controller,
        placeholder: hintText,
        placeholderStyle: TextStyle(color: Colorr.themcolor200, fontSize: 15),
        decoration: BoxDecoration(
          border: Border.all(color: Colors.transparent),
        ),
        suffix: suffixIcon,
      ),
    );
  }

  static SelectDroupDown({
    required void Function(int) onSelectedItemChanged,
    required BuildContext context,
    required List<String> items,
  }) {
    return showCupertinoModalPopup(
        context: context,
        builder: (_) => SizedBox(
              height: MediaQuery.of(context).size.height / 4,
              child: CupertinoPicker(
                backgroundColor: Colors.white,
                itemExtent: 30,
                scrollController: FixedExtentScrollController(initialItem: 1),
                children: items.map((text) => Text(text)).toList(),
                onSelectedItemChanged: onSelectedItemChanged,
              ),
            ));
  }

  static aarowCupertinobutton() {
    return CupertinoButton(
      padding: EdgeInsets.zero,
      onPressed: () {},
      child: Icon(Icons.arrow_drop_down, color: Colorr.Black),
    );
  }

  static Future<String> selectDate(
      {required BuildContext context,
      required TextEditingController controller,
      bool? Future}) async {
    DateTime selectedDate = DateTime.now();
    DateFormat dateFormat = DateFormat('dd-MM-yyyy');
    DateTime dateTime = DateTime.now();
    if (controller.text.isNotEmpty) {
      dateTime = dateFormat.parse(controller.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: controller.text.isNotEmpty ? dateTime : selectedDate,
      firstDate: DateTime(2015, 8),
      lastDate: Future != null ? selectedDate : DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: ColorScheme.light(
              primary: Colorr.themcolor, // <-- SEE HERE
              onPrimary: Colorr.White, // <-- SEE HERE
              onSurface: Colorr.themcolor, // <-- SEE HERE
            ),
            textButtonTheme: TextButtonThemeData(
              style: TextButton.styleFrom(
                primary: Colorr.themcolor, // button text color
              ),
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null && picked != selectedDate) {
      controller.text = DateFormat('dd-MM-yyyy').format(picked);
    }
    return controller.text;
  }

  static Future<String> selectDateIOS(
      {required BuildContext context,
      required TextEditingController controller,
      bool? Future}) async {
    DateTime selectedDate = DateTime.now();
    final DateTime? picked = await showCupertinoModalPopup<DateTime>(
      context: context,
      builder: (BuildContext context) {
        return Container(
          height: 200,
          color: Colorr.White,
          child: CupertinoDatePicker(
            mode: CupertinoDatePickerMode.date,
            initialDateTime: selectedDate,
            minimumDate: DateTime(2015, 8),
            maximumDate: Future != null ? selectedDate : DateTime(2101),
            onDateTimeChanged: (DateTime newDate) {
              controller.text = DateFormat('dd-MM-yyyy').format(newDate);
            },
          ),
        );
      },
    );
    return controller.text;
  }

  static swipeButton(
    Color color,
    String text,
    void Function() onSwipeEnd,
  ) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        boxShadow: [
          BoxShadow(
              color: Colorr.themcolor100,
              blurRadius: 1,
              spreadRadius: 0.1,
              offset: const Offset(1, 2))
        ],
      ),
      child: SwipeButton.expand(
        trackPadding:
            const EdgeInsets.only(left: 1, right: 1, top: 1, bottom: 1),
        height: 40,
        thumb: Center(
          child: Text(
            text,
            style: TextStyle(
                fontFamily: "Poppins",
                color: Colorr.White,
                fontSize: 14,
                fontWeight: FWeight.fW600),
          ),
        ),
        activeThumbColor: Colorr.themcolor,
        activeTrackColor: color,
        onSwipeEnd: onSwipeEnd,
        child: Padding(
          padding: const EdgeInsets.only(right: 10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                ">",
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colorr.themcolor100,
                    fontSize: 22,
                    fontWeight: FWeight.fW200),
              ),
              Text(
                ">",
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colorr.themcolor200,
                    fontSize: 24,
                    fontWeight: FWeight.fW400),
              ),
              Text(
                ">",
                style: TextStyle(
                  fontFamily: "Poppins",
                  color: Colorr.themcolor300,
                  fontSize: 27,
                ),
              ),
              Text(
                ">",
                style: TextStyle(
                    fontFamily: "Poppins",
                    color: Colorr.themcolor,
                    fontSize: 27,
                    fontWeight: FWeight.fW800),
              ),
            ],
          ),
        ),
      ),
    );
  }

  static showToast(BuildContext context, String message, bool done,
      [MaterialColor color = Colors.red]) {
    Toast.show(context, "$message", done);
  }

  static searchBar({required TextEditingController controller}) {
    return Container(
      height: 45,
      width: double.infinity,
      margin: const EdgeInsets.symmetric(horizontal: 15, vertical: 10),
      padding: const EdgeInsets.only(
        left: 8,
      ),
      decoration: BoxDecoration(
        color: Colorr.themcolor50,
        boxShadow: [
          BoxShadow(
            color: Colorr.themcolor200, // Change color of the shadow
            blurRadius: 5,
            spreadRadius: 0.5,
            offset: const Offset(3.0, 4.0),
          )
        ],
        borderRadius: BorderRadius.circular(60),
        border: Border.all(
          width: 2,
          color: Colorr.themcolor500,
        ),
      ),
      child: TextField(
        controller: controller,
        style: TextStyle(
            fontFamily: "PoppinsR",
            color: Colorr.themcolor500,
            fontSize: 14,
            fontWeight: FWeight.fW400),
        decoration: InputDecoration(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 1, horizontal: 15),
          border: const OutlineInputBorder(borderSide: BorderSide.none),
          hintText: "Search Here",
          suffixIcon: IconButton(
              splashRadius: 18,
              onPressed: () {
                controller.clear();
              },
              icon: Icon(
                Icons.close,
                color: Colorr.themcolor400,
              )),
          hintStyle: TextStyle(
              fontFamily: "PoppinsR",
              color: Colorr.themcolor600,
              fontSize: 14,
              fontWeight: FWeight.fW400),
        ),
      ),
    );
  }

  static DateIcon() {
    return Padding(
      padding: EdgeInsets.only(top: 10, bottom: 10, right: 13, left: 13),
      child: Image(
          fit: BoxFit.fill,
          height: 5,
          width: 5,
          image: AssetImage("images/Date.webp")),
    );
  }

  static DateIconIOS() {
    return Padding(
      padding: EdgeInsets.only(top: 5, bottom: 5, right: 13, left: 13),
      child: Image(
          fit: BoxFit.fill,
          height: 25,
          width: 20,
          image: AssetImage("images/Date.webp")),
    );
  }
}
