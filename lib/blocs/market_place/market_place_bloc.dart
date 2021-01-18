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

class MarketPlaceState extends Equatable {
  final List<BoardGame> boardGameList;

  const MarketPlaceState({this.boardGameList = const []});

  @override
  List<Object> get props => [];
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
