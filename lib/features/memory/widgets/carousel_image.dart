// ignore_for_file: public_member_api_docs, sort_constructors_first
// import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_carousel_widget/flutter_carousel_widget.dart';
import 'package:loading_indicator/loading_indicator.dart';

class CarouselImage extends StatefulWidget {
  final List<String> imageLinks;
  const CarouselImage({
    Key? key,
    required this.imageLinks,
  }) : super(key: key);

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  int currentIndex = 0;
  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Column(
          children: [
            Container(
              decoration: BoxDecoration(
                  color: Color.fromARGB(36, 128, 0, 255),
                  borderRadius: BorderRadius.only(
                      topLeft: Radius.circular(20),
                      bottomLeft: Radius.circular(20),
                      bottomRight: Radius.circular(20),
                      topRight: Radius.circular(20))),
              child: ExpandableCarousel(
                options: CarouselOptions(
                    // height: 400,
                    enlargeStrategy: CenterPageEnlargeStrategy.scale,
                    enlargeCenterPage: true,
                    // enlargeFactor: 1,
                    enableInfiniteScroll: false,
                    viewportFraction: 1,
                    onPageChanged: (index, reason) {
                      setState(() {
                        currentIndex = index;
                      });
                    },
                    // showIndicator: false,
                    slideIndicator: CircularSlideIndicator()),
                key: PageStorageKey(widget.imageLinks),
                items: widget.imageLinks
                    .map((e) => Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: ClipRRect(
                              borderRadius: BorderRadius.circular(20),
                              child: Image.network(
                                e,
                                loadingBuilder:
                                    (context, child, loadingProgress) {
                                  if (loadingProgress == null) {
                                    return child;
                                  }
                                  return LoadingIndicator(
                                    indicatorType:
                                        Indicator.ballClipRotateMultiple,
                                    backgroundColor:
                                        Color.fromARGB(29, 255, 255, 255),
                                    pathBackgroundColor: Colors.black,
                                    colors: [Colors.white],
                                  ); // Replace with your custom loader widget
                                },
                              )),
                        ))
                    .toList(),
              ),
            ),
            // Padding(
            //   padding: const EdgeInsets.all(8.0),
            //   child: Row(
            //     mainAxisAlignment: MainAxisAlignment.center,
            //     children: widget.imageLinks.asMap().entries.map((e) {
            //       return Padding(
            //         padding: const EdgeInsets.all(2.0),
            //         child: Container(
            //           key: PageStorageKey(currentIndex),
            //           width: 10,
            //           height: 10,
            //           decoration: BoxDecoration(
            //               border: Border.all(
            //                   color: const Color.fromARGB(255, 255, 255, 255)),
            //               color: currentIndex == e.key
            //                   ? Colors.white
            //                   : Color.fromARGB(0, 0, 0, 0),
            //               shape: BoxShape.circle),
            //         ),
            //       );
            //     }).toList(),
            //   ),
            // ),
          ],
        )
      ],
    );
  }
}
