import 'package:events_app/presentation/buy_ticket_screen.dart';
import 'package:flutter/material.dart';

import 'app_utils.dart';
import 'presentation/loginScreen.dart';
import 'presentation/signUpScreen.dart';

// void main() {
//   runApp(const MyApp());
// }

// void main() {
//   runApp(
//     ScreenUtilInit(
//       designSize: Size(375, 812), // Set the base design size
//       builder: (context, child) => MyApp(),
//     ),
//   );
// }
void main() {
  runApp(
    Sizer(
      builder: (context, orientation, deviceType) {
        return const MaterialApp(
          debugShowCheckedModeBanner: false,
          home: MyApp(),  
        );
      },
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      // home: const StartScreen(),
            home: const BuyTicketScreen(eventName: 'La Rosalia', eventDate: 'Mon, Apr 18 · 21:00 PM', eventLocation: 'Palau Sant Jordi, Barcelona',),

    );
  }
}

class StartScreen extends StatelessWidget {
  const StartScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: Column(
            children: [
              // Welcome Text Section
              const Padding(
                padding: EdgeInsets.only(top: 57),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  children: [
                    Text(
                      'Welcome!',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 32,
                        fontWeight: FontWeight.w700,
                        height: 1.2,
                      ),
                      textAlign: TextAlign.center,
                    ),
                    SizedBox(height: 10),
                    Text(
                      'Sing in or creat a new account',
                      style: TextStyle(
                        fontFamily: 'Inter',
                        fontSize: 16,
                        fontWeight: FontWeight.w400,
                        height: 1.5,
                        color: Color(0xFF7C7C7C),
                      ),
                      textAlign: TextAlign.center,
                    ),
                  ],
                ),
              ),
          
              // Image
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 34.68),
                // child: Image.asset('images/Frame.png'),
                                child: Image.asset('assets/images/Frame.png'),

              ),
          
              const Spacer(),
          
              // Buttons Section
              Padding(
                padding: const EdgeInsets.all(36.5),
                child: Column(
                  children: [
                    ElevatedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const LoginScreen()),
                        );
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: const Color(0xFF0DCDAA),
                        minimumSize: const Size(317, 60),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'Sign in',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Colors.white,
                        ),
                      ),
                    ),
                    const SizedBox(height: 11),
                    OutlinedButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => const SignUpScreen()),
                        );
                      },
                      style: OutlinedButton.styleFrom(
                        minimumSize: const Size(317, 60),
                        side: const BorderSide(color: Color(0xFF7C7C7C)),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      child: const Text(
                        'No account yet? Sing up',
                        style: TextStyle(
                          fontFamily: 'Inter',
                          fontSize: 16,
                          fontWeight: FontWeight.w500,
                          color: Color(0xFF7C7C7C),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
