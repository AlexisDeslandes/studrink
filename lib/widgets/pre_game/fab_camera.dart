import 'package:flutter/cupertino.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/models/player.dart';

class FabCamera extends StatelessWidget {
  final Player player;

  const FabCamera({Key? key, required this.player}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    final avatarPlayer = player.avatar;
    return Container(
      child: FloatingActionButton(
          heroTag: "fab_camera_${player.id}",
          onPressed: kIsWeb ? null : () => _takePicture(context),
          mini: true,
          child: avatarPlayer != null
              ? ClipRRect(
                  child: Image.memory(avatarPlayer),
                  borderRadius: BorderRadius.circular(100.0))
              : Container(
                  width: 48.0,
                  height: 48.0,
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(100.0),
                      color: player.color),
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
      final croppedFile = await ImageCropper.cropImage(
              sourcePath: pickedFile.path,
              aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
              cropStyle: CropStyle.circle),
          pictureArray = await croppedFile!.readAsBytes();
      context
          .read<CurrentGameBloc>()
          .add(ChangePicturePlayer(player: player, pictureData: pictureArray));
    }
  }
}
