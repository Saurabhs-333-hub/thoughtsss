// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/foundation.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:thoughtsss/core/utils.dart';
import 'package:url_launcher/url_launcher.dart';

class HashTagText extends StatelessWidget {
  final String text;
  const HashTagText({
    Key? key,
    required this.text,
  }) : super(key: key);
  void _launchURL(String url, BuildContext context) async {
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url), mode: LaunchMode.externalApplication);
    } else {
      return showSnackBar(context, 'Could not lunch url');
    }
  }

  @override
  Widget build(BuildContext context) {
    List<TextSpan> textSpans = [];
    text.split(' ').forEach((element) {
      if (element.startsWith('#')) {
        textSpans.add(TextSpan(
            text: '$element ',
            style: TextStyle(color: Colors.blue, fontSize: 20)));
      } else if (element.startsWith('www.') || element.startsWith('https://')) {
        textSpans.add(TextSpan(
            text: '$element ',
            style: TextStyle(color: Colors.blue, fontSize: 20),
            recognizer: TapGestureRecognizer()
              ..onTap = () {
                if (element.startsWith('www.')) {
                  _launchURL('https://$element', context);
                } else {
                  _launchURL(element, context);
                }
              }));
      } else {
        textSpans
            .add(TextSpan(text: '$element ', style: TextStyle(fontSize: 16)));
      }
    });
    return Container(
      child: RichText(text: TextSpan(children: textSpans)),
    );
  }
}
