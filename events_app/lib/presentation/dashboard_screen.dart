import 'package:events_app/presentation/favourites_screen.dart';
import 'package:events_app/presentation/home_screen.dart';
import 'package:events_app/presentation/profile_screen.dart';
import 'package:events_app/presentation/ticket_screen.dart';
import 'package:flutter/material.dart';

import '../app_theme.dart';
import 'search_screen.dart';

class DashboardScreen extends StatefulWidget {
  const DashboardScreen({super.key});
  @override
  State<DashboardScreen> createState() => _DashboardScreenState();
}

class _DashboardScreenState extends State<DashboardScreen> {
  int selectTab = 0;

  final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(selectedLocation: 'Barcelona'),
    SearchScreen(),
    const TicketScreen(),
    FavouritesScreen(),
    const ProfileScreen(),
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.gray900,
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: IndexedStack(
        index: selectTab,
        children: _widgetOptions,
      ),
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
