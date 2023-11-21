import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

void main() {
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  TextEditingController _controller = TextEditingController();
  String _response = "";

  Future<void> _sendMessage(String message) async {
    final http.Response response = await http.post(
      Uri.parse('https://70db-113-174-99-64.ngrok.io/webhooks/rest/webhook'),
          headers: <String, String>{
      'Content-Type': 'application/json; charset=UTF-8'},
      body: jsonEncode({"sender": "user", "message": message}),
    );
    if (response.statusCode == 200) {
      final List<dynamic> responseData = jsonDecode(response.body);
      setState(() {
        _response = responseData.isNotEmpty ? responseData.first['text'] : 'No response';
      });
    } else {
      throw Exception('Failed to load response');
    }
    print(_response);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Rasa Chat'),
      ),
      body: Column(
        children: [
          TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'Enter your message'),
          ),
          ElevatedButton(
            onPressed: () => _sendMessage(_controller.text),
            child: Text('Send'),
          ),
          Text('Responseee: $_response'),
        ],
      ),
    );
  }
}