import 'dart:io' as io;
import 'dart:html' as html;
import 'package:firebase_storage/firebase_storage.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path/path.dart' as Path;
import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase/firebase.dart' as fb;

class FilesUpload {
  FirebaseFirestore firestore = FirebaseFirestore.instance;

  Future<bool> uploadDetails(String quizTitle, String time, String date,
      String fileUrl, String classCode) async {
    firestore.collection('quizes').doc(classCode).collection('quiz').doc().set({
      'title': quizTitle,
      'date': date.toString(),
      'time': time,
      'imageUrl': fileUrl,
      'type': 'file'
    });
    return true;
  }

  Future<bool> submitStudentAssignment(
      {String name,
      PlatformFile assFile,
      String classCode,
      String assDocId}) async {
    try {
      String fileUrl =
          await uploadFileWeb(assFile, classCode, 'assignmentFiles');
      await firestore
          .collection('assignments')
          .doc(classCode)
          .collection('assignment')
          .doc(assDocId)
          .collection('attemptedBy')
          .doc()
          .set({
        'name': name,
        'dateTime': DateTime.now().toString(),
        'fileUrl': fileUrl,
        'marksObtained': '0'
      });
      return true;
    } catch (e) {
      return false;
    }
  }

  Future<bool> uploadAssignmentDetails(String assignmentTitle, String time,
      String date, String fileUrl, String classCode) async {
    firestore
        .collection('assignments')
        .doc(classCode)
        .collection('assignment')
        .doc()
        .set({
      'title': assignmentTitle,
      'date': date.toString(),
      'time': time,
      'imageUrl': fileUrl,
      'type': 'file'
    });
    return true;
  }

  Future<bool> gradeStudentAssignment(
      {String classCode,
      String marks,
      String assDocId,
      String stdDocId}) async {
    try {
      await firestore
          .collection('assignments')
          .doc(classCode)
          .collection('assignment')
          .doc(assDocId)
          .collection('attemptedBy')
          .doc(stdDocId)
          .update({'marksObtained': marks});
      return true;
    } catch (e) {
      return false;
    }
  }
  // Future<String> uploadFile(PlatformFile _file,String classCode) async {
  // // File ccc= _file as File;
  //   String uploadedFileUrl;
  //   StorageReference storageReference = FirebaseStorage.instance
  //       .ref()
  //       .child('quizFiles/${_file.name}');
  //   StorageUploadTask uploadTask = storageReference.putFile(io.File(_file.path));
  //   StorageTaskSnapshot cuyz= await uploadTask.onComplete;
  //   print('File Uploaded');
  //   uploadedFileUrl= await cuyz.ref.getDownloadURL();
  //   print('File URl :- $uploadedFileUrl');
  //   return uploadedFileUrl;
  // }

  Future<String> uploadFileWeb(
      PlatformFile _file, String classCode, String ref) async {
    String uploadedFileUrl;
    html.File htmlFile = html.File(_file.bytes, _file.name);
    print('file name:${htmlFile.name}');
    print('1');
    fb.Storage storage = fb.storage();
    fb.StorageReference storageReference = storage
        .ref('$ref/')
        .child('${DateTime.now().toString() + htmlFile.name}');
    print('2');
    fb.UploadTaskSnapshot uploadTaskSnapshot =
        await storageReference.put(_file.bytes).future;
    Uri imageUri = await uploadTaskSnapshot.ref.getDownloadURL();
    print('File Uploaded');
    uploadedFileUrl = imageUri.toString();
    print('Image URl :- $uploadedFileUrl');
    return uploadedFileUrl;
  }
}
