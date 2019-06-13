import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:treemap/src/tiles/squarify.dart';
import 'package:treemap/src/tiles/tile.dart';
import 'package:treemap/src/treenode.dart';

class TreeMap {
  final TreeNode root;
  final Size size;
  final Tile tile;

  List<TreeNode> get leaves {
    return root.leaves;
  }

  TreeMap({
    @required this.root,
    @required this.size,
    this.tile = const Squarify(),
  })  : assert(root != null && root.children.length > 0),
        assert(size != null && size.width > 0 && size.height > 0) {
    root.right = size.width;
    root.bottom = size.height;
    root.eachBefore(_positionNode);
  }

  _positionNode(TreeNode node) {
    node.left += node.margin.left;
    node.top += node.margin.top;
    node.right -= node.margin.right;
    node.bottom -= node.margin.bottom;
    if (node.right < node.left)
      node.left = node.right = (node.left + node.right) / 2;
    if (node.bottom < node.top)
      node.top = node.bottom = (node.top + node.bottom) / 2;

    if (node.children != null) {
      tile.position(
          node,
          node.left + node.padding.left,
          node.top + node.padding.top,
          node.right - node.padding.right,
          node.bottom - node.padding.bottom);
    }
  }
}
