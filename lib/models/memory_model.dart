// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'dart:convert';

import 'package:flutter/foundation.dart';

import 'package:thoughtsss/core/enums/memory_type_enum.dart';

class Memory {
  final String text;
  final List<String> hashtags;
  final String link;
  final List<String> imageLinks;
  final String uid;
  final TweetType tweetType;
  final DateTime createdAt;
  final List<String> likes;
  final List<String> commentIds;
  final String id;
  final int reShareCount;
  final String reMemoryBy;
  final String repliedTo;

  Memory(
      {required this.text,
      required this.hashtags,
      required this.link,
      required this.imageLinks,
      required this.uid,
      required this.tweetType,
      required this.createdAt,
      required this.likes,
      required this.commentIds,
      required this.id,
      required this.reShareCount,
      required this.reMemoryBy,
      required this.repliedTo});

  Memory copyWith(
      {String? text,
      List<String>? hashtags,
      String? link,
      List<String>? imageLinks,
      String? uid,
      TweetType? tweetType,
      DateTime? createdAt,
      List<String>? likes,
      List<String>? commentIds,
      String? id,
      int? reShareCount,
      String? reMemoryBy,
      String? repliedTo}) {
    return Memory(
      text: text ?? this.text,
      hashtags: hashtags ?? this.hashtags,
      link: link ?? this.link,
      imageLinks: imageLinks ?? this.imageLinks,
      uid: uid ?? this.uid,
      tweetType: tweetType ?? this.tweetType,
      createdAt: createdAt ?? this.createdAt,
      likes: likes ?? this.likes,
      commentIds: commentIds ?? this.commentIds,
      id: id ?? this.id,
      reShareCount: reShareCount ?? this.reShareCount,
      reMemoryBy: reMemoryBy ?? this.reMemoryBy,
      repliedTo: repliedTo ?? this.repliedTo,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'text': text,
      'hashtags': hashtags,
      'link': link,
      'imageLinks': imageLinks,
      'uid': uid,
      'tweetType': tweetType.type,
      'createdAt': createdAt.millisecondsSinceEpoch,
      'likes': likes,
      'commentIds': commentIds,
      'reShareCount': reShareCount,
      'reMemoryBy': reMemoryBy,
      'repliedTo': repliedTo
    };
  }

  factory Memory.fromMap(Map<String, dynamic> map) {
    return Memory(
      text: map['text'] as String,
      hashtags: List<String>.from((map['hashtags'])),
      link: map['link'] as String,
      imageLinks: List<String>.from((map['imageLinks'])),
      uid: map['uid'] as String,
      tweetType: (map['tweetType'] as String).toEnum(),
      createdAt: DateTime.fromMillisecondsSinceEpoch(map['createdAt'] as int),
      likes: List<String>.from((map['likes'])),
      commentIds: List<String>.from((map['commentIds'])),
      id: map['\$id'] as String,
      reShareCount: map['reShareCount'] as int,
      reMemoryBy: map['reMemoryBy'] as String,
      repliedTo: map['repliedTo'] as String,
    );
  }

  @override
  String toString() {
    return 'Memory(text: $text, hashtags: $hashtags, link: $link, imageLinks: $imageLinks, uid: $uid, tweetType: $tweetType, createdAt: $createdAt, likes: $likes, commentIds: $commentIds, id: $id, reShareCount: $reShareCount,reMemoryBy:$reMemoryBy,repliedTo:$repliedTo)';
  }

  @override
  bool operator ==(covariant Memory other) {
    if (identical(this, other)) return true;

    return other.text == text &&
        listEquals(other.hashtags, hashtags) &&
        other.link == link &&
        listEquals(other.imageLinks, imageLinks) &&
        other.uid == uid &&
        other.tweetType == tweetType &&
        other.createdAt == createdAt &&
        listEquals(other.likes, likes) &&
        listEquals(other.commentIds, commentIds) &&
        other.id == id &&
        other.reShareCount == reShareCount &&
        other.reMemoryBy == reMemoryBy &&
        other.repliedTo == repliedTo;
  }

  @override
  int get hashCode {
    return text.hashCode ^
        hashtags.hashCode ^
        link.hashCode ^
        imageLinks.hashCode ^
        uid.hashCode ^
        tweetType.hashCode ^
        createdAt.hashCode ^
        likes.hashCode ^
        commentIds.hashCode ^
        id.hashCode ^
        reShareCount.hashCode ^
        reMemoryBy.hashCode ^
        repliedTo.hashCode;
  }
}
