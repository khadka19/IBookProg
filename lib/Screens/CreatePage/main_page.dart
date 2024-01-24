import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_vector_icons/flutter_vector_icons.dart';
import 'package:flutter_zoom_drawer/flutter_zoom_drawer.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/Screens/CreatePage/CustomerOutstanding/customer_outstanding.dart';
import 'package:petrolpump/Screens/CreatePage/LedgerReport/ledger_report.dart';
import 'package:petrolpump/Screens/CreatePage/Suppliers/supplier_outstanding.dart';
import 'package:petrolpump/Screens/CreatePage/TrialStock/trial_stock.dart';
import 'package:petrolpump/Screens/CreatePage/about.dart';
import 'package:petrolpump/Screens/CreatePage/Order/create_order_screen.dart';
import 'package:petrolpump/Screens/CreatePage/Sales/create_sales_screen.dart';
import 'package:petrolpump/Screens/CreatePage/attendence.dart';
import 'package:petrolpump/Screens/CreatePage/logout.dart';
import 'package:petrolpump/Screens/CreatePage/ViewOrder/viewOrder_mainPage.dart';
import 'package:petrolpump/Screens/welcome_page.dart';

class MainPage extends StatefulWidget {
  final int initialIndex;
  MainPage({Key? key, required this.initialIndex}) : super(key: key);
  MainPage.open(this.initialIndex);
  MainPage.close(this.initialIndex);
  MainPage.toggle(this.initialIndex);
  MainPage.isOpen(this.initialIndex);
  MainPage.stateNotifier(this.initialIndex);

  @override
  State<MainPage> createState() => _MainPageState();
}

class _MainPageState extends State<MainPage> {
  final ZoomDrawerController zoomDrawerController = ZoomDrawerController();
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex;
  }

  @override
  Widget build(BuildContext context) {
    return ZoomDrawer(
      controller: zoomDrawerController,
      menuScreen: DrawerScreen(setIndex: (index) async {
        setState(() {
          currentIndex = index;
          zoomDrawerController.close!();
        });
      }),
      mainScreen: currentScreen(),
      borderRadius: 30.sp,
      showShadow: true,
      angle: 0.0,
      slideWidth: 236.sp,
      menuBackgroundColor: AppColors.kPrimaryColor,
    );
  }

  Widget currentScreen() {
    switch (currentIndex) {
      case 0:
        return Attendence(
          title: "Attendence",
        );

      case 1:
        return const CreateSalesScreen(
          title: "Create Sales",
        );
      case 2:
        return const CreateOrderScreen(
          title: "Create Order",
        );
      case 3:
        return const ViewOrder(
          title: "Order",
        );
      case 4:
        return const LedgerReport(
          title: "Ledger Report",
        );
      case 5:
        return const CustomerOutstanding(
          title: "Customer Outstanding",
        );
      case 6:
        return const SupplierOutstanding(
          title: "Supplier Outstanding",
        );
      case 7:
        return const TrialStock(
          title: "Trial Stock",
        );
      case 8:
        return const AboutPage(
          title: "About Us",
        );

      case 9:
        return FutureBuilder(
          future: LogOut.logOut(context),
          builder: (BuildContext context, AsyncSnapshot<void> snapshot) {
            if (snapshot.connectionState == ConnectionState.done) {
              return const WelcomePage(); // Replace with your welcome screen widget
            } else if (snapshot.hasError) {
              return Container(); // You can show an error message or other UI
            } else {
              return const CircularProgressIndicator();
            }
          },
        );

      default:
        return Attendence();
    }
  }
}

class DrawerScreen extends StatefulWidget {
  final ValueSetter setIndex;
  const DrawerScreen({Key? key, required this.setIndex}) : super(key: key);
  @override
  State<DrawerScreen> createState() => _DrawerScreenState();
}

class _DrawerScreenState extends State<DrawerScreen> {
  final GlobalKey<ScaffoldState> _scaffoldKey = GlobalKey();
  Future<bool?> _showExitConfirmationDialog(BuildContext context) async {
    return showDialog<bool?>(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text('Exit App'),
          content: const Text('Do you want to exit the app?'),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.of(context).pop(false); // User doesn't want to exit
              },
              child: const Text('No'),
            ),
            TextButton(
              onPressed: () {
                exit(0); // User wants to exit
              },
              child: const Text('Yes'),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        final exitConfirmed = await _showExitConfirmationDialog(context);
        return exitConfirmed ?? false;
      },
      child: Scaffold(
        key: _scaffoldKey,
        backgroundColor: AppColors.kPrimaryColor,
        body: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.fromLTRB(5.sp, 10.sp, 0, 5.sp),
              child: drawerList(MaterialIcons.file_present, "Attendence", 0),
            ),
            ExpansionTile(
              title: Padding(
                padding: EdgeInsets.fromLTRB(7.sp, 5.sp, 0, 10.sp),
                child: Row(
                  children: [
                    const Icon(
                      FontAwesome.file_text_o,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 15.sp,
                    ),
                    const Text(
                      "Transaction",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.sp),
                  child: drawerList(Entypo.eye, "Create Sales", 1),
                ),
                SizedBox(
                  height: 3.sp,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.sp),
                  child: drawerList(FontAwesome.file_pdf_o, "Create Order", 2),
                ),
              ],
            ),
            ExpansionTile(
              title: Padding(
                padding: EdgeInsets.fromLTRB(7.sp, 5.sp, 0, 10.sp),
                child: Row(
                  children: [
                    const Icon(
                      Feather.file_plus,
                      color: Colors.white,
                    ),
                    SizedBox(
                      width: 15.sp,
                    ),
                    const Text(
                      "Reports",
                      style: TextStyle(color: Colors.white),
                    ),
                  ],
                ),
              ),
              children: [
                Padding(
                  padding: EdgeInsets.only(left: 20.sp),
                  child: drawerList(FontAwesome.file_pdf_o, "Order", 3),
                ),
                SizedBox(
                  height: 3.sp,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.sp),
                  child: drawerList(FontAwesome.file_pdf_o, "Ledger", 4),
                ),
                SizedBox(
                  height: 3.sp,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.sp),
                  child:
                      drawerList(FontAwesome.file_pdf_o, "Cus Outstanding", 5),
                ),
                SizedBox(
                  height: 3.sp,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.sp),
                  child:
                      drawerList(FontAwesome.file_pdf_o, "Splr Outstanding", 6),
                ),
                SizedBox(
                  height: 3.sp,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20.sp),
                  child: drawerList(FontAwesome.file_pdf_o, "Trial Stock", 7),
                ),
              ],
            ),
            Padding(
              padding: EdgeInsets.fromLTRB(5.sp, 15.sp, 0, 5.sp),
              child: drawerList(MaterialCommunityIcons.contacts, "About Us", 8),
            ),
           
            Padding(
              padding: EdgeInsets.fromLTRB(5.sp, 50.sp, 0, 5.sp),
              child: drawerList(AntDesign.logout, "LogOut", 9),
            ),
          ],
        ),
      ),
    );
  }

  Widget drawerList(IconData icon, String text, int index) {
    return InkWell(
      onTap: () {
        WidgetsBinding.instance.addPostFrameCallback((_) {
          widget.setIndex(index);
        });
      },
      child: Container(
        margin: EdgeInsets.only(left: 20.sp, bottom: 12.sp),
        child: Row(
          children: [
            Icon(
              icon,
              color: Colors.white54,
            ),
            SizedBox(
              width: 12.sp,
            ),
            Text(
              text,
              style: const TextStyle(
                  color: Colors.white, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }
}

class DrawerWidget extends StatelessWidget {
  DrawerWidget({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: () {
        ZoomDrawer.of(context)!.toggle();
      },
      icon: const Icon(Icons.menu),
    );
  }
}
// ignore: must_be_immutable
