import 'dart:io';

import 'package:dio/io.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:path_provider/path_provider.dart';

class CachedSvgPicture extends StatefulWidget {
  final String url;

  const CachedSvgPicture({Key? key, required this.url}) : super(key: key);

  @override
  State<CachedSvgPicture> createState() => _CachedSvgPictureState();
}

class _CachedSvgPictureState extends State<CachedSvgPicture> {
  String imagePath = "";

  Future<void> downloadSvg(String url) async {
    final dio = DioForNative();
    final dir = await getApplicationDocumentsDirectory();
    final exist = await File("${dir.path}/${url.hashCode.toString()}").exists();
    if (!exist) {
      try {
        await dio.download(
          url,
          "${dir.path}/${url.hashCode.toString()}",
        );
      } catch (e) {
        imagePath = "";
      }
    }
    imagePath = "${dir.path}/${url.hashCode.toString()}";
  }

  @override
  void initState() {
    downloadSvg(widget.url);
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return imagePath == ""
        ? SvgPicture.network(
            widget.url,
            placeholderBuilder: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
          )
        : SvgPicture.file(
            File(imagePath),
            placeholderBuilder: (_) => const Center(
              child: CircularProgressIndicator(),
            ),
          );
  }
}
