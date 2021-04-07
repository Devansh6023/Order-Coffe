import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:mailto/mailto.dart';

void main() {
  runApp(OrderCoffee());
}

class OrderCoffee extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'Order Coffee',
      theme: ThemeData(primarySwatch: Colors.red),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  bool tick1 = false;
  bool tick2 = false;
  int _amount = 10;
  bool view = false;
  bool _validate = false;
  String printTick1 = "";
  String printTick2 = "";

  int _quantity = 0;
  TextEditingController Name = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.deepOrange[50],
      appBar: AppBar(
        title: Text('Order Coffee (\$10)'),
        backgroundColor: Colors.red[400],
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8),
            child: TextField(
              style: TextStyle(color: Colors.black, fontSize: 30),
              controller: Name,
              textAlign: TextAlign.center,
              decoration: InputDecoration(
                  hintText: ('Name'),
                  errorText: _validate ? 'Field Can\'t Be Empty' : null,
                  hintStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 30.0,
                    fontWeight: FontWeight.w300,
                    fontStyle: FontStyle.italic,
                  ),
                  suffixIcon: Icon(Icons.emoji_food_beverage),
                  labelStyle: TextStyle(
                    color: Colors.black,
                    fontSize: 15,
                    fontWeight: FontWeight.bold,
                  ),
                  border: UnderlineInputBorder()),
            ),
          ),
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Text(
              'TOPPINGS',
              style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Column(
            children: [
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.red[400],
                    value: this.tick1,
                    onChanged: (bool value) {
                      setState(() {
                        this.tick1 = value;
                        amountCB1();
                        CB1();
                      });
                    },
                  ),
                  Text('Whipped cream (+\$5)'),
                ],
              ),
              Row(
                children: [
                  Checkbox(
                    checkColor: Colors.white,
                    activeColor: Colors.red[400],
                    value: this.tick2,
                    onChanged: (bool value) {
                      setState(() {
                        this.tick2 = value;
                        amountCB2();
                        CB2();
                      });
                    },
                  ),
                  Text('Chocolate (+\$5)'),
                ],
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Text(
              'Quantity',
              style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              RaisedButton(
                padding: const EdgeInsets.all(4.0),
                onPressed: () {
                  if (_quantity > 0) _decrement();
                },
                child: Text(
                  '-',
                  style: TextStyle(color: Colors.black, fontSize: 30.0),
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(4.0),
                child: Text(
                  '$_quantity',
                  style: TextStyle(color: Colors.black, fontSize: 40),
                ),
              ),
              RaisedButton(
                padding: const EdgeInsets.all(4.0),
                onPressed: _increment,
                child: Text(
                  '+',
                  style: TextStyle(color: Colors.black, fontSize: 30.0),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 10, 0, 5),
            child: Text(
              'Order Summary',
              style: TextStyle(
                  color: Colors.red[400],
                  fontSize: 30,
                  fontWeight: FontWeight.bold),
            ),
          ),
          Visibility(
            visible: view,
            maintainSize: false,
            maintainAnimation: true,
            maintainState: true,
            child: Container(
              height: 200,
              width: 200,
              padding: EdgeInsets.fromLTRB(0, 10, 0, 10),
              child: Center(
                child: Text(
                  'Name: ${Name.text}\n'
                  'Quantity: $_quantity\n'
                  '$printTick1\n'
                  '$printTick2\n'
                  'Total: \$${_quantity * _amount}\n'
                  'Thank You',
                  style: TextStyle(
                      color: Colors.black,
                      fontSize: 20,
                      fontWeight: FontWeight.bold),
                ),
              ),
            ),
          ),
          RaisedButton(
            padding: const EdgeInsets.all(5.0),
            onPressed: () {
              _showOrder();
            },
            child: Text(
              'ORDER',
              style: TextStyle(color: Colors.black, fontSize: 25.0),
            ),
          ),
          Padding(
            padding: const EdgeInsets.fromLTRB(0, 5, 0, 0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: RaisedButton(
                    padding: const EdgeInsets.all(8),
                    onPressed: () {
                      _reset();
                    },
                    child: Text(
                      'RESET',
                      style: TextStyle(color: Colors.black, fontSize: 25.0),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.fromLTRB(0, 8, 0, 5),
                  child: RaisedButton(
                    padding: const EdgeInsets.all(8),
                    onPressed: () {
                      Name.text.isEmpty ? _validate = true : _validate = false;
                      _callLauchMailto();
                    },
                    child: Text(
                      'EMAIL ORDER',
                      style: TextStyle(color: Colors.black, fontSize: 25.0),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
      resizeToAvoidBottomInset: false,
    );
  }

  void _increment() {
    setState(() {
      _quantity++;
    });
  }

  void _decrement() {
    setState(() {
      _quantity--;
    });
  }

  void _reset() {
    setState(() {
      Name.clear();
      _quantity = 0;
      _amount = 10;
      tick1 = false;
      tick2 = false;
      view = false;
      Name.text.isEmpty ? _validate = false : _validate = true;
    });
  }

  void CB1() {
    if (tick1 == true) {
      printTick1 = '+Whipped Cream';
    } else {
      printTick1 = "";
    }
  }

  void CB2() {
    if (tick2 == true) {
      printTick2 = '+Chocolate';
    } else {
      printTick2 = "";
    }
  }

  void _showOrder() {
    setState(() {
      if (Name.text.isEmpty ? _validate = true : _validate = false) {
        view = false;
      } else {
        view = true;
      }
    });
  }

  void _callLauchMailto() {
    if (Name.text.isEmpty ? _validate = true : _validate = false) {
      _showOrder();
    } else {
      launchMailto();
    }
  }

  launchMailto() async {
    final mailtoLink = Mailto(
      to: ['companyid@gmail.com'],
      subject: 'Order your Coffee',
      body: ('Name: ${Name.text}\n'
          'Quantity: $_quantity\n'
          '$printTick1\n'
          '$printTick2\n'
          'Total: \$${_quantity * _amount}\n'
          'Thank You'),
    );
    await launch('$mailtoLink');
  }

  void amountCB1() {
    if (tick1 == true) {
      _amount = _amount + 5;
    }
    if (tick1 == false) {
      _amount = _amount - 5;
    }
  }

  void amountCB2() {
    if (tick2 == true) {
      _amount = _amount + 5;
    }
    if (tick2 == false) {
      _amount = _amount - 5;
    }
  }
}
