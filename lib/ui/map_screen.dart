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
import 'package:grabto/services/api_services.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/home_screen.dart';
import 'package:grabto/ui/select_address_screen.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:provider/provider.dart';

import '../helper/shared_pref.dart';
import '../helper/user_provider.dart';
import '../model/user_model.dart';
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
                    // Navigator.pop(context);
                    Navigator.pushReplacement(context, MaterialPageRoute(builder: (context)=>AddressScreen(type:widget.type)));

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
                    Icon(IconlyBold.location,color: MyColors.redBG,),
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
                Center(
                  child: ElevatedButton(
                    onPressed: () {
                      address.setAddress(_longName2);
                      address.setArea(_currentAddress);
                      confirmAddress(_currentAddress,widget.lat,widget.long);
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
                ),
              ],
            ),
          ),
        ],
      ),

    );
  }
  bool isLoading = false;
  Future<void> confirmAddress(String address, dynamic lat, dynamic long,) async {
    UserModel n = await SharedPref.getUser();
    try {
      setState(() {
        isLoading = true;
      });
      final body = {
        "user_id": n.id.toString(),
        "address": address,
        "lat": lat.toString(),
        "long": long.toString(),
      };
      print(body);
      final response = await ApiServices.confirmAddress(context, body);
print(response);
      // Check if the response is null or doesn't contain the expected data
      if (
          response!['error'] == false) {
        user_details(  n.id.toString());
        showSuccessMessage(context, message: response['message']);

      } else if (response != null) {
        String msg = response['message'];

        // Handle unsuccessful response or missing 'res' field
        showErrorMessage(context, message: msg);
      }
    } catch (e) {
      //print('verify_otp error: $e');
      // Handle error
      showErrorMessage(context, message: 'An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  List<BannerModel> banners=[];
  Future<void> user_details(String user_id) async {
    try {
      final body = {
        "user_id": user_id,
      };
      final response = await ApiServices.user_details(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          final user = UserModel.fromMap(data);
          print(user.banners.length);
          print("user.banners.length");
          setState(() {
            banners= user.banners;
          });
          print(banners.length);
          if (user != null) {
            await SharedPref.userLogin({
              SharedPref.KEY_ID: user.id,
              SharedPref.KEY_CURRENT_MONTH: user.current_month,
              SharedPref.KEY_PREMIUM: user.premium,
              SharedPref.KEY_STATUS: user.status,
              SharedPref.KEY_NAME: user.name,
              SharedPref.KEY_EMAIL: user.email,
              SharedPref.KEY_MOBILE: user.mobile,
              SharedPref.KEY_DOB: user.dob,
              SharedPref.KEY_OTP: user.otp,
              SharedPref.KEY_IMAGE: user.image,
              SharedPref.KEY_HOME_LOCATION: user.home_location,
              SharedPref.KEY_CURRENT_LOCATION: user.current_location,
              SharedPref.ADDRESS: user.address,
              SharedPref.KEY_LAT: user.lat,
              SharedPref.KEY_LONG: user.long,
              SharedPref.KEY_CREATED_AT: user.created_at,
              SharedPref.KEY_UPDATED_AT: user.updated_at,
              // SharedPref.KEY_BANNER: jsonEncode(user.banners),
            });
            Provider.of<UserProvider>(context, listen: false)
                .updateUserDetails(user);
            Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));

          } else {
            // Handle null user
            showErrorMessage(context, message: 'User data is invalid');
          }
        } else {
          // Handle invalid response data format
          showErrorMessage(context, message: 'Invalid response data format');
        }
      } else if (response != null) {
        String msg = response['msg'];

        // Handle unsuccessful response or missing 'res' field
        showErrorMessage(context, message: msg);
      }
    } catch (e) {
      //print('verify_otp error: $e');
      // Handle error
      //showErrorMessage(context, message: 'An error occurred: $e');
    } finally {}
  }

}
