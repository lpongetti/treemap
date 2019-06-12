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

class MyHomePage extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: TreeMapBuilder(
        padding: EdgeInsets.symmetric(horizontal: 20),
        mode: TreeMapMode.Squarify,
        root: TreeNode.node(children: [
          TreeNode.leaf(value: 4),
          TreeNode.leaf(value: 4),
          TreeNode.leaf(value: 4),
          TreeNode.leaf(value: 3),
          TreeNode.leaf(value: 3),
          TreeNode.leaf(value: 3),
          TreeNode.leaf(value: 2),
          TreeNode.leaf(value: 2),
          TreeNode.leaf(value: 2),
          TreeNode.leaf(value: 1),
          TreeNode.leaf(value: 1),
          TreeNode.leaf(value: 1),
          TreeNode.leaf(value: 1),
        ]),
      ),
    );
  }
}
