import 'dart:html' as html;
import 'dart:io' as io;
import 'dart:typed_data';
import 'package:path/path.dart';
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:flutter_downloader/flutter_downloader.dart';
import 'package:file_picker/file_picker.dart';

class Directory {
  void createFolder() async {
    if (await Permission.storage
        .request()
        .isGranted) {
      //String directory = (await getExternalStorageDirectory()).path;
      if (await io.Directory("/storage/emulated/0/Pardon Us").exists() !=
          true) {
        // print(directory);
        print("Directory not exist");
        new io.Directory("/storage/emulated/0/Pardon Us")
            .create(recursive: true);
      } else {
        print("Directory exist");
      }
    }
  }

  Future<bool> download(String link) async {
    if (await Permission.storage
        .request()
        .isGranted) {
      //var dir = await getExternalStorageDirectory();
      final taskId = await FlutterDownloader.enqueue(
        url: link,
        savedDir: '/storage/emulated/0/Pardon Us',
        // savedDir: dir.path,
        showNotification: true,
        // show download progress in status bar (for Android)
        openFileFromNotification:
        true, // click on notification to open downloaded file (for Android)
      );
      return true;
    } else {
      return false;
    }
  }

  void downloadWeb(String url){
    html.window.open(url, 'new tab');
  }

  Future<PlatformFile> pickFiles() async {
    PlatformFile _file;
    FilePickerResult _result = await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['pdf', 'doc', 'docx'],
    );
    if (_result != null) {
      print(_result.files.single.path);
      _file = _result.files.first;
      html.File(_file.bytes,_file.name);
      return _file;
    } else {
      return _file;
    }
  }

  Future<PlatformFile> chooseImage()async{
    PlatformFile _image;
    FilePickerResult _result= await FilePicker.platform.pickFiles(
      type: FileType.custom,
      allowedExtensions: ['png','jpeg','jpg']
    );
    if (_result != null) {
      _image = _result.files.first;
      return _image;
    } else {
      return _image;
    }
  }

  html.File startFilePicker()  {
    html.File files;
    html.InputElement uploadInput = html.FileUploadInputElement();
    uploadInput.click();
    uploadInput.onChange.listen((e) {
      // read file content as dataURL
      files = uploadInput.files.first;
      final reader= html.FileReader();
      reader.readAsDataUrl(files);
      reader.onLoad.listen((event) {
        print('selected ${files.name}');
        print('${files.type}');
      });
    });
    return files;
  }
}
