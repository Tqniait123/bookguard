import 'package:flutter/material.dart';
import 'package:granth_flutter/main.dart';

class BackgroundWidget extends StatelessWidget {
  const BackgroundWidget({super.key, required this.child});

  final Widget child;

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
      if(!appStore.isDarkMode)  Container(
          height: MediaQuery.of(context).size.height,
          decoration: BoxDecoration(
              gradient: LinearGradient(colors: [
                Color(0xFFFEDAB0),
                Colors.white
              ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                stops: [0, 0.25]
              )
          ),
        ),
        child
      ],
    );
  }
}
