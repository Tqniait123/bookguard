import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:granth_flutter/component/app_scroll_behaviour.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/models/dashboard_model.dart';
import 'package:granth_flutter/screen/book/component/book_list_component.dart';
import 'package:granth_flutter/screen/book/view_all_book_screen.dart';
import 'package:granth_flutter/screen/dashboard/category_list_screen.dart';
import 'package:granth_flutter/screen/dashboard/component/author_list_component.dart';
import 'package:granth_flutter/screen/dashboard/component/category_component.dart';
import 'package:granth_flutter/screen/dashboard/component/see_all_component.dart';
import 'package:granth_flutter/utils/constants.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../../utils/common.dart';
import '../../../utils/images.dart';
import '../component/banner_widget.dart';
import '../search_screen.dart';

class MobileDashboardFragment extends StatelessWidget {
  final DashboardResponse? data;

  MobileDashboardFragment({this.data});

  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: AppScrollBehavior(),
      child: AnimatedScrollView(
        listAnimationType: ListAnimationType.FadeIn,
        dragStartBehavior: DragStartBehavior.start,
        physics: AlwaysScrollableScrollPhysics(),
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              SizedBox(height: kToolbarHeight),
              if(appStore.isLoggedIn)Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                child: Text('${language!.welcomeBack}, ${appStore.name}', style: TextStyle(
                  color: appStore.isDarkMode ? Colors.grey.shade300 : Color(0xFF9D9D9D),
                  fontSize: 16,
                  fontWeight: FontWeight.w500
                ),),
              ),
              Padding(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                child: Text(language!.whatDoYouWantToRead, style: TextStyle(
                  color: appStore.isDarkMode ? Colors.white : Color(0xFF19191B),
                  fontSize: 26,
                  fontWeight: FontWeight.w500
                ),),
              ),
              16.height,
              Container(
                padding: EdgeInsetsGeometry.symmetric(horizontal: 16),
                decoration: BoxDecoration(
                  boxShadow: appStore.isDarkMode ? null : [
                    BoxShadow(
                      color: Color(0xFF99ABC6).withValues(alpha: 0.2),
                      blurRadius: 30,
                      offset: Offset(0, 4)
                    )
                  ],
                ),
                child: GestureDetector(
                  onTap: (){
                    SearchScreen().launch(context, pageRouteAnimation: PageRouteAnimation.Slide);
                  },
                  child: AppTextField(
                    // controller: emailController,

                    autoFocus: false,
                    enabled: false,
                    textFieldType: TextFieldType.OTHER,
                    decoration: inputDecoration(context, hintText: language!.whatAreYouLookingFor, preFixIcon: UnconstrainedBox(child: SvgPicture.asset(searchSvg, height: 30,)),
                    fillColor: appStore.isDarkMode ? null : Colors.white,
                      borderColor: Color(0xFFEAEAEA),
                      contentPadding: EdgeInsets.all(16),
                      borderRadius: 10,
                    ),
                  ),
                ),
              ),
              // if(data!.slider != null && data!.slider!.isNotEmpty)BannerWidget(sliders: data!.slider!,),
              // if (data!.slider != null && data!.slider!.isNotEmpty) 24.height,
              ///Category
              if (data!.categoryBook!.isNotEmpty) 24.height,
              SeeAllComponent(
                title: language!.categories,
                onClick: () {
                  CategoryListScreen().launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              CategoryComponent(categoryBookList: data!.categoryBook.validate()),

              16.height,
              ///Author List Details
              if (data!.topAuthor!.isNotEmpty) AuthorListComponent(authorList: data!.topAuthor.validate()),


              ///Popular Search Book
              if (data!.topSearchBook!.isNotEmpty) 24.height,

              SeeAllComponent(
                title: language!.popularBooks,
                onClick: () {
                  ViewAllBookScreen(type: POPULAR_BOOKS, title: language!.popularBooks).launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              BookListComponent(bookDetailsList: data!.popularBook.validate()),

              ///Top Sell Book
              if (data!.topSellBook!.isNotEmpty) 24.height,
              SeeAllComponent(
                title: language!.topSellBooks,
                onClick: () {
                  ViewAllBookScreen(type: TOP_SELL_BOOKS, title: language!.topSellBooks).launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              BookListComponent(bookDetailsList: data!.topSellBook.validate()),

              ///Recommended Books
              if (data!.recommendedBook!.isNotEmpty) 24.height,
              SeeAllComponent(
                title: language!.recommendedBooks,
                onClick: () {
                  ViewAllBookScreen(type: RECOMMENDED_BOOKS, title: language!.recommendedBooks).launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              BookListComponent(bookDetailsList: data!.recommendedBook.validate()),


              ///Top Search Book
              if (data!.topSearchBook!.isNotEmpty) 24.height,
              SeeAllComponent(
                title: language!.topSearchBooks,
                onClick: () {
                  ViewAllBookScreen(type: TOP_SEARCH_BOOKS, title: language!.topSearchBooks).launch(context);
                },
              ).paddingSymmetric(horizontal: 16),
              16.height,
              BookListComponent(bookDetailsList: data!.topSearchBook.validate()),


              16.height,
            ],
          ),
        ],
      ),
    );
  }
}
