import 'package:flutter/material.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/images.dart';
import 'package:nb_utils/nb_utils.dart';

class TermsScreen extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    print('TERMS_AND_CONDITIONS_TEXT');
    print(TERMS_AND_CONDITIONS_TEXT);
    return Scaffold(
      body: Center(
        child: ListView(
          // crossAxisAlignment: CrossAxisAlignment.center,
          // mainAxisAlignment: MainAxisAlignment.start,
          padding: EdgeInsets.all(16),
          children: [
            40.height,
            Image.asset(app_logo, alignment: Alignment.center, height: 120, width: 120).cornerRadiusWithClipRRect(defaultRadius),
            16.height,
            Text(language!.termsConditions, style: boldTextStyle(size: 24,color: context.primaryColor)),
            16.height,
            Text(
              TERMS_AND_CONDITIONS_TEXT,
              style: primaryTextStyle(),
              textAlign: TextAlign.justify,
            ),
          ],
        ),
      ),
    );
  }
}
