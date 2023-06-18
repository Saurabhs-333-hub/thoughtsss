import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thoughtsss/apis/memory_api.dart';
import 'package:thoughtsss/apis/storage_api.dart';
import 'package:thoughtsss/core/enums/memory_type_enum.dart';
import 'package:thoughtsss/core/utils.dart';
import 'package:thoughtsss/features/auth/controller/auth_controller.dart';
import 'package:thoughtsss/models/memory_model.dart';
import 'package:thoughtsss/models/reply_model.dart';
import 'package:thoughtsss/models/usermodel.dart';
import 'package:appwrite/models.dart' as model;

final memoryControllerProvider =
    StateNotifierProvider<MemoryController, bool>((ref) {
  return MemoryController(
      ref: ref,
      memoryAPI: ref.watch(memoryAPIProvider),
      storageAPI: ref.watch(storageAPIProvider));
});
final getMemoriesProvider = FutureProvider((ref) async {
  final memoryController = ref.watch(memoryControllerProvider.notifier);
  return memoryController.getMemories();
});

final getMemoriesByIDProvider = FutureProvider.family((ref,String id) async {
  final memoryController = ref.watch(memoryControllerProvider.notifier);
  return memoryController.getMemoriesByID(id);
});

final getReplyToMemoriesProvider =
    FutureProvider.family((ref, Memory memory) async {
  final memoryController = ref.watch(memoryControllerProvider.notifier);
  return memoryController.getRepliesToMemory(memory);
});

final getlatestMemoryProvider = StreamProvider.autoDispose((ref) {
  final memoryProvider = ref.watch(memoryAPIProvider);
  return memoryProvider.getLatestMemory();
});

class MemoryController extends StateNotifier<bool> {
  MemoryAPI _memoryAPI;
  StorageAPI _storageAPI;

  Ref _ref;
  MemoryController(
      {required Ref ref,
      required MemoryAPI memoryAPI,
      required StorageAPI storageAPI})
      : _ref = ref,
        _memoryAPI = memoryAPI,
        _storageAPI = storageAPI,
        super(false);
  Future<List<Memory>> getMemories() async {
    final memroyList = await _memoryAPI.getMemories();
    return memroyList.map((e) => Memory.fromMap(e.data)).toList();
  }
Future<Memory>getMemoriesByID(String id)async{
final memoryList= await _memoryAPI.getMemoryByID(id);
return Memory.fromMap(memoryList.data);
}
  void likeMemory(Memory memory, UserModel userModel) async {
    List<String> likes = memory.likes;
    if (memory.likes.contains(userModel.uid)) {
      likes.remove(userModel.uid);
    } else {
      likes.add(userModel.uid);
    }
    final res = await _memoryAPI.likeMemory(memory);
    res.fold(
      (l) => null,
      (r) => null,
    );
  }

  void updateReshareCount(
      Memory memory, UserModel userModel, BuildContext context) async {
    memory = memory.copyWith(
        reMemoryBy: userModel.username,
        likes: [],
        commentIds: [],
        reShareCount: memory.reShareCount + 1,
        createdAt: DateTime.now());
    final res = await _memoryAPI.updatedReshareCount(memory);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        memory = memory.copyWith(id: ID.unique(), reShareCount: 0);
        final res2 = await _memoryAPI.shareMemory(memory);
        res2.fold((l) => showSnackBar(context, l.message),
            (r) => showSnackBar(context, 'Reshared'));
      },
    );
  }

  void shareMemories(
      {required List<File> images,
      required String text,
      required BuildContext context,
      required String repliedTo}) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please Enter Some Text');
      return;
    }
    if (images.isNotEmpty) {
      _shareImageMemories(
          images: images, text: text, context: context, repliedTo: repliedTo);
    } else {
      _shareTextMemories(text: text, context: context, repliedTo: repliedTo);
    }
  }

  Future<List<Memory>> getRepliesToMemory(Memory memory) async {
    final document = await _memoryAPI.getRepliesToMemory(memory);
    return document.map((e) => Memory.fromMap(e.data)).toList();
  }

  void _shareImageMemories(
      {required List<File> images,
      required String text,
      required BuildContext context,
      required String repliedTo}) async {
    state = true;
    final hashtags = getHashTagFromText(text);
    String links = getLinkFromText(text);
    final user = _ref.watch(currentUserProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images);
    Memory memory = Memory(
        text: text,
        hashtags: hashtags,
        link: links,
        imageLinks: imageLinks,
        uid: user.uid,
        tweetType: TweetType.image,
        createdAt: DateTime.now(),
        likes: [],
        commentIds: [],
        id: '',
        reShareCount: 0,
        reMemoryBy: '',
        repliedTo: repliedTo);
    final res = await _memoryAPI.shareMemory(memory);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  void _shareTextMemories(
      {required String text,
      required BuildContext context,
      required String repliedTo}) async {
    state = true;
    final hashtags = getHashTagFromText(text);
    String links = getLinkFromText(text);
    final user = _ref.watch(currentUserProvider).value!;
    Memory memory = Memory(
        text: text,
        hashtags: hashtags,
        link: links,
        imageLinks: [],
        uid: user.uid,
        tweetType: TweetType.text,
        createdAt: DateTime.now(),
        likes: [],
        commentIds: [],
        id: '',
        reShareCount: 0,
        reMemoryBy: '',
        repliedTo: repliedTo);
    final res = await _memoryAPI.shareMemory(memory);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  String getLinkFromText(String text) {
    List<String> wordsInSentence = text.split(' ');
    String link = '';
    for (var word in wordsInSentence) {
      if (word.startsWith('https://') || word.startsWith('www.')) {
        link = word;
      }
    }
    return link;
  }

  List<String> getHashTagFromText(String text) {
    List<String> hashtag = [];
    List<String> wordsInSentence = text.split(' ');
    // String link = '';
    for (var word in wordsInSentence) {
      if (word.startsWith('#')) {
        hashtag.add(word);
      }
    }
    return hashtag;
  }
}
