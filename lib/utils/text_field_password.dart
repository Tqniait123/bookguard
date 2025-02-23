import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../main.dart';
import 'common.dart';

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
      controller: widget.controller,
      obscureText: obscure,
      autoFocus: widget.autoFocus,
      textFieldType: TextFieldType.PASSWORD,
      focus: widget.focus,
      nextFocus: widget.nextFocus,
      decoration: inputDecoration(context, hintText: widget.hint, preFixIcon: Icon(Icons.lock)),
      onFieldSubmitted: (value) {
        if(widget.onFieldSubmitted != null) {
          widget.onFieldSubmitted!(context);
        }
      },
      validator: widget.validator,
    );
  }
}
