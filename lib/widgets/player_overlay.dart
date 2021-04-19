
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:ptit_godet/models/player.dart';

class PlayerOverlayAnimated extends StatefulWidget {
  const PlayerOverlayAnimated({required this.player});

  final Player player;

  @override
  _PlayerOverlayAnimatedState createState() => _PlayerOverlayAnimatedState();
}

class _PlayerOverlayAnimatedState extends State<PlayerOverlayAnimated>
    with SingleTickerProviderStateMixin {
  late final AnimationController _animationController;
  late final Animation<Offset> _slideAnimation;
  late final Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
        vsync: this, duration: Duration(milliseconds: 1300));
    _slideAnimation = _animationController
        .drive(Tween(begin: Offset(0.0, 0.2), end: Offset(0.0, -0.2)));
    _fadeAnimation = _animationController.drive(TweenSequence([
      TweenSequenceItem(tween: Tween(begin: 0.0, end: 1.0), weight: 0.5),
      TweenSequenceItem(tween: Tween(begin: 1.0, end: 0.0), weight: 0.5)
    ]));
    _animationController.forward();
  }

  @override
  void dispose() {
    _animationController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final size = MediaQuery.of(context).size.width * 1 / 2;
    return Center(
        child: SlideTransition(
      position: _slideAnimation,
      child: FadeTransition(
          opacity: _fadeAnimation,
          child: PlayerOverlay(size: size, player: widget.player)),
    ));
  }
}

class PlayerOverlay extends StatelessWidget {
  const PlayerOverlay({Key? key, required this.size, required this.player})
      : super(key: key);

  final Player player;
  final double size;

  @override
  Widget build(BuildContext context) {
    return Card(
        key: ValueKey(player.name),
        elevation: 3,
        shape:
            RoundedRectangleBorder(borderRadius: BorderRadius.circular(100.0)),
        child: Padding(
          padding: const EdgeInsets.only(
              left: 3.0, top: 3.0, right: 25.0, bottom: 3.0),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: player.color,
                  borderRadius: BorderRadius.circular(100.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      player.name,
                      style: Theme.of(context)
                          .textTheme
                          .headline2!
                          .copyWith(fontSize: 18),
                    ),
                    Text("C'est ton tour",
                        style: Theme.of(context).textTheme.bodyText1!.copyWith(
                            fontWeight: FontWeight.w300,
                            fontSize: 12.0,
                            color: Colors.black.withOpacity(0.6))),
                  ],
                ),
              )
            ],
          ),
        ));
  }
}
