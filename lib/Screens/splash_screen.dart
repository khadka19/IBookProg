import 'dart:async';
import 'package:flutter/material.dart';
import 'package:petrolpump/CommonWidgets/constants_text.dart';
import 'package:petrolpump/CommonWidgets/route.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Screens/CreatePage/main_page.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _SplashScreenState createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> with SingleTickerProviderStateMixin {
  
 String baseURL = "BaseURL";
 String loggedIn="encryptedCompanyName";

  
  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _scaleAnimation;
  @override
  void initState() {
    super.initState();
     _initialize();

    
  }


  Future<void> _initialize()  async {
    _animationController = AnimationController(
      vsync: this,
      duration: const Duration(seconds: 2),
    );

    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(_animationController);
    _scaleAnimation = Tween<double>(begin: 0.5, end: 1.0).animate(_animationController);

    _animationController.forward();
Timer(Duration(seconds: 2), () async{ 
  try {
    bool hasUserName = await UserPreference.getUserPreference(ContstantsText.encrypedtUsername) != null;
    bool hasCompanyName = await UserPreference.getUserPreference(ContstantsText.encryptedCompanyCode) != null;
     
      if (hasUserName) {
        if(hasCompanyName){
          Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>MainPage(initialIndex: 0)));
        }else
        Navigator.pushReplacementNamed(context, AppRoutes.login);
      } else {
        Navigator.pushReplacementNamed(context, AppRoutes.welcome);
      }
    } catch (e) {
      // Handle any potential errors during the login status check
      print("Error during login status check: $e");
      Navigator.pushReplacementNamed(context, AppRoutes.welcome);
    }
});
    
  }


  @override
  Widget build(BuildContext context) {
    
    var screenHeight=MediaQuery.of(context).size.height;
    return Scaffold(
      backgroundColor: Colors.white,
      body: Column(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text(""),

          ScaleTransition(
            scale: _scaleAnimation,
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: SizedBox(
                height: screenHeight*0.2,
                width: double.maxFinite,
                child: 
                Padding(
                  padding: const EdgeInsets.fromLTRB(10, 0, 10, 0),
                  child: Image.asset(
                    "assets/images/logo.png",
                    fit: BoxFit.contain,
                  ),
                ),
              ),
            ),
          ),

          Padding(
            padding: const EdgeInsets.only(bottom: 50),
            child: FadeTransition(
              opacity: _fadeAnimation,
              child: const Text(
                "Powered By : Progressive Technology",
                style: TextStyle(fontSize: 14, color: Color.fromARGB(255, 197, 119, 3)),
              ),
            ),
          ),
        ],
      ),
    );
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }
}