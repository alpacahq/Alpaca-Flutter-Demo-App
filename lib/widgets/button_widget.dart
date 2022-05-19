// Code taken from:
//https://github.com/JohannesMilke/textformfield_example/blob/master/lib/widget/button_widget.dart

import 'package:flutter/material.dart';

class ButtonWidget extends StatelessWidget {
  final String text;
  final VoidCallback onClicked;

  const ButtonWidget({
    required this.text,
    required this.onClicked,
    Key? key,
  }) : super(key: key);

  @override
  // ignore: deprecated_member_use
  Widget build(BuildContext context) => RaisedButton(
        child: Text(
          text,
          style: const TextStyle(fontSize: 24),
        ),
        shape: const StadiumBorder(),
        color: Theme.of(context).primaryColor,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
        textColor: Colors.white,
        onPressed: onClicked,
      );
}