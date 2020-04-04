import 'package:flutter/material.dart';


class ForgotPassword extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        elevation: 0,
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: Icon(Icons.arrow_back_ios), 
          color: Colors.black,
          onPressed: (){Navigator.pop(context);}),
      
      ),
      body: Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: <Widget>[
          Center(
            child: Text('Retrieve Password', 
              style: TextStyle(
                fontFamily: "WorkSansSemiBold",
                fontSize: 30,
                fontWeight: FontWeight.bold
              ),)),
              SizedBox(height: 90),
              Padding(
                padding: const EdgeInsets.only(left: 30),
                child: Text('Email',
                  style: TextStyle(
                    fontSize: 20,
                    fontWeight: FontWeight.bold
                  ),),
              ),
              Padding(
                padding: const EdgeInsets.only(left: 30, right: 10),
                child: TextField(
                  controller: null,
                  decoration: InputDecoration(
                    filled: true,
                    fillColor: Colors.white,
                    
                  ),
                ),
              ),
              SizedBox(height: 30),
              Padding(
                padding: const EdgeInsets.only(left: 270),
                child: Container(
                  height: 50,
                  width: 100,
                  color: Colors.transparent,
                  
                  child: RaisedButton(
                    elevation: 10,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(15)
                    ),
                    child: Text('Submit',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,         
                        color: Colors.black
                      ),),
                    color: Colors.red,
                    onPressed: null),
                ),
              )
        ],
      ),
    );
  }
}