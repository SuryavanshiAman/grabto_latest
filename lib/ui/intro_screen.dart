import 'package:grabto/helper/shared_pref.dart';
import 'package:grabto/main.dart';
import 'package:grabto/model/city_model.dart';
import 'package:grabto/services/api.dart';
import 'package:grabto/services/api_services.dart';
import 'package:grabto/ui/home_screen.dart';
import 'package:grabto/ui/login_screen.dart';
import 'package:grabto/ui/signup_screen.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';

import '../theme/theme.dart';

class IntroScreen extends StatefulWidget {

  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  @override
  Widget build(BuildContext context) {
    return
      Scaffold(
      backgroundColor: Colors.white,
      body: Stack(
        children: [
          Positioned.fill(
            child: Image.asset(
              'assets/images/intro_screen.png',
              fit: BoxFit.cover,
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 24.0, ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(height: heights*0.06,),
                const Text(
                  'Discover.\nDine.\nShare.',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 38,
                    fontWeight: FontWeight.bold,
                    height: 1.2,
                  ),
                ),
                const SizedBox(height: 12),
                const Text(
                  'Your foodie journey starts here.',
                  style: TextStyle(
                    color: Colors.white70,
                    fontSize: 16,
                  ),
                ),
                const Spacer(),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    style: ElevatedButton.styleFrom(
                      backgroundColor: MyColors.redBG,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                    ),
                    onPressed: () {
                      Navigator.push(
                        context,
                        MaterialPageRoute(
                          builder: (context) =>
                              LoginScreen(),
                        ),
                      );
                    },
                    child: const Text('Get Started',style:TextStyle(color: MyColors.whiteBG),),
                  ),
                ),
                const SizedBox(height: 12),
                // Login as Guest
                Center(
                  child: TextButton(
                    onPressed: () {
                      guestUserLogin();
                    },
                    child: const Text(
                      'Login as guest',
                      style: TextStyle(color: Colors.white70),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),

      // SingleChildScrollView(
      //   child: Container(
      //     color: MyColors.primaryColor,
      //     height: MediaQuery.of(context).size.height,
      //     child: Column(
      //     mainAxisAlignment: MainAxisAlignment.end,
      //       children: [
      //         Container(
      //           height: 200,
      //           constraints: const BoxConstraints(maxHeight: 260),
      //           child:
      //               Image.asset('assets/images/grabto_logo_without_text.png'),
      //         ),
      //         Container(
      //           margin: EdgeInsets.only(top: heights*0.15),
      //           height: 350,
      //           width: MediaQuery.of(context).size.width,
      //           decoration: BoxDecoration(
      //             color: MyColors.roundBg,
      //             borderRadius: BorderRadius.only(
      //               topLeft: Radius.circular(80),
      //             ),
      //           ),
      //           child: Padding(
      //             padding: const EdgeInsets.symmetric(horizontal: 20.0),
      //             child: Column(
      //               mainAxisAlignment: MainAxisAlignment.center,
      //               children: [
      //                 // SizedBox(hei/ght: 40),
      //                 Text(
      //                   "Welcome",
      //                   style: TextStyle(
      //                     fontSize: 35,
      //                     fontWeight: FontWeight.bold,
      //                     color: MyColors.whiteBG,
      //                   ),
      //                 ),
      //                 Text(
      //                   "Deals that make your wallet smile!",
      //                   style: TextStyle(
      //                     fontSize: 15,
      //                     fontWeight: FontWeight.normal,
      //                     color: MyColors.whiteBG,
      //                   ),
      //                 ),
      //                 // SizedBox(height: 40),
      //                 // Container(
      //                 //   width: MediaQuery.of(context).size.width - 50,
      //                 //   height: 45,
      //                 //   child: ElevatedButton(
      //                 //     onPressed: () {
      //                 //       Navigator.push(
      //                 //         context,
      //                 //         MaterialPageRoute(builder: (context) {
      //                 //           return SignupScreen();
      //                 //         }),
      //                 //       );
      //                 //     },
      //                 //     child: Text(
      //                 //       "Sign Up",
      //                 //       style: TextStyle(
      //                 //         fontSize: 16,
      //                 //         color: MyColors.btnTextColor,
      //                 //       ),
      //                 //     ),
      //                 //     style: ButtonStyle(
      //                 //       backgroundColor: MaterialStateProperty.all<Color>(
      //                 //         MyColors.btnBgColor,
      //                 //       ),
      //                 //     ),
      //                 //   ),
      //                 // ),
      //                 SizedBox(height: 25),
      //                 Container(
      //                   width: MediaQuery.of(context).size.width - 50,
      //                   height: 45,
      //                   child: ElevatedButton(
      //                     onPressed: () {
      //                       Navigator.push(
      //                         context,
      //                         MaterialPageRoute(
      //                           builder: (context) =>
      //                               LoginScreen(),
      //                         ),
      //                       );
      //                     },
      //                     child: Text(
      //                       "Login",
      //                       style: TextStyle(
      //                         fontSize: 16,
      //                         color: MyColors.btnTextColor,
      //                       ),
      //                     ),
      //                     style: ButtonStyle(
      //                       backgroundColor: MaterialStateProperty.all<Color>(
      //                         MyColors.btnBgColor,
      //                       ),
      //                     ),
      //                   ),
      //                 ),
      //                 SizedBox(height: 25),
      //                 InkWell(
      //                   onTap: () {
      //                     guestUserLogin();
      //                   },
      //                   child: Text(
      //                     "Login as a Guest",
      //                     style: TextStyle(
      //                         color: Colors.white,
      //                         fontSize: 16,
      //                         fontWeight: FontWeight.bold),
      //                   ),
      //                 ),
      //                 SizedBox(height: 15),
      //               ],
      //             ),
      //           ),
      //         ),
      //       ],
      //     ),
      //   ),
      // ),
    );
  }

  Future<void> guestUserLogin() async {
    await SharedPref.userLogin({
      SharedPref.KEY_ID: 0,
      SharedPref.KEY_CURRENT_MONTH: "",
      SharedPref.KEY_PREMIUM: "",
      SharedPref.KEY_STATUS: "",
      SharedPref.KEY_NAME: UserName,
      SharedPref.KEY_EMAIL: UserEmail,
      SharedPref.KEY_MOBILE: "",
      SharedPref.KEY_DOB: "",
      SharedPref.KEY_OTP: "",
      SharedPref.KEY_IMAGE: image,
      SharedPref.KEY_HOME_LOCATION: "",
      SharedPref.KEY_CURRENT_LOCATION: "",
      SharedPref.KEY_LAT: "",
      SharedPref.KEY_LONG: "",
      SharedPref.KEY_CREATED_AT: "",
      SharedPref.KEY_UPDATED_AT: "",
    });

    await fetchCity();

    await Navigator.push(
        context,
        MaterialPageRoute(
            builder: (context) => HomeScreen()));
  }

  Future<void> fetchCity() async {
    try {
      final response = await ApiServices.api_show_city(context);
      print('fetchCity:response  $response');
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'] as List<dynamic>;

        List<CityModel> cityList = data.map((e) {
          return CityModel.fromMap(e);
        }).toList();

        // setState(() {
        if (cityList.isNotEmpty) {
          print('fetchCity:response ture ${cityList[0].city}');
          SharedPref.updateHomeLocation("${cityList[0].id}");
          SharedPref.updateCurrentLocation("${cityList[0].city}");
        } else {
          print('fetchCity:response false');
        }
        // });
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
