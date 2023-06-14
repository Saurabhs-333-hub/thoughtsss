import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:thoughtsss/constants/appwrite_constants.dart';
import 'package:thoughtsss/core/core.dart';
import 'package:thoughtsss/core/providers.dart';
import 'package:thoughtsss/models/memory_model.dart';

final memoryAPIProvider = Provider((ref) {
  return MemoryAPI(db: ref.watch(appwriteDatabaseProvider));
});

abstract class IMemoryAPI {
  FutureEither<Document> shareMemory(Memory memory);
  Future<List<Document>> getMemories();
}

class MemoryAPI implements IMemoryAPI {
  final Databases _db;
  MemoryAPI({required Databases db}) : _db = db;
  @override
  FutureEither<Document> shareMemory(Memory memory) async {
    try {
      final document = await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.memoriesCollection,
          documentId: ID.unique(),
          data: memory.toMap());
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(
          e.message ?? 'Some Unexpected Error Occured!', st.toString()));
    } catch (e, st) {
      return left(Failure(e.toString(), st.toString()));
    }
  }

  @override
  Future<List<Document>> getMemories() async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.memoriesCollection);
    return documents.documents;
  }
}
