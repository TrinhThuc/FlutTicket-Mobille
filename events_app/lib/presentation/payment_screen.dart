import 'package:events_app/app_theme.dart';
import 'package:events_app/app_utils.dart';
import 'package:events_app/widgets.dart';
import 'package:flutter/material.dart';

class PaymentScreen extends StatefulWidget {
  PaymentScreen({super.key});

  @override
  State<PaymentScreen> createState() => _PaymentScreenState();
}

class _PaymentScreenState extends State<PaymentScreen> {
  final TextEditingController nameController = TextEditingController();
  final TextEditingController surnameController = TextEditingController();
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  int selectedMethod = 0; // Track selected payment method globally

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: appTheme.whiteA700,
      resizeToAvoidBottomInset: true,
      appBar: CustomAppBar(
        leadingWidth: 33.h,
        leading: IconButton(
          icon: const Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.close, color: Colors.black),
            onPressed: () {},
          ),
        ],
      ),
      body: Padding(
        padding: EdgeInsets.all(16.h),
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              Expanded(
                child: ListView(
                  children: [
                    _buildEventDetails(),
                    SizedBox(height: 32.h),
                    _buildContactInfo(),
                    SizedBox(height: 32.h),
                    _buildPaymentMethods(),
                    SizedBox(height: 24.h),
                    _buildTermsAndConditions(),
                  ],
                ),
              ),
              _buildBottomPaymentBar(),
            ],
          ),
        ),
      ),
    );
  }

  /// **Event Details**
  Widget _buildEventDetails() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Text('La Rosalia', style: theme.textTheme.titleLarge),
        SizedBox(height: 12.h),
        Text('Remaining time 20.32', style: CustomTextStyles.bodySmallRed400),
      ],
    );
  }

  /// **Contact Information Form**
  Widget _buildContactInfo() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Contact Info', style: theme.textTheme.titleMedium),
        SizedBox(height: 16.h),
        Row(
          children: [
            Expanded(
              child: CustomTextFormField(
                controller: nameController,
                hintText: 'Your Name',
                contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.h),
                validator: (value) => value!.isEmpty ? 'Enter name' : null,
              ),
            ),
            SizedBox(width: 12.h),
            Expanded(
              child: CustomTextFormField(
                controller: surnameController,
                hintText: 'Your Surname',
                contentPadding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.h),
                validator: (value) => value!.isEmpty ? 'Enter surname' : null,
              ),
            ),
          ],
        ),
      ],
    );
  }

  /// **Payment Methods**
  Widget _buildPaymentMethods() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text('Payment Methods', style: theme.textTheme.titleMedium),
        SizedBox(height: 12.h),
        ListView.separated(
          shrinkWrap: true,
          physics: NeverScrollableScrollPhysics(),
          itemCount: 3,
          separatorBuilder: (_, __) => SizedBox(height: 6.h),
          itemBuilder: (_, index) => PaymentMethodTile(
            index: index,
            selectedMethod: selectedMethod,
            onSelected: (value) {
              setState(() {
                selectedMethod = value;
              });
            },
          ),
        ),
      ],
    );
  }

  /// **Terms & Conditions**
  Widget _buildTermsAndConditions() {
    return Text(
      'By proceeding, you agree to the Terms & Conditions and Refund Policy.',
      style: theme.textTheme.bodySmall!.copyWith(color: Colors.grey),
      textAlign: TextAlign.center,
    );
  }

  /// **Bottom Payment Bar**
  Widget _buildBottomPaymentBar() {
    return Column(
      children: [
        const Divider(),
        Padding(
          padding: EdgeInsets.symmetric(vertical: 16.h, horizontal: 16.h),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.shopping_bag),
                  SizedBox(width: 8.h),
                  Text('€67.00', style: theme.textTheme.titleLarge),
                ],
              ),
              ElevatedButton.icon(
                onPressed: () {},
                icon: const Icon(Icons.apple),
                label: const Text('Pay with Apple Pay'),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24.h),
                  ),
                  padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 20.h),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

/// **Payment Method Tile Widget**
class PaymentMethodTile extends StatelessWidget {
  final int index;
  final int selectedMethod;
  final Function(int) onSelected;

  const PaymentMethodTile({
    super.key,
    required this.index,
    required this.selectedMethod,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    List<String> paymentMethods = ['Apple Pay', 'Credit Card', 'Bitcoin'];
    List<String> paymentIcons = [
      'https://storage.googleapis.com/a1aa/image/MpBTZLZxSddab58HkoghtOEHdn0ZARD9InP8C9SPbzg.jpg',
      'https://storage.googleapis.com/a1aa/image/1LeWRVa1LqMm-0it_MPzykBC4hkK7PBk6qxxpCewnKA.jpg',
      'https://storage.googleapis.com/a1aa/image/4SXP89Ss-EvrKxx9VbpDN0L551f0KlE0bdGr413UdKM.jpg'
    ];

    return GestureDetector(
      onTap: () => onSelected(index),
      child: Container(
        padding: EdgeInsets.symmetric(vertical: 12.h, horizontal: 14.h),
        decoration: BoxDecoration(
          border: Border.all(
            color: selectedMethod == index ? Colors.blue : Colors.grey.shade300,
            width: selectedMethod == index ? 2 : 1,
          ),
          borderRadius: BorderRadius.circular(8.h),
          color: Colors.white,
        ),
        child: Row(
          children: [
            Radio<int>(
              value: index,
              groupValue: selectedMethod,
              onChanged: (value) => onSelected(value!),
              activeColor: Colors.blue,
            ),
            SizedBox(width: 12.h),
            Text(paymentMethods[index], style: CustomTextStyles.bodySmallBlack900),
            Spacer(),
            Image.network(paymentIcons[index], height: 24.h, width: 40.h),
          ],
        ),
      ),
    );
  }
}
