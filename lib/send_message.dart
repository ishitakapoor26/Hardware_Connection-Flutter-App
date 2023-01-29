// library send_messagee;
import 'dart:async';
import 'dart:convert';
import 'dart:core';
import 'dart:typed_data';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bluetooth_serial/flutter_bluetooth_serial.dart';

class ChatPage extends StatefulWidget {
  final BluetoothDevice? server;
  const ChatPage({
    Key? key,
    this.server,
    this.lcdMessage,
  }) : super(key: key);
  final String? lcdMessage;

  @override
  _ChatPageState createState() => _ChatPageState();
}

var hadi;

class _ChatPageState extends State<ChatPage>
    with SingleTickerProviderStateMixin {
  BluetoothConnection? connection;
  bool isConnecting = true;
  List<int> flag= [0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0];

  bool get isConnected => connection != null && connection!.isConnected;
  Color clickedColor = Colors.blue;
  bool isDisconnecting = false;

  void onClick(String message, Color color){
    if(clickedColor==Colors.blue){
      _sendMessage(message);
      setState(() {
        clickedColor= Colors.green;
      });
    }
    else if(clickedColor==Colors.green){
      _sendMessage('$message$message');
      setState(() {
        clickedColor= Colors.blue;
      });
    }
  }

  @override
  void initState() {
    BluetoothConnection.toAddress(widget.server!.address).then((_connection) {
      print('Connected to the device');
      connection = _connection;

      setState(() {
        isConnecting = false;
        isDisconnecting = false;
      });
    });
  }

  void dispose() {
    if (isConnected) {
      isDisconnecting = true;
      connection?.dispose();
      connection = null;
      mineController.close();
    }
    super.dispose();
  }

  StreamController<String> mineController =
      StreamController<String>.broadcast();
  Stream<String> myStream() async* {
    connection?.input?.listen((Uint8List data) {
      print(ascii.decode(data));

      mineController.add(ascii.decode(data));
    });
  }

  _sendMessage(String text) async {
    text = text.trim();

    if (text.length > 0) {
      try {
        connection!.output.add(Uint8List.fromList(utf8.encode(text)));
        await connection!.output.allSent;
      } catch (e) {
        // Ignore error, but notify state
        setState(() {
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Practice'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: <Widget>[
                Text('Tap on the bellow buttons to generate a figure'),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Button('a'),
                    Button('b'),
                    Button('c'),
                    Button('d'),
                    Button('e'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Button('f'),
                    Button('g'),
                    Button('h'),
                    Button('i'),
                    Button('j'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Button('k'),
                    Button('l'),
                    Button('m'),
                    Button('n'),
                    Button('o'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Button('p'),
                    Button('q'),
                    Button('r'),
                    Button('s'),
                    Button('t'),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: <Widget>[
                    Button('u'),
                    Button('v'),
                    Button('w'),
                    Button('x'),
                    Button('y'),
                  ],
                ),
                Padding(
                  padding: const EdgeInsets.only(left: 15.0, right: 15.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      ElevatedButton(
                          onPressed: (){
                            _sendMessage('rst');
                          },
                          child: Text('Reset',
                          style: TextStyle(
                            color: Colors.white
                          ),),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.blue
                        ),
                      ),
                  ElevatedButton(
                    onPressed: (){
                      _sendMessage('clr');
                    },
                    child: Text('Clear',
                      style: TextStyle(
                          color: Colors.white
                      ),),
                    style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue
                    ),
                  ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
  Widget Button(String message){
    int x= message.codeUnits[0]-97;
    print(x);
    return SizedBox(
      height: MediaQuery.of(context).size.height/15,
      width: MediaQuery.of(context).size.height/15,
      child: ElevatedButton(
        onPressed: (){
          if(flag[x]==1){
          _sendMessage('$message$message');
          setState(() {
            flag[x]=0;
          });
          }else {
            _sendMessage(message);
            setState(() {
              flag[x] = 1;
            });
          }
        },
        child: Text(""),
        style: ElevatedButton.styleFrom(
          backgroundColor: flag[x]==0? Colors.blue:Colors.green,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(50),
          ),
        ),
      ),
    );
  }
}

