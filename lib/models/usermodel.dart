// ignore_for_file: public_member_api_docs, sort_constructors_first

import 'package:flutter/foundation.dart';

@immutable
class UserModel {
  final String uid;
  final String username;
  final String email;
  final String password;
  final String fullName;
  final String profilePicture;
  final String bannerPicture;
  final String bio;
  final String location;
  final String dateOfBirth;
  final String gender;
  final List<String> interests;
  final List<String> followers;
  final List<String> followings;
  final bool isProfilePublic;
  final bool isEmailVerified;
  final bool isKThoughtsBlue;
  const UserModel({
    required this.uid,
    required this.username,
    required this.email,
    required this.password,
    required this.fullName,
    required this.profilePicture,
    required this.bannerPicture,
    required this.bio,
    required this.location,
    required this.dateOfBirth,
    required this.gender,
    required this.interests,
    required this.followers,
    required this.followings,
    required this.isProfilePublic,
    required this.isEmailVerified,
    required this.isKThoughtsBlue,
  });

  UserModel copyWith({
    String? uid,
    String? username,
    String? email,
    String? password,
    String? fullName,
    String? profilePicture,
    String? bannerPicture,
    String? bio,
    String? location,
    String? dateOfBirth,
    String? gender,
    List<String>? interests,
    List<String>? followers,
    List<String>? followings,
    bool? isProfilePublic,
    bool? isEmailVerified,
    bool? isKThoughtsBlue,
  }) {
    return UserModel(
      uid: uid ?? this.uid,
      username: username ?? this.username,
      email: email ?? this.email,
      password: password ?? this.password,
      fullName: fullName ?? this.fullName,
      profilePicture: profilePicture ?? this.profilePicture,
      bannerPicture: bannerPicture ?? this.bannerPicture,
      bio: bio ?? this.bio,
      location: location ?? this.location,
      dateOfBirth: dateOfBirth ?? this.dateOfBirth,
      gender: gender ?? this.gender,
      interests: interests ?? this.interests,
      followers: followers ?? this.followers,
      followings: followings ?? this.followings,
      isProfilePublic: isProfilePublic ?? this.isProfilePublic,
      isEmailVerified: isEmailVerified ?? this.isEmailVerified,
      isKThoughtsBlue: isKThoughtsBlue ?? this.isKThoughtsBlue,
    );
  }

  Map<String, dynamic> toMap() {
    return <String, dynamic>{
      'username': username,
      'email': email,
      'password': password,
      'fullName': fullName,
      'profilePicture': profilePicture,
      'bannerPicture': bannerPicture,
      'bio': bio,
      'location': location,
      'dateOfBirth': dateOfBirth,
      'gender': gender,
      'interests': interests,
      'followers': followers,
      'followings': followings,
      'isProfilePublic': isProfilePublic,
      'isEmailVerified': isEmailVerified,
      'isKThoughtsBlue': isKThoughtsBlue,
    };
  }

  factory UserModel.fromMap(Map<String, dynamic> map) {
    return UserModel(
      uid: map['\$id'] as String,
      username: map['username'] as String,
      email: map['email'] as String,
      password: map['password'] as String,
      fullName: map['fullName'] as String,
      profilePicture: map['profilePicture'] as String,
      bannerPicture: map['bannerPicture'] as String,
      bio: map['bio'] as String,
      location: map['location'] as String,
      dateOfBirth: map['dateOfBirth'] as String,
      gender: map['gender'] as String,
      interests: List<String>.from((map['interests'])),
      followers: List<String>.from((map['followers'])),
      followings: List<String>.from((map['followings'])),
      isProfilePublic: map['isProfilePublic'] as bool,
      isEmailVerified: map['isEmailVerified'] as bool,
      isKThoughtsBlue: map['isKThoughtsBlue'] as bool,
    );
  }

  @override
  String toString() {
    return 'UserModel(uid: $uid, username: $username, email: $email, password: $password, fullName: $fullName, profilePicture: $profilePicture, bannerPicture: $bannerPicture, bio: $bio, location: $location, dateOfBirth: $dateOfBirth, gender: $gender, interests: $interests, followers: $followers, followings: $followings, isProfilePublic: $isProfilePublic, isEmailVerified: $isEmailVerified, isKThoughtsBlue: $isKThoughtsBlue)';
  }

  @override
  bool operator ==(covariant UserModel other) {
    if (identical(this, other)) return true;

    return other.uid == uid &&
        other.username == username &&
        other.email == email &&
        other.password == password &&
        other.fullName == fullName &&
        other.profilePicture == profilePicture &&
        other.bannerPicture == bannerPicture &&
        other.bio == bio &&
        other.location == location &&
        other.dateOfBirth == dateOfBirth &&
        other.gender == gender &&
        listEquals(other.interests, interests) &&
        listEquals(other.followers, followers) &&
        listEquals(other.followings, followings) &&
        other.isProfilePublic == isProfilePublic &&
        other.isEmailVerified == isEmailVerified &&
        other.isKThoughtsBlue == isKThoughtsBlue;
  }

  @override
  int get hashCode {
    return uid.hashCode ^
        username.hashCode ^
        email.hashCode ^
        password.hashCode ^
        fullName.hashCode ^
        profilePicture.hashCode ^
        bannerPicture.hashCode ^
        bio.hashCode ^
        location.hashCode ^
        dateOfBirth.hashCode ^
        gender.hashCode ^
        interests.hashCode ^
        followers.hashCode ^
        followings.hashCode ^
        isProfilePublic.hashCode ^
        isEmailVerified.hashCode ^
        isKThoughtsBlue.hashCode;
  }
}
