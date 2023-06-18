import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:thoughtsss/constants/appwrite_constants.dart';
import 'package:thoughtsss/features/auth/widgets/error_page.dart';
import 'package:thoughtsss/features/memory/controller/memory_controller.dart';
import 'package:thoughtsss/features/memory/widgets/memory_card.dart';
import 'package:thoughtsss/models/memory_model.dart';

class MemoryList extends ConsumerWidget {
  const MemoryList({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    void getMemories() {
      ref.read(getMemoriesProvider);
    }

    return ref.watch(getMemoriesProvider).when(
          data: (memories) {
            return ref.watch(getlatestMemoryProvider).when(
                  data: (data) {
                    final latestMemory = Memory.fromMap(data.payload);
                    bool isMemoryAlreadyPresent = false;
                    for (var memoryModel in memories) {
                      if (memoryModel.id == latestMemory.id) {
                        isMemoryAlreadyPresent = true;
                        break;
                      }
                    }
                    if (!isMemoryAlreadyPresent && latestMemory.repliedTo == "") {
                      if (data.events.contains(
                          'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.memoriesCollection}.documents.*.create')) {
                        memories.insert(0, Memory.fromMap(data.payload));
                      } else if (data.events.contains(
                          'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.memoriesCollection}.documents.*.update')) {
                        final startPoint =
                            data.events[0].lastIndexOf('documents.');
                        final endPoint = data.events[0].lastIndexOf('.update');

                        final memoryId =
                            data.events[0].substring(startPoint + 10, endPoint);
                        var memory = memories
                            .where((element) => element.id == memoryId)
                            .first;
                        final memoryIndex = memories.indexOf(memory);
                        memories
                            .removeWhere((element) => element.id == memoryId);
                        memory = Memory.fromMap(data.payload);
                        memories.insert(memoryIndex, memory);
                      }
                    }
                    return ListView.builder(
                      key: PageStorageKey('Memory'),
                      itemCount: memories.length,
                      itemBuilder: (context, index) {
                        final memory = memories[index];
                        if (index == memories.length - 1) {
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
                  loading: () => ListView.builder(
                    key: PageStorageKey('Memory'),
                    itemCount: memories.length,
                    itemBuilder: (context, index) {
                      final memory = memories[index];
                      if (index == memories.length - 1) {
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
                  ),
                );
          },
          error: (error, stackTrace) => ErrorPage(error: error.toString()),
          loading: () =>
              LoadingIndicator(indicatorType: Indicator.ballClipRotateMultiple),
        );
  }
}
