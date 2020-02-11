import 'dart:io';

import 'package:cached_network_image/cached_network_image.dart';
import 'package:dpa/components/widget/loading_widget.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class ImagePreview extends StatelessWidget {
  final String pathOrUrl;
  final bool fromFile;
  final double ratio;

  const ImagePreview({
    @required this.pathOrUrl,
    this.fromFile = false,
    this.ratio = 16 / 9,
  });

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
              child: _buildImageWidget(),
            ),
          ),
        );
      },
      child: AspectRatio(
        aspectRatio: 16 / 9,
        child: _buildImageWidget(),
      ),
    );
  }

  Widget _buildImageWidget() {
    return (fromFile)
        ? Image.file(
            File(pathOrUrl),
            fit: BoxFit.cover,
          )
        : CachedNetworkImage(
            placeholder: (context, url) => Center(
              child: LoadingWidget(
                showLabel: false,
              ),
            ),
            imageUrl: pathOrUrl,
            fit: BoxFit.cover,
          );
  }
}
