// import 'dart:io';
// import 'package:flutter/material.dart';
// import 'package:image_picker/image_picker.dart';
// import 'package:permission_handler/permission_handler.dart';
//
// import 'main.dart';
//
// class GalleryScreen extends StatefulWidget {
//   @override
//   _GalleryScreenState createState() => _GalleryScreenState();
// }
//
// class _GalleryScreenState extends State<GalleryScreen> {
//   final List<File> _images = [];
//
//   final ImagePicker _picker = ImagePicker();
//
//   Future<void> _openCamera() async {
//     final pickedFile = await _picker.pickImage(source: ImageSource.camera);
//     if (pickedFile != null) {
//       setState(() {
//         _images.add(File(pickedFile.path));
//       });
//     }
//   }
//
//
//   Future<void> _pickImagesFromGallery() async {
//     final pickedFiles = await _picker.pickMultiImage();
//     if (pickedFiles != null) {
//       setState(() {
//         _images.addAll(pickedFiles.map((e) => File(e.path)));
//       });
//     }
//   }
//
//   @override
//   void initState() {
//     super.initState();
//     _requestPermissions();
//   }
//
//   Future<void> _requestPermissions() async {
//     await Permission.photos.request();
//     await Permission.camera.request();
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       backgroundColor: Colors.white,
//       body: Column(
//         children: [
//           Container(
//             height:heights*0.5,
//             width:widths*0.9,
//             child: GridView.builder(
//               padding: const EdgeInsets.all(8),
//               itemCount: _images.length,
//               gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
//                 crossAxisCount: 3,
//                 mainAxisSpacing: 8,
//                 crossAxisSpacing: 8,
//               ),
//               itemBuilder: (context, index) {
//                 return Image.file(_images[index], fit: BoxFit.cover);
//               },
//             ),
//           ),
//           Container(
//             padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
//             color: Colors.black,
//             child: Row(
//               children: [
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _openCamera,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.white),
//                     child: Text("Open Camera", style: TextStyle(color: Colors.black)),
//                   ),
//                 ),
//                 const SizedBox(width: 16),
//                 Expanded(
//                   child: ElevatedButton(
//                     onPressed: _pickImagesFromGallery,
//                     style: ElevatedButton.styleFrom(backgroundColor: Colors.orange),
//                     child: Text("Add Photos"),
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

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:grabto/theme/theme.dart';
import 'package:photo_manager/photo_manager.dart';
/// best
// class GalleryScreen extends StatefulWidget {
//   @override
//   _GalleryScreenState createState() => _GalleryScreenState();
// }
//
// class _GalleryScreenState extends State<GalleryScreen> {
//   List<AssetEntity> _images = [];
//
//   @override
//   void initState() {
//     super.initState();
//     _loadGalleryImages();
//   }
//
//   Future<void> _loadGalleryImages() async {
//     // Request permissions to access media
//     final PermissionState permission = await PhotoManager.requestPermissionExtend();
//
//     if (permission.isAuth) {
//       // Get image albums (asset paths)
//       final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
//         type: RequestType.image,
//         onlyAll: true, // Only "Recent" or "All" album
//       );
//
//       // Get images from the first album
//       final List<AssetEntity> media = await albums[0].getAssetListPaged(
//         page: 0,
//         size: 100,
//       );
//
//       setState(() {
//         _images = media;
//       });
//     } else {
//       // Open app settings if permission denied
//       PhotoManager.openSetting();
//     }
//   }
//
//   Widget _imageThumbnail(AssetEntity entity) {
//     return FutureBuilder<Uint8List?>(
//       future: entity.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
//       builder: (context, snapshot) {
//         final bytes = snapshot.data;
//         if (bytes == null) {
//           return Container(color: Colors.grey[300]);
//         }
//         return Image.memory(bytes, fit: BoxFit.cover);
//       },
//     );
//   }
//
//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("Gallery Only")),
//       body: _images.isEmpty
//           ? const Center(child: CircularProgressIndicator())
//           : GridView.builder(
//         padding: const EdgeInsets.all(8),
//         itemCount: _images.length,
//         gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
//           crossAxisCount: 3,
//           mainAxisSpacing: 8,
//           crossAxisSpacing: 8,
//         ),
//         itemBuilder: (context, index) {
//           return _imageThumbnail(_images[index]);
//         },
//       ),
//     );
//   }
// }
///

class GalleryScreen extends StatefulWidget {
  @override
  _GalleryScreenState createState() => _GalleryScreenState();
}

class _GalleryScreenState extends State<GalleryScreen> {
  List<AssetEntity> _images = [];
  Set<AssetEntity> _selectedImages = {};

  @override
  void initState() {
    super.initState();
    _loadGalleryImages();
  }

  Future<void> _loadGalleryImages() async {
    final PermissionState permission = await PhotoManager.requestPermissionExtend();

    if (permission.isAuth) {
      final List<AssetPathEntity> albums = await PhotoManager.getAssetPathList(
        type: RequestType.image,
        onlyAll: true,
      );

      final List<AssetEntity> media = await albums[0].getAssetListPaged(
        page: 0,
        size: 100,
      );

      setState(() {
        _images = media;
      });
    } else {
      PhotoManager.openSetting();
    }
  }

  void _toggleSelection(AssetEntity asset) {
    setState(() {
      if (_selectedImages.contains(asset)) {
        _selectedImages.remove(asset);
      } else {
        _selectedImages.add(asset);
      }
    });
  }

  Widget _imageThumbnail(AssetEntity entity) {
    return FutureBuilder<Uint8List?>(
      future: entity.thumbnailDataWithSize(const ThumbnailSize(200, 200)),
      builder: (context, snapshot) {
        final bytes = snapshot.data;
        if (bytes == null) {
          return Container(color: Colors.grey[300]);
        }

        final isSelected = _selectedImages.contains(entity);

        return GestureDetector(
          onTap: () => _toggleSelection(entity),
          child: Stack(
            children: [
              Positioned.fill(
                child: Image.memory(bytes, fit: BoxFit.cover),
              ),
              if (isSelected)
                Positioned.fill(
                  child: Container(
                    color: Colors.black.withOpacity(0.5),
                    child: const Center(
                      child: Icon(Icons.check_circle, color: Colors.white, size: 40),
                    ),
                  ),
                ),
            ],
          ),
        );
      },
    );
  }

  void _onDone() {
    // Use _selectedImages to do something
    print("Selected ${_selectedImages.length} images");
    // You can navigate to another screen or upload here
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: InkWell(
            onTap: (){
              Navigator.pop(context);
            },
            child: Icon(Icons.arrow_back)),
        title: Text("Select upto 10 photos ",style: TextStyle(fontSize: 16,fontFamily: 'wix',fontWeight: FontWeight.w600),),
        // actions: [
        //   IconButton(
        //     icon: const Icon(Icons.done),
        //     onPressed: _selectedImages.isNotEmpty ? _onDone : null,
        //   ),
        // ],
      ),
      body: _images.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : Column(
            children: [
              Expanded(
                child: GridView.builder(
                        padding: const EdgeInsets.all(8),
                        itemCount: _images.length,
                        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                mainAxisSpacing: 8,
                crossAxisSpacing: 8,
                        ),
                        itemBuilder: (context, index) {
                return _imageThumbnail(_images[index]);
                        },
                      ),
              ),

              Container(
                padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
                color: Colors.black,
                child: Row(

                  children: [
                    InkWell(
                      onTap: (){
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 32),
                        decoration: BoxDecoration(
                          color: MyColors.whiteBG,
                            borderRadius: BorderRadius.circular(5),
                        ),
                        child: Text("Open Camera",style: TextStyle(fontSize: 14,color: MyColors.textColor,fontFamily: 'wix',fontWeight: FontWeight.w600),),
                      ),
                    ),

                    InkWell(
                      onTap: (){
                      },
                      child: Container(
                        padding: EdgeInsets.symmetric(vertical: 12,horizontal: 33),
                        decoration: BoxDecoration(
                          color: MyColors.redBG,
                          borderRadius: BorderRadius.circular(5),
                          // border: Border.all(color: MyColors.grey.withAlpha(100))
                        ),
                        child: Text("Add Photos",style: TextStyle(fontSize: 14,color: MyColors.whiteBG,fontFamily:'wix',fontWeight: FontWeight.w600),),
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

