import 'package:events_app/app_theme.dart';
import 'package:events_app/app_utils.dart';
import 'package:events_app/widgets.dart';
import 'package:flutter/material.dart';

import 'payment_screen.dart';

class BuyTicketScreen extends StatelessWidget {
  final String eventName;
  final String eventDate;
  final String eventLocation;

  const BuyTicketScreen(
      {super.key,
      required this.eventName,
      required this.eventDate,
      required this.eventLocation});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      appBar: CustomAppBar(
        height: 56.h,
        // leading: Icon(Icons.arrow_back, color: Colors.black),
        actions: [
          IconButton(
            onPressed: () {
              Navigator.pop(context);
            },
            icon: const Icon(Icons.close, color: Colors.black),
          )
        ],
      ),
      body: SizedBox(
          width: double.maxFinite,
          child: Column(
            mainAxisSize: MainAxisSize.max,
            children: [
              Expanded(
                  child: Container(
                width: double.maxFinite,
                padding: EdgeInsets.only(left: 6.h, right: 6.h, top: 36.h),
                child: Column(
                  mainAxisSize: MainAxisSize.max,
                  children: [
                    Expanded(
                        child: Container(
                            width: double.maxFinite,
                            margin: EdgeInsets.only(left: 18.h),
                            child: Column(
                              mainAxisSize: MainAxisSize.max,
                              children: [
                                Text(
                                  eventName,
                                  style: theme.textTheme.titleLarge,
                                ),
                                SizedBox(height: 8.h),
                                Text(
                                  eventDate,
                                  style: theme.textTheme.bodySmall,
                                ),
                                Text(
                                  eventLocation,
                                  style: theme.textTheme.bodySmall,
                                ),
                                SizedBox(height: 82.h),
                                _buildTicketPurchaseSelection(context),
                              ],
                            )))
                  ],
                ),
              ))
            ],
          )),
      bottomNavigationBar: Container(
        height: 90.h,
        padding: EdgeInsets.symmetric(horizontal: 14.h, vertical: 22.h),
        decoration: AppDecoration.globalGrey,
        width: double.maxFinite,
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.shopping_bag_outlined,
              size: 24.h,
            ),
            const Spacer(),
            Text('€67.00', style: theme.textTheme.titleMedium),
            CustomElevatedButton(
              text: 'Buy',
              onPressed: () {
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return const PaymentScreen();
                }));
              },
              height: 44.h,
              width: 192.h,
              margin: EdgeInsets.only(left: 22.h),
              buttonStyle: ElevatedButton.styleFrom(
                backgroundColor: appTheme.greenA700, // ✅ Set button color
                shape: RoundedRectangleBorder(
                  // ✅ Apply rounded corners here
                  borderRadius: BorderRadius.circular(10.h),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTicketPurchaseSelection(BuildContext context) {
    final List ticketOptions = [
      {
        'title': 'Early Bird',
        'price': '€45.00',
        'fee': '+ €2.00 Fee',
        'salesEnd': 'Sales end on 18th April 2022',
        'isSoldOut': true,
      },
      {
        'title': 'Second Release',
        'price': '€55.00',
        'fee': '+ €2.00 Fee',
        'salesEnd': 'Sales end on 18th April 2022',
        'isSoldOut': false,
      },
      {
        'title': 'General',
        'price': '€65.00',
        'fee': '+ €2.00 Fee',
        'salesEnd': 'Sales end on 18th April 2022',
        'isSoldOut': false,
      },
    ];

    return Expanded(
        child: ListView.separated(
            padding: EdgeInsets.zero,
            physics: const BouncingScrollPhysics(),
            shrinkWrap: true,
            itemBuilder: (context, index) {
              return TicketpurchasesectionItemWidget(
                  ticketOption: ticketOptions[index]);
            },
            separatorBuilder: (context, index) {
              return Padding(
                  padding: EdgeInsets.symmetric(vertical: 9.0.h),
                  child: Divider(
                    height: 1.h,
                    thickness: 1.h,
                    color: appTheme.gray20001,
                  ));
            },
            itemCount: 3));
  }
}

class TicketpurchasesectionItemWidget extends StatelessWidget {
  const TicketpurchasesectionItemWidget({super.key, this.ticketOption});

  final ticketOption;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Expanded(
            child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(ticketOption['title'], style: theme.textTheme.titleMedium),
            SizedBox(height: 10.h),
            RichText(
              text: TextSpan(
                children: [
                  TextSpan(
                    text: ticketOption['price'],
                    style: CustomTextStyles.bodyLargeBlack900_1,
                  ),
                  TextSpan(
                    text: ticketOption['fee'],
                    style: CustomTextStyles.bodySmallGray600_1,
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsets.only(right: 18.h),
              child: Text(
                ticketOption['salesEnd'],
                style: CustomTextStyles.bodySmallGray600_1,
              ),
            ),
          ],
        )),
        ticketOption['isSoldOut']
            ? const Text('Sold Out!', style: TextStyle(color: Colors.grey))
            : Container(
                decoration: BoxDecoration(
                  border: Border.all(
                      color: Colors.grey, width: 1.5), // ✅ Border color & width
                  borderRadius: BorderRadius.circular(8), // ✅ Rounded corners
                ),
                padding: const EdgeInsets.symmetric(
                    horizontal: 12), // ✅ Padding inside border
                child: DropdownButtonHideUnderline(
                  // ✅ Removes default underline
                  child: DropdownButton<int>(
                    icon: const Icon(Icons.keyboard_arrow_down_rounded),
                    value: 0,
                    items: List.generate(
                      5,
                      (index) => DropdownMenuItem(
                        value: index,
                        child: Text('$index'),
                      ),
                    ),
                    onChanged: (value) {},
                  ),
                ),
              ),
      ],
    );
  }
}
