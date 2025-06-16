import 'dart:convert';
import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter_stripe/flutter_stripe.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/cart_response.dart';
import 'package:granth_flutter/models/stripe_model.dart';
import 'package:granth_flutter/network/network_utils.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:http/http.dart' as http;
import 'package:nb_utils/nb_utils.dart';

import '../../models/paymentMethod_model.dart';
import '../../models/plan_model.dart';
import '../dashboard/fragment/webView_payment.dart';

class FawaterkServices {
  static List<CartModel>? cartResponse;
  num totalAmount = 0;
  String stripeURL = "";
  String apiKey = ""; //live
  // String apiKey = "d83a5d07aaeb8442dcbe259e6dae80a3f2e21a3a581e1a5acd";
  bool isTest = false;
  List<PaymentMethodModel>? paymentMethods;

  Future<List<PaymentMethodModel>> fetchPaymentMethods() async {
    final apiUrl = 'https://app.fawaterk.com/api/v2/getPaymentmethods';
    final accessToken = apiKey;

    final headers = {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $accessToken',
    };

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: headers);
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(json.encode(responseData));
        return responseData['data']
            .map<PaymentMethodModel>((e) => PaymentMethodModel.fromJson(e))
            .toList();
      } else {
        throw response.reasonPhrase ?? '';
      }
    } catch (error) {
      print(error);
      throw error ?? '';
    }
  }

  Future<void> getApiKey() async {
    final apiUrl = '${Uri.parse(BASE_URL)}fwaterk_api_key';

    try {
      final response = await http.get(Uri.parse(apiUrl), headers: buildHeaderTokens());
      if (response.statusCode == 200) {
        final responseData = json.decode(response.body);
        print(json.encode(responseData));
        apiKey = responseData['Fawaterk_API_KEY'];
      } else {
        throw response.reasonPhrase ?? '';
      }
    } catch (error) {
      print(error);
      throw error ?? '';
    }
  }

  Future<void> sendPaymentRequest({
    required BuildContext context,
    required PaymentMethodModel paymentMethod,
    required List<CartModel> data,
    required num totalAmount,
    required Function(String invoiceId) afterSuccess,
  }) async {
    final apiUrl = 'https://app.fawaterk.com/api/v2/invoiceInitPay';
    final apiToken = apiKey;
    // final paymentId = 2; // 2=Visa-MasterCard, 3=Fawry, 4=Meeza

    num discountPrice = 0.0;
    discountPrice = data.where((element) => element.discountedPrice != 0).sumByDouble((p0) => p0.price.validate() - p0.discountedPrice.validate());

    print(discountPrice);
    print(totalAmount);
    print(data.sumByDouble((p0) => p0.price.validate()));
    print(appStore.userContactNumber);

    final requestData = {
      'payment_method_id': paymentMethod.paymentId,
      'cartTotal': data.sumByDouble((p0) => p0.price.validate()),
      'currency': 'EGP',
      'customer': {
        'first_name': appStore.userName,
        'last_name': appStore.userName,
        'email': appStore.userEmail,
        'phone': appStore.userContactNumber,
        'address': '',
      },
      'redirectionUrls': {
        'successUrl': 'https://dev.fawaterk.com/success',
        'failUrl': 'https://dev.fawaterk.com/fail',
        'pendingUrl': 'https://dev.fawaterk.com/pending',
      },
      'discountData': {
        'type':'literal',
        'value':discountPrice,
      },
      'cartItems': List.generate(data.length, (index) {
        return {
          'name': data[index].name,
          'price': data[index].price,
          'quantity': 1,
        };
      }).toList(),
    };

    final headers = {
      'Authorization': 'Bearer $apiToken',
      'Content-Type': 'application/json',
    };

    try {
      print('payyy');
      appStore.setLoading(true);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(requestData),
      );

      if(response.statusCode != 200){
        print('=======');
      }
      final responseData = json.decode(response.body);
      print(json.encode(responseData));
      appStore.setLoading(false);
      PaymentWebViewScreen(
        url: responseData['data']['payment_data']['redirectTo'],
          saveTransaction: (invoiceId) async{
            afterSuccess(invoiceId);
        }
      ).launch(context);
    } catch (error) {
      appStore.setLoading(false);
      print(error);
    }
  }

  Future<void> sendPaymentForSubscription({
    required BuildContext context,
    required PaymentMethodModel paymentMethod,
    required PlanDetails plan,
    required num totalAmount,
    required Function(String invoiceId) afterSuccess,
  }) async {
    final apiUrl = 'https://app.fawaterk.com/api/v2/invoiceInitPay';
    final apiToken = apiKey;
    // final paymentId = 2; // 2=Visa-MasterCard, 3=Fawry, 4=Meeza

    num discountPrice = 0.0;

    print(discountPrice);
    print(totalAmount);

    print(appStore.userContactNumber);

    final requestData = {
      'payment_method_id': paymentMethod.paymentId,
      'cartTotal': plan.price,
      'currency': 'EGP',
      'customer': {
        'first_name': appStore.userName,
        'last_name': appStore.userName,
        'email': appStore.userEmail,
        'phone': appStore.userContactNumber,
        'address': '',
      },
      'redirectionUrls': {
        'successUrl': 'https://dev.fawaterk.com/success',
        'failUrl': 'https://dev.fawaterk.com/fail',
        'pendingUrl': 'https://dev.fawaterk.com/pending',
      },

      'cartItems': [
         {
          'name': plan.name,
          'price': plan.price,
          'quantity': 1,
        }]
      ,
    };

    final headers = {
      'Authorization': 'Bearer $apiToken',
      'Content-Type': 'application/json',
    };

    try {
      print('payyy');
      appStore.setLoading(true);
      final response = await http.post(
        Uri.parse(apiUrl),
        headers: headers,
        body: json.encode(requestData),
      );

      if(response.statusCode != 200){
        print('=======');
      }
      final responseData = json.decode(response.body);
      print(json.encode(responseData));
      appStore.setLoading(false);
      PaymentWebViewScreen(
        url: responseData['data']['payment_data']['redirectTo'],
          saveTransaction: (invoiceId) async{
            afterSuccess(invoiceId);
        }
      ).launch(context);
    } catch (error) {
      appStore.setLoading(false);
      print(error);
    }
  }

//StripPayment
// void stripePay() async {
//   Map<String, String> headers = {
//     HttpHeaders.authorizationHeader: 'Bearer $stripePaymentKey',
//     HttpHeaders.contentTypeHeader: 'application/x-www-form-urlencoded',
//   };
//
//   var request = Request('POST', Uri.parse(stripeURL));
//
//   request.bodyFields = {
//     'amount': '500',
//     'currency': 'INR',
//   };
//
//   log(request.bodyFields);
//   request.headers.addAll(headers);
//
//   appStore.setLoading(true);
//
//   await request.send().then((value) {
//     appStore.setLoading(false);
//
//     Response.fromStream(value).then((response) async {
//       if (response.statusCode.isSuccessful()) {
//         StripePayModel res = StripePayModel.fromJson(await handleResponse(response));
//
//         await Stripe.instance
//             .initPaymentSheet(
//           paymentSheetParameters: SetupPaymentSheetParameters(
//               paymentIntentClientSecret: res.client_secret.validate(),
//               merchantDisplayName: APP_NAME,
//               customerId: appStore.userId.toString(),
//               customerEphemeralKeySecret: isAndroid ? res.client_secret.validate() : null,
//               setupIntentClientSecret: res.client_secret.validate()),
//         )
//             .then((value) async {
//           await Stripe.instance.presentPaymentSheet().then((value) async {
//             Stripe.instance.retrievePaymentIntent(res.client_secret.validate()).then((vs) {
//               toast("${vs.toJson()}", print: true);
//               var request = <String, String?>{
//                 "TXNID": vs.id.toString(),
//                 "STATUS": "TXN_SUCCESS",
//                 "TXN_PAYMENT_ID": vs.paymentMethodId,
//                 "TXN_ORDER_ID": vs.id.toString().isEmptyOrNull ? vs.paymentMethodId.toString() : vs.id.toString(),
//               };
//               var data = jsonEncode(cartResponse);
//               saveTransaction(request, data, STRIPE_STATUS, 'TXN_SUCCESS', totalAmount);
//             }).catchError((e) {
//               toast(e.toString(), print: true);
//             });
//           }).catchError((e) {
//             log("presentPaymentSheet ${e.toString()}");
//           });
//         }).catchError((e) {
//           toast(e.toString(), print: true);
//
//           throw e.toString();
//         });
//       } else if (response.statusCode == 400) {
//         toast("Testing Credential cannot pay more than 500");
//       }
//     }).catchError((e) {
//       appStore.setLoading(false);
//       toast(e.toString(), print: true);
//
//       throw e.toString();
//     });
//   }).catchError((e) {
//     appStore.setLoading(false);
//     toast(e.toString(), print: true);
//
//     throw e.toString();
//   });
// }
}
//
// StripeServices stripeServices = StripeServices();
