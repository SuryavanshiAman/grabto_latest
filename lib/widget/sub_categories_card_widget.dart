import 'package:cached_network_image/cached_network_image.dart';
import 'package:grabto/main.dart';
import 'package:grabto/theme/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:pod_player/pod_player.dart';

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
      // height: heights*0.2,
      // width: widths*0.23,

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
                  alignment: Alignment.topLeft,
                  children: [
                    SizedBox(
                      height: heights*0.2275,
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
class VibeGridWidget extends StatelessWidget {
  final String imgUrl;
  final String subcategoryName;
  final String spotAvailable;
  final String redeemed;
  final VoidCallback onTap;

  const VibeGridWidget({
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
      // height: heights*0.2,
      // width: widths*0.23,

      child: InkWell(
        onTap: onTap,
        child: Card(
          color: Colors.white,
          clipBehavior: Clip.antiAliasWithSaveLayer,
          elevation: 2,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(0),
          ),
          child: SizedBox(
            height: heights*0.11,
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
        ),
      ),
    );
  }
}

class VideoPlayerWidget extends StatefulWidget {
  final String videoUrl;

  const VideoPlayerWidget({Key? key, required this.videoUrl}) : super(key: key);

  @override
  _VideoPlayerWidgetState createState() => _VideoPlayerWidgetState();
}

class _VideoPlayerWidgetState extends State<VideoPlayerWidget> {
  late VideoPlayerController _controller;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.network(widget.videoUrl)
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
        _controller.setLooping(true);
        _controller.setVolume(0); // mute the video
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return _controller.value.isInitialized
        ? AspectRatio(
      aspectRatio: _controller.value.aspectRatio,
      child: VideoPlayer(_controller),
    )
        : Center(child: CircularProgressIndicator(color: MyColors.redBG));
  }
}
