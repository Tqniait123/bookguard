class PaymentMethodModel {
  int? paymentId;
  String? nameEn;
  String? nameAr;
  String? redirect;
  String? logo;

  PaymentMethodModel({ this.paymentId, this.nameEn, this.nameAr, this.redirect, this.logo});

  factory PaymentMethodModel.fromJson(Map<String, dynamic> json) {
    return PaymentMethodModel(
        paymentId: json['paymentId'],
        nameEn: json['name_en'],
        nameAr: json['name_ar'],
        redirect: json['redirect'],
      logo: json['logo'],);
  }

  Map<String, dynamic> toJson() {
    final Map<String, dynamic> data = new Map<String, dynamic>();
    data['paymentId'] = this.paymentId;
    data['name_en'] = this.nameEn;
    data['name_ar'] = this.nameAr;
    data['redirect'] = this.redirect;
    data['logo'] = this.logo;
    return data;
  }
}