import 'dart:async';
import 'dart:math';

import 'package:avatar_glow/avatar_glow.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/blocs/current_game/current_game_bloc.dart';
import 'package:studrink/blocs/nav/nav_bloc.dart';
import 'package:studrink/models/cell.dart';
import 'package:studrink/models/moving.dart';
import 'package:studrink/models/player.dart';
import 'package:studrink/navigators/widgets/back_btn_wrapper.dart';
import 'package:studrink/pages/my_custom_page.dart';
import 'package:studrink/utils/studrink_utils.dart';
import 'package:studrink/widgets/bottom_sheet/app_bottom_sheet.dart';
import 'package:studrink/widgets/bottom_sheet/chose_opponent_list_view.dart';
import 'package:studrink/widgets/card_cell_v3.dart';
import 'package:studrink/widgets/dice_view.dart';
import 'package:studrink/widgets/grid/grid_cell.dart';
import 'package:studrink/widgets/player_area/play_area.dart';
import 'package:studrink/widgets/player_avatar.dart';
import 'package:studrink/widgets/player_overlay.dart';
import 'package:tuple/tuple.dart';

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
  late List<GlobalKey> _cellKeys = List.generate(
    context.read<CurrentGameBloc>().state.boardGame!.cellCount,
    (index) => GlobalKey(),
  );

  final StreamController<Tuple2<int, Rect>?> _focusSubject =
      StreamController();
  late final _controller =
      AnimationController(vsync: this, duration: Duration(milliseconds: 900))
        ..forward();
  late final _gridController = ScrollController();
  late double _cellSize;

  @override
  void initState() {
    super.initState();
    context
        .read<CurrentGameBloc>()
        .add(InitGameAnimationController(_controller));
  }

  Future<void> _expandCell(int idCell, CurrentGameState state) async {
    _focusSubject.add(null);
    await Future.delayed(Duration(milliseconds: 200));
    final row = idCell ~/ 3;
    final mediaData = MediaQuery.of(context);
    final size = mediaData.size;
    final topPadding = mediaData.viewPadding.top;
    final bodyHeight = size.height - topPadding - kToolbarHeight;

    var offset =
        row * (_cellSize * 5 / 4) - (bodyHeight / 2 - (_cellSize * 5 / 4));
    offset = min(max(offset, 0), _gridController.position.maxScrollExtent);
    const duration = Duration(milliseconds: 300);

    if (_gridController.offset == offset) {
      await Future.delayed(duration);
    } else {
      await _gridController.animateTo(offset,
          duration: duration, curve: Curves.ease);
    }
    //todo mettre boutton du bas au dessus de la case hover
    RenderBox box =
        _cellKeys[idCell].currentContext!.findRenderObject()! as RenderBox;
    final paintBounds = box.paintBounds;
    final position = box.localToGlobal(Offset.zero);
    _focusSubject.add(Tuple2(
        idCell,
        Rect.fromLTWH(
            position.dx, position.dy, paintBounds.width, paintBounds.height)));
  }

  @override
  Widget build(BuildContext context) {
    const horizontalPadding = 8.0;
    final mediaData = MediaQuery.of(context);
    final size = mediaData.size, glowSize = 70.0;
    _cellSize = (size.width - (horizontalPadding * 2)) / 3;

    return Stack(
      children: [
        Scaffold(
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
          body: Stack(
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
                  listener: (context, state) =>
                      _displayOverlay(context, state, size.width, size.height),
                  child: BlocConsumer<CurrentGameBloc, CurrentGameState>(
                    listenWhen: (previous, current) {
                      final previousPlayer = previous.currentPlayer;
                      final currentPlayer = current.currentPlayer;
                      final idPreviousCell = previousPlayer!.idCurrentCell;
                      final previousCell =
                          current.boardGame!.cells[idPreviousCell];

                      final justHadPickedOtherMoving =
                          previousCell.cellType == CellType.otherMoving &&
                              previousPlayer.id != currentPlayer?.id &&
                              currentPlayer!.idCurrentCell != 0;

                      return (previousPlayer.id != currentPlayer?.id ||
                              previousPlayer.idCurrentCell !=
                                  currentPlayer?.idCurrentCell) &&
                          !justHadPickedOtherMoving;
                    },
                    listener: (context, state) =>
                        _expandCell(state.currentPlayer!.idCurrentCell, state),
                    builder: (context, state) {
                      return Padding(
                        padding: EdgeInsets.only(
                            top: 16,
                            left: horizontalPadding,
                            right: horizontalPadding),
                        child: CustomScrollView(
                          controller: _gridController,
                          slivers: [
                            SliverGrid(
                                delegate: SliverChildBuilderDelegate(
                                    (context, index) {
                                  final cellIndex = gridIndex(index);
                                  final length = state.boardGame!.cellCount;
                                  if (cellIndex >= length) return SizedBox();

                                  final current =
                                      state.currentPlayer!.idCurrentCell ==
                                          cellIndex;
                                  final cell =
                                      state.boardGame!.cells[cellIndex];
                                  return LayoutBuilder(
                                    builder: (context, constraints) =>
                                        GestureDetector(
                                      onTap: () =>
                                          _expandCell(cellIndex, state),
                                      child: GridCell(
                                          glassKey: _cellKeys[cellIndex],
                                          constraints: constraints,
                                          cellIndex: cellIndex,
                                          cell: cell,
                                          playerList: state
                                              .playerListFromIdCell(cellIndex),
                                          current: current),
                                    ),
                                  );
                                },
                                    childCount:
                                        state.boardGame!.cellCountForGridView),
                                gridDelegate:
                                    SliverGridDelegateWithFixedCrossAxisCount(
                                        crossAxisCount: 3,
                                        childAspectRatio: 4 / 5))
                          ],
                        ),
                      );
                    },
                  ),
                ),
              ),
              Positioned.fill(
                bottom: MediaQuery.of(context).viewPadding.bottom,
                child: Align(
                  alignment: Alignment.bottomCenter,
                  child: ScaleTransition(
                    child: const PlayArea(),
                    scale: _controller
                        .drive(CurveTween(curve: Interval(2 / 3, 1.0)))
                        .drive(TweenSequence([
                          TweenSequenceItem(
                              tween: Tween(begin: 0.0, end: 1.3), weight: 0.7),
                          TweenSequenceItem(
                              tween: Tween(begin: 1.3, end: 1.0), weight: 0.3)
                        ])),
                  ),
                ),
              )
            ],
          ),
        ),
        Positioned.fill(
            child: Align(
          alignment: Alignment.topCenter,
          child: BlocSelector<CurrentGameBloc, CurrentGameState, Player>(
              selector: (state) => state.currentPlayer!,
              builder: (context, currentPlayer) => AvatarGlow(
                  glowColor: currentPlayer.color,
                  child: PlayerAvatar(
                    player: currentPlayer,
                    size: 60,
                  ),
                  endRadius: glowSize)),
        )),
        StreamBuilder<Tuple2<int, Rect>?>(
            stream: _focusSubject.stream,
            builder: (context, snapshot) =>
                JeSaisPas(cellTuple: snapshot.data)),
        const DiceView(),
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
                    style: Theme.of(context).textTheme.bodyMedium),
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
