import 'package:flutter/material.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/images.dart';
import 'package:granth_flutter/utils/model_keys.dart';
import 'package:granth_flutter/widgets/custom_back_button.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/text_field_password.dart';

class MobileChangePasswordComponent extends StatefulWidget {
  @override
  _MobileChangePasswordComponentState createState() => _MobileChangePasswordComponentState();
}

class _MobileChangePasswordComponentState extends State<MobileChangePasswordComponent> {
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
        UserKeys.email: appStore.userEmail,
        UserKeys.oldPassword: oldPasswordController.text.trim(),
        UserKeys.newPassword: confirmPasswordController.text.trim(),
      };

      appStore.setLoading(true);

      await changePassword(request).then((res) async {
        if (res.status!) {
          finish(context);
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
      appBar: appBarWidget('', elevation: 0,color: transparentColor,
          titleTextStyle: boldTextStyle(color: appStore.isDarkMode ? Colors.white : Colors.black, size: 26), center: true, backWidget: CustomBackButton()),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          autovalidateMode: AutovalidateMode.onUserInteraction,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              40.height,
              Text(language!.createANewPassword, style: boldTextStyle(size: 32)),
              32.height,
              Text(language!.youNewPasswordMust, style: secondaryTextStyle(weight: FontWeight.w600),),
              32.height,
            TextFieldPassword(
                controller: oldPasswordController,
                focus: oldPasswordFocusNode,
                nextFocus: newPasswordFocusNode,
                hint: language!.oldPassword,
              ),
              16.height,
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
                  text: language!.submit,
                  onTap: () {
                    changePasswordApi(context);
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
