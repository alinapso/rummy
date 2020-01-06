import 'package:flutter/material.dart';

class ScoreTableRow extends StatelessWidget {
  final List<String> values;
  final String text;
  final int winner;
  final Color backgroundColor;
  final Color textColor;
  const ScoreTableRow(this.values, this.winner,
      {Key key, this.text, this.backgroundColor, this.textColor})
      : super(key: key);

  @override
  Widget build(BuildContext context) {
    List<Widget> cells = new List();
    for (int i = 0; i < values.length; i++) {
      cells.add(createScoreElement(values[i], i == winner,
          backgroundColor: backgroundColor, textColor: textColor));
    }
    return Container(
      child: Row(
        children: <Widget>[
          Expanded(
            child: Container(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 1),
                child: Row(
                  children: cells,
                ),
              ),
            ),
          ),
          Container(
            width: 30.0,
            child: Center(
              child: Text(text != null ? text.toString() : ""),
            ),
          )
        ],
      ),
    );
  }
}

Widget createScoreElement(String score, bool winner,
    {Color backgroundColor, Color textColor}) {
  return Expanded(
    child: Padding(
      padding: const EdgeInsets.only(left: 1, right: 1),
      child: Container(
        color: (winner)
            ? Colors.green
            : (backgroundColor != null) ? backgroundColor : Colors.white,
        child: Center(
          child: Text(
            score,
            style: TextStyle(fontSize: 25, color: textColor),
          ),
        ),
      ),
    ),
  );
}
