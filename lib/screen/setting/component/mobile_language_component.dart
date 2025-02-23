import 'package:flutter/material.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/main.dart';
import 'package:nb_utils/nb_utils.dart';

class MobileLanguageComponent extends StatefulWidget {
  @override
  _MobileLanguageComponentState createState() => _MobileLanguageComponentState();
}

class _MobileLanguageComponentState extends State<MobileLanguageComponent> {
  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    //
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget("", elevation: 0, showBack: true, color: context.scaffoldBackgroundColor, backWidget: BackButton(style: ButtonStyle(
        foregroundColor: MaterialStateProperty.all(Color(0xFFFFFFFF)),
        backgroundColor: MaterialStateProperty.all(Color(0xFF876A48)), // Brown color
        shape: MaterialStateProperty.all(
          CircleBorder(),
        ),
        padding: MaterialStateProperty.all(EdgeInsets.all(12)), // Adjust size
      ))),
      body: LanguageListWidget(
        widgetType: WidgetType.LIST,
        trailing: Container(
          padding: EdgeInsets.all(2),
          decoration: boxDecorationDefault(color: defaultPrimaryColor, shape: BoxShape.circle, boxShadow: [BoxShadow(color: Colors.transparent)]),
          child: Icon(Icons.check, size: 15, color: white),
        ),
        onLanguageChange: (v) {
          appStore.setLanguage(v.languageCode!);
          setState(() {});
          finish(context, true);
        },
      ),
    );
  }
}
