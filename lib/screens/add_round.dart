import 'package:flutter/material.dart';
import 'package:rummy/models/add_round_controller.dart';
import 'package:rummy/models/player.dart';
import 'package:rummy/models/round.dart';
import 'package:rummy/widgets/ShowAlertBox.dart';

class AddRound extends StatefulWidget {
  final List<Player> players;
  final Round round;
  AddRound(this.players, {Key key, this.round}) : super(key: key);

  @override
  _AddRoundState createState() => _AddRoundState(players, round: round);
}

class _AddRoundState extends State<AddRound> {
  final Round round;
  final List<Player> players;
  List<AddRoundControler> controllers;
  final _formKey = GlobalKey<FormState>();
  List<Widget> fields;
  int dropdownValue = 100;
  _AddRoundState(this.players, {this.round}) {
    controllers = new List();

    for (int i = 0; i < players.length; i++) {
      controllers.add(new AddRoundControler());
    }
    if (round != null) {
      for (int i = 0; i < players.length; i++) {
        controllers[i].text.text = round.points[i].toString();
        controllers[i].checkd = round.points[i] == -20;
        dropdownValue = (round.multi * 100).round();
      }
    }
  }
  bool isNumeric(String s) {
    if (s == null) {
      return false;
    }
    return int.tryParse(s) != null;
  }

  int getWinnerCount() {
    int winnerCounter = 0;
    for (int i = 0; i < controllers.length; i++) {
      if (controllers[i].checkd) winnerCounter++;
    }
    return winnerCounter;
  }

  Widget generateField(int position) {
    return TextFormField(
        keyboardType: TextInputType.number,
        decoration: const InputDecoration(
          hintText: 'Enter Player score',
        ),
        onSaved: (input) => {},
        validator: (value) {
          if (value.isEmpty) {
            return 'Please enter some text';
          }
          if (!isNumeric(value)) return 'Input must be a number!';
          return null;
        },
        controller: controllers[position].text,
        readOnly: controllers[position].checkd,
        focusNode: controllers[position].focus,
        textInputAction: TextInputAction.done,
        onFieldSubmitted: (term) {
          controllers[position].focus.unfocus();
          if (controllers.length - 1 < position)
            FocusScope.of(context)
                .requestFocus(controllers[position + 1].focus);
        });
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
                        Row(
                          children: <Widget>[
                            Expanded(
                              child: DropdownButton<int>(
                                isExpanded: true,
                                value: dropdownValue,
                                icon: Icon(Icons.arrow_downward),
                                iconSize: 24,
                                elevation: 16,
                                style: TextStyle(color: Colors.deepPurple),
                                underline: Container(
                                  height: 2,
                                  color: Colors.deepPurpleAccent,
                                ),
                                onChanged: (int newValue) {
                                  setState(() {
                                    dropdownValue = newValue;
                                  });
                                },
                                items: <int>[100, 150, 200]
                                    .map<DropdownMenuItem<int>>((int value) {
                                  return DropdownMenuItem<int>(
                                    value: value,
                                    child:
                                        Center(child: Text(value.toString())),
                                  );
                                }).toList(),
                              ),
                            ),
                            Container(
                              width: 120,
                              child: Padding(
                                padding: const EdgeInsets.only(right: 17),
                                child: Text(
                                  "סוג ניצחון",
                                  textAlign: TextAlign.right,
                                ),
                              ),
                            ),
                          ],
                        ),
                        SizedBox(
                          child: Builder(
                            builder: (BuildContext context) {
                              return ListView.builder(
                                scrollDirection: Axis.vertical,
                                shrinkWrap: true,
                                itemCount: players.length,
                                itemBuilder:
                                    (BuildContext context, int postion) {
                                  return Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: <Widget>[
                                      Expanded(child: generateField(postion)),
                                      Container(
                                        child: Text(players[postion].name),
                                        width: 70,
                                        alignment: Alignment(1.0, -1.0),
                                      ),
                                      Checkbox(
                                        value: controllers[postion].checkd,
                                        onChanged: (bool value) {
                                          setState(() {
                                            controllers[postion].checkd = value;
                                            if (value == true)
                                              controllers[postion].text.text =
                                                  "-20";
                                            else
                                              controllers[postion].text.text =
                                                  "";
                                          });
                                        },
                                      ),
                                    ],
                                  );
                                },
                              );
                            },
                          ),
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            RaisedButton(
                              onPressed: () {
                                if (_formKey.currentState.validate()) {
                                  int winnerCount = getWinnerCount();
                                  if (winnerCount == 0) {
                                    showAlertDialog(context,
                                        "Some one need to win the round!");
                                    return;
                                  } else if (winnerCount > 1) {
                                    showAlertDialog(
                                        context, "There could be one winner!");
                                    return;
                                  }
                                  _formKey.currentState.save();
                                  List<int> scores = new List();
                                  controllers.forEach((c) =>
                                      {scores.add(int.parse(c.text.text))});
                                  Navigator.pop(
                                      context,
                                      new Round(
                                          scores,
                                          (double.parse(
                                                  dropdownValue.toString()) /
                                              100.0)));
                                } else
                                  print(_formKey.currentState.validate());
                              },
                              child: Text('Submit'),
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
