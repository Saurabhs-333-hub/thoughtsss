// // ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:like_button/like_button.dart';
// import 'package:loading_indicator/loading_indicator.dart';
// import 'package:timeago/timeago.dart' as timeago;

// import 'package:thoughtsss/constants/asset_constants.dart';
// import 'package:thoughtsss/core/enums/memory_type_enum.dart';
// import 'package:thoughtsss/features/auth/controller/auth_controller.dart';
// import 'package:thoughtsss/features/auth/widgets/error_page.dart';
// import 'package:thoughtsss/features/memory/controller/memory_controller.dart';
// import 'package:thoughtsss/features/memory/views/memory_reply_view.dart';
// import 'package:thoughtsss/features/memory/widgets/carousel_image.dart';
// import 'package:thoughtsss/features/memory/widgets/hashtag_text.dart';
// import 'package:thoughtsss/features/memory/widgets/memory_button.dart';
// import 'package:thoughtsss/features/reply/controller/reply_controller.dart';
// import 'package:thoughtsss/models/memory_model.dart';
// import 'package:thoughtsss/models/reply_model.dart';

// class ReplyCard extends ConsumerWidget {
//   final Memory memorys;
//   final Reply reply;
//   const ReplyCard({
//     required this.memorys,
//     required this.reply,
//   });

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final currentUser = ref.watch(currentUserProvider).value;
//     return currentUser == null
//         ? LoadingIndicator(indicatorType: Indicator.ballClipRotateMultiple)
//         : ref.watch(userDetailsProvider(reply.uid)).when(
//             data: (data) {
//               return Padding(
//                 padding: const EdgeInsets.all(2.0),
//                 child: ClipRRect(
//                   borderRadius: BorderRadius.circular(14),
//                   child: Container(
//                     decoration: BoxDecoration(
//                       borderRadius: BorderRadius.circular(14),
//                       color: Color.fromARGB(255, 0, 0, 0),
//                     ),
//                     child: Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         if (reply.reMemoryBy.isNotEmpty)
//                           Container(
//                             color: Color.fromARGB(255, 162, 0, 255),
//                             child: Padding(
//                               padding: const EdgeInsets.all(6.0),
//                               child: Row(
//                                 children: [
//                                   Icon(Icons.ios_share_rounded),
//                                   Padding(
//                                     padding: const EdgeInsets.only(left: 6.0),
//                                     child: Text(
//                                         '@${reply.reMemoryBy} reshared it!'),
//                                   )
//                                 ],
//                               ),
//                             ),
//                           ),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             children: [
//                               CircleAvatar(),
//                               Expanded(
//                                   child: Padding(
//                                 padding: const EdgeInsets.all(8.0),
//                                 child: Text('@${data.username}'),
//                               )),
//                               Text(timeago.format(reply.createdAt),
//                                   style: TextStyle(fontSize: 10)),
//                               IconButton(
//                                 icon: Icon(Icons.more_vert),
//                                 onPressed: () {},
//                               )
//                             ],
//                           ),
//                         ),
//                         GestureDetector(
//                           onTap: () {
//                             Navigator.push(
//                                 context,
//                                 MaterialPageRoute(
//                                   builder: (context) => MemoryReply(
//                                     memorys: memorys,
//                                     reply: reply,
//                                   ),
//                                 ));
//                           },
//                           child: Row(
//                             crossAxisAlignment: CrossAxisAlignment.start,
//                             children: [
//                               Expanded(
//                                 child: Padding(
//                                   padding: const EdgeInsets.all(8.0),
//                                   child: HashTagText(text: reply.text),
//                                 ),
//                               ),
//                             ],
//                           ),
//                         ),
//                         if (reply.tweetType == TweetType.image)
//                           GestureDetector(
//                               onTap: () {
//                                 Navigator.push(
//                                     context,
//                                     MaterialPageRoute(
//                                       builder: (context) => MemoryReply(
//                                           memorys: memorys, reply: reply),
//                                     ));
//                               },
//                               child:
//                                   CarouselImage(imageLinks: reply.imageLinks)),
//                         Padding(
//                           padding: const EdgeInsets.all(8.0),
//                           child: Row(
//                             mainAxisAlignment: MainAxisAlignment.spaceAround,
//                             children: [
//                               LikeButton(
//                                 likeCount: reply.likes.length,
//                                 onTap: (isLiked) async {
//                                   ref
//                                       .read(replyControllerProvider.notifier)
//                                       .likereply(reply, currentUser);
//                                   return !isLiked;
//                                 },
//                                 isLiked: reply.likes.contains(currentUser.uid),
//                                 countBuilder: (likeCount, isLiked, text) {
//                                   return Text(text);
//                                 },
//                               ),
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(Icons.lightbulb_circle_rounded),
//                                     onPressed: () {
//                                       Navigator.push(
//                                           context,
//                                           MaterialPageRoute(
//                                             builder: (context) => MemoryReply(
//                                                 memorys: memorys, reply: reply),
//                                           ));
//                                     },
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                         reply.commentIds.length.toString()),
//                                   )
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(Icons.auto_graph_rounded),
//                                     onPressed: () {},
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(
//                                         '${reply.commentIds.length + reply.reShareCount + reply.likes.length}'),
//                                   )
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(Icons.ios_share_rounded),
//                                     onPressed: () {
//                                       ref
//                                           .read(
//                                               replyControllerProvider.notifier)
//                                           .updateReshareCount(
//                                               reply, currentUser, context);
//                                     },
//                                   ),
//                                   Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Text(reply.reShareCount.toString()),
//                                   )
//                                 ],
//                               ),
//                               Row(
//                                 children: [
//                                   IconButton(
//                                     icon: Icon(Icons.bookmark_rounded),
//                                     onPressed: () {},
//                                   ),
//                                 ],
//                               )
//                             ],
//                           ),
//                         )
//                       ],
//                     ),
//                   ),
//                 ),
//               );
//             },
//             error: (error, stackTrace) => ErrorPage(error: error.toString()),
//             loading: () => LoadingIndicator(
//                 indicatorType: Indicator.ballClipRotateMultiple));
//   }
// }
