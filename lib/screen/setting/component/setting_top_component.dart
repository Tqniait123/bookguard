import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/component/cache_image_widget.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/screen/auth/edit_profile_screen.dart';
import 'package:granth_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../widgets/gradient_circle_widget.dart';

class SettingTopComponent extends StatefulWidget {
  static String tag = '/SettingTopComponent';

  @override
  SettingTopComponentState createState() => SettingTopComponentState();
}

class SettingTopComponentState extends State<SettingTopComponent> {
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
    return Observer(
      builder: (context) {
        return Column(
          children: [
            GestureDetector(
              onTap: () {
                EditProfileScreen().launch(context);
              },
              child: Row(
                crossAxisAlignment: CrossAxisAlignment.center,
                // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  appStore.userProfile.isNotEmpty
                      ? Observer(builder: (context) {
                    return GradientCircleAvatar(
                      child: ClipOval(
                        child: CachedImageWidget(
                          url: appStore.userProfile.validate(),
                          height: isWeb ? 70 : 80,
                          width: isWeb ? 70 : 80,
                          fit: BoxFit.cover,
                        ).cornerRadiusWithClipRRect(40),
                      ),
                    );
                  })
                      : Image.asset(place_holder_img, width: isWeb ? 70 : 80, height: isWeb ? 70 : 80, fit: BoxFit.cover).cornerRadiusWithClipRRect(40),

                  12.width,
                      Text(appStore.name.validate(), maxLines: 2, style: boldTextStyle(size: 32, weight: FontWeight.w700, color: appStore.isDarkMode ? Colors.white : Colors.black,)),


                ],
              ).paddingSymmetric(horizontal: 16),
            ),
            // Row(
            //   crossAxisAlignment: CrossAxisAlignment.end,
            //   children: [
            //     Text(
            //       "${language!.loggedIn}" + " " + appStore.userEmail.validate(),
            //       maxLines: 2,
            //       style: secondaryTextStyle(),
            //       overflow: TextOverflow.ellipsis,
            //     ).expand(),
            //     8.width,
            //     Container(width: 100, child: Divider(color: defaultPrimaryColor))
            //   ],
            // ).paddingSymmetric(horizontal: 16),
          ],
        );
      },
    );
  }
}
