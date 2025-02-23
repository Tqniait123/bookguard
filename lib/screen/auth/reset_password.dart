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
          finish(context);
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
      appBar: appBarWidget("", elevation: 0, backWidget: BackButton(style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Color(0xFFFFFFFF)),
        backgroundColor: MaterialStateProperty.all(Color(0xFF876A48)), // Brown color
        shape: MaterialStateProperty.all(
          CircleBorder(),
        ),
        padding: MaterialStateProperty.all(EdgeInsets.all(12)), // Adjust size
      ))),
      body: Stack(
        children: [
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Column(
              children: <Widget>[
                Image.asset(change_password, height: context.height() * 0.35, width: context.width(), fit: BoxFit.contain),
                Form(
                  key: _formKey,
                  autovalidateMode: AutovalidateMode.onUserInteraction,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      16.height,
                      Center(child: Text(language!.createANewPassword, style: boldTextStyle(size: 28))),
                      // 8.height,
                      // Text(language!.youNewPasswordMust, style: secondaryTextStyle(), textAlign: TextAlign.center,),
                      16.height,
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
                          gradient: LinearGradient(
                            colors: [defaultPrimaryColor, Color(0xffD2BB8F)],
                            begin: Alignment.topRight,
                            end: Alignment.bottomRight,
                          ),
                          borderRadius: BorderRadius.circular(15),
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
              ],
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
