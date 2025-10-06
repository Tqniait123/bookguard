import 'dart:io';

import 'package:flutter/material.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/model_keys.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../widgets/phone_field.dart';

class MobileEditProfileComponent extends StatefulWidget {
  final File? imageFile;

  MobileEditProfileComponent({this.imageFile});

  @override
  _MobileEditProfileComponentState createState() => _MobileEditProfileComponentState();
}

class _MobileEditProfileComponentState extends State<MobileEditProfileComponent> {
  final GlobalKey<FormState> formKey = GlobalKey<FormState>();

  TextEditingController nameController = TextEditingController();
  TextEditingController usernameController = TextEditingController();
  TextEditingController emailController = TextEditingController();
  TextEditingController mobileNumberController = TextEditingController();

  FocusNode? nameFocusNode = FocusNode();
  FocusNode? userNameFocusNode = FocusNode();
  FocusNode? emailFocusNode = FocusNode();
  FocusNode? mobileNumberFocusNode = FocusNode();

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    nameController.text = appStore.name.validate();
    usernameController.text = appStore.userName.validate();
    emailController.text = appStore.userEmail.validate();
    mobileNumberController.text = appStore.userContactNumber.validate();
  }

  ///save profile api call
  Future<void> saveProfile(BuildContext context) async {
    hideKeyboard(context);
    formKey.currentState?.save();
    appStore.setLoading(true);

    Map request = {
      UserKeys.id: appStore.userId,
      UserKeys.userName: usernameController.text.trim(),
      UserKeys.name: nameController.text.trim(),
      UserKeys.email: emailController.text.trim(),
      UserKeys.dob: "",
      UserKeys.contactNumber: mobileNumberController.text.trim(),
    };

    print('widget.imageFile');
    print(widget.imageFile);
    await updateUser(request, mSelectedImage: widget.imageFile, id: appStore.userId, name: nameController.text.trim(), userName: usernameController.text.trim(), contactNumber: mobileNumberController.text.trim()).then((result) {
      appStore.setLoading(false);
      finish(context);
    }).catchError((error) {
      toast(error.toString());
      appStore.setLoading(false);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    print('widget.imageFile');
    print(widget.imageFile);
    return Stack(
      fit: StackFit.expand,
      children: [
        Container(
          margin: EdgeInsets.only(top: context.height() * .25),
          // decoration: boxDecorationWithRoundedCorners(
          //   backgroundColor: appBarBackgroundColorGlobal,
          //   borderRadius: BorderRadius.only(topLeft: Radius.circular(defaultRadius), topRight: Radius.circular(defaultRadius)),
          // ),
          child: Form(
            autovalidateMode: AutovalidateMode.onUserInteraction,
            key: formKey,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language!.name, style: TextStyle(color: appStore.isDarkMode ? Colors.grey.shade300 : Color(0xFF6C7278)),),
                            4.height,
                            AppTextField(
                              decoration: inputDecoration(context,
                                   preFixIcon: Icon(Icons.person),),
                              textFieldType: TextFieldType.NAME,
                              controller: nameController,
                              focus: nameFocusNode,
                              nextFocus: userNameFocusNode,
                            ),
                          ],
                        ),
                      ),
                      8.width,
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(language!.userName, style: TextStyle(color: appStore.isDarkMode ? Colors.grey.shade300 : Color(0xFF6C7278)),),
                            4.height,
                            AppTextField(
                              textFieldType: TextFieldType.USERNAME,
                              focus: userNameFocusNode,
                              controller: usernameController,
                              nextFocus: emailFocusNode,
                              decoration: inputDecoration(context, preFixIcon: Icon(Icons.person)),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  16.height,

                  16.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(language!.email, style: TextStyle(color: appStore.isDarkMode ? Colors.grey.shade300 : Color(0xFF6C7278)),),
                      4.height,
                      AppTextField(
                        textFieldType: TextFieldType.EMAIL,
                        focus: emailFocusNode,
                        nextFocus: mobileNumberFocusNode,
                        controller: emailController,
                        enabled: false,
                        decoration: inputDecoration(context, preFixIcon: Icon(Icons.email)),
                      ),
                    ],
                  ),
                  16.height,
                  // Column(
                  //   crossAxisAlignment: CrossAxisAlignment.start,
                  //   children: [
                  //     Text(language!.contactNumber, style: TextStyle(color: appStore.isDarkMode ? Colors.grey.shade300 : Color(0xFF6C7278)),),
                  //     4.height,
                  //     AppTextField(
                  //       textFieldType: TextFieldType.PHONE,
                  //       focus: mobileNumberFocusNode,
                  //       controller: mobileNumberController,
                  //       decoration: inputDecoration(context, preFixIcon: Icon(Icons.phone)),
                  //       onFieldSubmitted: (value) {
                  //         saveProfile(context);
                  //       },
                  //     ),
                  //   ],
                  // ),
                  16.height,
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(language!.contactNumber, style: TextStyle(color: appStore.isDarkMode ? Colors.grey.shade300 : Color(0xFF6C7278)),),
                      4.height,
                      PhoneField(
                        focus: mobileNumberFocusNode,
                        // controller: mobileNumberController,
                        initialValue: appStore.userContactNumber.validate(),
                        onSaved: (phone) => mobileNumberController.text = '${phone?.countryCode}${phone?.number}',
                        decoration: inputDecoration(context, preFixIcon: Icon(Icons.phone)),
                        onFieldSubmitted: (value) {
                          saveProfile(context);
                        },
                      ),
                    ],
                  ),
                  16.height,
                ],
              ).paddingAll(16),
            ),
          ),
        ),
        Positioned(
          bottom: 26,
          left: 16,
          right: 16,
          child: Container(
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
              text: language!.editNow,
              textStyle: boldTextStyle(color: Colors.white),
              color: defaultPrimaryColor,
              enableScaleAnimation: false,
              onTap: () {
                saveProfile(context);
              },
            ).cornerRadiusWithClipRRect(defaultRadius),
          ),
        ),
      ],
    );
  }
}
