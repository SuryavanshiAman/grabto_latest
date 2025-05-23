import 'package:cached_network_image/cached_network_image.dart';
import 'package:grabto/model/features_model.dart';
import 'package:grabto/model/gallery_model.dart';
import 'package:grabto/services/api_services.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/full_screen_gallery.dart';
import 'package:flutter/material.dart';
import 'package:grabto/model/menu_type_model.dart';

class ViewMenuScreen extends StatefulWidget {
  List <Data>? menuType;

  ViewMenuScreen(this.menuType);

  @override
  State<ViewMenuScreen> createState() => _ViewMenuScreenState();
}

class _ViewMenuScreenState extends State<ViewMenuScreen> {
  bool _isLoading1 = false;

  @override
  void initState() {
    super.initState();


  }

  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: MyColors.textColor,
        appBar: AppBar(
          leading: InkWell(
              onTap: (){
                Navigator.pop(context);
              },
              child: Icon(Icons.arrow_back,color: MyColors.whiteBG,)),
          backgroundColor: MyColors.textColor,
          title: Text('Menu List',style: TextStyle(color: MyColors.whiteBG),),
        ),
        body: _isLoading1
            ? Center(
          child: CircularProgressIndicator(
            color: MyColors
                .primaryColor, // Set the loading indicator color
          ),
        ):
        MenuGrid(images: widget.menuType),

        // TabBarView(
        //   children: [
        //     _isLoading1
        //         ? Center(
        //             child: CircularProgressIndicator(
        //               color: MyColors
        //                   .primaryColor, // Set the loading indicator color
        //             ),
        //           )
        //         : ambienceList.isEmpty
        //             ? _buildNoImagesWidget()
        //             : MenuGrid(images: ambienceList),
        //     _isLoading2
        //         ? Center(
        //             child: CircularProgressIndicator(
        //               color: MyColors
        //                   .primaryColor, // Set the loading indicator color
        //             ),
        //           )
        //         : foodList.isEmpty
        //             ? _buildNoImagesWidget()
        //             : MenuGrid(images: foodList),
        //   ],
        // ),
      ),
    );
  }

  // Future<void> fetchGalleryImagesFood(String store_id, String food_type) async {
  //   setState(() {
  //     _isLoading2 = true;
  //   });
  //   try {
  //     final body = {"store_id": "$store_id", "food_type": "$food_type"};
  //     final response = await ApiServices.store_multiple_gallery(body);
  //     //print("object: $response");
  //     if (response != null) {
  //       setState(() {
  //         foodList = response;
  //         //_isLoading2=false;
  //       });
  //     }
  //     setState(() {
  //       _isLoading2 = false;
  //     });
  //   } catch (e) {
  //     print('fetchGalleryImagesFood: $e');
  //   } finally {
  //     _isLoading2 = false;
  //   }
  // }
  //
  // Future<void> fetchGalleryImagesAmbience(
  //     String store_id) async {
  //   setState(() {
  //     _isLoading1 = true;
  //   });
  //   try {
  //     final body1 = {"store_id": "$store_id", "food_type": "food"};
  //     final responseFood = await ApiServices.store_multiple_gallery(body1);
  //
  //     final body2 = {"store_id": "$store_id", "food_type": "ambience"};
  //     final responseAmbience = await ApiServices.store_multiple_gallery(body2);
  //
  //
  //     if (responseFood != null) {
  //       setState(() {
  //         foodList = responseFood;
  //       });
  //     }
  //     if (responseAmbience != null) {
  //       setState(() {
  //         ambienceList = responseAmbience;
  //       });
  //     }
  //
  //
  //     setState(() {
  //       ambienceList.addAll(foodList);
  //       _isLoading2 = false;
  //     });
  //   } catch (e) {
  //     print('fetchGalleryImagesAmbience: $e');
  //   } finally {
  //     _isLoading1 = false;
  //   }
  // }
  //
  // Widget _buildNoImagesWidget() {
  //   return Column(
  //     mainAxisAlignment: MainAxisAlignment.center,
  //     children: [
  //       Container(
  //         width: 200,
  //         height: 180,
  //         child: Image.asset('assets/vector/blank.png'), // No images available
  //       ),
  //       SizedBox(height: 16),
  //       Text(
  //         'No Images available',
  //         style: TextStyle(
  //           fontSize: 15,
  //           fontWeight: FontWeight.w200,
  //         ),
  //       ),
  //     ],
  //   );
  // }
}

class MenuGrid extends StatefulWidget {
  final List<Data>? images;

  MenuGrid({required this.images});

  @override
  State<MenuGrid> createState() => _MenuGridState();
}

class _MenuGridState extends State<MenuGrid> {
  // Initially set to true to show the loading indicator

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.all(10),

      child: GridView.builder(
        itemCount: widget.images?.length??0,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 4 / 4,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              List<String>imageUrls =
                  widget.images?.map((e) => e.image).whereType<String>() .toList()??[];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenGallery(
                    images: imageUrls,
                    initialIndex: index
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
             child:  CachedNetworkImage(
                imageUrl:widget.images?[index].image??"",
                fit: BoxFit.fill,
                placeholder: (context, url) => Image.asset(
                  'assets/images/vertical_placeholder.jpg',
                  // Path to your placeholder image asset
                  fit: BoxFit.cover,
                  width: double.infinity,
                  height: double.infinity,
                ),
                errorWidget: (context, url, error) =>
                    Center(child: Icon(Icons.error)),
              ),
              // child: Image.network(
              //   widget.images[index].image,
              //   fit: BoxFit.cover,
              //   loadingBuilder: (context, child, loadingProgress) {
              //     if (loadingProgress == null) return child;
              //     return Center(
              //       child: CircularProgressIndicator(
              //         color: MyColors.primaryColor,
              //         // Set the loading indicator color
              //         strokeWidth: 4,
              //       ),
              //     );
              //   },
              //   errorBuilder: (context, error, stackTrace) {
              //     return Image.asset(
              //       'assets/images/placeholder.png', // Placeholder image
              //       fit: BoxFit.cover,
              //     );
              //   },
              // ),
            ),
          );
        },
      ),
    );
  }
}
