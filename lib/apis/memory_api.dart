import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:thoughtsss/constants/appwrite_constants.dart';
import 'package:thoughtsss/core/core.dart';
import 'package:thoughtsss/core/providers.dart';
import 'package:thoughtsss/models/memory_model.dart';

final memoryAPIProvider = Provider((ref) {
  return MemoryAPI(
      db: ref.watch(appwriteDatabaseProvider),
      realTime: ref.watch(appwriteRealTimeProvider));
});

abstract class IMemoryAPI {
  FutureEither<Document> shareMemory(Memory memory);
  Future<List<Document>> getMemories();
  Stream<RealtimeMessage> getLatestMemory();
  FutureEither<Document> likeMemory(Memory memory);
  FutureEither<Document> updatedReshareCount(Memory memory);
  Future<List<Document>> getRepliesToMemory(Memory memory);
  Future<Document> getMemoryByID(String id);
  Future<List<Document>> getUserMemories(String uid);
}

class MemoryAPI implements IMemoryAPI {
  final Databases _db;
  final Realtime _realTime;
  MemoryAPI({required Databases db, required Realtime realTime})
      : _db = db,
        _realTime = realTime;
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
        collectionId: AppwriteConstants.memoriesCollection,
        queries: [
          Query.orderDesc('createdAt'),
          Query.equal('repliedTo', ''),
        ]);
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestMemory() {
    return _realTime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.memoriesCollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> likeMemory(Memory memory) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.memoriesCollection,
          documentId: memory.id,
          data: {'likes': memory.likes});
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(
          e.message ?? 'Some Unexpected Error Occured!', st.toString()));
    } catch (e, st) {
      return left(Failure(e.toString(), st.toString()));
    }
  }

  @override
  FutureEither<Document> updatedReshareCount(Memory memory) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.memoriesCollection,
          documentId: memory.id,
          data: {'reShareCount': memory.reShareCount});
      return right(document);
    } on AppwriteException catch (e, st) {
      return left(Failure(
          e.message ?? 'Some Unexpected Error Occured!', st.toString()));
    } catch (e, st) {
      return left(Failure(e.toString(), st.toString()));
    }
  }

  @override
  Future<List<Document>> getRepliesToMemory(Memory memory) async {
    final document = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.memoriesCollection,
        queries: [Query.equal('repliedTo', memory.id)]);
    return document.documents;
  }

  @override
  Future<Document> getMemoryByID(String id) async {
    return _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.memoriesCollection,
        documentId: id);
  }

  @override
  Future<List<Document>> getUserMemories(String uid) async {
    final document = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.memoriesCollection,
        queries: [Query.equal('uid', uid)]);
    return document.documents;
  }
}
