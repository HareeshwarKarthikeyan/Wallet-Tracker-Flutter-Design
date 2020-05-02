import 'dart:async';

import 'package:flutter/material.dart';

class EditBudget extends StatefulWidget {
  EditBudget({Key key, this.title}) : super(key: key);
  final String title;
  @override
  _EditBudgetState createState() => _EditBudgetState();
}

class _EditBudgetState extends State<EditBudget> {
    final weekly_budget = TextEditingController(), monthly_budget = TextEditingController();

  int wb, mb;
  int balance = 5000;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          backgroundColor: Color.fromRGBO(58, 66, 86, 1.0),
          leading: BackButton(
            color: Colors.white,
          ),
          title: Container(
              margin: EdgeInsets.only(left: 0),
              child: new Text(
                'Budget',
                style: TextStyle(
                  fontSize: 20,
                ),
              )),
          centerTitle: true,
        ),
        body: Material(
            color: Color.fromRGBO(58, 66, 86, 1.0),
            child: Material(
                child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Align(
                  child: Container(
                      //DIALOG BOX
                      child: Dialog(
                    backgroundColor: Color.fromRGBO(64, 75, 96, 0.9),
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                        side: BorderSide.none,
                        borderRadius: BorderRadius.circular(10)),
                    child: Container(
                      height: 450.0,
                      width: 300.0,
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 15),
                            child: Text(
                              'Sep-Aug 2019',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 10, 20, 0),
                            child: Text(
                              'Wallet Balance',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 2.5, 20, 15),
                            child: Text(
                              '\$$balance',
                              style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 20,
                                  fontWeight: FontWeight.bold),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 2.5, 20, 5),
                            child: Text(
                              'Weekly Limit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          //TextBox
                          Container(
                            width: 200,
                            child: TextFormField(
                              maxLength: 10,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 7.5),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(),
                                ),
                                //fillColor: Colors.green
                              ),
                              validator: (val) {},
                              controller: weekly_budget,
                              keyboardType: TextInputType.text,
                              style: new TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Padding(
                            padding: EdgeInsets.fromLTRB(20, 0, 20, 5),
                            child: Text(
                              'Monthly Limit',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                              ),
                            ),
                          ),
                          //TextBox
                          Container(
                            width: 200,
                            child: TextFormField(
                              maxLength: 10,
                              decoration: InputDecoration(
                                contentPadding: const EdgeInsets.symmetric(
                                    vertical: 10.0, horizontal: 7.5),
                                fillColor: Colors.white,
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(15.0),
                                  borderSide: BorderSide(),
                                ),
                              ),
                              validator: (val) {},
                              controller: monthly_budget,
                              keyboardType: TextInputType.phone,
                              style: new TextStyle(
                                color: Colors.black,
                              ),
                            ),
                          ),
                          Builder(
                              builder: (context) => RaisedButton(
                                  shape: RoundedRectangleBorder(
                                      borderRadius:
                                          BorderRadius.circular(15.0)),
                                  onPressed: () {
                                    //update the values here
                                    print(weekly_budget.text);
                                   
                                    Navigator.pop(context);
                                  },
                                  child: Text(
                                    'Apply',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 20,
                                    ),
                                  )))
                        ],
                      ),
                    ),
                  )),
                ),
              ],
            ))));
  }
}
