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
import 'package:granth_flutter/widgets/background_widget.dart';
import 'package:granth_flutter/widgets/custom_back_button.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/app_loader_widget.dart';
import '../../component/no_data_found_widget.dart';
import '../../models/plan_model.dart';
import '../../models/subscriptio_history_model.dart';
import 'components/plan_component.dart';
import 'components/subscriptions_history_component.dart';

class SubscriptionsHistoryPage extends StatefulWidget {
  @override
  _SubscriptionsHistoryPageState createState() => _SubscriptionsHistoryPageState();
}

class _SubscriptionsHistoryPageState extends State<SubscriptionsHistoryPage> {

  List<PlanDetails> yearlyPlans = [];
  List<SubscriptionsHistory> _subscriptions = [];
  List<PlanDetails> monthlyPlans = [];
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
    await getSubscriptionsHistory().then((value) {
      _subscriptions = value.subscriptionsHistory??[];
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  // Future<void> subscribe(int planId) async {
  //   appStore.setLoading(true);
  //   await subscribeApi({'plan_id' : planId.toString()}).then((value) {
  //     toast(value.message);
  //     if(value.status == true){
  //       getData();
  //       appStore.setUserActiveSubscription(true);
  //     }
  //     setState(() {});
  //   }).catchError((e) {
  //     toast(e.toString());
  //   });
  //   appStore.setLoading(false);
  // }

  @override
  void dispose() {
    LiveStream().dispose(REFRESH_lIBRARY_LIST);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    print(_subscriptions.isEmpty);
    return BackgroundWidget(
      child: Stack(
        children: [
          Observer(
            builder: (context) => Scaffold(
              backgroundColor: transparentColor,
              body: NestedScrollView(
                headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                  return <Widget>[
                    SliverAppBar(
                      elevation: 0,
                      backgroundColor: transparentColor,
                      automaticallyImplyLeading: false,
                      expandedHeight: 120,
                      pinned: true,
                      titleSpacing: 16,
                      actions: <Widget>[],
                      leading: CustomBackButton(),
                      // bottom: TabBar(
                      //   automaticIndicatorColorAdjustment: false,
                      //   indicatorColor: defaultPrimaryColor,
                      //   indicatorSize: TabBarIndicatorSize.tab,
                      //   unselectedLabelColor: appStore.isDarkMode ? white : blackColor,
                      //   labelColor: defaultPrimaryColor,
                      //   isScrollable: false,
                      //   onTap: (index) {
                      //     appStore.setTabBarIndex(index);
                      //   },
                      //   tabs:  [
                      //     Tab(text: language!.month),
                      //     Tab(text: language!.years),
                      //   ],
                      // ),
                      flexibleSpace: FlexibleSpaceBar(
                        title: Text(language!.subscriptionHistory, style: boldTextStyle()),
                        titlePadding: EdgeInsets.only(bottom: 80, left: 16),
                        centerTitle: true,
                      ),
                    )
                  ];
                },
                body: Stack(
                  children: [
                    _subscriptions.isNotEmpty
                        ? SubscriptionsHistoryComponent(
                      list: _subscriptions,
                      i: 0,
                      onPlanSelected: (int planId){
                        // subscribe(planId);
                      },
                    )
                        : NoDataFoundWidget()
                  ],
                ),
              ),
            ),
          ),
          Observer(
            builder: (context) => AppLoaderWidget().visible(appStore.isLoading.validate()).center(),
          )
        ],
      ),
    );
  }
}
