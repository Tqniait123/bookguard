import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_epub_viewer/flutter_epub_viewer.dart';
import 'package:granth_flutter/component/app_loader_widget.dart';
import 'package:granth_flutter/component/font_size_component.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/font_size_model.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../utils/constants.dart';
import '../../utils/file_common.dart';

class EPubViewerScreen extends StatefulWidget {
  final String filePath;
  final String bookName;
  final int? bookId;
  final String? lastCfi;

  EPubViewerScreen({required this.filePath, required this.bookName, this.bookId, this.lastCfi});

  @override
  State<EPubViewerScreen> createState() => _EPubViewerScreenState();
}

class _EPubViewerScreenState extends State<EPubViewerScreen> {
  late EpubController _epubReaderController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<FontSizeModel> fontSizeList = fontList();

  String cfi = '';
  String oldCfi = '';

  double textSize = 18.0;

  int selectedIndex = 1;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {
    ///open epub file
    cfi = widget.lastCfi??'';
    oldCfi = widget.lastCfi??'';
    _epubReaderController = EpubController();

    await Future.delayed(const Duration(seconds: 2), () {
      AppLoaderWidget();
    });
    _epubReaderController.addHighlight(cfi: cfi);
    _epubReaderController.display(cfi: cfi);
    setState(() {});
  }

  @override
  void dispose() {
    super.dispose();
  }

  Widget bottomSheetWidget() {
    return Column(
      children: [
        16.height,
        Container(
          padding: EdgeInsets.all(defaultRadius),
          alignment: Alignment.center,
          child: Icon(Icons.close, color: white),
          decoration: boxDecorationDefault(
            color: defaultPrimaryColor,
            shape: BoxShape.circle,
            boxShadow: [
              BoxShadow(color: Colors.transparent),
            ],
          ),
        ).onTap(
              () {
            finish(context);
          },
        ),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
            children: _epubReaderController!.getChapters().map((e) {
              print("e----${e.title}");
            return Padding(
              padding: const EdgeInsets.all(8.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    e.title.validate().trim(),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                    style: primaryTextStyle(),
                  ),
                  Divider(),
                ],
              ),
            ).onTap(() async {
              // _epubReaderController!.(
              //   index: _epubReaderController!.tableOfContents().indexOf(e),
              // );
              await 1.seconds.delay;
              finish(context);
            });
          }).toList(),
        ).paddingAll(16),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: scaffoldKey,
      appBar: appBarWidget(
        widget.bookName,
        color: context.scaffoldBackgroundColor,
        backWidget: IconButton(
          onPressed: () async {
            showModalBottomSheet(
              isScrollControlled: true,
              isDismissible: true,
              enableDrag: true,
              backgroundColor: context.cardColor,
              elevation: 2,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.only(topRight: Radius.circular(22), topLeft: Radius.circular(22)),
              ),
              context: context,
              builder: (context) {
                return DraggableScrollableSheet(
                  expand: false,
                  initialChildSize: 0.8,
                  maxChildSize: 1.0,
                  builder: (context, scrollController) {
                    return SingleChildScrollView(
                      controller: scrollController,
                      child: bottomSheetWidget(),
                    );
                  },
                );
              },
            );
          },
          icon: Icon(Icons.menu),
        ),
        actions: [
          IconButton(
            icon: Icon(Icons.font_download_outlined),
            onPressed: () async {
              bool? data = await showModalBottomSheet(
                context: context,
                isDismissible: true,
                shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(20))),
                builder: (BuildContext context) {
                  return StatefulBuilder(builder: (context, secondaryState) {
                    return FontSizeComponent(
                      fontSizeList: fontSizeList,
                      selectedIndex: selectedIndex,
                      onTap: (index) {
                        secondaryState(() {
                          selectedIndex = index;
                          textSize = fontSizeList[index].fontSize.toString().toDouble();
                        });
                      },
                    );
                  });
                },
              );
              if (data.validate()) {
                setState(() {});
              }
            },
          ),
          IconButton(
            icon: Icon(Icons.bookmark_add, color: cfi.isNotEmpty ? Colors.yellow : null,),
            onPressed: () async {

              // // _epubController.gotoEpubCfi('epubcfi(/6/6[chapter-2]!/4/2/1612)');
              // print((await _epubReaderController.getCurrentLocation()).startCfi);
              // print(cfi);
              // print((await _epubReaderController.getCurrentLocation()).endCfi);
              if(cfi != oldCfi){
                _epubReaderController.addHighlight(
                  cfi: cfi,
                );
                oldCfi = cfi;

                updateIntoDb(bookId: widget.bookId!, cfi: cfi);
              }
              setState(() {});

            },
          ),
        ],
      ),
      body: _epubReaderController != null
          ? Theme(
        data: appStore.isDarkMode ? ThemeData.dark() : ThemeData.light(),
        // child: EpubViewer(epubController: _epubReaderController, epubSource: EpubSource.fromFile(File(widget.filePath),),
        child: EpubViewer(epubController: _epubReaderController, epubSource: EpubSource.fromUrl(widget.filePath,),
          // controller: _epubReaderController!,
          // onDocumentLoaded: (document) => Center(child: CircularProgressIndicator()),
          // builders: EpubViewBuilders<DefaultBuilderOptions>(
          //   options: DefaultBuilderOptions(textStyle: TextStyle(fontSize: textSize)),
          //   chapterDividerBuilder: (_) => Divider(),
          //   loaderBuilder: (context) => Center(child: CircularProgressIndicator()),
          // ),
          // onChapterChanged: (value) async {
          //   await setValue('$LAST_BOOK_PAGE${widget.bookId}', _epubReaderController!.generateEpubCfi());
          // },
          onTextSelected: (val){
          print('va............................................l');
          print(val.selectionCfi);
          cfi = val.selectionCfi;
          },
        ),
      )
          : AppLoaderWidget().center(),
    );
  }
}
