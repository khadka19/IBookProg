import 'dart:io';
import 'package:connectivity/connectivity.dart';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petrolpump/API_Services/auth_services.dart';
import 'package:petrolpump/CommonWidgets/InternetConnectivity/internet_not_connected.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/CommonWidgets/constants_text.dart';
import 'package:petrolpump/CommonWidgets/custom_app_bar.dart';
import 'package:petrolpump/CommonWidgets/route.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Utilities/utilities.dart';

class WelcomePage extends StatefulWidget {
  const WelcomePage({super.key});

  @override
  State<WelcomePage> createState() => _WelcomePageState();
}

TextEditingController userNameCtrl = TextEditingController();
var userNameText = userNameCtrl.text;
Future<String> _GetUerName() async {
  AuthService myService = AuthService();
  String urlName = await myService.getUserName(userNameCtrl.text) ?? "";
  return urlName;
}

class _WelcomePageState extends State<WelcomePage> {
  bool isLoadingFlagF = ContstantsText.isLoadingFalse;
  bool isLoadingReplaceBtn = false; // Initialize isLoadingReplaceBtn to false

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      var encrypedtUsername = await UserPreference.getUserPreference(
          ContstantsText.encrypedtUsername);
      var encrypedtCompanyCode = await UserPreference.getUserPreference(
          ContstantsText.encryptedCompanyCode);
      if (encrypedtUsername != null && encrypedtCompanyCode != null) {
        // ignore: use_build_context_synchronously
        Navigator.pushNamed(context, AppRoutes.mainPage);
      } else {
        setState(() {
          isLoadingFlagF =
              true; // Set isLoading to true only when not logged in
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (isLoadingFlagF) {
      return WillPopScope(
        onWillPop: () async {
          exit(0);
        },
        child: Scaffold(
          resizeToAvoidBottomInset: false,
          body: Column(
            children: [
              colorStack(),
              const SizedBox(
                height: 30,
              ),
              Padding(
                padding: const EdgeInsets.all(10),
                child: form(),
              ),
            ],
          ),
        ),
      );
    } else {
      return Container();
    }
  }

  Widget colorStack() {
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
          color: AppColors.kPrimaryColor,
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.4,
          child: const Padding(
            padding: EdgeInsets.fromLTRB(10, 40, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      "Welcome",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 40,
                          fontWeight: FontWeight.bold),
                    ),
                  ),
                )
              ],
            ),
          )),
    );
  }

  Widget form() {
    return Form(
        child: Column(
      children: [
        TextFormField(
          keyboardType: TextInputType.emailAddress,
          autocorrect: false,
          autofocus: true,
          style: const TextStyle(
            fontSize: 17,
          ),
          controller: userNameCtrl,
          decoration: InputDecoration(
            hintText: 'Username',
            hintStyle: GoogleFonts.adamina(),
            prefix: const Padding(
              padding: EdgeInsets.only(right: 10),
              child: Icon(
                Icons.person,
              ),
            ),
            border: InputBorder.none,
            filled: true,
            fillColor: Colors.grey[200],
            contentPadding: const EdgeInsets.all(10.0),
          ),
          validator: (value) {
            if (value!.isEmpty) {
              return "Email is required";
            }
            bool emailValid = RegExp(
                    r"^[a-zA-Z0-9.a-zA-Z0-9.!#$%&'*+-/=?^_`{|}~]+@[a-zA-Z0-9]+\.[a-zA-Z]+")
                .hasMatch(value);
            if (!emailValid) {
              return "Invalid email address";
            }
            return null;
          },
        ),
        const SizedBox(
          height: 50,
        ),
        CustomAppBarWidget(
          onPressed: () async {
            showDialog(
                context: context,
                builder: (BuildContext context) {
                  return Center(child: CircularProgressIndicator());
                });
            final connectivityResult = await Connectivity().checkConnectivity();

            if (connectivityResult == ConnectivityResult.none) {
              // ignore: use_build_context_synchronously
              showDialog(
                barrierDismissible: false,
                context: context,
                builder: (_) => NetworkErrorDialog(
                  onPressed: () async {
                    Navigator.pop(context);
                    final connectivityResult =
                        await Connectivity().checkConnectivity();
                    if (connectivityResult == ConnectivityResult.none) {
                      // ignore: use_build_context_synchronously
                      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
                          content:
                              Text('Please turn on your wifi or mobile data')));
                              Navigator.pop(context);
                    } else {
                      Navigator.pop(context);
                    }
                  },
                ),
              );
            } else {
              var apiResult = await _GetUerName();
              if (apiResult != "") {
            var   userName= await UserPreference.getUserPreference("BaseURL");
                UserPreference.setUserPreference(ContstantsText.encrypedtUsername, userName);
                // ignore: use_build_context_synchronously
                Utilities.showSnackBar(
                  context,
                  "Valid User . Please do Login",
                );
                // ignore: use_build_context_synchronously
                Navigator.pushNamed(context, AppRoutes.login);
              } else {
                Utilities.showSnackBar(context, "InValid User", false);
                Navigator.pop(context);
              }
            }
          },
          buttonColor: AppColors.kPrimaryColor,
          buttonText: 'Get Access',
          context: context,
          isLoadingReplaceBtn: isLoadingReplaceBtn,
        )
      ],
    ));
  }
}