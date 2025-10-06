import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screen/auth/change_password_screen.dart';
import 'package:granth_flutter/screen/auth/sign_in_screen.dart';
import 'package:granth_flutter/screen/dashboard/fragment/cart_fragment.dart';
import 'package:granth_flutter/screen/setting/choose_detail_page_variant_screen.dart';
import 'package:granth_flutter/screen/setting/component/setting_screen_bottom_component.dart';
import 'package:granth_flutter/screen/setting/component/setting_top_component.dart';
import 'package:granth_flutter/screen/setting/language_screen.dart';
import 'package:granth_flutter/screen/setting/transaction_history_screen.dart';
import 'package:granth_flutter/screen/setting/wishlist_screen.dart';
import 'package:granth_flutter/utils/colors.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/images.dart';
import 'package:granth_flutter/widgets/background_widget.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../component/app_loader_widget.dart';
import '../../../utils/common.dart';
import '../../../widgets/line_widget.dart';
import '../../setting/about_us_screen.dart';
import '../../setting/feedback_screen.dart';
import '../../setting/terms_screen.dart';
import '../../subscriptions/subscriptions_history.dart';
import '../../subscriptions/subscriptions_page.dart';

class MobileSettingFragment extends StatefulWidget {
  @override
  _MobileSettingFragmentState createState() => _MobileSettingFragmentState();
}

class _MobileSettingFragmentState extends State<MobileSettingFragment> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  void share() async {
    getPackageInfo().then((value) {
      Share.share('Share $APP_NAME with your friends.\n\n${getSocialMediaLink(LinkProvider.PLAY_STORE)}${value.packageName}');
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Stack(
        children: [
          Scaffold(
            backgroundColor: transparentColor,
            appBar: appBarWidget(
              language!.account,
              color: transparentColor,
              titleTextStyle: boldTextStyle(color: appStore.isDarkMode ? Colors.white : Colors.black, size: 32),
              elevation: 0,
              showBack: false,
              actions: [
                IconButton(
                  splashRadius: 24,
                  icon: Icon(Icons.shopping_cart_outlined),
                  onPressed: () {
                    CartFragment(isShowBack: true).launch(context);
                  },
                ).visible(appStore.isLoggedIn),
                IconButton(
                  // padding: EdgeInsets.only(right: defaultRadius),
                  splashRadius: 24,
                  icon: Icon(Icons.favorite_border),
                  onPressed: () {
                    WishListScreen().launch(context);
                  },
                ).visible(appStore.isLoggedIn),
              ],
            ),
            body: LayoutBuilder(
              builder: (context, constraint) {
                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: ConstrainedBox(
                      constraints: BoxConstraints(minHeight: constraint.maxHeight),
                      child: IntrinsicHeight(
                        child: Column(
                          children: <Widget>[
                            20.height,
                            SettingTopComponent().visible(appStore.isLoggedIn),
      
                            40.height,
      
                            SettingItemWidget(
                              title: language!.login,
                              // subTitle: language!.changeYourPassword,
                              titleTextColor: appStore.isDarkMode ? Colors.white : Colors.black,
                              onTap: () {
                                SignInScreen().launch(context);
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ).visible(!appStore.isLoggedIn),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: LineWidget(),
                            ).visible(!appStore.isLoggedIn),
                            if(appStore.subscriptionAvailable == '1')SettingItemWidget(
                              title: language!.subscriptions,
                              // subTitle: language!.subscriptions,
                              titleTextColor: appStore.isDarkMode ? Colors.white : Colors.black,
                              titleTextStyle: primaryTextStyle(weight: fontWeightBoldGlobal),
                              onTap: () {
                                appStore.isLoggedIn ? SubscriptionsPage().launch(context)  : SignInScreen().launch(context);
      
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: LineWidget(),
                            ).visible(appStore.isLoggedIn),
                            if(appStore.subscriptionAvailable == '1')SettingItemWidget(
                              title: language!.subscriptionHistory,
                              // subTitle: language!.subscriptionHistory,
                              titleTextStyle: primaryTextStyle(weight: fontWeightBoldGlobal),
                              onTap: () {
                                SubscriptionsHistoryPage().launch(context);
      
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ).visible(appStore.isLoggedIn),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: LineWidget(),
                            ),
                            SettingItemWidget(
                              title: language!.appLanguage,
                              // subTitle: language!.changeYourLanguage,
                              titleTextStyle: primaryTextStyle(weight: fontWeightBoldGlobal),
                              onTap: () async {
                                bool? hasLanguageChange = await LanguagesScreen().launch(context);
                                if (hasLanguageChange.validate()) {
                                  setState(() {});
                                }
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: LineWidget(),
                            ),
      
                            SettingItemWidget(
                              title: language!.changePassword,
                              // subTitle: language!.changeYourPassword,
                              onTap: () {
                                ChangePasswordScreen().launch(context);
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ).visible(appStore.isLoggedIn),
                            // Divider(height: 0).visible(appStore.isLoggedIn),
                            // SettingItemWidget(
                            //   title: language!.transactionHistory,
                            // //   subTitle: language!.transactionHistoryReport,
                            //   onTap: () {
                            //     TransactionHistoryScreen().launch(context);
                            //   },
                            //   trailing: IconButton(
                            //     constraints: BoxConstraints(),
                            //     padding: EdgeInsets.only(left: defaultRadius),
                            //     onPressed: () {},
                            //     splashColor: transparentColor,
                            //     highlightColor: transparentColor,
                            //     icon: Icon(Icons.monetization_on_outlined),
                            //   ),
                            // ).visible(appStore.isLoggedIn),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: LineWidget(),
                            ).visible(appStore.isLoggedIn),
      
                            SettingItemWidget(
                              title: language!.chooseDetailPageVariant,
                              // subTitle: language!.animationMadeEvenBetter,
                              onTap: () {
                                ChooseDetailPageVariantScreen().launch(context);
                              },
                              trailing: Icon(Icons.arrow_forward_ios),
                            ),
      
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: LineWidget(),
                            ),
                            SettingItemWidget(
                              title: language!.aboutApp,
                              // subTitle: language!.aboutApp,
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                AboutUsScreen().launch(context);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: LineWidget(),
                            ),
                            SettingItemWidget(
                              title: language!.feedback,
                              // subTitle: language!.feedback,
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () {
                                FeedBackScreen().launch(context);
                              },
                            ),
      
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: LineWidget(),
                            ),
                            SettingItemWidget(
                              title: language!.termsConditions,
                              // // subTitle: language!.termsConditions,
                              trailing: Icon(Icons.arrow_forward_ios),
                              onTap: () async{
                                // await commonLaunchUrl(PRIVACY_POLICY);
                                TermsScreen().launch(context);
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: LineWidget(),
                            ),
                            SettingItemWidget(
                              title: language!.appTheme,
                              // subTitle: appStore.isDarkMode ? language!.tapToEnableLightMode : language!.tapToEnableDarkMode,
                              onTap: () async {
                                if (appStore.isDarkMode) {
                                  appStore.setDarkMode(false);
                                  await setValue(IS_DARK_MODE, false);
                                } else {
                                  appStore.setDarkMode(true);
                                  await setValue(IS_DARK_MODE, true);
                                }
                                setState(() {});
                                setState(() {});
                              },
                              trailing: Container(
                                padding: EdgeInsets.only(left: defaultRadius),
                                height: 20,
                                width: 50,
                                child: Switch(
                                  value: appStore.isDarkMode,
                                  activeColor: Colors.white,
                                  activeTrackColor: Color(0xFF86A4E9),
                                  inactiveThumbColor: secondaryPrimaryColor,
                                  inactiveTrackColor: grey.withValues(alpha: 0.6),
                                  onChanged: (val) async {
                                    // appStore.setDarkMode(val);
                                    // await setValue(IS_DARK_MODE, val);
                                    if (appStore.isDarkMode) {
                                      appStore.setDarkMode(false);
                                      await setValue(IS_DARK_MODE, false);
                                    } else {
                                      appStore.setDarkMode(true);
                                      await setValue(IS_DARK_MODE, true);
                                    }
                                    setState(() {});
                                    setState(() {});
                                  },
                                ),
                              ),
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: LineWidget(),
                            ),
                            SettingItemWidget(
                              title: language!.share,
                              // subTitle: language!.share,
                              trailing: Icon(Icons.share_rounded),
                              onTap: () {
                                share();
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: LineWidget(),
                            ),
                            SettingItemWidget(
                              title: language!.rateUs,
                              // subTitle: language!.rateUs,
                              trailing: Image.asset(terms_icon, height: 24, width: 24, fit: BoxFit.fitHeight, color: appStore.isDarkMode ? Colors.white : Colors.black,),
                              onTap: () {
                                getPackageName().then((value) {
                                  String package = '';
                                  if (isAndroid) package = value;
      
                                  commonLaunchUrl(
                                    '${isAndroid ? getSocialMediaLink(LinkProvider.PLAY_STORE) : getSocialMediaLink(LinkProvider.APPSTORE)}$package',
                                    launchMode: LaunchMode.externalApplication,
                                  );
                                });
                              },
                            ),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: LineWidget(),
                            ).visible(appStore.isLoggedIn),
                            SettingItemWidget(
                              title: language!.signOut,
                              // subTitle: language!.deleteAccount,
                              titleTextColor: appStore.isDarkMode ? Color(0xFF6D7A9B) : Color(0xFF8696BB),
                              onTap: () async {
                                showConfirmDialogCustom(context, primaryColor: defaultPrimaryColor, onAccept: (c) {
                                  logout(context);
                                }, title: language!.areYouSureWantToLogout, positiveText: language!.yes, negativeText: language!.no);
                              },
                            ).visible(appStore.isLoggedIn),
                            Padding(
                              padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
                              child: LineWidget(),
                            ).visible(appStore.isLoggedIn),
                            SettingItemWidget(
                              title: language!.deleteAccount,
                              // subTitle: language!.deleteAccount,
                              titleTextColor: Colors.red,
                              // trailing: Image.asset(delete_account, height: 24, width: 24, fit: BoxFit.fitHeight, color: Colors.red,),
                              onTap: () async{
                                showConfirmDialogCustom(context, primaryColor: defaultPrimaryColor, onAccept: (c) {
                                  deleteAccount(context);
                                }, title: language!.areYouSureWantToDeleteAccount, positiveText: language!.yes, negativeText: language!.no);
      
      
                              },
                            ).visible(appStore.isLoggedIn),

                            // Spacer(),
                            // Padding(
                            //   padding: EdgeInsets.all(defaultRadius),
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
                            //       elevation: 0,
                            //       enableScaleAnimation: false,
                            //       shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: defaultPrimaryColor)),
                            //       width: context.width(),
                            //       color: transparentColor,
                            //       text: language!.signOut,
                            //       textStyle: boldTextStyle(color: Colors.white),
                            //       onTap: () async {
                            //         showConfirmDialogCustom(context, primaryColor: defaultPrimaryColor, onAccept: (c) {
                            //           logout(context);
                            //         }, title: language!.areYouSureWantToLogout, positiveText: language!.yes, negativeText: language!.no);
                            //       },
                            //     ).visible(appStore.isLoggedIn),
                            //   ),
                            // ),
                            16.height,
                            // Container(
                            //   color: defaultPrimaryColor.withValues(alpha: 0.7),
                            //   padding: EdgeInsets.all(defaultRadius),
                            //   width: context.width(),
                            //   child: Column(
                            //     children: [
                            //       Image.asset(transparent_app_logo, height: 60, width: 60),
                            //       VersionInfoWidget(prefixText: "", textStyle: boldTextStyle(color: white)),
                            //       24.height,
                            //       SizedBox(
                            //         key: UniqueKey(),
                            //         child: SettingScreenBottomComponent(),
                            //       ),
                            //       16.height,
                            //       AppButton(
                            //         elevation: 0,
                            //         enableScaleAnimation: false,
                            //         shapeBorder: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12), side: BorderSide(color: defaultPrimaryColor)),
                            //         width: context.width(),
                            //         color: white,
                            //         text: language!.logout,
                            //         textStyle: boldTextStyle(color: defaultPrimaryColor),
                            //         onTap: () async {
                            //           showConfirmDialogCustom(context, primaryColor: defaultPrimaryColor, onAccept: (c) {
                            //             logout(context);
                            //           }, title: language!.areYouSureWantToLogout, positiveText: language!.yes, negativeText: language!.no);
                            //         },
                            //       ).visible(appStore.isLoggedIn),
                            //     ],
                            //   ),
                            // ),
                          ],
                        ),
                      ),
                    ),
                  ),
                );
              },
            ),
          ),
          Observer(
            builder: (context) {
              return AppLoaderWidget().visible(appStore.isLoading).center();
            },
          )
        ],
      ),
    );
  }
}
