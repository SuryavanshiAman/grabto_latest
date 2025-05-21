import 'package:cached_network_image/cached_network_image.dart';
import 'package:grabto/model/features_model.dart';
import 'package:grabto/model/gallery_model.dart';
import 'package:grabto/model/vibe_model.dart';
import 'package:grabto/services/api_services.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/full_screen_gallery.dart';
import 'package:flutter/material.dart';

class VibeScreen extends StatefulWidget {
  int store_id = 0;
  final VibeModel ? data;

  VibeScreen(this.store_id,this.data);

  @override
  State<VibeScreen> createState() => _VibeScreenState();
}

class _VibeScreenState extends State<VibeScreen> {
  bool _isLoading1 = false;
  // List<GalleryModel> ambienceList = [];
  // bool _isLoading2 = false;
  List<GalleryModel> foodList = [];

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
          title: Text('Restaurant Vibe',style: TextStyle(color: MyColors.whiteBG),),
        ),
        body: _isLoading1
            ? Center(
          child: CircularProgressIndicator(
            color: MyColors
                .primaryColor, // Set the loading indicator color
          ),
        ):
        // foodList.isEmpty
            // ? Center(child: _buildNoImagesWidget())
            // :
        GalleryGrid(images: widget.data),

      ),
    );
  }

  Widget _buildNoImagesWidget() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          width: 200,
          height: 180,
          child: Image.asset('assets/vector/blank.png'), // No images available
        ),
        SizedBox(height: 16),
        Text(
          'No Images available',
          style: TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w200,
          ),
        ),
      ],
    );
  }
}

class GalleryGrid extends StatefulWidget {
  final VibeModel? images;

  GalleryGrid({required this.images});

  @override
  State<GalleryGrid> createState() => _GalleryGridState();
}

class _GalleryGridState extends State<GalleryGrid> {
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
        itemCount: widget.images?.data?.length??0,
        gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 3,
          crossAxisSpacing: 8,
          mainAxisSpacing: 8,
          childAspectRatio: 3 / 4,
        ),
        itemBuilder: (BuildContext context, int index) {
          return GestureDetector(
            onTap: () {
              List<String> imageUrls =
              widget.images?.data?.map((e) => e.image).whereType<String>() .toList()??[];
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (context) => FullScreenGallery(
                    images: imageUrls,
                    initialIndex: index,
                  ),
                ),
              );
            },
            child: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:  CachedNetworkImage(
                imageUrl:widget.images?.data?[index].image,
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
