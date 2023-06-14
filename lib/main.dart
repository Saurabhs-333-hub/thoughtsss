// ignore_for_file: prefer_const_constructors

import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:thoughtsss/features/auth/controller/auth_controller.dart';
import 'package:thoughtsss/features/auth/views/login.dart';
import 'package:thoughtsss/features/auth/views/signup.dart';
import 'package:thoughtsss/features/auth/widgets/error_page.dart';
import 'package:thoughtsss/features/home/views/home.dart';
// import 'package:thoughtsss/features/home/views/home_tabbar.dart';
// import 'package:thoughtsss/features/home/views/home_tabbar.dart';
import 'package:stack_trace/stack_trace.dart' as stack_trace;
import 'package:thoughtsss/features/memory/widgets/http_overriders.dart';
import 'package:thoughtsss/themes/themes.dart';

import 'features/auth/widgets/loading_page.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  HttpOverrides.global = MyHttpOverrides();
  runApp(ProviderScope(child: MyApp()));
  FlutterError.demangleStackTrace = (StackTrace stack) {
    if (stack is stack_trace.Trace) return stack.vmTrace;
    if (stack is stack_trace.Chain) return stack.toTrace().vmTrace;
    return stack;
  };
}

class MyApp extends ConsumerWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: lightTheme,
      themeMode: ThemeMode.system,
      darkTheme: darkTheme,
      home: ref.watch(currentUserAccountProvider).when(
          data: (user) {
            if (user != null) {
              return Home();
            }
            return SignUpView();
          },
          error: (error, st) => ErrorPage(error: error.toString()),
          loading: () => LoadingPage()),
      routes: {
        '/login': (context) => LoginView(),
        '/signUp': (context) => SignUpView(),
        // '/home': (context) => Home(),
        // '/createMemory': (context) => CreateMemoryView()
      },
    );
  }
}
