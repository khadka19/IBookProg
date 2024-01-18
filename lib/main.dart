import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:petrolpump/CommonWidgets/route.dart';
import 'package:petrolpump/Provider/all_provider.dart';
import 'package:petrolpump/Provider/all_provider_order.dart';
import 'package:petrolpump/Provider/attendence.dart';
import 'package:petrolpump/Provider/cusOutstanding_provider.dart';
import 'package:petrolpump/Provider/ledger_provider.dart';
import 'package:petrolpump/Provider/order_provider.dart';
import 'package:petrolpump/Provider/splrOutstandingProvider.dart';
import 'package:petrolpump/Provider/trial_stock_provider.dart';
import 'package:petrolpump/Screens/splash_screen.dart';
import 'package:provider/provider.dart';

void main() async {
  await AwesomeNotifications().initialize(null, [
    NotificationChannel(
      channelGroupKey: "basic_channel_group",
      channelKey: "basic_channel",
      channelName: "Basic Notification",
      channelDescription: "Basic notifications channel",
    )
  ], channelGroups: [
    NotificationChannelGroup(
      channelGroupKey: "basic_channel_group",
      channelGroupName: "Basic Group",
    )
  ]);
  bool isAllowedToSendNotification =
      await AwesomeNotifications().isNotificationAllowed();
  if (!isAllowedToSendNotification) {
    AwesomeNotifications().requestPermissionToSendNotifications();
  }
  runApp(MultiProvider(providers: [
    ChangeNotifierProvider(create: (_) => CustomerProvider()),
    ChangeNotifierProvider(create: (_) => ProductProvider()),
    ChangeNotifierProvider(create: (_) => ProductListProvider()),
    ChangeNotifierProvider(
        create: (context) =>
            context.read<ProductProvider>().getDataRowProvider()),
    ChangeNotifierProvider(
      create: (context) => SalesProvider(
        context.read<ProductProvider>(),
        context.read<CustomerProvider>(),
      ),
    ),
    ChangeNotifierProvider(create: (_) => AttendenceProvider()),

// provider for order
    ChangeNotifierProvider(create: (_) => CustomerProviderO()),
    ChangeNotifierProvider(create: (_) => ProductProviderO()),
    ChangeNotifierProvider(create: (_) => ProductListProviderO()),
    ChangeNotifierProvider(
        create: (context) =>
            context.read<ProductProviderO>().getDataRowProvider()),
    ChangeNotifierProvider(
      create: (context) => OrderProvider(
        context.read<ProductProviderO>(),
        context.read<CustomerProviderO>(),
      ),
    ),
    ChangeNotifierProvider(create: (_) => ProductCompanyProviderO()),
    ChangeNotifierProvider(create: (_) => ViewOrderProvider()),
    ChangeNotifierProvider(create: (_) => CustomerProviderVO()),
    ChangeNotifierProvider(create: (_) => OrderDetailsProvider()),
    ChangeNotifierProvider(create: (_) => CustomerProviderLR()),
    ChangeNotifierProvider(create: (_) => LedgerDateProvider()),
    ChangeNotifierProvider(create: (_) => PDFLedgerProvider()),
    ChangeNotifierProvider(create: (_) => CustomerOutstandingProvider()),
    ChangeNotifierProvider(create: (_) => SupplierOutstandingProvider()),
    ChangeNotifierProvider(create: (_) => TrialStockProvider()),
  ], child: const MyApp()));
  // LocationUtilitiies().initBackgroundFetch();
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> {
  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(360, 690),
      minTextAdapt: true,
      splitScreenMode: true,
      child: MaterialApp(
        onGenerateRoute: AppRoutes.generateRoute,
        debugShowCheckedModeBanner: false,
        theme: ThemeData(
          primaryColor: const Color(0xff25727A),
          visualDensity: VisualDensity.adaptivePlatformDensity,
        ),
        home: const SplashScreen(),
      ),
    );
  }
}
