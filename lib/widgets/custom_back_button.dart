import 'package:flutter/material.dart';
import 'package:granth_flutter/main.dart';

class CustomBackButton extends StatelessWidget {
  const CustomBackButton({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: GestureDetector(
        onTap: () {
          Navigator.maybePop(context);
        },
        child: Container(
          width: 48,
          height: 48,
          decoration: BoxDecoration(
              borderRadius: BorderRadius.only(topLeft: Radius.circular(25), bottomRight: Radius.circular(25), bottomLeft: Radius.circular(25), topRight: Radius.circular(12), ),
              color: appStore.isDarkMode ? Colors.grey.shade900 : Colors.white,
              border: Border(bottom: BorderSide(color: Color(0xFFF6BB39), width: 2))
          ),
          child: Icon(
            Icons.arrow_back,
            color: appStore.isDarkMode ? Colors.white : Colors.black,
            size: 24,
          ),
        ),
      ),
    );
  }
}
