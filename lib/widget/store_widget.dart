import 'package:cached_network_image/cached_network_image.dart';
import 'package:grabto/main.dart';
import 'package:grabto/model/store_model.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/coupon_fullview_screen.dart';
import 'package:flutter/material.dart';

class StoreWidget extends StatelessWidget {
  final List<StoreModel> storeList;

  StoreWidget(this.storeList);

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(top: 0, left: 15, right: 15, bottom: 0),
      child: LayoutBuilder(
        builder: (context, constraints) {
          return ListView.builder(
            itemCount: storeList.length,
            shrinkWrap: true,
             //physics: NeverScrollableScrollPhysics(),
            itemBuilder: (context, index) {
              StoreModel store =
                  storeList[index]; // Get the store at the current index
              return InkWell(
                onTap: () {
                  Navigator.push(context, MaterialPageRoute(builder: (context) {
                    return CouponFullViewScreen("${store.id}");
                  }));
                },
                child: Container(
                  margin: const EdgeInsets.only(bottom: 20),
                  child: Card(
                    color: Colors.white,
                    elevation: 5,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(10),
                    ),
                    clipBehavior: Clip.antiAliasWithSaveLayer,
                    child: Container(
                      child: Column(
                        children: [
                          SizedBox(
                            width: double.infinity,
                            height: 220,
                            child: CachedNetworkImage(
                              imageUrl: store.banner,
                              fit: BoxFit.fill,
                              placeholder: (context, url) => Image.asset(
                                'assets/images/placeholder.png',
                                // Path to your placeholder image asset
                                fit: BoxFit.cover,
                                width: double.infinity,
                                height: double.infinity,
                              ),
                              errorWidget: (context, url, error) =>
                                  const Center(child: Icon(Icons.error)),
                            ),
                          ),
                          Container(
                            color: Colors.white,
                            padding: const EdgeInsets.all(10),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    SizedBox(
                                      width: widths*0.6,
                                      child: Text(
                                        store.storeName,
                                        style: const TextStyle(
                                          fontWeight: FontWeight.w500,
                                          color: MyColors.txtTitleColor,
                                          fontSize: 17,
                                          // overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ),
                                    if (store.rating.isNotEmpty)
                                      Flexible(
                                        child: SizedBox(
                                          width: 65,
                                          height: 38,
                                          child: Card(
                                            elevation: 2,
                                            color: Colors.green,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.all(8.0),
                                              child: Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment.center,
                                                children: [
                                                  Text(
                                                    "${store.rating}",
                                                    style: const TextStyle(
                                                      color: Colors.white,
                                                      fontSize: 12,
                                                      fontWeight:
                                                          FontWeight.bold,
                                                    ),
                                                  ),
                                                  const SizedBox(width: 5),
                                                  const Icon(
                                                    Icons.star,
                                                    color: Colors.white,
                                                    size: 15,
                                                  ),
                                                ],
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  children: [
                                    if (store.distance.isNotEmpty) ...[
                                      Text(
                                        '${store.distance} km',
                                        style: const TextStyle(
                                          fontWeight: FontWeight.bold,
                                          color: MyColors.txtDescColor2,
                                          fontSize: 12,
                                          overflow: TextOverflow.ellipsis,
                                        ),
                                      ),
                                    ],
                                  ],
                                ),
                                const SizedBox(height: 5),
                                Row(
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Expanded(
                                      child: Row(
                                        children: [
                                          const Icon(
                                            Icons.star,
                                            color: MyColors.blackBG,
                                            size: 15,
                                          ),
                                          const SizedBox(width: 5),
                                          Expanded(
                                            child: Text(
                                              store.subcategoryName,
                                              style: const TextStyle(
                                                fontWeight: FontWeight.w500,
                                                color: MyColors.blackBG,
                                                fontSize: 12,
                                                overflow: TextOverflow.ellipsis,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (store.redeem.isNotEmpty)
                                      Flexible(
                                        child: Container(
                                          child: Text(
                                            '${store.redeem} Redeemed',
                                            style: const TextStyle(
                                              fontWeight: FontWeight.w500,
                                              color: Colors.green,
                                              fontSize: 11,
                                              overflow: TextOverflow.ellipsis,
                                            ),
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                          Container(
                            height: 50,
                            padding: const EdgeInsets.only(
                                left: 15, top: 10, bottom: 10, right: 15),
                            color: MyColors.blueBG,
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.center,
                              children: [
                                SizedBox(
                                  width: 20,
                                  height: 20,
                                  child: Image.asset(
                                    'assets/images/offer_2.png',
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 10),
                                // Comment out the Padding widget and move the Expanded widget directly inside the Row
                                // Padding(
                                //   padding: const EdgeInsets.only(bottom: 0),
                                //   child:
                                Expanded(
                                  child: Text(
                                    "Offer :- " + store.offers,
                                    style: const TextStyle(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                        fontSize: 18),
                                    overflow: TextOverflow.ellipsis,
                                  ),
                                ),
                                // ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              );
            },
          );
        },
      ),
    );
  }
}
