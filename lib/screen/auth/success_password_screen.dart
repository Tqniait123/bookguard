import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/images.dart';
import 'package:granth_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/text_field_password.dart';
import '../../component/app_loader_widget.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/custom_back_button.dart';

class SuccessPasswordScreen extends StatelessWidget {

  SuccessPasswordScreen();

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        // appBar: appBarWidget('', elevation: 0, color: transparentColor, backWidget:
        // CustomBackButton()),
        body: Padding(
          padding: EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              40.height,
              Center(child: Text(language!.YouHaveChangedSuccessfully, style: boldTextStyle(size: 32))),
              24.height,
              Text(language!.pleaseUseNewPassword, style: secondaryTextStyle(weight: FontWeight.w600), textAlign: TextAlign.center,),

              50.height,
              Container(
                decoration: BoxDecoration(
                  // border: Border.all(color: Color(0xFF18181B).withValues(alpha: 0.05), width: 2),
                    borderRadius: BorderRadius.circular(15),
                    color: defaultPrimaryColor,
                    boxShadow: [
                      BoxShadow(
                        color: appStore.isDarkMode
                            ? const Color(0xFF000000).withValues(alpha: 0.25)
                            : const Color(0xFF18181B).withValues(alpha: 0.05),
                        blurRadius: 2,
                        spreadRadius: 0.5,
                        offset: const Offset(0, 1),
                      ),
                      BoxShadow(
                        color: appStore.isDarkMode
                            ? const Color(0xFF2A2A2A).withValues(alpha: 0.6)
                            : const Color(0xFFEFF6FF),
                        blurRadius: appStore.isDarkMode ? 3 : 0,
                        spreadRadius: appStore.isDarkMode ? 1.5 : 4,
                        offset: const Offset(0, 0),
                      ),
                    ]
                ),
                child: AppButton(
                  color: transparentColor,
                  width: context.width(),
                  textStyle: boldTextStyle(color: Colors.white),
                  text: language!.lblContinue,
                  onTap: () {
                    finish(context);
                    finish(context);
                    finish(context);
                    finish(context);
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
