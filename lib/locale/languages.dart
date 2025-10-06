import 'package:flutter/material.dart';

abstract class BaseLanguage {
  static BaseLanguage of(BuildContext context) => Localizations.of<BaseLanguage>(context, BaseLanguage)!;

  String get createYourAccount;

  String get name;

  String get userName;

  String get email;

  String get contactNumber;

  String get password;

  String get confirmPassword;

  String get confirmPasswordRequired;

  String get passwordDoesnTMatch;

  String get login;

  String get loginSuccessfully;

  String get loginToYourAccount;

  String get dashboard;

  String get topSearchBooks;

  String get popularBooks;

  String get topPopularBooks;

  String get topSellBooks;

  String get categories;

  String get recommendedBooks;

  String get authors;

  String get authorDetails;

  String get aboutMe;

  String get authorBook;

  String get reviews;

  String get noDataFound;

  String get topReviews;

  String get writeReview;

  String get overview;

  String get information;

  String get youMayAlsoLike;

  String get currentPassword;

  String get newPassword;

  String get thisFieldIsRequired;

  String get passwordMustBeSame;

  String get chooseDetailPageVariant;

  String get enterYourName;

  String get enterYourUsername;

  String get enterYourEmail;

  String get enterYourMobileNumber;

  String get updateProfile;

  String get feedback;

  String get enterYourNewEmail;

  String get enterYourMessage;

  String get submit;

  String get reset;

  String get noInternet;

  String get searchBooks;

  String get searchResultFor;

  String get searchForBooksBy;

  String get changeYourPassword;

  String get transactionHistory;

  String get transactionHistoryReport;

  String get changePassword;

  String get appLanguage;

  String get changeYourLanguage;

  String get appTheme;

  String get tapToEnableLightMode;

  String get tapToEnableDarkMode;

  String get animationMadeEvenBetter;

  String get disablePushNotification;

  String get tapToEnableNotification;

  String get tapToDisableNotification;

  String get signOut;

  String get areYouSureWantToLogout;

  String get areYouSureWantToSubscribe;

  String get yes;

  String get no;

  String get placeOrder;

  String get paymentMethod;

  String get paymentDetails;

  String get designation;

  String get areYouSureWant;

  String get category;

  String get price;

  String get removed;

  String get added;

  String get viewSample;

  String get downloadSample;

  String get pleaseWait;

  String get addToCart;

  String get readBook;

  String get areYouSureWantToRemoveCart;

  String get fontSize;

  String get set;

  String get freeDailyBook;

  String get getItNow;

  String get created;

  String get publisher;

  String get availableFormat;

  String get totalPage;

  String get edit;

  String get delete;

  String get recentSearch;

  String get clearAll;

  String get seeAll;

  String get hey;

  String get loggedIn;

  String get chooseTheme;

  String get yourReview;

  String get areYouSureWantToDelete;

  String get language;

  String get myCart;

  String get sample;

  String get month;

  String get years;

  String get year;

  String get subscriptions;

  String get subscribeNow;

  String get purchase;

  String get download;

  String get myLibrary;

  String get noSampleBooksDownload;

  String get noPurchasedBookAvailable;

  String get noBookAvailable;

  String get introduction;

  String get camera;

  String get gallery;

  String get forgotPassword;

  String get verifyOtp;

  String get verify;

  String get lblForgotPassword;

  String get donTHaveAnAccount;

  String get register;

  String get signUp;

  String get joinNow;

  String get alreadyHaveAnAccount;

  String get youCanReadBooksEasily;

  String get discoverEndlessBookWorlds;

  String get organizeYourReadingList;

  String get walkThrow3;

  String get youCanDownloadBooks;

  String get youCanReadBooks;

  String get readBookAnywhere;

  String get walkThrow1;

  String get walkThrow2;

  String get inspireDiscussGrow;

  String get connectWithBookLovers;

  String get downloadBooks;

  String get offlineBookRead;

  String get next;

  String get lblContinue;

  String get myWishlist;

  String get free;

  String get downloading;

  String get totalMrp;

  String get subTotal;

  String get discount;

  String get total;

  String get signInToContinue;

  String get termsConditions;

  String get rateUs;

  String get share;

  String get aboutApp;

  String get cancel;

  String get editProfile;

  String get aboutUs;

  String get buyNow;

  String get areYouSureWantToRemoveReview;

  String get processing;

  String get transactionSuccessfully;

  String get appthemeLight;

  String get appthemeDark;

  String get appthemeDefault;

  String get books;

  String get createANewPassword;

  String get resetPassword;

  String get youNewPasswordMust;

  String get createYourNewPassword;

  String get confirmNewPassword;

  String get YouHaveChangedSuccessfully;

  String get pleaseUseNewPassword;

  String get oldPassword;

  String get pleaseEnterInfoTo;

  String get weHaveSentA;

  String get justEnterTheEmail;

  String get message;

  String get getStarted;

  String get goToCart;

  String get cart;

  String get profile;

  String get account;

  String get library;

  String get youAlreadySubscribed;

  String get startedAt;

  String get endAt;

  String get subscriptionHistory;

  String get current;

  String get deleteAccount;

  String get areYouSureWantToDeleteAccount;

  String get enterOTP;

  String get resendCodeIn;

  String get sendOtp;

  String get sendCode;

  String get resendCode;

  String get addBookmarkToPage;

  String get currentPageWillSavedAsBookmark;

  String get noteOptional;

  String get save;

  String get pageBookmarkAddedSuccessfully;

  String get addBookmarkToSelectedText;

  String get selectedText;

  String get textBookmarkAddedSuccessfully;

  String get bookmarkSelectedText;

  String get addHighlightAndBookmark;

  String get highlight;

  String get highlightAndBookmarkAdded;

  String get bookmarkThePage;

  String get showBookmarks;

  String get bookmarkAndHighlight;

  String get noBookmarksSaved;

  String get bookmarkPages;

  String get note;

  String get saveDone;

  String get confirmDeletion;

  String get doYouWantDeleteThisBookmark;

  String get bookmarksDeleted;

  String get selectBookmarkColor;

  String get changeFontSize;

  String get loading;

  String get signInToYourAccount;

  String get bySigningUp;

  String get termsOfService;

  String get and;

  String get whatAreYouLookingFor;

  String get welcomeBack;

  String get whatDoYouWantToRead;

  String get editNow;

  String get bookDetails;

  String get views;

  String get removeAll;

  String get searchPlaceholder;

  String get phoneValidation;

  String get phoneInvalid;
}
