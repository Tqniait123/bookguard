import 'package:granth_flutter/models/bookdetail_model.dart';
import 'package:granth_flutter/utils/model_keys.dart';

class DownloadedBook {
  int? id;
  int? userId;
  String? taskId;
  String? bookId;
  String? bookName;
  String? authorName;
  String? frontCover;
  String? fileType;
  String? filePath;
  String? lastCfi;
  String? webBookPath;
  bool isDownloaded;
  int? canReview;

  DownloadedBook({this.userId, this.id, this.taskId, this.bookId, this.bookName, this.frontCover, this.fileType, this.filePath, this.lastCfi, this.webBookPath, this.authorName, this.isDownloaded = false, this.canReview});

  factory DownloadedBook.fromJson(Map<String, dynamic> json) {
    return DownloadedBook(
        id: json[LibraryBookKey.id],
        taskId: json[LibraryBookKey.taskId],
        bookId: json[CommonKeys.bookId],
        bookName: json[LibraryBookKey.bookName],
        frontCover: json[LibraryBookKey.frontCover],
        fileType: json[LibraryBookKey.fileType],
        filePath: json[LibraryBookKey.filePath],
        lastCfi: json['last_cfi'],
        webBookPath: json[LibraryBookKey.webBookPath],
        authorName: json[LibraryBookKey.authorName],
        userId: json[LibraryBookKey.userId],
        canReview: json[LibraryBookKey.canReview],
    );
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data[LibraryBookKey.id] = this.id;
    data[LibraryBookKey.taskId] = this.taskId;
    data[CommonKeys.bookId] = this.bookId;
    data[LibraryBookKey.bookName] = this.bookName;
    data[LibraryBookKey.frontCover] = this.frontCover;
    data[LibraryBookKey.fileType] = this.fileType;
    data[LibraryBookKey.filePath] = this.filePath;
    data['last_cfi'] = this.lastCfi;
    data[LibraryBookKey.webBookPath] = this.webBookPath;
    data[LibraryBookKey.authorName] = this.authorName;
    data[LibraryBookKey.userId] = this.userId;
    data[LibraryBookKey.canReview] = this.canReview;
    return data;
  }
}

DownloadedBook defaultBook(BookDetailResponse mBookDetail, fileType) {
  return DownloadedBook(
      bookId: mBookDetail.bookId.toString(), bookName: mBookDetail.name, frontCover: mBookDetail.frontCover, fileType: fileType, filePath: mBookDetail.filePath, webBookPath: mBookDetail.filePath, canReview: mBookDetail.canReview);
}
