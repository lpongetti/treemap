import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';

class TreeNode {
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

  TreeNode._fakerow({
    @required List<TreeNode> children,
    num value,
  })  : _children = children,
        _value = value;

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

abstract class Tile {
  const Tile();

  position(TreeNode node, double left, double top, double right, double bottom);

  dice(TreeNode node, double left, double top, double right, double bottom) {
    var k = (right - left) / node.value;

    for (var child in node.children) {
      child.left = left;
      child.top = top;
      child.right = left += child.value * k;
      child.bottom = bottom;
    }
  }

  slice(TreeNode node, double left, double top, double right, double bottom) {
    var k = (bottom - top) / node.value;

    for (var child in node.children) {
      child.left = left;
      child.top = top;
      child.right = right;
      child.bottom = top += child.value * k;
    }
  }
}

class Dice extends Tile {
  @override
  position(
      TreeNode node, double left, double top, double right, double bottom) {
    dice(node, left, top, right, bottom);
  }
}

class Slice extends Tile {
  @override
  position(
      TreeNode node, double left, double top, double right, double bottom) {
    slice(node, left, top, right, bottom);
  }
}

class Squarify extends Tile {
  static double _ratio = (1 + sqrt(5.0)) / 2;

  double get ratio => _ratio;

  set _setRatio(double x) => _ratio = x > 1 ? x : 1.0;

  const Squarify();

  factory Squarify.ratio(double ratio) {
    return Squarify().._setRatio = ratio;
  }

  @override
  position(
      TreeNode node, double left, double top, double right, double bottom) {
    int i0 = 0, i1 = 0;
    num sumValue, minValue, maxValue, childValue;
    var value = node.value;
    var nodes = node.children;

    double newRatio, minRatio, alpha, beta;

    while (i0 < nodes.length) {
      final width = right - left;
      final height = bottom - top;

      // Find the next non-empty node.
      do {
        sumValue = nodes[i1++].value;
      } while (sumValue < 0 && i1 < nodes.length);

      minValue = maxValue = sumValue;
      alpha = max(height / width, width / height) / (value * ratio);
      beta = sumValue * sumValue * alpha;
      minRatio = max(maxValue / beta, beta / minValue);

      // Keep adding nodes while the aspect ratio maintains or improves.
      for (; i1 < nodes.length; ++i1) {
        sumValue += childValue = nodes[i1].value;
        if (childValue < minValue) minValue = childValue;
        if (childValue > maxValue) maxValue = childValue;
        beta = sumValue * sumValue * alpha;
        newRatio = max(maxValue / beta, beta / minValue);
        if (newRatio > minRatio) {
          sumValue -= childValue;
          break;
        }
        minRatio = newRatio;
      }

      // Position and record the row orientation.
      var row = TreeNode._fakerow(
        children: nodes.sublist(i0, i1),
        value: sumValue,
      );
      if (width < height)
        dice(row, left, top, right,
            value > 0 ? top += height * sumValue / value : bottom);
      else
        slice(row, left, top,
            value > 0 ? left += width * sumValue / value : right, bottom);

      value -= sumValue;
      i0 = i1;
    }
  }
}

class Binary extends Tile {
  List<TreeNode> _children;
  List<num> _sums;

  @override
  position(
      TreeNode node, double left, double top, double right, double bottom) {
    _children = node.children;
    _sums = List<num>(_children.length + 1);
    var sum = 0;
    _sums[0] = sum;

    for (var i = 0; i < _children.length; ++i) {
      _sums[i + 1] = sum += _children[i].value;
    }

    partition(0, _children.length, node.value, left, top, right, bottom);
  }

  partition(int i, int j, num value, double left, double top, double right,
      double bottom) {
    if (i >= j - 1) {
      var node = _children[i];
      node.left = left;
      node.top = top;
      node.right = right;
      node.bottom = bottom;
      return;
    }

    var valueOffset = _sums[i],
        valueTarget = (value / 2) + valueOffset,
        k = i + 1,
        hi = j - 1;

    while (k < hi) {
      var mid = (k + hi) >> 1;
      if (_sums[mid] < valueTarget)
        k = mid + 1;
      else
        hi = mid;
    }

    if ((valueTarget - _sums[k - 1]) < (_sums[k] - valueTarget) && i + 1 < k)
      --k;

    var valueLeft = _sums[k] - valueOffset, valueRight = value - valueLeft;

    if ((right - left) > (bottom - top)) {
      var xk = (left * valueRight + right * valueLeft) / value;
      partition(i, k, valueLeft, left, top, xk, bottom);
      partition(k, j, valueRight, xk, top, right, bottom);
    } else {
      var yk = (top * valueRight + bottom * valueLeft) / value;
      partition(i, k, valueLeft, left, top, right, yk);
      partition(k, j, valueRight, left, yk, right, bottom);
    }
  }
}

class TreeMapBuilder extends StatelessWidget {
  final TreeNode root;
  final Tile tile;

  TreeMapBuilder({
    this.root,
    this.tile = const Squarify(),
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var treemap = TreeMap(
          root: root,
          size: Size(constraints.maxWidth, constraints.maxHeight),
          tile: tile,
        );

        return Stack(
          children: treemap.leaves.fold([], (result, node) {
            return result
              ..add(
                Positioned(
                  top: node.top,
                  left: node.left,
                  width: node.right - node.left,
                  height: node.bottom - node.top,
                  child: node.builder != null
                      ? node.builder
                      : Container(
                          decoration: BoxDecoration(
                            color: Colors.blue,
                            border: Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                          ),
                        ),
                ),
              );
          }),
        );
      },
    );
  }
}
