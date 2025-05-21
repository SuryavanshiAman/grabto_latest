// import 'dart:convert';
// import 'dart:typed_data';
//
// import 'package:flutter/material.dart';
// import 'package:grabto/model/store_model.dart';
// import 'package:grabto/services/api.dart';
// import 'package:grabto/theme/theme.dart';
// import 'package:grabto/ui/profile/preview_post_screen.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:photo_manager/photo_manager.dart';
// import 'package:http/http.dart' as http;
//
// class AddPostScreen extends StatefulWidget {
//   final String status;
//   const AddPostScreen({super.key, required this.status});
//
//   @override
//   _AddPostScreenState createState() => _AddPostScreenState();
// }
//
// class _AddPostScreenState extends State<AddPostScreen> {
//   List<AssetEntity> _images = [];
//   Set<AssetEntity> _selectedImages = {};
//   List<StoreModel> _filteredStores = [];
//   @override
//   void initState() {
//     super.initState();
//     _loadGalleryMedia();
//     _fetchStores('');
//   }
//   Future<void> _fetchStores(String query) async {
//     final body = {"search_name": "$query"};
//
//     String apiUrl = '$BASE_URL/search_store';
//     try {
//       final response = await http.post(Uri.parse(apiUrl), body: body);
//       if (response.statusCode == 200) {
//         final jsonData = json.decode(response.body);
//         if (jsonData['res'] == 'success') {
//           List<dynamic> data = jsonData['data'];
//           setState(() {
//             _filteredStores =
//                 data.map((store) => StoreModel.fromMap(store)).toList();
//           });
//
//           print("data: ");
//         }
//       } else {
//         throw Exception(
//             'Failed to load stores. Status code: ${response.statusCode}');
//       }
//     } catch (e) {
//       print('Error fetching stores: $e');
//       // Handle error here
//     }
//   }
//   // Future<void> _loadGalleryImages() async {
//   //   final PermissionState permission = await PhotoManager.requestPermissionExtend();
//   //
//   //   if (permission.isAuth) {
//   //     final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
//   //       type: RequestType.image,
//   //       onlyAll: true,
//   //     );
//   //
//   //     final List<AssetEntity> media = await albums[0].getAssetListPaged(
//   //       page: 0,
//   //       size: 100,
//   //     );
//   //
//   //     setState(() {
//   //       _images = media;
//   //     });
//   //   } else {
//   //     PhotoManager.openSetting();
//   //   }
//   // }
//   Future<void> _loadGalleryMedia() async {
//     final PermissionState permission = await PhotoManager.requestPermissionExtend();
//
//     if (permission.isAuth) {
//       RequestType mediaType;
//
//       if (widget.status == "2") {
//         mediaType = RequestType.video; // For Flicks
//       } else {
//         mediaType = RequestType.image; // For Photos, Review, Highlight
//       }
//
//       final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
//         type: mediaType,
//         onlyAll: true,
//       );
//
//       final List<AssetEntity> media = await albums[0].getAssetListPaged(
//         page: 0,
//         size: 100,
//       );
//
//       setState(() {
//         _images = media;
//       });
//     } else {
//       PhotoManager.openSetting();
//     }
//   }
//
//   // void _toggleSelection(AssetEntity asset) {
//   //   setState(() {
//   //     if (_selectedImages.contains(asset)) {
//   //       _selectedImages.remove(asset);
//   //     } else {
//   //       _selectedImages.add(asset);
//   //     }
//   //   });
//   // }
//   void _toggleSelection(AssetEntity asset) {
//     setState(() {
//       if (_selectedImages.contains(asset)) {
//         _selectedImages.remove(asset);
//       } else {
//         if (_selectedImages.length < 10) {
//           _selectedImages.add(asset);
//         } else {
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(content: Text("You can select up to 10 photos")),
//           );
//         }
//       }
//     });
//   }
//
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _openCamera() async {
//     final XFile? image = await _picker.pickImage(source: ImageSource.camera);
//     if (image != null) {
//       final AssetEntity? asset = await PhotoManager.editor.saveImageWithPath(image.path);
//       if (asset != null) {
//         setState(() {
//           _images.insert(0, asset);
//           _selectedImages.add(asset); // Optional: auto-select captured image
//         });
//       }
//     }
//   }
//   Widget _imageThumbnail(AssetEntity entity) {
//     return FutureBuilder<Uint8List?>(
//       future: entity.thumbnailDataWithSize( ThumbnailSize(200, 200)),
//       builder: (context, snapshot) {
//         final bytes = snapshot.data;
//         if (bytes == null) {
//           return Container(
//               decoration: BoxDecoration(
//                   color: Colors.grey[300],
//                   borderRadius: BorderRadius.circular(5)
//               ),
//               );
//         }
//
//         final isSelected = _selectedImages.contains(entity);
//
//         return GestureDetector(
//           onTap: () => _toggleSelection(entity),
//           child: Stack(
//             children: [
//               Positioned.fill(
//                 child: Image.memory(bytes, fit: BoxFit.cover),
//               ),
//               if (isSelected)
//                 Positioned.fill(
//                   child: Container(
//                     padding: EdgeInsets.all(5),
//                     decoration: BoxDecoration(
//                       color: Colors.black.withOpacity(0.5),
//                       border: Border.all(color: MyColors.blueBG,width: 2),
//                       // borderRadius: BorderRadius.circular(5)
//                     ),
//                     child: Align(
//                       alignment: Alignment.topRight,
//                       child: CircleAvatar(
//                         radius: 7,
//                         backgroundColor: MyColors.whiteBG,
//                           child: Icon(Icons.check_circle_sharp, color:MyColors.blueBG, size: 14)),
//                     ),
//                   ),
//                 ),
//             ],
//           ),
//         );
//       },
//     );
//   }
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         leading: InkWell(
//             onTap: (){
//               Navigator.pop(context);
//             },
//             child: Icon(Icons.arrow_back)),
//         title: Text(widget.status=="1"?"Select upto 10 photos":widget.status=="2"?"Select only 1 video":widget.status=="3"?"Select upto 10 photos":"Select only 1 photos",style: TextStyle(fontSize: 16,fontFamily: 'wix',fontWeight: FontWeight.w600),),
//       ),
//       body: _images.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : Column(
//         children: [
//           Expanded(
//             child: GridView.builder(
//               padding: const EdgeInsets.all(8),
//               itemCount: _images.length,
//               gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 mainAxisSpacing: 8,
//                 crossAxisSpacing: 8,
//               ),
//               itemBuilder:
//                   (context, index) {
//                 return _imageThumbnail(_images[index]);
//               },
//             ),
//           ),
//
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             color: Colors.black,
//             child: Row(
// mainAxisAlignment: MainAxisAlignment.spaceEvenly,
//               children: [
//                 InkWell(
//                   onTap: (){
//                     _openCamera();
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 12,horizontal: 32),
//                     decoration: BoxDecoration(
//                       color: MyColors.whiteBG,
//                       borderRadius: BorderRadius.circular(5),
//                     ),
//                     child: Text("Open Camera",style: TextStyle(fontSize: 14,color: MyColors.textColor,fontFamily: 'wix',fontWeight: FontWeight.w600),),
//                   ),
//                 ),
//
//                 InkWell(
//                   onTap: (){
//                     if (_selectedImages.isEmpty) {
//                       ScaffoldMessenger.of(context).showSnackBar(
//                         SnackBar(content: Text("Please select at least one photo")),
//                       );
//                       return;
//                     }
//
//                     Navigator.push(context, MaterialPageRoute(builder: (context)=>PreviewPostScreen( selectedImages: _selectedImages.toList(),)));
//                   },
//                   child: Container(
//                     padding: EdgeInsets.symmetric(vertical: 12,horizontal: 33),
//                     decoration: BoxDecoration(
//                       color: MyColors.redBG,
//                       borderRadius: BorderRadius.circular(5),
//                       // border: Border.all(color: MyColors.grey.withAlpha(100))
//                     ),
//                     child: Text(widget.status=="1"?"Add Photos":widget.status=="2"?"Add Flicks":widget.status=="3"?"Add Review":"Add Highlight",style: TextStyle(fontSize: 14,color: MyColors.whiteBG,fontFamily:'wix',fontWeight: FontWeight.w600),),
//                   ),
//                 ),
//               ],
//             ),
//           ),
//         ],
//       ),
//     );
//   }
// }
import 'dart:convert';
import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:grabto/model/store_model.dart';
import 'package:grabto/services/api.dart';
import 'package:grabto/theme/theme.dart';
import 'package:grabto/ui/profile/preview_post_screen.dart';
import 'package:image_picker/image_picker.dart';
import 'package:photo_manager/photo_manager.dart';
import 'package:http/http.dart' as http;

class AddPostScreen extends StatefulWidget {
  final String status;
  const AddPostScreen({super.key, required this.status});

  @override
  _AddPostScreenState createState() => _AddPostScreenState();
}

class _AddPostScreenState extends State<AddPostScreen> {
  List<AssetEntity> _media = [];
  Set<AssetEntity> _selectedMedia = {};
  List<StoreModel> _filteredStores = [];

  final ImagePicker _picker = ImagePicker();

  @override
  void initState() {
    super.initState();
    _loadGalleryMedia();
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
            _filteredStores = data.map((store) => StoreModel.fromMap(store)).toList();
          });
        }
      } else {
        throw Exception('Failed to load stores. Status code: ${response.statusCode}');
      }
    } catch (e) {
      print('Error fetching stores: $e');
    }
  }

  Future<void> _loadGalleryMedia() async {
    final PermissionState permission = await PhotoManager.requestPermissionExtend();

    if (permission.isAuth) {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: widget.status == "2" ? RequestType.video : RequestType.image,
        onlyAll: true,
      );

      final List<AssetEntity> media = await albums[0].getAssetListPaged(page: 0, size: 100);

      setState(() {
        _media = media;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  void _toggleSelection(AssetEntity asset) {
    setState(() {
      if (_selectedMedia.contains(asset)) {
        _selectedMedia.remove(asset);
      } else {
        if (widget.status == "2") {
          // Only allow 1 video
          if (_selectedMedia.isEmpty) {
            _selectedMedia.add(asset);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("You can select only 1 video")),
            );
          }
        } else {
          if (_selectedMedia.length < 10) {
            _selectedMedia.add(asset);
          } else {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text("You can select up to 10 photos")),
            );
          }
        }
      }
    });
  }

  Future<void> _openCamera() async {
    final XFile? image = await _picker.pickImage(source: ImageSource.camera);
    if (image != null) {
      final AssetEntity? asset = await PhotoManager.editor.saveImageWithPath(image.path);
      if (asset != null) {
        setState(() {
          _media.insert(0, asset);
          _selectedMedia.add(asset);
        });
      }
    }
  }

  Widget _mediaThumbnail(AssetEntity entity) {
    return FutureBuilder<Uint8List?>(
      future: entity.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
      builder: (context, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null) {
          return Container(
            decoration: BoxDecoration(
              color: Colors.grey[300],
              borderRadius: BorderRadius.circular(5),
            ),
          );
        }

        final isSelected = _selectedMedia.contains(entity);

        return GestureDetector(
          onTap: () => _toggleSelection(entity),
          child: Stack(
            children: [
              Positioned.fill(child: Image.memory(bytes, fit: BoxFit.cover)),

              // Video play icon overlay
              if (entity.type == AssetType.video)
                const Center(
                  child: Icon(Icons.play_circle_fill, size: 30, color: Colors.white),
                ),

              if (isSelected)
                Positioned.fill(
                  child: Container(
                    padding: const EdgeInsets.all(5),
                    decoration: BoxDecoration(
                      color: Colors.black.withOpacity(0.5),
                      border: Border.all(color: MyColors.blueBG, width: 2),
                    ),
                    child: Align(
                      alignment: Alignment.topRight,
                      child: CircleAvatar(
                        radius: 7,
                        backgroundColor: MyColors.whiteBG,
                        child: Icon(Icons.check_circle_sharp, color: MyColors.blueBG, size: 14),
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    String getTitle() {
      switch (widget.status) {
        case "1":
        case "3":
          return "Select up to 10 photos";
        case "2":
          return "Select only 1 video";
        default:
          return "Select only 1 photo";
      }
    }

    String getButtonText() {
      switch (widget.status) {
        case "1":
          return "Add Photos";
        case "2":
          return "Add Flicks";
        case "3":
          return "Add Review";
        default:
          return "Add Highlight";
      }
    }

    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
          onTap: () => Navigator.pop(context),
          child: const Icon(Icons.arrow_back),
        ),
        title: Text(
          getTitle(),
          style: const TextStyle(fontSize: 16, fontFamily: 'wix', fontWeight: FontWeight.w600),
        ),
      ),
      body: _media.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: const EdgeInsets.all(8),
              itemCount: _media.length,
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
              ),
              itemBuilder: (context, index) => _mediaThumbnail(_media[index]),
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
            color: Colors.black,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                InkWell(
                  onTap: () => _openCamera(),
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 32),
                    decoration: BoxDecoration(
                      color: MyColors.whiteBG,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      "Open Camera",
                      style: TextStyle(
                          fontSize: 14,
                          color: MyColors.textColor,
                          fontFamily: 'wix',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
                InkWell(
                  onTap: () {
                    if (_selectedMedia.isEmpty) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text("Please select at least one media")),
                      );
                      return;
                    }

                    Navigator.push(
                      context,
                      MaterialPageRoute(
                        builder: (context) => PreviewPostScreen(
                          selectedImages: _selectedMedia.toList(),
                        ),
                      ),
                    );
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 33),
                    decoration: BoxDecoration(
                      color: MyColors.redBG,
                      borderRadius: BorderRadius.circular(5),
                    ),
                    child: Text(
                      getButtonText(),
                      style: TextStyle(
                          fontSize: 14,
                          color: MyColors.whiteBG,
                          fontFamily: 'wix',
                          fontWeight: FontWeight.w600),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
