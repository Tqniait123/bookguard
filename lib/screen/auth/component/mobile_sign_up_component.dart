import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/component/app_loader_widget.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screen/auth/component/signin_bottom_widget.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/screen/auth/component/signin_top_component.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/images.dart';
import '../../../utils/text_field_password.dart';
import '../../../widgets/custom_back_button.dart';
import '../../../widgets/phone_field.dart';
import '../../setting/terms_screen.dart';
import '../login_otp_screen.dart';

class MobileSignUpComponent extends StatefulWidget {
  @override
  _MobileSignUpComponentState createState() => _MobileSignUpComponentState();
}

class _MobileSignUpComponentState extends State<MobileSignUpComponent> {
  final formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();
  TextEditingController passwordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  FocusNode? nameFocusNode = FocusNode();
  FocusNode? userNameFocusNode = FocusNode();
  FocusNode? emailFocusNode = FocusNode();
  FocusNode? mobileNumberFocusNode = FocusNode();
  FocusNode? passwordFocusNode = FocusNode();
  FocusNode? confirmPasswordFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  ///createUser api call
  Future<void> createUserApi(BuildContext context) async {
    if (formKey.currentState!.validate()) {
      formKey.currentState!.save();
      hideKeyboard(context);

      Map request = {
        UserKeys.email: emailController.text.trim(),
        UserKeys.name: nameController.text.trim(),
        UserKeys.userName: usernameController.text.trim(),
        UserKeys.contactNumber: mobileNumberController.text.trim(),
        UserKeys.password: passwordController.text.trim(),
      };

      appStore.setLoading(true);

      await createUser(request).then((res) async {
        LoginOtpScreen(email: emailController.text.trim(), fromRegister: true,).launch(context);
        toast(res.message);
      }).catchError((e) {
        toast(e.toString());
        appStore.setLoading(false);
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
          SingleChildScrollView(
            padding: EdgeInsets.all(16),
            child: Form(
              autovalidateMode: AutovalidateMode.onUserInteraction,
              key: formKey,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
            Image.asset(transparent_app_logo, height: 74, width: 74,),
                  Text(language!.joinNow, style: boldTextStyle(size: 32)),
                  8.height,
                  // Text(language!.pleaseEnterInfoTo, style: secondaryTextStyle()),
                  SignInBottomWidget(
                    title: language!.alreadyHaveAnAccount,
                    subTitle: language!.login,
                    onTap: () {
                      finish(context);
                    },
                  ),
                  32.height,
                  AppTextField(
                    controller: nameController,
                    decoration: inputDecoration(context, hintText: language!.name, preFixIcon: Icon(Icons.person)),
                    textFieldType: TextFieldType.NAME,
                    focus: nameFocusNode,
                    nextFocus: userNameFocusNode,
                  ),
                  16.height,
                  AppTextField(
                    controller: usernameController,
                    decoration: inputDecoration(context, hintText: language!.userName, preFixIcon: Icon(Icons.person)),
                    textFieldType: TextFieldType.USERNAME,
                    focus: userNameFocusNode,
                    nextFocus: emailFocusNode,
                  ),
                  16.height,
                  PhoneField(
                    focus: mobileNumberFocusNode,
                    // controller: mobileNumberController,
                    initialValue: appStore.userContactNumber.validate(),
                    onSaved: (phone) => mobileNumberController.text = '${phone?.countryCode}${phone?.number}',
                    decoration: inputDecoration(context, hintText: language!.contactNumber,),
                    hintText: language!.contactNumber,
                  ),
                  16.height,
                  AppTextField(
                    controller: emailController,
                    decoration: inputDecoration(context, hintText: language!.email, preFixIcon: Icon(Icons.email)),
                    textFieldType: TextFieldType.EMAIL,
                    focus: emailFocusNode,
                    nextFocus: mobileNumberFocusNode,
                  ),

                  16.height,
                  TextFieldPassword(
                    controller: passwordController,
                    focus: passwordFocusNode,
                    nextFocus: confirmPasswordFocusNode,
                    hint: language!.password
                  ),
                  16.height,
                  TextFieldPassword(
                    focus: confirmPasswordFocusNode,
                    controller: confirmPasswordController,
                    hint: language!.confirmPassword,
                    onFieldSubmitted: (value) {
                      createUserApi(context);
                    },
                    validator: (value) {
                      if (value!.trim().isEmpty) return language!.confirmPasswordRequired;
                      if (value.trim().length < passwordLengthGlobal) return language!.passwordDoesnTMatch;
                      return passwordController.text == value.trim() ? null : language!.passwordDoesnTMatch;
                    },
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
                      text: language!.joinNow,
                      textStyle: boldTextStyle(color: Colors.white),
                      color: defaultPrimaryColor,
                      onTap: () {
                        createUserApi(context);
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
