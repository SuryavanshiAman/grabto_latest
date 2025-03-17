//
// import 'package:flutter/material.dart';
// import 'package:google_maps_flutter/google_maps_flutter.dart';
// import 'package:geolocator/geolocator.dart';
//
// class LocationPickerScreen extends StatefulWidget {
//   final double lat;
//   final double long;
//
//   const LocationPickerScreen({super.key, required this.lat, required this.long});
//
//   @override
//   _LocationPickerScreenState createState() => _LocationPickerScreenState();
// }
//
// class _LocationPickerScreenState extends State<LocationPickerScreen> {
//   GoogleMapController? _mapController;
//   late LatLng _currentLocation;
//
//   @override
//   void initState() {
//     super.initState();
//     _currentLocation = LatLng(widget.lat, widget.long); // Initialize here
//     _getCurrentLocation();
//     print(widget.lat);
//     print(widget.long);
//     print("Qwerty");
//   }
//
//   Future<void> _getCurrentLocation() async {
//     LocationPermission permission = await Geolocator.requestPermission();
//
//     // Check if permission is denied
//     if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
//       return;
//     }
//
//     Position position = await Geolocator.getCurrentPosition(
//       desiredAccuracy: LocationAccuracy.high,
//     );
//
//     setState(() {
//       _currentLocation = LatLng(position.latitude, position.longitude);
//     });
//
//     _mapController?.animateCamera(CameraUpdate.newLatLng(_currentLocation));
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Stack(
//         children: [
//           GoogleMap(
//             initialCameraPosition: CameraPosition(
//               target: _currentLocation,
//               zoom: 16,
//             ),
//             onMapCreated: (GoogleMapController controller) {
//               _mapController = controller;
//             },
//             onCameraMove: (CameraPosition position) {
//               setState(() {
//                 _currentLocation = position.target;
//               });
//             },
//           ),
//           Center(
//             child: Icon(Icons.location_pin, size: 50, color: Colors.red),
//           ),
//           Positioned(
//             bottom: 20,
//             left: 20,
//             right: 20,
//             child: Column(
//               children: [
//                 Container(
//                   padding: EdgeInsets.all(10),
//                   decoration: BoxDecoration(
//                     color: Colors.white,
//                     borderRadius: BorderRadius.circular(10),
//                     boxShadow: [
//                       BoxShadow(color: Colors.black26, blurRadius: 5),
//                     ],
//                   ),
//                   child: Column(
//                     children: [
//                       Text(
//                         _currentLocation.toString(),
//                         style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//                       ),
//                       Text("Kapalitala Lane, Bowbazar, Kolkata, West Bengal, India"),
//                       SizedBox(height: 5),
//                       ElevatedButton(
//                         onPressed: () {
//                           // Confirm the location
//                         },
//                         style: ElevatedButton.styleFrom(
//                           backgroundColor: Colors.red,
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(5),
//                           ),
//                           padding: EdgeInsets.symmetric(vertical: 12),
//                         ),
//                         child: Text("CONFIRM LOCATION", style: TextStyle(fontSize: 16)),
//                       ),
//                     ],
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:geolocator/geolocator.dart';
import 'package:geocoding/geocoding.dart';
import 'package:http/http.dart' as http;

class LocationPickerScreen extends StatefulWidget {
  final double lat;
  final double long;

  const LocationPickerScreen({super.key, required this.lat, required this.long});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  late LatLng _currentLocation;
  String _currentAddress = "Fetching address..."; // Default text

  @override
  void initState() {
    super.initState();
    _currentLocation = LatLng(widget.lat, widget.long);
    _getCurrentLocation();
  }

  /// Function to get the current location
  Future<void> _getCurrentLocation() async {
    LocationPermission permission = await Geolocator.requestPermission();

    if (permission == LocationPermission.denied || permission == LocationPermission.deniedForever) {
      return;
    }

    Position position = await Geolocator.getCurrentPosition(
      desiredAccuracy: LocationAccuracy.high,
    );

    setState(() {
      _currentLocation = LatLng(position.latitude, position.longitude);
    });

    // Fetch and update the address
    _getAddressFromLatLng(position.latitude, position.longitude);

    _mapController?.animateCamera(CameraUpdate.newLatLng(_currentLocation));
  }

  /// Function to get address from latitude and longitude
  // Future<void> _getAddressFromLatLng(double lat, double lng) async {
  //   try {
  //     List<Placemark> placemarks = await placemarkFromCoordinates(lat, lng);
  //
  //     if (placemarks.isNotEmpty) {
  //       Placemark place = placemarks[0];
  //
  //       setState(() {
  //         _currentAddress = "${place.street}, ${place.locality}, ${place.administrativeArea}, ${place.country}";
  //       });
  //     }
  //   } catch (e) {
  //     print("Error fetching address: $e");
  //     setState(() {
  //       _currentAddress = "Unable to fetch address";
  //     });
  //   }
  // }
  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      final url = Uri.parse("https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng");

      final response = await http.get(url);
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        setState(() {
          _currentAddress = data["display_name"] ?? "No address found";
        });
      } else {
        setState(() {
          _currentAddress = "Failed to fetch address";
        });
      }
    } catch (e) {
      print("Error fetching address: $e");
      setState(() {
        _currentAddress = "Unable to fetch address";
      });
    }
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target: _currentLocation,
              zoom: 16,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onCameraMove: (CameraPosition position) {
              setState(() {
                _currentLocation = position.target;
              });

              // Update address as the map moves
              _getAddressFromLatLng(position.target.latitude, position.target.longitude);
            },
          ),
          Center(
            child: Icon(Icons.location_pin, size: 50, color: Colors.red),
          ),
          Positioned(
            bottom: 20,
            left: 20,
            right: 20,
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.all(10),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(10),
                    boxShadow: [
                      BoxShadow(color: Colors.black26, blurRadius: 5),
                    ],
                  ),
                  child: Column(
                    children: [
                      Text(
                        _currentLocation.toString(),
                        style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                      ),
                      Text(
                        _currentAddress,
                        style: TextStyle(fontSize: 16),
                        textAlign: TextAlign.center,
                      ),
                      SizedBox(height: 5),
                      ElevatedButton(
                        onPressed: () {
                          // Confirm the location
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(5),
                          ),
                          padding: EdgeInsets.symmetric(vertical: 12),
                        ),
                        child: Text("CONFIRM LOCATION", style: TextStyle(fontSize: 16)),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
