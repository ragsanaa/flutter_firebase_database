import 'dart:io';

import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_storage/firebase_storage.dart' as cloud_storage;
import 'package:flutter/material.dart';

class CloudService {
  final cloud_storage.FirebaseStorage storage =
      cloud_storage.FirebaseStorage.instance;

  Future<String> getFile(String fileName) async {
    String res = await storage.ref('images/$fileName').getDownloadURL();
    return res;
  }

  Future<void> uploadFile(String fileName, String filePath) async {
    final File file = File(filePath);
    try {
      await storage.ref("images/$fileName").putFile(file);
    } on FirebaseException catch (e) {
      debugPrint(e.message.toString());
    }
  }

  Future<cloud_storage.ListResult> getFilesList(String fileType) async {
    cloud_storage.ListResult files = await storage.ref(fileType).listAll();

    for (var ref in files.items) {
      debugPrint(ref.fullPath);
    }
    return files;
  }
}
