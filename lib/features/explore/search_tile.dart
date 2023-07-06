// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';

import 'package:thoughtsss/models/usermodel.dart';

class SearchTile extends StatelessWidget {
  final UserModel usermodel;
  const SearchTile({
    Key? key,
    required this.usermodel,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      color: const Color.fromARGB(0, 0, 0, 0),
      child: Card(
        child: ListTile(
          leading: usermodel.bannerPicture.isEmpty
              ? CircleAvatar()
              : CircleAvatar(
                  backgroundImage: NetworkImage(usermodel.bannerPicture)),
          title: Text(usermodel.username),
        ),
      ),
    );
  }
}
