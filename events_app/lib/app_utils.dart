import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'presentation/loginScreen.dart';

final Map<String, String> en = {
  "lbl_0": "0",
  "lbl_1": "1",
  "lbl_123_events": "123 Events",
  "lbl_1_ticket": "1 Ticket",
  "lbl_2": "2",
  "lbl_2021": "2021",
  "lbl_2022": "2022",
  "lbl_2_fee": "+ €2 Fee",
  "lbl_2_ticket_s": "2 Ticket's",
  "lbl_3_ticket_s": "3 Ticket's",
  "lbl_45_00": "€45.00",
  "lbl_45_00_2_fee": "€45.00 + €2 Fee",
  "lbl_55_00": "€55.00",
  "lbl_55_00_2_fee": "€55.00 + €2 Fee",
  "lbl_65_00": "€65.00",
  "lbl_65_00_2_fee": "€65.00 + €2 Fee",
  "lbl_67_00": "€67.00",
  "lbl_6_ticket": "6 ticket",
  "lbl_about": "About",
  "lbl_add_favourites": "Add favourites",
  "lbl_add_to_calandar": "Add to calandar",
  "lbl_apple_play": "Apple Play",
  "lbl_apply_filter": "Apply filter",
  "lbl_arcade_fire": "Arcade Fire",
  "lbl_arts": "Arts",
  "lbl_barcelona": "Barcelona",
  "lbl_ben_plat": "Ben Plat",
  "lbl_berlin": "Berlin",
  "lbl_bitcoin": "BitCoin",
  "lbl_business": "Business",
  "lbl_buy": "Buy",
  "lbl_choose_a_city": "Choose a city",
  "lbl_community": "Community",
  "lbl_concert": "Concert",
  "lbl_contact_info": "Contact info",
  "lbl_credit_card": "Credit Card",
  "lbl_data": "Data",
  "lbl_early_bird": "Early Bird",
  "lbl_english": "English",
  "lbl_expo": "Expo",
  "lbl_favourites": "Favourites",
  "lbl_fede_lanzi": "Fede Lanzi",
  "lbl_filters": "Filters",
  "lbl_find_events_in": "Find events in",
  "lbl_flut": "Flut",
  "lbl_food_drink": "Food & Drink",
  "lbl_general": "General",
  "lbl_german": "German",
  "lbl_hello": "Hello!",
  "lbl_italian": "Italian",
  "lbl_italy": "Italy",
  "lbl_kasabian": "Kasabian",
  "lbl_la_monumental": "La Monumental",
  "lbl_la_rosalia": "La Rosalia",
  "lbl_languages": "Languages",
  "lbl_logout": "Logout",
  "lbl_london": "London",
  "lbl_m_neskin": "Måneskin",
  "lbl_madrid": "Madrid",
  "lbl_manage_events": "Manage Events",
  "lbl_milan": "Milan",
  "lbl_most_searched": "Most Searched",
  "lbl_music": "Music",
  "lbl_new": "New",
  "lbl_nik_mulvey": "Nik Mulvey",
  "lbl_no_ticket_yes": "No ticket yes",
  "lbl_past_tcikets": "Past Tcikets",
  "lbl_past_tickets": "Past Tickets",
  "lbl_pay_with": "Pay with ",
  "lbl_payment_methods": "Payment methods",
  "lbl_price": "Price",
  "lbl_primary_city": "Primary City",
  "lbl_razzmatazz": "Razzmatazz",
  "lbl_refund_policy": "Refund Policy",
  "lbl_rome": "Rome",
  "lbl_sala_apolo": "Sala Apolo",
  "lbl_search_for": "Search For....",
  "lbl_second_release": "Second Release",
  "lbl_settings": "Settings",
  "lbl_sold_out": "Sold Out!",
  "lbl_spain": "Spain",
  "lbl_spanish": "Spanish",
  "lbl_surname": "Surname",
  "lbl_the_fratellis": "The Fratellis",
  "lbl_the_kilelers": "The Kilelers",
  "lbl_the_kooks": "The Kooks",
  "lbl_the_weeknd": "The Weeknd",
  "lbl_the_wombats": "The Wombats",
  "lbl_tickets": "Tickets",
  "lbl_try_again": "Try again",
  "lbl_united_kingdom": "United Kingdom",
  "lbl_upcoming": "Upcoming",
  "lbl_view_on_maps": "View on maps",
  "lbl_your_name": "Your name",
  "lbl_your_surname": "Your surname",
  "msg_21_00_pm_23_30": "21:00 Pm 23.30 Pm",
  "msg_35_00_75_00": "€ 35.00 € 75.00",
  "msg_account_settingd": "Account Settingd",
  "msg_copy_event_to_calendar": "Copy Event to calendar",
  "msg_flut_fee_is_not_refundable": "Flut fee is not-refundable.",
  "msg_foster_the_people": "Foster The People",
  "msg_fri_apr_20_20_00": "Fri, Apr 20. 20.00 Pm",
  "msg_fri_apr_22_21_00": "Fri, Apr 22 21.00 Pm",
  "msg_fri_mar_2_20_30": "Fri, Mar 2 20:30 Pm",
  "msg_info_youremail_com": "info@youremail.com",
  "msg_let_s_find_your": "Let's find your next event. \nChoose a location.",
  "msg_lorem_ipsum_dolor":
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor D ",
  "msg_lorem_ipsum_dolor2":
      "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor in",
  "msg_make_sure_you_have_added":
      "Make sure you have\nadded event's in this section",
  "msg_make_sure_you_r":
      "Make sure you'r in the same account that purchased yout tickets",
  "msg_manage_log_in_options": "Manage Log in options",
  "msg_mon_apr_18_21_00": "Mon, Apr 18 21:00 Pm",
  "msg_mon_apr_18_21_002": "Mon, Apr 18 21:00 Pm",
  "msg_mon_apr_23_20_00": "Mon, Apr 23 20.00 Pm",
  "msg_mon_apr_25_17_30": "Mon, Apr 25 17.30",
  "msg_mon_feb_11_21_00": "Mon, Feb 11 21:00 Pm",
  "msg_never_miss_an_event": "Never Miss an Event",
  "msg_no_favourites_yes": "No favourites yes",
  "msg_of_monster_and_man": "Of Monster and Man",
  "msg_palau_sant_jordi": "Palau Sant Jordi, Barcelona",
  "msg_palau_sant_jordi2": "Palau Sant Jordi",
  "msg_passeig_ol_mpic": "Passeig Olímpic, 5-7, 08038 Barcelona",
  "msg_popular_in_barcelona": "Popular in Barcelona",
  "msg_remaining_time_20_32": "Remaining time 20.32",
  "msg_sales_end_on_apr": "Sales end on Apr 17, 2022",
  "msg_sat_jan_22_21_00": "Sat, Jan 22 21:00 Pm",
  "msg_select_location": "Select Location....",
  "msg_sort_by_relevant": "Sort by relevant",
  "msg_sun_apr_21_21_00": "Sun, Apr 21 21.00 Pm",
  "msg_thu_apr_19_20_00": "Thu, Apr 19 20.00 Pm",
  "msg_thu_may_18_21_30": "Thu, May 18 21:30 Pm",
  "msg_today_i_would_like": "Today I would like...",
  "msg_what_kind_of_event": "What kind of event?",
  "err_msg_please_enter_valid_text": "Please enter valid text",
  "err_msg_field_cannot_be_empty": "Field cannot be empty",
  "msg_network_err": "Network Error",
  "msg_something_went_wrong": "Something Went Wrong!"
};

const num FIGMA_DESIGN_WIDTH = 390;

const num FIGMA_DESIGN_HEIGHT = 844;

const num FIGMA_DESIGN_STATUS_BAR = 0;

const String dateTimeFormatPattern = 'dd/MM/yyyy';

/// Checks if string consist only Alphabet. (No Whitespace)

bool isText(String? inputString, {bool isRequired = false}) {
  bool isInputStringValid = false;

  if (!isRequired && (inputString == null ? true : inputString.isEmpty)) {
    isInputStringValid = true;
  }

  if (inputString != null && inputString.isNotEmpty) {
    const pattern = r'^[a-zA-Z]+$';

    final regExp = RegExp(pattern);

    isInputStringValid = regExp.hasMatch(inputString);
  }

  return isInputStringValid;
}

extension ResponsiveExtension on num {
  double get _width => SizeUtils.width;

  double get h => ((this * _width) / FIGMA_DESIGN_WIDTH);

  double get fSize => ((this * _width) / FIGMA_DESIGN_WIDTH);
}

extension FormatExtension on double {
  double toDoubleValue({int fractionDigits = 2}) {
    return double.parse(toStringAsFixed(fractionDigits));
  }

  double isNonZero({num defaultValue = 0.0}) {
    return this > 0 ? this : defaultValue.toDouble();
  }
}

extension DateTimeExtension on DateTime {
  String format({
    String pattern = dateTimeFormatPattern,
    String? locale,
  }) {
    if (locale != null && locale.isNotEmpty) {
      initializeDateFormatting(locale);
    }

    return DateFormat(pattern, locale).format(this);
  }
}

enum DeviceType { mobile, tablet, desktop }

typedef ResponsiveBuild = Widget Function(
    BuildContext context, Orientation orientation, DeviceType deviceType);

// ignore_for_file: must_be_immutable

// class ImageConstant {
// // Image folder path

//   // static String imagePath = 'assets/images';
//     static String imagePath = 'images';

// // Common images

//   static String imgArrowDown = '$imagePath/img_arrow_down.svg';

//   static String imgIconSearch = '$imagePath/img_icon_search.svg';

//   static String imgIconMapPin = '$imagePath/img_icon_map_pin.svg';

//   static String imgArrowdownGray900 = '$imagePath/img_arrowdown_gray_900.svg';

//   static String imgRectangle3 = '$imagePath/img_rectangle_3.png';

//   static String imgIconMapPinGray900 =
//       '$imagePath/img_icon_map_pin_gray_900.svg';

//   static String imgIconHeart = '$imagePath/img_icon_heart.svg';

//   static String imgIconShare2 = '$imagePath/img_icon_share_2.svg';

//   static String imgRectangle4 = '$imagePath/img_rectangle_4.png';

//   static String imgRectangle484x88 = '$imagePath/img_rectangle_4_84x88.png';

//   static String imgRectangle41 = '$imagePath/img_rectangle_4_1.png';

//   static String imgIconHome = '$imagePath/img_icon_home.svg';

//   static String imgIconSearchGray40001 =
//       '$imagePath/img_icon_search_gray_400_01.svg';

//   static String imgIconTicket = '$imagePath/img_icon_ticket.svg';

//   static String imgIconHeartGray40001 =
//       '$imagePath/img_icon_heart_gray_400_01.svg';

//   static String imgIconUser = '$imagePath/img_icon_user.svg';

//   static String imgRectangle5 = '$imagePath/img_rectangle_5.png';

//   static String imgArrowDownWhiteA700 =
//       '$imagePath/img_arrow_down_white_a700.svg';

//   static String imgIconHeartwhiteA700 =
//       '$imagePath/img_icon_heart_white_a700.svg';

//   static String imgIconShare2WhiteA700 =
//       '$imagePath/img_icon_share_2_white_a700.svg';

//   static String imgIconCalendar = '$imagePath/img_icon_calendar.svg';

//   static String imgIconMapPinBlack900 =
//       '$imagePath/img_icon_map_pin_black_900.svg';

//   static String imgIconDollarSign = '$imagePath/img_icon_dollar_sign.svg';

//   static String imgIconX = '$imagePath/img_icon_x.svg';

//   static String imgArrowdownBlack9001 =
//       '$imagePath/img_arrowdown_black_900_1.svg';

//   static String imgIconShoppingBag = '$imagePath/img_icon_shopping_bag.svg';

//   static String imgArrowDownBlack900 =
//       '$imagePath/img_arrow_down_black_900.svg';

//   static String imgContrast = '$imagePath/img_contrast.svg';

//   static String imgApplePayLogo2014 = '$imagePath/img_apple_pay_logo_2014.svg';

//   static String imgBase = '$imagePath/img_base.svg';

//   static String imgVisa11 = '$imagePath/img_visa_1_1.svg';

//   static String imgUser = '$imagePath/img_user.svg';

//   static String imgSettings = '$imagePath/img_settings.svg';

//   static String imgApplepaylogo20141 = '$imagePath/img_applepaylogo2014_1.svg';

//   static String imgIconChevrondown = '$imagePath/img_icon_chevrondown.svg';

//   static String imgArrowDownBlueGray900 =
//       '$imagePath/img_arrow_down_blue_gray_900.svg';

//   static String imgRectangle42 = '$imagePath/img_rectangle_4_2.png';

//   static String imgIconHeartDeepOrangeA700 =
//       '$imagePath/img_icon_heart_deep_orange_a700.svg';

//   static String imgRectangle43 = '$imagePath/img_rectangle_4_3.png';

//   static String imgRectangle44 = '$imagePath/img_rectangle_4_4.png';

//   static String imgRectangle45 = '$imagePath/img_rectangle_4_5.png';

//   static String imgRectangle46 = '$imagePath/img_rectangle_4_6.png';

//   static String imgCheckmark = '$imagePath/img_checkmark.svg';

//   static String imgIconHomeGray40001 =
//       '$imagePath/img_icon_home_gray_400_01.svg';

//   static String imgIconSearchBlack900 =
//       '$imagePath/img_icon_search_black_900.svg';

//   static String imgVector = '$imagePath/img_vector.svg';

//   static String imgSettingsGray100 = '$imagePath/img_settings_gray_100.svg';

//   static String imgIconTicketBlack900 =
//       '$imagePath/img_icon_ticket_black_900.svg';

//   static String imgTicket1 = '$imagePath/img_ticket_1.svg';

//   static String imgRectangle9 = '$imagePath/img_rectangle_9.png';

//   static String imgRectangle996x140 = '$imagePath/img_rectangle_9_96x140.png';

//   static String imgRectangle91 = '$imagePath/img_rectangle_9_1.png';

//   static String imgRectangle996x134 = '$imagePath/img_rectangle_9_96x134.png';

//   static String imgRectangle92 = '$imagePath/img_rectangle_9_2.png';

//   static String imgRectangle93 = '$imagePath/img_rectangle_9_3.png';

//   static String imgRectangle94 = '$imagePath/img_rectangle_9_4.png';

//   static String imgFavorite = '$imagePath/img_favorite.svg';

//   static String imgIconHeartBlack900 =
//       '$imagePath/img_icon_heart_black_900.svg';

//   static String imgIconHeartDeepOrangeA70018x18 =
//       '$imagePath/img_icon_heart_deep_orange_a700_18x18.svg';

//   static String imgFavoriteDeepOrangeA700 =
//       '$imagePath/img_favorite_deep_orange_a700.svg';

//   static String imgEllipse2 = '$imagePath/img_ellipse_2.png';

//   static String imgIconEdit3 = '$imagePath/img_icon_edit_3.svg';

//   static String imgIconEdit3BlueGray900 =
//       '$imagePath/img_icon_edit_3_blue_gray_900.svg';

//   static String imgArrowRight = '$imagePath/img_arrow_right.svg';

//   static String imgTopRightShadow = '$imagePath/img_top_right_shadow.png';

//   static String imgIphone13ProMax = '$imagePath/img_iphone_13_pro_max.png';

//   static String imgScreenShine = '$imagePath/img_screen_shine.png';

//   static String imgHardware = '$imagePath/img_hardware.png';

//   static String ingIphone13ProMax196x100 =
//       '$imagePath/img_iphone_13_pro_max_196x100.png';

//   static String ingScreenShine196x100 =
//       '$imagePath/img_screen_shine_196x100.png';

//   static String imgIphone13ProMax1 = '$imagePath/img_iphone_13_pro_max_1.png';

//   static String ingScreenShine1 = '$imagePath/img_screen_shine_1.png';

//   static String imageNotFound = 'assets/images/image_not_found.png';
// }

class Sizer extends StatelessWidget {
  const Sizer({super.key, required this.builder});

  /// Builds the widget whenever the orientation changes.

  final ResponsiveBuild builder;

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(builder: (context, constraints) {
      return OrientationBuilder(builder: (context, orientation) {
        SizeUtils.setScreenSize(constraints, orientation);
        return builder(context, orientation, SizeUtils.deviceType);
      });
    });
  }
}

class SizeUtils {
  static late BoxConstraints boxConstraints;

  /// Device's Orientation

  static late Orientation orientation;

  /// This can either be mobile or tablet
  static late DeviceType deviceType;

  /// Device's Height

  static late double height;

  /// Device's Width

  static late double width;

  static void setScreenSize(
    BoxConstraints constraints,
    Orientation currentOrientation,
  ) {
    boxConstraints = constraints;

    orientation = currentOrientation;

    if (orientation == Orientation.portrait) {
      width =
          boxConstraints.maxWidth.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);

      height = boxConstraints.maxHeight.isNonZero();
    } else {
      width =
          boxConstraints.maxHeight.isNonZero(defaultValue: FIGMA_DESIGN_WIDTH);

      height = boxConstraints.maxWidth.isNonZero();
    }
    deviceType = DeviceType.mobile;
  }
}

class AppUtils {
  /// Hiển thị hộp thoại xác nhận.
  static void showConfirmDialog(
    BuildContext context,
    String message, {
    required VoidCallback onConfirm,
  }) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text('Confirm'),
          content: Text(message),
          actions: [
            TextButton(
              onPressed: () => Navigator.of(dialogContext).pop(),
              child: const Text('Cancel'),
            ),
            TextButton(
              onPressed: () {
                Navigator.of(dialogContext).pop();
                onConfirm();
              },
              child: const Text('OK'),
            ),
          ],
        );
      },
    );
  }

  static Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('access_token');
    // Giả sử bạn đã đăng ký route '/login' cho màn hình đăng nhập
    Navigator.pushAndRemoveUntil(context, 
      MaterialPageRoute(builder: (context) => const LoginScreen()),
      (route) => false,
    );
  }

  static Future<String> pickImageFromGallery(BuildContext context) async {
    final ImagePicker picker = ImagePicker();
    try {
      final XFile? image = await picker.pickImage(source: ImageSource.gallery);
      if (image != null) {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Image selected: ${image.path}')),
          );
          
        }
        return image.path;
      } else {
        if (context.mounted) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('No image selected')),
          );
        }
      }
      return '';
    } catch (e) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(content: Text('Error picking image: $e')),
        );
        print('Error picking image: $e');
      }
      return '';
    }
  }
}

/// Formats a double amount into Vietnamese Dong (vnđ) currency format.
///
/// Example: formatCurrencyVND(1234567.89) -> "1.234.568 vnđ"
String formatCurrencyVND(int? amount) {
  if (amount == null) {
    return '0 vnđ'; // Hoặc giá trị mặc định khác tùy bạn chọn
  }
  final format = NumberFormat.currency(locale: 'vi_VN', symbol: 'vnđ');
  // Làm tròn đến số nguyên gần nhất trước khi định dạng
  return format.format(amount.round()); 
}
