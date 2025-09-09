import 'package:flutter/material.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screen/auth/reset_password.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/images.dart';
import 'package:granth_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:pinput/pinput.dart';

import '../dashboard/dashboard_screen.dart';
import 'component/timer_widget.dart';


class LoginOtpScreen extends StatefulWidget {

  final String email;
  final bool fromRegister;
  LoginOtpScreen({required this.email, this.fromRegister = false});

  @override
  _LoginOtpScreenState createState() => _LoginOtpScreenState();
}

class _LoginOtpScreenState extends State<LoginOtpScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  TextEditingController otpController = TextEditingController();

  bool firstTime = true;

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  /// verify token Api
  Future<void> verifyTokenApi(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      hideKeyboard(context);
      Map request = {UserKeys.email: widget.email.trim(), UserKeys.code: otpController.text.trim()};
      appStore.setLoading(true);

      if(widget.fromRegister){
        await verifyTokenRegister(request).then((res) async {
          if (res.status!) {
            finish(context);
            finish(context);
            toast(res.message.toString());
          } else {
            toast(parseHtmlString(res.message));
          }
        }).catchError((e, s) {
          print(s);
          toast(e.toString());
        });
      }else{
        await verifyTokenLogin(request).then((res) async {
          if (res.status!) {
            // finish(context);
            if (res.data != null) await saveUserData(res.data!);
            DashboardScreen().launch(context,
                isNewTask: true, pageRouteAnimation: PageRouteAnimation.Fade);
            toast(res.message.toString());
          } else {
            toast(parseHtmlString(res.message));
          }
        }).catchError((e, s) {
          print(s);
          toast(e.toString());
        });
      }
      appStore.setLoading(false);
    }
  }

  /// verify token Api
  Future<void> sendTokenApi(BuildContext context) async {
      hideKeyboard(context);

      Map request = {UserKeys.email: widget.email.trim()};
      appStore.setLoading(true);

      await sendToken(request).then((res) async {
        if (res.status!) {
          // finish(context);
          // ResetPasswordScreen(email: widget.email.trim(),).launch(context);
          firstTime = false;
          setState((){});
          toast(res.message.toString());
        } else {
          toast(parseHtmlString(res.message));
        }
      }).catchError((e) {
        toast(e.toString());
      });
      appStore.setLoading(false);
  }

  /// verify token Api
  Future<void> resendTokenApi(BuildContext context) async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();
      hideKeyboard(context);

      Map request = {UserKeys.email: widget.email.trim()};
      appStore.setLoading(true);

      await resendTokenRegister(request).then((res) async {
        if (res.status!) {
          // finish(context);
          // ResetPasswordScreen(email: widget.email.trim(),).launch(context);
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
                  Center(child: Text(language!.verifyOtp, style: boldTextStyle(size: 28))),
                  8.height,
                  Text(language!.enterOTP, style: secondaryTextStyle(), textAlign: TextAlign.center,),
                  32.height,
                  Center(
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 16.0),
                      child: Pinput(
                        autofocus: true,
                        controller: otpController,
                        length: 4,
                        defaultPinTheme: PinTheme(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color: appStore.isDarkMode ? Colors.grey.shade900 : Colors.white,
                            borderRadius: BorderRadius.circular(defaultRadius),
                            border: Border.all(color: appStore.isDarkMode ? Colors.grey.shade800 : const Color(0xFFCED4DA)),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor.withOpacity(0.16),
                                offset: const Offset(0, 2),
                                blurRadius: 3,
                              ),
                            ],
                          ),),
                        focusedPinTheme: PinTheme(
                          width: 50,
                          height: 50,
                          decoration: BoxDecoration(
                            color:  appStore.isDarkMode ? Colors.grey.shade900 : Colors.white,
                            borderRadius: BorderRadius.circular(defaultRadius),
                            border: Border.all(color:Theme.of(context).primaryColor),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor.withOpacity(0.16),
                                offset: const Offset(0, 2),
                                blurRadius: 3,
                              ),
                            ],
                          ),),
                        submittedPinTheme: PinTheme(
                          width: 50,
                          height: 50,
                          textStyle: const TextStyle(color: Colors.white),
                          decoration: BoxDecoration(
                            color: Theme.of(context).primaryColor,
                            borderRadius: BorderRadius.circular(defaultRadius),
                            border: Border.all(color:Theme.of(context).primaryColor),
                            boxShadow: [
                              BoxShadow(
                                color: Theme.of(context).shadowColor.withOpacity(0.16),
                                offset: const Offset(0, 2),
                                blurRadius: 3,
                              ),
                            ],
                          ),),
                        // onChanged: (text) {
                        //   setState(() {
                        //     hasError = false;
                        //   });
                        //   _smsCode = text;
                        // },
                        onCompleted: (text) {
                          if (_formKey.currentState!.validate()) {
                            verifyTokenApi(context);
                          }
                        },
                      ),
                    ),
                  ),
                  20.height,
                  firstTime && !widget.fromRegister ?
                  Center(
                    child: TextButton(
                      onPressed: (){
                        sendTokenApi(context);
                      },
                      child: Text(
                        language!.sendCode,
                        style: TextStyle(fontSize: 16, color: Theme.of(context).primaryColor),
                      ),
                    ),
                  )
                      :
                  Center(
                    child: CustomTimerWidget(onResend: (){
                      resendTokenApi(context);
                    }, textColor: const Color(0xFFC1447C),),
                  ),
                  30.height,
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
                      text: language!.verifyOtp,
                      onTap: () {
                        if (_formKey.currentState!.validate()) {
                          verifyTokenApi(context);
                        }
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
