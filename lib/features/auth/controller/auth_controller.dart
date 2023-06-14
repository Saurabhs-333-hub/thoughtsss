import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thoughtsss/apis/auth_api.dart';
import 'package:thoughtsss/apis/user_api.dart';
import 'package:thoughtsss/features/home/views/home.dart';
// import 'package:thoughtsss/features/home/views/home.dart';
import 'package:thoughtsss/models/usermodel.dart';

import '../../../core/utils.dart';
import 'package:appwrite/models.dart' as model;

// import '../../home/views/home_tabbar.dart';

final authControllerProvider =
    StateNotifierProvider<AuthController, bool>((ref) {
  return AuthController(
      authAPI: ref.watch(authAPIProvider), userAPI: ref.watch(userAPIProvider));
});
final currentUserProvider = FutureProvider((ref) {
  final currentUserId = ref.watch(currentUserAccountProvider).value!.$id;
  final userDetails = ref.watch(userDetailsProvider(currentUserId));
  return userDetails.value;
});
final userDetailsProvider = FutureProvider.family((ref, String uid) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.getUserData(uid);
});
final currentUserAccountProvider = FutureProvider((ref) {
  final authController = ref.watch(authControllerProvider.notifier);
  return authController.currentUser();
});

class AuthController extends StateNotifier<bool> {
  final AuthAPI _authAPI;
  final UserAPI _userAPI;
  AuthController({required AuthAPI authAPI, required UserAPI userAPI})
      : _authAPI = authAPI,
        _userAPI = userAPI,
        super(false);
  Future<model.Account?> currentUser() => _authAPI.currentUserAccount();
  void signUp(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    final res = await _authAPI.signUp(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) async {
      UserModel usermodel = UserModel(
          uid: r.$id,
          username: getNamefromEmail(email),
          email: email,
          password: password,
          fullName: '',
          profilePicture:
              'https://github.com/Saurabhs-333-hub/thoughts_images/blob/main/woman.png',
          bannerPicture: '',
          bio: '',
          location: '',
          dateOfBirth: '',
          gender: '',
          interests: const [],
          followers: const [],
          followings: const [],
          isProfilePublic: false,
          isEmailVerified: false,
          isKThoughtsBlue: false);
      final res = await _userAPI.saveUserData(usermodel);
      res.fold((l) => showSnackBar(context, l.message), (r) {
        showSnackBar(context, 'Account Created! Please Login!');
        // Navigator.pushNamed(context, '/login');
      });
    });
  }

  void signIn(
      {required String email,
      required String password,
      required BuildContext context}) async {
    state = true;
    final res = await _authAPI.signIn(email: email, password: password);
    state = false;
    res.fold((l) => showSnackBar(context, l.message), (r) {
      Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) => Home(),
          ));
    });
  }

  Future<UserModel> getUserData(String uid) async {
    final document = await _userAPI.getuserData(uid);
    final updatedUser = UserModel.fromMap(document.data);
    return updatedUser;
  }
}
