// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:thoughtsss/core/enums/memory_type_enum.dart';
import 'package:thoughtsss/features/auth/controller/auth_controller.dart';
import 'package:thoughtsss/features/auth/widgets/error_page.dart';
import 'package:thoughtsss/features/memory/widgets/carousel_image.dart';
import 'package:thoughtsss/features/memory/widgets/hashtag_text.dart';
import 'package:thoughtsss/models/memory_model.dart';
import 'package:timeago/timeago.dart' as timeago;

class MemoryCard extends ConsumerWidget {
  final Memory memory;
  const MemoryCard({
    required this.memory,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(userDetailsProvider(memory.uid)).when(
        data: (data) {
          return Container(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      CircleAvatar(),
                      Expanded(
                          child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Text('@${data.username}'),
                      )),
                      Text(timeago.format(memory.createdAt),
                          style: TextStyle(fontSize: 10)),
                      IconButton(
                        icon: Icon(Icons.more_vert),
                        onPressed: () {},
                      )
                    ],
                  ),
                ),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Expanded(
                      child: Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: HashTagText(text: memory.text),
                      ),
                    ),
                  ],
                ),
                if (memory.tweetType == TweetType.image)
                  CarouselImage(imageLinks: memory.imageLinks)
              ],
            ),
          );
        },
        error: (error, stackTrace) => ErrorPage(error: error.toString()),
        loading: () =>
            LoadingIndicator(indicatorType: Indicator.ballClipRotateMultiple));
  }
}
