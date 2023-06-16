import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:thoughtsss/constants/appwrite_constants.dart';
import 'package:thoughtsss/core/core.dart';
import 'package:thoughtsss/core/providers.dart';
import 'package:thoughtsss/models/memory_model.dart';
import 'package:thoughtsss/models/reply_model.dart';

final replyAPIProvider = Provider((ref) {
  return ReplyAPI(
      db: ref.watch(appwriteDatabaseProvider),
      realTime: ref.watch(appwriteRealTimeProvider));
});

abstract class IReplyAPI {
  FutureEither<Document> shareReply(Reply memory);
  Future<List<Document>> getReplies();
  Stream<RealtimeMessage> getLatestReply();
  FutureEither<Document> likeReply(Reply memory);
  FutureEither<Document> updatedReshareCount(Reply memory);
}

class ReplyAPI implements IReplyAPI {
  final Databases _db;
  final Realtime _realTime;
  ReplyAPI({required Databases db, required Realtime realTime})
      : _db = db,
        _realTime = realTime;
  @override
  FutureEither<Document> shareReply(Reply memory) async {
    try {
      final document = await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.repliesCollection,
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
  Future<List<Document>> getReplies() async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.repliesCollection,
        queries: [Query.orderDesc('createdAt')]);
    return documents.documents;
  }

  @override
  Stream<RealtimeMessage> getLatestReply() {
    return _realTime.subscribe([
      'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.repliesCollection}.documents'
    ]).stream;
  }

  @override
  FutureEither<Document> likeReply(Reply memory) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.repliesCollection,
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
  FutureEither<Document> updatedReshareCount(Reply memory) async {
    try {
      final document = await _db.updateDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.repliesCollection,
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
}
