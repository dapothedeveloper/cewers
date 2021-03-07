import 'package:cewers/custom_widgets/cewer_title.dart';
import 'package:cewers/notifier/page-view.dart';
import 'package:cewers/screens/alert.dart';
import 'package:flutter/material.dart';
import 'package:cewers/localization/localization_constant.dart';
import 'package:cewers/screens/alerts.dart';
import 'package:cewers/screens/feedback.dart';
import 'package:cewers/screens/map.dart';
import 'package:cewers/screens/sos.dart';
import 'package:provider/provider.dart';

class IndexPage extends StatefulWidget {
  final int screenIndex;
  IndexPageState createState() => IndexPageState();
  IndexPage([this.screenIndex]);
}

class IndexPageState extends State<IndexPage> {
  final List<TabViewScreenModel> screens = [
    TabViewScreenModel(HOME, "home.png", AlertScreen(), null, null),
    TabViewScreenModel(ALERT, "alert.png", AlertListScreen(), null, null),
    TabViewScreenModel(MAP, "pin.png", HeatMap(), null, null),
    TabViewScreenModel(FEEDBACK, "info.png", FeedbackScreen(), null, null),
    TabViewScreenModel(SOS, "phone.png", SosScreen(), "Emergency", "Numbers!"),
  ];
  PageController _controller;
  PageViewNotifier bloc;
  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.screenIndex ?? 0);
  }

  @override
  Widget build(BuildContext context) {
    bloc = Provider.of<PageViewNotifier>(context, listen: false);
    return Scaffold(
      appBar: AppBar(
        title: Consumer<PageViewNotifier>(
          builder: (_, model, __) => CewerAppBar(
            screens[model.currentPage].boldTitle,
            screens[model.currentPage].italicTitle,
          ),
        ),
      ),
      bottomNavigationBar: Builder(
        builder: (_) => SafeArea(
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: []..addAll(
                screens.asMap().entries.map<Widget>(
                      (e) => Consumer<PageViewNotifier>(
                        builder: (_, notifier, __) => fetchAllTabs(
                            _, e.value, e.key, notifier.currentPage),
                      ),
                    ),
              ),
          ),
        ),
      ),
      body: SafeArea(
        child: PageView(
          controller: _controller,
          children: []..addAll(
              screens.asMap().entries.map(
                    (e) => e.value.screen,
                  ),
            ),
        ),
      ),
    );
  }

  Widget fetchAllTabs(BuildContext context, TabViewScreenModel tab, int index,
      int currentPage) {
    return GestureDetector(
      onTap: () {
        _controller.jumpToPage(index);
        bloc.changePage(index);
      },
      child: Container(
        height: 75,
        child: Column(children: <Widget>[
          Image.asset(
            "assets/icons/tabs/${tab.icon}",
          ),
          Text(
            translate(context, tab.name),
            style: TextStyle(
              fontWeight:
                  currentPage == index ? FontWeight.bold : FontWeight.w300,
              fontSize: 12,
              color:
                  currentPage == index ? Theme.of(context).primaryColor : null,
            ),
          )
        ]),
      ),
    );
  }
}

class TabViewScreenModel {
  final String icon;
  final String name;
  final Widget screen;
  final String boldTitle;
  final String italicTitle;
  TabViewScreenModel(
      this.name, this.icon, this.screen, this.boldTitle, this.italicTitle);
}
