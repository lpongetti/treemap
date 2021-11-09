import 'package:flutter/material.dart';
import 'package:treemap/src/treenode_base.dart';

class TreeNode implements TreeNodeBase {
  num _value = 0;
  List<TreeNode>? children;
  TreeNodeOptions? options;
  EdgeInsets margin;
  EdgeInsets padding;
  WidgetBuilder? builder;
  TreeNode? parent;
  double top = 0;
  double left = 0;
  double right = 0;
  double bottom = 0;

  num get value {
    if (children == null) {
      return _value;
    }
    return children!.fold(0, (a, b) => a + b.value);
  }

  set value(num newValue) {
    if (children == null) {
      _value = newValue;
    }
  }

  TreeNode.node({
    required this.children,
    WidgetBuilder? builder,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.options,
  }) : assert(children != null && children.length > 0) {
    for (var child in children!) {
      this._value += child.value;
      child.parent = this;
    }
  }

  TreeNode.leaf({
    required num value,
    WidgetBuilder? builder,
    this.margin = const EdgeInsets.all(0),
    this.padding = const EdgeInsets.all(0),
    this.options,
  })  : assert(value > 0),
        _value = value;

  int get depth {
    int depth = 0;
    TreeNode? dparent = parent;
    while (dparent != null) {
      dparent = dparent.parent;
      depth++;
    }
    return depth;
  }

  List<TreeNode> get leaves {
    var leaves = <TreeNode>[];
    for (var child in children!) {
      if (child.children == null) {
        leaves.add(child);
      } else {
        leaves.addAll([child, ...child.leaves]);
      }
    }
    return leaves;
  }

  eachBefore(Function(TreeNode) callback) {
    var node = this;
    var nodes = [node];

    while (nodes.isNotEmpty) {
      node = nodes.removeLast();
      callback(node);
      var children = node.children;
      if (children != null) {
        nodes.addAll(children);
      }
    }
  }
}

class TreeNodeOptions {
  final Color? color;
  final BoxBorder? border;
  final Widget? child;
  GestureTapCallback? onTap;

  TreeNodeOptions({
    this.color,
    this.border,
    this.child,
    this.onTap,
  });
}
