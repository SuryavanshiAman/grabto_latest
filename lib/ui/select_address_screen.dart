import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';
import 'package:http/http.dart' as http;
import 'package:iconly/iconly.dart';
import 'package:lucide_icons/lucide_icons.dart';

import 'map_screen.dart';

class AddressScreen extends StatefulWidget {
  final int type;

  const AddressScreen({super.key,required this.type});
  @override
  State<AddressScreen> createState() => _AddressScreenState();
}

class _AddressScreenState extends State<AddressScreen> {
  final TextEditingController searchCont = TextEditingController();

  List<dynamic> suggestions = [];
  bool isLoading = false;

  static const String googleApiKey = "AIzaSyCOqfJTgg1Blp1GIeh7o8W8PC1w5dDyhWI";
bool visibility=false;
  Future<void> fetchSuggestions(String query) async {
    if (query.isEmpty) return;

    setState(() {
      isLoading = true;
    });

    final url =
        "https://maps.googleapis.com/maps/api/place/autocomplete/json?input=$query&key=$googleApiKey&components=country:IN";
    print("Fetching suggestions: $url");

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final rawSuggestions = data['predictions'] as List;

        // Fetch additional details for each suggestion
        List<Map<String, dynamic>> enrichedSuggestions = [];
        for (var suggestion in rawSuggestions) {
          final placeId = suggestion['place_id'];
          final details = await fetchPlaceDetailsForSuggestion(placeId);
          print("Aman:${suggestion['description']}");
          print("Aman:${ details['latitude']}");
          print("Aman:${details['longitude']}");
          setState(() {
            visibility=true;
          });
          enrichedSuggestions.add({
            'description': suggestion['description'],
            'place_id': placeId, // Add the place_id here
            'district': details['district'] ?? '',
            'pincode': details['pincode'] ?? '',
            'latitude': details['latitude'] ?? 0.0,
            'longitude': details['longitude'] ?? 0.0,
          });
        }

        setState(() {
          suggestions = enrichedSuggestions;
        });
      } else {
        throw Exception("Failed to load suggestions");
      }
    } catch (e) {
      print("Error fetching suggestions: $e");
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  Future<Map<String, dynamic>> fetchPlaceDetailsForSuggestion(String placeId) async {
    final url =
        "https://maps.googleapis.com/maps/api/place/details/json?place_id=$placeId&key=$googleApiKey";
    // print("Fetching place details: $url");
    print("Fetching place details: $placeId");
    print("Dhakelu");

    try {
      final response = await http.get(Uri.parse(url));
      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        final addressComponents = data['result']['address_components'];
        final geometry = data['result']['geometry']['location'];

        String district = '';
        String pincode = '';
        double latitude = geometry['lat'];
        double longitude = geometry['lng'];

        // Extract district and pincode
        for (var component in addressComponents) {
          if (component['types'].contains('administrative_area_level_3')) {
            district = component['long_name'];
          }
          if (component['types'].contains('postal_code')) {
            pincode = component['long_name'];
          }
        }

        return {
          'district': district,
          'pincode': pincode,
          'latitude': latitude,
          'longitude': longitude,
        };
      } else {
        throw Exception("Failed to fetch place details");
      }
    } catch (e) {
      print("Error fetching place details: $e");
      return {};
    }
  }
  GoogleMapController? _mapController;
  late LatLng _currentLocation;
  Future<void> _getCurrentLocation(dynamic type) async {
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
    _getAddressFromLatLng(position.latitude, position.longitude, type);

    _mapController?.animateCamera(CameraUpdate.newLatLng(_currentLocation));
  }
  // static const String googleApiKey = "AIzaSyCOqfJTgg1Blp1GIeh7o8W8PC1w5dDyhWI";
  String _currentAddress = "Fetching address..."; // Default text
  String _longName = "Fetching details...";
  double _latitude=0.0;
  double _longitude=0.0;
  Future<void> _getAddressFromLatLng(double lat, double lng,dynamic type) async {
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
        Map<String, dynamic> location = data["results"][0]["geometry"]["location"];
        double fetchedLat = location["lat"];
        double fetchedLng = location["lng"];

        setState(() {
          _currentAddress = formattedAddress;
          _longName = longName;
          _latitude = fetchedLat;
          _longitude = fetchedLng;
          Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationPickerScreen(lat:_latitude,long:_longitude,type:type)));

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
  String selectedLocation = "Write here my selected location";
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteBG,
      appBar: AppBar(
        title: Text(
          "Enter your area or apartment name",
          style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
        ),
        leading: IconButton(
          icon: Icon(Icons.arrow_back, color: Colors.black),
          onPressed: () => Navigator.pop(context),
        ),
        backgroundColor: Colors.white,
        elevation: 0,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // Search Box
            SizedBox(
              height: heights*0.06,
              child: TextField(
                controller: searchCont,
                // maxLines: 3,

                decoration: InputDecoration(
contentPadding: EdgeInsets.only(top: 10),
                  border: OutlineInputBorder(
                    borderSide: BorderSide(color: Colors.grey.withOpacity(0.2)),
                    borderRadius: BorderRadius.circular(15)
                  ),
                  focusedBorder: OutlineInputBorder(
                      borderSide: BorderSide(color: Colors.grey.withOpacity(0.5)),
                      borderRadius: BorderRadius.circular(15)
                  ),
                  hintText: "Try JP Nagar, Siri Gardenia, etc.",
                  hintStyle: TextStyle(color: Colors.grey),
                  prefixIcon: Icon(Icons.search, color: Colors.black),
                  suffixIcon: searchCont.text.isNotEmpty
                      ? IconButton(
                    icon: Icon(Icons.cancel_rounded, color: Colors.grey),
                    onPressed: () {
                      setState(() {
                        searchCont.clear();
                      });
                      },
                  )
                      : null,

                ),
                onChanged: (String value) {
                  fetchSuggestions(value);
                },
              ),
            ),
            SizedBox(height: 16),
            // Use My Current Location
            // SizedBox(
            //   height: heights*0.05,
            //   child: ListTile(
            //     minLeadingWidth: 5,
            //     title: Row(
            //       children: [
            //         Icon(Icons.navigation_rounded, color: Colors.red,size: 18,),
            //         Text(
            //           "Use my current location",
            //           style: TextStyle(
            //               color: Colors.red, fontWeight: FontWeight.w600),
            //         ),
            //       ],
            //     ),
            //     trailing: Icon(Icons.arrow_forward_ios_rounded,size: 16,),
            //     onTap: () {
            //       _getCurrentLocation(2).then((data){});
            //     },
            //   ),
            // ),
            InkWell(
              onTap: (){
                _getCurrentLocation(2);

              },
              child: Container(
                height: heights*0.05,
                child:Row(
                  children: [
                    Icon(Icons.navigation_rounded, color: Colors.red,size: 18,),
                    Text(
                      "Use my current location",
                      style: TextStyle(
                          color: Colors.red, fontWeight: FontWeight.w600),
                    ),
                    Spacer(),
                    Icon(Icons.arrow_forward_ios_rounded,size: 14,)
                  ],
                ),
                // ListTile(
                //
                //   minLeadingWidth: 5,
                //   // tileColor: Colors.red,
                //   title: Row(
                //     children: [
                //   Icon(LucideIcons.plus, color: Colors.red,size: 18,weight: 50,),
                //       Text(
                //         "Add new address",
                //         style: TextStyle(
                //             color: Colors.red, fontWeight:  FontWeight.w600),
                //       ),
                //     ],
                //   ),
                //
                //   onTap: () {
                //     _getCurrentLocation(1);
                //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationPickerScreen(lat:suggestion['latitude'],long:suggestion['longitude'],type:1)));
                //
                //   },
                // ),
              ),
            ),
            Container(
              margin: EdgeInsets.only(top: 10,bottom: 10),
              color:  MyColors.textColor.withOpacity(0.1),
              height: 1,
              width: widths,
            ),
            // Divider(color: MyColors.textColor.withOpacity(0.1),height: 50,),
            InkWell(
              onTap: (){
                _getCurrentLocation(1);

              },
              child: Container(
                height: heights*0.05,
                child:Row(
                  children: [
                    Icon(LucideIcons.plus, color: Colors.red,size: 18,weight: 50,),
                    Text(
                      "Add new address",
                      style: TextStyle(
                          color: Colors.red, fontWeight:  FontWeight.w600),
                    ),
                  ],
                ),
                // ListTile(
                //
                //   minLeadingWidth: 5,
                //   // tileColor: Colors.red,
                //   title: Row(
                //     children: [
                //   Icon(LucideIcons.plus, color: Colors.red,size: 18,weight: 50,),
                //       Text(
                //         "Add new address",
                //         style: TextStyle(
                //             color: Colors.red, fontWeight:  FontWeight.w600),
                //       ),
                //     ],
                //   ),
                //
                //   onTap: () {
                //     _getCurrentLocation(1);
                //     // Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationPickerScreen(lat:suggestion['latitude'],long:suggestion['longitude'],type:1)));
                //
                //   },
                // ),
              ),
            ),
            Divider(color: MyColors.textColor.withOpacity(0.1),),
            // Saved Addresses
         visibility==false?Padding(
              padding: const EdgeInsets.symmetric(vertical: 8.0),
              child: Text(
                "SAVED ADDRESSES",
                style: TextStyle(
                    fontSize: 12,
                    color: Colors.grey,
                    fontWeight: FontWeight.w500),
              ),
            ):Padding(
           padding: const EdgeInsets.symmetric(vertical: 8.0),
           child: Text(
             "SEARCH RESULT",
             style: TextStyle(
                 fontSize: 12,
                 wordSpacing: 2,
                 letterSpacing: 2,
                 color: Colors.grey,
                 fontWeight: FontWeight.w500),
           ),
         ),

            visibility==false? ListTile(
              // leading:
              title: Row(
                children: [
            Icon(Icons.home, color: Colors.grey,size: 18,),
                  Text(
                    "Home",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                ],
              ),
              subtitle: Text(
                "B86, Raghuwar Marriage Lawn, Mayur Vihar, Chandanapur, Indira Nagar, Lucknow, Uttar Pradesh...",
                style: TextStyle(color: Colors.grey),
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              trailing: Padding(
                padding: const EdgeInsets.only(bottom: 38.0),
                child: Icon(Icons.more_vert),
              ),
            ):Container(),
            if (isLoading)
              const Padding(
                padding: EdgeInsets.symmetric(vertical: 10),
                child: CircularProgressIndicator(),
              ),
            Expanded(
              child: ListView.builder(
                itemCount: suggestions.length,
                itemBuilder: (context, index) {
                  final suggestion = suggestions[index];
                  return ListTile(
                    onTap: () {
                      if (suggestion['place_id'] != null) {
                        fetchPlaceDetailsForSuggestion(suggestion['place_id']).then((details,) {
                          // elementList.setDistrict(details['district']);
                          setState(() {
                            selectedLocation =
                            "${suggestion['description']} (${details['district']}, ${details['pincode']})";
                          });
                          Navigator.push(context, MaterialPageRoute(builder: (context)=>LocationPickerScreen(lat:suggestion['latitude'],long:suggestion['longitude'],type:widget.type)));
                          // Navigator.pop(context);
                        }).catchError((e) {
                          ScaffoldMessenger.of(context).showSnackBar(
                            SnackBar(content: Text('Error fetching details: $e')),
                          );
                        });
                      } else {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(content: Text('Place ID not available')),
                        );
                      }
                    },
                   title:  Row(
                     children: [
                       Icon(LucideIcons.navigation,size: 18,),
                       Text(
                          suggestion['description'].toString().split(',')[0], // First part before comma
                          style: const TextStyle(
                            fontFamily: "nunito",
                            fontWeight: FontWeight.w600,
                              fontSize: 14
                          ),
                        ),
                     ],
                   ),
                    subtitle: Text(
                     "${ suggestion['description'].toString().contains(',') ? suggestion['description'].toString().substring(suggestion['description'].toString().indexOf(',') + 1).trim() : ''}, lat-${suggestion['latitude']},long-${suggestion['longitude']}", // Rest of the text after comma
                      style: const TextStyle(
                        // fontFamily: "nunito",
                        fontWeight: FontWeight.w400,
                        color: Colors.grey,

                      ),
                    ),
                  );

                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
