import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:grabto/main.dart';
import 'package:grabto/model/store_model.dart';
import 'package:grabto/services/api.dart';
import 'package:grabto/view_model/add_post_view_model.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:photo_manager/src/types/entity.dart';
import 'package:http/http.dart' as http;
import 'package:provider/provider.dart';

import '../../theme/theme.dart';
import '../search_screen.dart';

class PreviewPostScreen extends StatefulWidget {
  final List<AssetEntity> selectedImages;
   PreviewPostScreen({super.key, required this.selectedImages});

  @override
  State<PreviewPostScreen> createState() => _PreviewPostScreenState();
}

class _PreviewPostScreenState extends State<PreviewPostScreen> {
  List<StoreModel> _filteredStores = [];
  @override
  void initState() {
    super.initState();
    _fetchStores('');
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
        final mimeType = asset.mimeType ?? 'image/jpeg';
        String base64String = 'data:$mimeType;base64,${base64Encode(bytes)}';
        base64Images.add(base64String);
      } else {
        print("Null bytes for asset: ${asset.title}");
      }
    }

    return base64Images;
  }
int comment =0;
int fire =0;
int share =0;
TextEditingController captionCont=TextEditingController();
  @override
  Widget build(BuildContext context) {
    final data = Provider.of<AddPostViewModel>(context);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Preview Post/s',style: TextStyle(fontSize: 16),),
        leading: const BackButton(),
      ),
      body: ListView(
        shrinkWrap: true,
        children: [
          // Image preview row
          Container(
            margin: EdgeInsets.symmetric(horizontal: 10),
            height: heights*0.33,
            child: ListView.builder(
              padding: EdgeInsets.zero,
              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount: widget.selectedImages.length,
              itemBuilder: (context, index) {
                return FutureBuilder<Uint8List?>(
                  future: widget.selectedImages[index].thumbnailDataWithSize( ThumbnailSize(200, 200)),
                  builder: (context, snapshot) {
                    if (!snapshot.hasData) {
                      return Container(color: Colors.grey[300]);
                    }
                    return Container(
                      margin: const EdgeInsets.all(5),
                      width: widths*0.63,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(12),
                        image:  DecorationImage(
                          image: MemoryImage(snapshot.data! ), // Replace with your image
                          fit: BoxFit.fill,
                        ),
                      ),
                    );
                      Image.memory(snapshot.data!, fit: BoxFit.cover);
                  },
                );
              },
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: TextField(
              maxLines: 2,
              controller: captionCont,
              decoration: InputDecoration(
                hintText: 'Add a caption...',
                hintStyle: TextStyle(fontWeight: FontWeight.w600,fontFamily: 'wix',fontSize: 14,color: MyColors.textColorTwo),
                border: InputBorder.none,
              ),
            ),
          ),
           Divider(color: MyColors.textColorTwo.withAlpha(50),),
          ListTile(
            visualDensity: VisualDensity(vertical: -4),
            minLeadingWidth: widths*0.01,
            leading: const Icon(Icons.restaurant,size: 14),
            title: const Text('Add Restaurant',style: TextStyle(fontSize: 14,fontFamily: 'wix',fontWeight: FontWeight.w600),),
            trailing: const Icon(Icons.arrow_forward_ios, size: 14),
            onTap: () {
              Navigator.push(context, MaterialPageRoute(builder: (context)=>SearchStoreScreen(status:"1")));
            },
          ),
          Container(
            height: heights*0.07,
            margin: EdgeInsets.symmetric(horizontal: widths*0.04),
            child: ListView.builder(

              shrinkWrap: true,
              scrollDirection: Axis.horizontal,
              itemCount:_filteredStores.length,
              itemBuilder: (context, index) {
                return  InkWell(
                  onTap: (){
                  },
                  child: Container(
                    alignment: Alignment.center,
                    padding: EdgeInsets.symmetric(vertical: 3,horizontal: 20),
                    margin: EdgeInsets.symmetric(vertical: 14,horizontal: 5),
                    decoration: BoxDecoration(
                      color: MyColors.grey.withAlpha(50),
                        borderRadius: BorderRadius.circular(5),
                        // border: Border.all(color: MyColors.grey.withAlpha(100))
                    ),
                    child: Text( _filteredStores[index].storeName,
                        maxLines: 2, // Set maxLines to 2
                        overflow: TextOverflow.ellipsis,style: TextStyle(fontSize: 10,color: MyColors.textColor,fontWeight: FontWeight.w600,fontFamily: 'wix'),),
                  ),
                );
              },
            ),
          ),
          Divider(color: MyColors.textColorTwo.withAlpha(50),),
          _buildToggleRow("Turn off commenting", Icons.comments_disabled_outlined, comment, (val) {
            setState(() {
              comment = val;
            });
          }),
          _buildToggleRow("Hide fire count on this post", Icons.local_fire_department_outlined, fire, (val) {
            setState(() {
              fire = val;
            });
          }),
          _buildToggleRow("Hide share count on this post", Icons.share_outlined, share, (val) {
            setState(() {
              share = val;
            });
          }),

        ],
      ),
      bottomSheet:   Container(
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
              onPressed: () async{
                List<String> base64Images = await _convertAssetsToBase64(widget.selectedImages);
                print("😊😊");
print(comment);
print(fire);
print(share);
print("😊😊");
                await data.addPostApi(
                    context,
                    base64Images,
                    captionCont.text,
                    "29",
                    comment,
                    fire,
                    share
                );
              },
              child: const Text(
                'Share',
                style: TextStyle(fontSize: 14, fontWeight: FontWeight.w600,fontFamily: 'wix',color: MyColors.whiteBG),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildToggleRow(String text,IconData icon,int currentValue, Function(int) onChanged) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Row(
            children: [
              Icon(icon,size: 16,),
              SizedBox(width: widths*0.03,),
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
              alignment: isOn == 1 ? Alignment.centerRight : Alignment.centerLeft,
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
