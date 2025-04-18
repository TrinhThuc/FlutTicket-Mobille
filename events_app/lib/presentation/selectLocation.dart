import 'package:events_app/presentation/select_location_screen.dart';
import 'package:flutter/material.dart';

class SelectLocation extends StatelessWidget {
  const SelectLocation({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                const SizedBox(height: 109),
                Column(
                  children: [
                    Image.asset('assets/images/illustration.png',
                    height: 200,
                    ),
                    const SizedBox(height: 44),
                    const Column(
                      children: [
                        Text(
                          'Select Location',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Color(0xFF181725),
                            fontFamily: 'Inter',
                            height: 19.2 / 20, // lineHeight / fontSize
                          ),
                          textAlign: TextAlign.center,
                        ),
                        SizedBox(height: 18),
                        Text(
                          'Let\'s find your next event. Stay in tune with\nwhat\'s happening in your area!',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w400,
                            color: Color(0xFF7C7C7C),
                            fontFamily: 'Inter',
                            height: 24 / 16, // lineHeight / fontSize
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ],
                    ),
                  ],
                ),
                const SizedBox(height: 109),
                Padding(
                  padding: const EdgeInsets.only(bottom: 109.15),
                  child: ElevatedButton(
                    onPressed: () {
                      Navigator.pushReplacement(context, MaterialPageRoute(builder: (context) => SelectLocationScreen()));
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: const Color(0xFF0DCDAA),
                      minimumSize: const Size(double.infinity, 60),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      padding: const EdgeInsets.symmetric(vertical: 18),
                    ),
                    child: const Text(
                      'Choose city',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w500,
                        color: Colors.white,
                        fontFamily: 'Inter',
                        height: 24 / 16, // lineHeight / fontSize
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

