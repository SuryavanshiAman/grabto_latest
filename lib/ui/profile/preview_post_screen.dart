import 'dart:convert';
import 'dart:io';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:grabto/main.dart';
import 'package:grabto/model/store_model.dart';
import 'package:grabto/services/api.dart';
import 'package:grabto/view_model/add_flick_view_model.dart';
import 'package:grabto/view_model/add_post_view_model.dart';
import 'package:grabto/view_model/add_rivew_view_model.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager/src/types/entity.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../../view_model/add_heighlight_view_model.dart';
import '../restaurent_search_screen.dart';

class PreviewPostScreen extends StatefulWidget {
  final List<AssetEntity> selectedImages;
  final String status;
  PreviewPostScreen(
      {super.key, required this.selectedImages, required this.status});

  @override
  State<PreviewPostScreen> createState() => _PreviewPostScreenState();
}

class _PreviewPostScreenState extends State<PreviewPostScreen> {
  List<StoreModel> _filteredStores = [];
  List<String> base64Videos=[];
  @override
  void initState() {
    super.initState();
    _fetchStores('');
    _initVideoConversion();
  }
  void _initVideoConversion() async {
    base64Videos = await _convertVideoToBase64(widget.selectedImages);
    setState(() {}); // optionally update the UI
  }
  Future<void> _fetchStores(String query) async {
    final body = {"search_name": "$query"};

    String apiUrl = '$BASE_URL/search_store';
    try {
      final response = await http.post(Uri.parse(apiUrl), body: body);
      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        if (jsonData['res'] == 'success') {
          List<dynamic> data = jsonData['data'];
          setState(() {
            _filteredStores =
                data.map((store) => StoreModel.fromMap(store)).toList();
          });

          print("data: ");
        }
      } else {
        throw Exception(
            'Failed to load stores. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching stores: $e');
      // Handle error here
    }
  }

  final List<String> selectedRestaurants = [
    'The Urban Terrace',
    'Non-Veg Point',
    'Tadka Restaurant'
  ];
  Future<List<String>> _convertAssetsToBase64(List<AssetEntity> assets) async {
    List<String> base64Images = [];

    for (AssetEntity asset in assets) {
      final bytes = await asset.originBytes;

      if (bytes != null) {
        final mimeType = asset.mimeType ?? 'image/jpeg/mp4';
        String base64String = 'data:$mimeType;base64,${base64Encode(bytes)}';
        base64Images.add(base64String);
      } else {
        print("Null bytes for asset: ${asset.title}");
      }
    }

    return base64Images;
  }
  // Future<List<String>> _convertVideoToBase64(List<AssetEntity> assets) async {
  //   List<String> base64List = [];
  //
  //   for (AssetEntity asset in assets) {
  //     File? file = await asset.file;
  //     if (file != null) {
  //       final mimeType = asset.mimeType;
  //       List<int> fileBytes = await file.readAsBytes();
  //       String base64String = 'data:$mimeType;base64,${base64Encode(fileBytes)}';
  //       base64List.add(base64String);
  //     }
  //   }
  //
  //   return base64List;
  // }
  Future<List<String>> _convertVideoToBase64(List<AssetEntity> assets) async {
    List<String> base64List = [];

    for (AssetEntity asset in assets) {
      File? file = await asset.file;
      if (file != null) {
        int sizeInBytes = await file.length();
        if (sizeInBytes < 10 * 1024 * 1024) { // Less than 10 MB
          final mimeType = asset.mimeType ?? 'video/mp4';
          List<int> fileBytes = await file.readAsBytes();
          String base64String = 'data:$mimeType;base64,${base64Encode(fileBytes)}';
          base64List.add(base64String);
        } else {
          print('Skipped large video: ${file.path}, size: $sizeInBytes bytes');
        }
      }
    }

    return base64List;
  }
int rating=0;
int selectedIndex=-1;
// String storeId="0";
  int comment = 0;
  int fire = 0;
  int share = 0;
  TextEditingController captionCont = TextEditingController();
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AddPostViewModel>(context);
    final addHighlight = Provider.of<AddHighlightViewModel>(context);
    final addReview = Provider.of<AddReviewViewModel>(context);
    final addFlick = Provider.of<AddFlickViewModel>(context);
    String hintText() {
      switch (widget.status) {
        case "1":
          return "Add a caption...";
        case "2":
          return "Add a caption...";
        case "3":
          return "Add review...";
        default:
          return "";
      }
    }

    String titleText() {
      switch (widget.status) {
        case "1":
          return "Preview Post/s";
        case "2":
          return "Preview flick";
        case "3":
          return "New Review";
        default:
          return "";
      }
    }

    return Scaffold(
      appBar:widget.status!="4"? AppBar(

        title: Text(
          titleText(),
          style: TextStyle(
              fontSize: 16, fontFamily: 'wix', fontWeight: FontWeight.w600),
        ),
        leading: const BackButton(),
      ):null,
      body:widget.status!="4"? ListView(
        shrinkWrap: true,
        children: [
          Container(
            alignment:widget.status!="2"?null: Alignment.center,
            // color: MyColors.redBG,
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: heights * 0.33,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.selectedImages.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Uint8List?>(
                  future: widget.selectedImages[index]
                      .thumbnailDataWithSize(ThumbnailSize(200, 200)),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(color: Colors.grey[300]);
                    }
                    return Container(
                      margin: const EdgeInsets.all(5),
                      width:widget.status!="2"? widths * 0.63:widths*0.4,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image: DecorationImage(
                          image: MemoryImage(
                              snapshot.data!), // Replace with your image
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                  },
                );
              },
            ),
          ),
          widget.status=="3"?
          SizedBox(
            height: heights * 0.045,
            width: widths,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: 10,
              itemBuilder: (context, index) {
                Color boxColor;
                if (index < 3) {
                  boxColor = Color(0xffff8b8b);
                } else if (index < 7) {
                  boxColor = Colors.yellow;
                } else {
                  boxColor = Color(0xff76fe7c);
                }
                return InkWell(
                  onTap: (){
                    setState(() {
                      selectedIndex=index;
                      rating=index+1;
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    margin: const EdgeInsets.all(5),
                    padding: EdgeInsets.symmetric(vertical: 2, horizontal: 12),
                    decoration: BoxDecoration(
                      color: boxColor,
                      borderRadius: BorderRadius.circular(5),
                      border: Border.all(color:selectedIndex==index? MyColors.redBG:Colors.transparent)
                    ),
                    child: Text(
                      (index + 1).toString(),
                      style: TextStyle(
                          fontSize: 12,
                          fontFamily: 'wix',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                );
              },
            ),
          ):Container(),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              maxLines: 2,
              controller: captionCont,
              decoration: InputDecoration(
                hintText: hintText(),
                hintStyle: TextStyle(
                    fontWeight: FontWeight.w600,
                    fontFamily: 'wix',
                    fontSize: 14,
                    color: MyColors.textColorTwo),
                border: InputBorder.none,
              ),
            ),
          ),
          Divider(
            color: MyColors.textColorTwo.withAlpha(50),
          ),
          ListTile(
            visualDensity: VisualDensity(vertical: -4),
            minLeadingWidth: widths * 0.01,
            leading: const Icon(Icons.restaurant, size: 14),
            title: const Text(
              'Add Restaurant',
              style: TextStyle(
                  fontSize: 14, fontFamily: 'wix', fontWeight: FontWeight.w600),
            ),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              Navigator.push(
                  context,
                  MaterialPageRoute(
                      builder: (context) => RestaurantsSearch(status: "1")));
            },
          ),
          Container(
            height: heights * 0.07,
            margin: EdgeInsets.symmetric(horizontal: widths * 0.04),
            child: ListView.builder(
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: _filteredStores.length,
              itemBuilder: (context, index) {
                return InkWell(
                  onTap: () {
                    setState(() {
                      data.setStoreId(_filteredStores[index].subcategoryId);
                    });
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 3, horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 14, horizontal: 5),
                    decoration: BoxDecoration(
                      color: MyColors.grey.withAlpha(50),
                      borderRadius: BorderRadius.circular(5),
                      // border: Border.all(color: MyColors.grey.withAlpha(100))
                    ),
                    child: Text(
                      _filteredStores[index].storeName,
                      maxLines: 2, // Set maxLines to 2
                      overflow: TextOverflow.ellipsis,
                      style: TextStyle(
                          fontSize: 10,
                          color: MyColors.textColor,
                          fontWeight: FontWeight.w600,
                          fontFamily: 'wix'),
                    ),
                  ),
                );
              },
            ),
          ),
          Divider(
            color: MyColors.textColorTwo.withAlpha(50),
          ),
          _buildToggleRow(
              "Turn off commenting", Icons.comments_disabled_outlined, comment,
              (val) {
            setState(() {
              comment = val;
            });
          }),
          _buildToggleRow("Hide fire count on this post",
              Icons.local_fire_department_outlined, fire, (val) {
            setState(() {
              fire = val;
            });
          }),
          _buildToggleRow(
              "Hide share count on this post", Icons.share_outlined, share,
              (val) {
            setState(() {
              share = val;
            });
          }),
        ],
      ):FutureBuilder<Uint8List?>(
        future: widget.selectedImages[0]
            .thumbnailDataWithSize(ThumbnailSize(200, 200)),
        builder: (context, snapshot) {
          if (!snapshot.hasData) {
            return Container(color: Colors.grey[300]);
          }
          return Container(
            margin: const EdgeInsets.all(5),
            width: widths ,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: DecorationImage(
                image: MemoryImage(
                    snapshot.data!), // Replace with your image
                fit: BoxFit.fill,
              ),
            ),
          );
        },
      ),
      bottomSheet: Container(
        color: MyColors.textColor,
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: MyColors.redBG,
                padding: const EdgeInsets.symmetric(vertical: 12),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              onPressed: () async {
                // List<String> base64Videos = await _convertVideoToBase64(widget.selectedImages);

                List<String> base64Images =
                    await _convertAssetsToBase64(widget.selectedImages);
                widget.status=="1"?
                await data.addPostApi(context, base64Images, captionCont.text,
                    data.storeId, comment, fire, share): widget.status=="2"? addFlick.addFlickApi(context,base64Videos, captionCont.text,
                    data.storeId, comment, fire, share): widget.status=="3"?addReview.addReviewApi(context, base64Images, captionCont.text,
                    data.storeId, comment, fire, share, rating):addHighlight.addHighlightApi(context, base64Images);
              },
              child: const Text(
                'Share',
                style: TextStyle(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    fontFamily: 'wix',
                    color: MyColors.whiteBG),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow(
      String text, IconData icon, int currentValue, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(
                icon,
                size: 16,
              ),
              SizedBox(
                width: widths * 0.03,
              ),
              Text(
                text,
                style: const TextStyle(fontSize: 14),
              ),
            ],
          ),
          CustomToggleSwitch(
            initialValue: currentValue == 1 ? 1 : 0,
            onChanged: (val) {
              setState(() {
                onChanged(val);
                print("⭐⭐⭐");
              });
            },
          ),
        ],
      ),
    );
  }
}

class CustomToggleSwitch extends StatefulWidget {
  final int initialValue; // 0 for off, 1 for on
  final ValueChanged<int> onChanged;

  const CustomToggleSwitch({
    Key? key,
    this.initialValue = 0,
    required this.onChanged,
  }) : super(key: key);

  @override
  State<CustomToggleSwitch> createState() => _CustomToggleSwitchState();
}

class _CustomToggleSwitchState extends State<CustomToggleSwitch> {
  late int isOn; // 0 = off, 1 = on

  @override
  void initState() {
    super.initState();
    isOn = widget.initialValue;
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          isOn = isOn == 1 ? 0 : 1;
        });
        widget.onChanged(isOn);
      },
      child: SizedBox(
        width: 50,
        height: 30,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: widths * 0.1,
              height: heights * 0.015,
              decoration: BoxDecoration(
                color: isOn == 1 ? Colors.green : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            AnimatedAlign(
              duration: const Duration(milliseconds: 200),
              alignment:
                  isOn == 1 ? Alignment.centerRight : Alignment.centerLeft,
              child: Container(
                width: widths * 0.08,
                height: heights * 0.025,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: MyColors.textColor, // Your custom color
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.2),
                      blurRadius: 2,
                      offset: const Offset(0, 2),
                    )
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
