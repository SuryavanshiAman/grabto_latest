import 'package:flutter/material.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';



class AddressBottomSheet extends StatelessWidget {
  const AddressBottomSheet({super.key});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        bottom: MediaQuery.of(context).viewInsets.bottom,
      ),
      child: Container(
        height: heights*0.7,
        color: MyColors.whiteBG,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  children: [
                    const Icon(Icons.location_on, color: MyColors.redBG),
                    const SizedBox(width: 8),
                    const Text(
                      "Sector H",
                      style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                const Text(
                  "Sector H, Jankipuram, Lucknow, Uttar Pradesh 226021, India",
                  style: TextStyle(color: MyColors.blackBG),
                ),
                const SizedBox(height: 12),
                Container(
                  padding: const EdgeInsets.all(12),
                  decoration: BoxDecoration(
                    color:  MyColors.redBG.withOpacity(0.1),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: const Text(
                    "A detailed address will help our Delivery Partner reach your doorstep easily",
                    style: TextStyle(color:MyColors.redBG,fontSize: 11,fontWeight: FontWeight.w500),
                  ),
                ),
                const SizedBox(height: 12),
                 TextField(
                  decoration: InputDecoration(labelText: "HOUSE / FLAT / BLOCK NO.",labelStyle: TextStyle(fontSize: 13,color: Colors.grey[600])),
                ),
                const SizedBox(height: 8),
                 TextField(
                  decoration: InputDecoration(labelText: "APARTMENT / ROAD / AREA (RECOMMENDED)",labelStyle: TextStyle(fontSize: 13,color: Colors.grey[600])),
                ),
                const SizedBox(height: 20),
                 Text("DIRECTIONS TO REACH (OPTIONAL)",style: TextStyle(fontSize: 11,color: Colors.grey[600]),),
                const SizedBox(height: 20),
                Container(
                  height: heights*0.065,
                  padding: EdgeInsets.only(left: 10,right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(30),
                    border: Border.all(color: Colors.grey),

                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text("Tap to record voice directions",style: TextStyle(fontWeight: FontWeight.w500),),
                      CircleAvatar(
                        radius: 12,
                        backgroundColor: Colors.grey[300],
                        child: Icon(Icons.mic,size: 17,),
                      )
                    ],
                  ),
                ),
                // Row(
                //   children: [
                //     ElevatedButton.icon(
                //       onPressed: () {},
                //       icon: const Icon(Icons.mic),
                //       label: const Text("Tap to record voice directions"),
                //       style: ElevatedButton.styleFrom(
                //
                //         // backgroundColor: Colors.grey[200],
                //         foregroundColor: Colors.black,
                //       ),
                //     ),
                //   ],
                // ),
                const SizedBox(height: 10),
                 TextField(

                  maxLines: 3,
                  decoration: InputDecoration(

                    filled: true,
                    fillColor: Colors.grey[200],
                    hintText: "e.g. Ring the bell on the red gate",
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 12),
                const Text("SAVE AS"),
                const SizedBox(height: 8),
                Wrap(
                  spacing: 8,
                  children: [
                    ChoiceChip(label: const Text("Home"), selected: false),
                    ChoiceChip(label: const Text("Work"), selected: false),
                    ChoiceChip(label: const Text("Friends and Family"), selected: false),
                    ChoiceChip(label: const Text("Other"), selected: false),
                  ],
                ),
                const SizedBox(height: 12),
                const Text("RECEIVER'S PHONE NUMBER (OPTIONAL)"),
                const SizedBox(height: 8),
                TextField(
                  keyboardType: TextInputType.phone,
                  decoration: InputDecoration(
                    suffixIcon: Icon(Icons.contact_phone),
                    border: OutlineInputBorder(),
                  ),
                ),
                const SizedBox(height: 16),
                Container(
                  alignment: Alignment.center,
                  height: heights*0.065,
                  padding: EdgeInsets.only(left: 10,right: 10),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(5),
                    // border: Border.all(color: Colors.grey),
color: MyColors.redBG
                  ),
                  child: Text(
                    "ENTER HOUSE / FLAT / BLOCK NO.",
                    style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                  ),
                ),
                // ElevatedButton(
                //   style: ElevatedButton.styleFrom(
                //     backgroundColor: MyColors.redBG,
                //     minimumSize: Size(double.infinity, 50),
                //   ),
                //   onPressed: () {},
                //   child: const Text(
                //     "ENTER HOUSE / FLAT / BLOCK NO.",
                //     style: TextStyle(color: Colors.white, fontWeight: FontWeight.bold),
                //   ),
                // ),
                const SizedBox(height: 16),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
