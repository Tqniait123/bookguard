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

import '../../../models/plan_model.dart';
import '../../../utils/images.dart';

class PlanComponent extends StatefulWidget {
  static String tag = '/PlanComponent';

  final List<PlanModel>? list;
  final int? i;
  final bool? isSampleExits;

  final Function? onDownloadUpdate;
  final Function? onRemoveBookUpdate;

  PlanComponent({this.list, this.i, this.isSampleExits = false, this.onDownloadUpdate, this.onRemoveBookUpdate});

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
        int selected = 1;
          return Center(
            child: Container(
              // width: 300,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                gradient: widget.list![index].id == selected ? LinearGradient(
                  colors: [
                    Color(0xFFDDC69A), // Soft gold
                    Color(0xFF876A48), // Deep gold
                  ],
                  begin: Alignment.topCenter,
                  end: Alignment.bottomCenter,
                ) : null,
                color: widget.list![index].id == selected ? null : Colors.white,
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
                  if(widget.list![index].id == selected)Row(
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
                        color: widget.list![index].id == selected ? Colors.white : Colors.black,
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                  SizedBox(height: 8),
                  Text(
                    '- ${widget.list![index].duration??''} months',
                    style: TextStyle(
                      color: widget.list![index].id == selected ? Colors.white : Colors.black,
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
                      '${widget.list![index].price} L.E',
                      style: TextStyle(
                        color:widget.list![index].id == selected ? Colors.white : Colors.black,
                        fontSize: 20,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );},

    );
  }
}
