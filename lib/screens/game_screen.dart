import 'package:flutter/material.dart';
import 'package:rummy/models/player.dart';
import 'package:rummy/widgets/ShowAlertBox.dart';
import '../models/round.dart';
import 'add_round.dart';
import 'menu.dart';
import '../widgets/score_table_row.dart';

class GameScreen extends StatefulWidget {
  final List<Player> players;
  GameScreen(this.players, {Key key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState(players);
}

class _GameScreenState extends State<GameScreen> {
  List<Player> players;
  List<Widget> table;
  List<Round> rounds;

  _GameScreenState(this.players) {
    init();
  }
  init() {
    table = new List();
    rounds = new List();
  }

  Widget createTitle() {
    List<String> values = new List();
    players.forEach((p) => {values.add(p.name)});
    return ScoreTableRow(
      values,
      -1,
      backgroundColor: Colors.orangeAccent,
      textColor: Colors.white,
    );
  }

  Widget createScoreRow() {
    List<String> values = new List();
    List<int> scores = new List();
    for (int i = 0; i < players.length; i++) {
      int score = players[i].score - 100 * players[i].wins;
      values.add(score.toString());
      scores.add(score);
    }
    return ScoreTableRow(
      values,
      _findWinner(scores),
      text: "סהכ",
    );
  }

  renderTable() {
    //Clear players score for recalculation
    for (int i = 0; i < players.length; i++) players[i].clear();
    //Clear table score for recalculation
    table.clear();
    //recreate table score

    for (int i = 0; i < rounds.length; i++) {
      table.add(InkWell(
        onDoubleTap: () {
          _navigateAndDisplaySelection(context, round: rounds[i], roundId: i);
        },
        child: ScoreTableRow(
            _calcScore(rounds[i]), _findWinner(rounds[i].points),
            text: (i + 1).toString()),
      ));
    }
  }

  int _findWinner(List<int> scores) {
    int winner = -1;
    bool tie = false;
    int winnerTemp = 99999;
    for (int i = 0; i < scores.length; i++) {
      if (scores[i] == winnerTemp)
        tie = true;
      else if (scores[i] < winnerTemp) {
        winner = i;
        winnerTemp = scores[i];
      }
    }
    if (tie) return -1;
    return winner;
  }

  List<String> _calcScore(Round r) {
    for (int i = 0; i < players.length; i++) {
      players[i].score += (r.points[i] * r.multi).round();
      if (r.points[i] < 0) {
        players[i].wins++;
      }
    }

    return convertToString();
  }

  _navigateAndDisplaySelection(BuildContext context,
      {Round round, int roundId}) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    Round result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(
          builder: (context) => AddRound(
                this.players,
                round: round,
              )),
    );

    setState(() {
      if (result != null && round != null) {
        rounds[roundId] = result;
      } else if (result != null) rounds.add(result);
    });
  }

  List<String> convertToString() {
    List<String> strs = new List();
    players.forEach((p) => {strs.add(p.score.toString())});
    return strs;
  }

  @override
  Widget build(BuildContext context) {
    renderTable();

    return WillPopScope(
      child: Scaffold(
        appBar: AppBar(
          title: Center(child: const Text("lets go!")),
        ),
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Container(
              //color: Colors.grey[300],
              child: Column(
                children: <Widget>[
                  createTitle(),
                  Container(
                    height: 4,
                    color: Colors.black38,
                  ), //make this not rendering every time
                  ConstrainedBox(
                    constraints: new BoxConstraints(
                      maxHeight: MediaQuery.of(context).size.height - 200.0,
                    ),
                    child: SingleChildScrollView(
                      child: Column(
                        children: table,
                      ),
                    ),
                  ),
                  Container(
                    height: 4,
                    color: Colors.black38,
                  ),
                  createScoreRow(),
                ],
              ),
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton(
          onPressed: () {
            _navigateAndDisplaySelection(context);
          },
          tooltip: 'Add New Round',
          child: const Icon(Icons.add),
        ),
      ),
      onWillPop: () {
        showAlertDialog(context, "Would you like to end this game?", () {
          Navigator.pushReplacement(
              context,
              // Create the SelectionScreen in the next step.
              MaterialPageRoute(
                builder: (context) => Menu(),
              ));
          return;
        });

        return new Future(() => false);
      },
    );
  }
}
