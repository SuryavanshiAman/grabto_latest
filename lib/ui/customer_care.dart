import 'package:grabto/main.dart';
import 'package:grabto/services/api.dart';
import 'package:grabto/services/api_services.dart';
import 'package:grabto/utils/snackbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

import '../theme/theme.dart';

class CustomerCare extends StatefulWidget {
  @override
  State<CustomerCare> createState() => _CustomerCareState();
}

class _CustomerCareState extends State<CustomerCare> {
  bool isLoading = false;

  String email = '';
  String address = '';
  String mobile = '';
  String created_at = '';
  String updated_at = '';

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    website_setting();
  }

  @override
  Widget build(BuildContext context) {
    double width = MediaQuery.of(context).size.width;
    double width_90 = width * 0.95;
    double Dwidth_90 = width * 0.95;
    return Scaffold(
      backgroundColor: MyColors.backgroundBg,
      appBar: AppBar(
        backgroundColor: MyColors.backgroundBg,
        leading: InkWell(
            onTap: () {
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        // centerTitle: true,
        title: Text(
          "Support",
          style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
        ),
      ),
      body:
      // Padding(
      //   padding: const EdgeInsets.all(20),
      //   child: Column(
      //     crossAxisAlignment: CrossAxisAlignment.center,
      //     children: [
      //       const SizedBox(height: 30),
      //
      //       // Illustration
      //       Image.asset(
      //         'assets/images/support.png', // replace with your image
      //         height: 200,
      //       ),
      //
      //       const SizedBox(height: 16),
      //       const Text(
      //         "Our customer support team is ready to make sure you have the best service.",
      //         textAlign: TextAlign.center,
      //         style: TextStyle(fontSize: 12,color: MyColors.textColorTwo),
      //       ),
      //       Divider(color: MyColors.textColorTwo.withAlpha(10)),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //         children: [
      //           SupportActionButton(
      //             icon: Icons.email_outlined,
      //             label: 'Send Email',
      //             onTap: ()   {
      //               _sendEmail( email);
      //             },
      //           ),
      //           SupportActionButton(
      //             icon: Icons.call_outlined,
      //             label: 'Call Us',
      //             onTap: () {
      //               _makePhoneCall(mobile);
      //             },
      //           ),
      //         ],
      //       ),
      //       Divider(color: MyColors.textColorTwo.withAlpha(10)),
      //       Row(
      //         mainAxisAlignment: MainAxisAlignment.center,
      //         children: [
      //           Icon(Icons.thumb_up_alt_outlined,size: 14,color: MyColors.redBG,),
      //           const Text(
      //             "GIVE APP FEEDBACK",
      //             style: TextStyle(
      //               color: Colors.red,
      //               fontSize: 12,
      //               fontWeight: FontWeight.w500,
      //             ),
      //           ),
      //         ],
      //       ),
      //
      //       const SizedBox(height: 30),
      //       const Align(
      //         alignment: Alignment.centerLeft,
      //         child: Text(
      //           "Help us improve",
      //           style: TextStyle(
      //             fontWeight: FontWeight.w500,
      //             color: Colors.black87,
      //           ),
      //         ),
      //       ),
      //       const SizedBox(height: 8),
      //       const Align(
      //         alignment: Alignment.centerLeft,
      //         child: Text(
      //           "Report a bug or suggest ways to make Grabto better.",style: TextStyle(fontWeight: FontWeight.w500,color: MyColors.textColorTwo),
      //         ),
      //       ),
      //       const SizedBox(height: 10),
      //
      //       Align(
      //         alignment: Alignment.centerRight,
      //         child: Container(
      //           width: widths*0.39,
      //           padding: EdgeInsets.symmetric(vertical: 5,horizontal: 20),
      //           decoration: BoxDecoration(
      //             color: MyColors.redBG,
      //               borderRadius: BorderRadius.circular(5),
      //               // border: Border.all(color: MyColors.grey.withAlpha(100))
      //           ),
      //           child: Row(
      //             children: [
      //               Text("Give Feedback ",style: TextStyle(fontSize: 12,color: MyColors.whiteBG,fontWeight: FontWeight.w500),),
      //               Icon(Icons.arrow_forward,color: MyColors.whiteBG,size: 12,)
      //             ],
      //           ),
      //         ),
      //       ),
      //
      //       const Spacer(),
      //
      //       // Social Icons
      //        Align(
      //         alignment: Alignment.centerLeft,
      //         child: Row(
      //           mainAxisAlignment: MainAxisAlignment.spaceBetween,
      //           children: [
      //             Text(
      //               "Follow us on",
      //               style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
      //             ),
      //             SizedBox(
      //               width: widths*0.4,
      //               child: Row(
      //                 mainAxisAlignment: MainAxisAlignment.spaceEvenly,
      //                 children: [
      //                   Padding(
      //                     padding: const EdgeInsets.only(top: 8.0),
      //                     child: Image.asset("assets/images/youtube.png"),
      //                   ),
      //                   Image.asset("assets/images/insta.png"),
      //                   Image.asset("assets/images/facebook.png"),
      //                   Image.asset("assets/images/linkdin.png"),
      //                   // IconButton(onPressed: () {}, icon: const Icon(Icons.play_circle_filled_outlined)),
      //                   // IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
      //                   // IconButton(onPressed: () {}, icon: const Icon(Icons.facebook_outlined)),
      //                   // IconButton(onPressed: () {}, icon: const Icon(Icons.linked_camera_outlined)),
      //                 ],
      //               ),
      //             ),
      //           ],
      //         ),
      //
      //       ),
      //       const SizedBox(height: 8),
      //
      //     ],
      //   ),
      // ),
      Stack(
        children: [
          Container(
            color: MyColors.backgroundBg,
            child: SingleChildScrollView(
              child: Column(
                children: [
                  InkWell(
                      // onTap: () {
                      //   //_sendEmail("$email");
                      //   _makePhoneCall("$mobile");
                      // },
                      child: buildContainerItem(width_90)),
                  SizedBox(
                    height: 50,
                  )
                ],
              ),
            ),
          ),
          // Show a loading indicator if _isLoading is true
          if (isLoading)
            Container(
              color: Colors.black.withOpacity(0.5), // Adjust opacity as needed
              child: Center(
                child: CircularProgressIndicator(
                  valueColor: AlwaysStoppedAnimation<Color>(
                    Colors.orange,
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

  void _sendEmail(String _email) async {
    final Uri _emailLaunchUri = Uri(
        scheme: 'mailto',
        path: '$_email',
        queryParameters: {
          'subject': '',
          'body': 'Hello,\nDiscount Deals Team'
        });

// ...

// mailto:smith@example.com?subject=Example+Subject+%26+Symbols+are+allowed%21
    launch(_emailLaunchUri.toString());
  }

  _makePhoneCall(String? phoneNumber) async {
    if (phoneNumber == null || phoneNumber.isEmpty) {
      print('Error: Phone number is null or empty');
      return;
    }
    final url = 'tel:$phoneNumber';
    print(
        'Phone number: $phoneNumber'); // Print the phone number to the console
    try {
      await launch('$url');
    } catch (e) {
      print('Error launching phone call: $e');
      // Handle the error gracefully, such as displaying an error message to the user
    }
  }

  Container buildContainerItem(double width_90) {
    return Container(
      color: Colors.white,
      alignment: Alignment.center,
      child: Column(
        children: <Widget>[
          Container(
            width: width_90,
            height: 180,
            margin: EdgeInsets.only(top: 10, bottom: 24),
            decoration: BoxDecoration(
              borderRadius: new BorderRadius.all(Radius.circular(6)),
              gradient: LinearGradient(colors: [
                Color.fromRGBO(149, 72, 176, 1),
                Color.fromRGBO(104, 133, 240, 1)
              ], begin: Alignment.bottomLeft, end: Alignment.topRight),
            ),
            child: Column(
              children: <Widget>[
                SizedBox(
                  height: 12,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Container(
                    alignment: Alignment.topLeft,
                    child: Text(
                      "INDIA",
                      style: TextStyle(color: Colors.white, fontSize: 16),
                    ),
                  ),
                ),
                SizedBox(
                  height: 20,
                ),
                Padding(
                  padding: EdgeInsets.only(left: 20),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: <Widget>[
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            "Customer Care",
                            style: TextStyle(
                                fontSize: 20.0,
                                color: Colors.white,
                                fontWeight: FontWeight.w600),
                          ),
                          SizedBox(height: 10,),
                          if(mobile.isNotEmpty)
                          InkWell(
                            onTap: () {
                              //_sendEmail("$email");
                              _makePhoneCall("$mobile");
                            },
                            child: Text(
                              "Call:- $mobile",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                          SizedBox(height: 5,),
                          if(email.isNotEmpty)
                          InkWell(
                            onTap: () {
                              //_sendEmail("$email");
                              _sendEmail("$email");
                            },
                            child: Text(
                              "Email:- $email",
                              style: TextStyle(
                                  fontSize: 18.0,
                                  color: Colors.white,
                                  fontWeight: FontWeight.w600),
                            ),
                          ),
                        ],
                      ),
                      // IconButton(
                      //   padding: new EdgeInsets.only(right: 34, bottom: 32),
                      //   icon: new Icon(
                      //     Icons.navigate_next,
                      //     size: 60.0,
                      //     color: Colors.white,
                      //   ),
                      //   onPressed: () {
                      //     //navigateToOrderPage();
                      //   },
                      // )
                    ],
                  ),
                )
              ],
            ),
          ),
        ],
      ),
    );
  }

  Future<void> website_setting() async {
    try {
      setState(() {
        isLoading = true;
      });
      final response = await ApiServices.website_setting();

      // Check if the response is null or doesn't contain the expected data
      if (response != null &&
          response.containsKey('res') &&
          response['res'] == 'success') {
        final data = response['data'];
        // Ensure that the response data is in the expected format
        if (data != null && data is Map<String, dynamic>) {
          //print('verify_otp data: $data');
          print("website: $data");

          email = data['email'] as String;
          address = data['address'] as String;
          mobile = data['mobile'] as String;
          created_at = data['created_at'] as String;
          updated_at = data['updated_at'] as String;

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
}
// import 'package:flutter/material.dart';
//
// class SupportScreen extends StatelessWidget {
//   const SupportScreen({super.key});
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: Padding(
//         padding: const EdgeInsets.all(20),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.center,
//           children: [
//             const SizedBox(height: 30),
//
//             // Illustration
//             Image.asset(
//               'assets/support_illustration.png', // replace with your image
//               height: 200,
//             ),
//
//             const SizedBox(height: 16),
//             const Text(
//               "Our customer support team is ready to make sure you have the best service.",
//               textAlign: TextAlign.center,
//               style: TextStyle(fontSize: 16),
//             ),
//
//             const SizedBox(height: 20),
//
//             // Email and Call Us
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 SupportActionButton(
//                   icon: Icons.email_outlined,
//                   label: 'Send Email',
//                   onTap: () {},
//                 ),
//                 SupportActionButton(
//                   icon: Icons.call_outlined,
//                   label: 'Call Us',
//                   onTap: () {},
//                 ),
//               ],
//             ),
//
//             const SizedBox(height: 16),
//             const Text(
//               "🔁 GIVE APP FEEDBACK",
//               style: TextStyle(
//                 color: Colors.red,
//                 fontWeight: FontWeight.bold,
//               ),
//             ),
//
//             const SizedBox(height: 30),
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Help us improve",
//                 style: TextStyle(
//                   fontWeight: FontWeight.bold,
//                   color: Colors.black87,
//                 ),
//               ),
//             ),
//             const SizedBox(height: 8),
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Report a bug or suggest ways to make Grabto better.",
//               ),
//             ),
//             const SizedBox(height: 10),
//
//             Align(
//               alignment: Alignment.centerLeft,
//               child: ElevatedButton.icon(
//                 style: ElevatedButton.styleFrom(
//                   backgroundColor: Colors.deepOrange,
//                 ),
//                 icon: const Icon(Icons.feedback_outlined),
//                 label: const Text("Give Feedback"),
//                 onPressed: () {},
//               ),
//             ),
//
//             const Spacer(),
//
//             // Social Icons
//             const Align(
//               alignment: Alignment.centerLeft,
//               child: Text(
//                 "Follow us on",
//                 style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey),
//               ),
//             ),
//             const SizedBox(height: 8),
//             Row(
//               children: [
//                 IconButton(onPressed: () {}, icon: const Icon(Icons.play_circle_filled_outlined)),
//                 IconButton(onPressed: () {}, icon: const Icon(Icons.camera_alt_outlined)),
//                 IconButton(onPressed: () {}, icon: const Icon(Icons.facebook_outlined)),
//                 IconButton(onPressed: () {}, icon: const Icon(Icons.linked_camera_outlined)),
//               ],
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

class SupportActionButton extends StatelessWidget {
  final IconData icon;
  final String label;
  final VoidCallback onTap;

  const SupportActionButton({
    required this.icon,
    required this.label,
    required this.onTap,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Ink(
          padding: EdgeInsets.zero,
          decoration:  ShapeDecoration(
            color:MyColors.redBG.withAlpha(30),
            shape: RoundedRectangleBorder(),
          ),
          child: IconButton(
            visualDensity: VisualDensity(vertical: -3,horizontal: -4),
            icon: Icon(icon),
            color: Colors.deepOrange,
            onPressed: onTap,
          ),
        ),
        const SizedBox(height: 8),
        Text(label,style: TextStyle(fontSize: 13,fontWeight: FontWeight.w500),),
      ],
    );
  }
}
