import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

class BookmarkModel {
  final String id;
  final String bookId;
  final BookmarkType type;
  final String title;
  final String content;
  final String cfi;
  final String? selectedText;
  final String? selectedCfi;
  final DateTime createdAt;
  final String? note;
  final String color; // إضافة حقل اللون

  BookmarkModel({
    required this.id,
    required this.bookId,
    required this.type,
    required this.title,
    required this.content,
    required this.cfi,
    this.selectedText,
    this.selectedCfi,
    required this.createdAt,
    this.note,
    this.color = 'blue', // اللون الافتراضي
  });

  Map<String, dynamic> toJson() => {
    'id': id,
    'bookId': bookId,
    'type': type.toString(),
    'title': title,
    'content': content,
    'cfi': cfi,
    'selectedText': selectedText,
    'selectedCfi': selectedCfi,
    'createdAt': createdAt.toIso8601String(),
    'note': note,
    'color': color,
  };

  factory BookmarkModel.fromJson(Map<String, dynamic> json) => BookmarkModel(
    id: json['id'],
    bookId: json['bookId'],
    type: BookmarkType.values.firstWhere(
          (e) => e.toString() == json['type'],
    ),
    title: json['title'],
    content: json['content'],
    cfi: json['cfi'],
    selectedText: json['selectedText'],
    selectedCfi: json['selectedCfi'],
    createdAt: DateTime.parse(json['createdAt']),
    note: json['note'],
    color: json['color'] ?? 'blue',
  );
}

enum BookmarkType { textSelection, pageBookmark, cfiHighlight }

class BookmarkColors {
  static const Map<String, Color> colors = {
    'red': Colors.red,
    'pink': Colors.pink,
    'purple': Colors.purple,
    'blue': Colors.blue,
    'cyan': Colors.cyan,
    'green': Colors.green,
    'lime': Colors.lime,
    'yellow': Colors.yellow,
    'orange': Colors.orange,
    'brown': Colors.brown,
    'grey': Colors.grey,
    'black': Colors.black87,
  };

  static const Map<String, String> colorNames = {
    'red': 'أحمر',
    'pink': 'وردي',
    'purple': 'بنفسجي',
    'blue': 'أزرق',
    'cyan': 'سماوي',
    'green': 'أخضر',
    'lime': 'أخضر فاتح',
    'yellow': 'أصفر',
    'orange': 'برتقالي',
    'brown': 'بني',
    'grey': 'رمادي',
    'black': 'أسود',
  };

  static Color getColor(String colorName) {
    return colors[colorName] ?? Colors.blue;
  }

  static String getColorName(String colorKey) {
    return colorNames[colorKey] ?? 'أزرق';
  }
}

class EpubBookmarkManager {
  static final EpubBookmarkManager _instance = EpubBookmarkManager._internal();
  factory EpubBookmarkManager() => _instance;
  EpubBookmarkManager._internal();

  final List<BookmarkModel> _bookmarks = [];
  final ValueNotifier<List<BookmarkModel>> bookmarksNotifier =
  ValueNotifier<List<BookmarkModel>>([]);

  List<BookmarkModel> get bookmarks => List.unmodifiable(_bookmarks);

  // إضافة بوكمارك للنص المحدد
  Future<void> addTextSelectionBookmark({
    required String bookId,
    required String selectedText,
    required String selectedCfi,
    required String currentCfi,
    String? note,
    String color = 'blue',
  }) async {
    final bookmark = BookmarkModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bookId: bookId,
      type: BookmarkType.textSelection,
      title: selectedText.length > 50
          ? '${selectedText.substring(0, 50)}...'
          : selectedText,
      content: selectedText,
      cfi: currentCfi,
      selectedText: selectedText,
      selectedCfi: selectedCfi,
      createdAt: DateTime.now(),
      note: note,
      color: color
    );

    _bookmarks.add(bookmark);
    bookmarksNotifier.value = List.from(_bookmarks);
    await _saveToStorage();
  }

  // إضافة بوكمارك للصفحة الحالية
  Future<void> addPageBookmark({
    required String bookId,
    required String title,
    required String cfi,
    String? note,
    String color = 'blue', // إضافة معامل اللون
  }) async {
    final bookmark = BookmarkModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bookId: bookId,
      type: BookmarkType.pageBookmark,
      title: title.isNotEmpty ? title : 'صفحة محفوظة',
      content: cfi,
      cfi: cfi,
      createdAt: DateTime.now(),
      note: note,
      color: color, // حفظ اللون
    );

    _bookmarks.add(bookmark);
    bookmarksNotifier.value = List.from(_bookmarks);
    await _saveToStorage();
  }

  // إضافة هايلايت مع بوكمارك
  Future<void> addHighlightBookmark({
    required String bookId,
    required String title,
    required String cfi,
    String? note,
  }) async {
    final bookmark = BookmarkModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      bookId: bookId,
      type: BookmarkType.cfiHighlight,
      title: title,
      content: cfi,
      cfi: cfi,
      createdAt: DateTime.now(),
      note: note,
    );

    _bookmarks.add(bookmark);
    bookmarksNotifier.value = List.from(_bookmarks);
    await _saveToStorage();
  }

  // حذف بوكمارك
  Future<void> deleteBookmark(String bookmarkId) async {
    _bookmarks.removeWhere((bookmark) => bookmark.id == bookmarkId);
    bookmarksNotifier.value = List.from(_bookmarks);
    await _saveToStorage();
  }

  // التحقق من وجود بوكمارك للـ CFI
  bool hasBookmarkForCfi(String bookId, String cfi) {
    return _bookmarks.any((bookmark) =>
    bookmark.bookId == bookId && bookmark.cfi == cfi);
  }

  // الحصول على بوكمارك كتاب معين
  List<BookmarkModel> getBookmarksByBook(String bookId) {
    return _bookmarks.where((bookmark) => bookmark.bookId == bookId).toList();
  }

  // حفظ البوكمارك في التخزين المحلي
  Future<void> _saveToStorage() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksJson = _bookmarks.map((b) => b.toJson()).toList();
    await prefs.setString('epub_bookmarks', jsonEncode(bookmarksJson));
  }

  // تحميل البوكمارك من التخزين المحلي
  Future<void> loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final bookmarksString = prefs.getString('epub_bookmarks');
    if (bookmarksString != null) {
      final List<dynamic> bookmarksJson = jsonDecode(bookmarksString);
      _bookmarks.clear();
      _bookmarks.addAll(
        bookmarksJson.map((json) => BookmarkModel.fromJson(json)).toList(),
      );
      bookmarksNotifier.value = List.from(_bookmarks);
    }
  }
}