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
    return TextFormField(
      decoration: const InputDecoration(
        hintText: 'Enter Player Name',
      ),
      onSaved: (input) => {players.add(Player(input, players.length))},
      validator: (value) {
        if (value.isEmpty) {
          return 'Please enter some text';
        }
        return null;
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SizedBox.expand(
        child: Padding(
          padding: const EdgeInsets.all(12.0),
          child: Column(
            children: <Widget>[
              Form(
                  key: _formKey,
                  child: Expanded(
                    child: ListView(
                      children: <Widget>[
                        SizedBox(
                          height: MediaQuery.of(context).size.height,
                          child: Builder(
                            builder: (BuildContext context) {
                              return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: fields.length,
                                itemBuilder:
                                    (BuildContext context, int postion) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(
                                        child: fields[postion],
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.cancel),
                                        onPressed: () => {
                                          setState(() {
                                            print(postion);
                                            fields.removeAt(postion);
                                          })
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        )
                      ],
                    ),
                  )),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: <Widget>[
                  RaisedButton(
                    onPressed: () {
                      if (_formKey.currentState.validate()) {
                        players.clear();
                        _formKey.currentState.save();
                        Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => GameScreen(players),
                            ));
                      } else
                        print(_formKey.currentState.validate());
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
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
