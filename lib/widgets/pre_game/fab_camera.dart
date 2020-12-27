import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_cropper/image_cropper.dart';
import 'package:image_picker/image_picker.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/models/player.dart';

class FabCamera extends StatelessWidget {
  final Player player;

  const FabCamera({Key key, @required this.player})
      : assert(player != null),
        super(key: key);

  bool sameIdUser(Player element) => element.id == player.id;

  @override
  Widget build(BuildContext context) {
    return FloatingActionButton(
      onPressed: () => _takePicture(context),
      mini: true,
      child: BlocBuilder<CurrentGameBloc, CurrentGameState>(
        buildWhen: (previous, current) {
          final playerPrevious =
                  previous.playerList.firstWhere(sameIdUser, orElse: () => null),
              playerCurrent =
                  current.playerList.firstWhere(sameIdUser, orElse: () => null);
          return playerCurrent != null &&
              playerPrevious != null &&
              playerPrevious.avatar != playerCurrent.avatar;
        },
        builder: (context, state) {
          final avatarPlayer = state.playerList.firstWhere(sameIdUser).avatar;
          if (avatarPlayer != null) {
            return ClipRRect(
                child: Image.memory(avatarPlayer),
                borderRadius: BorderRadius.circular(100.0));
          }
          return Icon(Icons.camera_alt, color: Theme.of(context).primaryColor);
        },
      ),
    );
  }

  void _takePicture(BuildContext context) async {
    final picker = ImagePicker(),
        pickedFile = await picker.getImage(
            source: ImageSource.camera,
            preferredCameraDevice: CameraDevice.front);
    if (pickedFile != null) {
      final croppedFile = await ImageCropper.cropImage(
              sourcePath: pickedFile.path,
              aspectRatio: CropAspectRatio(ratioX: 1.0, ratioY: 1.0),
              cropStyle: CropStyle.circle),
          pictureArray = await croppedFile.readAsBytes();
      context
          .bloc<CurrentGameBloc>()
          .add(ChangePicturePlayer(player: player, pictureData: pictureArray));
    }
  }
}
