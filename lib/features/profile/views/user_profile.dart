// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thoughtsss/features/profile/widgets/profile.dart';

import 'package:thoughtsss/models/usermodel.dart';

class UserProfile extends ConsumerWidget {
  final UserModel usermodel;
  const UserProfile({
    required this.usermodel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      body: Hero(
          tag: usermodel.email,
          child: Profile(
            userModel: usermodel,
          )),
    );
  }
}
