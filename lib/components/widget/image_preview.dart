import 'package:cached_network_image/cached_network_image.dart';
import 'package:dpa/theme/colors.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final String url;

  const ImagePreview({@required this.url});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        showDialog(
          context: context,
          child: new AlertDialog(
            content: GestureDetector(
              onTap: () {
                Navigator.pop(context);
              },
              child: ImageFullScreen(url: url),
            ),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: CachedNetworkImage(
          placeholder: (context, url) => Center(
            child: CircularProgressIndicator(
              valueColor: new AlwaysStoppedAnimation<Color>(MyColors.second),
            ),
          ),
          imageUrl: url,
          fit: BoxFit.cover,
        ),
      ),
    );
  }
}

class ImageFullScreen extends StatelessWidget {
  final String url;

  const ImageFullScreen({@required this.url});

  @override
  Widget build(BuildContext context) {
    return CachedNetworkImage(
      placeholder: (context, url) => Center(
        child: CircularProgressIndicator(
          valueColor: new AlwaysStoppedAnimation<Color>(MyColors.second),
        ),
      ),
      imageUrl: url,
      fit: BoxFit.cover,
    );
  }
}
