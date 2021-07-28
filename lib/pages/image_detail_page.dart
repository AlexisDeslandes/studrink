import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/navigators/widgets/back_btn_wrapper.dart';
import 'package:ptit_godet/pages/my_custom_page.dart';

class ImageDetailPage extends MyCustomPage {
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

class _ImageDetailScreenState extends State<ImageDetailScreen>
    with TickerProviderStateMixin, BackBtnWrapper {
  late final AnimationController controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 600))
        ..forward();

  @override
  void dispose() {
    controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return FadeTransition(
      opacity: controller,
      child: Scaffold(
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: BackButton(
                onPressed: () => controller.reverse().then(
                    (value) => context.read<NavBloc>().add(const PopNav())),
                color: Colors.black),
          ),
          backgroundColor: Theme.of(context).scaffoldBackgroundColor,
          body: InteractiveViewer(
              child: Center(
                  child: Hero(
                      tag: widget.heroTag,
                      child: Material(
                        elevation: 1,
                        child: Image.asset(widget.imgPath,
                            width: MediaQuery.of(context).size.width * 0.7),
                      ))))),
    );
  }
}
