import 'dart:io';

import 'package:appwrite/appwrite.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thoughtsss/apis/reply_api.dart';
import 'package:thoughtsss/apis/reply_api.dart';
import 'package:thoughtsss/apis/storage_api.dart';
import 'package:thoughtsss/core/enums/memory_type_enum.dart';
import 'package:thoughtsss/core/utils.dart';
import 'package:thoughtsss/features/auth/controller/auth_controller.dart';
import 'package:thoughtsss/models/reply_model.dart';
import 'package:thoughtsss/models/reply_model.dart';
import 'package:thoughtsss/models/usermodel.dart';

final replyControllerProvider =
    StateNotifierProvider<ReplyController, bool>((ref) {
  return ReplyController(
      ref: ref,
      replyAPI: ref.watch(replyAPIProvider),
      storageAPI: ref.watch(storageAPIProvider));
});
final getRepliesProvider = FutureProvider((ref) async {
  final replyController = ref.watch(replyControllerProvider.notifier);
  return replyController.getReplies();
});

final getlatestReplyProvider = StreamProvider.autoDispose((ref) {
  final replyProvider = ref.watch(replyAPIProvider);
  return replyProvider.getLatestReply();
});

class ReplyController extends StateNotifier<bool> {
  ReplyAPI _replyAPI;
  StorageAPI _storageAPI;

  Ref _ref;
  ReplyController(
      {required Ref ref,
      required ReplyAPI replyAPI,
      required StorageAPI storageAPI})
      : _ref = ref,
        _replyAPI = replyAPI,
        _storageAPI = storageAPI,
        super(false);
  Future<List<Reply>> getReplies() async {
    final memroyList = await _replyAPI.getReplies();
    return memroyList.map((e) => Reply.fromMap(e.data)).toList();
  }

  void likereply(Reply reply, UserModel userModel) async {
    List<String> likes = reply.likes;
    if (reply.likes.contains(userModel.uid)) {
      likes.remove(userModel.uid);
    } else {
      likes.add(userModel.uid);
    }
    final res = await _replyAPI.likeReply(reply);
    res.fold(
      (l) => null,
      (r) => null,
    );
  }

  void updateReshareCount(
      Reply reply, UserModel userModel, BuildContext context) async {
    reply = reply.copyWith(
        reMemoryBy: userModel.username,
        likes: [],
        commentIds: [],
        reShareCount: reply.reShareCount + 1,
        createdAt: DateTime.now());
    final res = await _replyAPI.updatedReshareCount(reply);
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) async {
        reply = reply.copyWith(id: ID.unique(), reShareCount: 0);
        final res2 = await _replyAPI.shareReply(reply);
        res2.fold((l) => showSnackBar(context, l.message),
            (r) => showSnackBar(context, 'Reshared'));
      },
    );
  }

  void shareReplies(
      {required List<File> images,
      required String text,
      required BuildContext context,
      required String repliedTo}) {
    if (text.isEmpty) {
      showSnackBar(context, 'Please Enter Some Text');
      return;
    }
    if (images.isNotEmpty) {
      _shareImageReplies(
          images: images, text: text, context: context, repliedTo: repliedTo);
    } else {
      _shareTextReplies(text: text, context: context, repliedTo: repliedTo);
    }
  }

  void _shareImageReplies(
      {required List<File> images,
      required String text,
      required BuildContext context,
      required String repliedTo}) async {
    state = true;
    final hashtags = getHashTagFromText(text);
    String links = getLinkFromText(text);
    final user = _ref.watch(currentUserProvider).value!;
    final imageLinks = await _storageAPI.uploadImage(images);
    Reply reply = Reply(
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
    final res = await _replyAPI.shareReply(reply);
    state = false;
    res.fold(
      (l) => showSnackBar(context, l.message),
      (r) => null,
    );
  }

  void _shareTextReplies(
      {required String text,
      required BuildContext context,
      required String repliedTo}) async {
    state = true;
    final hashtags = getHashTagFromText(text);
    String links = getLinkFromText(text);
    final user = _ref.watch(currentUserProvider).value!;
    Reply reply = Reply(
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
    final res = await _replyAPI.shareReply(reply);
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
