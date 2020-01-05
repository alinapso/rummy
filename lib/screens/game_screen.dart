import 'package:flutter/material.dart';
import 'package:rummy/models/player.dart';
import 'package:rummy/widgets/ShowAlertBox.dart';
import '../models/round.dart';
import 'add_round.dart';
import 'menu.dart';

class GameScreen extends StatefulWidget {
  final List<Player> players;
  GameScreen(this.players, {Key key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState(players);
}

class _GameScreenState extends State<GameScreen> {
  List<Player> players;
  List<TableRow> roundsTable;
  List<Round> rounds;
  List<Widget> scoreRow;
  List<int> scores;
  _GameScreenState(this.players) {
    init();
    createScoreRow();
  }
  init() {
    roundsTable = new List();
    scoreRow = new List();
    scores = new List();
    rounds = new List();
  }

  createScoreRow() {
    for (int i = 0; i < players.length; i++) {
      scores.add(0);
    }
  }

  renderScoresTable() {
    roundsTable.clear();
    roundsTable.add(createTitle());
    rounds.forEach((r) => {roundsTable.add(createRoundRow(r))});
  }

  TableRow createRoundRow(Round round) {
    List<TableCell> cells = new List();
    round.points.forEach((r) => {
          cells.add(TableCell(
            child: Container(
              decoration: BoxDecoration(color: Colors.green),
              height: 50.0,
              child: Center(
                child: Text(
                  r.toString(),
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
          ))
        });
    return TableRow(children: cells);
  }

  renderScoreRow() {
    scoreRow.clear();
    for (int i = 0; i < players.length; i++) {
      scoreRow.add(createScoreElement(scores[i]));
    }
  }

  Widget createScoreElement(int score) {
    return Expanded(
      child: Center(
        child: Text(
          score.toString(),
          style: TextStyle(fontSize: 25),
        ),
      ),
    );
  }

  TableRow createTitle() {
    List<TableCell> cells = new List();
    players.forEach((p) => {
          cells.add(TableCell(
            child: Container(
              decoration: BoxDecoration(color: Colors.grey),
              height: 50.0,
              child: Center(
                child: Text(
                  p.name,
                  style: TextStyle(fontSize: 25),
                ),
              ),
            ),
          ))
        });
    return TableRow(children: cells);
  }

  _navigateAndDisplaySelection(BuildContext context) async {
    // Navigator.push returns a Future that completes after calling
    // Navigator.pop on the Selection Screen.
    Round result = await Navigator.push(
      context,
      // Create the SelectionScreen in the next step.
      MaterialPageRoute(builder: (context) => AddRound(this.players)),
    );

    setState(() {
      rounds.add(result);
    });
  }

  @override
  Widget build(BuildContext context) {
    renderScoresTable();
    renderScoreRow();
    return WillPopScope(
      child: Scaffold(
        body: SizedBox.expand(
          child: Padding(
            padding: const EdgeInsets.symmetric(vertical: 24.0),
            child: Column(
              children: <Widget>[
                Container(
                    child: SingleChildScrollView(
                        child: Table(children: roundsTable))),
                Container(
                  child: Row(
                    children: scoreRow,
                  ),
                  height: 60,
                )
              ],
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
          Navigator.push(
            context,
            // Create the SelectionScreen in the next step.
            MaterialPageRoute(builder: (context) => Menu()),
          );
          return;
        });

        return new Future(() => false);
      },
    );
  }
}
