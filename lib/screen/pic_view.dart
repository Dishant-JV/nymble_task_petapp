import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/cupertino.dart';
import 'package:photo_view/photo_view.dart';

class PicView extends StatelessWidget {
  final String imageUrl;

  const PicView({Key? key, required this.imageUrl}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Container(
        child: PhotoView(
      imageProvider: CachedNetworkImageProvider(imageUrl),
    ));
  }
}
