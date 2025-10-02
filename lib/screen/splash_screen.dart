import 'package:flutter/material.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/screen/dashboard/dashboard_screen.dart';
import 'package:granth_flutter/screen/walkthrough/walkthrough_screen.dart';
import 'package:granth_flutter/utils/colors.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configs.dart';

class SplashScreen extends StatefulWidget {
  static String tag = '/SplashScreen';

  @override
  SplashScreenState createState() => SplashScreenState();
}

class SplashScreenState extends State<SplashScreen> {

  double progress = 0.0;
  @override
  void initState() {
    super.initState();
    _simulateLoading();
    init();
  }

  void _simulateLoading() {
    Future.delayed(const Duration(milliseconds: 200), () {
      if (!mounted) return;
      if (progress < 1.0) {
        setState(() {
          progress += 0.1;
        });
        _simulateLoading();
      }
    });
  }

  Future<void> init() async {
    setStatusBarColor(transparentColor, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.dark);
    await 1.seconds.delay;

    if (isMobile) {
      if (getBoolAsync(FIRST_TIME, defaultValue: true)) {
        WalkThroughScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Fade, isNewTask: true);
      } else {
        DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
      }
    } else {
      DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: defaultPrimaryColor, // dark blue
      body: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Spacer(),
          // Logo
          Image.asset(
            app_logo_white,
            // height: 100,
          ),
          const Spacer(),
          // Progress bar
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 50, vertical: 10),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(12),
              child: Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.white, width: 2),
                  borderRadius: BorderRadius.circular(10)
                ),
                child: LinearProgressIndicator(
                  value: progress,
                  borderRadius: BorderRadius.circular(10),
                  minHeight: 18,
                  backgroundColor: Colors.white,
                  valueColor: AlwaysStoppedAnimation<Color>(defaultPrimaryColor),
                ),
              ),
            ),
          ),
          Text(
            language!.loading,
            style: const TextStyle(color: Colors.white, fontSize: 12),
          ),
          const SizedBox(height: 30),
        ],
      ),
    );
  }
}
