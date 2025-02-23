import 'package:carousel_slider_plus/carousel_slider_plus.dart';
import 'package:fancy_shimmer_image/fancy_shimmer_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../../models/slider_model.dart';
import '../../../utils/images.dart';


class BannerWidget extends StatelessWidget {
  const BannerWidget({super.key, required this.sliders});

  final List<SliderResponse> sliders;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: CarouselSlider(
            items:
            List.generate(sliders.length??0, (index)=>
                imageFancy(sliders[index].slideImage, sliders[index].title)),
            options: CarouselOptions(
              // height: 400,
              aspectRatio: 16/9,
              viewportFraction: 1,
              initialPage: 0,
              enableInfiniteScroll: true,
              reverse: false,
              autoPlay: true,
              autoPlayInterval: const Duration(seconds: 3),
              autoPlayAnimationDuration: const Duration(milliseconds: 800),
              autoPlayCurve: Curves.fastOutSlowIn,
              enlargeCenterPage: true,
              enlargeFactor: 0.3,
              // onPageChanged: callbackFunction,
              scrollDirection: Axis.horizontal,
            )
        ),
    );
  }

  Widget imageFancy(String? image, String? title ){
    return Stack(
      children: [
        ClipRRect(
          borderRadius: BorderRadius.circular(22),
          child: FancyShimmerImage(
            imageUrl: image??'',
            // height: MediaQuery.of(context).size.width - 32,
            width:double.infinity,
            boxFit: BoxFit.contain ,
            errorWidget: Image.asset(
              place_holder_img,
              fit: BoxFit.contain,
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(22),
            // gradient: LinearGradient(
            //   begin: Alignment.topCenter,
            //   end: Alignment.bottomCenter,
            //   colors: [
            //     AppColors.yPrimaryColor.withOpacity(0.4),
            //     AppColors.yPrimaryColor.withOpacity(0.37),
            //     AppColors.yPrimaryColor.withOpacity(0.35),
            //     AppColors.yPrimaryColor.withOpacity(0.3),
            //     AppColors.yPrimaryColor.withOpacity(0.3),
            //     AppColors.yPrimaryColor.withOpacity(0.3),
            //     Colors.black.withOpacity(0.35),
            //     Colors.black.withOpacity(0.5),
            //     Colors.black.withOpacity(0.7),
            //     Colors.black.withOpacity(0.9),
            //   ],
            // ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                title??'',
                style: TextStyle(
                fontSize: 32,
                color: Colors.white,
                fontWeight: FontWeight.w700,),
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),

      ],
    );
  }
}
