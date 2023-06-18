import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thoughtsss/apis/user_api.dart';
import 'package:thoughtsss/models/usermodel.dart';

final exploreControllerNotifier = StateNotifierProvider((ref) {
  return ExploreControllerNotifier(userAPI: ref.watch(userAPIProvider));
});

final searchUserProvider = FutureProvider.family((ref,String username ) async {
  final exploreController=ref.watch(exploreControllerNotifier.notifier);
  return exploreController.searchUser(username);
});

class ExploreControllerNotifier extends StateNotifier<bool> {
  final UserAPI _userAPI;
  ExploreControllerNotifier({required UserAPI userAPI})
      : _userAPI = userAPI,
        super(false);
  Future<List<UserModel>> searchUser(String username) async {
    final users = await _userAPI.searchUserByName(username);
    return users.map((e) => UserModel.fromMap(e.data)).toList();
  }
}
