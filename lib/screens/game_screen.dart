import 'package:flutter/material.dart';
import 'package:rummy/models/player.dart';

class GameScreen extends StatefulWidget {
  final List<Player> players;
  GameScreen(this.players, {Key key}) : super(key: key);

  @override
  _GameScreenState createState() => _GameScreenState(players);
}

class _GameScreenState extends State<GameScreen> {
  List<Player> players;
  _GameScreenState(this.players);
  TableRow createTitle() {
    List<TableCell> cells = new List();
    players.forEach((p) => {
          cells.add(TableCell(
            child: Text(p.name),
          ))
        });
    return TableRow(children: cells);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: Colors.blue,
      ),
      body: SizedBox.expand(
        child: Text(players.length.toString()),
      ),
    );
  }
}
