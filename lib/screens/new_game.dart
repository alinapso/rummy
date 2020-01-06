import 'package:flutter/material.dart';
import 'package:rummy/models/add_player_controller.dart';
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
  List<AddPlayerContoller> controllers;
  _NewGameState() {
    players = new List<Player>();
    fields = new List();
    controllers = new List();
    fields.add(generateField(0));
  }

  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    // Clean up the focus node when the Form is disposed.

    super.dispose();
  }

  Widget generateField(int position) {
    controllers.add(new AddPlayerContoller());
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
        autofocus: true,
        focusNode: controllers[controllers.length - 1].focus,
        controller: controllers[controllers.length - 1].txt,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (term) {
          controllers[position].focus.unfocus();
          if (controllers.length - 1 < position)
            FocusScope.of(context)
                .requestFocus(controllers[position + 1].focus);
        });
  }

  // The Names are not been deleted becouse are saved by the form it self and not the elements!
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Center(child: const Text("Fill all players names")),
      ),
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
                        Builder(
                          builder: (BuildContext context) {
                            return ListView.builder(
                              scrollDirection: Axis.vertical,
                              shrinkWrap: true,
                              itemCount: fields.length,
                              itemBuilder: (BuildContext context, int postion) {
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
                                          controllers.removeAt(postion);
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  players.clear();
                                  _formKey.currentState.save();
                                  Navigator.pushReplacement(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) =>
                                            GameScreen(players),
                                      ));
                                } else
                                  print(_formKey.currentState.validate());
                              },
                              child: Text('Submit'),
                            ),
                            RaisedButton(
                              onPressed: () {
                                setState(() {
                                  fields.add(generateField(controllers.length));
                                  FocusScope.of(context).requestFocus(
                                      controllers[controllers.length - 1]
                                          .focus);
                                });
                              },
                              child: Text('Add New Player'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  )),
            ],
            mainAxisAlignment: MainAxisAlignment.center,
          ),
        ),
      ),
    );
  }
}
