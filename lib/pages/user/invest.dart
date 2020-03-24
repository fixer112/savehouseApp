import 'dart:async';
import 'dart:convert';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_paystack/flutter_paystack.dart';
import 'package:image_picker/image_picker.dart';
import 'package:provider/provider.dart';
import 'package:random_string/random_string.dart';
import 'package:savehouse/models/user.dart';
import 'package:savehouse/pages/widgets/imagepreview.dart';
import 'package:savehouse/providers/user.dart';
import 'package:http/http.dart' as http;

import '../../globals.dart';
import '../../values.dart';
import '../../widgets.dart';
import '../home.dart';
import '../widgets/popup.dart';

class Invest extends StatefulWidget {
  @override
  _InvestState createState() => _InvestState();
}

class _InvestState extends State<Invest> {
  var loading = false;

  var amount = TextEditingController();
  String duration;
  String type;
  String method;
  File _image;

  final GlobalKey _scaffoldKey = GlobalKey<ScaffoldState>();

  Future getImage() async {
    File image = await ImagePicker.pickImage(source: ImageSource.gallery);
    //print(image.path);
    setState(() {
      _image = image;
    });
    //print(_image.path);
  }

  Future addInvestment(BuildContext context, GlobalKey _scaffoldKey) async {
    var user = Provider.of<UserModel>(context, listen: false);
    try {
      user.setLoading(true);
      var url =
          '${user.hostUrl}/api/user/${user.user.id}/new_investment?api_token=${user.user.apiToken}';
      var request = http.MultipartRequest('POST', Uri.parse(url));
      //var d = Map<String, dynamic>.from(data);
      request.fields['amount'] = amount.text;
      request.fields['type'] = type;
      request.fields['duration'] = duration;

      //if (_image != null) {
      request.files
          .add(await http.MultipartFile.fromPath('proof', _image.path));
      // }
      request.headers['Accept'] = 'application/json';
      var res = await request.send();
      var resStr = await res.stream.bytesToString();

      user.setLoading(false);
      print(resStr);
      request2(
          resStr,
          res.statusCode,
          () async => Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => Home())),
          context,
          _scaffoldKey);
      return;
    } catch (e) {
      user.setLoading(false);
      print(e);
      snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }

  @override
  void initState() {
    super.initState();
    var user = Provider.of<UserModel>(context, listen: false);

    var publicKey = user.user.settings['paystack_key'];

    print('user_id:${user.user.id}');

    PaystackPlugin.initialize(publicKey: publicKey);
  }

  String _getReference(id) {
    return '${randomAlphaNumeric(7)}$id${randomAlphaNumeric(7)}';
  }

  checkOut(BuildContext context,
      {@required UserModel user,
      @required String type,
      @required int duration,
      @required int amount}) async {
    Charge charge = Charge()
      ..amount = amount * 100
      ..reference = _getReference(user.user.id)
      ..putMetaData('user_id', user.user.id)
      ..putMetaData('type', type)
      ..putMetaData('duration', duration)
      ..email = user.user.email;

    CheckoutResponse res = await PaystackPlugin.checkout(
      context,
      method: CheckoutMethod.card, // Defaults to CheckoutMethod.selectable
      charge: charge,
    );
    print(res.toString());
    if (res.message != 'Transaction terminated') {
      try {
        user.setLoading(true);
        final response = await http.get(
            '${user.hostUrl}/api/user/paystack/validate/${res.reference}?api_token=${user.user.apiToken}',
            headers: {
              'Accept': 'application/json',
            });
        user.setLoading(false);
        //var body = json.decode(response.body);
        //print(body);
        request(response, () async {
          Navigator.pushReplacement(context,
              MaterialPageRoute(builder: (BuildContext context) => Home()));
        }, context, _scaffoldKey);
      } catch (e) {
        user.setLoading(false);
        snackbar(connErrorMsg, context, _scaffoldKey);
      }
    }
  }

  verifyTran(String ref) async {
    var user = Provider.of<UserModel>(context, listen: false);
    try {
      user.setLoading(true);
      final response = await http.get(
          '${user.hostUrl}/api/user/paystack/validate/$ref?api_token=${user.user.apiToken}',
          headers: {
            'Accept': 'application/json',
          });
      user.setLoading(false);
      //var body = json.decode(response.body);
      //print(body);
      request(response, () async {}, context, _scaffoldKey);
    } catch (e) {
      user.setLoading(false);
      snackbar(connErrorMsg, context, _scaffoldKey);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      body: Consumer<UserModel>(builder: (context, user, child) {
        var durations = user.user.settings['investment_durations'];
        var types = user.user.settings['investments'];
        return Stack(children: [
          ListView(
            padding: EdgeInsets.all(20.0),
            children: <Widget>[
              Widgets.pageTitle(
                'Invest',
                'start a new journey, savely',
                context: context,
                icon: false,
              ),
              SizedBox(
                height: 40,
              ),
              Text(
                'Amount to Invest',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Widgets.textField(
                  amount, 'Amount', TextInputType.numberWithOptions()),
              SizedBox(height: 25),
              Text(
                'Duration to Invest',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: DropdownButton(
                  items: List.generate(durations.length, (index) {
                    //var key = investments.keys.toList()[index];
                    var string = durations[index].toString();
                    return Widgets.dropItem(string, string);
                  }),
                  hint: Text('Select Duration'),
                  value: duration,
                  onChanged: (value) {
                    setState(() {
                      duration = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 25),
              Text(
                'Investment type',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: DropdownButton(
                  items: List.generate(types.length, (index) {
                    //var key = investments.keys.toList()[index];
                    var string = types[index].toString();
                    return Widgets.dropItem(string, string);
                  }),
                  hint: Text('Select Type'),
                  value: type,
                  onChanged: (value) {
                    setState(() {
                      type = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 25),
              Text(
                'Method of payment',
                style: TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 15.0),
                child: DropdownButton<String>(
                  items: [
                    Widgets.dropItem('Online Payment', 'online'),
                    Widgets.dropItem('Proof Payment', 'proof'),
                  ],
                  hint: Text('Select Method'),
                  value: method,
                  onChanged: (value) {
                    setState(() {
                      method = value;
                    });
                  },
                ),
              ),
              SizedBox(height: 25),
              method == 'proof'
                  ? Column(
                      // shrinkWrap: true,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        Text(
                          'Choose Proof of payment',
                          style: TextStyle(
                              fontSize: 13, fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 15),
                        Row(
                          children: <Widget>[
                            FlatButton(
                              color: secondaryColor,
                              child: Text(
                                _image != null
                                    ? 'Change Proof'
                                    : 'Choose Proof',
                                style: TextStyle(color: Colors.white),
                              ),
                              onPressed: () => getImage(),
                            ),
                            Padding(
                              padding: EdgeInsets.only(left: 20),
                            ),
                            _image != null
                                ? InkWell(
                                    child: CircleAvatar(
                                      backgroundImage: FileImage(_image),
                                    ),
                                    onTap: () => showImagePreview(
                                        context, Image.file(_image)),
                                  )
                                : Container()
                          ],
                        ),
                        SizedBox(height: 25),
                      ],
                    )
                  : Container(),
              FlatButton(
                color: primaryColor,
                child: loading == true
                    ? SizedBox(
                        height: 15,
                        width: 15,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : Text(
                        'INVEST',
                        style: TextStyle(
                          fontSize: 12.0,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                onPressed: () {
                  int minAmount = user.user.settings['minimum_amount'];
                  if (!user.isloading) {
                    //print(duration);
                    if ([amount.text, duration, type, method].contains(null)) {
                      return snackbar(
                          'All fields required', context, _scaffoldKey);
                    }
                    if (int.parse(amount.text) < minAmount) {
                      return snackbar('Minimum amount allowed is $minAmount',
                          context, _scaffoldKey);
                    }
                    if (method == 'online') {
                      return checkOut(context,
                          user: user,
                          duration: int.parse(duration),
                          type: type,
                          amount: int.parse(amount.text));
                    }
                    if (method == 'proof') {
                      return _image != null
                          ? addInvestment(context, _scaffoldKey)
                          : snackbar(
                              'No proof selected', context, _scaffoldKey);
                    }
                  }
                  closeKeybord(context);
                },
              ),
            ],
          ),
          Widgets.loader(user)
        ]);
      }),
      bottomNavigationBar: Widgets.bottomNav(1, context),
    );
  }
}
