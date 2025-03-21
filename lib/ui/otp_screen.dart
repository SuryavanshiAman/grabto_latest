import 'dart:async';
import 'dart:convert';

import 'package:geolocator/geolocator.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:grabto/helper/location_provider.dart';
import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/main.dart';
import 'package:grabto/model/user_model.dart';
import 'package:grabto/services/api_services.dart';
import 'package:grabto/ui/home_screen.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:grabto/widget/pinput/pinput.dart';
import 'package:provider/provider.dart';
import 'package:http/http.dart' as http;
// import 'package:numeric_keyboard/numeric_keyboard.dart';

import '../theme/theme.dart';

class OtpScreen extends StatefulWidget {
  String mobile;

  OtpScreen({required this.mobile});

  @override
  State<OtpScreen> createState() => _OtpScreenState();
}

class _OtpScreenState extends State<OtpScreen> {
  bool isLoading = false;
  String text = '';

  void _onKeyboardTap(String value) {
    setState(() {
      text = text + value;
    });
  }

  Widget otpNumberWidget(int position) {
    try {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: MyColors.primaryColor, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
        child: Center(
            child: Text(
          text[position],
          style: TextStyle(color: Colors.black, fontSize: 20),
        )),
      );
    } catch (e) {
      return Container(
        height: 40,
        width: 40,
        decoration: BoxDecoration(
            border: Border.all(color: MyColors.txtDescColor2, width: 1),
            borderRadius: const BorderRadius.all(Radius.circular(8))),
      );
    }
  }
  final TextEditingController otpCon = TextEditingController();
  int _seconds = 60;
  Timer? _timer;
  bool resendOtp=false;
@override
  void initState() {
    // TODO: implement initState
    super.initState();
    startTimer();
  }
  void startTimer() {
    _timer = Timer.periodic(Duration(seconds: 1), (timer) {
      if (_seconds > 0) {
        setState(() {
          _seconds--;
        });
      } else {
        setState(() {
          resendOtp=true;
        });
        _timer?.cancel();
      }
    });
  }

  @override
  void dispose() {
    _timer?.cancel(); // Dispose the timer when the widget is removed
    super.dispose();
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.all(Radius.circular(20)),
              color: MyColors.blackBG,
            ),
            child: Icon(
              Icons.arrow_back_ios,
              color: Colors.white,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.of(context).pop(),
        ),
        elevation: 0,
        backgroundColor: Colors.white,
      ),
      body: Stack(
        children: [
          ListView(
            shrinkWrap: true,
            // mainAxisSize: MainAxisSize.max,
            children: <Widget>[
              Container(
                  margin: EdgeInsets.symmetric(horizontal: 30),
                  height: 250,
                  constraints: const BoxConstraints(maxHeight: 260),
                  child: Image.asset('assets/vector/otp_img.png')),
              Center(
                child: Text('Enter verification code',
                    style: TextStyle(
                        color: MyColors.txtTitleColor,
                        fontSize: 20,
                        fontWeight: FontWeight.w500)),
              ),
              Text(
                  'Enter the 4 digit number that \n we sent to ${widget.mobile}',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      color: MyColors.txtDescColor,
                      fontSize: 15,
                      fontWeight: FontWeight.w500)),
              SizedBox(
                height: 10,
              ),
              Pinput(
                controller: otpCon,
                length: 4,
                defaultPinTheme: PinTheme(
                  width: widths * 0.15,
                  height: heights * 0.07,
                  textStyle: TextStyle(fontSize: 20, color: MyColors.textColor),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: Colors.grey,
                      width: 2,
                    ),
                  ),
                ),
                focusedPinTheme: PinTheme(
                  width: widths * 0.15,
                  height: heights * 0.07,
                  textStyle:
                  const TextStyle(fontSize: 20, color: MyColors.textColor),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(15),
                    border: Border.all(
                      color: MyColors.primaryColor,
                      width: 2,
                    ),
                  ),
                ),
              ),
              SizedBox(
                height: 30,
              ),

              Container(
                width: MediaQuery.of(context).size.width,
                margin: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                child: ElevatedButton(
                  onPressed: () {

                    resendOtp==false? verify_otp(widget.mobile, otpCon.text):
                    user_login(widget.mobile);
                  },
                  child: Text(
                    resendOtp==false?  "Verify":"Resend OTP",
                    style:
                        TextStyle(fontSize: 15, color: Colors.white),
                  ),
                  style: ButtonStyle(
                    backgroundColor: MaterialStateProperty.all<Color>(
                        MyColors.btnBgColor),
                  ),
                ),
              ),
              SizedBox(
                height: 10,
              ),
              Center(
                child: Text(
                  "Resend OTP in $_seconds seconds",
                  style: TextStyle( fontWeight: FontWeight.bold),
                ),
              ),
            ],
          ),
          // Show a loading indicator if _isLoading is true
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
              child: Center(
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

  Future<void> verify_otp(String mobile, String otp) async {
    if (mobile.isEmpty) {
      showErrorMessage(context, message: 'Please fill mobile number');
      return;
    } else if (otp.length != 4) {
      showErrorMessage(context, message: 'Please fill only 4 digit otp');
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      final body = {"mobile": mobile, "otp": otp};
      final response = await ApiServices.verify_otp(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          //print('verify_otp data: $data');
          final user = UserModel.fromMap(data);

          if (user != null) {
            //print('verify_otp data: 1');

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
              SharedPref.KEY_LAT: user.lat,
              SharedPref.KEY_LONG: user.long,
              SharedPref.KEY_CREATED_AT: user.created_at,
              SharedPref.KEY_UPDATED_AT: user.updated_at,
            });

            // Pop all screens until reaching the first screen
            // Navigator.popUntil(context, (route) => route.isFirst);
            _getCurrentLocation();
            // Replace the current screen with the login screen

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
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }
  Future<void> user_login(String mobile) async {
    if (mobile.isEmpty) {
      showErrorMessage(context, message: 'Please fill mobile number');
      return;
    } else if (mobile.length != 10) {
      showErrorMessage(context,
          message: 'Please fill only 10 digit mobile number');
      return;
    }

    try {
      setState(() {
        isLoading = true;
      });
      final body = {"mobile": mobile};
      final response = await ApiServices.apiUserLogin(context, body);

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          print('user_login data: $data');
          final user = UserModel.fromMap(data);

          if (user != null) {
            Navigator.push(context,
                MaterialPageRoute(builder: (context) => OtpScreen(mobile: mobile,)));
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
        showErrorMessage(context, message: 'Mobile no. is not registered.');
        showErrorMessage(context, message: msg);
        print("Aman");
        // Navigator.push(context,
        //     MaterialPageRoute(builder: (context) => SignupScreen(mobile:mobile)));
        // Handle unsuccessful response or missing 'res' field

      }
    } catch (e) {
      print('user_login error: $e');
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
        confirmAddress(formattedAddress,lat,lng);
        print("CCCCCCCCCC:${address.area}");
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(builder: (context) => HomeScreen()),
        );
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

      // Check if the response is null or doesn't contain the expected data
      if (
      response!['error'] == false) {
        showSuccessMessage(context, message: response['message']);
        Navigator.push(context, MaterialPageRoute(builder: (context)=>HomeScreen()));

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
}
