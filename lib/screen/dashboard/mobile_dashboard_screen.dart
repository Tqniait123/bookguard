import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/screen/auth/sign_in_screen.dart';
import 'package:granth_flutter/screen/dashboard/fragment/cart_fragment.dart';
import 'package:granth_flutter/screen/dashboard/fragment/dashboard_fragment.dart';
import 'package:granth_flutter/screen/dashboard/fragment/library_fragment.dart';
import 'package:granth_flutter/screen/dashboard/fragment/setting_fragment.dart';
import 'package:granth_flutter/utils/colors.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/images.dart';
import 'package:granth_flutter/utils/string_extensions.dart';
import 'package:granth_flutter/widgets/background_widget.dart';
import 'package:nb_utils/nb_utils.dart';

class MobileDashboardScreen extends StatefulWidget {
  @override
  _MobileDashboardScreenState createState() => _MobileDashboardScreenState();
}

class _MobileDashboardScreenState extends State<MobileDashboardScreen> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return BackgroundWidget(
        child: Scaffold(
          backgroundColor: transparentColor,
          body: [
            DashboardFragment(),
            if(appStore.addCartAvailable == '1')appStore.isLoggedIn ? CartFragment() : SignInScreen(),
            LibraryFragment(),
            SettingFragment(),
          ][appStore.bottomNavigationBarIndex],
          bottomNavigationBar: Container(
            decoration: BoxDecoration(
              boxShadow: [
                BoxShadow(
                  color: Color(0xFF020F69).withValues(alpha: 0.1),
                  offset: Offset(0, -20),
                  blurRadius: 50,
                  spreadRadius: 0
                )

              ]
            ),
            child: Stack(
              children: [
                NavigationBarTheme(
                  data: NavigationBarThemeData(
                    backgroundColor: !appStore.isDarkMode ? Color(0xFFFFFFFF).withValues(alpha: 0.95) : Colors.grey.shade900,
            labelTextStyle: WidgetStateProperty.resolveWith<TextStyle>(
                  (states) {
                if (states.contains(WidgetState.selected)) {
                  return TextStyle(
                    color: defaultPrimaryColor, // selected label color
                    fontSize: 12,
                    fontWeight: FontWeight.bold,
                  );
                }
                return TextStyle(
                  color: appStore.isDarkMode ? Colors.grey.shade400 : Colors.grey.shade600, // unselected label color
                  fontSize: 12,
                );
              },
            ),

                  ),

                  child: NavigationBar(
                    selectedIndex: appStore.bottomNavigationBarIndex,
                    labelBehavior: NavigationDestinationLabelBehavior.alwaysShow,
                    indicatorColor: Colors.transparent,
                    height: 65,
                    destinations: [
                      NavigationDestination(
                        icon: SvgPicture.asset(home_iconSvg),
                        selectedIcon: SvgPicture.asset(home_icon1Svg),
                        label: language!.dashboard,
                      ),
                      if(appStore.addCartAvailable == '1')NavigationDestination(
                        icon: SvgPicture.asset(bag_iconSvg),
                        selectedIcon: SvgPicture.asset(bag_icon1Svg),
                        label: language!.cart,
                      ),
                      NavigationDestination(
                        icon: SvgPicture.asset(library_iconSvg),
                        selectedIcon: SvgPicture.asset(library_icon1Svg),
                        label: language!.library,
                      ),
                      NavigationDestination(
                        icon: SvgPicture.asset(profile_iconSvg),
                        selectedIcon: SvgPicture.asset(profile_icon1Svg),
                        label: language!.account,
                      ),
                    ],
                    onDestinationSelected: (index) {
                      appStore.bottomNavigationBarIndex = index;
                      if (index == 1) {
                        LiveStream().emit(REFRESH_lIBRARY_LIST);
                      }
                      paymentMode = '';
                      setState(() {});
                    },
                  ),
                ),
                Container(
                  height: 2,
                  decoration: BoxDecoration(
                    gradient: LinearGradient(
                      colors: [
                        defaultPrimaryColor.withValues(alpha: 0.1),
                        defaultPrimaryColor.withValues(alpha: 0.95),
                        defaultPrimaryColor.withValues(alpha: 0.1),
                      ],
                      begin: Alignment.centerLeft,
                      end: Alignment.centerRight,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      );
    });
  }
}
