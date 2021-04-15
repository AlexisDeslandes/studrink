import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/widgets/base_screen.dart';

class FinishGamePage extends CupertinoPage {
  const FinishGamePage()
      : super(
            key: const ValueKey("/finish_game"),
            child: const FinishGameScreen());
}

class FinishGameScreen extends StatefulWidget {
  const FinishGameScreen();

  @override
  State<StatefulWidget> createState() => FinishGameScreenState();
}

class FinishGameScreenState extends BaseScreenState {

  @override
  String get subTitle => "";

  @override
  String get title => "Jeux terminé";

  @override
  Widget body(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: BlocBuilder<CurrentGameBloc, CurrentGameState>(
        buildWhen: (previous, current) => false,
        builder: (context, state) {
          final winner = state.winner!;
          return Column(
            children: [
              Expanded(
                  child: Center(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    SizedBox(
                      width: size.width / 3,
                      height: size.width / 3,
                      child: Material(
                        elevation: 5,
                        borderRadius: BorderRadius.circular(100),
                        child: ClipOval(
                            child: winner.avatar != null
                                ? Image.memory(winner.avatar!)
                                : Container(
                                    color: winner.color,
                                    width: 30,
                                    height: 30)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text("${winner.name} a gagné.",
                          style: Theme.of(context).textTheme.bodyText2),
                    )
                  ],
                ),
              )),
              Expanded(
                  child: Center(
                      child: ElevatedButton(
                          child: Text("Accueil"),
                          onPressed: () {
                            context.read<CurrentGameBloc>().add(ResetGame());
                            context.read<NavBloc>().add(const ResetNavToHome());
                          })))
            ],
          );
        },
      ),
    );
  }
}
