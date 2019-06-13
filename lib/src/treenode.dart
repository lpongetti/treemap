import 'package:flutter/material.dart';
import 'package:treemap/src/treenode_base.dart';

class TreeNode implements TreeNodeBase {
  List<TreeNode> _children;
  EdgeInsets _margin;
  EdgeInsets _padding;
  num _value;
  WidgetBuilder _builder;
  TreeNode _parent;
  double top = 0;
  double left = 0;
  double right = 0;
  double bottom = 0;

  List<TreeNode> get children => _children;
  num get value => _value;
  EdgeInsets get margin => _margin;
  EdgeInsets get padding => _padding;
  WidgetBuilder get builder => _builder;
  TreeNode get parent => _parent;

  TreeNode.node({
    @required List<TreeNode> children,
    EdgeInsets margin = const EdgeInsets.all(0),
    EdgeInsets padding = const EdgeInsets.all(0),
  })  : _children = children,
        _margin = margin,
        _padding = padding,
        assert(children != null && children.length > 0) {
    _value = 0;
    for (var child in children) {
      _value += child.value;
      child._parent = this;
    }
  }

  TreeNode.leaf({
    @required num value,
    WidgetBuilder builder,
    EdgeInsets margin = const EdgeInsets.all(0),
  })  : _value = value,
        _builder = builder,
        _margin = margin,
        assert(value != null);

  int get depth {
    int depth = 0;
    TreeNode parent = _parent;
    while (parent != null) {
      parent = parent._parent;
      depth++;
    }
    return depth;
  }

  List<TreeNode> get leaves {
    var leafs = List<TreeNode>();
    for (var child in children) {
      if (child.children == null) {
        leafs.add(child);
      } else {
        leafs.addAll(child.leaves);
      }
    }
    return leafs;
  }

  eachBefore(Function(TreeNode) callback) {
    var node = this;
    var nodes = [node];

    while (nodes.isNotEmpty && (node = nodes.removeLast()) != null) {
      callback(node);
      var children = node.children;
      if (children != null) {
        nodes.addAll(children);
      }
    }
  }
}
