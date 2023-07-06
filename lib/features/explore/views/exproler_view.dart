// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';

import 'package:thoughtsss/features/auth/widgets/error_page.dart';
import 'package:thoughtsss/features/explore/controller/explore_controller.dart';
import 'package:thoughtsss/features/explore/search_tile.dart';
import 'package:thoughtsss/features/profile/views/user_profile.dart';
import 'package:thoughtsss/models/usermodel.dart';

class Explore extends ConsumerStatefulWidget {
  const Explore({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreState();
}

class _ExploreState extends ConsumerState<Explore> {
  TextEditingController _searchController = TextEditingController();
  bool isSubmitted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Padding(
          padding: const EdgeInsets.all(8.0),
          child: SizedBox(
              height: 40,
              child: TextField(
                controller: _searchController,
                decoration: InputDecoration(
                    border: OutlineInputBorder(),
                    fillColor: Colors.grey.shade800,
                    filled: true),
                onChanged: (value) {
                  if (value == '') {
                    setState(() {
                      isSubmitted = false;
                    });
                  } else {
                    setState(() {
                      isSubmitted = true;
                    });
                  }
                },
              )),
        ),
      ),
      body: isSubmitted
          ? ref.watch(searchUserProvider(_searchController.text)).when(
              data: (data) {
                return ListView.builder(
                  itemCount: data.length,
                  itemBuilder: (context, index) {
                    final user = data[index];
                    return Hero(
                      tag: user.email,
                      transitionOnUserGestures: true,
                      child: GestureDetector(
                          onTap: () {
                            Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) =>
                                      UserProfile(usermodel: user),
                                ));
                          },
                          child: Container(
                            color: const Color.fromARGB(0, 0, 0, 0),
                            child: SearchTile(
                              usermodel: user,
                            ),
                          )),
                    );
                  },
                );
              },
              error: (error, stackTrace) => ErrorPage(error: error.toString()),
              loading: () => LoadingIndicator(
                  indicatorType: Indicator.ballClipRotateMultiple))
          : Container(
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(10),
                  color: Colors.grey.shade800),
              child: Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text("Search Users!"),
              )),
    );
  }
}
