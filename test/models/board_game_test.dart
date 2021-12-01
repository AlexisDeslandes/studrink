import 'package:flutter_test/flutter_test.dart';
import 'package:studrink/models/board_game.dart';

import '../test_utils/utils.dart';

void main() {
  test("Build a boardGame with text code.", () {
    const textCode = SdTestUtils.boardGameString;
    final boardGame = BoardGame.fromCode(textCode.trim());
  });
}
