import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/models/board_game.dart';

class MarketPlaceBloc extends Bloc<MarketPlaceEvent, MarketPlaceState> {
  final AssetBundle assetBundle;

  MarketPlaceBloc({AssetBundle assetBundle})
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
    }
  }

  Future<MarketPlaceState> _initMarketPlace() async {
    final gamesAsString =
        await assetBundle.loadString("assets/games/games.json");
    final List<Map<String, dynamic>> gamesAsJson =
        (jsonDecode(gamesAsString) as List<dynamic>)
            .cast<Map<String, dynamic>>();
    return MarketPlaceState(
        boardGameList:
            gamesAsJson.map((json) => BoardGame.fromJson(json)).toList());
  }
}

extension MarketSortExtension on MarketSort {
  String get description {
    switch (this) {
      case MarketSort.TOP:
        return "Top des jeux";
      case MarketSort.EVENT:
        return "Evénements";
      case MarketSort.NEW:
        return "Nouveaux";
      default:
        return "Top des jeux";
    }
  }
}

enum MarketSort { TOP, EVENT, NEW }

class MarketPlaceState extends Equatable {
  final List<BoardGame> boardGameList;
  final MarketSort selectedSort;
  final String searchWord;

  const MarketPlaceState(
      {this.boardGameList = const [],
      this.selectedSort = MarketSort.TOP,
      this.searchWord = ""});

  MarketPlaceState.copy(MarketPlaceState old,
      {List<BoardGame> boardGameList, MarketSort selectedSort, String search})
      : this(
            boardGameList: boardGameList ?? old.boardGameList,
            selectedSort: selectedSort ?? old.selectedSort,
            searchWord: search ?? old.searchWord);

  List<BoardGame> get boardGameListTreated {
    final searchList = _listContainingSearchWord;
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
  List<Object> get props => [boardGameList, selectedSort, searchWord];

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
