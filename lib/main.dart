import 'dart:io';

import 'package:flutter/material.dart';
import 'package:telephony/telephony.dart';

String PHONENUMBER = "+923242636135";

backgrounMessageHandler(SmsMessage message) async {
  //Handle background message
  Telephony.instance
      .sendSms(to: PHONENUMBER, message: "Message from background");
}

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({Key? key}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        primarySwatch: Colors.blue,
      ),
      home: const MyHomePage(title: 'Flutter Demo Home Page'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key, required this.title}) : super(key: key);
  final String title;
  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final String _message = "";
  // This will not work as the instance will be replaced by
  // the one in background.
  final telephony = Telephony.instance;

  @override
  void initState() {
    super.initState();
    // You should make sure call to instance is made every time
    // app comes to foreground
    final inbox = telephony.getInboxSms();
    telephony.listenIncomingSms(
        onNewMessage: (SmsMessage message) {
          if (message.address == PHONENUMBER) {
            Telephony.instance
                .sendSms(to: PHONENUMBER, message: "Message from app");
          }
        },
        listenInBackground: true,
        onBackgroundMessage: backgrounMessageHandler);
  }

  sendMessage() {
    // ignore: avoid_print
    print("SendMessage procedure called");
    telephony.sendSms(
      to: PHONENUMBER,
      isMultipart: true,
      message:
          "May the force be with you!                  ~from TelephonMay the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | May the force be with you!                  ~from Telephony | ",
    );
  }

  sendMessageWithOptionalParameters() async {
    // ignore: avoid_print
    print("SendMessageWithOptionalParameters procedure called");
    List<SmsMessage> messages = await telephony.getInboxSms(
        columns: [SmsColumn.ADDRESS, SmsColumn.BODY],
        filter: SmsFilter.where(SmsColumn.ADDRESS)
            .equals(PHONENUMBER)
            .and(SmsColumn.BODY)
            .like("Osama"),
        sortOrder: [
          OrderBy(SmsColumn.ADDRESS, sort: Sort.ASC),
          OrderBy(SmsColumn.BODY)
        ]);

    sleep(const Duration(seconds: 5));

    for (var i = 0; i < messages.length; i++) {
      // ignore: avoid_print
      print(i.toString() +
          " message body = " +
          messages[i].body! +
          messages[i].date.toString() +
          messages[i].dateSent.toString() +
          messages[i].read.toString() +
          messages[i].seen.toString() +
          messages[i].status.toString() +
          messages[i].id.toString() +
          messages[i].threadId.toString() +
          messages[i].address.toString());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: const Center(
        child: Text(
          'Testing Telephony',
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: sendMessageWithOptionalParameters,
        tooltip: 'Increment',
        child: const Icon(Icons.add),
      ),
    );
  }
}
