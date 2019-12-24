import 'package:rummy/models/player.dart';
import 'package:rummy/models/round.dart';

class Game {
  List<Player> players;
  List<Round> rounds;
  int maxRoundsCount;
  Game(this.maxRoundsCount, this.players, {this.rounds}) {
    assert(maxRoundsCount > 0);
    assert(players.length >= 2);
    if (rounds == null) rounds = new List();
  }
}
