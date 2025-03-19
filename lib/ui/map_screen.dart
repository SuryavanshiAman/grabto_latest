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
import 'package:grabto/helper/location_provider.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/home_screen.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import 'add_address_bottom_sheet_screen.dart';

class LocationPickerScreen extends StatefulWidget {
  final double lat;
  final double long;
  final int type;

  const LocationPickerScreen({super.key, required this.lat, required this.long,required this.type});

  @override
  _LocationPickerScreenState createState() => _LocationPickerScreenState();
}

class _LocationPickerScreenState extends State<LocationPickerScreen> {
  GoogleMapController? _mapController;
  late LatLng _currentLocation;
  String _currentAddress = "Fetching address..."; // Default text
  String _longName = "Fetching details...";
  String _longName2 = "Fetching details...";
  @override
  void initState() {
    super.initState();
    _currentLocation = LatLng(widget.lat, widget.long);
    // _getCurrentLocation();
    print(widget.lat);
    print(widget.long);
    print("widget.long");
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
  static const String googleApiKey = "AIzaSyCOqfJTgg1Blp1GIeh7o8W8PC1w5dDyhWI";
  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    try {
      // final url = Uri.parse("https://nominatim.openstreetmap.org/reverse?format=json&lat=$lat&lon=$lng");
      final url = Uri.parse("https://maps.googleapis.com/maps/api/geocode/json?latlng=$lat,$lng&key=$googleApiKey");
print(url);
      final response = await http.get(url,
          );
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        String formattedAddress = data["results"][0]["formatted_address"];
        List<dynamic> addressComponents = data["results"][0]["address_components"];
        String longName = addressComponents.isNotEmpty ? addressComponents[0]["long_name"] : "Not Available";
        String longName2 = addressComponents.isNotEmpty ? addressComponents[1]["long_name"] : "Not Available";

        setState(() {
          _currentAddress = formattedAddress;
          _longName = longName;
          _longName = longName;
          _longName2 = longName2;
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
    final address=Provider.of<Address>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(
          "Select delivery location",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Stack(
        alignment: Alignment.bottomCenter,
        clipBehavior:Clip.none,
        children: [
          GoogleMap(
            initialCameraPosition: CameraPosition(
              target:  LatLng(widget.lat, widget.long),
              zoom: 16,
            ),
            onMapCreated: (GoogleMapController controller) {
              _mapController = controller;
            },
            onCameraMove: (CameraPosition position) {
              print(position.target.latitude);
              print(position.target.longitude);
              print("dq");
              _getAddressFromLatLng(position.target.latitude,position.target.longitude);
            },
          ),
          Padding(
            padding: const EdgeInsets.only(top: 18.0),
            child: Align(
              alignment: Alignment.topCenter,
              child: SizedBox(
                height: heights*0.06,
                width: widths*0.9,
                child: TextField(
                  // controller: searchCont,
                  // maxLines: 3,
                  readOnly: true,
                  decoration: InputDecoration(
                    filled: true,

                    fillColor: MyColors.whiteBG,
                    contentPadding: EdgeInsets.only(top: 10,left: 10),
                    border: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                        borderRadius: BorderRadius.circular(10)
                    ),
                    hintText: "Search for a building,street name,or area",
                    hintStyle: TextStyle(color: Colors.grey,fontSize: 13),
                    // prefixIcon: Icon(Icons.search, color: Colors.black),
                    suffixIcon:Icon(Icons.search, color: Colors.black),

                  ),
                  onTap: (){
                    Navigator.pop(context);
                  },
                  onChanged: (String value) {

                    // fetchSuggestions(value);
                  },
                ),
              ),
            ),
          ),
          Center(
            child: Icon(Icons.location_pin, size: 50, color: Colors.red),
          ),
          Container(
            height: 170,
            padding: EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(10),
              boxShadow: [
                BoxShadow(color: Colors.black26, blurRadius: 5),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(IconlyBold.location,color: MyColors.orange,),
                    Text(
                      _longName.toString(),
                      style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                    ),
                    Spacer(),
                    InkWell(
                      onTap: (){
                        Navigator.pop(context);
                      },
                      child: Container(
                        padding: EdgeInsets.fromLTRB(10,2,10,2),
                        decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(5),
                          color: Colors.grey.withOpacity(0.2)
                        ),
                        child: Text("CHANGE",style: TextStyle(fontSize: 12,color: MyColors.orange,fontWeight: FontWeight.w500)),
                      ),
                    )
                  ],
                ),
                Text(
                  _currentAddress,
                  maxLines: 2,
                  style: TextStyle(fontSize: 16,fontWeight: FontWeight.w400,),
                  textAlign: TextAlign.left,
                ),
                SizedBox(height: 15),
                ElevatedButton(

                  onPressed: () {
                    address.setAddress(_longName2);
                    address.setArea(_currentAddress);
                    widget.type==1?
                    showModalBottomSheet(
                      context: context,
                      isScrollControlled: true,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
                      ),
                      builder: (context) => const AddressBottomSheet(),
                    ):Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: MyColors.orange,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(5),
                    ),
                    padding: EdgeInsets.symmetric(vertical: 12,horizontal:100),
                  ),
                  child: Text("CONFIRM LOCATION", style: TextStyle(fontSize: 14,color: MyColors.whiteBG)),
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
}
