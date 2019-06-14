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
      body: Center(
        child: Container(
          color: Colors.red,
          width: 425,
          height: 425,
          child: TreeMapLayout(
            tile: Binary(),
            root: TreeNode.node(
                // padding: EdgeInsets.symmetric(horizontal: 20),
                children: [
                  TreeNode.leaf(
                    value: 16,
                    margin: EdgeInsets.all(5),
                  ),
                  TreeNode.leaf(
                    value: 57,
                    margin: EdgeInsets.all(5),
                  ),
                  TreeNode.leaf(
                    value: 97,
                    margin: EdgeInsets.all(5),
                  ),
                  TreeNode.leaf(
                    value: 3,
                    margin: EdgeInsets.all(5),
                  ),
                  TreeNode.leaf(
                    value: 43,
                    margin: EdgeInsets.all(5),
                  ),
                  TreeNode.leaf(
                    value: 54,
                    margin: EdgeInsets.all(5),
                  ),
                ]),
          ),
        ),
      ),
    );
  }
}
