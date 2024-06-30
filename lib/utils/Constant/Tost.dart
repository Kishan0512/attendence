import 'dart:async';

import 'package:flutter/material.dart';

import 'Colors.dart';

class Toast {
  static void show(BuildContext context, String message,bool done) {
    var size= calcTextSize(message, TextStyle(fontSize: 12));
    final theme = Theme.of(context);
    final text = Material(
      color: Colors.transparent,
      child:  Container(
        height: MediaQuery.of(context).size.height/40,
        width: size.width+30,
        child: Row(mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              done ?
              Icon(Icons.check_circle,color: Colors.green,size: 20): Icon(Icons.error_outline_rounded,color: Colors.red,size: 20),
              Text(
                message,
                style: TextStyle(color: Colors.white, fontSize: 12.0),
              )
            ]),
      ),
    );

    final container = Container(
      padding: EdgeInsets.symmetric(horizontal: 12.0, vertical: 12.0),
      margin: EdgeInsets.only(bottom: 50),
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(50),
        color: Color(0xffb6b6b6),
      ),
      child: text,
    );

    final positioned = Positioned.fill(
      child: Align(
        alignment: Alignment.bottomCenter,
        child: container,
      ),
    );

    final overlayEntry =
    OverlayEntry(builder: (context) => Stack(children: [positioned]));
    Overlay.of(context).insert(overlayEntry);

    Timer(Duration(milliseconds: 2500), () {
      overlayEntry.remove();
    });
  }
 static Size calcTextSize(String text, TextStyle style) {
    final TextPainter textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      textDirection: TextDirection.ltr,
      textScaleFactor: WidgetsBinding.instance.window.textScaleFactor,
    )..layout();
    return textPainter.size;
  }
}
