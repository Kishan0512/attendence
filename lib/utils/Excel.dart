import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:syncfusion_flutter_xlsio/xlsio.dart';

import 'Constant/LocalCustomWidgets.dart';

class ExcelSheet {
  static Future generateExcelFromJson(
      BuildContext context, List<dynamic> jsonData, String FileName) async {
    List<String> keys = [];

    for (int i = 0; i < 1; i++) {
      Map<String, dynamic> e = jsonData[i];
      if (keys.isEmpty) {
        keys = e.keys.toList();
      }
    }
    ;
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    final directory = Directory("storage/emulated/0/Download");
    if (FileName == "AttendanceReport") {
      sheet.getRangeByIndex(1, 1).setText(keys[2]);
      sheet.getRangeByIndex(1, 2).setText(keys[3]);
      sheet.getRangeByIndex(1, 3).setText(keys[4]);
      sheet.getRangeByIndex(1, 4).setText(keys[6]);
      sheet.getRangeByIndex(1, 5).setText(keys[5]);
      sheet.getRangeByIndex(1, 6).setText(keys[0]);
      sheet.getRangeByIndex(1, 7).setText(keys[1]);
      sheet.getRangeByIndex(1, 8).setText(keys[7]);

      for (var row = 0; row < jsonData.length; row++) {
        final dataRow = jsonData[row];

        sheet.getRangeByIndex(row + 2, 1).setText(dataRow["companyId"]);
        sheet.getRangeByIndex(row + 2, 2).setText(dataRow["employeeId"]["_id"]);
        sheet
            .getRangeByIndex(row + 2, 3)
            .setText(dataRow["employeeId"]["FirstName"]);
        sheet.getRangeByIndex(row + 2, 4).setText(dataRow["date"]);
        sheet.getRangeByIndex(row + 2, 5).setText(dataRow["day"]);
        sheet.getRangeByIndex(row + 2, 6).setText(dataRow["fromTime"] != null
            ? DateFormat('hh:mm a')
                .format(DateTime.parse(dataRow["fromTime"]).toLocal())
            : "");
        sheet.getRangeByIndex(row + 2, 7).setText(dataRow["toTime"] != null
            ? DateFormat('hh:mm a')
                .format(DateTime.parse(dataRow["toTime"]).toLocal())
            : "");
        sheet.getRangeByIndex(row + 2, 8).setText(dataRow["workingHours"]);
        sheet.autoFitRow(row + 2);
        sheet.autoFitColumn(1);
        sheet.autoFitColumn(2);
        sheet.autoFitColumn(3);
        sheet.autoFitColumn(4);
        sheet.autoFitColumn(5);
        sheet.autoFitColumn(6);
        sheet.autoFitColumn(7);
        sheet.autoFitColumn(8);
      }
      final filePath = '${directory.path}/Attendance_report.xlsx';
      final file = File(filePath);
      file.writeAsBytesSync(workbook.saveAsStream());
    } else if (FileName == "DailyReport") {
      for (var col = 0; col < jsonData[0].length; col++) {
        sheet.getRangeByIndex(1, col + 1).setText(keys[col]);
      }
      for (var row = 0; row < jsonData.length; row++) {
        final dataRow = jsonData[row];
        for (var col = 0; col < keys.length; col++) {
          sheet.getRangeByIndex(row + 2, col + 1).setText(dataRow[keys[col]]);
          sheet.autoFitColumn(col + 1);
          sheet.autoFitRow(row + 2);
        }
      }
      final filePath = '${directory.path}/DailyReport.xlsx';
      final file = File(filePath);
      file.writeAsBytesSync(workbook.saveAsStream());
    } else {
      sheet.getRangeByIndex(1, 1).setText("Name");
      sheet.getRangeByIndex(1, 2).setText("EmployeeID");
      sheet.getRangeByIndex(1, 3).setText("Leave Type");
      sheet.getRangeByIndex(1, 4).setText("From Date");
      sheet.getRangeByIndex(1, 5).setText("To Date");
      sheet.getRangeByIndex(1, 6).setText("No Of day");
      sheet.getRangeByIndex(1, 7).setText("Reason");
      for (var row = 0; row < jsonData.length; row++) {
        final dataRow = jsonData[row];
        sheet
            .getRangeByIndex(row + 2, 1)
            .setText(dataRow['EmployeeId']['FirstName']);
        sheet.getRangeByIndex(row + 2, 2).setText(dataRow['EmployeeId']['_id']);
        sheet.getRangeByIndex(row + 2, 3).setText(dataRow['leaveId']['name']);
        sheet.getRangeByIndex(row + 2, 4).setText(
            CustomWidgets.DateFormatchange(dataRow['fromDate'].toString()));
        sheet.getRangeByIndex(row + 2, 5).setText(
            CustomWidgets.DateFormatchange(dataRow['toDate'].toString()));
        sheet.getRangeByIndex(row + 2, 6).setText(dataRow['day']!.toString());
        sheet.getRangeByIndex(row + 2, 7).setText(dataRow['reason']!);
        sheet.autoFitColumn(1);
        sheet.autoFitColumn(2);
        sheet.autoFitColumn(3);
        sheet.autoFitColumn(4);
        sheet.autoFitColumn(5);
        sheet.autoFitColumn(6);
        sheet.autoFitColumn(7);
      }
      final filePath = '${directory.path}/LeaveReport.xlsx';
      final file = File(filePath);
      file.writeAsBytesSync(workbook.saveAsStream());
    }
    CustomWidgets.showToast(context, "Excel file generated successfully", true);
  }

  ///todo MonthlyReport Excel
  ///todo pass data in dynamic list
  ///todo to generate Excel

  static Future<void> MonthlyReport(
      {required BuildContext context,
      required List<dynamic> Month_Data,
      required List<dynamic> Employee_Data,
      required String Year,
      required String Months}) async {
    List<String> name = [
      "A",
      "B",
      "C",
      "D",
      "E",
      "F",
      "G",
      "H",
      "I",
      "J",
      "K",
      "L",
      "M",
      "N",
      "O",
      "P",
      "Q",
      "R",
      "S",
      "T",
      "U",
      "V",
      "W",
      "X",
      "Y",
      "Z",
      "AA",
      "AB",
      "AC",
      "AD",
      "AE",
      "AF",
      "AG",
      "AH",
      "AI",
      "AJ",
      "AK",
      "AL",
      "AM",
      "AN",
      "AO",
      "AP",
      "AQ",
      "AR",
      "AS",
      "AT",
      "AU",
      "AV",
      "AW",
      "AX",
      "AY",
      "AZ",
    ];
    final Workbook workbook = Workbook();
    final Worksheet sheet = workbook.worksheets[0];

    // todo Header style
    final Style HeaderStyle = workbook.styles.add("Header");
    HeaderStyle.backColor = "#4CAF50";
    HeaderStyle.fontName = "Times New Roman";
    HeaderStyle.fontSize = 20;
    HeaderStyle.vAlign = VAlignType.center;
    HeaderStyle.hAlign = HAlignType.center;
    // todo month and year style
    final Style Month = workbook.styles.add("Month");
    Month.backColor = "#FFA100";
    Month.fontName = "Times New Roman";
    Month.fontSize = 16;
    Month.vAlign = VAlignType.center;
    Month.hAlign = HAlignType.center;
    // Todo text Rotation
    final Style Final = workbook.styles.add("Final");
    Final.rotation = 90;
    Final.fontSize = 8;
    Final.vAlign = VAlignType.center;
    Final.hAlign = HAlignType.center;
    // todo normal day editing
    final Style Normal = workbook.styles.add("Normal");
    final Style red = workbook.styles.add("red");
    final Style green = workbook.styles.add("green");
    final Style bluee = workbook.styles.add("blue");
    final Style Yello = workbook.styles.add("Yello");
    final Style purple = workbook.styles.add("pup");
    Normal.hAlign = HAlignType.center;
    red.hAlign = HAlignType.center;
    green.hAlign = HAlignType.center;
    Yello.hAlign = HAlignType.center;
    purple.hAlign = HAlignType.center;
    bluee.hAlign = HAlignType.center;
    red.fontColor = "#FF1200";
    red..borders.all.lineStyle = LineStyle.thin;
    green..borders.all.lineStyle = LineStyle.thin;
    green.fontColor = "#4CAF50";
    purple.fontColor= "#9C27B0";
    purple..borders.all.lineStyle = LineStyle.thin;
    bluee..borders.all.lineStyle = LineStyle.thin;
    bluee.fontColor = "#2196F3";
    Yello..borders.all.lineStyle = LineStyle.thin;
    Yello.fontColor = "#795548";



    sheet.getRangeByName('A1:AM1')
      ..merge()
      ..setText("SnapiTech")
      ..cellStyle = HeaderStyle;
    sheet.getRangeByName('AI2:AM2')
      ..merge()
      ..setText(DateFormat('MMM-yyyy').format(DateTime.parse(DateFormat('MM-yyyy').parse("$Months-$Year").toString())))
      ..cellStyle = Month;
    sheet.getRangeByName('A3:C3')
      ..merge()
      ..setText("Employee Name")
      ..cellStyle = Month;
    sheet.getRangeByName('AI3')
      ..setText("Present")
      ..cellStyle = Final
      ..columnWidth = 3;
    sheet.getRangeByName('AJ3')
      ..setText("Absent")
      ..cellStyle = Final
      ..columnWidth = 3;
    sheet.getRangeByName('AK3')
      ..setText("Late")
      ..cellStyle = Final
      ..columnWidth = 3;
    sheet.getRangeByName('AL3')
      ..setText("Leave")
      ..cellStyle = Final
      ..columnWidth = 3;
    sheet.getRangeByName('AM3')
      ..setText("Percentage")
      ..cellStyle = Final
      ..columnWidth = 3;
    for (int i = 0; i <= 30; i++) {
      sheet.getRangeByName('${name[i + 3]}2:${name[i + 3]}3')
        ..merge()
        ..setNumber((i + 1))
        ..cellStyle = Normal
        ..columnWidth = 3;
    }
    for (int i = 0; i < Employee_Data.length; i++) {
      sheet.getRangeByName('A${i + 4}:C${i + 4}')
        ..merge()
        ..setText(Employee_Data[i]["Name"])
        ..cellStyle = Normal;
      for (int j = 1; j <= DateTime(int.parse(Year), int.parse(Months) + 1, 0).day; j++) {
        // List s1 = Month_Data[j]['$Year-$Months-${j.toString().padLeft(2, "0")}'];

        String s = Month_Data[j-1]['Data'].firstWhere((e) => e["employeeId"].toString() == Employee_Data[i]['EmpID'].toString(), orElse: () => {'status': 'A'})['Status'].toString();

        sheet.getRangeByName('${name[j + 2]}${i + 4}')
          ..setText((s))
          ..cellStyle = s == "A" ? red : s == "P" ? green : s=="L"? bluee: s=="LA"? Yello: purple
          ..columnWidth = 3;
      }
    }
    for (int i = 0; i < Employee_Data.length; i++) {
      sheet.getRangeByName("AI${i + 4}")
        ..setFormula('=COUNTIF(D${i + 4}:AH${i + 4}, "P")')
        ..cellStyle = Normal
        ..columnWidth = 3;
      sheet.getRangeByName("AJ${i + 4}")
        ..setFormula('=COUNTIF(D${i + 4}:AH${i + 4}, "A")')
        ..cellStyle = Normal
        ..columnWidth = 3;
      sheet.getRangeByName("AK${i + 4}")
        ..setFormula('=COUNTIF(D${i + 4}:AH${i + 4}, "LA")')
        ..cellStyle = Normal
        ..columnWidth = 3;
      sheet.getRangeByName("AL${i + 4}")
        ..setFormula('=COUNTIF(D${i + 4}:AH${i + 4}, "L")')
        ..cellStyle = Normal
        ..columnWidth = 3;
      sheet.getRangeByName("AM${i + 4}")
        ..setFormula('=TEXT(AI${i + 4}/SUM(AI${i + 4}:AL${i + 4}), "0.0%")')
        ..cellStyle = Normal
        ..columnWidth = 7;
    }

    final directory = Directory("storage/emulated/0/Download");
    final filePath = '${directory.path}/MonthlyReport.xlsx';
    final file = File(filePath);
    file.writeAsBytesSync(workbook.saveAsStream());
    CustomWidgets.showToast(context, "Excel file generated successfully", true);
  }
}
