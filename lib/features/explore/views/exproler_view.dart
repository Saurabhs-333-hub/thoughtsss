import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:loading_indicator/loading_indicator.dart';
import 'package:thoughtsss/features/auth/widgets/error_page.dart';
import 'package:thoughtsss/features/explore/controller/explore_controller.dart';

class Explore extends ConsumerStatefulWidget {
  const Explore({super.key});

  @override
  ConsumerState<ConsumerStatefulWidget> createState() => _ExploreState();
}

class _ExploreState extends ConsumerState<Explore> {
  TextEditingController _searchController = TextEditingController();
  bool isSubmitted = false;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: SizedBox(
                height: 40,
                child: TextField(
                  controller: _searchController,
                  decoration: InputDecoration(
                      border: OutlineInputBorder(),
                      fillColor: Colors.grey.shade800,
                      filled: true),
                  onChanged: (value) {
                    if (value == '') {
                      setState(() {
                        isSubmitted = false;
                      });
                    } else {
                      setState(() {
                        isSubmitted = true;
                      });
                    }
                  },
                )),
          ),
          isSubmitted
              ? ref.watch(searchUserProvider(_searchController.text)).when(
                  data: (data) {
                    return Expanded(
                      child: ListView.builder(
                        itemCount: data.length,
                        itemBuilder: (context, index) {
                          final user = data[index];
                          return ListTile(
                            title: Text(user.username),
                          );
                        },
                      ),
                    );
                  },
                  error: (error, stackTrace) =>
                      ErrorPage(error: error.toString()),
                  loading: () => LoadingIndicator(
                      indicatorType: Indicator.ballClipRotateMultiple))
              : Text("Search Users!")
        ],
      ),
    );
  }
}
