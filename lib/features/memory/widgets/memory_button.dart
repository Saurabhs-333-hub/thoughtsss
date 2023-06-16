// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class MemoryIcon extends StatelessWidget {
  final String pathname;
  final String text;
  final VoidCallback onTap;
  const MemoryIcon({
    Key? key,
    required this.pathname,
    required this.text,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
        onTap: onTap,
        child: Row(
          children: [
            SvgPicture.asset(pathname),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(text),
            )
          ],
        ));
  }
}
