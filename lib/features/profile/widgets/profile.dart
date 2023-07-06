// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:thoughtsss/features/auth/controller/auth_controller.dart';
import 'package:thoughtsss/features/auth/widgets/error_page.dart';
import 'package:thoughtsss/features/memory/widgets/memory_card.dart';
import 'package:thoughtsss/features/profile/controller/user_profile_controller.dart';
import 'package:thoughtsss/features/profile/widgets/follow_count.dart';

import 'package:thoughtsss/models/usermodel.dart';
import 'package:velocity_x/velocity_x.dart';

class Profile extends ConsumerWidget {
  final UserModel userModel;
  const Profile({
    required this.userModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final currentUser = ref.watch(currentUserProvider).value;
    return currentUser == null
        ? LoadingIndicator(indicatorType: Indicator.ballClipRotateMultiple)
        : NestedScrollView(
            headerSliverBuilder: (context, innerBoxIsScrolled) {
              return [
                SliverAppBar(
                  expandedHeight: 160,
                  floating: true,
                  snap: true,
                  flexibleSpace: Stack(children: [
                    Positioned.fill(
                        child: userModel.bannerPicture.isEmpty
                            ? VxArc(
                                height: 0,
                                arcType: VxArcType.convey,
                                child: Container(color: Colors.purple.shade700))
                            : Container(
                                color: Colors.purple.shade700,
                                child: Image.network(userModel.bannerPicture),
                              )),
                    userModel.profilePicture.isEmpty
                        ? Positioned(
                            bottom: 0,
                            child: CircleAvatar(),
                          )
                        : Positioned(
                            bottom: 0,
                            child: CircleAvatar(
                              backgroundImage:
                                  NetworkImage(userModel.profilePicture),
                            ),
                          ),
                    currentUser.uid == userModel.uid
                        ? Container(
                            alignment: Alignment.bottomRight,
                            child: OutlinedButton(
                                onPressed: () {}, child: Text("Edit Profile")))
                        : Container(
                            alignment: Alignment.bottomRight,
                            child: OutlinedButton(
                                onPressed: () {}, child: Text("Follow")))
                  ]),
                ),
                SliverPadding(
                  padding: EdgeInsets.all(8.0),
                  sliver: SliverList(
                    delegate: SliverChildListDelegate([
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text(userModel.username,
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('@${userModel.username}',
                            style:
                                TextStyle(fontSize: 20, color: Colors.white)),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceAround,
                        children: [
                          FollowCount(
                              count: userModel.followers.length,
                              text: 'Followers'),
                          FollowCount(
                              count: userModel.followings.length,
                              text: 'Following'),
                          FollowCount(
                              count: userModel.interests.length,
                              text: 'Interests'),
                        ],
                      )
                    ]),
                  ),
                )
              ];
            },
            body: ref.watch(getUserMemoriesProvider(userModel.uid)).when(
                data: (data) {
                  return ListView.builder(
                    key: PageStorageKey('Memory'),
                    itemCount: data.length,
                    itemBuilder: (context, index) {
                      final memory = data[index];
                      if (index == data.length - 1) {
                        return Padding(
                            padding: EdgeInsets.only(
                                bottom: 60.0), // Adjust the padding as needed
                            child: MemoryCard(
                              memory: memory,
                            ));
                      } else {
                        return MemoryCard(
                          memory: memory,
                        );
                      }
                    },
                  );
                },
                error: (error, stackTrace) =>
                    ErrorPage(error: error.toString()),
                loading: () => LoadingIndicator(
                    indicatorType: Indicator.ballClipRotateMultiple)));
  }
}
