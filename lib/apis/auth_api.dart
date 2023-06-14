// import 'dart:developer';

import 'package:appwrite/appwrite.dart';
import 'package:appwrite/models.dart' as model;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fpdart/fpdart.dart';
import 'package:thoughtsss/core/failure.dart';
import 'package:thoughtsss/core/providers.dart';
import 'package:thoughtsss/core/type_def.dart';

final authAPIProvider = Provider((ref) {
  return AuthAPI(account: ref.watch(appwriteAccountProvider));
});

abstract class IAuthAPI {
  FutureEither<model.Account> signUp(
      {required String email, required String password});
  FutureEither<model.Session> signIn(
      {required String email, required String password});
  Future<model.Account?> currentUserAccount();
}

class AuthAPI implements IAuthAPI {
  final Account _account;
  AuthAPI({required Account account}) : _account = account;

  @override
  Future<model.Account?> currentUserAccount() async {
    try {
      return await _account.get();
    } catch (e) {
      return null;
    }
  }

  @override
  FutureEither<model.Account> signUp(
      {required String email, required String password}) async {
    try {
      final account = await _account.create(
          userId: ID.unique(), email: email, password: password);
      return right(account);
    } on AppwriteException catch (e, st) {
      return left(Failure(
          e.message ?? "Some Unexpected Error Occured!", st.toString()));
    } catch (e, st) {
      return left(Failure(e.toString(), st.toString()));
    }
  }

  @override
  FutureEither<model.Session> signIn(
      {required String email, required String password}) async {
    try {
      final account =
          await _account.createEmailSession(email: email, password: password);
      return right(account);
    } on AppwriteException catch (e, st) {
      return left(Failure(
          e.message ?? "Some Unexpected Error Occured!", st.toString()));
    } catch (e, st) {
      return left(Failure(e.toString(), st.toString()));
    }
  }
}
