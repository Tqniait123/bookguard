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
            child: Center(
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
                  color: selected ? null : Color(0xFFEFE8E4),
                  borderRadius: BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black26,
                      blurRadius: 10,
                      offset: Offset(0, 4),
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
                    Align(
                      alignment: Alignment.center,
                      child: Text(
                        widget.list![index].name??'',
                        style: TextStyle(
                          color: selected ? Colors.white : Colors.black,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    SizedBox(height: 8),
                    Text(
                      '- ${duration}',
                      style: TextStyle(
                        color: selected ? Colors.white : Colors.black,
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
                    Align(
                      alignment: Alignment.bottomRight,
                      child: Text(
                        '${price}$defaultCurrencySymbol',
                        style: TextStyle(
                          color:selected ? Colors.white : Colors.black,
                          fontSize: 20,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          );},

    );
  }
}
