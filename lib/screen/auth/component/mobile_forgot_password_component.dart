import 'package:flutter/material.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/images.dart';
import 'package:granth_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../widgets/custom_back_button.dart';
import '../otp_screen.dart';
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
          // ResetPasswordScreen(email: emailController.text.trim(),).launch(context);
          OtpScreen(email: emailController.text.trim(),).launch(context);
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
      backgroundColor: transparentColor,
      appBar: appBarWidget('', elevation: 0, color: transparentColor, backWidget:
      CustomBackButton()),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Image.asset(forgot_password, height: context.height() * 0.35, width: context.width(), fit: BoxFit.contain),
              // 8.height,
              40.height,
              Text(language!.forgotPassword, style: boldTextStyle(size: 32)),
              32.height,
              Text(language!.justEnterTheEmail, style: secondaryTextStyle(weight: FontWeight.w600),),
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
                child:  AppButton(
                  color: transparentColor,
                  width: context.width(),
                  textStyle: boldTextStyle(color: Colors.white),
                  text: language!.sendCode,
                  onTap: () {
                    forgotPasswordApi(context);
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
