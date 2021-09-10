import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/models/player.dart';
import 'package:studrink/utils/image_utils.dart';

class FabCamera extends StatefulWidget {
  final Player player;

  const FabCamera({Key? key, required this.player}) : super(key: key);

  @override
  _FabCameraState createState() => _FabCameraState();
}

class _FabCameraState extends State<FabCamera> {
  late Player _player = widget.player;
  bool _isLoading = false;

  @override
  void didUpdateWidget(covariant FabCamera oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (widget.player.avatar != oldWidget.player.avatar) {
      setState(() {
        _player = widget.player;
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    final avatarPlayer = _player.avatar;
    return Container(
      child: FloatingActionButton(
          backgroundColor:
              _isLoading ? Theme.of(context).scaffoldBackgroundColor : null,
          heroTag: "fab_camera_${_player.id}",
          onPressed: kIsWeb ? null : () => _takePicture(context),
          mini: true,
          child: _isLoading
              ? Padding(
                  padding: const EdgeInsets.all(3.0),
                  child: CircularProgressIndicator(
                      color: Theme.of(context).primaryColor),
                )
              : avatarPlayer != null
                  ? ClipRRect(
                      child: Image.memory(avatarPlayer),
                      borderRadius: BorderRadius.circular(100.0))
                  : Container(
                      width: 48.0,
                      height: 48.0,
                      decoration: BoxDecoration(
                          borderRadius: BorderRadius.circular(100.0),
                          color: _player.color),
                      child: kIsWeb
                          ? null
                          : Icon(Icons.camera_alt, color: Colors.black))),
    );
  }

  void _takePicture(BuildContext context) async {
    final picker = ImagePicker(),
        pickedFile = await picker.pickImage(
            source: ImageSource.camera,
            preferredCameraDevice: CameraDevice.front);
    if (pickedFile != null) {
      setState(() => _isLoading = true);
      final bytes = await pickedFile.readAsBytes();
      final bytesCropped = await compute(ImageUtils.crop, bytes);
      context.read<CurrentGameBloc>().add(ChangePicturePlayer(
          player: widget.player, pictureData: bytesCropped));
    }
  }
}
