import 'package:events_app/presentation/home_screen.dart';
import 'package:events_app/presentation/select_location_screen.dart';
import 'package:flutter/widgets.dart';

class AppRoutes {
  static const String selectLocationScreen = '/select_location_screen';

  static const String homeScreen = '/home_screen';

  static const String homeInitialPage = '/home_initial_page';

  static const String singleEventScreen = '/single_event_screen';

  static const String buyTicketScreen = '/buy_ticket_screen';

  static const String checkoutScreen = '/check_out_screen';

  static const String searchPage = '/search_page';

  static const String searchOneScreen = '/search_one_screen';

  static const String ticketEmptyScreen = '/ticket_empty_screen';

  static const String ticketTabPage = '/ticket_tab_page';

  static const String ticketPage = '/ticket_page';

  static const String ticketupcomingiTabPage = '/ticketupcomingi_tab_page';

  static const String ticketOneScreen = '/ticket_one_screen';

  static const String ticketonepastTabPage = '/ticketonepast_tab_page';

  static const String favouritesEmptyScreen = '/favourites_empty_screen';

  static const String favouritesPage = '/favourites_page';

  static const String userPage = '/user_page';

  static const String appNavigationScreen = '/app_navigation_screen';

  static const String initialRoute = '/initialRoute';

  static Map<String, WidgetBuilder> routes = {
    selectLocationScreen: (context) => SelectLocationScreen(),
    homeScreen: (context) => HomeScreen(
          selectedLocation: '',
        ),
    // singleEventScreen: (context) => SingleEventScreen(),
    // buyTicketScreen: (context) => BuyTicketScreen(),
    // checkoutScreen: (context) => CheckoutScreen(),
    // searchOneScreen: (context) => SearchOneScreen(),
    // ticketEmptyScreen: (context) => TicketEmptyScreen(),
    // ticketOneScreen: (context) => TicketOneScreen(),
    // favouritesEmptyScreen: (context) => FavouritesEmptyScreen(),
    // appNavigationScreen: (context) => AppNavigationScreen(),
    initialRoute: (context) => SelectLocationScreen()
  };
}
