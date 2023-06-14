import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:thoughtsss/features/auth/widgets/error_page.dart';
import 'package:thoughtsss/features/memory/controller/memory_controller.dart';
import 'package:thoughtsss/features/memory/widgets/memory_card.dart';

class MemoryList extends ConsumerWidget {
  const MemoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ref.watch(getMemoriesProvider).when(
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
          error: (error, stackTrace) => ErrorPage(error: error.toString()),
          loading: () =>
              LoadingIndicator(indicatorType: Indicator.ballClipRotateMultiple),
        );
  }
}
