import 'dart:math';

import 'package:flutter/material.dart';
import 'package:treemap/treemap.dart';

void main() => runApp(MyApp());

class MyApp extends StatelessWidget {
  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        brightness: Brightness.dark,
        primarySwatch: Colors.blue,
      ),
      home: MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({Key? key}) : super(key: key);

  @override
  _MyHomePageState createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  List<TreeNode> childNode = [];

  @override
  void initState() {
    super.initState();
    _addNewNode();
  }

  _addNewNode() {
    setState(() {
      final node = TreeNode.leaf(
        value: max(1, Random().nextInt(10)),
        margin: EdgeInsets.all(5),
        options: TreeNodeOptions(
          color: () {
            Random random = Random();
            return Colors.primaries[random.nextInt(Colors.primaries.length)];
          }(),
        ),
      );
      node.options?.onTap = () {
        setState(() {
          childNode.remove(node);
        });
      };
      childNode.add(node);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Container(
          color: Colors.red,
          width: 425,
          height: 425,
          child: TreeMapLayout(
            duration: Duration(milliseconds: 500),
            tile: Binary(),
            children: [
              TreeNode.node(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(5),
                children: childNode,
                options: TreeNodeOptions(
                  color: Colors.amber,
                ),
              ),
              TreeNode.node(
                padding: EdgeInsets.all(20),
                margin: EdgeInsets.all(5),
                children: [TreeNode.leaf(value: 15)],
                options: TreeNodeOptions(
                  color: Colors.blue,
                ),
              ),
            ],
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        child: Text("+"),
        onPressed: () {
          _addNewNode();
        },
      ),
    );
  }
}
