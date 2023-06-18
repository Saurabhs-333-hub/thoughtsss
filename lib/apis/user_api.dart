import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:thoughtsss/constants/appwrite_constants.dart';
import 'package:thoughtsss/core/core.dart';
import 'package:thoughtsss/core/providers.dart';
import 'package:thoughtsss/models/usermodel.dart';

final userAPIProvider = Provider((ref) {
  return UserAPI(db: ref.watch(appwriteDatabaseProvider));
});

abstract class IUserAPI {
  FutureEitherVoid saveUserData(UserModel usermodel);
  Future<Document> getuserData(String uid);
  Future<List<Document>> searchUserByName(String username);
}

class UserAPI implements IUserAPI {
  final Databases _db;
  UserAPI({required Databases db})
      : _db = db,
        super();
  @override
  FutureEitherVoid saveUserData(UserModel usermodel) async {
    try {
      await _db.createDocument(
          databaseId: AppwriteConstants.databaseId,
          collectionId: AppwriteConstants.usersCollection,
          documentId: usermodel.uid,
          data: usermodel.toMap());
      return right(null);
    } on AppwriteException catch (e, st) {
      return left(Failure(
          e.message ?? 'Some Unexpected Error Occured!', st.toString()));
    } catch (e, st) {
      return left(Failure(e.toString(), st.toString()));
    }
  }

  @override
  Future<Document> getuserData(String uid) async {
    return await _db.getDocument(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        documentId: uid);
  }

  @override
  Future<List<Document>> searchUserByName(String username) async {
    final documents = await _db.listDocuments(
        databaseId: AppwriteConstants.databaseId,
        collectionId: AppwriteConstants.usersCollection,
        queries: [Query.search('username', username)]);
        return documents.documents;
  }
}
