import 'package:events_app/presentation/favourites_screen.dart';
import 'package:events_app/presentation/home_screen.dart';
import 'package:events_app/presentation/profile_screen.dart';
import 'package:events_app/presentation/ticket_screen.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';
import '../app_utils.dart';
import 'search_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectTab = 0;
  final List<GlobalKey<State<StatefulWidget>>> _screenKeys = [
    GlobalKey<HomeInitialPageState>(),
    GlobalKey<SearchScreenState>(),
    GlobalKey<TicketEmptyScreenState>(),
    GlobalKey<FavouritesScreenState>(),
    GlobalKey<ProfileScreenState>(),
  ];

  void _refreshCurrentScreen() {
    switch (selectTab) {
      case 0:
        (_screenKeys[0].currentState as HomeInitialPageState?)?.refreshData();
        break;
      case 1:
        (_screenKeys[1].currentState as SearchScreenState?)?.refreshData();
        break;
      case 2:
        (_screenKeys[2].currentState as TicketEmptyScreenState?)?.refreshData();
        break;
      case 3:
        (_screenKeys[3].currentState as FavouritesScreenState?)?.refreshData();
        break;
      case 4:
        (_screenKeys[4].currentState as ProfileScreenState?)?.refreshData();
        break;
    }
  }

  Widget _buildScreen(int index) {
    switch (index) {
      case 0:
        return Sizer(
          builder: (context, orientation, deviceType) {
            return HomeScreen(key: _screenKeys[0], selectedLocation: 'Barcelona');
          },
        );
      case 1:
        return Sizer(
          builder: (context, orientation, deviceType) {
            return SearchScreen(key: _screenKeys[1]);
          },
        );
      case 2:
        return Sizer(
          builder: (context, orientation, deviceType) {
            return TicketScreen(key: _screenKeys[2]);
          },
        );
      case 3:
        return Sizer(
          builder: (context, orientation, deviceType) {
            return FavouritesScreen(key: _screenKeys[3]);
          },
        );
      case 4:
        return Sizer(
          builder: (context, orientation, deviceType) {
            return ProfileScreen(key: _screenKeys[4]);
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray900,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: _buildScreen(selectTab),
      bottomNavigationBar: BottomAppBar(
        color: appTheme.gray900,
        padding: const EdgeInsets.all(0),
        child: Container(
          decoration: BoxDecoration(color: appTheme.gray200, boxShadow: const [
            BoxShadow(
                color: Colors.black12, blurRadius: 2, offset: Offset(0, -2))
          ]),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              TabButton(
                  icon: "assets/icon/home_icon.png",
                  selectIcon: "assets/icon/home_select_icon.png",
                  isActive: selectTab == 0,
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        selectTab = 0;
                        _refreshCurrentScreen();
                      });
                    }
                  }),
              TabButton(
                  icon: "assets/icon/search_icon.png",
                  selectIcon: "assets/icon/search_select_icon.png",
                  isActive: selectTab == 1,
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        selectTab = 1;
                        _refreshCurrentScreen();
                      });
                    }
                  }),
              TabButton(
                  icon: "assets/icon/ticket_icon.png",
                  selectIcon: "assets/icon/ticket_select_icon.png",
                  isActive: selectTab == 2,
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        selectTab = 2;
                        _refreshCurrentScreen();
                      });
                    }
                  }),
              TabButton(
                  icon: "assets/icon/favourite_icon.png",
                  selectIcon: "assets/icon/favourite_select_icon.png",
                  isActive: selectTab == 3,
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        selectTab = 3;
                        _refreshCurrentScreen();
                      });
                    }
                  }),
              TabButton(
                  icon: "assets/icon/user_icon.png",
                  selectIcon: "assets/icon/user_select_icon.png",
                  isActive: selectTab == 4,
                  onTap: () {
                    if (mounted) {
                      setState(() {
                        selectTab = 4;
                        _refreshCurrentScreen();
                      });
                    }
                  }),
            ],
          ),
        ),
      ),
    );
  }
}

class TabButton extends StatelessWidget {
  final String icon;
  final String selectIcon;
  final bool isActive;
  final VoidCallback onTap;

  const TabButton(
      {super.key,
      required this.icon,
      required this.selectIcon,
      required this.isActive,
      required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Image.asset(
            isActive ? selectIcon : icon,
            width: 25,
            height: 25,
            fit: BoxFit.fitWidth,
            errorBuilder: (context, error, stackTrace) {
              return const Icon(Icons.error, size: 25, color: Colors.red);
            },
          ),
          SizedBox(height: isActive ? 22 : 8),
          Visibility(
            visible: isActive,
            child: Container(
              width: 4,
              height: 4,
              decoration: BoxDecoration(
                  color: appTheme.gray200,
                  // gradient: LinearGradient(colors: AppColors.secondary),
                  borderRadius: BorderRadius.circular(2)),
            ),
          )
        ],
      ),
    );
  }
}
