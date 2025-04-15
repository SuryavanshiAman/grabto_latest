import 'package:cached_network_image/cached_network_image.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class SubCategoriesCardWidget extends StatelessWidget {
  final String imgUrl;
  final String subcategoryName;
  final String spotAvailable;
  final String redeemed;
  final VoidCallback onTap;

  const SubCategoriesCardWidget({
    Key? key,
    required this.imgUrl,
    required this.subcategoryName,
    required this.spotAvailable,
    required this.redeemed,
    required this.onTap,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
      height: heights*0.16,
      width: widths*0.23,

      child: InkWell(
        onTap: onTap,
        child: Card(
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Column(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(8),
                child: Stack(
                  alignment: Alignment.center,
                  children: [
                    SizedBox(
                      height: heights*0.1513,
                      width: double.infinity,
                      child: CachedNetworkImage(
                        imageUrl: imgUrl,
                        fit: BoxFit.fill,
                        placeholder: (context, url) => Image.asset(
                          'assets/images/placeholder.png',
                          fit: BoxFit.cover,
                          width: double.infinity,
                          height: double.infinity,
                        ),
                        errorWidget: (context, url, error) =>
                            Center(child: Icon(Icons.error)),
                      ),

                    ),

                    Container(
                      height: heights*0.15,
                      decoration: BoxDecoration(
                        // boxShadow: [
                        //   BoxShadow(
                        //     color: Color(0x30000000),
                        //     blurRadius: 20.0,
                        //   ),
                        // ],
                      ),
                      child: Container(
                        padding: EdgeInsets.all(8),
                        width: widths*0.2,
                        // color: Colors.red,
                        child: Text(
                          subcategoryName,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: MyColors.blackBG,
                            fontSize: 12,
                            // overflow: TextOverflow.ellipsis,
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
