import 'dart:io';

import 'package:firebase_storage/firebase_storage.dart';
import 'package:uuid/uuid.dart';

class UploadImageTask {
  final uuid = new Uuid();
  StorageReference storageRef;
  StorageUploadTask uploadTask;

  UploadImageTask(String imagePath) {
    this.storageRef =
        FirebaseStorage.instance.ref().child(getRemoteFileName());
    this.uploadTask = storageRef.putFile(
      File(imagePath),
      StorageMetadata(
        contentType: 'image/jpg',
      ),
    );
  }

  String getRemoteFileName() {
    final id = uuid.v5(Uuid.NAMESPACE_URL, 'denispinna.eu');
    return "$id.jpg";
  }

  Future<String> execute() async {
    final StorageTaskSnapshot downloadUrl = await uploadTask.onComplete;
    final String url = await downloadUrl.ref.getDownloadURL();
    return url;
  }
}
