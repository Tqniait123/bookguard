import 'package:flutter/material.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/images.dart';
import 'package:granth_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../reset_password.dart';

class MobileForgotPasswordComponent extends StatefulWidget {
  @override
  _MobileForgotPasswordComponentState createState() => _MobileForgotPasswordComponentState();
}

class _MobileForgotPasswordComponentState extends State<MobileForgotPasswordComponent> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  /// Forgot Password Api
  Future<void> forgotPasswordApi(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      hideKeyboard(context);

      Map request = {UserKeys.email: emailController.text.trim()};
      appStore.setLoading(true);

      await forgotPassword(request).then((res) async {
        if (res.status!) {
          // finish(context);
          ResetPasswordScreen(email: emailController.text.trim(),).launch(context);
          toast(res.message.toString());
        } else {
          toast(parseHtmlString(res.message));
        }
      }).catchError((e) {
        toast(e.toString());
      });
      appStore.setLoading(false);
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("", elevation: 0, backWidget: BackButton(style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Color(0xFFFFFFFF)),
        backgroundColor: MaterialStateProperty.all(Color(0xFF876A48)), // Brown color
        shape: MaterialStateProperty.all(
          CircleBorder(),
        ),
        padding: MaterialStateProperty.all(EdgeInsets.all(12)), // Adjust size
      ))),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: <Widget>[
            Form(
              key: _formKey,
              autovalidateMode: AutovalidateMode.onUserInteraction,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Image.asset(forgot_password, height: context.height() * 0.35, width: context.width(), fit: BoxFit.contain),
                  8.height,
                  Center(child: Text(language!.forgotPassword, style: boldTextStyle(size: 28))),
                  8.height,
                  Text(language!.justEnterTheEmail, style: secondaryTextStyle(), textAlign: TextAlign.center,),
                  32.height,
                  AppTextField(
                    controller: emailController,
                    textFieldType: TextFieldType.EMAIL,
                    decoration: inputDecoration(context, hintText: language!.email, preFixIcon: Icon(Icons.email)),
                    onFieldSubmitted: (value) {
                      forgotPasswordApi(context);
                    },
                  ),
                  50.height,
                  Container(
                    decoration: BoxDecoration(
                      gradient: LinearGradient(
                        colors: [defaultPrimaryColor, Color(0xffD2BB8F)],
                        begin: Alignment.topRight,
                        end: Alignment.bottomRight,
                      ),
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child:  AppButton(
                      color: transparentColor,
                      width: context.width(),
                      textStyle: boldTextStyle(color: Colors.white),
                      text: language!.reset,
                      onTap: () {
                        forgotPasswordApi(context);
                      },
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
