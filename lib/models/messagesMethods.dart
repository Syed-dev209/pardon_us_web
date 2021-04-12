import 'dart:io';
import 'dart:html' as html;
import 'package:file_picker/file_picker.dart';
import 'package:image_picker/image_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_storage/firebase_storage.dart' as firebase_storage;
import 'package:firebase/firebase.dart' as fb;

class MessengerMethods {
  FirebaseFirestore _firestore = FirebaseFirestore.instance;
  String uploadedImgUrl;
  String uploadedVideoUrl;

  void sendTextMsg(
      {String senderName,
      String classCode,
      String textMessage,
      String type = 'text'}) async {
    int time = DateTime.now().millisecondsSinceEpoch;
    _firestore
        .collection('messages')
        .doc(classCode)
        .collection('classMessage')
        .doc()
        .set({
      'createdAt': time,
      'sender': senderName,
      'text': textMessage,
      'type': type
    });
  }

  // Future<String> _uploadExerciseVideo(File video) async {
  //   String url = '';
  //   firebase_storage.StorageReference storageReference = firebase_storage
  //       .FirebaseStorage.instance
  //       .ref('exerciseVideos/${Path.basename(video.path)}');
  //   await storageReference.putFile(video);
  //   url = await storageReference.getDownloadURL();
  //   return url;
  // }

  void sendImage(File _image, String senderName, String classCode) async {
    firebase_storage.StorageReference storageReference = firebase_storage
        .FirebaseStorage.instance
        .ref()
        .child('messenger/${Path.basename(_image.path)}');
    firebase_storage.StorageDataUploadTask uploadTask =
        storageReference.putFile(_image);
    firebase_storage.UploadTaskSnapshot cuyz =
        await uploadTask.future.whenComplete(() => print('upload complete'));

    print('File Uploaded');
    //uploadedImgUrl = await cuyz.ref.getDownloadURL();
    uploadedImgUrl = cuyz.downloadUrl.toString();
    print('Image URl :- $uploadedImgUrl');
    sendTextMsg(
        senderName: senderName,
        classCode: classCode,
        textMessage: uploadedImgUrl,
        type: 'image');
  }

  void sendImageWeb(
      PlatformFile _image, String senderName, String classCode) async {
    // StorageReference storageReference = FirebaseStorage.instance
    //     .ref()
    //     .child('messenger/${Path.basename(_image.path)}');
    // StorageUploadTask uploadTask = storageReference.putFile(_image);
    // StorageTaskSnapshot cuyz= await uploadTask.onComplete;
    html.File htmlFile = html.File(_image.bytes, _image.name);
    String ref = 'messenger';
    fb.Storage storage = fb.storage();
    fb.StorageReference storageReference = storage
        .ref('$ref/')
        .child('${DateTime.now().toString() + htmlFile.name}');
    fb.UploadTaskSnapshot uploadTaskSnapshot =
        await storageReference.put(_image.bytes).future;
    Uri videoUri = await uploadTaskSnapshot.ref.getDownloadURL();
    print('File Uploaded');
    uploadedVideoUrl = videoUri.toString();
    print('Image URl :- $uploadedVideoUrl');
    sendTextMsg(
        senderName: senderName,
        classCode: classCode,
        textMessage: uploadedVideoUrl,
        type: 'image');
  }

  Future<File> chooseVideo() async {
    final picker = ImagePicker();
    final pickedFile = await ImagePicker.pickVideo(source: ImageSource.gallery);
    return File(pickedFile.path);
  }

  Future<PlatformFile> chooseVideoWeb() async {
    PlatformFile _image;
    FilePickerResult _result = await FilePicker.platform
        .pickFiles(type: FileType.custom, allowedExtensions: ['mp4']);
    if (_result != null) {
      _image = _result.files.first;
      return _image;
    } else {
      return _image;
    }
  }

  // Future<bool> sendVideo(
  //     File _video, String senderName, String classCode) async {
  //   StorageReference storageReference = FirebaseStorage.instance
  //       .ref()
  //       .child('messengerVideos/${Path.basename(_video.path)}');
  //   StorageUploadTask uploadTask = storageReference.putFile(_video);
  //   StorageTaskSnapshot cuyz = await uploadTask.onComplete;
  //   print('File Uploaded');
  //   uploadedVideoUrl = await cuyz.ref.getDownloadURL();
  //   print('Video URl :- $uploadedVideoUrl');
  //   sendTextMsg(
  //       senderName: senderName,
  //       classCode: classCode,
  //       textMessage: uploadedVideoUrl,
  //       type: 'video');
  //   return true;
  // }

  Future<String> sendVideoWeb(
      PlatformFile _video, String senderName, String classCode) async {
    html.File htmlFile = html.File(_video.bytes, _video.name);
    String ref = 'messengerVideos';
    fb.Storage storage = fb.storage();
    fb.StorageReference storageReference = storage
        .ref('$ref/')
        .child('${DateTime.now().toString() + htmlFile.name}');
    fb.UploadTaskSnapshot uploadTaskSnapshot =
        await storageReference.put(_video.bytes).future;
    Uri videoUri = await uploadTaskSnapshot.ref.getDownloadURL();
    print('File Uploaded');
    uploadedVideoUrl = videoUri.toString();
    print('Video URl :- $uploadedVideoUrl');
    sendTextMsg(
        senderName: senderName,
        classCode: classCode,
        textMessage: uploadedVideoUrl,
        type: 'video');
    return uploadedVideoUrl;
  }
}
