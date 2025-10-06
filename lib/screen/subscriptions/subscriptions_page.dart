import 'dart:convert';
import 'dart:io';

import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/book_list_model.dart';
import 'package:granth_flutter/models/bookdetail_model.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/models/downloaded_book.dart';
import 'package:granth_flutter/network/rest_apis.dart';
import 'package:granth_flutter/screen/book/component/library_componet.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:granth_flutter/utils/file_common.dart';
import 'package:granth_flutter/widgets/background_widget.dart';
import 'package:granth_flutter/widgets/custom_back_button.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../component/app_loader_widget.dart';
import '../../models/paymentMethod_model.dart';
import '../../models/plan_model.dart';
import '../payment/fawaterk_payment.dart';
import '../payment/payment_done.dart';
import 'components/plan_component.dart';

class SubscriptionsPage extends StatefulWidget {
  @override
  _SubscriptionsPageState createState() => _SubscriptionsPageState();
}

class _SubscriptionsPageState extends State<SubscriptionsPage> {
  List<DownloadedBook> purchasedList = [];
  List<DownloadedBook> sampleList = [];
  List<PlanDetails> yearlyPlans = [];
  List<PlanDetails> monthlyPlans = [];
  PlanDetails? selectedPlan;
  List<DownloadedBook> downloadedList = [];
  PlanModel? planModel;
  List<PaymentMethodModel>? paymentMethods;
  PaymentMethodModel? selectedPaymentMethod;

  bool _methodsLoad = false;

  late FawaterkServices fawaterkServices;

  bool isDataLoaded = false;

  @override
  void initState() {
    super.initState();
    afterBuildCreated(() {
      LiveStream().on(REFRESH_lIBRARY_LIST, (p0) async {
        if (mounted) {
          // await fetchData();
          await getData();
        }
      });
      init();
    });
  }

  void init() async {
    // fetchData();
    getData();
  }

  getPaymentMethods() async {
    fawaterkServices = FawaterkServices();

    await fawaterkServices.getApiKey().then((val) async {
      paymentMethods = await fawaterkServices.fetchPaymentMethods();
      if (paymentMethods != null) {
        paymentMethods!.removeWhere((e) => e.redirect == 'false');
        if(Platform.isIOS){
          paymentMethods!.removeWhere((e) => e.nameEn != 'applepay');
        }
      }
      setState(() {});
      print(paymentMethods);
    });
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  DownloadedBook? isExists(List<DownloadedBook> tasks, BookDetailResponse mBookDetail) {
    DownloadedBook? exist;
    tasks.forEach((task) {
      if (task.bookId == mBookDetail.bookId.toString() && task.fileType == PURCHASED_BOOK) {
        exist = task;
      }
    });
    if (exist == null) {
      exist = defaultBook(mBookDetail, PURCHASED_BOOK);
    }
    return exist;
  }


  Future<void> getData() async {
    appStore.setLoading(true);
    await getPlans().then((value) {
      planModel = value;
      yearlyPlans = planModel?.data?.yearlyPlans??[];
      monthlyPlans = planModel?.data?.monthlyPlans??[];
      setState(() {});
    }).catchError((e) {
      toast(e.toString());
    });
    appStore.setLoading(false);
  }

  Future<void> subscribe(int planId) async {
    print('-----------------------');
    finish(context);
    appStore.setLoading(true);
    await getPaymentMethods();
    appStore.setLoading(false);

    await showBottomSheet(() async{

      if (selectedPaymentMethod != null) {
        finish(context);
        fawaterkServices.sendPaymentForSubscription(
            context: context,
            paymentMethod: selectedPaymentMethod!,
            plan: selectedPlan!,
            totalAmount: selectedPlan!.price!,
            afterSuccess: (invoiceId) async{
              finish(context);
              var trDetails = {
                "TXNID": invoiceId,
                "STATUS": "TXN_SUCCESS",
                "TXN_PAYMENT_ID": selectedPaymentMethod!.paymentId.toString(),
              };
              var plan = {
                'plan_id' : planId.toString(),
              };
              var typeEn = selectedPaymentMethod!.nameEn;
              var typeAr = selectedPaymentMethod!.nameAr;

              appStore.setLoading(true);
              // await saveTransaction(
              //     request, data, selectedPaymentMethod!.paymentId, 'TXN_SUCCESS', appStore.payableAmount);
              await subscribeApi(trDetails, planId.toString(), typeEn, typeAr).then((value) {
                toast(value.message);
                if(value.status == true){
                  getData();
                  appStore.setUserActiveSubscription(true);

                  PaymentSuccessPage().launch(context);
                }
                setState(() {});
              }).catchError((e) {
                toast(e.toString());
              });
              appStore.setLoading(false);
            }
        );
        // PaymentWebViewScreen(url: '',).launch(context);
      }else{
        toast('choose payment method');
      }
    });
  }

  @override
  void dispose() {
    LiveStream().dispose(REFRESH_lIBRARY_LIST);
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Observer(
          builder: (context) => DefaultTabController(
            length: 2,
            child: BackgroundWidget(
              child: Scaffold(
                backgroundColor: transparentColor,
                body: NestedScrollView(
                  headerSliverBuilder: (BuildContext context, bool innerBoxIsScrolled) {
                    return <Widget>[
                      SliverAppBar(
                        elevation: 0,
                        backgroundColor: transparentColor,
                        automaticallyImplyLeading: false,
                        expandedHeight: 120,
                        pinned: true,
                        titleSpacing: 16,
                        actions: <Widget>[],
                        leading: CustomBackButton(),
                        bottom: TabBar(
                          automaticIndicatorColorAdjustment: false,
                          indicatorColor: defaultPrimaryColor,
                          indicatorSize: TabBarIndicatorSize.tab,
                          unselectedLabelColor: appStore.isDarkMode ? white : blackColor,
                          labelColor: defaultPrimaryColor,
                          isScrollable: false,
                          onTap: (index) {
                            appStore.setTabBarIndex(index);
                          },
                          tabs:  [
                            Tab(text: language!.month),
                            Tab(text: language!.years),
                          ],
                        ),
                        flexibleSpace: FlexibleSpaceBar(
                          title: Text(language!.subscriptions, style: boldTextStyle()),
                          titlePadding: EdgeInsets.only(bottom: 80, left: 16),
                          centerTitle: true,
                        ),
                      )
                    ];
                  },
                  body: Stack(
                    children: [
                      appStore.isLoggedIn && appStore.isNetworkConnected
                          ? TabBarView(
                        children: [
                          monthlyPlans.isNotEmpty
                              ? PlanComponent(
                            list: monthlyPlans,
                            i: 0,
                            onPlanSelected: (int planId){
                              selectedPlan = monthlyPlans.firstWhere((plan)=> plan.id == planId);
                              subscribe(planId);
                            },
                          )
                              : Observer(builder: (context) {
                            return NoDataWidget(
                              title: language!.noSampleBooksDownload,
                            ).visible(!appStore.isLoading && isDataLoaded);
                          }),
                          yearlyPlans.isNotEmpty
                              ? PlanComponent(
                            list: yearlyPlans,
                            i: 1,
                            onPlanSelected: (int planId){
                              selectedPlan = yearlyPlans.firstWhere((plan)=> plan.id == planId);
                              subscribe(planId);
                            },
                          )
                              : NoDataWidget(
                            title: language!.noPurchasedBookAvailable,
                          ).visible(isDataLoaded && !appStore.isLoading),
                        ],
                      )
                          : TabBarView(
                        children: [
                          yearlyPlans.isNotEmpty
                              ? PlanComponent(
                            list: monthlyPlans,
                            i: 0,
                            onPlanSelected: (int planId){
                              subscribe(planId);
                            },
                          )
                              : NoDataWidget(
                            title: language!.noSampleBooksDownload,
                          ).visible(isDataLoaded && !appStore.isLoading),
                          monthlyPlans.isNotEmpty
                              ? PlanComponent(
                            list: monthlyPlans,
                            i: 0,
              
                          )
                              : NoDataWidget(title: language!.noPurchasedBookAvailable).visible(isDataLoaded && !appStore.isLoading)
                        ],
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ),
        ),
        Observer(
          builder: (context) => AppLoaderWidget().visible(appStore.isLoading.validate()).center(),
        )
      ],
    );
  }

  Future showBottomSheet(Function subscribeRequest) {
    return showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      backgroundColor: whiteColor,
      builder: (context) {
        return PaymentMethodsBottomSheet(paymentMethods: paymentMethods, subscribeRequest: subscribeRequest, onSelect: (paymentMethod){
          selectedPaymentMethod = paymentMethod;
          setState(() {});
        },);
      },
    );
  }
}

class PaymentMethodsBottomSheet extends StatefulWidget {
  const PaymentMethodsBottomSheet({super.key, this.paymentMethods, required this.subscribeRequest, required this.onSelect});

  final List<PaymentMethodModel>? paymentMethods;
  final Function subscribeRequest;
  final Function(PaymentMethodModel) onSelect;

  @override
  State<PaymentMethodsBottomSheet> createState() => _PaymentMethodsBottomSheetState();
}

class _PaymentMethodsBottomSheetState extends State<PaymentMethodsBottomSheet> {
  PaymentMethodModel? selectedPaymentMethod;

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      crossAxisAlignment: CrossAxisAlignment.start,
      mainAxisAlignment: MainAxisAlignment.start,
      children: <Widget>[
        8.height,
        Center(
          child: Container(
            height: 8,
            width: 50,
            decoration: BoxDecoration(
              color: Colors.grey,
              borderRadius: BorderRadius.circular(20),
            ),
          ),
        ),
        8.height,
        Text(language!.paymentMethod,
            style: boldTextStyle())
            .paddingSymmetric(horizontal: 16),
        8.height,
        HorizontalList(
          itemCount: widget.paymentMethods?.length ?? 0,
          spacing: 0,
          runSpacing: 0,
          itemBuilder: (context, index) {
            return Container(
              height: 60,
              margin: EdgeInsets.symmetric(horizontal: 8),
              decoration: boxDecorationWithRoundedCorners(
                backgroundColor: context.cardColor,
                border: selectedPaymentMethod?.paymentId ==
                    widget.paymentMethods?[index].paymentId
                    ? Border.all(color: defaultPrimaryColor)
                    : Border.all(color: transparentColor),
              ),
              child: TextIcon(
                edgeInsets: EdgeInsets.all(16),
                spacing: 8,
                text: widget.paymentMethods?[index].nameEn ?? '',
                textStyle: secondaryTextStyle(),
                prefix: FancyShimmerImage(
                  imageUrl:
                  widget.paymentMethods?[index].logo ?? '',
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
                widget.paymentMethods?[index];
                widget.onSelect(selectedPaymentMethod!);
              });
            },
                highlightColor: transparentColor,
                splashColor: transparentColor);
          },
        ),
        12.height,
        Container(
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
              widget.subscribeRequest();

            },
          ),
        ).paddingAll(16)
      ],
    );
  }
}

