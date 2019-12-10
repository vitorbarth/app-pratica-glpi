import 'package:flutter/material.dart';
import 'dart:async';
import 'dart:convert';
import 'internal.dart';
import 'package:intl/intl.dart';
import 'edit.dart';

import 'package:http/http.dart' as http;

class Inicial extends StatefulWidget {
  final String session;


  Inicial({this.session});

  @override
  _InicialState createState() => _InicialState(session: this.session);
}

class _InicialState extends State<Inicial> {
  final List<ListItem> items = new List();
  final String session;

  _InicialState({this.session});

  void _getItens() {
    super.initState();
    GetItens();
  }



  Future<List<ListItem>> GetItens() async {


    String url = "http://187.109.233.147:55598/glpi/apirest.php/";
    String chave = "gP5Z23wHqItcI2Wc81lJ7fjQIAeBMehq7QAVgXoG";


    final response = await http.get(
        url+"ticket",
        headers: {'App-Token': chave, 'Session-Token':this.session});


    if (response.statusCode != 200){
      return null;
    }

    final res = json.decode(response.body);
    //String session =  responseJson['session_token'];



    String status;
    for(var resItem in res ) {

      if (resItem['status'] == 1){
        status = "Novo";
      } else if (resItem['status'] == 2){
        status = "Atribuído";
      }else if (resItem['status'] == 3){
        status = "Planejado";
      }else if (resItem['status'] == 4){
        status = "Pendente";
      }else if (resItem['status'] == 5){
        status = "Solucionado";
      }else if (resItem['status'] == 6) {
        status = "Fechado";
      }

      String urgencia;
      if (resItem['urgency'] == 5){
        urgencia = "Muito Alta";
      } else if (resItem['urgency'] == 4){
        urgencia = "Alta";
      }else if (resItem['urgency'] == 3){
        urgencia = "Média";
      }else if (resItem['urgency'] == 2){
        urgencia = "Baixa";
      }else if (resItem['urgency'] == 1){
        urgencia = "Muito Baixa";
      }

      String impacto;
      if (resItem['impact'] == 5){
        impacto = "Muito Alta";
      } else if (resItem['impact'] == 4){
        impacto = "Alta";
      }else if (resItem['impact'] == 3){
        impacto = "Média";
      }else if (resItem['impact'] == 2){
        impacto = "Baixa";
      }else if (resItem['impact'] == 1){
        impacto = "Muito Baixa";
      }

      String prioridade;
      if (resItem['priority'] == 5){
        prioridade = "Muito Alta";
      } else if (resItem['priority'] == 4){
        prioridade = "Alta";
      }else if (resItem['priority'] == 3){
        prioridade = "Média";
      }else if (resItem['priority'] == 2){
        prioridade = "Baixa";
      }else if (resItem['priority'] == 1){
        prioridade = "Muito Baixa";
      }

      ListItem item = new ListItem(
          resItem['id'],
          resItem['name'],
        DateTime.parse(resItem['date']),
        status,
          resItem['content'],
        urgencia,
        impacto,
        prioridade);

      items.add(item);

    }

    setState(() => {
      items
    });

    return items;

  }

  void viewChamado (ListItem item){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Internal(item: item, session: this.session)
      ),
    );
  }
  void _addItem(){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Edit(item: null, session: this.session)
      ),
    );
  }

  ListTile _buildItemsForListView(BuildContext context, int index) {
    return ListTile(
      title:Text(items[index].name, style: TextStyle(fontSize: 20)),
      subtitle: Text(new DateFormat("dd/MM/yyyy hh:mm:ss").format(items[index].date), style: TextStyle(fontSize: 18)),
      onTap: () => viewChamado(items[index]),
    );
  }
  @override
  void initState() {
    _getItens();
    super.initState();
  }
  Widget build(BuildContext context) {

    return Scaffold(
      appBar: AppBar(

        title: Text('Meus chamados'),
      ),
      body: ListView.builder(
        itemCount: items.length,
        itemBuilder: _buildItemsForListView,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _addItem,
        tooltip: 'Increment',
        child: Icon(Icons.add),
      ), // This trailing com
      // This trailing comma makes auto-formatting nicer for build methods.
    );


  }







}

// A ListItem that contains data to display a message.
class ListItem {
  final int id;
  final String name;
  final DateTime date;
  final String status;
  final String content;
  final String urgency;
  final String impact;
  final String priority;

  ListItem(
      this.id,
      this.name,
      this.date,
      this.status,
      this.content,
      this.urgency,
      this.impact,
      this.priority
      );
}
