import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rummy/screens/new_game.dart';
import 'package:rummy/widgets/ShowAlertBox.dart';

class Menu extends StatefulWidget {
  Menu({Key key}) : super(key: key);

  @override
  _MenuState createState() => _MenuState();
}

class _MenuState extends State<Menu> {
  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      child: Scaffold(
        body: SizedBox.expand(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: <Widget>[
              FlatButton(
                child: Text("Start New Game!"),
                onPressed: () {
                  //need to be replecet sense in the next screen there will be no menu to come to
                  Navigator.pushReplacement(
                      context,
                      MaterialPageRoute(
                        builder: (context) => NewGame(),
                      ));
                },
              )
            ],
          ),
        ),
      ),
      onWillPop: () {
        showExitDialog(context, "Are you sure you want to exit?", () {
          SystemChannels.platform.invokeMethod('SystemNavigator.pop');
          return;
        });

        return;
      },
    );
  }
}
