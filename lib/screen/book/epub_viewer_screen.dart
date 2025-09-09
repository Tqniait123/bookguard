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

import '../../models/book_mark_module.dart';
import '../../network/rest_apis.dart';
import '../../utils/constants.dart';
import '../../utils/file_common.dart';
import 'package:intl/intl.dart';

import 'component/bookmark_colorpicker.dart';

class EPubViewerScreen extends StatefulWidget {
  final String filePath;
  final String bookName;
  final int? bookId;
  final bool? canReview;
  final String? lastCfi;

  EPubViewerScreen({
    required this.filePath,
    required this.bookName,
    this.bookId,
    this.lastCfi, this.canReview
  });

  @override
  State<EPubViewerScreen> createState() => _EPubViewerScreenState();
}

class _EPubViewerScreenState extends State<EPubViewerScreen> {
  late EpubController _epubReaderController;
  final scaffoldKey = GlobalKey<ScaffoldState>();
  List<FontSizeModel> fontSizeList = fontList();

  String cfi = '';
  String oldCfi = '';
  String selectedText = '';
  String selectedCfi = '';

  double textSize = 18.0;
  int selectedIndex = 1;
  int _currentPage = 0;
  List<String> _openedPages= [];
  bool _canReview= false;

  @override
  void initState() {
    init();
    super.initState();
  }

  void init() async {

    cfi = widget.lastCfi ?? '';
    oldCfi = widget.lastCfi ?? '';
    _canReview = widget.canReview ?? false;
    _epubReaderController = EpubController();
    // تحميل البوكمارك المحفوظة
    await EpubBookmarkManager().loadBookmarks();



    await Future.delayed(const Duration(seconds: 2), () {
      AppLoaderWidget();
    });

    // if (cfi.isNotEmpty) {
    //   // _epubReaderController.addHighlight(cfi: cfi);
    //   _epubReaderController.display(cfi: cfi);
    // }

    // تحميل جميع الهايلايتس المحفوظة
    _loadAllSavedHighlights();

    setState(() {});
  }

  Future<void> _loadAllSavedHighlights() async {
    if (widget.bookId == null) return;

    try {
      final bookmarks = EpubBookmarkManager().getBookmarksByBook(widget.bookId.toString());

      for (var bookmark in bookmarks) {
        // تحميل الهايلايتس والنصوص المحددة فقط
        if (bookmark.type == BookmarkType.cfiHighlight ||
            bookmark.type == BookmarkType.textSelection) {

          // استخدام CFI الصحيح حسب نوع البوكمارك
          String highlightCfi = bookmark.selectedCfi ?? bookmark.cfi;

          if (highlightCfi.isNotEmpty) {
            // إضافة الهايلايت مع اللون المخصص
            await _epubReaderController.addHighlight(
              cfi: highlightCfi,
              color: BookmarkColors.getColor(bookmark.color), // استخدام اللون المحفوظ
            );

            // تأخير صغير لضمان التحميل الصحيح
            await Future.delayed(const Duration(milliseconds: 100));
          }
        }
      }

      print('تم تحميل ${bookmarks.length} هايلايت للكتاب');

    } catch (e) {
      print('--------===================');
      print('خطأ في تحميل الهايلايتس: $e');
    }
  }

  @override
  void dispose() {
    super.dispose();
  }

  // عرض قائمة البوكمارك
  void _showBookmarksList() {
    if (widget.bookId == null) return;

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => EpubBookmarksListScreen(
          bookId: widget.bookId.toString(),
          epubController: _epubReaderController,
        ),
      ),
    );
  }

  // إضافة بوكمارك للصفحة الحالية
  void _addPageBookmark() async {
    if (widget.bookId == null) return;

    final noteController = TextEditingController();
    String selectedColor = 'blue'; // اللون الافتراضي

    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => AlertDialog(
          title: Text(language!.addBookmarkToPage),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language!.currentPageWillSavedAsBookmark),
                const SizedBox(height: 16),

                // اختيار اللون
                BookmarkColorPicker(
                  selectedColor: selectedColor,
                  onColorSelected: (color) {
                    setState(() {
                      selectedColor = color;
                    });
                  },
                ),

                const SizedBox(height: 16),

                // حقل الملاحظة
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: language!.noteOptional,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context, false),
              child: Text(language!.cancel),
            ),
            ElevatedButton(
              onPressed: () => Navigator.pop(context, true),
              child: Text(language!.save),
            ),
          ],
        ),
      ),
    );

    if (result == true) {
      final currentCfi = (await _epubReaderController.getCurrentLocation()).startCfi;
      await EpubBookmarkManager().addPageBookmark(
        bookId: widget.bookId.toString(),
        title: widget.bookName,
        cfi: currentCfi,
        note: noteController.text.isNotEmpty ? noteController.text : null,
        color: selectedColor, // تمرير اللون المختار
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(language!.pageBookmarkAddedSuccessfully)),
      );
    }
  }

  // إضافة بوكمارك للنص المحدد
  void _addTextSelectionBookmark() async {
    if (widget.bookId == null || selectedText.isEmpty) return;

    final noteController = TextEditingController();
    String selectedColor = 'blue';

    bool? result = await showDialog<bool>(
      context: context,
      builder: (context) => StatefulBuilder(
          builder: (context, setState){
          return AlertDialog(
            title: Text(language!.addBookmarkToSelectedText),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language!.selectedText, style: TextStyle(fontWeight: FontWeight.bold)),
                const SizedBox(height: 8),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color: Colors.grey.shade100,
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(color: Colors.grey.shade300),
                  ),
                  child: Text(
                    selectedText.length > 100
                        ? '${selectedText.substring(0, 100)}...'
                        : selectedText,
                    style: const TextStyle(fontSize: 14),
                    maxLines: 3,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                const SizedBox(height: 16),

                // اختيار اللون
                BookmarkColorPicker(
                  selectedColor: selectedColor,
                  onColorSelected: (color) {
                    print('------------------------');
                    print(color);
                    setState(() {
                      selectedColor = color;
                    });

                  },
                ),

                const SizedBox(height: 16),
                TextField(
                  controller: noteController,
                  decoration: InputDecoration(
                    labelText: language!.noteOptional,
                    border: OutlineInputBorder(),
                  ),
                  maxLines: 3,
                ),
              ],
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.pop(context, false),
                child: Text(language!.cancel),
              ),
              ElevatedButton(
                onPressed: () => Navigator.pop(context, true),
                child: Text(language!.save),
              ),
            ],
          );
        }
      ),
    );

    if (result == true) {
      await EpubBookmarkManager().addTextSelectionBookmark(
        bookId: widget.bookId.toString(),
        selectedText: selectedText,
        selectedCfi: selectedCfi,
        currentCfi: cfi,
        note: noteController.text.isNotEmpty ? noteController.text : null,
        color: selectedColor,
      );

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text(language!.textBookmarkAddedSuccessfully)),
      );

      // إضافة هايلايت للنص
      _epubReaderController.addHighlight(cfi: selectedCfi, color: BookmarkColors.getColor(selectedColor),);
    }
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
            boxShadow: [BoxShadow(color: Colors.transparent)],
          ),
        ).onTap(() {
          finish(context);
        }),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: _epubReaderController.getChapters().map((e) {
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
              _epubReaderController.display(cfi: e.href);
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
        titleWidget:  Marquee(
          child: Text(
              widget.bookName.validate().capitalizeFirstLetter(),
            // style: boldTextStyle(),
            textAlign: TextAlign.start,
            overflow: TextOverflow.ellipsis,
          ),
        ),
        color: context.scaffoldBackgroundColor,
        backWidget: Row(
          spacing: 8,
          children: [
            GestureDetector(
              child: Icon(Icons.arrow_back),
              onTap: () {

                  Navigator.pop(context);
              },
            ),
            GestureDetector(
              onTap: () async {
                showModalBottomSheet(
                  isScrollControlled: true,
                  isDismissible: true,
                  enableDrag: true,
                  backgroundColor: context.cardColor,
                  elevation: 2,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.only(
                        topRight: Radius.circular(22),
                        topLeft: Radius.circular(22)
                    ),
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
              child: Icon(Icons.menu),
            ),
          ],
        ),
        actions: [
          PopupMenuButton<int>(
            icon: const Icon(Icons.more_vert),
            onSelected: (value) async {
              if (value == 1) {
                // زر الخطوط
                bool? data = await showModalBottomSheet(
                  context: context,
                  isDismissible: true,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                  ),
                  builder: (BuildContext context) {
                    return StatefulBuilder(
                      builder: (context, secondaryState) {
                        return FontSizeComponent(
                          fontSizeList: fontSizeList,
                          selectedIndex: selectedIndex,
                          onTap: (index) {
                            secondaryState(() {
                              selectedIndex = index;
                              textSize = fontSizeList[index]
                                  .fontSize
                                  .toString()
                                  .toDouble();
                            });
                          },
                          onSet: () {
                            _epubReaderController.setFontSize(fontSize: textSize);
                            finish(context, true);
                          },
                        );
                      },
                    );
                  },
                );
                if (data.validate()) setState(() {});
              } else if (value == 2) {
                _addPageBookmark();
              } else if (value == 3) {
                _showBookmarksList();
              } else if (value == 4 && selectedText.isNotEmpty) {
                _addTextSelectionBookmark();
              }
            },
            itemBuilder: (context) => [
               PopupMenuItem(value: 1, child: Text(language!.changeFontSize)),
              if (selectedText.isNotEmpty)
                PopupMenuItem(
                  value: 4,
                  child: Text(language!.bookmarkSelectedText),
                ),
              PopupMenuItem(
                value: 2,
                child: Text(language!.bookmarkThePage),
              ),
              PopupMenuItem(
                value: 3,
                child: Text(language!.showBookmarks),
              ),
            ],
          ),
        ],
      ),
      body: _epubReaderController != null
          ? Theme(
        data: appStore.isDarkMode ? ThemeData.dark() : ThemeData.light(),
        child: EpubViewer(
          epubController: _epubReaderController,
          onEpubLoaded: (){
            print('----------00000000000--------------');
            _loadAllSavedHighlights();
          },
          epubSource: EpubSource.fromUrl(widget.filePath),
          onTextSelected: (val) {
            print('${language!.selectedText} ${val.selectionCfi}');
            setState(() {
              selectedText = val.selectedText ?? '';
              selectedCfi = val.selectionCfi;
              cfi = val.selectionCfi;
            });
          },
          onRelocated: (val){
            print(_openedPages.any((e)=> e == val.startCfi));
            print(_openedPages);
            if(_canReview) return;

            if(!_openedPages.any((e)=> e == val.startCfi)) {
            _openedPages.add(val.startCfi);
                    _currentPage += 1;
                  }

            if(_currentPage >= 5){
              updateBookReviewStatus({
                'book_id':
                widget.bookId.toString()
              }).then((value) {
                _canReview = true;
                appStore.setIsCanReviewFirstTime(true);
                LiveStream().emit(REVIEW_FIRST_TIME, true);
                setState(() {});
              }).catchError((error) {
                print(error);
              });
            }

          },
        ),
      )
          : AppLoaderWidget().center(),
    );
  }
}

class EpubBookmarksListScreen extends StatelessWidget {
  final String bookId;
  final EpubController epubController;

  const EpubBookmarksListScreen({
    Key? key,
    required this.bookId,
    required this.epubController,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(language!.bookmarkAndHighlight),
      ),
      body: ValueListenableBuilder<List<BookmarkModel>>(
        valueListenable: EpubBookmarkManager().bookmarksNotifier,
        builder: (context, allBookmarks, child) {
          final bookBookmarks = allBookmarks
              .where((bookmark) => bookmark.bookId == bookId)
              .toList();

          // ترتيب حسب التاريخ (الأحدث أولاً)
          bookBookmarks.sort((a, b) => b.createdAt.compareTo(a.createdAt));

          if (bookBookmarks.isEmpty) {
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(Icons.bookmarks_outlined, size: 64, color: Colors.grey),
                  SizedBox(height: 16),
                  Text(language!.noBookmarksSaved),
                ],
              ),
            );
          }

          // تجميع البوكمارك حسب النوع
          final groupedBookmarks = <BookmarkType, List<BookmarkModel>>{};
          for (var bookmark in bookBookmarks) {
            groupedBookmarks.putIfAbsent(bookmark.type, () => []).add(bookmark);
          }

          return SingleChildScrollView(
            padding: const EdgeInsets.all(16),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // النصوص المحددة
                if (groupedBookmarks.containsKey(BookmarkType.textSelection)) ...[
                  Text(
                    '${language!.selectedText} (${groupedBookmarks[BookmarkType.textSelection]!.length})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...groupedBookmarks[BookmarkType.textSelection]!
                      .map((bookmark) => EpubBookmarkTile(
                    bookmark: bookmark,
                    epubController: epubController,
                    icon: Icons.format_quote,
                    color: Colors.orange,
                  )),
                  const SizedBox(height: 24),
                ],

                // الهايلايتس
                if (groupedBookmarks.containsKey(BookmarkType.cfiHighlight)) ...[
                  Text(
                    '${language!.highlight} (${groupedBookmarks[BookmarkType.cfiHighlight]!.length})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...groupedBookmarks[BookmarkType.cfiHighlight]!
                      .map((bookmark) => EpubBookmarkTile(
                    bookmark: bookmark,
                    epubController: epubController,
                    icon: Icons.highlight,
                    color: Colors.yellow,
                  )),
                  const SizedBox(height: 24),
                ],

                // بوكمارك الصفحات
                if (groupedBookmarks.containsKey(BookmarkType.pageBookmark)) ...[
                  Text(
                    '${language!.bookmarkPages} (${groupedBookmarks[BookmarkType.pageBookmark]!.length})',
                    style: Theme.of(context).textTheme.titleLarge?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: 8),
                  ...groupedBookmarks[BookmarkType.pageBookmark]!
                      .map((bookmark) => EpubBookmarkTile(
                    bookmark: bookmark,
                    epubController: epubController,
                    icon: Icons.bookmark,
                    color: Colors.blue,
                  )),
                ],
              ],
            ),
          );
        },
      ),
    );
  }
}

// افترض أن لديك BookmarkModel يحتوي على الحقول:
// id, title, selectedText, note, createdAt, cfi
class EpubBookmarkTile extends StatelessWidget {
  final BookmarkModel bookmark;
  final EpubController epubController;
  final IconData icon;
  final Color color;

  const EpubBookmarkTile({
    Key? key,
    required this.bookmark,
    required this.epubController,
    required this.icon,
    required this.color,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final bookmarkColor = BookmarkColors.getColor(bookmark.color);

    return Card(
      margin: const EdgeInsets.only(bottom: 12),
      child: ListTile(
        leading: Icon(Icons.bookmark, color: bookmarkColor,),
        title: Text(
          bookmark.title,
          maxLines: 2,
          overflow: TextOverflow.ellipsis,
          style: const TextStyle(fontWeight: FontWeight.w500),
        ),
        subtitle: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (bookmark.selectedText != null && bookmark.selectedText!.isNotEmpty) ...[
              const SizedBox(height: 4),
              Container(
                padding: const EdgeInsets.all(8),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(6),
                ),
                child: Text(
                  bookmark.selectedText!.length > 100
                      ? '${bookmark.selectedText!.substring(0, 100)}...'
                      : bookmark.selectedText!,
                  style: Theme.of(context).textTheme.bodySmall,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
            if (bookmark.note != null) ...[
              const SizedBox(height: 4),
              Text(
                '${language!.note} ${bookmark.note!}',
                style: Theme.of(context).textTheme.bodySmall?.copyWith(
                  fontStyle: FontStyle.italic,
                  color: Colors.blue.shade700,
                ),
              ),
            ],
            const SizedBox(height: 4),
            Text(
              '${language!.saveDone} ${_formatDate(bookmark.createdAt)}',
              style: Theme.of(context).textTheme.bodySmall?.copyWith(
                color: Colors.grey.shade600,
              ),
            ),
          ],
        ),
        trailing: PopupMenuButton<String>(
          onSelected: (value) async {
            if (value == 'delete') {
              bool? confirm = await showDialog<bool>(
                context: context,
                builder: (context) => AlertDialog(
                  title: Text(language!.confirmDeletion),
                  content: Text(language!.doYouWantDeleteThisBookmark),
                  actions: [
                    TextButton(
                      onPressed: () => Navigator.pop(context, false),
                      child: Text(language!.cancel),
                    ),
                    ElevatedButton(
                      onPressed: () => Navigator.pop(context, true),
                      child: Text(language!.save),
                      style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
                    ),
                  ],
                ),
              );

              if (confirm == true) {
                await EpubBookmarkManager().deleteBookmark(bookmark.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text(language!.bookmarksDeleted)),
                  );
                }
              }
            }
          },
          itemBuilder: (context) => [
            PopupMenuItem(
              value: 'delete',
              child: Row(
                children: [
                  Icon(Icons.delete, color: Colors.red),
                  SizedBox(width: 8),
                  Text(language!.delete),
                ],
              ),
            ),
          ],
        ),
        onTap: () {
          // الانتقال للموقع المحدد
          try {
            print('===================== ${bookmark.cfi} --');
            epubController.display(cfi: bookmark.cfi);
            Navigator.pop(context);
          } catch (e) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('حدث خطأ أثناء فتح الموقع')),
            );
          }
        },
      ),
    );
  }
}
Color _getContrastColor(Color color) {
  final luminance = color.computeLuminance();
  return luminance > 0.5 ? Colors.black : Colors.white;
}

String _formatDate(DateTime date) {
  // تنسيق بسيط للتاريخ
  return '${date.year}-${date.month.toString().padLeft(2, '0')}-${date.day.toString().padLeft(2, '0')} '
      '${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}';
}

