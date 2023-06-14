import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thoughtsss/constants/appwrite_constants.dart';
import 'package:thoughtsss/core/providers.dart';
final storageAPIProvider = Provider((ref) {
  return StorageAPI(storage: ref.watch(appwriteStorageProvider));
});
class StorageAPI {
  final Storage _storage;
  StorageAPI({required Storage storage}) : _storage = storage;
  Future<List<String>> uploadImage(List<File> files) async {
    List<String> imageLinks = [];
    for (var file in files) {
      final uploadImage = await _storage.createFile(
          bucketId: AppwriteConstants.imageBucket,
          fileId: ID.unique(),
          file: InputFile.fromPath(path: file.path));
      imageLinks.add(AppwriteConstants.imageUrl(uploadImage.$id));
    }
    return imageLinks;
  }
}
