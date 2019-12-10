import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'main.dart';
import 'inicial.dart';

import 'package:http/http.dart' as http;


class Login extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Login',
      theme: ThemeData(

        primarySwatch: Colors.blue,
      ),
      home: MyLoginPage(title: 'Login'),
    );
  }
}

class MyLoginPage extends StatefulWidget {
  MyLoginPage({Key key, this.title}) : super(key: key);

  final String title;

  @override
  _MyLoginPageState createState() => _MyLoginPageState();
}

class _MyLoginPageState extends State<MyLoginPage> {


  String msgResult = "";

  final txtUsuario = TextEditingController();
  final txtSenha = TextEditingController();


  void _login(String usuario, String senha) {

      LoginHttp(usuario, senha).then((value) {
      }, onError: (error) {
      });
  }
  Future<String> LoginHttp(String usuario, String senha) async {


    String url = "http://187.109.233.147:55598/glpi/apirest.php/";
    String chave = "gP5Z23wHqItcI2Wc81lJ7fjQIAeBMehq7QAVgXoG";

    final stringToBase64 = utf8.fuse(base64);
    final encodedCredentials = stringToBase64.encode(usuario+':'+senha);

    final response = await http.get(
        url+"initSession",
        headers: {'App-Token': chave, 'Authorization':'Basic '+ encodedCredentials});


    String msg;
    if (response.statusCode != 200){
      msg =  "Usuário ou senha incorretos!";
      setState(() {
        msgResult = msg;
      });
      return msg;
    }

    final responseJson = json.decode(response.body);
    String session =  responseJson['session_token'];

    msg =  "Usuário autenticado com sucesso!";


    setState(() {
      msgResult = msg;
    });

    Navigator.push(
      context,
      MaterialPageRoute(
        builder: (context) => Inicial(session: session)


      ),
    );
    return session;

  }


  @override
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text(widget.title),
      ),
      body: Center(
        child: Column(

          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            Text(
              'Informe seu login e senha:',
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            TextField(
              obscureText: false,
              controller: txtUsuario,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Usuário',
              ),
            ),
            Padding(padding: EdgeInsets.only(top: 5)),
            TextField(
              controller: txtSenha,
              obscureText: true,
              decoration: InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Senha',
              ),
            ),
            FlatButton(
              color: Colors.blue,
              onPressed: () {
                _login(txtUsuario.text, txtSenha.text);
              },
              child: Text(
                "Login",
              ),
            ),
            Text(
              '$msgResult',
            ),
          ],
        ),
      ),
    // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


