
import 'package:grabto/main.dart';
import 'package:grabto/model/user_model.dart';
import 'package:grabto/ui/otp_screen.dart';
import 'package:grabto/ui/signup_screen.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import '../services/api_services.dart';
import '../theme/theme.dart';


class LoginScreen extends StatefulWidget {

  @override
  State<LoginScreen> createState() => _LoginScreenState();
}

class _LoginScreenState extends State<LoginScreen> {
  TextEditingController mobileControllerLogin = TextEditingController();

  bool isLoading = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: true,
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: MyColors.whiteBG,
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back,color:MyColors.textColor,size: 20,)),
        elevation: 0,
      ),
      body: LayoutBuilder(
        builder: (context, constraints) {
          return SingleChildScrollView(
            padding: const EdgeInsets.symmetric(horizontal: 24),
            child: ConstrainedBox(
              constraints: BoxConstraints(minHeight: constraints.maxHeight),
              child: IntrinsicHeight(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const SizedBox(height: 32),

                    // Heading
                    const Center(
                      child: Text(
                        'Login to your account',
                        style: TextStyle(
                          fontSize: 20,
                          fontWeight: FontWeight.w500,
                        ),
                      ),
                    ),
                    const SizedBox(height: 8),

                    // Subtitle
                    const Center(
                      child: Text(
                        'A code will be sent to your mobile after\nyou select send.',
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          color: MyColors.textColorTwo,
                          fontSize: 12,
                        ),
                      ),
                    ),
                    const SizedBox(height: 40),

                    // Mobile Number Field
                    TextField(
                      controller: mobileControllerLogin,
                      keyboardType: TextInputType.phone,
                      maxLength: 10,
                      decoration: InputDecoration(
                        counter: const Offstage(),
                        hintText: 'Enter mobile number',
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                        contentPadding: const EdgeInsets.symmetric(horizontal: 16),
                      ),
                    ),
                    const SizedBox(height: 24),

                    // Send Code Button
                    SizedBox(
                      width: double.infinity,
                      height: 43,
                      child: ElevatedButton(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: MyColors.redBG,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: () {
                          final mobile = mobileControllerLogin.text;
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => OtpScreen(mobile: mobile),
                            ),
                          );
                        },
                        child: const Text(
                          'Send Code',
                          style: TextStyle(fontSize: 16, color: MyColors.whiteBG),
                        ),
                      ),
                    ), // replaces Spacer
Spacer(),
                    Center(
                      child: Image.asset(
                        'assets/images/login_img.png',
                        height: heights * 0.35,
                        width: widths * 0.95,
                        fit: BoxFit.fill,
                      ),
                    ),
                    // const SizedBox(height: 16),
                  ],
                ),
              ),
            ),
          );
        },
      ),
    );

  }

  // Future<void> user_login(String mobile) async {
  //   if (mobile.isEmpty) {
  //     showErrorMessage(context, message: 'Please fill mobile number');
  //     return;
  //   } else if (mobile.length != 10) {
  //     showErrorMessage(context,
  //         message: 'Please fill only 10 digit mobile number');
  //     return;
  //   }
  //
  //   try {
  //     setState(() {
  //       isLoading = true;
  //     });
  //     final body = {"mobile": mobile};
  //     print(body);
  //     final response = await ApiServices.apiUserLogin(context, body);
  //
  //     // Check if the response is null or doesn't contain the expected data
  //     if (response != null && response.containsKey('res') &&
  //         response['res'] == 'success') {
  //       final data = response['data'];
  //       if (data != null && data is Map<String, dynamic>) {
  //         print('user_login data: $data');
  //         final user = UserModel.fromMap(data);
  //
  //         if (user != null) {
  //           Navigator.push(context,
  //               MaterialPageRoute(builder: (context) => OtpScreen(mobile: mobile,)));
  //         } else {
  //           // Handle null user
  //           showErrorMessage(context, message: 'User data is invalid');
  //         }
  //       } else {
  //         // Handle invalid response data format
  //         showErrorMessage(context, message: 'Invalid response data format');
  //       }
  //     } else if (response != null) {
  //       String msg = response['msg'];
  //       showErrorMessage(context, message: 'Mobile no. is not registered.');
  //       showErrorMessage(context, message: msg);
  //       print("Aman");
  //       Navigator.push(context,
  //           MaterialPageRoute(builder: (context) => SignupScreen(mobile:mobile)));
  //       // Handle unsuccessful response or missing 'res' field
  //
  //     }
  //   }
  //   catch (e) {
  //     print('user_login error: $e');
  //     // Handle error
  //     showErrorMessage(context, message: 'An r occurred: $e');
  //   } finally {
  //     setState(() {
  //       isLoading = false;
  //     });
  //   }
  // }

}
