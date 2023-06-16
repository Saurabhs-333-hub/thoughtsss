// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:thoughtsss/constants/appwrite_constants.dart';
import 'package:thoughtsss/features/auth/widgets/error_page.dart';
import 'package:thoughtsss/features/memory/controller/memory_controller.dart';
import 'package:thoughtsss/features/memory/widgets/memory_card.dart';
import 'package:thoughtsss/features/reply/controller/reply_controller.dart';

import 'package:thoughtsss/models/memory_model.dart';

class MemoryReply extends ConsumerWidget {
  final Memory memory;
  const MemoryReply({required this.memory, super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    TextEditingController _textController = TextEditingController();
    return Scaffold(
      appBar: AppBar(
          leading: GestureDetector(
              onTap: () => Navigator.pop(context),
              child: Icon(Icons.arrow_back_rounded))),
      body: SingleChildScrollView(
        child: Column(
          children: [
            MemoryCard(memory: memory),
            SizedBox(
              height: 400,
              child: ref.watch(getReplyToMemoriesProvider(memory)).when(
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
                              if (!isMemoryAlreadyPresent &&
                                  latestMemory.repliedTo == memory.id) {
                                if (data.events.contains(
                                    'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.memoriesCollection}.documents.*.create')) {
                                  memories.insert(
                                      0, Memory.fromMap(data.payload));
                                } else if (data.events.contains(
                                    'databases.${AppwriteConstants.databaseId}.collections.${AppwriteConstants.memoriesCollection}.documents.*.update')) {
                                  final startPoint =
                                      data.events[0].lastIndexOf('documents.');
                                  final endPoint =
                                      data.events[0].lastIndexOf('.update');

                                  final memoryId = data.events[0]
                                      .substring(startPoint + 10, endPoint);
                                  var memory = memories
                                      .where(
                                          (element) => element.id == memoryId)
                                      .first;
                                  final memoryIndex = memories.indexOf(memory);
                                  memories.removeWhere(
                                      (element) => element.id == memoryId);
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
                                            bottom:
                                                60.0), // Adjust the padding as needed
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
                                          bottom:
                                              60.0), // Adjust the padding as needed
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
                    error: (error, stackTrace) =>
                        ErrorPage(error: error.toString()),
                    loading: () => LoadingIndicator(
                        indicatorType: Indicator.ballClipRotateMultiple),
                  ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: TextField(
                controller: _textController,
                decoration: InputDecoration(border: OutlineInputBorder()),
                onSubmitted: (value) {
                  ref.watch(memoryControllerProvider.notifier).shareMemories(
                      images: [],
                      text: _textController.text.trim(),
                      context: context,
                      repliedTo: memory.id);
                },
              ),
            )
          ],
        ),
      ),
    );
  }
}
