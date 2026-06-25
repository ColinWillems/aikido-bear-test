import 'dart:async';
import 'dart:ui';

import 'package:bear_adventure_app/app/modules/cards/views/cards.view.dart';
import 'package:bear_necessities/bear_necessities.dart';
import 'package:scroll_snap_list/scroll_snap_list.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:bear_adventure_app/app/modules/home/controllers/home.controller.dart';
import 'package:responsive_framework/responsive_framework.dart';
import 'package:tinycolor2/tinycolor2.dart';

class HomeView extends GetView<HomeController> {
  const HomeView({super.key});

  @override
  Widget build(BuildContext context) {
    return HomeSliverAppBar(controller: controller);
  }
}

class HomeSliverAppBar extends StatefulWidget {
  const HomeSliverAppBar({super.key, required this.controller});
  final HomeController controller;

  @override
  HomeSliverAppBarState createState() => HomeSliverAppBarState();
}

class HomeSliverAppBarState extends State<HomeSliverAppBar>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  Color indicatorColor = BearColors.creamWhite;
  List<Color> colors = [
    BearColors.bearGreen.lighten(10),
  ];
  double selectedTab = 0;

  void _changeIndicatorColor(Color color) {
    indicatorColor = color;
  }

  @override
  void initState() {
    selectedTab = 0;

    Timer(1.seconds, () => focusTab(selectedTab.toInt()));

    _tabController = TabController(
      initialIndex: selectedTab.toInt(),
      length: colors.length,
      vsync: this,
    )..addListener(() {
        Future.delayed(
            150.milliseconds,
            () => setState(() {
                  _changeIndicatorColor(colors[_tabController.index]);
                }));
      });
    _changeIndicatorColor(colors[_tabController.index]);

    super.initState();
  }

  void focusTab(int index) {
    if (widget.controller.scrollSnapKey.currentState != null) {
      widget.controller.scrollSnapKey.currentState!.focusToItem(index);
    }
    _tabController.animateTo(index);
  }

  @override
  Widget build(BuildContext context) {
    final TextTheme textTheme = Theme.of(context).textTheme;
    final FlutterView window = View.of(context);
    final double topSafeArea = window.viewPadding.top / window.devicePixelRatio;
    const double tabIconWidth = 160;
    const double tabIconMargin = 16;
    const double tabIconElevation = 10;
    final double maxWidth = AppThemes.appLayout.maxViewWidth;

    final List<Widget> buttons = [
      SizedBox(
        height: tabIconWidth,
        width: tabIconWidth,
        child: Wrap(
          alignment: WrapAlignment.center,
          spacing: tabIconMargin,
          runSpacing: tabIconMargin,
          children: [
            PushableButton(
              onPressed: () => focusTab(0),
              color: BearColors.bearCards.tint(20),
              height: tabIconWidth - tabIconElevation,
              selected: _tabController.index == 0,
              elevation: tabIconElevation,
              borderRadius: 16,
              child: ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: BearAssets.images.home.cards
                    .image(package: BearApp.bearNecessities, fit: BoxFit.cover),
              ),
            ),
            Text(
              LocaleKeys.home_cards.tr,
              style: textTheme.headlineMedium?.s20.w900.copyWith(
                color: Color.fromRGBO(255, 252, 240, 1),
              ),
            ),
          ],
        ),
      ),
    ];

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: Container(
        padding: EdgeInsets.zero,
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
              primary: false,
              backgroundColor: Colors.transparent,
              expandedHeight: 386 + topSafeArea,
              titleSpacing: 0,
              toolbarHeight: 126,
              title: SafeArea(
                top: true,
                child: Container(
                  alignment: Alignment.topCenter,
                  padding: const EdgeInsets.only(bottom: 10),
                  color: BearColors.bearGreen,
                  child: ObxValue(
                      (profile) => Text(
                            LocaleKeys.home_title.tr.replaceFirst(
                                RegExp(r'%character_name%'), profile().name),
                            textAlign: TextAlign.center,
                            style: textTheme.headlineSmall,
                          ),
                      widget.controller.activeProfile),
                ),
              ),
              flexibleSpace: const FlexibleSpaceBar(
                background: SizedBox.expand(
                  child: ColoredBox(color: BearColors.bearGreen),
                ),
              ),
              pinned: true,
              floating: true,
              bottom: AppBar(
                primary: false,
                titleSpacing: 0,
                backgroundColor: BearColors.bearGreen,
                toolbarHeight: 320,
                title: Container(
                  constraints: const BoxConstraints(minHeight: 320),
                  color: BearColors.bearGreen,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    mainAxisSize: MainAxisSize.max,
                    children: [
                      MaxWidthBox(
                        maxWidth: maxWidth,
                        child: Container(
                          decoration: const BoxDecoration(
                              color: Color(0xFF57923A),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(16))),
                          clipBehavior: Clip.antiAlias,
                          child: IntrinsicHeight(
                            child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              BearAssets.images.home.bearNews.image(
                                  package: BearApp.bearNecessities,
                                  width: 65,
                                  fit: BoxFit.fitWidth,
                                  alignment: Alignment.bottomCenter),
                              Expanded(
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      vertical: 8, horizontal: 8),
                                  child: Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.start,
                                    mainAxisAlignment:
                                        MainAxisAlignment.center,
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Text(
                                        LocaleKeys.home_banner_title.tr,
                                        textAlign: TextAlign.start,
                                        style: textTheme.labelSmall?.s13,
                                      ),
                                      Text(
                                        LocaleKeys.home_banner_message.tr,
                                        style:
                                            textTheme.bodySmall?.s11.copyWith(
                                                color: BearColors.creamWhite
                                                    .withOpacity(0.65)),
                                      ),
                                    ],
                                  ),
                                ),
                              ),
                            ],
                          )),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.only(bottom: 8),
                        child: SizedBox(
                          width: double.infinity,
                          height: tabIconWidth + 50,
                          child: ScrollSnapList(
                            key: widget.controller.scrollSnapKey,
                            initialIndex: selectedTab,
                            onItemFocus: (selectedIndex) {
                              setState(() {
                                selectedTab = selectedIndex.toDouble();
                                _tabController.animateTo(selectedTab.toInt());
                              });
                            },
                            itemSize: tabIconWidth,
                            dynamicItemOpacity: 0.5,
                            itemBuilder: (context, index) {
                              return buttons[index];
                            },
                            itemCount: buttons.length,
                            dynamicItemSize: true,
                          ),
                        ),
                      ),
                      Center(
                        child: Container(
                          decoration: TriangleTabIndicator(
                              color: indicatorColor, radius: 20),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SliverFillRemaining(
              hasScrollBody: false,
              fillOverscroll: false,
              child: SizedBox(
                height: 100,
                width: 300,
                child: TabBarView(
                  controller: _tabController,
                  children: [
                    CardsView(
                      color: colors[0],
                      contentWidth: maxWidth,
                    ),
                  ],
                ),
              ),
            )
          ],
        ),
      ),
    );
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }
}
