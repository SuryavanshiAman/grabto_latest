import 'package:flutter/material.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/search_screen.dart';

class RestaurantPaymentScreen extends StatelessWidget {
  const RestaurantPaymentScreen({Key? key}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final orangeGradient = LinearGradient(
      colors: [Colors.orange.shade300, Colors.deepOrange],
      begin: Alignment.topCenter,
      end: Alignment.bottomCenter,
    );

    return Scaffold(
      body: Column(
        children: [
          Container(
            height: 350,
            decoration: BoxDecoration(color: MyColors.redBG),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Icon(Icons.storefront, size: 80, color: Colors.white),
                const SizedBox(height: 16),
                const Text(
                  'Search the restaurant to pay',
                  style: TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const SizedBox(height: 4),
                const Text(
                  'Get EXTRA 25% OFF upto ₹1000.\nExciting bank offers.',
                  style: TextStyle(color: MyColors.whiteBG),
                  textAlign: TextAlign.center,
                ),
                const SizedBox(height: 20),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: SizedBox(
                    height: heights*0.06,
                    child: TextField(
                      readOnly: true,
                      decoration: InputDecoration(
                        prefixIcon: const Icon(Icons.search),
                        hintText: 'Search restaurant to pay',
                        fillColor: Colors.white,
                        filled: true,
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(5),
                          borderSide: BorderSide.none,
                        ),
                      ),
                      onTap: (){
                        Navigator.push(
                            context, MaterialPageRoute(builder: (context) => SearchStoreScreen(status:"1")));
                      },
                    ),
                  ),
                ),
                const SizedBox(height: 12),

              ],
            ),
          ),

          // Additional Offers
          Expanded(
            child: ListView(
              padding:  EdgeInsets.all(16),
              children: [
                Center(
                  child:  Text(
                    'Additional Offers',
                    style: TextStyle(
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                )
                ,
                const SizedBox(height: 16),
                offerCard(
                  cardImage: "assets/images/offer_one.png",
                  title: 'EazyDiner IndusInd Bank Credit Card',
                  discount: '25% Off upto ₹1000',
                  points: [
                    'No min. bill value',
                    'Valid every single time',
                    'EazyDiner IndusInd Signature Credit Card',
                  ],
                ),
                const SizedBox(height: 16),
                offerCard(
                  cardImage: "assets/images/offer_two.png",
                  title: 'EazyDiner IndusInd Bank Credit Card',
                  discount: '20% Off upto ₹500',
                  points: [
                    'No min. bill value',
                    'Valid thrice per card per month',
                    'EazyDiner IndusInd Platinum Credit Card',
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget offerCard({
    required String cardImage,
    required String title,
    required String discount,
    required List<String> points,
  }) {
    return Container(
      width: widths*0.5,
      height: heights*0.1,
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.grey,
        borderRadius: BorderRadius.circular(5),
        image:DecorationImage(
          image: AssetImage(cardImage,),
          fit: BoxFit.fill,

        ),
        // boxShadow: const [
        //   BoxShadow(
        //     color: Colors.black12,
        //     blurRadius: 4,
        //     offset: Offset(0, 2),
        //   )
        // ],
      ),
      // child: Column(
      //   crossAxisAlignment: CrossAxisAlignment.start,
      //   children: [
      //     Row(
      //       children: [
      //         Icon(cardImage, size: 40, color: Colors.deepOrange),
      //         const SizedBox(width: 10),
      //         Expanded(
      //           child: Text(
      //             title,
      //             style: const TextStyle(fontWeight: FontWeight.bold),
      //           ),
      //         ),
      //       ],
      //     ),
      //     const SizedBox(height: 8),
      //     Text(
      //       discount,
      //       style: const TextStyle(
      //         color: Colors.deepOrange,
      //         fontWeight: FontWeight.w600,
      //       ),
      //     ),
      //     const SizedBox(height: 8),
      //     ...points.map((point) => Row(
      //       crossAxisAlignment: CrossAxisAlignment.start,
      //       children: [
      //         const Text('• ', style: TextStyle(fontSize: 16)),
      //         Expanded(child: Text(point)),
      //       ],
      //     )),
      //   ],
      // ),
    );
  }
}
