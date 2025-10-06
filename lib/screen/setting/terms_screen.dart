import 'package:flutter/material.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/images.dart';
import 'package:granth_flutter/widgets/background_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../widgets/custom_back_button.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {

    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: appBarWidget(
            language!.termsConditions,
            color: transparentColor,
            titleTextStyle: boldTextStyle(color: appStore.isDarkMode ? Colors.white : Colors.black, size: 32),
            elevation: 0,
            center: true,
            backWidget: CustomBackButton()),
        body: Center(
          child: ListView(
            // crossAxisAlignment: CrossAxisAlignment.center,
            // mainAxisAlignment: MainAxisAlignment.start,
            padding: EdgeInsets.all(16),
            children: [
              40.height,

              // Text(language!.termsConditions, style: boldTextStyle(size: 24,color: context.primaryColor)),
              // 16.height,
              Text(
                TERMS_AND_CONDITIONS_TEXT,
                style: primaryTextStyle(),
                textAlign: TextAlign.justify,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
