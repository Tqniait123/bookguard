import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:granth_flutter/component/app_scroll_behaviour.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/screen/auth/component/mobile_sign_up_component.dart';
import 'package:granth_flutter/screen/dashboard/dashboard_screen.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/screen/walkthrough/component/mobile_res_walkthrough_component.dart';
import 'package:granth_flutter/screen/walkthrough/walkthrough_screen_web.dart';
import 'package:granth_flutter/utils/colors.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/dots_indicator.dart';
import 'package:granth_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../auth/sign_in_screen.dart';
import '../auth/sign_up_screen.dart';

class WalkThroughScreen extends StatefulWidget {
  static String tag = '/WalkThroughScreen';

  @override
  WalkThroughScreenState createState() => WalkThroughScreenState();
}

class WalkThroughScreenState extends State<WalkThroughScreen> {
  PageController pageController = PageController(initialPage: 0);

  List<WalkThroughModelClass> pages = [];
  int currentIndex = 0;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    pages.add(WalkThroughModelClass(subTitle: language!.walkThrow1, image: walk_through_1, title: language!.discoverEndlessBookWorlds));
    pages.add(WalkThroughModelClass(subTitle: language!.walkThrow2, image: walk_through_2, title: language!.organizeYourReadingList));
    pages.add(WalkThroughModelClass(title: language!.connectWithBookLovers, image: walk_through_3, subTitle: language!.walkThrow3));

    setStatusBarColor(transparentColor, statusBarBrightness: Brightness.dark, statusBarIconBrightness: Brightness.dark);
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: secondaryPrimaryColor,
      body: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          // Image.asset(pages[currentIndex].image.validate(), width: double.infinity, fit: BoxFit.cover,),

          PageView.builder(
            scrollDirection: Axis.horizontal,
            scrollBehavior: AppScrollBehavior(),
            controller: pageController,
            itemCount: pages.length,
            onPageChanged: (index) {
              currentIndex = index;
              setState(() {});
            },
            itemBuilder: (BuildContext context, int index) {
              WalkThroughModelClass mData = pages[index];
              // return Responsive(
              //   mobile: MobileResWalkthroughComponent(mData: mData).paddingSymmetric(horizontal: 16),
              //   web: WebWalkthroughScreen(mData: mData).paddingSymmetric(horizontal: 16),
              //   tablet: WebWalkthroughScreen(mData: mData).paddingSymmetric(horizontal: 16),
              // );
              return Stack(
                children: [
                  Image.asset(mData.image.validate(), width: double.infinity, height: MediaQuery.of(context).size.height, fit: BoxFit.cover,),
                  Positioned(
                    bottom: 0,
                    left: 0,
                    right: 0,
                    height: MediaQuery.of(context).size.height, // adjust the shadow height
                    child: Container(
                      decoration: BoxDecoration(
                        gradient: LinearGradient(
                          begin: Alignment.bottomCenter,
                          end: Alignment.topCenter,
                          colors: [
                            Color(0xFF000000), // black
                            Color(0xFF000000).withValues(alpha: 0.2), // transparent black
                          ],
                          // stops: [0.0, 0.2], // match your screenshot (0% to 20%)
                        ),
                      ),
                    ),
                  ),
                  Padding(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        SizedBox(height: kToolbarHeight,),

                        GestureDetector(
                          onTap: () async{
                            await setValue(FIRST_TIME, false);
                            DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                          },
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.end,
                            children: [
                            Text('skip', style: TextStyle(color: Colors.white),),
                            4.width,
                            Icon(Icons.arrow_forward_ios, color: Colors.white, size: 15,)
                          ],),
                        ),
                        Spacer(),
                        Text(mData.title.validate(), style: boldTextStyle(size: 30, color: Colors.white)),
                        8.height,
                        Text(mData.subTitle.validate(), style: secondaryTextStyle(size: 10, color: Colors.white), softWrap: true),
                        24.height,
                        if(currentIndex < 2)Container(
                          padding: EdgeInsets.all(2),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(15),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFF18181B).withValues(alpha: 0.05), width: 2),
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: AppButton(
                              enableScaleAnimation: false,
                              color: Colors.transparent,
                              width: double.infinity,
                              text: currentIndex == 2 ? language!.getStarted : language!.next,
                              textStyle: boldTextStyle(color: Colors.black),
                              onTap: () async {
                                if (currentIndex == 2) {
                                  await setValue(FIRST_TIME, false);
                                  DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                                } else {
                                  pageController.nextPage(duration: 500.milliseconds, curve: Curves.linearToEaseOut);
                                }
                              },
                            ),
                          ),
                        ),
                        if(currentIndex == 2)...[
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(

                                border: Border.all(color: Color(0xFF18181B).withValues(alpha: 0.05), width: 2),
                                borderRadius: BorderRadius.circular(15),
                                color: defaultPrimaryColor
                              ),
                              child: AppButton(
                                enableScaleAnimation: false,
                                color: Colors.transparent,
                                width: double.infinity,
                                text: language!.dashboard,
                                textStyle: boldTextStyle(color: Colors.white),
                                onTap: () async {
                                    await setValue(FIRST_TIME, false);
                                    DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                                },
                              ),
                            ),
                          ),
                          8.height,
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(

                                border: Border.all(color: Color(0xFF18181B).withValues(alpha: 0.05), width: 2),
                                borderRadius: BorderRadius.circular(15),
                                color: defaultPrimaryColor
                              ),
                              child: AppButton(
                                enableScaleAnimation: false,
                                color: Colors.transparent,
                                width: double.infinity,
                                text: language!.login,
                                textStyle: boldTextStyle(color: Colors.white),
                                onTap: () async {
                                    await setValue(FIRST_TIME, false);
                                    SignInScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                                },
                              ),
                            ),
                          ),
                          8.height,
                          Container(
                            padding: EdgeInsets.all(2),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(15),
                            ),
                            child: Container(
                              decoration: BoxDecoration(
                                border: Border.all(color: Color(0xFF18181B).withValues(alpha: 0.05), width: 2),
                                borderRadius: BorderRadius.circular(15),
                              ),
                              child: AppButton(
                                enableScaleAnimation: false,
                                color: Colors.transparent,
                                width: double.infinity,
                                text: language!.register,
                                textStyle: boldTextStyle(color: Colors.black),
                                onTap: () async {
                                    await setValue(FIRST_TIME, false);
                                    SignupScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
                                },
                              ),
                            ),
                          )
                        ],
                        16.height,
                      ],
                    ),
                  ),
                ],
              );
            },
          ),

          // Positioned(
          //   bottom: 40,
          //   left: 30,
          //   child: DotsIndicator(
          //     controller: pageController,
          //     itemCount: pages.length,
          //     currentIndex: currentIndex,
          //     activeText: whiteColor,
          //     deActiveText: blackColor,
          //     color: defaultPrimaryColor,
          //     length: 27,
          //     colorDisable: grey.withValues(alpha: 0.1),
          //     // isCircle: true,
          //     onPageSelected: (int value) {
          //       //
          //     },
          //   ),
          // ),
          // Positioned(
          //   bottom: 26,
          //   right: 30,
          //   child: Container(
          //     decoration: BoxDecoration(
          //       gradient: LinearGradient(
          //         colors: [defaultPrimaryColor, Color(0xffD2BB8F)],
          //         begin: Alignment.topRight,
          //         end: Alignment.bottomRight,
          //       ),
          //       borderRadius: BorderRadius.circular(15),
          //     ),
          //     child: AppButton(
          //       enableScaleAnimation: false,
          //       color: Colors.transparent,
          //       text: currentIndex == 2 ? language!.getStarted : language!.next,
          //       textStyle: boldTextStyle(color: whiteColor),
          //       onTap: () async {
          //         if (currentIndex == 2) {
          //           await setValue(FIRST_TIME, false);
          //           DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
          //         } else {
          //           pageController.nextPage(duration: 500.milliseconds, curve: Curves.linearToEaseOut);
          //         }
          //       },
          //     ),
          //   ),
          // ),
          // Padding(
          //   padding: const EdgeInsets.only(top: 40),
          //   child: Row(
          //     mainAxisAlignment: currentIndex != 0 ? MainAxisAlignment.spaceBetween : MainAxisAlignment.end,
          //     children: [
          //       if(currentIndex != 0)Align(alignment: Alignment.topLeft, child:
          //       IconButton(onPressed: (){
          //         print('=========');
          //         pageController.previousPage(duration: 500.milliseconds, curve: Curves.linearToEaseOut);
          //
          //       }, icon: Container(
          //         padding: EdgeInsets.all(8),
          //         decoration: BoxDecoration(shape: BoxShape.circle,
          //             color: defaultPrimaryColor),
          //         child: Icon(Icons.arrow_back, color: Colors.white,),
          //       ))
          //       ),
          //       Align(alignment: Alignment.topRight, child: Image.asset(small_logo.validate())),
          //
          //     ],
          //   ),
          // ),
        ],
      ),
    );
  }
}
