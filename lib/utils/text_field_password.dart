import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'common.dart';
import 'images.dart';

class TextFieldPassword extends StatefulWidget {
  const TextFieldPassword({super.key, required this.controller, this.onFieldSubmitted, required this.focus, this.autoFocus = false, required this.hint, this.nextFocus, this.validator});

  final TextEditingController controller;
  final FocusNode? focus;
  final FocusNode? nextFocus;
  final bool autoFocus;

  final String hint;
  final Function? onFieldSubmitted;
  final String? Function(String?)? validator;

  @override
  State<TextFieldPassword> createState() => _TextFieldPasswordState();
}

class _TextFieldPasswordState extends State<TextFieldPassword> {

  bool obscure = true;

  changeObscure(){
    obscure = !obscure;
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return AppTextField(
      isPassword: true,
      controller: widget.controller,
      obscureText: true,
      autoFocus: widget.autoFocus,
      textFieldType: TextFieldType.PASSWORD,
      enableChatGPT: false,
      focus: widget.focus,
      nextFocus: widget.nextFocus,
      suffixPasswordVisibleWidget: UnconstrainedBox(child: SvgPicture.asset(eyeSvg, height: 23, width: 23,)),
      suffixPasswordInvisibleWidget: UnconstrainedBox(child: SvgPicture.asset(closeEyeSvg, height: 20, width: 20,)),
      decoration: inputDecoration(context, hintText: widget.hint, preFixIcon: Icon(Icons.lock)
        ),
      onFieldSubmitted: (value) {
        if(widget.onFieldSubmitted != null) {
          widget.onFieldSubmitted!(context);
        }
      },
      validator: widget.validator,
    );
  }
}
