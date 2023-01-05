import 'package:flutter/material.dart';
import 'package:list_provider/models/model.dart';
import 'package:provider/provider.dart';

import 'provider/list_provider.dart';

class MyHomePage extends StatefulWidget {
  const MyHomePage({
    super.key,
  });

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  late GlobalKey<FormState> _formKey;
  late TextEditingController _controller;
  var taskItems;
  int counter = 0;
  late DynamicList listClass;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    _formKey = GlobalKey();
    _controller = TextEditingController();
    taskItems = Provider.of<ListProvider>(context, listen: false);
    listClass = DynamicList(taskItems.list);
  }

  @override
  void dispose() {
    // TODO: implement dispose
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Dynamic ListView with Provider'),
      ),
      body: Container(
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  onSaved: (val) {
                    taskItems.addItem(val);
                  },
                  validator: (val) {
                    if (val!.length > 0) {
                      return null;
                    } else {
                      " Add a text";
                    }
                  },
                ),
              ),
            ),
            Padding(
                padding: EdgeInsets.all(8.0),
                child: ElevatedButton(
                  child: Text("Add"),
                  onPressed: () {
                    if (_formKey.currentState!.validate()) {
                      _formKey.currentState!.save();
                      print(_formKey.currentState!);
                    }
                  },
                )),
            Consumer<ListProvider>(
              builder: (context, provider, listTile) => Expanded(
                child: ListView.builder(
                    itemCount: listClass.list.length,
                    itemBuilder: (context, index) => buildList(context, index)),
              ),
            )
          ],
        ),
      ),
    );
  }

  Widget buildList(BuildContext context, int index) {
    counter++;
    return Dismissible(
        key: Key(counter.toString()),
        direction: DismissDirection.startToEnd,
        onDismissed: (direction) {
          taskItems.deleteItem(index);
        },
        child: Container(
          margin: const EdgeInsets.all(4),
          decoration: BoxDecoration(
              border: Border.all(color: Colors.blue, width: 2),
              borderRadius: BorderRadius.circular(10)),
          child: ListTile(
            title: Text(listClass.list[index].toString()),
            trailing: const Icon(Icons.keyboard_arrow_right),
          ),
        ));
  }
}
