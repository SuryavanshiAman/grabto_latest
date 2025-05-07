import 'package:flutter/material.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/refer_and_earn.dart';
import 'package:grabto/ui/term_and_condition.dart';
import 'package:grabto/ui/transaction_screen.dart';
import 'package:provider/provider.dart';

import '../helper/shared_pref.dart';
import '../helper/user_provider.dart';
import 'about_us_screen.dart';
import 'customer_care.dart';
import 'how_it_works.dart';

class AccountSettingsScreen extends StatefulWidget {
  @override
  State<AccountSettingsScreen> createState() => _AccountSettingsScreenState();
}

class _AccountSettingsScreenState extends State<AccountSettingsScreen> {
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
   Provider.of<UserProvider>(context,listen: false).fetchUserDetails();
  }
  @override
  Widget build(BuildContext context) {
    return Consumer<UserProvider>(
      builder: (context, userProvider, child) {
        final user = userProvider.user;
        return Scaffold(
          appBar: AppBar(
            // centerTitle: true,
            title: Text('Account Settings',style: TextStyle(fontSize: 19),),
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                // Profile Header
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Row(
                    children: [
                      Container(
                        height: heights*0.12,
                        width: widths*0.22,
                        decoration: BoxDecoration(

                            borderRadius: BorderRadius.circular(5),
                            image: DecorationImage(image: NetworkImage(user?.image??""),fit: BoxFit.fill)
                        ),
                      ),
                      // CircleAvatar(
                      //   radius: 35,
                      //   backgroundImage: AssetImage('assets/profile.jpg'), // Replace with NetworkImage or your asset
                      // ),
                      SizedBox(width: 12),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(user?.name??"", style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text(user?.name??"", style: TextStyle(color: MyColors.textColorTwo,fontSize: 12)),
                          Row(
                            children: [
                              Icon(Icons.local_phone_outlined, size: 16, color: Colors.grey),
                              SizedBox(width: 4),
                              Text("+${user?.mobile??" "}"),
                            ],
                          ),
                          SizedBox(height: heights*0.01,),
                          Row(
                            children: [
                              Container(
                                alignment: Alignment.center,
                                width: widths*0.3,
                                height: heights*0.03,
                                // padding: EdgeInsets.symmetric(horizontal: 24,vertical: 8),
                                decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(5),
                                    color:MyColors.redBG
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                                  children: [
                                    Icon(Icons.mode_edit_outline_outlined, size: 14, color: MyColors.whiteBG),

                                    Text("Edit Profile",style: TextStyle(color: MyColors.whiteBG,fontSize: 12),),
                                  ],
                                ),
                              ),

                              SizedBox(width: 8),
                              Container(
                                width: widths*0.3,
                                height: heights*0.03,
                                decoration: BoxDecoration(
                                  color: MyColors.whiteBG,
                                  borderRadius: BorderRadius.circular(5),
                                  border: Border.all(color: MyColors.textColorTwo.withAlpha(20)),
                                ),
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    CircleAvatar(
                                      radius: 8,
                                      backgroundColor: Colors.yellow,
                                      child: Text("👑",style: TextStyle(color: Colors.white,fontSize: 10),),
                                    ),
                                    Text("Get Premium",style: TextStyle(fontSize: 12),),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                // Summary Section
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceAround,
                  children: [
                    Column(
                      children: [
                        Text('12', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold,color: MyColors.redBG)),
                        Text('Dinings Booked',style: TextStyle(color: MyColors.textColorTwo,fontSize: 12),),
                      ],
                    ),
                    Column(
                      children: [
                        Text('₹500', style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: MyColors.redBG)),
                        Text('Earned through refer',style: TextStyle(color: MyColors.textColorTwo,fontSize: 12),),
                      ],
                    ),
                  ],
                ),
                Divider( height: 20,color: MyColors.textColorTwo.withAlpha(20),),

                // Options List
                ListTile(
                  visualDensity: VisualDensity(vertical: -4),
                  leading: Icon(Icons.favorite, color: Colors.red,size: 18),
                  title: Text('Favorite Restaurants',style: TextStyle(fontSize: 13),),
                  onTap: () {},
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: -4),
                  leading: Icon(Icons.receipt_long,size: 18),
                  title: Text('Transactions',style: TextStyle(fontSize: 13),),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return TransactionScreen();
                        }));
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: -4),
                  leading: Icon(Icons.campaign,size: 18),
                  title: Text('Refer and Earn',style: TextStyle(fontSize: 13)),
                  onTap: () {
                    Navigator.push(context, MaterialPageRoute(builder: (context) {
                      return    ReferAndEarnScreen();
                    }));
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: -4),
                  leading: Icon(Icons.info_outline,size: 18),
                  title: Text('About Grabto',style: TextStyle(fontSize: 13)),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => AboutUsScreen()),
                    );
                  },
                ),
                Divider( height: 20,color: MyColors.textColorTwo.withAlpha(20),),
                ListTile(
                  visualDensity: VisualDensity(vertical: -4),
                  leading: Icon(Icons.support_agent,size: 18),
                  title: Text('Support',style: TextStyle(fontSize: 13)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return CustomerCare();
                        }));
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: -4),
                  leading: Icon(Icons.insert_emoticon_outlined,size: 18),
                  title: Text('Rate Grabto',style: TextStyle(fontSize: 13)),
                  onTap: () {},
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: -4),
                  leading: Icon(Icons.privacy_tip_outlined,size: 18),
                  title: Text('Terms & Privacy',style: TextStyle(fontSize: 13)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return TermsAndCondition();
                        }));
                  },
                ),
                ListTile(
                  visualDensity: VisualDensity(vertical: -4),
                  leading: Icon(Icons.help_outline,size: 18),
                  title: Text('How to use App?',style: TextStyle(fontSize: 13)),
                  onTap: () {
                    Navigator.push(context,
                        MaterialPageRoute(builder: (context) {
                          return HowItWorksScreen();
                        }));
                  },
                ),
                Divider( height: 20,color: MyColors.textColorTwo.withAlpha(20),),

                ListTile(
                  visualDensity: VisualDensity(vertical: -4),
                  leading: Icon(Icons.logout, color: Colors.red,size: 18),
                  title: Text('Sign Out', style: TextStyle(color: Colors.red,fontSize: 13)),
                  onTap: () {
                    logoutUser();
                  },
                ),
              ],
            ),
          ),
        );
      },
    )
      ;
  }
  void logoutUser() {
    SharedPref.logout(context);
  }
}
