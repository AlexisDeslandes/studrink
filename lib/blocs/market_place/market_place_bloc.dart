import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:studrink/models/board_game.dart';
import 'package:studrink/widgets/my_choice_chip.dart';

class MarketPlaceBloc extends Bloc<MarketPlaceEvent, MarketPlaceState> {
  final AssetBundle assetBundle;

  MarketPlaceBloc({AssetBundle? assetBundle})
      : this.assetBundle = assetBundle ?? rootBundle,
        super(const MarketPlaceEmpty());

  @override
  Stream<MarketPlaceState> mapEventToState(MarketPlaceEvent event) async* {
    if (event is InitMarketPlace) {
      yield await _initMarketPlace();
    } else if (event is ChangeMarketSort) {
      yield MarketPlaceState.copy(state, selectedSort: event.sort);
    } else if (event is SearchMarket) {
      yield MarketPlaceState.copy(state, search: event.search);
    } else if (event is ChoseBoardGame) {
      yield MarketPlaceState.copy(state, chosenBoardGame: event.boardGame);
    }
  }

  Future<MarketPlaceState> _initMarketPlace() async {
    final gamesAsString =
        await assetBundle.loadString("assets/games/games.json");
    final List<Map<String, dynamic>> gamesAsJson =
        (jsonDecode(gamesAsString) as List<dynamic>)
            .cast<Map<String, dynamic>>();
    final boardGameList =
        gamesAsJson.map((json) => BoardGame.fromJson(json)).toList();
    return MarketPlaceState(boardGameList: boardGameList);
  }
}

extension MarketSortExtension on MarketSort {
  String get description {
    switch (this) {
      case MarketSort.TOP:
        return "Top";
      case MarketSort.EVENT:
        return "Events";
      case MarketSort.NEW:
        return "Nouveaux";
      default:
        return "Top";
    }
  }

  MyChoiceChipPosition get position {
    switch (this) {
      case MarketSort.TOP:
        return MyChoiceChipPosition.LEFT;
      case MarketSort.EVENT:
        return MyChoiceChipPosition.MID;
      case MarketSort.NEW:
        return MyChoiceChipPosition.RIGHT;
    }
  }
}

enum MarketSort { TOP, EVENT, NEW }

class MarketPlaceState extends Equatable {
  final List<BoardGame> boardGameList;
  final MarketSort selectedSort;
  final String searchWord;
  final BoardGame? chosenBoardGame;

  const MarketPlaceState(
      {this.boardGameList = const [],
      this.selectedSort = MarketSort.TOP,
      this.searchWord = "",
      this.chosenBoardGame});

  MarketPlaceState.copy(MarketPlaceState old,
      {List<BoardGame>? boardGameList,
      MarketSort? selectedSort,
      String? search,
      BoardGame? chosenBoardGame})
      : this(
            boardGameList: boardGameList ?? old.boardGameList,
            selectedSort: selectedSort ?? old.selectedSort,
            searchWord: search ?? old.searchWord,
            chosenBoardGame: chosenBoardGame ?? old.chosenBoardGame);

  List<BoardGame> get boardGameListTreated {
    final searchList = [..._listContainingSearchWord];
    switch (selectedSort) {
      case MarketSort.NEW:
        return searchList..sort((a, b) => a.date.compareTo(b.date));
      case MarketSort.EVENT:
        return searchList
          ..sort((a, b) {
            if (a.event == b.event) {
              return 0;
            } else if (a.event && !b.event) {
              return -1;
            } else {
              return 1;
            }
          });
      case MarketSort.TOP:
      default:
        return searchList;
    }
  }

  @override
  List<Object?> get props =>
      [boardGameList, selectedSort, searchWord, chosenBoardGame];

  List<BoardGame> get _listContainingSearchWord {
    if (searchWord.isEmpty) {
      return this.boardGameList;
    }
    return boardGameList
        .where((element) =>
            element.name.toLowerCase().contains(searchWord.toLowerCase()))
        .toList();
  }
}

class MarketPlaceEmpty extends MarketPlaceState {
  const MarketPlaceEmpty();
}

class MarketPlaceEvent {
  const MarketPlaceEvent();
}

class InitMarketPlace extends MarketPlaceEvent {
  const InitMarketPlace();
}

class ChangeMarketSort extends MarketPlaceEvent {
  final MarketSort sort;

  const ChangeMarketSort(this.sort);
}

class SearchMarket extends MarketPlaceEvent {
  final String search;

  const SearchMarket(this.search);
}

class ChoseBoardGame extends MarketPlaceEvent {
  final BoardGame boardGame;

  const ChoseBoardGame(this.boardGame);
}
