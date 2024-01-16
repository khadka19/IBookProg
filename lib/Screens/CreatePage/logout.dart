import 'package:flutter/material.dart';
import 'package:petrolpump/CommonWidgets/constants_text.dart';
import 'package:petrolpump/CommonWidgets/route.dart';
import 'package:petrolpump/Preference/preference.dart';

class LogOut{
  static Future<void> logOut(BuildContext context) async {
  try {
    await UserPreference.removeUserPreference(ContstantsText.encryptedCompanyCode);
    await UserPreference.removeUserPreference(ContstantsText.encryptedCompanyCode);
    await UserPreference.removeUserPreference(ContstantsText.encryptedCompanyName);
    await UserPreference.removeUserPreference(ContstantsText.unEncryptedCompanyName);
    await UserPreference.removeUserPreference(ContstantsText.encryptedFYStartMiti);

    // ignore: use_build_context_synchronously
    Navigator.pushNamed(context, AppRoutes.login);
  } catch (e) {
    print('Error during logout: $e');
  }
}
  }
class MyWidget extends StatefulWidget {
  const MyWidget({super.key});

  @override
  State<MyWidget> createState() => _MyWidgetState();
}

class _MyWidgetState extends State<MyWidget> {
  @override
  Widget build(BuildContext context) {
    return const Placeholder();
  }
}