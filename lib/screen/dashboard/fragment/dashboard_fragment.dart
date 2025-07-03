// ignore_for_file: unused_import

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/component/app_loader_widget.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/dashboard_model.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screen/dashboard/fragment/mobile_dashboard_fragment.dart';
import 'package:granth_flutter/screen/dashboard/fragment/web_fragment/dashboard_fragment_web.dart';
import 'package:granth_flutter/screen/dashboard/search_screen.dart';
import 'package:granth_flutter/utils/colors.dart';
import 'package:granth_flutter/configs.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:provider/provider.dart';

import '../../../available_provider.dart';

class DashboardFragment extends StatefulWidget {
  static String tag = '/DashboardScreen';

  @override
  DashboardFragmentState createState() => DashboardFragmentState();
}

class DashboardFragmentState extends State<DashboardFragment> {

  late Future<DashboardResponse> _dashboardFuture;

  @override
  void initState() {
    super.initState();
    _dashboardFuture = getDashboardDetails();
    init();
  }

  void init() async {
    afterBuildCreated(() {
      setStatusBarColor(transparentColor, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.dark);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }
int n= 0;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: context.scaffoldBackgroundColor,
      appBar: appBarWidget(
        language!.dashboard,
        color: defaultPrimaryColor,
        titleTextStyle: boldTextStyle(size: 24, color: Colors.white),
        showBack: false,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(Icons.search, color: Colors.white,),
            onPressed: () {
              SearchScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
            },
          ),
        ],
      ),
      body: RefreshIndicator(
        color: secondaryPrimaryColor,
        backgroundColor: defaultPrimaryColor,
        onRefresh: () async {
          setState(() {});
          return await 2.seconds.delay;
        },
        child: SnapHelperWidget<DashboardResponse>(
              future: _dashboardFuture,
              onSuccess: (data) {
                TERMS_AND_CONDITIONS_TEXT = data.termConditions??'';
                PRIVACY_POLICY_TEXT = data.privacyPolicy??'';
                appStore.subscriptionAvailable = data.subscriptionAvailable;
                ADD_CART_AVAILABLE = data.subscriptionAvailable;

                try{
                  WidgetsBinding.instance.addPostFrameCallback((_) {

appStore.setAvailableValue(subscription: data.subscriptionAvailable??'0', addCart: data.addCartAvailable??'0');
                    n++;
                    print('$n');
                  });
                }catch(e){
                  showDialog(
                    context: context,
                    builder: (context) => AlertDialog(
                      title: Text("Error"),
                      content: SingleChildScrollView(
                        child: Text(
                          e.toString(),
                          style: TextStyle(fontSize: 14),
                        ),
                      ),
                      actions: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: Text("OK"),
                        ),
                      ],
                    ),
                  );
                }

                return Responsive(
                  mobile: MobileDashboardFragment(data: data),
                  web: WebDashboardFragment(data: data),
                  tablet: MobileDashboardFragment(data: data),
                );
              },
              loadingWidget: AppLoaderWidget().center(),
            ),
      ),
    );
  }
}
