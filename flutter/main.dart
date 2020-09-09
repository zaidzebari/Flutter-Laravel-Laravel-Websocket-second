import 'package:flutter/material.dart';
import 'package:flutter_pusher_client/flutter_pusher.dart';
import 'package:laravel_echo/laravel_echo.dart';

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Laravel Laravel Websocket',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: MyHomePage(title: 'Flutter Laravel Laravel Websocket'),
    );
  }
}

class MyHomePage extends StatefulWidget {
  MyHomePage({Key key, this.title}) : super(key: key);
  final String title;

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  FlutterPusher pusher;
  Echo echo;
  List<Message> message = [];

  String token =
      "eyJ0eXAiOiJKV1QiLCJhbGciOiJSUzI1NiJ9.eyJhdWQiOiIyIiwianRpIjoiODI0ZTE2NWNlNWY4YTAwYzY2NDQyYzkxOTI5YTgzNmJlNWZhYWFiYWNiMWY1N2ZlMmJlZWZhM2I3YzI5Mjg0YmQzMzdmM2Q1ODkzOGZiNDMiLCJpYXQiOjE1OTk2Nzg1MDEsIm5iZiI6MTU5OTY3ODUwMSwiZXhwIjoxNjMxMjE0NTAxLCJzdWIiOiIxIiwic2NvcGVzIjpbXX0.oeHd1Fz2f32FbBaTUMOC5ih2AGiPj640mwM2byZS8dGGUBOyzLs9nW0-eySp6GGm4DXwsaOX89TQA6BMXi9duwGYBW_STnBnShvtPizHgtiK6xGiVSXHM9_ciA6Wmx1wccZ_sYZbZ5lpmlD3W47Bv4HztB5LIW6ELrOYgIH1lp-x8Xqmkq_d8emzq2ldQ8s4XizGnLS56b8X5XvC1pBQPjxZReDf3l51kVgNWd5DyeivRk-jrjZF4k7tm8w-WiFTk8pJqwHgIP6A1a8Rt5Dh7EmAoeKAuG7WJuFFOoT4tajtYLjSmQO0w3pOeKdloM8b4mSk4f-mRBkwXYRjv0aV-HUsoPkBNVUb3hNqIpmVD5lPPSl7yrZIre39htFFRh7iQTEDbnPnXH2YGZZFTHbnsxmzrnxB59xOgTKIPBn1lDQqJrh3cf5QSKxbZv5Bbpqeh13UrEuBK3x5hf0DXf5zRyl9DK1rXE6yJbUE-gasyM4KyeyPrRTEvFxYkb3rI7eRJI-Vr-lLdBcqNRKJjHOSHNjeMD1Vi9HKfxrX-KrBJLnV30WeKpv_8mE_5fGRs8D5yXl2cC06P5KRyj0oebdyQ9YP3wwQhG79UXyQQxUSV4EXCefSqeMJwKJ7YAAUUoR0F-XDdbO2prpwBS8S2bYioeKg2Sh7BUpZgga5NvNY6FM";
  void initSocket() {
    print('initiating Socket....');
    PusherOptions options = PusherOptions(
      host: '192.168.1.22',
      port: 6001,
      cluster: 'mt1',
      encrypted: false,
      auth: PusherAuth(
        "http://192.168.1.22:8000/broadcasting/auth",
        headers: {
          'Authorization': "Bearer $token",
          'Content-Type': 'application/json',
        },
      ),
    );

    try {
      pusher = FlutterPusher('ABCDEFG', options, enableLogging: true);
    } catch (e) {
      print(e.errMsg());
    }
    echo = new Echo({
      'broadcaster': 'pusher',
      'client': pusher,
    });
    //"https://192.168.1.22/broadcasting/auth"

    echo.private('home').listen('NewMessage', (event) {
      print('this is event text ' + event['message'].toString());

      setState(() {
        message.add(Message(event['message'].toString()));
      });
    });
  } //http://192.168.1.22/web/socket/public/broadcasting/auth

  @override
  void dispose() {
    echo.disconnect();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(widget.title),
      ),
      body: Center(
        child: ListView.builder(
            physics: ScrollPhysics(),
            shrinkWrap: true,
            itemCount: message.length,
            itemBuilder: (BuildContext contex, int index) {
              return ListTile(
                title: Text(
                  message[index].message.toString(),
                  style: TextStyle(fontSize: 22),
                ),
              );
            }),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => initSocket(),
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ),
    );
  }
}

class Message {
  String message;
  Message(this.message);
}
