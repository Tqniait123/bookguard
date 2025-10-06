import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:granth_flutter/component/app_loader_widget.dart';
import 'package:granth_flutter/component/no_data_found_widget.dart';
import 'package:granth_flutter/screen/book/component/book_component.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/bookdetail_model.dart';
import 'package:granth_flutter/widgets/background_widget.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../widgets/custom_back_button.dart';

class MobileWishListComponent extends StatelessWidget {
  const MobileWishListComponent({Key? key, required this.wishList, this.width}) : super(key: key);

  final List<BookDetailResponse>? wishList;
  final double? width;

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        appBar: appBarWidget(language!.myWishlist,center: true, titleTextStyle: boldTextStyle(color: appStore.isDarkMode ? Colors.white : Colors.black, size: 32), elevation: 0, color: transparentColor, backWidget:
        CustomBackButton()),
        body: Stack(
          fit: StackFit.expand,
          children: [
            if (!appStore.isLoading)
              wishList!.isEmpty
                  ? NoDataFoundWidget()
                  : SingleChildScrollView(
                      padding: EdgeInsets.all(defaultRadius),
                      child: Wrap(
                        spacing: 8,
                        runSpacing: 16,
                        children: wishList!.map(
                          (element) {
                            BookDetailResponse mData = wishList![wishList!.indexOf(element)];
                            return SizedBox(
                              width: width ?? (context.width() / 2) - 22,
                              child: BookComponent(bookData: mData, isWishList: true, isCenterBookInfo: true),
                            );
                          },
                        ).toList(),
                      ),
                    ),
            if (appStore.isLoading)
              Observer(
                builder: (context) {
                  return AppLoaderWidget().center();
                },
              ),
          ],
        ),
      ),
    );
  }
}
