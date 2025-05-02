// import 'package:custom_clippers/custom_clippers.dart';
// import 'package:dotted_border/dotted_border.dart';
// import 'package:flutter/material.dart';
//
// import '../theme/theme.dart';
//
// class ReferAndEarn extends StatelessWidget {
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: MyColors.backgroundBg,
//       appBar: AppBar(
//         backgroundColor: MyColors.backgroundBg,
//         leading: InkWell(
//             onTap: () {
//               Navigator.pop(context);
//             },
//             child: Icon(Icons.arrow_back_ios)),
//         centerTitle: true,
//         title: Text(
//           "Refer & Earn",
//           style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//         ),
//       ),
//       body: Container(
//         color: MyColors.backgroundBg,
//         child: SingleChildScrollView(
//           child: Column(
//             children: [
//               SizedBox(
//                 height: 50,
//               ),
//               Center(
//                 child: Container(
//                     constraints: const BoxConstraints(maxHeight: 240),
//                     margin: const EdgeInsets.symmetric(horizontal: 8),
//                     child: Image.asset('assets/vector/vect_refer.png')),
//               ),
//               SizedBox(
//                 height: 20,
//               ),
//               Text(
//                 "Refer Your Friends",
//                 style: TextStyle(
//                     fontSize: 25,
//                     fontWeight: FontWeight.bold,
//                     color: MyColors.txtTitleColor),
//               ),
//               Text(
//                 "Invite your friends and earn money",
//                 style: TextStyle(
//                     fontSize: 15,
//                     fontWeight: FontWeight.normal,
//                     color: MyColors.txtDescColor),
//               ),
//               SizedBox(
//                 height: 40,
//               ),
//
//               ClipPath(
//                 clipper: MultiplePointsClipper(Sides.bottom, heightOfPoint: 10),
//
//                 child: Container(
//                   height: 200,
//                   margin: EdgeInsets.symmetric(horizontal: 20),
//                   padding: EdgeInsets.all(20),
//                   color: Colors.red,
//                   alignment: Alignment.center,
//                   child: Column(
//                     children: [
//                       DottedBorder(
//                         borderType: BorderType.RRect,
//                         radius: Radius.circular(12),
//                         strokeWidth: 1,
//                         dashPattern: [6, 3],
//                         // Adjust the dash pattern as needed
//                         color: MyColors.whiteBG,
//                         child: Container(
//                           width: 180,
//                           height: 50,
//                           // Your container content goes here
//                           child: Center(
//                             child: Text('DIGIC20',style: TextStyle(fontSize: 22,color: MyColors.whiteBG),),
//                           ),
//                         ),
//                       ),
//                       SizedBox(
//                         height: 40,
//                       ),
//                       Container(
//                         width: 200,height: 40,
//                         child: ElevatedButton(
//                           onPressed: () {
//
//                           },
//                           child: Text(
//                             "Share Your Code",
//                             style: TextStyle(fontSize: 16, color: MyColors.whiteBG),
//                           ),
//                           style: ButtonStyle(
//                             backgroundColor: MaterialStateProperty.all<Color>(
//                                 MyColors.primaryColor),
//                           ),
//                         ),
//                       ),
//                     ],
//                   ),
//                 ),
//               ),
//               SizedBox(
//                 height: 200,
//               ),
//             ],
//           ),
//         ),
//       ),
//     );
//   }
// }
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';

class ReferAndEarnScreen extends StatelessWidget {
  final String referralCode = "RISH1556";

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: MyColors.whiteBG,
      appBar: AppBar(
        backgroundColor: MyColors.whiteBG,
        title: Text("Refer and Earn",style:
          TextStyle(fontSize: 18),),
        leading: BackButton(),
      ),
      body: SingleChildScrollView(
        padding: EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Wallet Card
            Container(
              width: double.infinity,
              padding: EdgeInsets.all(16),
              decoration: BoxDecoration(
                // color: Colors.red,
                image: DecorationImage(image:AssetImage("assets/images/Card.png"),fit: BoxFit.fill),
                borderRadius: BorderRadius.circular(16),

              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          CircleAvatar(
                            radius: 8,
                            backgroundImage: AssetImage("assets/images/grabto_logo_without_text.png"),
                            ),
                          SizedBox(width: widths*0.01,),
                          Text("GRABTO WALLET",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 14,
                                  color: Colors.black)),
                        ],
                      ),
                      Text(referralCode,
                          style: TextStyle(fontWeight: FontWeight.w500)),
                    ],
                  ),
                  SizedBox(height: 16),

                  Center(
                    child: Text("Balance: ₹5000",
                        style: TextStyle(
                            fontSize: 18,
                            fontWeight: FontWeight.bold,
                            color: Colors.black)),
                  ),
                  SizedBox(height: 8),
                  Padding(
                    padding: const EdgeInsets.only(left: 80.0),
                    child:   Text.rich(
                      TextSpan(
                        children: [
                          TextSpan(
                            text: "Member Since:",
                            style: TextStyle(
                                color: Colors.black54, fontSize: 12, fontWeight: FontWeight.bold),
                          ),
                          TextSpan(
                            text: " 09/07/2024",
                            style: TextStyle(fontSize: 13, color: Colors.black),
                          ),
                        ],
                      ),
                    ),
                  //   Text("Member Since: 09/07/2024",
                  //       style: TextStyle(color: Colors.black54)),
                  ),
                  SizedBox(height: 16),
                  Text("MR. RISHABH SAHU",
                      style: TextStyle(fontWeight: FontWeight.w500)),
                ],
              ),
            ),

            SizedBox(height: 24),

            /// Earn Text
            Text.rich(
              TextSpan(
                children: [
                  TextSpan(
                    text: "Earn ₹200",
                    style: TextStyle(
                        color: MyColors.redBG, fontSize: 20, fontWeight: FontWeight.bold),
                  ),
                  TextSpan(
                    text: "\nfor every friend you refer",
                    style: TextStyle(fontSize: 18, color: Colors.black,fontWeight: FontWeight.w600),
                  ),
                ],
              ),
            ),
            SizedBox(height: 8),
            Text("Earn ₹1000 for the first 5 referrals",
                style: TextStyle(color:MyColors.textColorTwo,fontSize: 12)),

            SizedBox(height: 12),

            /// Invite Button
            Container(
              padding: EdgeInsets.symmetric(vertical: 8),
              width: widths*0.5,
              decoration: BoxDecoration(
                color: Color(0xfffff6f3),
                borderRadius: BorderRadius.circular(5)
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  Text("Invite via Referral link",style: TextStyle(color: MyColors.redBG,fontWeight: FontWeight.w500,fontSize: 12),),
                 Icon( Icons.file_upload_outlined,color: MyColors.redBG,size: 18,)
                ],
              ),
            ),

            SizedBox(height: 20),

            /// Offer Boxes
            Row(
              children: [
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(right: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("You Get",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            SizedBox(width: widths*0.01,),
                            Icon( Icons.card_giftcard,color: MyColors.redBG,size: 18,)
                          ],
                        ),
                        SizedBox(height: 8),
                        Text("25% off upto ₹200 on your next order.",
                            style: TextStyle(fontSize: 12,color: MyColors.textColorTwo)),
                      ],
                    ),
                  ),
                ),
                Expanded(
                  child: Container(
                    padding: EdgeInsets.all(12),
                    margin: EdgeInsets.only(left: 8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      border: Border.all(color: Colors.grey.shade300),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            Text("They Get",
                                style: TextStyle(
                                    fontWeight: FontWeight.bold, fontSize: 14)),
                            SizedBox(width: widths*0.01,),
                            Icon( Icons.card_giftcard,color: MyColors.redBG,size: 18,)
                          ],
                        ),
                        // Text("They Get 🎁",
                        //     style: TextStyle(
                        //         fontWeight: FontWeight.bold, fontSize: 14)),
                        SizedBox(height: 8),
                        Text("25% off upto ₹50 on their first order.",
                            style: TextStyle(fontSize: 12,color: MyColors.textColorTwo
                            )),
                      ],
                    ),
                  ),
                ),
              ],
            ),

            SizedBox(height: 24),

            /// Referral Code Box
            Container(
                                    margin: EdgeInsets.only(
                                      top: 10,
                                      left: 15,
                                      right: 15,
                                    ),
                                    child: Row(
                                      // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                                      children: [
                                        Container(
                                          height: heights * 0.02,
                                          width: 2,
                                          color: MyColors.redBG,
                                        ),
                                        SizedBox(
                                          width: 5,
                                        ),
                                        Text(
                                          "Referral Code",
                                          style: TextStyle(
                                              fontSize: 14, fontWeight: FontWeight.w500),
                                        ),
                                      ],
                                    ),
                                  ),
            // Text("Referral Code",
            //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
            SizedBox(height: 12),
            Center(
              child: Container(
                width:widths*0.4,
                padding: EdgeInsets.symmetric(vertical: 10,),
                decoration: BoxDecoration(
                  color: Color(0xFFFFF7E6),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    referralCode,
                    style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w500,
                        letterSpacing: 2),
                  ),
                ),
              ),
            ),

            SizedBox(height: 16),

            /// Share and Copy Buttons
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.share_outlined, color: Colors.red),
                      onPressed: () {},
                    ),
                    Text("Share", style: TextStyle(color: Colors.black)),
                  ],
                ),
                SizedBox(width: 40),
                Column(
                  children: [
                    IconButton(
                      icon: Icon(Icons.copy, color: Colors.red),
                      onPressed: () {
                        Clipboard.setData(ClipboardData(text: referralCode));
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text("Referral code copied")),
                        );
                      },
                    ),
                    Text("Copy", style: TextStyle(color: Colors.black)),
                  ],
                ),
              ],
            ),


          ],
        ),
      ),
      bottomSheet: Container(
        height: heights*0.08,
        width: widths,
        color: Colors.black,
        child: Center(
          child: Container(
            alignment: Alignment.center,
            width: widths*0.8,
            height: heights*0.05,
            padding: EdgeInsets.symmetric(horizontal: 24,vertical: 8),
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(5),
                  color: MyColors.redBG
            ),
            child: Text("Invite from contacts",style: TextStyle(color: MyColors.whiteBG),),
          ),
        ),
      ) ,
    );
  }
}
