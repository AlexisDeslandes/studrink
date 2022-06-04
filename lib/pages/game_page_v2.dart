import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/nav/nav_bloc.dart';
import 'package:studrink/models/moving.dart';
import 'package:studrink/models/player.dart';
import 'package:studrink/navigators/widgets/back_btn_wrapper.dart';
import 'package:studrink/pages/my_custom_page.dart';
import 'package:studrink/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:studrink/widgets/bottom_sheet/chose_opponent_list_view.dart';
import 'package:studrink/widgets/dice_view.dart';
import 'package:studrink/widgets/glass/glass_widget.dart';
import 'package:studrink/widgets/player_area/play_area.dart';
import 'package:studrink/widgets/player_avatar.dart';
import 'package:studrink/widgets/player_overlay.dart';

class GamePageV2 extends MyCustomPage {
  const GamePageV2()
      : super(
            child: const GameScreenV2(),
            key: const ValueKey<String>("/game_V2"));
}

class GameScreenV2 extends StatefulWidget {
  const GameScreenV2();

  @override
  _GameScreenV2State createState() => _GameScreenV2State();
}

class _GameScreenV2State extends State<GameScreenV2>
    with TickerProviderStateMixin, BackBtnWrapper {
  late final _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 900))
        ..forward();

  @override
  void initState() {
    super.initState();
    context
        .read<CurrentGameBloc>()
        .add(InitGameAnimationController(_controller));
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size, glowSize = 70.0;
    return Stack(
      children: [
        Positioned(
            left: MediaQuery.of(context).size.width / 2 - glowSize,
            top: -glowSize / 4,
            child: BlocSelector<CurrentGameBloc, CurrentGameState, Player>(
                selector: (state) => state.currentPlayer!,
                builder: (context, currentPlayer) => AvatarGlow(
                    glowColor: currentPlayer.color,
                    child: Stack(
                      children: [
                        PlayerAvatar(
                          player: currentPlayer,
                          size: 60,
                        ),
                        Positioned.fill(
                            child: Center(
                                child: Text(currentPlayer.shortName,
                                    style: TextStyle(
                                        fontWeight: FontWeight.bold))))
                      ],
                    ),
                    endRadius: glowSize))),
        Scaffold(
          backgroundColor: Colors.transparent,
          appBar: AppBar(
            backgroundColor: Colors.transparent,
            elevation: 0,
            leading: FadeTransition(
              opacity: _controller,
              child: BackButton(
                  onPressed: () => _controller.reverse().then(
                      (value) => context.read<NavBloc>().add(const PopNav())),
                  color: Colors.black),
            ),
          ),
          body: SafeArea(
            child: Stack(
              children: [
                BlocListener<CurrentGameBloc, CurrentGameState>(
                  listenWhen: (previous, current) =>
                      previous.currentPlayer?.state !=
                      current.currentPlayer?.state,
                  listener: _displayBottomSheet,
                  child: BlocListener<CurrentGameBloc, CurrentGameState>(
                    listenWhen: (previous, current) =>
                        previous.currentPlayer?.name !=
                            current.currentPlayer?.name &&
                        current.currentPlayer != null,
                    listener: (context, state) => _displayOverlay(
                        context, state, size.width, size.height),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(child:
                            BlocBuilder<CurrentGameBloc, CurrentGameState>(
                          builder: (context, state) {
                            return Padding(
                              padding: EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 8),
                              child: GridView.builder(
                                  gridDelegate:
                                      SliverGridDelegateWithFixedCrossAxisCount(
                                          crossAxisCount: 3),
                                  itemCount:
                                      state.boardGame!.cellCountForGridView,
                                  itemBuilder: (context, index) {
                                    final cellIndex = (index + 3) % 6 == 0
                                        ? index + 2
                                        : (index + 1) % 6 == 0
                                            ? index - 2
                                            : index;

                                    final length =
                                        state.boardGame!.cells.length;

                                    if (cellIndex >= length) {
                                      return SizedBox();
                                    }

                                    return Stack(
                                      children: [
                                        Padding(
                                          padding: const EdgeInsets.all(4.0),
                                          child: GlassWidget(
                                            padding: EdgeInsets.all(12),
                                            child: Center(
                                              child: SvgPicture.asset(
                                                state.boardGame!
                                                    .cells[cellIndex].iconPath,
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (!(((cellIndex + 3) % 6 == 0) ||
                                            ((cellIndex + 4) % 6 == 0)))
                                          Positioned.fill(
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerRight,
                                                  child: Container(
                                                    color: Colors.black,
                                                    width: 4,
                                                    height: 3,
                                                  ))),
                                        if (!(((cellIndex) % 6 == 0) ||
                                            ((cellIndex + 1) % 6 == 0)))
                                          Positioned.fill(
                                              child: Align(
                                                  alignment:
                                                      Alignment.centerLeft,
                                                  child: Container(
                                                    color: Colors.black,
                                                    width: 4,
                                                    height: 3,
                                                  ))),
                                        if ((cellIndex + 1) % 3 == 0)
                                          Positioned.fill(
                                              child: Align(
                                                  alignment:
                                                      Alignment.bottomCenter,
                                                  child: Container(
                                                    color: Colors.black,
                                                    width: 4,
                                                    height: 3,
                                                  ))),
                                        if ((cellIndex) % 3 == 0 &&
                                            cellIndex != 0)
                                          Positioned.fill(
                                              child: Align(
                                                  alignment:
                                                      Alignment.topCenter,
                                                  child: Container(
                                                    color: Colors.black,
                                                    width: 4,
                                                    height: 3,
                                                  )))
                                      ],
                                    );
                                  }),
                            );
                          },
                        )),
                        ScaleTransition(
                          child: const PlayArea(),
                          scale: _controller
                              .drive(CurveTween(curve: Interval(2 / 3, 1.0)))
                              .drive(TweenSequence([
                                TweenSequenceItem(
                                    tween: Tween(begin: 0.0, end: 1.3),
                                    weight: 0.7),
                                TweenSequenceItem(
                                    tween: Tween(begin: 1.3, end: 1.0),
                                    weight: 0.3)
                              ])),
                        )
                      ],
                    ),
                  ),
                ),
                const DiceView()
              ],
            ),
          ),
        ),
      ],
    );
  }

  void _displayOverlay(BuildContext context, CurrentGameState state,
      double maxWidth, double maxHeight) async {
    OverlayState overlayState = Overlay.of(context)!;
    OverlayEntry overlayEntry = OverlayEntry(
        builder: (context) => Positioned(
            child: PlayerOverlayAnimated(player: state.currentPlayer!),
            width: maxWidth,
            height: maxHeight));
    overlayState.insert(overlayEntry);
    await Future.delayed(Duration(milliseconds: 2000));
    overlayEntry.remove();
  }

  void _displayBottomSheet(BuildContext context, CurrentGameState state) {
    final currentPlayerState = state.currentPlayer!.state;
    Widget content = const SizedBox();
    switch (currentPlayerState) {
      case PlayerState.choseOpponent:
        {
          content = ChoseOpponentListView(
              callback: (player) =>
                  context.read<CurrentGameBloc>().add(PickOpponent(player)),
              playerList: state.playerList
                  .where((element) => state.currentPlayer != element)
                  .toList());
          break;
        }
      case PlayerState.chosePlayerMoving:
        {
          final cells = state.boardGame!.cells,
              moving = state.currentCell!.moving!,
              movingCount = moving.movingType == MovingType.forward
                  ? moving.count
                  : -moving.count,
              playerList = state.playerListAbleToMove();

          if (playerList.isNotEmpty)
            content = ChoseOpponentListView(
                contentCallback: (player) => Text(
                    "Effets : ${cells[player.idCurrentCell + movingCount].effectsLabel}",
                    style: Theme.of(context).textTheme.bodyText1),
                playerList: playerList,
                callback: (player) => context
                    .read<CurrentGameBloc>()
                    .add(MakePlayerMoving(player)));
          break;
        }
      case PlayerState.stealConditionKey:
        {
          final playerHavingConditionKey = state.playerListAbleToBeStolen();
          if (playerHavingConditionKey.isNotEmpty)
            content = ChoseOpponentListView(
                playerList: playerHavingConditionKey,
                callback: (player) => context
                    .read<CurrentGameBloc>()
                    .add(StealConditionKey(player)));
          break;
        }
      default:
        {
          content = const SizedBox();
          break;
        }
    }
    if (!(content is SizedBox))
      showModalBottomSheet(
          isDismissible: false,
          barrierColor: Colors.black.withOpacity(0.2),
          context: context,
          builder: (context) => AppBottomSheet(child: content));
  }
}
