import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';

class ImageDetailPage extends CupertinoPage {
  ImageDetailPage({required String path, required String heroTag})
      : super(
            key: const ValueKey("/image_detail"),
            child: ImageDetailScreen(imgPath: path, heroTag: heroTag));
}

class ImageDetailScreen extends StatefulWidget {
  const ImageDetailScreen(
      {Key? key, required this.imgPath, required this.heroTag})
      : super(key: key);
  final String imgPath;
  final String heroTag;

  @override
  _ImageDetailScreenState createState() => _ImageDetailScreenState();
}

class _ImageDetailScreenState extends State<ImageDetailScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(
            onPressed: () => context.read<NavBloc>().add(const PopNav()),
            color: Colors.black),
      ),
      backgroundColor: Colors.transparent,
      body: InteractiveViewer(
          child: Center(
              child: Hero(
                  tag: widget.heroTag,
                  child: Image.asset(widget.imgPath,
                      width: MediaQuery.of(context).size.width * 0.7)))),
    );
  }
}
