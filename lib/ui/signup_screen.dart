import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/model/city_model.dart';
import 'package:grabto/model/user_model.dart';
import 'package:grabto/services/api_services.dart';
import 'package:grabto/ui/otp_screen.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:grabto/widget/date_picker.dart';
import 'package:grabto/widget/item_list_dialog.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';

import '../helper/location_provider.dart';
import '../theme/theme.dart';
import 'package:flutter/services.dart';
import 'package:http/http.dart' as http;
import '../widget/filter_date-formate.dart';

class SignupScreen extends StatefulWidget {
  final String mobile;

  const SignupScreen({super.key, required this.mobile});

  @override
  State<SignupScreen> createState() => _SignupScreenState();
}

class _SignupScreenState extends State<SignupScreen> {
  TextEditingController nameController = TextEditingController();
  TextEditingController mobileController = TextEditingController();
  TextEditingController cityController = TextEditingController();
  TextEditingController dobCont = TextEditingController();
  DateTime selectedDate = DateTime.now();
  DateTime? _selectedDate;
  List<CityModel> cityList = [];
  int cityId = 0;

  // Future<void> _selectDate(BuildContext context) async {
  //   final DateTime? picked = await showDatePicker(
  //     context: context,
  //     initialDate: DateTime.now(),
  //     // Initial date when the picker opens
  //     firstDate: DateTime(1900),
  //     // Earliest selectable date
  //     lastDate: DateTime.now(),
  //     // Latest selectable date
  //
  //     builder: (BuildContext context, Widget? child) {
  //       return Theme(
  //         data: Theme.of(context).copyWith(
  //           dialogBackgroundColor: Colors.black,
  //           textTheme: const TextTheme(
  //             displayMedium:
  //                 TextStyle(color: Colors.black), // Change text color here
  //           ),
  //           colorScheme: const ColorScheme.light(
  //             primary: MyColors.primaryColor, // Change header color here
  //             onPrimary: Colors.white, // Change header text color here
  //             onSurface: Colors.black, // Change body text color here
  //           ),
  //         ),
  //         child: child!,
  //       );
  //     },
  //   );
  //
  //   /* textTheme: TextTheme(
  //             bodyText2:
  //                 TextStyle(color: Colors.black), // Change text color here
  //           ),*/
  //
  //   if (picked != null && picked != _selectedDate) {
  //     setState(() {
  //       _selectedDate = picked;
  //       print("date: $_selectedDate");
  //       // _dobController.text =
  //       //     "${_selectedDate!.day}/${_selectedDate!.month}/${_selectedDate!.year}";
  //     });
  //   }
  // }

  bool isLoading = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    mobileController.text = widget.mobile;
    fetchCity();
  }

  void _showCityDialog() async {
    final CityModel? selectedCity = await showDialog<CityModel>(
      context: context,
      builder: (BuildContext context) {
        return ItemListDialog(items: cityList);
      },
    );

    if (selectedCity != null) {
      setState(() {
        cityId = selectedCity.id;
        cityController.text = selectedCity.city;
      });
    }
  }

  bool showSelectedDate = false;
  void _handleDateSelected(DateTime date) {
    setState(() {
      selectedDate = date;
      dobCont.text = formattedDate();
      showSelectedDate = true;
    });
  }

  String formattedDate() {
    final String year = selectedDate.year.toString();
    final String month = selectedDate.month.toString().padLeft(2, '0');
    final String day = selectedDate.day.toString().padLeft(2, '0');
    return '$year-$month-$day';
  }

  // DateTime? _selectedDate;
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          SingleChildScrollView(
            child: Container(
              color: MyColors.backgroundBg,
              height: MediaQuery.of(context).size.height,
              child: Stack(
                children: [
                  Positioned(
                    top: 80,
                    left: 20,
                    child: Container(
                        margin: const EdgeInsets.symmetric(horizontal: 30),
                        height: 200,
                        constraints: const BoxConstraints(maxHeight: 260),
                        child: Image.asset('assets/vector/sign_up_img.png')),
                  ),
                  Container(
                    //margin: EdgeInsets.only(bottom: 15),
                    child: Align(
                      alignment: Alignment.bottomCenter,
                      child: Container(
                        height: 470,
                        width: MediaQuery.of(context).size.width,
                        decoration: const BoxDecoration(
                          color: MyColors.roundBg,
                          borderRadius: BorderRadius.only(
                              topLeft: Radius.circular(
                                  80)), // Adjust the radius to make it more or less rounded
                        ),
                        child: Container(
                          margin: const EdgeInsets.symmetric(
                              horizontal: 25, vertical: 20),
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 20,
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Sign Up",
                                    style: TextStyle(
                                        fontSize: 25,
                                        fontWeight: FontWeight.bold,
                                        color: MyColors.whiteBG),
                                  ),
                                ],
                              ),
                              const Row(
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  Text(
                                    "Create your account",
                                    style: TextStyle(
                                        fontSize: 15,
                                        fontWeight: FontWeight.normal,
                                        color: MyColors.whiteBG),
                                  ),
                                ],
                              ),
                              const SizedBox(
                                height: 20,
                              ),
                              Container(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.end,
                                  children: [
                                    Container(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.end,
                                        children: [
                                          Container(
                                            height: 50,
                                            child: TextField(
                                              controller: nameController,
                                              enabled: true,
                                              cursorColor: Colors.white,
                                              minLines: 1,
                                              style: const TextStyle(
                                                  color: MyColors.whiteBG),
                                              decoration: InputDecoration(
                                                hintText: 'Name',
                                                hintStyle: const TextStyle(
                                                    color: Color(0xFFDDDDDD)),
                                                prefixIcon: const Icon(
                                                    Icons.person_outline,
                                                    color: MyColors.whiteBG),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  gapPadding: 0,
                                                  borderSide: const BorderSide(
                                                      color: MyColors
                                                          .primaryColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: MyColors.whiteBG),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          Container(
                                            height: 50,
                                            child: TextField(
                                              controller: mobileController,
                                              enabled: true,
                                              cursorColor: Colors.white,
                                              keyboardType:
                                                  TextInputType.number,
                                              //maxLength: 10,
                                              minLines: 1,
                                              style: const TextStyle(
                                                  color: MyColors.whiteBG),
                                              decoration: InputDecoration(
                                                hintText: 'Mobile Number',
                                                hintStyle: const TextStyle(
                                                    color: Color(0xFFDDDDDD)),
                                                prefixIcon: const Icon(
                                                    Icons.mobile_friendly,
                                                    color: MyColors.whiteBG),
                                                enabledBorder:
                                                    OutlineInputBorder(
                                                  gapPadding: 0,
                                                  borderSide: const BorderSide(
                                                      color: MyColors
                                                          .primaryColor),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                                focusedBorder:
                                                    OutlineInputBorder(
                                                  borderSide: const BorderSide(
                                                      color: MyColors.whiteBG),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          50.0),
                                                ),
                                              ),
                                            ),
                                          ),
                                          const SizedBox(
                                            height: 10,
                                          ),
                                          // Container(
                                          //   height: 55,
                                          //   child: TextField(
                                          //     controller: cityController,
                                          //     enabled: true,
                                          //     cursorColor: Colors.white,
                                          //     keyboardType: TextInputType.text,
                                          //     //maxLength: 10,
                                          //     minLines: 1,
                                          //     style: TextStyle(
                                          //         color: MyColors.whiteBG),
                                          //     decoration: InputDecoration(
                                          //       hintText: 'City',
                                          //       hintStyle: TextStyle(
                                          //           color: Color(0xFFDDDDDD)),
                                          //       prefixIcon: Icon(
                                          //           Icons.mobile_friendly,
                                          //           color: MyColors.whiteBG),
                                          //       enabledBorder:
                                          //           OutlineInputBorder(
                                          //         gapPadding: 0,
                                          //         borderSide: BorderSide(
                                          //             color: MyColors
                                          //                 .primaryColor),
                                          //         borderRadius:
                                          //             BorderRadius.circular(
                                          //                 50.0),
                                          //       ),
                                          //       focusedBorder:
                                          //           OutlineInputBorder(
                                          //         borderSide: BorderSide(
                                          //             color: MyColors.whiteBG),
                                          //         borderRadius:
                                          //             BorderRadius.circular(
                                          //                 50.0),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          // DobWidget(
                                          //   controller: dobCont,
                                          //   initialDate: selectedDate,
                                          //   onDateSelected: _handleDateSelected,
                                          // ),
                                          Container(
                                            margin: EdgeInsets.only(top: 10),
                                            padding: EdgeInsets.only(left: 8),
                                            decoration: BoxDecoration(
                                                border: Border.all(
                                                    color:
                                                        MyColors.primaryColor),
                                                borderRadius:
                                                    BorderRadius.circular(20)),
                                            child: Row(
                                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                              children: [
                                                Text(
                                                    _selectedDate==null?'DOB': '${_selectedDate!.day}-${_selectedDate!.month}-${_selectedDate!.year}',style: TextStyle(color: Colors.white),),
                                                FilterDateFormat(
                                                  onDateSelected:
                                                      (DateTime selectedDate) {
                                                    setState(() {
                                                      _selectedDate = selectedDate;
                                                    });
                                                  },
                                                ),
                                              ],
                                            ),
                                          ),
                                          // Container(
                                          //   height: 55,
                                          //   child: TextField(
                                          //     controller: mobileController,
                                          //     enabled: true,
                                          //     cursorColor: Colors.white,
                                          //     keyboardType:
                                          //     TextInputType.number,
                                          //     //maxLength: 10,
                                          //     minLines: 1,
                                          //     style: const TextStyle(
                                          //         color: MyColors.whiteBG),
                                          //     decoration: InputDecoration(
                                          //       hintText: 'Date Of Birth',
                                          //       hintStyle: const TextStyle(
                                          //           color: Color(0xFFDDDDDD)),
                                          //       prefixIcon: const Icon(
                                          //           Icons.cal,
                                          //           color: MyColors.whiteBG),
                                          //       enabledBorder:
                                          //       OutlineInputBorder(
                                          //         gapPadding: 0,
                                          //         borderSide: const BorderSide(
                                          //             color: MyColors
                                          //                 .primaryColor),
                                          //         borderRadius:
                                          //         BorderRadius.circular(
                                          //             50.0),
                                          //       ),
                                          //       focusedBorder:
                                          //       OutlineInputBorder(
                                          //         borderSide: const BorderSide(
                                          //             color: MyColors.whiteBG),
                                          //         borderRadius:
                                          //         BorderRadius.circular(
                                          //             50.0),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          const SizedBox(
                                            height: 17,
                                          ),
                                          GestureDetector(
                                            onTap: _showCityDialog,
                                            child: AbsorbPointer(
                                              child: Container(
                                                height: 55,
                                                child: TextField(
                                                  controller: cityController,
                                                  enabled: true,
                                                  cursorColor: Colors.white,
                                                  keyboardType:
                                                      TextInputType.text,
                                                  minLines: 1,
                                                  style: const TextStyle(
                                                      color: MyColors.whiteBG),
                                                  decoration: InputDecoration(
                                                    hintText: 'City',
                                                    hintStyle: const TextStyle(
                                                        color:
                                                            Color(0xFFDDDDDD)),
                                                    prefixIcon: const Icon(
                                                        Icons.location_city,
                                                        color:
                                                            MyColors.whiteBG),
                                                    enabledBorder:
                                                        OutlineInputBorder(
                                                      gapPadding: 0,
                                                      borderSide:
                                                          const BorderSide(
                                                              color: MyColors
                                                                  .primaryColor),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                    focusedBorder:
                                                        OutlineInputBorder(
                                                      borderSide:
                                                          const BorderSide(
                                                              color: MyColors
                                                                  .whiteBG),
                                                      borderRadius:
                                                          BorderRadius.circular(
                                                              50.0),
                                                    ),
                                                  ),
                                                ),
                                              ),
                                            ),
                                          ),

                                          const SizedBox(
                                            height: 17,
                                          ),
                                          // Container(
                                          //   height: 55,
                                          //   child: TextField(
                                          //     controller: _dobController,
                                          //     //readOnly: true, // Make TextField readonly
                                          //     // onTap: () {
                                          //     //   _selectDate(context); // Open date picker when tapping on TextField
                                          //     //
                                          //     // },
                                          //     cursorColor: Colors.white,
                                          //     keyboardType:
                                          //         TextInputType.datetime,
                                          //     minLines: 1,
                                          //     inputFormatters: [
                                          //       DateInputFormatter()
                                          //     ],
                                          //     style: TextStyle(
                                          //         color: Colors.white),
                                          //     decoration: InputDecoration(
                                          //       hintText: 'DOB',
                                          //       hintStyle: TextStyle(
                                          //           color: Color(0xFFDDDDDD)),
                                          //       prefixIcon: Icon(
                                          //           Icons.calendar_today,
                                          //           color: Colors.white),
                                          //       enabledBorder:
                                          //           OutlineInputBorder(
                                          //         gapPadding: 0,
                                          //         borderSide: BorderSide(
                                          //             color: MyColors
                                          //                 .primaryColor),
                                          //         borderRadius:
                                          //             BorderRadius.circular(
                                          //                 50.0),
                                          //       ),
                                          //       focusedBorder:
                                          //           OutlineInputBorder(
                                          //         borderSide: BorderSide(
                                          //             color: MyColors.whiteBG),
                                          //         borderRadius:
                                          //             BorderRadius.circular(
                                          //                 50.0),
                                          //       ),
                                          //     ),
                                          //   ),
                                          // ),
                                          // SizedBox(
                                          //   height: 17,
                                          // ),
                                          ElevatedButton(
                                            onPressed: () async {
                                              if (_selectedDate==null) {
                                                showErrorMessage(context, message: 'Please fill Date of birth');
                                                return;
                                              }
                                              final name = nameController.text;
                                              final mobile = mobileController.text;
                                              final city = "$cityId";
                                              final dob =  DateFormat('dd-MM-yyy').format(DateTime.parse(_selectedDate.toString()??""));
                                              // final dob = dobCont.text;

                                              String token =
                                                  await SharedPref.getToken();
                                              print("llll:${_selectedDate}");
                                              // user_signup(
                                              //     name, mobile, city,dob);
                                              Navigator.push(
                                                  context,
                                                  MaterialPageRoute(
                                                      builder: (context) => OtpScreen(
                                                        name:name,
                                                        mobile: mobile,
                                                        dob:dob,
                                                        city:city,
                                                        type:"2"
                                                      )));
                                            },
                                            child: const Text(
                                              "Sign Up",
                                              style: TextStyle(
                                                  fontSize: 17,
                                                  color: Colors.white),
                                            ),
                                            style: ButtonStyle(
                                              backgroundColor:
                                                  MaterialStateProperty.all<
                                                          Color>(
                                                      MyColors.btnBgColor),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              )
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          // Show a loading indicator if _isLoading is true
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
              child: const Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    MyColors.primaryColor,
                  ),
                  // Change the color
                  strokeWidth: 4,
                ),
              ),
            ),
        ],
      ),
    );
  }

  Future<void> user_signup(
      String name, String mobile, String city, String dob) async {
    print(dob);
    print("dob");
    if (name.isEmpty) {
      showErrorMessage(context, message: 'Please fill name');
      return;
    } else if (mobile.isEmpty) {
      showErrorMessage(context, message: 'Please fill mobile number');
      return;
    } else if (mobile.length != 10) {
      showErrorMessage(context,
          message: 'Please fill only 10 digit mobile number');
      return;
    } else if (dob==null) {
      showErrorMessage(context, message: 'Please fill Date of birth');
      return;
    } else if (city == "0") {
      showErrorMessage(context, message: 'Please fill city');
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      final body = {
        "name": name,
        "mobile": mobile,
        "current_location": city,
        "dob": dob,
      };
      final response = await ApiServices.user_signup(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          //print('user_signup data: $data');
          final user = UserModel.fromMap(data);

          if (user != null) {
            Navigator.push(
                context,
                MaterialPageRoute(
                    builder: (context) => OtpScreen(
                      mobile: mobile,
                    )));
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
      //print('user_signup error: $e');
      // Handle error
      showErrorMessage(context, message: 'An error occurred: $e');
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  late LatLng _currentLocation;
  GoogleMapController? _mapController;
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
  static const String googleApiKey = "AIzaSyCOqfJTgg1Blp1GIeh7o8W8PC1w5dDyhWI";
  Future<void> _getAddressFromLatLng(double lat, double lng) async {
    final address=Provider.of<Address>(context,listen: false);
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
        address.setArea(formattedAddress);
        address.setAddress(longName2);

      } else {
        setState(() {
        });
      }
    } catch (e) {
      print("Error fetching address: $e");
      setState(() {
      });
    }
  }
  @override
  void dispose() {
    // _dobController.dispose();
    super.dispose();
  }

  Future<void> fetchCity() async {
    try {
      final response = await ApiServices.api_show_city(context);
      print('fetchCity:response  $response');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'] as List<dynamic>;

        cityList = data.map((e) {
          return CityModel.fromMap(e);
        }).toList();
      } else if (response != null) {
        String msg = response['msg'];

        // Handle unsuccessful response or missing 'res' field
        showErrorMessage(context, message: msg);
      }
    } catch (e) {
      print('fetchCity: $e');
    }
  }
}

class DateInputFormatter extends TextInputFormatter {
  @override
  TextEditingValue formatEditUpdate(
      TextEditingValue oldValue, TextEditingValue newValue) {
    String newText =
        newValue.text.replaceAll('/', ''); // Remove existing slashes

    // Limit the length of input to 8 characters (DDMMYYYY)
    if (newText.length > 8) {
      newText = newText.substring(0, 8);
    }

    if (newValue.selection.baseOffset == 0) {
      return newValue;
    }

    StringBuffer buffer = StringBuffer();
    int selectionIndex = newText.length;

    for (int i = 0; i < newText.length; i++) {
      buffer.write(newText[i]);
      if (i == 1 || i == 3) {
        buffer.write('/');
        if (i < selectionIndex) {
          selectionIndex++;
        }
      }
    }

    String formattedText = buffer.toString();
    if (formattedText.length > 10) {
      formattedText = formattedText.substring(0, 10);
    }

    return TextEditingValue(
      text: formattedText,
      selection: TextSelection.collapsed(
          offset: selectionIndex > 10 ? 10 : selectionIndex),
    );
  }
}
