import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:granth_flutter/component/app_loader_widget.dart';
import 'package:granth_flutter/main.dart';
import 'package:granth_flutter/component/cache_image_widget.dart';
import 'package:granth_flutter/configs.dart';
import 'package:granth_flutter/screen/auth/component/mobile_edit_profile_component.dart';
import 'package:granth_flutter/screen/auth/web_screen/edit_profile_screen_web.dart';
import 'package:granth_flutter/utils/images.dart';
import 'package:granth_flutter/widgets/background_widget.dart';
import 'package:image_picker/image_picker.dart';
import 'package:nb_utils/nb_utils.dart';

import '../../widgets/custom_back_button.dart';

class EditProfileScreen extends StatefulWidget {
  static String tag = '/EditProfileScreen';

  @override
  EditProfileScreenState createState() => EditProfileScreenState();
}

class EditProfileScreenState extends State<EditProfileScreen> {
  File? imageFile;
  Uint8List imageWebFile = Uint8List(8);
  bool loadFromFile = false;

  @override
  void initState() {
    super.initState();
    init();
  }

  Future<void> init() async {
    //
  }

  Future getImage(ImageSource source) async {
    var image = await ImagePicker().pickImage(source: source);
    if (image != null) {
      if (!isWeb) {
        setState(() {
          imageFile = File(image.path);
          loadFromFile = true;
          finish(context);
        });
      } else {
        var f = await image.readAsBytes();
        setState(() {
          imageWebFile = f;
          imageFile = File('a');
          loadFromFile = true;
          finish(context);
        });
      }
    }
  }

  Future showBottomSheet() {
    return showModalBottomSheet(
      isScrollControlled: false,
      context: context,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.vertical(top: Radius.circular(16))),
      backgroundColor: whiteColor,
      builder: (context) {
        return Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            SettingItemWidget(
              title: language!.camera,
              leading: Icon(Icons.camera_alt_outlined),
              titleTextStyle: primaryTextStyle(),
              onTap: () {
                getImage(ImageSource.camera);
              },
            ),
            SettingItemWidget(
              title: language!.gallery,
              leading: Icon(Icons.photo),
              titleTextStyle: primaryTextStyle(),
              onTap: () {
                getImage(ImageSource.gallery);
              },
            ),
          ],
        );
      },
    );
  }

  @override
  void setState(fn) {
    if (mounted) super.setState(fn);
  }

  @override
  Widget build(BuildContext context) {
    return BackgroundWidget(
      child: Scaffold(
        backgroundColor: transparentColor,
        resizeToAvoidBottomInset: true,
        appBar: appBarWidget(language!.editProfile, textColor: appStore.isDarkMode ? Colors.white : Colors.black,
            titleTextStyle: boldTextStyle(
                color: appStore.isDarkMode ? Colors.white : Colors.black,
                size: 32), elevation: 0, color: transparentColor, center: true,
        backWidget: CustomBackButton()),
        body: Stack(
          children: [
            Positioned(
              top: kToolbarHeight,
              left: 0,
              right: 0,
              child: Center(
                child: Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: imageFile != null
                          ? Builder(
                              builder: (context) {
                                return isWeb
                                    ? Image.memory(
                                        imageWebFile,
                                        width: 100,
                                        height: 100,
                                        fit: BoxFit.cover,
                                      ).cornerRadiusWithClipRRect(32)
                                    : Image.file(imageFile!, width: 100, height: 100, fit: BoxFit.cover).cornerRadiusWithClipRRect(32);
                              },
                            )
                          : appStore.userProfile.isNotEmpty
                              ? Observer(
                                  builder: (_) => CachedImageWidget(
                                    url: appStore.userProfile,
                                    height: 100,
                                    width: 100,
                                    fit: BoxFit.cover,
                                  ).cornerRadiusWithClipRRect(32),
                                )
                              : Image.asset(place_holder_img, width: 100, height: 100, fit: BoxFit.cover).cornerRadiusWithClipRRect(32),
                    ),
                    Positioned(
                      right: 0,
                      bottom: 0,
                      child: CircleAvatar(
                        radius: defaultRadius,
                        backgroundColor: defaultPrimaryColor,
                        child: IconButton(
                          padding: EdgeInsets.all(4),
                          icon: SvgPicture.asset(upload_imageSvg),
                          onPressed: () {
                            showBottomSheet();
                          },
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ),
            Responsive(
              mobile: MobileEditProfileComponent(imageFile: imageFile),
              web: WebEditProfileScreen(imageWebFile: imageWebFile),
              tablet: WebEditProfileScreen(width: context.width() / 2 - 20, imageWebFile: imageWebFile),
            ),
            Observer(
              builder: (context) {
                return AppLoaderWidget().center().visible(appStore.isLoading);
              },
            )
          ],
        ),
      ),
    );
  }
}
