import 'dart:async';
import 'package:awesome_notifications/awesome_notifications.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:petrolpump/API_Services/attendence_services.dart';
import 'package:petrolpump/CommonWidgets/colors.dart';
import 'package:petrolpump/CommonWidgets/notification.dart';
import 'package:petrolpump/Provider/attendence.dart';
import 'package:petrolpump/Screens/CreatePage/main_page.dart';
import 'package:petrolpump/Utilities/utilities.dart';
import 'package:petrolpump/models/PostModel/attendence_post_model.dart';
import 'package:petrolpump/models/PostModel/user_movement_post.dart';
import 'package:petrolpump/models/attendence_checkStatus_model.dart';
import 'package:provider/provider.dart';
import 'package:slide_to_act/slide_to_act.dart';

// ignore: must_be_immutable
class Attendence extends StatefulWidget {
  String title;
   
  Attendence({
    Key? key,
    this.title = "Attendence",
   
  }) : super(key: key);

  @override
  State<Attendence> createState() => _AttendenceState();
}

class _AttendenceState extends State<Attendence> {

@override
  void initState() {
    AwesomeNotifications().setListeners(
        onActionReceivedMethod: NotificationController.onActionReceivedMethod,
        onNotificationCreatedMethod:
            NotificationController.onNotificationCreatedMethod,
        onNotificationDisplayedMethod:
            NotificationController.onNotificationDisplayedMethod,
        onDismissActionReceivedMethod:
            NotificationController.onDismissActionReceivedMethod);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    MyServiceAttendence myServiceAttendence = MyServiceAttendence();
    final attendenceProvider = Provider.of<AttendenceProvider>(context);
    var selectedAttendenceModelProvider =
        attendenceProvider.selectedAttendenceModel;
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
        appBar: AppBar(
          backgroundColor: AppColors.kPrimaryColor,
          elevation: 0,
          title: Text(widget.title),
          centerTitle: true,
          leading:  DrawerWidget(),
        ),
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                const SizedBox(
                  height: 20,
                ),
                SvgPicture.asset(
                  "assets/images/arrow.svg",
                  height: screenHeight * 0.08,
                  width: screenWidth * 0.04,
                  fit: BoxFit.fill,
                ),
                const SizedBox(
                  height: 5,
                ),
                Stack(
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(top: 15, left: 40),
                      child: Opacity(
                          opacity: 0.1,
                          child: SvgPicture.asset(
                            "assets/images/mobileHolding2.svg",
                            height: screenHeight * 0.3,
                            width: screenWidth * 0.3,
                          )),
                    ),
                    SvgPicture.asset(
                      "assets/images/mobileHolding2.svg",
                      height: screenHeight * 0.3,
                      width: screenWidth * 0.3,
                    ),
                  ],
                ),
                SizedBox(
                  height: screenHeight * 0.07,
                ),
                Text(
                  "Don't Forget Your Attendence ",
                  style: GoogleFonts.abrilFatface(
                      color: const Color.fromARGB(255, 197, 119, 3),
                      fontWeight: FontWeight.bold,
                      fontSize: 18.sp,
                      letterSpacing: 2),
                ),
                Container(),
                SizedBox(
                  height: screenHeight * 0.04,
                ),
                FutureBuilder<AttendenceCheckStatus>(
                  future: myServiceAttendence.getCheckStatus(),
                  builder: (BuildContext context,
                      AsyncSnapshot<AttendenceCheckStatus> snapshot) {
                    if (snapshot.connectionState == ConnectionState.done) {
                      if (snapshot.hasData) {
                        final attendence = snapshot.data;
                        selectedAttendenceModelProvider.checkIn =
                            attendence!.checkIn;
                        selectedAttendenceModelProvider.checkInTime =
                            attendence.checkInTime;
                        selectedAttendenceModelProvider.checkOut =
                            attendence.checkOut;
                        selectedAttendenceModelProvider.checkOutTime =
                            attendence.checkOutTime;

                        if (selectedAttendenceModelProvider.checkIn == true &&
                            selectedAttendenceModelProvider.checkOut == true) {
                          return const CheckOutTime();
                        } else if (selectedAttendenceModelProvider.checkIn ==
                            true) {
                          return const CheckOutSliderAndCheckInTime();
                        } else {
                          return const CheckInSlider();
                        }
                      }
                      {
                        return const Text("Attendence data is null.");
                      }
                    } else {
                      return const CircularProgressIndicator(); // Example loading indicator
                    }
                  },
                )
              ],
            ),
          ),
        ));
  }
}

class CheckInSlider extends StatefulWidget {
  static String formattedCheckInTime = '';

  const CheckInSlider({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckInSlider> createState() => _CheckInSliderState();
}

class _CheckInSliderState extends State<CheckInSlider> {
  @override
  Widget build(BuildContext context) {
    final attendenceProvider = Provider.of<AttendenceProvider>(context);
    // Note : below 2 line code is to access that above _selectedAttendenceModel here
    DateTime dataTime = DateTime.now();
    CheckInSlider.formattedCheckInTime = "${dataTime.toLocal()}";
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Builder(builder: (context) {
              final GlobalKey<SlideActionState> key = GlobalKey();
              return SlideAction(
                height: screenHeight * 0.06,
                sliderButtonIconPadding: 8.sp,
                text: "Slide to Check In",
                textStyle: const TextStyle(
                  letterSpacing: 1,
                  color: Colors.white,
                  fontSize: 18,
                ),
                outerColor: AppColors.successColor,
                innerColor: Colors.white,
                key: key,
                onSubmit: () async {
                  try {
                    Future<Position> position =
                        LocationUtilitiies.getCurrentPosition(context);
                    position.then((position) async {
                      AttendencePostModel model = AttendencePostModel(
                          id: 0,
                          userId: 0,
                          attendanceDateTime:
                              CheckInSlider.formattedCheckInTime,
                          attendenceType: "CHECKIN",
                          latitude: position.latitude,
                          longitude: position.longitude);

                      bool response =
                          await MyServiceAttendence().postAttendence(model);
                      if (response == true) {
                        // ignore: use_build_context_synchronously
                         AwesomeNotifications().createNotification(
                        content: NotificationContent(
                            id: 1,
                            channelKey: "basic_channel",
                            title: "Location Tracking",
                            body:
                                "Hello ! Your Location is being tracked now."),
                      );
                        // ignore: use_build_context_synchronously
                        Utilities.showSnackBar(
                            context, "Checked In Successfully !!!", true);
                        attendenceProvider.setCheckIn(true);
                      }
                      key.currentState!.reset();
                      // ignore: body_might_complete_normally_catch_error
                    }).catchError((error) {});
                  } catch (e) {
                    print("Error: $e");
                  }
                },
              );
            })),
      ],
    );
  }
}

class CheckOutSliderAndCheckInTime extends StatefulWidget {
  const CheckOutSliderAndCheckInTime({
    Key? key,
  }) : super(key: key);
  @override
  State<CheckOutSliderAndCheckInTime> createState() =>
      _CheckOutSliderAndCheckInTimeState();
}

class _CheckOutSliderAndCheckInTimeState
    extends State<CheckOutSliderAndCheckInTime> {
  Timer? locationUpdateTimer;
  @override
  void initState() {
    super.initState();
    // Start the timer for location updates every 2 minutes
    locationUpdateTimer = Timer.periodic(const Duration(minutes: 16), (timer) {
      try {
       LocationUtilitiies.updateUserLocation(context);
      } catch (e) {
        print("Error in _updateUserLocation: $e");
      }
       print("Timer executed at ${DateTime.now()}");
      // Call the function to update user location
    });
  }

 @override
  void dispose() {
    // Dispose the timer when the widget is disposed
    locationUpdateTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final attendenceProvider = Provider.of<AttendenceProvider>(context);
    var selectedAttendenceModelProvider =
        attendenceProvider.selectedAttendenceModel;
    DateTime dataTime = DateTime.now();
    String formattedDateTime = "${dataTime.toLocal()}";
    var screenWidth = MediaQuery.of(context).size.width;
    var screenHeight = MediaQuery.of(context).size.height;
    return Column(
      children: [
        SizedBox(
          width: screenWidth * 0.9,
          child: Card(
            shadowColor: AppColors.borderColor,
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Your Check In Time",
                        style: GoogleFonts.abyssinicaSil(
                            color: AppColors.kPrimaryColor,
                            letterSpacing: 1,
                            fontSize: 16.sp),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_clock),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(
                            selectedAttendenceModelProvider.checkInTime,
                            style: TextStyle(fontSize: 14.sp),
                          )
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Builder(builder: (context) {
              final GlobalKey<SlideActionState> key = GlobalKey();
              return SlideAction(
                  height: screenHeight * 0.06,
                  sliderButtonIconPadding: 8.sp,
                  text: "Slide to Check Out",
                  textStyle: const TextStyle(
                    letterSpacing: 1,
                    color: Colors.white,
                    fontSize: 18,
                  ),
                  outerColor: AppColors.warningColor,
                  innerColor: Colors.white,
                  key: key,
                  onSubmit: () async {
                    try {
                    // _updateUserLocation();
                      Future<Position> position =
                          LocationUtilitiies.getCurrentPosition(context);
                      position.then((position) async {
                        AttendencePostModel model = AttendencePostModel(
                            id: 0,
                            userId: 0,
                            attendanceDateTime: formattedDateTime,
                            attendenceType: "CHECKOUT",
                            latitude: position.latitude,
                            longitude: position.longitude);

                        bool response =
                            await MyServiceAttendence().postAttendence(model);
                        // ignore: unrelated_type_equality_checks
                        if (response == true) {
                          // ignore: use_build_context_synchronously
                          Utilities.showSnackBar(
                              context, "Checked Out Successfully !!!", true);
                          attendenceProvider.setCheckOut(true);
                          // ignore: use_build_context_synchronously
                      locationUpdateTimer?.cancel();

                        }
                        // ignore: body_might_complete_normally_catch_error
                      }).catchError((error) {});
                    } catch (e) {
                      print("Error: $e");
                    }
                  });
            })),
      ],
    );
  }
}

class CheckOutTime extends StatefulWidget {
  const CheckOutTime({
    Key? key,
  }) : super(key: key);

  @override
  State<CheckOutTime> createState() => _CheckOutTimeState();
}

class _CheckOutTimeState extends State<CheckOutTime> {
  @override
  Widget build(BuildContext context) {
    final attendenceProvider = Provider.of<AttendenceProvider>(context);
    var selectedAttendenceModelProvider =
        attendenceProvider.selectedAttendenceModel;
    var screenWidth = MediaQuery.of(context).size.width;
    return SizedBox(
      width: screenWidth * 0.9,
      child: Column(
        children: [
          Card(
            shadowColor: AppColors.borderColor,
            elevation: 6,
            child: Padding(
              padding: const EdgeInsets.all(20),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Column(
                    children: [
                      Text(
                        "Your Check In Time",
                        style: GoogleFonts.abyssinicaSil(
                            color: AppColors.kPrimaryColor,
                            letterSpacing: 1,
                            fontSize: 16.sp),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_clock),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(selectedAttendenceModelProvider.checkInTime,
                              style: TextStyle(fontSize: 14.sp))
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(
                    height: 15,
                  ),
                  Column(
                    children: [
                      Text(
                        "Your Check Out Time",
                        style: GoogleFonts.abyssinicaSil(
                            color: AppColors.kPrimaryColor,
                            letterSpacing: 1,
                            fontSize: 16.sp),
                      ),
                      const SizedBox(
                        height: 5,
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Icon(Icons.lock_clock),
                          const SizedBox(
                            width: 3,
                          ),
                          Text(selectedAttendenceModelProvider.checkOutTime,
                              style: TextStyle(fontSize: 14.sp))
                        ],
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          const Opacity(
              opacity: 0.8,
              child: Text(
                "NOTE : You can do Check In only the Next Day...",
                style: TextStyle(
                  color: AppColors.warningColor,
                ),
              ))
        ],
      ),
    );
  }
}

class LocationUtilitiies {
  static late Location location; // Declare the Location object
  static Timer? locationUpdateTimer; // Timer for location updates
 

 static updateUserLocation(BuildContext context) {
    try {
     
      Future<Position> positionUserMovement =
          LocationUtilitiies._getCurrentPositionUserMovement(context);
      positionUserMovement.then((positionUserMovement) async {
        UserMovementPostModel modelUserMovement = UserMovementPostModel(
          UserId: 0,
          MovementDateTime: CheckInSlider.formattedCheckInTime,
          Latitude: positionUserMovement.latitude,
          Longitude: positionUserMovement.longitude,
        );
        bool responseUserMovement =
            await MyServiceAttendence().userMovementPost(modelUserMovement);
            print("User movement response: $responseUserMovement");
        // Handle the response as needed
      });
    } catch (e) {
      print("Error: $e");
    }
  }


  static Future<Position> getCurrentPosition(BuildContext context) async {
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) {
      throw Exception("Location permission not granted.");
    }
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (e) {
      throw Exception("Failed to get current position: $e");
    }
  }

  static Future<Position> _getCurrentPositionUserMovement(
      BuildContext context) async {
    final hasPermission = await _handleLocationPermission(context);
    if (!hasPermission) {
      throw Exception("Location permission not granted.");
    }
    try {
      final Position position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.high);
      return position;
    } catch (e) {
      throw Exception("Failed to get current position: $e");
    }
  }

  static _handleLocationPermission(BuildContext context) async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location services are disabled. Please enable the services')));
      return false;
    }
    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        // ignore: use_build_context_synchronously
        ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('Location permissions are denied')));
        return false;
      }
    }
    if (permission == LocationPermission.deniedForever) {
      // ignore: use_build_context_synchronously
      ScaffoldMessenger.of(context).showSnackBar(const SnackBar(
          content: Text(
              'Location permissions are permanently denied, we cannot request permissions.')));
      return false;
    }
    return true;
  }
}