import 'dart:io';

import 'package:flutter/material.dart';
import 'package:granth_flutter/component/ink_well_widget.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/downloaded_book.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/file_common.dart';
import 'package:granth_flutter/utils/permissions.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:permission_handler/permission_handler.dart';

import '../../../configs.dart';
import '../../../models/plan_model.dart';
import '../../../utils/images.dart';

class PlanComponent extends StatefulWidget {
  static String tag = '/PlanComponent';

  final List<PlanDetails>? list;
  final int? i;
  final Function(int id)? onPlanSelected;

  PlanComponent({this.list, this.i, this.onPlanSelected});

  @override
  PlanComponentState createState() => PlanComponentState();
}

class PlanComponentState extends State<PlanComponent> {
  String finalFilePath = '';
  String fileName = '';

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

    return ListView.separated(
      padding: EdgeInsets.all(12),
      itemCount: widget.list?.length??0,
      separatorBuilder: (context, index)=> SizedBox(height: 10,),
      itemBuilder: (context, index){
        bool selected = widget.list![index].myPlan != null ? true : false;
        final price = widget.list![index].myPlan?.price?? widget.list![index].price;
        final duration = widget.list![index].myPlan?.duration?? widget.list![index].durationString;

          return GestureDetector(
            child: Center(
              child: Container(
                padding: EdgeInsets.all(1),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(5),
                  gradient: LinearGradient(
                    colors: [
                      defaultPrimaryColor.withValues(alpha: 0.1),
                      defaultPrimaryColor.withValues(alpha: 0.95),
                      defaultPrimaryColor.withValues(alpha: 0.1),
                    ],
                    begin: Alignment.centerLeft,
                    end: Alignment.centerRight,
                  ),
                ),
                child: Container(
                  // width: 300,
                  padding: EdgeInsets.all(16),
                  decoration: BoxDecoration(
                    gradient:selected ? LinearGradient(
                      colors: [
                        Color(0xFFDDC69A), // Soft gold
                        Color(0xFF876A48), // Deep gold
                      ],
                      begin: Alignment.topCenter,
                      end: Alignment.bottomCenter,
                    ) : null,
                    color: selected ? null : (appStore.isDarkMode ? Colors.grey.shade900 : Colors.white),
                    borderRadius: BorderRadius.circular(5),
                    boxShadow: [
                      BoxShadow(
                        color:defaultPrimaryColor.withValues(alpha: 0.16),
                        blurRadius: 80,
                        spreadRadius: 0,
                        offset: Offset(0, -20),
                      ),
                    ],
                    border: Border.all(color: Color(0xFFEFEFEF))
                  ),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      if(selected)Row(
                        children: [
                          Image.asset(selected_plan),
                          Spacer(),
                        ],
                      ),
                      SizedBox(height: 8),
                     Text(
                          widget.list![index].name??'',
                          style: TextStyle(
                            color: selected ? Colors.white : defaultPrimaryColor,
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      SizedBox(height: 8),
                      Row(
                        children: [
                          Text(
                              '${price}$defaultCurrencySymbol ',
                              style: TextStyle(
                                color:selected ? Colors.white : defaultPrimaryColor,
                                fontSize: 32,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          // Text(
                          //     '/ ${widget.i == 0 ? language!.month : language!.year}',
                          //     style: TextStyle(
                          //       color:appStore.isDarkMode ? Colors.white : (selected ? Colors.white : Color(0xFFA4A5AA)),
                          //       fontSize: 16,
                          //       fontWeight: FontWeight.w400,
                          //     ),
                          //   ),
                        ],
                      ),
                      8.height,
                      Divider(color: appStore.isDarkMode ? Colors.grey.shade800 : (selected ? Colors.white : Color(0xFFECEDF1)),),
                      8.height,
                      Text(
                        '- ${duration}',
                        style: TextStyle(
                          color: selected ? Colors.white : defaultPrimaryColor,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      // SizedBox(height: 8),
                      // Column(
                      //   crossAxisAlignment: CrossAxisAlignment.start,
                      //   children: [
                      //     Text(
                      //       '- Access to essential features.',
                      //       style: TextStyle(color: Colors.white70, fontSize: 14),
                      //     ),
                      //     Text(
                      //       '- Limited storage (5GB).',
                      //       style: TextStyle(color: Colors.white70, fontSize: 14),
                      //     ),
                      //     Text(
                      //       '- Email support.',
                      //       style: TextStyle(color: Colors.white70, fontSize: 14),
                      //     ),
                      //     Text(
                      //       '- Monthly analytics report.',
                      //       style: TextStyle(color: Colors.white70, fontSize: 14),
                      //     ),
                      //   ],
                      // ),
                      SizedBox(height: 16),

                      GestureDetector(
                        onTap: (){

                          if(widget.onPlanSelected != null && widget.list![index].myPlan == null) {
                            if(appStore.userActiveSubscription){
                              toast(language!.youAlreadySubscribed);
                              return;
                            }
                            showConfirmDialogCustom(context, cancelable: false, primaryColor: defaultPrimaryColor, onCancel: (_){
                              finish(context);
                            }, onAccept: (c) {
                              widget.onPlanSelected!(widget.list![index].id??0);
                            }, title: language!.areYouSureWantToSubscribe, positiveText: language!.yes, negativeText: language!.no);

                          }
                        },
                        child: Container(
                          width: double.infinity,
                          padding: EdgeInsets.symmetric(vertical: 20),
                          decoration: BoxDecoration(
                            color: appStore.isDarkMode ? Colors.grey.shade800 : Color(0xFFF6F6F9),
                            borderRadius: BorderRadius.circular(61),
                          ),
                          child: Center(child: Text(language!.subscribeNow, style: TextStyle(fontSize: 18, fontWeight: FontWeight.w700, color: defaultPrimaryColor),)),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            ),
          );},

    );
  }
}
