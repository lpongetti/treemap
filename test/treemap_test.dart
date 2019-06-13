import 'dart:ui';

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:treemap/treemap.dart';

void main() {
  test('treemap root position', () {
    var treenode = new TreeNode.node(children: [
      TreeNode.node(
        children: [
          TreeNode.leaf(value: 1),
        ],
      ),
    ]);

    var treemap = TreeMap(root: treenode, size: Size(800, 800));

    expect(treemap.root.top, 0);
    expect(treemap.root.left, 0);
    expect(treemap.root.bottom, 800);
    expect(treemap.root.right, 800);
  });

  test('treenode root position with margin', () {
    var treenode = new TreeNode.node(
        margin: EdgeInsets.only(left: 30, top: 10, right: 40, bottom: 20),
        children: [
          TreeNode.node(
            children: [
              TreeNode.leaf(value: 1),
            ],
          ),
        ]);
    var treemap = TreeMap(root: treenode, size: Size(800, 800));

    expect(treemap.root.top, 10);
    expect(treemap.root.left, 30);
    expect(treemap.root.bottom, 800 - 20);
    expect(treemap.root.right, 800 - 40);
  });

  test('treenode root position padding', () {
    var treenode = new TreeNode.node(
        padding: EdgeInsets.only(left: 30, top: 10, right: 40, bottom: 20),
        children: [
          TreeNode.node(
            children: [
              TreeNode.leaf(value: 1),
            ],
          ),
        ]);
    var treemap = TreeMap(root: treenode, size: Size(800, 800));

    expect(treemap.root.children[0].top, 10);
    expect(treemap.root.children[0].left, 30);
    expect(treemap.root.children[0].bottom, 800 - 20);
    expect(treemap.root.children[0].right, 800 - 40);
  });
}
