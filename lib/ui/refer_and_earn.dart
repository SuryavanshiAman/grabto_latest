
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:grabto/helper/user_provider.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';
import 'package:provider/provider.dart';
import 'package:share_plus/share_plus.dart';

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
                          Text(user?.reffree.toString()??"",
                              style: TextStyle(fontWeight: FontWeight.w500)),
                        ],
                      ),
                      SizedBox(height: 16),

                      Center(
                        child: Text("Balance: ₹${user?.wallet??""}",
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
                      Text(user?.name??"",
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
                InkWell(
                  onTap: (){
                    Share.share(user?.referralLink??"");
                  },
                  child: Container(
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
                    padding: EdgeInsets.symmetric(vertical: 10,),
                    decoration: BoxDecoration(
                      color: Color(0xFFFFF7E6),
                      borderRadius: BorderRadius.circular(12),
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
                SizedBox(height: 12),
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
                SizedBox(height: 12),
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
                                border: Border.all(color: MyColors.textColorTwo.withAlpha(10)),
                              ),
                              child: Icon(step.icon, color: MyColors.redBG),
                            ),
                            if (index != steps.length - 1)
                              Container(
                                width: 2,
                                height: 40,
                                color:MyColors.textColorTwo.withAlpha(10),
                              ),
                          ],
                        ),
                        SizedBox(width: 12),
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.only(top: 8),
                            child: Text(
                              step.text,
                              style: TextStyle(fontSize: 14),
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
      },
    );

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