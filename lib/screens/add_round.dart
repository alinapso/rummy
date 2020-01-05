import 'package:flutter/material.dart';

import '../models/player.dart';
import '../models/round.dart';

class AddRound extends StatelessWidget {
  final List<Player> players;
  AddRound(this.players);
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Pick an option'),
      ),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: RaisedButton(
                onPressed: () {
                  Navigator.pop(context, new Round(<int>[0, 0, 0, 0], 1));
                },
                child: Text('Yep!'),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
