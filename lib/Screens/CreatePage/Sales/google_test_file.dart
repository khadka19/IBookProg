// import 'dart:async';
// import 'dart:io';
// import 'package:flutter/material.dart';

// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:flutter_polyline_points/flutter_polyline_points.dart';
// import 'package:location/location.dart';

// class GoogleMapTest extends StatefulWidget {
//   const GoogleMapTest({super.key});

//   @override
//   State<GoogleMapTest> createState() => _GoogleMapTestState();
// }

// class _GoogleMapTestState extends State<GoogleMapTest> {
//   final Location _locationController = new Location();

//   final Completer<GoogleMapController> _mapController =
//       Completer<GoogleMapController>();

//   static const LatLng _pGooglePlex =
//       LatLng(27.696094182950855, 85.29264155880307);
//   static const LatLng _pApplePark = LatLng(27.686250, 85.348268);
//   LatLng? _currentP;

//   Map<PolylineId, Polyline> polylines = {};

//   @override
//   void initState() {
//     super.initState();
//     getLocationUpdates().then(
//       (_) => {
//         getPolylinePoints().then((coordinates) => {
//               generatePolyLineFromPoints(coordinates),
//             }),
//       },
//     );
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: _currentP == null
//           ? const Center(
//               child: Text("Loading..."),
//             )
//           : GoogleMap(
//               onMapCreated: ((GoogleMapController controller) =>
//                   _mapController.complete(controller)),
//               initialCameraPosition: const CameraPosition(
//                 target: _pGooglePlex,
//                 zoom: 13,
//               ),
//               markers: {
//                 Marker(
//                   markerId: const MarkerId("_currentLocation"),
//                   icon: BitmapDescriptor.defaultMarker,
//                   position: _currentP!,
//                 ),
//                 const Marker(
//                     markerId: MarkerId("_sourceLocation"),
//                     icon: BitmapDescriptor.defaultMarker,
//                     position: _pGooglePlex),
//                 const Marker(
//                     markerId: MarkerId("_destionationLocation"),
//                     icon: BitmapDescriptor.defaultMarker,
//                     position: _pApplePark)
//               },
//               polylines: Set<Polyline>.of(polylines.values),
//             ),
//     );
//   }

//   Future<void> _cameraToPosition(LatLng pos) async {
//     final GoogleMapController controller = await _mapController.future;
//     CameraPosition _newCameraPosition = CameraPosition(
//       target: pos,
//       zoom: 13,
//     );
//     await controller.animateCamera(
//       CameraUpdate.newCameraPosition(_newCameraPosition),
//     );
//   }

//   Future<void> getLocationUpdates() async {
//     bool _serviceEnabled;
//     PermissionStatus _permissionGranted;

//     _serviceEnabled = await _locationController.requestService();
//     if (!_serviceEnabled) {
//     // ignore: use_build_context_synchronously
//     exit(0);
//     } else {
//       _serviceEnabled = await _locationController.serviceEnabled();
//     }

//     _permissionGranted = await _locationController.requestPermission();
//     if (_permissionGranted == PermissionStatus.denied) {
//       // ignore: use_build_context_synchronously
//     exit(0);
//     } else if (_permissionGranted == PermissionStatus.granted) {
//       _permissionGranted = await _locationController.hasPermission();
//     }

//     _locationController.onLocationChanged
//         .listen((LocationData currentLocation) {
//       if (currentLocation.latitude != null &&
//           currentLocation.longitude != null) {
//         setState(() {
//           _currentP =
//               LatLng(currentLocation.latitude!, currentLocation.longitude!);
//           _cameraToPosition(_currentP!);
//         });
//       }
//     });
//   }

//   Future<List<LatLng>> getPolylinePoints() async {
//     List<LatLng> polylineCoordinates = [];
//     PolylinePoints polylinePoints = PolylinePoints();
//     PolylineResult result = await polylinePoints.getRouteBetweenCoordinates(
//       "AIzaSyAyjjGXcOkcQOnAVO0Yu9nUpNaonf9dvo8",
//       PointLatLng(_pGooglePlex.latitude, _pGooglePlex.longitude),
//       PointLatLng(_pApplePark.latitude, _pApplePark.longitude),
//       travelMode: TravelMode.driving,
//     );
//     if (result.points.isNotEmpty) {
//       result.points.forEach((PointLatLng point) {
//         polylineCoordinates.add(LatLng(point.latitude, point.longitude));
//       });
//     } else {
//       print(result.errorMessage);
//     }
//     return polylineCoordinates;
//   }

//   void generatePolyLineFromPoints(List<LatLng> polylineCoordinates) async {
//     PolylineId id = const PolylineId("poly");
//     Polyline polyline = Polyline(
//         polylineId: id,
//         color: Colors.black,
//         points: polylineCoordinates,
//         width: 8);
//     setState(() {
//       polylines[id] = polyline;
//     });
//   }
// }
