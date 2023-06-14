import 'package:container_tab_indicator/container_tab_indicator.dart';
import 'package:flutter/material.dart';
import 'package:thoughtsss/features/memory/widgets/memory_list.dart';
import 'package:velocity_x/velocity_x.dart';

class HomeTabBar extends StatefulWidget {
  const HomeTabBar({super.key});

  @override
  State<HomeTabBar> createState() => _HomeTabBarState();
}

class _HomeTabBarState extends State<HomeTabBar>
    with SingleTickerProviderStateMixin {
  late TabController tabController = TabController(length: 6, vsync: this);
  @override
  Widget build(BuildContext context) {
    return SafeArea(
        child: Scaffold(
            extendBodyBehindAppBar: true,
            extendBody: true,
            body: CustomScrollView(slivers: [
              SliverAppBar(
                toolbarHeight: 60,
                // expandedHeight: 100,
                // backgroundColor: Color(Vx.getColorFromHex('#0xFF110220')),
                // foregroundColor: Color(Vx.getColorFromHex('#190433')),
                title: Text("Thoughts"),
                flexibleSpace: FlexibleSpaceBar(
                    background: DecoratedBox(
                        decoration: BoxDecoration(
                            // borderRadius: BorderRadius.only(
                            //     bottomLeft: Radius.circular(20),
                            //     bottomRight: Radius.circular(20)),
                            gradient: LinearGradient(
                                begin: Alignment.topCenter,
                                end: Alignment.bottomCenter,
                                colors: [
                      Color(Vx.getColorFromHex('#121212')),
                      Color(Vx.getColorFromHex('#0x00190433')),
                      // Colors.transparent
                    ])))),
                floating: true,
                // pinned: true,
                // shape: RoundedRectangleBorder(
                //     borderRadius: BorderRadius.only(
                //         bottomLeft: Radius.circular(20),
                //         bottomRight: Radius.circular(20))),
                bottom: TabBar(
                    dividerColor: Colors.transparent,
                    controller: tabController,
                    isScrollable: true,
                    indicator: ContainerTabIndicator(
                        color: Color(Vx.getColorFromHex('#1F0C3E')),
                        height: 30,
                        radius: BorderRadius.all(Radius.circular(40))),
                    tabs: [
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Tab(
                          text: 'Quotes',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Tab(
                          text: 'Memory',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Tab(
                          text: 'Memory',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Tab(
                          text: 'Memory',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Tab(
                          text: 'Memory',
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(horizontal: 10),
                        child: Tab(
                          text: 'Memory',
                        ),
                      )
                    ]),
              ),
              NewWidget(tabController: tabController)
            ])));
  }
}

class NewWidget extends StatefulWidget {
  const NewWidget({
    super.key,
    required this.tabController,
  });

  final TabController tabController;

  @override
  State<NewWidget> createState() => _NewWidgetState();
}

class _NewWidgetState extends State<NewWidget> {
  @override
  Widget build(BuildContext context) {
    return SliverList(
        delegate: SliverChildBuilderDelegate(
      childCount: 1,
      (context, index) => SizedBox(
        height: MediaQuery.of(context).size.height -
            kToolbarHeight -
            kBottomNavigationBarHeight -
            30,
        child: TabBarView(controller: widget.tabController, children: [
          ListView.builder(
            key: PageStorageKey('Quotes'),
            itemCount: 10,
            itemBuilder: (context, index) => Card(
                color: Color.fromARGB(9, 119, 0, 255),
                child: SizedBox(height: 600, width: 200)),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: MemoryList(),
          ),
          Text("hi"),
          Text("hi"),
          Text("hi"),
          Text("hi")
        ]),
      ),
    ));
  }
}
