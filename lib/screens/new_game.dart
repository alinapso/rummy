import 'package:flutter/material.dart';
import 'package:rummy/models/player.dart';
import 'package:rummy/screens/game_screen.dart';

class NewGame extends StatefulWidget {
  NewGame({Key key}) : super(key: key);

  @override
  _NewGameState createState() => _NewGameState();
}

class _NewGameState extends State<NewGame> {
  final _formKey = GlobalKey<FormState>();
  List<Widget> fields;
  List<Player> players;
  _NewGameState() {
    players = new List<Player>();
    fields = new List();
    print(players);
    fields.add(generateField());
  }
  Widget generateField() {
    return Container(
      child: TextFormField(
        decoration: const InputDecoration(
          hintText: 'Enter Player Name',
        ),
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          return null;
        },
        onSaved: (input) => {players.add(Player(input))},
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: SingleChildScrollView(
            child: Column(
              children: <Widget>[
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: <Widget>[
                      Column(
                        children: fields,
                      ),
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 16.0),
                        child: Center(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              RaisedButton(
                                onPressed: () {
                                  if (_formKey.currentState.validate()) {
                                    _formKey.currentState.save();
                                    Navigator.push(
                                        context,
                                        MaterialPageRoute(
                                          builder: (context) =>
                                              GameScreen(players),
                                        ));
                                  }
                                },
                                child: Text('Submit'),
                              ),
                              RaisedButton(
                                onPressed: () {
                                  setState(() {
                                    fields.add(generateField());
                                  });
                                },
                                child: Text('Add New Player'),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
              mainAxisAlignment: MainAxisAlignment.center,
            ),
          ),
        ),
      ),
    );
  }
}
