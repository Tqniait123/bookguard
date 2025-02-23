import 'bookdetail_model.dart';

class ReadBook {
  bool? status;
  String? message;
  BookDetailResponse? data;

  ReadBook({this.status, this.message, this.data});

  ReadBook.fromJson(Map<String, dynamic> json) {
    status = json['status'];
    message = json['message'];
    data = json['data'] != null ? new BookDetailResponse.fromJson(json['data']) : null;
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['status'] = this.status;
    data['message'] = this.message;
    if (this.data != null) {
      data['data'] = this.data!.toJson();
    }
    return data;
  }
}