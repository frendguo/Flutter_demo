import 'package:flutter/material.dart';

class InputPage extends StatefulWidget {
  @override
  _InputPageState createState() => _InputPageState();
}

class _InputPageState extends State<InputPage> {
  final _controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Please input url'),),
      body: Column(
        children: <Widget>[
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: TextField(
              controller: _controller,
            ),
          ),

          RaisedButton(
            child: Icon(Icons.done),
            onPressed: () => Navigator.pop(context, _controller.text),
          )
        ],
      ),
    );
  }
}