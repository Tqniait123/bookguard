import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/book_list_model.dart';
import 'package:granth_flutter/models/bookdetail_model.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/models/downloaded_book.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screen/book/component/library_componet.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/file_common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/app_loader_widget.dart';
import '../../models/plan_model.dart';
import 'components/plan_component.dart';

class SubscriptionsPage extends StatefulWidget {
  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  List<DownloadedBook> purchasedList = [];
  List<DownloadedBook> sampleList = [];
  List<PlanDetails> yearlyPlans = [];
  List<PlanDetails> monthlyPlans = [];
  List<DownloadedBook> downloadedList = [];
  PlanModel? planModel;

  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      LiveStream().on(REFRESH_lIBRARY_LIST, (p0) async {
        if (mounted) {
          // await fetchData();
          await getData();
        }
      });
      init();
    });
  }

  void init() async {
    // fetchData();
    getData();
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  DownloadedBook? isExists(List<DownloadedBook> tasks, BookDetailResponse mBookDetail) {
    DownloadedBook? exist;
    tasks.forEach((task) {
      if (task.bookId == mBookDetail.bookId.toString() && task.fileType == PURCHASED_BOOK) {
        exist = task;
      }
    });
    if (exist == null) {
      exist = defaultBook(mBookDetail, PURCHASED_BOOK);
    }
    return exist;
  }


  Future<void> getData() async {
    appStore.setLoading(true);
    await getPlans().then((value) {
      planModel = value;
      yearlyPlans = planModel?.data?.yearlyPlans??[];
      monthlyPlans = planModel?.data?.monthlyPlans??[];
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  Future<void> subscribe(int planId) async {
    appStore.setLoading(true);
    await subscribeApi({'plan_id' : planId.toString()}).then((value) {
      toast(value.message);
      if(value.status == true){
        getData();
        appStore.setUserActiveSubscription(true);
      }
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  @override
  void dispose() {
    LiveStream().dispose(REFRESH_lIBRARY_LIST);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Observer(
          builder: (context) => DefaultTabController(
            length: 2,
            child: Scaffold(
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      elevation: 0,
                      automaticallyImplyLeading: false,
                      expandedHeight: 120,
                      pinned: true,
                      titleSpacing: 16,
                      actions: <Widget>[],
                      leading: BackButton( style: ButtonStyle(
                        foregroundColor: MaterialStateProperty.all(Color(0xFFFFFFFF)),
                        backgroundColor: MaterialStateProperty.all(Color(0xFF876A48)), // Brown color
                        shape: MaterialStateProperty.all(
                          CircleBorder(),
                        ),
                        padding: MaterialStateProperty.all(EdgeInsets.all(12)), // Adjust size
                      )),
                      bottom: TabBar(
                        automaticIndicatorColorAdjustment: false,
                        indicatorColor: defaultPrimaryColor,
                        indicatorSize: TabBarIndicatorSize.tab,
                        unselectedLabelColor: appStore.isDarkMode ? white : blackColor,
                        labelColor: defaultPrimaryColor,
                        isScrollable: false,
                        onTap: (index) {
                          appStore.setTabBarIndex(index);
                        },
                        tabs:  [
                          Tab(text: language!.month),
                          Tab(text: language!.years),
                        ],
                      ),
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(language!.subscriptions, style: boldTextStyle()),
                        titlePadding: EdgeInsets.only(bottom: 60, left: 16),
                        centerTitle: true,
                      ),
                    )
                  ];
                },
                body: Stack(
                  children: [
                    appStore.isLoggedIn && appStore.isNetworkConnected
                        ? TabBarView(
                      children: [
                        monthlyPlans.isNotEmpty
                            ? PlanComponent(
                          list: monthlyPlans,
                          i: 0,
                          onPlanSelected: (int planId){
                            subscribe(planId);
                          },
                        )
                            : Observer(builder: (context) {
                          return NoDataWidget(
                            title: language!.noSampleBooksDownload,
                          ).visible(!appStore.isLoading && isDataLoaded);
                        }),
                        yearlyPlans.isNotEmpty
                            ? PlanComponent(
                          list: yearlyPlans,
                          i: 0,
                          onPlanSelected: (int planId){
                            subscribe(planId);
                          },
                        )
                            : NoDataWidget(
                          title: language!.noPurchasedBookAvailable,
                        ).visible(isDataLoaded && !appStore.isLoading),
                      ],
                    )
                        : TabBarView(
                      children: [
                        yearlyPlans.isNotEmpty
                            ? PlanComponent(
                          list: monthlyPlans,
                          i: 0,
                          onPlanSelected: (int planId){
                            subscribe(planId);
                          },
                        )
                            : NoDataWidget(
                          title: language!.noSampleBooksDownload,
                        ).visible(isDataLoaded && !appStore.isLoading),
                        monthlyPlans.isNotEmpty
                            ? PlanComponent(
                          list: monthlyPlans,
                          i: 0,

                        )
                            : NoDataWidget(title: language!.noPurchasedBookAvailable).visible(isDataLoaded && !appStore.isLoading)
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
        Observer(
          builder: (context) => AppLoaderWidget().visible(appStore.isLoading.validate()).center(),
        )
      ],
    );
  }
}
