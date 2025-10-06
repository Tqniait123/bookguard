import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/cart_response.dart';
import 'package:granth_flutter/configs.dart';
import 'package:nb_utils/nb_utils.dart';

class PriceCalculation extends StatefulWidget {
  final List<CartModel>? cartItemList;
  final context;

  PriceCalculation({this.cartItemList, this.context, Key? key}) : super(key: key);

  @override
  PriceCalculationState createState() => PriceCalculationState();
}

class PriceCalculationState extends State<PriceCalculation> {
  double total = 0.0;
  double discount = 0.0;
  double discountPrice = 0.0;
  double mrp = 0.0;

  List<CartModel> cartItemListTemp = [];

  @override
  void initState() {
    super.initState();
    init();
  }

  void init() async {
    setCartItem(widget.cartItemList);
  }

  void setCartItem(List<CartModel>? cartItems) async {
    cartItemListTemp.clear();

    total = 0.0;
    discount = 0.0;
    total = 0.0;

    setState(() {});

    cartItemListTemp.addAll(cartItems!);

    mrp = cartItemListTemp.sumByDouble((p0) => p0.price.validate());

    discountPrice = cartItemListTemp.where((element) => element.discountedPrice != 0).sumByDouble((p0) => p0.price.validate() - p0.discountedPrice.validate());

    // total = mrp - discountPrice;
    appStore.setPayableAmount(mrp - discountPrice);
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return Container(
        width: context.width(),
        decoration: boxDecorationWithRoundedCorners(
          backgroundColor: appStore.isDarkMode ? Colors.grey.shade900 : Color(0xFFF4F4F4),
          boxShadow: defaultBoxShadow(shadowColor: grey.withValues(alpha: 0.2), spreadRadius: 0.5, offset: Offset(0.3, 0.2), blurRadius: 1),
        ),
        child: Column(
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language!.subTotal, style: primaryTextStyle(size: 16,weight: FontWeight.w500, color: appStore.isDarkMode ? Colors.grey.shade500 : Color(0xFF272727).withValues(alpha: 0.6)), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                8.width,
                Text('${mrp.toString()}$defaultCurrencySymbol', style: primaryTextStyle(size: 18, color: appStore.isDarkMode ? Colors.white : Colors.black,)),
              ],
            ),
            16.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(language!.discount, style: primaryTextStyle(size: 16,weight: FontWeight.w500, color: appStore.isDarkMode ? Colors.grey.shade500 : Color(0xFF272727).withValues(alpha: 0.6)), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                8.width,
                Text('${discountPrice.validate().toStringAsFixed(1)}$defaultCurrencySymbol', style: primaryTextStyle(size: 18, weight: FontWeight.w500, color: appStore.isDarkMode ? Colors.white : Colors.black,)),
              ],
            ),
            8.height,
            Divider(),
            8.height,
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text('${language!.total}', style: boldTextStyle(size: 16,weight: FontWeight.w500, color: appStore.isDarkMode ? Colors.grey.shade500 : Color(0xFF272727).withValues(alpha: 0.6)), maxLines: 2, overflow: TextOverflow.ellipsis).expand(),
                8.width,
                Text('${appStore.payableAmount.toString()}$defaultCurrencySymbol', style: boldTextStyle(color: appStore.isDarkMode ? Colors.white : Colors.black, size: 18, weight: FontWeight.w700)),
              ],
            ),
          ],
        ).paddingAll(16),
      );
    });
  }
}
