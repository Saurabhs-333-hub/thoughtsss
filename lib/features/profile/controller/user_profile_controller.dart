import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thoughtsss/apis/memory_api.dart';
import 'package:thoughtsss/apis/user_api.dart';
import 'package:thoughtsss/models/memory_model.dart';
import 'package:thoughtsss/models/usermodel.dart';

final userProfileControllerNotifier = StateNotifierProvider((ref) {
  return UserProfileControllerNotifier(memoryAPI: ref.watch(memoryAPIProvider));
});

final getUserMemoriesProvider = FutureProvider.family((ref, String uid) async {
  final userProfileController =
      ref.watch(userProfileControllerNotifier.notifier);
  return userProfileController.gteUserMemories(uid);
});

class UserProfileControllerNotifier extends StateNotifier<bool> {
  final MemoryAPI _memoryAPI;
  UserProfileControllerNotifier({required MemoryAPI memoryAPI})
      : _memoryAPI = memoryAPI,
        super(false);
  Future<List<Memory>> gteUserMemories(String uid) async {
    final memories = await _memoryAPI.getUserMemories(uid);
    return memories.map((e) => Memory.fromMap(e.data)).toList();
  }
}
