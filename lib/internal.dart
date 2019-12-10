import 'package:flutter/material.dart';
import 'inicial.dart';
import 'package:intl/intl.dart';
import 'edit.dart';

class Internal extends StatefulWidget {
  final ListItem item;
  final String session;
  Internal({this.item, this.session});


  @override
  _InternalState createState() => _InternalState(item : this.item, session: this.session);
}

class _InternalState extends State<Internal> {

  final ListItem item;
  final String session;
  final List<Valor> valores = new List();


  void _getItens() {
    super.initState();
    SetValor();
  }

  List<Valor> SetValor() {
    valores.add(new Valor("Título", item.name));
    valores.add(new Valor("Mensagem", item.content.replaceAll("&lt;", "").replaceAll("p&gt;", "")));
    valores.add(new Valor("Data de criação", new DateFormat("dd/MM/yyyy hh:mm:ss").format(item.date)));
    valores.add(new Valor("Status", item.status));
    valores.add(new Valor("Prioridade", item.priority));
    valores.add(new Valor("Impacto", item.impact));
    valores.add(new Valor("Urgência", item.urgency));


    setState(() => {
      valores
    });

    return valores;
  }
  _InternalState({this.item, this.session});

  void _editItem(){
    Navigator.push(
      context,
      MaterialPageRoute(
          builder: (context) => Edit(item: item, session: this.session)
      ),
    );
  }


  ListTile _buildItemsForListView(BuildContext context, int index) {

    return ListTile(
      title:Text(valores[index].chave, style: TextStyle(fontSize: 20)),
      subtitle: Text(valores[index].valor, style: TextStyle(fontSize: 18))
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

        title: Text(item.name),
      ),
      body: ListView.builder(
        itemCount: valores.length,
        itemBuilder: _buildItemsForListView,
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: _editItem,
        tooltip: 'Increment',
        child: Icon(Icons.edit),
      ), // This trailing comma makes auto-formatting nicer for build methods.
    );
  }
}


class Valor {

  final String chave;
  final String valor;

  Valor(

      this.chave,
      this.valor
      );
}
