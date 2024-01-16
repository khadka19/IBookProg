import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_custom_clippers/flutter_custom_clippers.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petrolpump/API_Services/attendence_services.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/CommonWidgets/constants_text.dart';
import 'package:petrolpump/CommonWidgets/cryptography.dart';
import 'package:petrolpump/CommonWidgets/custom_app_bar.dart';
import 'package:petrolpump/CommonWidgets/search_bar.dart';
import 'package:petrolpump/Preference/preference.dart';
import 'package:petrolpump/Provider/all_provider.dart';
import 'package:petrolpump/Screens/CreatePage/Sales/custom_productList_class.dart';
import 'package:petrolpump/Screens/CreatePage/main_page.dart';
import 'package:petrolpump/Screens/welcome_page.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/auth_model.dart';
import 'package:petrolpump/models/companyName_model.dart';
import 'package:petrolpump/API_Services/auth_services.dart';
import 'package:provider/provider.dart';
// ignore: depend_on_referenced_packages
import 'package:intl/intl.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key});
  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  String formatDate(DateTime dateTime) {
    // Use the DateFormat class to format the date
    final formatter = DateFormat('yyyy-MM-dd');
    return formatter.format(dateTime);
  }

  FocusNode emailFocusNode = FocusNode();
  FocusNode passwordFocusNode = FocusNode();

  TextEditingController companyCtrl = TextEditingController();
  TextEditingController emailCtrl = TextEditingController();
  TextEditingController PasswordCtrl = TextEditingController();
  var loginUserName = "";
  bool passwordVisible = false;
  SelectedContentProductList selectedContentProductList =
      const SelectedContentProductList();
  MyServiceAttendence myServiceAttendence = MyServiceAttendence();
  AuthService myService = AuthService();
  List<CompanyModel> _companyList = []; // Store fetched customer data
  bool isLoadingFlagT = ContstantsText.isLoadingTrue;
  bool isLoadingReplaceBtn = ContstantsText.isLoadingFalse;
  @override
  void initState() {
    super.initState();
    passwordVisible = true;
    
    Future.delayed(const Duration(seconds: 2), () {
      setState(() {
        isLoadingFlagT = false; // Set isLoading to false after 3 seconds
      });
    });
  }

  List<CompanyModel> filterCompany(String searchCompText) {
    return _companyList.where((company) {
      return company.companyName.toLowerCase().contains(searchCompText);
    }).toList();
  }

  String searchComp = "";
  final TextEditingController _searchController = TextEditingController();
  ValueNotifier<String> searchCompanyListner = ValueNotifier<String>('');

  String _selectedItem = "Select a Company";
  String _selectedComanyName = "";
  String _selectedItemCode = "";
  String _selectedFYStartMiti = '';
  String _selectedFYEndMiti = '';

  final _formKey = GlobalKey<FormState>();

  String baseURL = "BaseURL";

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        exit(0); // Exit the app
      },
      child: Scaffold(
        body: SingleChildScrollView(
          scrollDirection: Axis.vertical,
          child: SizedBox(
            height: MediaQuery.of(context).size.height * 1,
            child: Column(
              children: [
                colorStack(),
                const SizedBox(
                  height: 30,
                ),
                Expanded(
                  child: Column(
                    children: [
                      isLoadingFlagT
                          ? const Center(
                              child: Text(
                              "L o a d i n g . . .",
                              style: TextStyle(fontSize: 16),
                            ))
                          : form(),
                      const SizedBox(
                        height: 30,
                      ),
                      Visibility(visible: !isLoadingFlagT, child: text()),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }

  colorStack() {
    return ClipPath(
      clipper: WaveClipperTwo(),
      child: Container(
          color: AppColors.kPrimaryColor,
          width: double.maxFinite,
          height: MediaQuery.of(context).size.height * 0.4,
          child: Padding(
            padding: const EdgeInsets.fromLTRB(10, 40, 10, 10),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(""),
                    InkWell(
                      onTap: () {
                        UserPreference.removeUserPreference(
                            ContstantsText.encrypedtUsername);
                        Navigator.pushReplacement(
                          context,
                          MaterialPageRoute(
                            builder: (context) => const WelcomePage(),
                          ),
                        );
                      },
                      child: Row(
                        children: [
                          Text("Change URL ?",
                              style: GoogleFonts.archivoBlack(
                                  color: Colors.white54)),
                          const SizedBox(
                            width: 7,
                          ),
                          const Icon(Entypo.log_out)
                        ],
                      ),
                    ),
                  ],
                ),
                const Center(
                  child: Padding(
                    padding: EdgeInsets.only(top: 50),
                    child: Text(
                      "Login",
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
    final itemProviderCustomer = context.watch<CustomerProvider>();
    final itemProviderDataRow = context.watch<DataRowProvider>();

    return Form(
      key: _formKey,
      child: Padding(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 20),
        child: Column(
          children: [
            TextFormField(
              focusNode: emailFocusNode,
              onEditingComplete: () {
                FocusScope.of(context).requestFocus(passwordFocusNode);
              },
              keyboardType: TextInputType.emailAddress,
              style: const TextStyle(
                fontSize: 17,
              ),
              controller: emailCtrl,
              decoration: InputDecoration(
                hintText: 'Email',
                hintStyle: GoogleFonts.adamina(),
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.all(10.0),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            TextFormField(
              focusNode: passwordFocusNode,
              obscureText: passwordVisible,
              style: const TextStyle(
                fontSize: 17,
              ),
              controller: PasswordCtrl,
              decoration: InputDecoration(
                hintText: 'Password', hintStyle: GoogleFonts.adamina(),
                //  helperText:"Password must contain special character",
                helperStyle: const TextStyle(color: Colors.green),
                suffixIcon: IconButton(
                  icon: Icon(passwordVisible
                      ? Icons.visibility
                      : Icons.visibility_off),
                  onPressed: () {
                    setState(
                      () {
                        passwordVisible = !passwordVisible;
                      },
                    );
                  },
                ),
                alignLabelWithHint: false,
                border: InputBorder.none,
                filled: true,
                fillColor: Colors.grey[200],
                contentPadding: const EdgeInsets.all(10.0),
              ),
              keyboardType: TextInputType.visiblePassword,
              textInputAction: TextInputAction.done,
            ),
            const SizedBox(
              height: 20,
            ),
            Container(
              width: double.maxFinite,
              decoration: BoxDecoration(
                color: Colors.grey[200],
              ),
              child: InkWell(
                onTap: () async {
                  if (emailCtrl.text.isEmpty || PasswordCtrl.text.isEmpty) {
                    Utilities.showSnackBar(
                        context, "Enter Username/Password", false);
                  } else {
                    showDialog(
                        context: context,
                        builder: (BuildContext context) {
                          return const Center(
                            child: CircularProgressIndicator(),
                          );
                        });
                  }
                  await myService
                      .getCompanyName(emailCtrl.text, PasswordCtrl.text)
                      .then((data) {
                    setState(() {
                      _companyList =
                          data; // Store the fetched data in the customerList
                      // _companyList.sort((a, b) => a.companyName.compareTo(b.companyName));
                    });
                  });
                  // ignore: use_build_context_synchronously
                  Navigator.pop(context);
                  // ignore: use_build_context_synchronously
                  showModalBottomSheet(
                      isScrollControlled: true,
                      shape: const RoundedRectangleBorder(
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(20),
                              topRight: Radius.circular(20))),
                      context: context,
                      builder: (BuildContext context) {
                        return SizedBox(
                          height: MediaQuery.of(context).size.height * 0.6,
                          child: SingleChildScrollView(
                            scrollDirection: Axis.vertical,
                            child: Padding(
                              padding: const EdgeInsets.fromLTRB(10, 10, 10, 0),
                              child: Column(
                                children: [
                                  CustomSearchBar(
                                    hintText: "Select a Company",
                                    controller: _searchController,
                                    onChanged: (String? value) {
                                      searchCompanyListner.value = value ?? "";
                                    },
                                  ),
                                  SizedBox(
                                      height:
                                          MediaQuery.of(context).size.height *
                                              0.5,
                                      child: _companyList.isEmpty
                                          ? const Center(
                                              child: Text("Company Not Found"))
                                          : ValueListenableBuilder(
                                              valueListenable:
                                                  searchCompanyListner,
                                              builder: (context, value, child) {
                                                return ListView.builder(
                                                    itemCount:
                                                        filterCompany(value)
                                                            .length,
                                                    itemBuilder:
                                                        (BuildContext context,
                                                            int index) {
                                                      CompanyModel company =
                                                          filterCompany(
                                                              value)[index];

                                                      return Padding(
                                                        padding:
                                                            const EdgeInsets
                                                                    .fromLTRB(
                                                                10, 7, 10, 7),
                                                        child: InkWell(
                                                          onTap: () {
                                                            setState(() {
                                                              _selectedItem =
                                                                  "${company.companyName} (${formatDate(company.fyStartMiti)} || ${formatDate(company.fyEndMiti)})";
                                                              _selectedComanyName =
                                                                  company
                                                                      .companyName;
                                                              _selectedItemCode =
                                                                  company
                                                                      .companyCode;
                                                              _selectedFYStartMiti =
                                                                  formatDate(company
                                                                      .fyStartMiti);
                                                              _selectedFYEndMiti =
                                                                  formatDate(company
                                                                      .fyEndMiti);
                                                            });
                                                            Navigator.pop(
                                                                context);
                                                          },
                                                          child: Column(
                                                            crossAxisAlignment:
                                                                CrossAxisAlignment
                                                                    .start,
                                                            children: [
                                                              Text(
                                                                "${company.companyName} (${formatDate(company.fyStartMiti)} || ${formatDate(company.fyEndMiti)})",
                                                                style: GoogleFonts
                                                                    .adamina(
                                                                        fontSize:
                                                                            17),
                                                              ),
                                                              const Divider(
                                                                thickness: 1,
                                                              )
                                                            ],
                                                          ),
                                                        ),
                                                      );
                                                    });
                                              },
                                            ))
                                ],
                              ),
                            ),
                          ),
                        );
                      });
                },
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Padding(
                      padding: const EdgeInsets.fromLTRB(10, 13, 10, 13),
                      child: SizedBox(
                        width: MediaQuery.of(context).size.height * 0.3,
                        child: Text(
                          _selectedItem,
                          style: GoogleFonts.adamina(fontSize: 17),
                          overflow: TextOverflow.clip,
                        ),
                      ),
                    ),
                    const Icon(
                      Icons.arrow_drop_down,
                      color: Colors.black,
                    )
                  ],
                ),
              ),
            ),
            const SizedBox(
              height: 20,
            ),
            CustomAppBarWidget(
              onPressed: () async {
                if (_selectedItem == 'Select a Company') {
                  showDialog(
                    context: context,
                    builder: (BuildContext context) {
                      return AlertDialog(
                        title: Text(
                          "Alert !!!",
                          style: GoogleFonts.adamina(
                            color: Colors.red,
                          ),
                        ),
                        content: const Text(
                            "Please select a company before proceeding."),
                        actions: [
                          ElevatedButton(
                            onPressed: () async {
                              Navigator.pop(context);
                            },
                            child: const Text("OK"),
                          ),
                        ],
                      );
                    },
                  );
                } else {
                  setState(() {
                    isLoadingReplaceBtn = true;
                  });
                  try {
                    AuthRequest auth = AuthRequest(
                        username: emailCtrl.text.trim(),
                        password: PasswordCtrl.text.trim(),
                        company: _selectedItemCode);

                    AuthResponse response = await AuthService().login(auth);

                    if (response.success) {
                      String encryptedUserName =
                          Cryptography.encryptData(userNameCtrl.toString());
                      UserPreference.setUserPreference(
                          ContstantsText.encrypedtUsername, encryptedUserName);

                      String companyCode = _selectedItemCode.toString();
                      String encryptedCompanyCode =
                          Cryptography.encryptData(companyCode);
                      UserPreference.setUserPreference(
                          ContstantsText.encryptedCompanyCode,
                          encryptedCompanyCode);

                      String companyName = _selectedComanyName;
                      UserPreference.setUserPreference(
                          ContstantsText.unEncryptedCompanyName, companyName);

                      String fyStartMiti = _selectedFYStartMiti.toString();
                      String encryptedFYStartMiti =
                          Cryptography.encryptData(fyStartMiti);
                      UserPreference.setUserPreference(
                          ContstantsText.encryptedFYStartMiti,
                          encryptedFYStartMiti);

                      String fyEndMiti = _selectedFYEndMiti.toString();
                      String encryptedFYEndMiti =
                          Cryptography.encryptData(fyEndMiti);
                      UserPreference.setUserPreference(
                          ContstantsText.encryptedFYEndMiti,
                          encryptedFYEndMiti);

                      emailCtrl.clear();
                      PasswordCtrl.clear();
                      itemProviderCustomer.clearSelection();
                      itemProviderDataRow.clearDataRowSelection();

                      // ignore: use_build_context_synchronously
                      Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(
                          builder: (context) => MainPage(
                            initialIndex: 0,
                          ),
                        ),
                      );
                    }
                  } catch (e) {
                    setState(() {
                      isLoadingReplaceBtn = false;
                    });
                    String errorMessage = _extractErrorMessage(e);
                    if (!errorMessage.contains("Error:")) {
                      Utilities.showSnackBar(context, errorMessage, false);
                    }
                  }
                }
              },
              buttonColor: AppColors.kPrimaryColor,
              buttonText: "Submit",
              context: context,
              isLoadingReplaceBtn: isLoadingReplaceBtn,
            ),
          ],
        ),
      ),
    );
  }

  Widget text() {
    return const Expanded(
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("By signing up , you agree with the"),
              Text(
                "Terms of Service",
                style: TextStyle(color: Colors.blue),
              )
            ],
          ),
          SizedBox(
            height: 5,
          ),
          Row(mainAxisAlignment: MainAxisAlignment.center, children: [
            Text(
              "&",
              style: TextStyle(fontSize: 15),
            ),
            SizedBox(
              width: 5,
            ),
            Text(
              " Privacy Policy",
              style: TextStyle(color: Colors.blue, fontSize: 15),
            )
          ]),
        ],
      ),
    );
  }

  Widget dialog() {
    return AlertDialog(
      title: const Text("Error"),
      content:
          const Text("Authentication failed. Please check your credentials."),
      actions: [
        ElevatedButton(
          onPressed: () {
            Navigator.pop(context); // Close the dialog
          },
          child: const Text("OK"),
        ),
      ],
    );
  }
}

String _extractErrorMessage(dynamic exception) {
  String originalMessage = exception.toString();
  if (originalMessage.contains("Error:")) {
    int errorStartIndex = originalMessage.indexOf("Error:");
    String errorMessage = originalMessage.substring(errorStartIndex + 6).trim();
    return errorMessage;
  } else {
    return originalMessage;
  }
}
