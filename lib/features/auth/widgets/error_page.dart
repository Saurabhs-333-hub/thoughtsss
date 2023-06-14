import 'package:flutter/material.dart';

class Errortext extends StatefulWidget {
  final String error;
  const Errortext({super.key, required this.error});

  @override
  State<Errortext> createState() => _ErrortextState();
}

class _ErrortextState extends State<Errortext> {
  @override
  Widget build(BuildContext context) {
    return Center(
      child: CircularProgressIndicator(),
    );
  }
}

class ErrorPage extends StatelessWidget {
  final String error;
  const ErrorPage({super.key, required this.error});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(child: Errortext(error: error)),
    );
  }
}
