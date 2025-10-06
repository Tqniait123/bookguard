import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
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

import '../../../network/network_utils.dart';
import '../../../utils/images.dart';
import '../../../utils/text_field_password.dart';
import '../../../widgets/custom_back_button.dart';
import '../../setting/terms_screen.dart';
import '../login_otp_screen.dart';

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
        if(e is UnVerifiedException){
          LoginOtpScreen(email: emailController.text.trim(),).launch(context);
        }
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
    final textColor = appStore.isDarkMode ? Colors.grey[400] : Color(0xFF6C7278);
    final linkColor = appStore.isDarkMode ? Colors.white : Colors.black;

    return Scaffold(
      backgroundColor: transparentColor,
      appBar: appBarWidget('', elevation: 0, color: transparentColor, backWidget:
      CustomBackButton()),
      body: Stack(
        children: [
          Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: SingleChildScrollView(
              padding: EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // SignInTopComponent(),
                  Image.asset(transparent_app_logo, height: 74, width: 74,),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      8.height,
                      Text(language!.signInToYourAccount, style: boldTextStyle(size: 32)),
                      // 8.height,
                      SignInBottomWidget(
                        title: language!.donTHaveAnAccount,
                        subTitle: language!.signUp,
                        onTap: () {
                          SignupScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                        },
                      ),
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
                      Row(
                        children: [
                          const Expanded(
                            child: Divider(
                              color: Color(0xFFEDF1F3),
                              thickness: 1,
                            ),
                          ),
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8.0),
                            child: Text(
                              'Or login with',
                              style: TextStyle(
                                color: Colors.grey[600],
                                fontSize: 14,
                              ),
                            ),
                          ),
                          const Expanded(
                            child: Divider(
                              color: Color(0xFFEDF1F3),
                              thickness: 1,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 16),

                      // Social Buttons
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          _socialButton(
                            icon: googleSvg,
                            text: 'Google',
                            onPressed: () {},
                          ),
                          const SizedBox(width: 16),
                          _socialButton(
                            icon: facebookSvg,
                            text: 'Facebook',
                            onPressed: () {},
                          ),
                        ],
                      ),
                      32.height,
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


                      40.height,
                      Center(
                        child: RichText(
                          textAlign: TextAlign.center,
                          text: TextSpan(
                            style: TextStyle(
                              fontSize: 16,
                              color: textColor,
                              fontWeight: FontWeight.w500,
                              height: 1.5,
                            ),
                            children: [
                              TextSpan(text: language!.bySigningUp),
                              TextSpan(
                                text: language!.termsOfService,
                                style: TextStyle(
                                  color: linkColor,
                                  fontWeight: FontWeight.w500,
                                ),
                                recognizer: TapGestureRecognizer()
                                  ..onTap = (){
                                    TermsScreen().launch(context);
                                  },
                              ),
                              // TextSpan(text: ' ${language!.and} '),
                              // TextSpan(
                              //   text: 'Data Processing Agreement',
                              //   style: TextStyle(
                              //     color: linkColor,
                              //     fontWeight: FontWeight.w500,
                              //   ),
                              //   recognizer: TapGestureRecognizer()
                              //     ..onTap = (){},
                              // ),
                            ],
                          ),
                        ),
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

  Widget _socialButton({
    required String icon,
    required String text,
    required VoidCallback onPressed,
  }) {
    return Expanded(
      child: SizedBox(
        height: 50,
        child: OutlinedButton.icon(
          style: OutlinedButton.styleFrom(
            side: const BorderSide(color: Color(0xFFEDF1F3)),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            // backgroundColor: Colors.white,
            foregroundColor: appStore.isDarkMode ? Colors.white : Colors.black,
          ),
          icon: SvgPicture.asset(icon),
          label: Text(
            text,
            style: const TextStyle(fontSize: 15, fontWeight: FontWeight.w500),
          ),
          onPressed: onPressed,
        ),
      ),
    );
  }
}
