import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/component/app_loader_widget.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screen/auth/component/signin_bottom_widget.dart';
import 'package:granth_flutter/screen/auth/component/signin_top_component.dart';
import 'package:granth_flutter/screen/auth/forgot_password_screen.dart';
import 'package:granth_flutter/screen/dashboard/dashboard_screen.dart';
import 'package:granth_flutter/screen/auth/sign_up_screen.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/images.dart';
import '../../../utils/text_field_password.dart';

class MobileLoginComponent extends StatefulWidget {
  @override
  _MobileLoginComponentState createState() => _MobileLoginComponentState();
}

class _MobileLoginComponentState extends State<MobileLoginComponent> {
  final formKey = GlobalKey<FormState>();

  TextEditingController emailController = TextEditingController();
  TextEditingController passwordController = TextEditingController();

  FocusNode? emailFocusNode = FocusNode();
  FocusNode? passwordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  ///login api call
  Future<void> loginApi(BuildContext context) async {
    if (appStore.isLoading) return;

    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      Map request = {
        UserKeys.deviceId: "",
        UserKeys.email: emailController.text.trim(),
        UserKeys.password: passwordController.text.trim(),
        UserKeys.registrationId: getStringAsync(PLAYER_ID),
      };

      appStore.setLoading(true);

      await login(request).then((res) async {
        if (res.data != null) await saveUserData(res.data!);
        DashboardScreen().launch(context, isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
        toast(language!.loginSuccessfully);
      }).catchError((e) {
        appStore.setLoading(false);
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
      appBar: appBarWidget('', elevation: 0, color: context.scaffoldBackgroundColor, backWidget: BackButton(style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Color(0xFFFFFFFF)),
        backgroundColor: MaterialStateProperty.all(Color(0xFF876A48)), // Brown color
        shape: MaterialStateProperty.all(
          CircleBorder(),
        ),
        padding: MaterialStateProperty.all(EdgeInsets.all(12)), // Adjust size
      ))),
      body: Stack(
        children: [
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                children: [
                  // SignInTopComponent(),
                  Image.asset(login_book1),
                  Column(
                    children: [
                      Text(language!.login, style: boldTextStyle(size: 28)).center(),
                      8.height,
                      Text(language!.signInToContinue, style: secondaryTextStyle()),
                      32.height,
                      AppTextField(
                        controller: emailController,
                        autoFocus: false,
                        textFieldType: TextFieldType.EMAIL,
                        focus: emailFocusNode,
                        nextFocus: passwordFocusNode,
                        decoration: inputDecoration(context, hintText: language!.email, preFixIcon: Icon(Icons.email)),
                      ),
                      16.height,
                      TextFieldPassword(
                        controller: passwordController,
                        autoFocus: false,
                        focus: passwordFocusNode,
                        hint: language!.password,
                        onFieldSubmitted: (value) {
                          loginApi(context);
                        },
                      ),
                      Align(
                        alignment: Alignment.topRight,
                        child: TextButton(
                          onPressed: () {
                            ForgotPasswordScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                          },
                          child: Text(language!.lblForgotPassword, style: boldTextStyle(color: defaultPrimaryColor, size: 14)),
                        ),
                      ),
                      24.height,
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
                          width: context.width(),
                          text: language!.login,
                          textStyle: boldTextStyle(color: Colors.white),
                          color: transparentColor,
                          enableScaleAnimation: false,
                          onTap: () async {
                            loginApi(context);
                          },
                        ),
                      ),
                      32.height,
                      SignInBottomWidget(
                        title: language!.donTHaveAnAccount,
                        subTitle: language!.register,
                        onTap: () {
                          SignupScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                        },
                      )
                    ],
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
    );
  }
}
