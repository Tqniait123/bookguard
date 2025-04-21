import 'dart:convert';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/screen/dashboard/fragment/webView_payment.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:flutterwave_standard/models/requests/customer.dart';
import 'package:flutterwave_standard/models/requests/customizations.dart';
import 'package:flutterwave_standard/models/requests/standard_request.dart';
import 'package:flutterwave_standard/models/responses/charge_response.dart';
import 'package:granth_flutter/component/app_loader_widget.dart';
import 'package:granth_flutter/component/no_data_found_widget.dart';
import 'package:granth_flutter/models/payment_method_list_model.dart';
import 'package:granth_flutter/screen/dashboard/component/cart_component.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/cart_response.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screen/payment/price_calulation_screen.dart';
import 'package:granth_flutter/utils/common.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/model_keys.dart';
import '../../../models/paymentMethod_model.dart';
import '../../../utils/images.dart';
import '../../payment/cart_payment.dart';

import '../../payment/fawaterk_payment.dart';
import '../../payment/flutter_wave_payment.dart';
import '../../payment/payment_done.dart';

class MobileCartFragment extends StatefulWidget {
  final bool? isShowBack;

  MobileCartFragment({this.isShowBack});

  @override
  _MobileCartFragmentState createState() => _MobileCartFragmentState();
}

class _MobileCartFragmentState extends State<MobileCartFragment> {
  List<PaymentMethodListModel> paymentModeList = paymentModeListData();
  List<CartModel> cartItemList = [];
  CartPayment cartPayment = CartPayment();

  late FawaterkServices fawaterkServices;

  List<PaymentMethodModel>? paymentMethods;
  PaymentMethodModel? selectedPaymentMethod;

  @override
  void initState() {
    super.initState();
    getCart();
    afterBuildCreated(() {
      init();
      getPaymentMethods();
      LiveStream().on(CART_DATA_CHANGED, (p0) {
        init();
        // finish(context, true);
        print('22222222222222 ✔✔');
      });
      LiveStream().on(PAYMENT_DONE, (p0) async {

        PaymentSuccessPage().launch(context);
        print('retrive ✔✔');
        setState(() {});
      });
    });
  }

  getPaymentMethods() async {
    fawaterkServices = FawaterkServices();
    paymentMethods = await fawaterkServices.fetchPaymentMethods();
    if(paymentMethods != null) {
      paymentMethods!.removeWhere((e) => e.redirect == 'false');
    }
    setState(() {});
    print(paymentMethods);
  }

  Future<void> init() async {
    appStore.setLoading(true);
    await getCart().then((value) {
      cartItemList = value.data.validate();
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  /// RemoveCart Api
  Future<void> removeCartApi(BuildContext context,
      {int? itemId, int? bookId}) async {
    Map request = {
      UserKeys.id: itemId,
    };
    appStore.setLoading(true);
    removeFromCart(request).then((value) {
      appStore.setLoading(false);
      toast(value.message);
      appStore.setCartCount(appStore.cartCount - 1);
      init();
      cartItemListBookId.remove(bookId);
      LiveStream().emit(CART_DATA_CHANGED);
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });
  }

  ///FlutterWave Payment
  void flutterWaveCheckout() async {
    final customer = Customer(
      name: appStore.userName,
      phoneNumber: appStore.userContactNumber,
      email: appStore.userEmail.validate(),
    );

    final request = StandardRequest(
      txRef: DateTime.now().millisecond.toString(),
      amount: appStore.payableAmount.toString(),
      customer: customer,
      paymentOptions: "card, payattitude",
      customization: Customization(title: "Test Payment"),
      isTestMode: true,
      publicKey: FLUTTER_WAVE_PUBLIC_KEY,
      currency: 'USD',
      redirectUrl: "https://www.google.com",
    );

    try {
      final ChargeResponse response = await beginPayment(request);
      if (response.success == true) {
        var request = <String, String?>{
          "STATUS": "TXN_SUCCESS",
          "TXNID": response.transactionId,
          "TXNSTATUS": response.status,
          "TXNSREFF": response.txRef,
          "TXNSUCCESS": response.success.toString(),
        };
        var data = jsonEncode(cartItemList);
        saveTransaction(request, data, FLUTTER_WAVE_STATUS, 'TXN_SUCCESS',
            appStore.payableAmount);
        appStore.setBottomNavigationBarIndex(0);
        init();
      } else {
        toast('Transaction Failed');
      }
    } catch (error) {
      toast(error.toString());
    }
  }

  Future<ChargeResponse> beginPayment(StandardRequest request) async {
    try {
      showDialog(
        context: context,
        barrierDismissible: false,
        builder: (BuildContext context) {
          return Center(
            child: CircularProgressIndicator(),
          );
        },
      );

      await Future.delayed(Duration(seconds: 2));
      finish(context);

      return ChargeResponse(
        status: "success",
        success: true,
        transactionId: DateTime.now().millisecondsSinceEpoch.toString(),
        txRef: request.txRef,
      );
    } catch (e) {
      finish(context);
      throw e;
    }
  }

  @override
  onTransactionComplete(ChargeResponse? chargeResponse) {
    if (chargeResponse != null) {
      var request = <String, dynamic>{
        "STATUS": "TXN_SUCCESS",
        "TXNID": chargeResponse.transactionId,
        "TXNSTATUS": chargeResponse.status,
        "TXNSREFF": chargeResponse.txRef,
        "TXNSUCCESS": chargeResponse.success.toString(),
      };
      var data = jsonEncode(cartItemList);

      saveTransaction(request, data, FLUTTER_WAVE_STATUS, 'TXN_SUCCESS',
              appStore.payableAmount)
          .then((value) {
        toast("Order saved successfully"); //Todo : Lang
        appStore.setLoading(false);
        appStore.setBottomNavigationBarIndex(0);
        init();
      }).catchError((error) {
        appStore.setLoading(false);
        toast("Failed to save order: $error"); //Todo : Lang
      });
    }
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  void dispose() {
    LiveStream().dispose(CART_DATA_CHANGED);
    LiveStream().dispose(PAYMENT_DONE);
    print('---------------------------------dispose');
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: appBarWidget(language!.myCart,
          elevation: 0,
          showBack: widget.isShowBack ?? false,
          color: context.scaffoldBackgroundColor,
          backWidget: BackButton(
              style: ButtonStyle(
            foregroundColor: MaterialStateProperty.all(Color(0xFFFFFFFF)),
            backgroundColor: MaterialStateProperty.all(Color(0xFF876A48)),
            // Brown color
            shape: MaterialStateProperty.all(
              CircleBorder(),
            ),
            padding:
                MaterialStateProperty.all(EdgeInsets.all(12)), // Adjust size
          ))),
      bottomNavigationBar: cartItemList.length != 0 || appStore.cartCount != 0
          ? Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [defaultPrimaryColor, Color(0xffD2BB8F)],
                  begin: Alignment.topRight,
                  end: Alignment.bottomRight,
                ),
                borderRadius: BorderRadius.circular(15),
              ),
              child: AppButton(
                text: language!.placeOrder,
                color: transparentColor,
                width: context.width(),
                enableScaleAnimation: false,
                onTap: () async {
                  if (paymentMode == FLUTTER_WAVE) {
                    showConfirmDialog(
                      context,
                      'You will be charged a total of ${appStore.payableAmount} ${defaultCurrencySymbol}. Do you wish to continue?',
                      //Todo : language key
                      positiveText: "Continue",
                      negativeText: "Cancel",
                      onAccept: () {
                        FlutterWave().flutterWaveCheckout(
                          ctx: context,
                          onCompleteCall: (p0) {
                            onTransactionComplete(p0);
                          },
                        );
                      },
                    );
                  } else {
                    print('======================================');
                    // cartPayment.placeOrder(paymentMode: paymentMode, cartItemList: cartItemList, context: context);

                    // appStore.setLoading(true);
                    var data = jsonEncode(cartItemList);
                    // await saveTransaction(
                    // {}, data, OFFLINE_STATUS, 'TXN_SUCCESS', appStore.payableAmount);
                    // appStore.setLoading(false);
                    // appStore.setBottomNavigationBarIndex(0);
                    // init();
                    if (selectedPaymentMethod != null) {
                      fawaterkServices.sendPaymentRequest(
                          context: context,
                          paymentMethod: selectedPaymentMethod!,
                          data: cartItemList,
                          totalAmount: appStore.payableAmount,
                        afterSuccess: (invoiceId) async{
                          finish(context);
                          var request = <String, String?>{
                            "TXNID": invoiceId,
                            "STATUS": "TXN_SUCCESS",
                            "TXN_PAYMENT_ID": selectedPaymentMethod!.paymentId.toString(),
                            // "TXN_ORDER_ID": vs.id.toString().isEmptyOrNull ? vs.paymentMethodId.toString() : vs.id.toString(),
                          };
                          var type = {
                            'typeEn': selectedPaymentMethod!.nameEn,
                            'typeAr': selectedPaymentMethod!.nameAr,
                          };
                          appStore.setLoading(true);
                          await saveTransaction(
                          request, data, type, 'TXN_SUCCESS', appStore.payableAmount);
                          appStore.setLoading(false);
                          appStore.setBottomNavigationBarIndex(0);
                          init();
                          }
                      );
                      // PaymentWebViewScreen(url: '',).launch(context);
                    }else{
                      toast('choose payment method');
                    }
                  }
                },
              ),
            ).paddingAll(16)
          : SizedBox(),
      body: Stack(
        children: [
          cartItemList.length != 0 || appStore.cartCount != 0
              ? SingleChildScrollView(
                  padding: EdgeInsets.only(bottom: 30),
                  child: Column(
                    children: [
                      ListView.builder(
                        physics: NeverScrollableScrollPhysics(),
                        itemCount: cartItemList.length,
                        shrinkWrap: true,
                        padding: EdgeInsets.only(
                            left: defaultRadius,
                            right: defaultRadius,
                            top: defaultRadius,
                            bottom: 16),
                        itemBuilder: ((context, index) {
                          return CartComponent(
                            cartModel: cartItemList[index],
                            onRemoveTap: () {
                              removeCartApi(context,
                                  itemId: cartItemList[index].cartMappingId,
                                  bookId: cartItemList[index].bookId);
                              cartItemList.removeAt(index);
                              setState(() {});
                            },
                          );
                        }),
                      ),
                      16.height,
                      SizedBox(
                        width: context.width(),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          mainAxisAlignment: MainAxisAlignment.start,
                          children: [
                            Text(language!.paymentMethod,
                                    style: boldTextStyle())
                                .paddingSymmetric(horizontal: 16),
                            8.height,
                            HorizontalList(
                              itemCount: paymentMethods?.length ?? 0,
                              spacing: 0,
                              runSpacing: 0,
                              itemBuilder: (context, index) {
                                return Container(
                                  height: 60,
                                  margin: EdgeInsets.symmetric(horizontal: 8),
                                  decoration: boxDecorationWithRoundedCorners(
                                    backgroundColor: context.cardColor,
                                    border: selectedPaymentMethod?.paymentId ==
                                            paymentMethods?[index].paymentId
                                        ? Border.all(color: defaultPrimaryColor)
                                        : Border.all(color: transparentColor),
                                  ),
                                  child: TextIcon(
                                    edgeInsets: EdgeInsets.all(16),
                                    spacing: 8,
                                    text: paymentMethods?[index].nameEn ?? '',
                                    textStyle: secondaryTextStyle(),
                                    prefix: FancyShimmerImage(
                                      imageUrl:
                                          paymentMethods?[index].logo ?? '',
                                      height: 50.0,
                                      // Set image size
                                      width: 80.0,
                                      // Set image size
                                      boxFit: BoxFit.contain,
                                      errorWidget: Icon(Icons.error_outline,
                                          color: Colors.red),
                                    ),
                                  ),
                                ).onTap(() {
                                  setState(() {
                                    selectedPaymentMethod =
                                        paymentMethods?[index];
                                  });
                                },
                                    highlightColor: transparentColor,
                                    splashColor: transparentColor);
                              },
                            ),
                            // Padding(
                            //   padding: EdgeInsets.only(left: defaultRadius, right: defaultRadius, top: defaultRadius, bottom: 16),
                            //   child: DropdownButton<PaymentMethodModel>(
                            //     value: selectedPaymentMethod,
                            //     onChanged: (value) {
                            //       setState(() {
                            //         selectedPaymentMethod = value;
                            //       });
                            //     },
                            //     isExpanded: true, // Ensure dropdown takes full width
                            //     icon: Icon(Icons.arrow_drop_down, color: Colors.grey), // Custom icon for dropdown
                            //     style: TextStyle(color: Colors.black, fontSize: 16), // Text style
                            //     dropdownColor: Colors.white, // Dropdown background color
                            //     items: paymentMethods?.map<DropdownMenuItem<PaymentMethodModel>>((PaymentMethodModel value) {
                            //       return DropdownMenuItem<PaymentMethodModel>(
                            //         value: value,
                            //         child: Padding(
                            //           padding: const EdgeInsets.symmetric(vertical: 8.0, horizontal: 12.0),
                            //           child: Row(
                            //             children: [
                            //               FancyShimmerImage(
                            //                 imageUrl: value.logo ?? '',
                            //                 height: 50.0, // Set image size
                            //                 width: 50.0,  // Set image size
                            //                 boxFit: BoxFit.contain,
                            //                 errorWidget: Icon(Icons.error_outline, color: Colors.red),
                            //               ),
                            //               SizedBox(width: 12),
                            //               Expanded(
                            //                 child: Text(
                            //                   value.nameEn ?? '',
                            //                   style: TextStyle(
                            //                     fontWeight: FontWeight.w500,
                            //                     fontSize: 16,
                            //                   ),
                            //                 ),
                            //               ),
                            //             ],
                            //           ),
                            //         ),
                            //       );
                            //     }).toList(),
                            //   ),
                            // ),
                            24.height,
                            Text(language!.paymentDetails,
                                    style: boldTextStyle())
                                .paddingSymmetric(horizontal: 16),
                            16.height,
                            PriceCalculation(
                                    cartItemList: cartItemList,
                                    key: UniqueKey(),
                                    context: BuildContext)
                                .paddingSymmetric(horizontal: 16),
                          ],
                        ),
                      )
                    ],
                  ),
                )
              : Observer(
                  builder: (context) => NoDataFoundWidget(
                    title: 'Your Cart is Empty',
                  ).visible(!appStore.isLoading),
                ),
          Observer(
            builder: (context) => AppLoaderWidget()
                .visible(appStore.isLoading.validate())
                .center(),
          )
        ],
      ),
    );
  }
}
