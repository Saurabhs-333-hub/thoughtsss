// import 'package:flutter/cupertino.dart';
import 'dart:io';

import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:thoughtsss/core/utils.dart';
import 'package:thoughtsss/features/auth/controller/auth_controller.dart';
import 'package:thoughtsss/features/memory/controller/memory_controller.dart';
import 'package:velocity_x/velocity_x.dart';

class CreateMemory extends ConsumerStatefulWidget {
  const CreateMemory({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _CreateMemoryState();
}

class _CreateMemoryState extends ConsumerState<CreateMemory> {
  final TextEditingController _textEditingController = TextEditingController();
  List<File> images = [];
  void onPickImages() async {
    images = await pickImages();
    setState(() {});
  }

  void shareMemory() {
    ref.read(memoryControllerProvider.notifier).shareMemories(
        images: images,
        text: _textEditingController.text.trim(),
        context: context,
        repliedTo: '');
  }

  @override
  Widget build(BuildContext context) {
    final currentUser = ref.watch(currentUserProvider).value;
    // print(currentUser);
    return currentUser == null
        ? SizedBox(
            height: 40,
            child: LoadingIndicator(
              indicatorType: Indicator.ballClipRotateMultiple,
              backgroundColor: Colors.white,
            ),
          )
        : Scaffold(
            appBar: AppBar(
                // leading: IconButton(
                //   icon: Icon(Icons.keyboard_double_arrow_left_rounded),
                //   onPressed: () => Navigator.pop(context),
                // ),
                actions: [
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      minWidth: 10,
                      onPressed: () {
                        onPickImages();
                      },
                      color: Color(Vx.getColorFromHex('#8E39D2')),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(40),
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(40),
                              topRight: Radius.circular(40))),
                      child: Icon(Icons.image_rounded),
                    ),
                  ),
                  Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: MaterialButton(
                      onPressed: () {
                        shareMemory();
                      },
                      color: Color(Vx.getColorFromHex('#8E39D2')),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              bottomLeft: Radius.circular(40),
                              bottomRight: Radius.circular(20),
                              topRight: Radius.circular(40))),
                      child: Text("Upload Memory 🦋"),
                    ),
                  )
                ]),
            body: Padding(
              padding: const EdgeInsets.all(8.0),
              child: SingleChildScrollView(
                child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(),
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Text("Create Memory 🦋",
                                style: GoogleFonts.aladin(fontSize: 30)),
                          ),
                        ],
                      ),
                      Container(
                        decoration: BoxDecoration(
                            color: Color(Vx.getColorFromHex('#0x66190443')),
                            borderRadius: BorderRadius.only(
                                topLeft: Radius.circular(10),
                                bottomLeft: Radius.circular(20),
                                bottomRight: Radius.circular(20),
                                topRight: Radius.circular(40))),
                        child: Column(
                          children: [
                            TextField(
                                maxLength: 100,
                                maxLines: null,
                                controller: _textEditingController,
                                style: GoogleFonts.roboto(fontSize: 20),
                                decoration: InputDecoration(
                                    hintText: 'Some Memorable Content 🦋',
                                    border: OutlineInputBorder(
                                      borderRadius: BorderRadius.only(
                                          topLeft: Radius.circular(10),
                                          bottomLeft: Radius.circular(40),
                                          bottomRight: Radius.circular(40),
                                          topRight: Radius.circular(40)),
                                    ))),
                            images.isEmpty
                                ? Padding(
                                    padding: const EdgeInsets.all(8.0),
                                    child: Container(
                                      decoration: BoxDecoration(
                                          color: const Color.fromARGB(
                                              52, 158, 158, 158),
                                          borderRadius: BorderRadius.only(
                                              topLeft: Radius.circular(20),
                                              bottomLeft: Radius.circular(20),
                                              bottomRight: Radius.circular(20),
                                              topRight: Radius.circular(20))),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Text(
                                            "No image has been selected yet!"),
                                      ),
                                    ),
                                  )
                                : Container(
                                    decoration: BoxDecoration(
                                        color:
                                            Color.fromARGB(59, 158, 158, 158),
                                        borderRadius: BorderRadius.only(
                                            topLeft: Radius.circular(20),
                                            bottomLeft: Radius.circular(20),
                                            bottomRight: Radius.circular(20),
                                            topRight: Radius.circular(20))),
                                    child: CarouselSlider(
                                        items: images
                                            .map((e) => Padding(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  child: ClipRRect(
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              20),
                                                      child: Image.file(e)),
                                                ))
                                            .toList(),
                                        options: CarouselOptions(
                                            // height: 200,
                                            enlargeStrategy:
                                                CenterPageEnlargeStrategy.scale,
                                            enlargeCenterPage: true,
                                            enlargeFactor: 1,
                                            enableInfiniteScroll: false)),
                                  )
                          ],
                        ),
                      ),
                    ]),
              ),
            ));
  }
}
