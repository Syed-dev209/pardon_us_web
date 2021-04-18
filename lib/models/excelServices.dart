import 'package:excel/excel.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:file_picker_cross/file_picker_cross.dart';
import 'dart:html' as html;
import 'package:path/path.dart';
import 'dart:convert';

class ExcelSheet {
  var excel, bytes;
  String classCode;
  String fileName;
  FilePickerCross myFile;
  createWebExcel() async {
    myFile = await FilePickerCross.importFromStorage(
        type: FileTypeCross
            .custom, // Available: `any`, `audio`, `image`, `video`, `custom`. Note: not available using FDE
        fileExtension:
            'xlsx' // Only if FileTypeCross.custom . May be any file extension like `dot`, `ppt,pptx,odp`
        );
  }

  Future<String> createNewExcel(String classCode) async {
    // await createWebExcel();
    fileName = classCode + DateTime.now().toString();
    excel = Excel.createExcel();
    List<String> dataList = [
      "Name",
      "Email",
      "Date Time of joining and leaving",
      "Action"
    ];
    excel.insertRowIterables(
        'Sheet1', dataList, 0); //row counting starts from 0
    for (var table in excel.tables.keys) {
      print(table);
      print(excel.tables[table].maxCols);
      print(excel.tables[table].maxRows);
      for (var row in excel.tables[table].rows) {
        print("$row");
      }
    }
    // excel.encode().then(
    //   (onValue) async {
    //     // File(join("/Users/DW/Desktop/$fileName.xlsx"))
    //     //   ..createSync(recursive: true)
    //     //   ..writeAsBytesSync(onValue);
    //     print(myFile.path);
    //     myFile.saveToPath(path: "C:\\${myFile.fileName}");
    //   },
    // );
    //myFile.exportToStorage(subject: "C:\\${myFile.fileName}");

    return fileName;
  }

  insertRow({String name, List<String> dataList, int index}) {
    excel.insertRowIterables('Sheet1', dataList, index);
  }

  Future<html.File> saveFile() async {
    html.File file;
    excel.encode().then((onValue) {
      // print(myFile.path);
      file = html.File(onValue, fileName);
      print('printing file ==============');
      //final bytes = utf8.encode();
      bytes = onValue;
      final blob = html.Blob([onValue]);
      final url = html.Url.createObjectUrlFromBlob(blob);
      final anchor = html.document.createElement('a') as html.AnchorElement
        ..href = url
        ..style.display = 'none'
        ..download = '$fileName.xlsx';
      html.document.body.children.add(anchor);
// download
      anchor.click();
// cleanup
      html.document.body.children.remove(anchor);
      html.Url.revokeObjectUrl(url);
    });

    // bytes = File("/storage/emulated/0/Pardon Us/$name.xlsx").readAsBytes();
    // return "/storage/emulated/0/Pardon Us/$name.xlsx";
    return file;
  }

  dynamic getBytes() {
    return bytes;
  }
}
