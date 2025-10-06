import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screen/auth/success_password_screen.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/images.dart';
import 'package:granth_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/text_field_password.dart';
import '../../component/app_loader_widget.dart';
import '../../widgets/background_widget.dart';
import '../../widgets/custom_back_button.dart';

class ResetPasswordScreen extends StatefulWidget {

  final String email;

  ResetPasswordScreen({required this.email});

  @override
  _ResetPasswordScreenState createState() => _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends State<ResetPasswordScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode oldPasswordFocusNode = FocusNode();
  FocusNode newPasswordFocusNode = FocusNode();
  FocusNode confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  ///change password api call
  Future<void> changePasswordApi(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      hideKeyboard(context);

      Map request = {
        UserKeys.email: widget.email,
        UserKeys.password: confirmPasswordController.text.trim(),
      };

      appStore.setLoading(true);

      await restPassword(request).then((res) async {
        if (res.status!) {
          SuccessPasswordScreen().launch(context, );
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
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: appBarWidget('', elevation: 0, color: transparentColor, backWidget:
        CustomBackButton()),
        body: Stack(
          children: [
            SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Form(
                key: _formKey,
                autovalidateMode: AutovalidateMode.onUserInteraction,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    40.height,
                    Text(language!.resetPassword, style: boldTextStyle(size: 32)),
                    32.height,
                    Text(language!.createYourNewPassword, style: secondaryTextStyle(weight: FontWeight.w600),),
                    32.height,
                    // TextFieldPassword(
                    //   controller: oldPasswordController,
                    //   focus: oldPasswordFocusNode,
                    //   nextFocus: newPasswordFocusNode,
                    //   hint: language!.oldPassword,
                    // ),
                    // 16.height,
                    TextFieldPassword(
                      controller: newPasswordController,
                      focus: newPasswordFocusNode,
                      nextFocus: confirmPasswordFocusNode,
                      hint:  language!.newPassword,
                    ),
                    16.height,
                    TextFieldPassword(
                      controller: confirmPasswordController,
                      focus: confirmPasswordFocusNode,
                      hint: language!.confirmPassword,
                      validator: (val) {
                        if (val!.isEmpty) return language!.thisFieldIsRequired;
                        if (val != newPasswordController.text) return language!.passwordMustBeSame;
                        return null;
                      },
                      onFieldSubmitted: (value) {
                        changePasswordApi(context);
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
                      child: AppButton(
                        color: transparentColor,
                        width: context.width(),
                        textStyle: boldTextStyle(color: Colors.white),
                        text: language!.confirmNewPassword,
                        onTap: () {
                          changePasswordApi(context);
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Observer(
              builder: (context) {
                return AppLoaderWidget().visible(appStore.isLoading).center();
              },
            )
          ],
        ),
      ),
    );
  }
}
