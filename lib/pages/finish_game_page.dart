import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:ptit_godet/blocs/current_game/current_game_bloc.dart';
import 'package:ptit_godet/blocs/nav/nav_bloc.dart';
import 'package:ptit_godet/widgets/no_back_element_screen.dart';

class FinishGamePage extends CupertinoPage {
  const FinishGamePage()
      : super(
            key: const ValueKey("/finish_game"),
            child: const FinishGameScreen());
}

class FinishGameScreen extends NoBackElementScreen {
  const FinishGameScreen();

  @override
  Widget body(BuildContext context) {
    final size = MediaQuery.of(context).size;
    return Container(
      width: size.width,
      height: size.height,
      child: BlocBuilder<CurrentGameBloc, CurrentGameState>(
        buildWhen: (previous, current) => false,
        builder: (context, state) {
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
                        child:
                            ClipOval(child: Image.memory(state.winner.avatar)),
                      ),
                    ),
                    Padding(
                      padding: const EdgeInsets.only(top: 30.0),
                      child: Text("${state.winner.name} est le gagnant.",
                          style: Theme.of(context).textTheme.bodyText2),
                    )
                  ],
                ),
              )),
              Expanded(
                  child: Center(
                      child: RaisedButton(
                child: Text("Accueil"),
                onPressed: () {
                  context.bloc<NavBloc>().add(const ResetNavToHome());
                  context.bloc<CurrentGameBloc>().add(const ResetGame());
                }
              )))
            ],
          );
        },
      ),
    );
  }

  @override
  String titleContent() {
    return "Jeux terminé";
  }
}
