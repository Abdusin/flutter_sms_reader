import 'package:flutter/material.dart';
import 'package:sms/sms.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key,}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  SmsQuery query = SmsQuery();
  SmsReceiver receiver = SmsReceiver();
  List<SmsMessage> messages = List();
  final GlobalKey<ScaffoldState> _scaffoldKey = new GlobalKey<ScaffoldState>();
  @override
  void initState() { 
    super.initState();
    query.getAllSms.then((value){
      setState(()=>messages=value);
    });
    receiver.onSmsReceived.listen((sms) {
      print('GELDİDA MESAJ');
      showInSnackBar('Yeni Mesajınız Var');
      setState(()=>messages.insert(0,sms));
    });
  }
  void showInSnackBar(String value) {
    _scaffoldKey.currentState.showSnackBar(new SnackBar(
        content: new Text(value)
    ));
  }
  void messageSend() {
    SmsSender sender = SmsSender();
    String address = '+905068584146';
    SmsMessage message = SmsMessage(address, 'Test Mesajı');
    message.onStateChanged.listen((state) {
      if (state == SmsMessageState.Sent) {
        print("SMS is sent!");
      } else if (state == SmsMessageState.Delivered) {
        print("SMS is delivered!");
      }
    });
    sender.sendSms(message);
  }
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      key: _scaffoldKey,
      appBar: AppBar(
        title: Text('Mesaj Oku 3000'),
        actions: [
          IconButton(
            icon: Icon(Icons.message),
            onPressed: messageSend,
          ),
        ],
      ),
      body: Container(
        child:ListView.builder(
          itemCount: messages.length,
          itemBuilder: (context,index){
            var message =  messages[index];
            return Column(
              children: [
                Text(message.sender,style: TextStyle(fontWeight: FontWeight.bold),),
                Text(message.body),
              ],
            );
          },
        ),
      ),
    );
  }
}
