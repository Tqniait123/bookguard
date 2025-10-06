import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:granth_flutter/main.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'dart:ui' as ui;

import 'package:intl_phone_field/phone_number.dart';
import 'package:nb_utils/nb_utils.dart';

import '../configs.dart';

class PhoneField extends StatelessWidget {
  final Function(String code)? onCodeChanged;
  final String? hintText;
  final String? invalidNumberMessage;
  final String? labelText;
  final String? initialCode;
  final String? initialValue;
  final double? fontSize;
  final FormFieldSetter<PhoneNumber>? onSaved;
  final TextInputType? keyboardType;
  final List<TextInputFormatter>? inputFormatters;
  final Color? fillColor;
  final Color? hintColor;
  final bool readOnly;
  final bool above;
  final FontWeight? fontWeight;
  final TextEditingController? controller;
  final FocusNode? focus;
  final Function(String)? onFieldSubmitted;
  final InputDecoration? decoration;
  final Color? borderColor;
  final double? borderRadius;

  const PhoneField({
    Key? key,
    this.onCodeChanged,
    this.hintText,
    this.invalidNumberMessage,
    this.fillColor,
    this.initialCode,
    this.fontWeight,
    this.fontSize,
    this.hintColor,
    this.readOnly = false,
    this.above = false,
    this.labelText,
    this.keyboardType,
    this.inputFormatters,
    this.onSaved,
    this.initialValue,
    this.controller,
    this.focus,
    this.onFieldSubmitted,
    this.decoration,
    this.borderColor,
    this.borderRadius,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final isDark = Theme.of(context).brightness == Brightness.dark;

    return Stack(
      children: [
        IntlPhoneField(
          invalidNumberMessage: invalidNumberMessage,
          focusNode: focus,
          pickerDialogStyle: PickerDialogStyle(
            searchFieldInputDecoration: InputDecoration(
              hintText: language!.searchPlaceholder,
              filled: true,
              fillColor: appStore.isDarkMode ? Colors.grey.shade900 : Colors.white,
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(8),
                borderSide: BorderSide.none,
              ),
            ),
            backgroundColor: appStore.isDarkMode ? Colors.grey.shade900 : Colors.white,
            countryCodeStyle: TextStyle(
              color: appStore.isDarkMode ? Colors.white : Colors.black,
            ),
            countryNameStyle: TextStyle(
              color: appStore.isDarkMode ? Colors.white70 : Colors.black87,
            ),
            listTileDivider: Divider(
              color: appStore.isDarkMode ? Colors.white.withOpacity(0.1) : Colors.grey.withOpacity(0.2),
            ),
          ),
          flagsButtonMargin: const EdgeInsets.only(left: 12, right: 8),
          flagsButtonPadding: EdgeInsets.zero,
          languageCode: appStore.selectedLanguageCode,
          initialCountryCode: initialCode ?? 'EG',
          autovalidateMode: AutovalidateMode.onUserInteraction,
          textAlign: Directionality.of(context) == ui.TextDirection.ltr ? TextAlign.left : TextAlign.right,
          dropdownTextStyle: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: fontWeight ?? FontWeight.w400,
            fontSize: fontSize,
            color: isDark ? Colors.white.withOpacity(0.3) : Colors.grey.withOpacity(0.5),
            fontFamily: appStore.selectedLanguageCode == 'en' ? 'Poppin' : 'Almarai',
          ),
          onSaved: onSaved,
          onChanged: (phone) {
            print('$phone');
            print(phone.countryCode.substring(1));
            if (onCodeChanged != null) {
              onCodeChanged!(phone.countryCode.substring(1));
            }
          },
          onSubmitted: (s) {
            if (onFieldSubmitted != null) onFieldSubmitted!.call(s);
          },
          initialValue: initialValue,
          inputFormatters: inputFormatters,
          dropdownDecoration: BoxDecoration(
            border: Border(
              right: BorderSide(
                color: isDark ? Colors.white.withOpacity(0.3) : Colors.grey.withOpacity(0.5),
                width: 1,
              ),
            ),
          ),
          showDropdownIcon: true,
          dropdownIconPosition: IconPosition.trailing,
          dropdownIcon: Icon(
            Icons.keyboard_arrow_down,
            color: isDark ? Colors.white.withOpacity(0.7) : Colors.grey[600],
            size: 20,
          ),
          style: Theme.of(context).textTheme.bodyMedium?.copyWith(
            fontWeight: fontWeight ?? FontWeight.w400,
            fontSize: fontSize,
            color: Colors.red,
            fontFamily: appStore.selectedLanguageCode == 'en' ? 'Poppin' : 'Almarai',
          ),
          decoration: decoration ?? InputDecoration(
            contentPadding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
            hintText: hintText,
            labelText: above ? null : labelText,
            filled: true,
            fillColor: fillColor ?? Theme.of(context).colorScheme.background,
            hintStyle: TextStyle(
              color: hintColor,
              fontWeight: FontWeight.w400,
            ),
            counterText: '',
            enabledBorder: OutlineInputBorder(
              borderRadius: radius(borderRadius ?? 10),
              borderSide: BorderSide(
                  color: borderColor ?? (appStore.isDarkMode ? Color(0xFF3A3F44) : Color(0xFFD3D3D5)),
                  width: 0.0
              ),
            ),
            disabledBorder: OutlineInputBorder(
              borderRadius: radius(borderRadius ?? 10),
              borderSide: BorderSide(
                  color: borderColor ?? (appStore.isDarkMode ? Color(0xFF3A3F44) : Color(0xFFD3D3D5)),
                  width: 0.0
              ),
            ),
            focusedErrorBorder: OutlineInputBorder(
              borderRadius: radius(borderRadius ?? 10),
              borderSide: BorderSide(color: Colors.red, width: 0.0),
            ),
            errorBorder: OutlineInputBorder(
              borderRadius: radius(borderRadius ?? 10),
              borderSide: BorderSide(color: Colors.red, width: 1.0),
            ),
            errorMaxLines: 2,
            errorStyle: primaryTextStyle(color: Colors.red, size: 12),
            focusedBorder: OutlineInputBorder(
              borderRadius: radius(borderRadius ?? 10),
              borderSide: BorderSide(color: defaultPrimaryColor, width: 0.0),
            ),
          ),
          enabled: true,
          readOnly: readOnly,
          validator: (value) {
            String pattern = r'(^(?:[+0]9)?[0-9]{10,12}$)';
            RegExp regExp = RegExp(pattern);
            if (value == null || value.number.isEmpty) {
              return language!.phoneValidation;
            } else if (!regExp.hasMatch(value.number)) {
              return language!.phoneInvalid;
            }
            return null;
          },
        ),
      ],
    );
  }
}