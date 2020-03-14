import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart';

final String connErrorMsg = 'Connection Failed';

snackbar(text, BuildContext context, _scaffoldKey, {seconds = 5}) {
  final snack =
      SnackBar(content: Text(text), duration: Duration(seconds: seconds));
  _scaffoldKey.currentState.removeCurrentSnackBar();
  _scaffoldKey.currentState.showSnackBar(snack);
}

alert(context, {title = '', content}) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      // return object of type Dialog
      return AlertDialog(
        title: Text(title),
        content: Text(content),
        /* actions: <Widget>[
            // usually buttons at the bottom of the dialog
            new FlatButton(
              child: new Text("Close"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ], */
      );
    },
  );
}

request(Response response, Function action, context, GlobalKey _scaffoldKey) {
  print(response.statusCode);
  var body = json.decode(response.body);
  //print(body);

  if (response.statusCode == 422) {
    var errors = '';
    body['errors'].forEach((error, data) => errors += '${data[0]}\n');
    return snackbar(errors, context, _scaffoldKey);
  }
  if (response.statusCode == 200) {
    if (body.containsKey('error')) {
      return snackbar(body['error'], context, _scaffoldKey);
    }
    if (body.containsKey('success')) {
      return snackbar(body['success'], context, _scaffoldKey);
    }
    action();
  } else {
    print(body);
    return snackbar(
        'An error occured, Please try later.', context, _scaffoldKey);
  }
}
