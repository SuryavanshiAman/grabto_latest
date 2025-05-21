
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grabto/helper/user_provider.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';
import 'package:intl/intl.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';
import 'package:url_launcher/url_launcher.dart';

class ReferAndEarnScreen extends StatefulWidget {
  const ReferAndEarnScreen({super.key});

  @override
  State<ReferAndEarnScreen> createState() => _ReferAndEarnScreenState();
}

class _ReferAndEarnScreenState extends State<ReferAndEarnScreen> {
  final String referralCode = "RISH1556";
  void initState() {
    // TODO: implement initState
    super.initState();
    Provider.of<UserProvider>(context,listen: false).fetchUserDetails();
  }
  @override
  Widget build(BuildContext context) {
    return  Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
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
                  height: heights*0.27,
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
                          Row(
                            children:[
                              Text(user?.reffree.toString()??"",
                                  style: TextStyle(fontWeight: FontWeight.w500)),
                              SizedBox(width: widths*0.01,),
                              Image.asset("assets/images/credit_card.png"),
                              SizedBox(width: widths*0.01,),
                            ]
                          )

                        ],
                      ),
                      SizedBox(height: 30),

                      Padding(
                        padding:  EdgeInsets.only(left: widths*0.05),
                        child: Center(
                          child: Text("Balance: ₹${user?.wallet??""}",
                              style: TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.black)),
                        ),
                      ),
                      SizedBox(height: 8),
                      Padding(
                        padding:  EdgeInsets.only(left: widths*0.08),
                        child:   Center(
                          child: Text.rich(
                            TextSpan(
                              children: [
                                TextSpan(
                                  text: "Member Since:",
                                  style: TextStyle(
                                      color: Colors.black54, fontSize: 12, fontWeight: FontWeight.w500),
                                ),
                                TextSpan(
                                  text: "",
                                  // text:DateFormat('dd/MM/yyy').format(DateTime.parse(user?.created_at??"") ),
                                  style: TextStyle(fontSize: 14, color: Colors.black),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Spacer(),
                      Padding(
                        padding: const EdgeInsets.only(left: 8.0),
                        child: Text(user?.name??"",
                            style: TextStyle(fontWeight: FontWeight.w500)),
                      ),
                      SizedBox(height: 10),

                    ],
                  ),
                ),

                SizedBox(height: 24),

                /// Earn Text
                Text.rich(
                  TextSpan(
                    children: [
                      TextSpan(
                        text: "Earn ₹100",
                        style: TextStyle(
                            color: MyColors.redBG, fontSize: 20, fontWeight: FontWeight.w800),
                      ),
                      TextSpan(
                        text: "\nfor every friend you refer",
                        style: TextStyle(fontSize: 19, color: Colors.black,fontWeight: FontWeight.w600),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 8),
                Text("Earn ₹500 for the first 5 referrals",
                    style: TextStyle(color:MyColors.textColorTwo,fontSize: 10)),

                SizedBox(height: 12),

                /// Invite Button
                InkWell(
                  onTap: (){
                    Share.share(user?.referralLink??"");
                  },
                  child: Container(
                    padding: EdgeInsets.symmetric(vertical: 4),
                    width: widths*0.5,
                    decoration: BoxDecoration(
                        color: Color(0xfffff6f3),
                        borderRadius: BorderRadius.circular(5)
                    ),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Text("Invite via Referral link",style: TextStyle(color: MyColors.redBG,fontWeight: FontWeight.w500,fontSize: 10),),
                        Icon( Icons.file_upload_outlined,color: MyColors.redBG,size: 16,)
                      ],
                    ),
                  ),
                ),

                SizedBox(height: 20),

                /// Offer Boxes
                Row(
                  children: [
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(right: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(5),
                            boxShadow: [
                              BoxShadow(
                                  color: Colors.blue.withAlpha(60),
                                  blurRadius: 7,
                                  spreadRadius: 0.1,
                                  // spreadRadius: ,
                                  offset: Offset(0,3)
                              )
                            ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("You Get",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 12)),
                                SizedBox(width: widths*0.01,),
                                Icon( Icons.card_giftcard,color: MyColors.redBG,size: 16,)
                              ],
                            ),
                            SizedBox(height: 8),
                            Text("25% off upto ₹200 on your next payment.",
                                style: TextStyle(fontSize: 10,color: MyColors.textColorTwo)),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Container(
                        padding: EdgeInsets.all(10),
                        margin: EdgeInsets.only(left: 8),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          border: Border.all(color: Colors.grey.shade200),
                          borderRadius: BorderRadius.circular(5),
                          boxShadow: [
                            BoxShadow(
                              color: Color(0xFFFFF7E6),
                              blurRadius: 7,
                              spreadRadius: 0.1,
                              // spreadRadius: ,
                              offset: Offset(0,3)
                            )
                          ]
                        ),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Row(
                              children: [
                                Text("They Get",
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold, fontSize: 12)),
                                SizedBox(width: widths*0.01,),
                                Icon( Icons.card_giftcard,color: MyColors.redBG,size: 16,)
                              ],
                            ),
                            // Text("They Get 🎁",
                            //     style: TextStyle(
                            //         fontWeight: FontWeight.bold, fontSize: 14)),
                            SizedBox(height: 8),
                            Text("25% off upto ₹50 on their first payment.",
                                style: TextStyle(fontSize: 10,color: MyColors.textColorTwo
                                )),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),

                SizedBox(height: 24),

                /// Referral Code Box
                Row(
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
                // Text("Referral Code",
                //     style: TextStyle(fontWeight: FontWeight.bold, fontSize: 16)),
                SizedBox(height: 12),
                Center(
                  child: Container(
                    width:widths*0.4,
                    padding: EdgeInsets.symmetric(vertical:5,),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF7E6),
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Center(
                      child: Text(
                          user?.reffree.toString()??"",
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
                        Container(
                          padding: EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                          decoration: BoxDecoration(
                            color: Color(0xfffff6f3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IconButton(
                            visualDensity: VisualDensity(vertical: -4,horizontal: -4),
                            icon: Icon(Icons.share_outlined, color: Colors.red),
                            onPressed: () {
                              Share.share(user?.referralLink??"");
                            },
                          ),
                        ),
                        Text("Share", style: TextStyle(color: Colors.black,fontSize: 12)),
                      ],
                    ),
                    SizedBox(width: 40),
                    Column(
                      children: [
                        Container(padding: EdgeInsets.symmetric(vertical: 2,horizontal: 2),
                          decoration: BoxDecoration(
                            color:  Color(0xfffff6f3),
                            borderRadius: BorderRadius.circular(5),
                          ),
                          child: IconButton(
                            visualDensity: VisualDensity(vertical: -4,horizontal: -4),
                            icon: Icon(Icons.copy, color: Colors.red),
                            onPressed: () {
                              Clipboard.setData(ClipboardData(text: referralCode));
                              ScaffoldMessenger.of(context).showSnackBar(
                                SnackBar(content: Text("Referral code copied")),
                              );
                            },
                          ),
                        ),
                        Text("Copy", style: TextStyle(color: Colors.black,fontSize: 12)),
                      ],
                    ),
                  ],
                ),
                SizedBox(height: heights*0.04),
                Container(
                  // margin: EdgeInsets.only(
                  //   top: 10,
                  //   left: 15,
                  //   right: 15,
                  // ),
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
                        "How referral works?",
                        style: TextStyle(
                            fontSize: 14, fontWeight: FontWeight.w500),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: heights*0.03),
                Column(
                  children: List.generate(steps.length, (index) {
                    final step = steps[index];
                    return Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Column(
                          children: [
                            // Icon with circle
                            Container(
                              padding: EdgeInsets.all(8),
                              decoration: BoxDecoration(
                                color: Colors.white,
                                shape: BoxShape.circle,
                                border: Border.all(color: MyColors.textColorTwo.withAlpha(30)),
                              ),
                              child: Icon(step.icon, color: MyColors.redBG),
                            ),
                            if (index != steps.length - 1)
                              Container(
                                width: 2,
                                height: 30,
                                color:MyColors.textColorTwo.withAlpha(30),
                              ),
                          ],
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              step.text,
                              style: TextStyle(fontSize: 12),
                            ),
                          ),
                        )
                      ],
                    );
                  }),
                ),
                SizedBox(height: 56),
              ],
            ),
          ),
          bottomSheet: Container(
            height: heights*0.08,
            width: widths,
            color: Colors.black,
            child: Center(
              child: InkWell(
                onTap: (){
                  // openWhatsAppApp();
                  openWhatsAppAppWithMessage("Use this * ${user?.referralLink??""} *  referral link and get exciting rewards ");
                },
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
            ),
          ) ,
        );
      },
    );

  }
  // void openWhatsAppApp() async {
  //   final url = Uri.parse("https://wa.me/");
  //   if (await canLaunchUrl(url)) {
  //     await launchUrl(url, mode: LaunchMode.externalApplication);
  //   } else {
  //     throw 'Could not open WhatsApp';
  //   }
  // }
  void openWhatsAppAppWithMessage(String message) async {
    final encodedMessage = Uri.encodeComponent(message);
    final url = Uri.parse("whatsapp://send?text=$encodedMessage");

    if (await canLaunchUrl(url)) {
      await launchUrl(url, mode: LaunchMode.externalApplication);
    } else {
      throw 'Could not open WhatsApp';
    }
  }
  final List<_StepInfo> steps = [
    _StepInfo(icon: Icons.link, text: 'Share referral code or link with friends.'),
    _StepInfo(icon: Icons.inventory_2_outlined, text: 'When they place their first order, you both earn awards.'),
    _StepInfo(icon: Icons.wallet_giftcard_outlined, text: 'Redeem your coupons at checkout to claim your awards'),
  ];
}

class _StepInfo {
  final IconData icon;
  final String text;

  _StepInfo({required this.icon, required this.text});
}