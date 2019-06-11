import 'dart:math';
import 'dart:ui';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:treemap/src/treemap_mode.dart';

class TreeNode {
  final List<TreeNode> children;
  final WidgetBuilder builder;
  num _value;
  TreeNode _parent;
  double _width = 0;
  double _height = 0;
  double _top = 0;
  double _left = 0;
  double _area = 0;

  num get value => _value;

  TreeNode._internal({
    this.children,
    num value,
    this.builder,
  }) {
    _value = value;

    if (children != null && children.length > 0) {
      _value = 0;
      for (var child in children) {
        _value += child.value;
        child._parent = this;
      }
    }
  }

  factory TreeNode.node({List<TreeNode> children}) {
    assert(children.length != null);

    return TreeNode._internal(children: children);
  }

  factory TreeNode.leaf({num value, WidgetBuilder builder}) {
    assert(value != null);

    return TreeNode._internal(value: value, builder: builder);
  }

  int get depth {
    int depth = 0;
    TreeNode parent = _parent;
    while (parent != null) {
      parent = parent._parent;
      depth++;
    }
    return depth;
  }

  List<TreeNode> get _leafs {
    var leafs = List<TreeNode>();
    for (var child in children) {
      if (child.children == null) {
        leafs.add(child);
      } else {
        leafs.addAll(child._leafs);
      }
    }
    return leafs;
  }
}

class TreeMap {
  final TreeNode root;
  final Size size;
  final EdgeInsets padding;
  final bool sticky;
  final num ratio;
  final TreemapMode mode;

  List<TreeNode> get leafs {
    return root._leafs;
  }

  TreeMap({
    @required this.root,
    @required this.size,
    this.padding = const EdgeInsets.all(2),
    this.sticky = false,
    this.ratio = 1.61803398875,
    this.mode = TreemapMode.Squarify,
  })  : assert(root != null && root.children.length > 0),
        assert(size != null && size.width > 0 && size.height > 0) {
    root._width = size.width;
    root._height = size.height;
    _squarify(root);
  }

  _squarify(TreeNode node) {
    var children = node.children;
    if (children != null && children.length > 0) {
      List<TreeNode> row = [];

      var rect = _rectanglePadding(node);
      var remaining = List<TreeNode>()..addAll(children);
      var best = double.infinity;
      num u;
      switch (mode) {
        case TreemapMode.Slice:
          u = rect.width;
          break;
        case TreemapMode.Dice:
          u = rect.height;
          break;
        case TreemapMode.SliceDice:
          if (node.depth & 1 > 0)
            u = rect.height;
          else
            u = rect.width;
          break;
        default:
          u = min(rect.width, rect.height);
      }

      _scale(remaining, rect.width * rect.height / node.value);
      num area = 0;
      while (remaining.length > 0) {
        var child = remaining.last;
        row.add(child);
        area += child._area;

        var score = _worst(row, area, u);
        if (mode != TreemapMode.Squarify || score <= best) {
          remaining.removeLast();
          best = score;
        } else {
          area -= row.removeLast()._area;
          _position(row, area, u, rect, false);
          u = min(rect.width, rect.height);
          row.length = area = 0;
          best = double.infinity;
        }
      }
      if (row.length > 0) {
        _position(row, area, u, rect, true);
        row.length = area = 0;
      }
      children.forEach(_squarify);
    }
  }

  MutableRectangle _rectanglePadding(TreeNode node) {
    var x = node._left + padding.left,
        y = node._top + padding.top,
        dx = node._width - padding.horizontal,
        dy = node._height - padding.vertical;
    if (dx < 0) {
      x += dx / 2;
      dx = 0;
    }
    if (dy < 0) {
      y += dy / 2;
      dy = 0;
    }

    return MutableRectangle(x, y, dx, dy);
  }

  double _worst(List<TreeNode> row, double area, double u) {
    var area2 = pow(area, 2);
    var u2 = pow(u, 2);
    num rmax = 0;
    num rmin = double.infinity;

    for (var i = 0; i < row.length; i++) {
      var areaChild = row[i]._area;
      if (areaChild == 0) continue;
      if (areaChild < rmin) rmin = areaChild;
      if (areaChild > rmax) rmax = areaChild;
    }
    return area2 > 0
        ? max(u2 * rmax * ratio / area2, area2 / (u2 * rmin * ratio))
        : double.infinity;
  }

  _position(List<TreeNode> row, double area, double u, MutableRectangle rect,
      bool flush) {
    double x = rect.left;
    double y = rect.top;
    double v = u > 0 ? area / u : 0;
    TreeNode child;
    if (u == rect.width) {
      if (flush || v > rect.height) {
        v = rect.height;
      }
      for (var i = 0; i < row.length; i++) {
        child = row[i];
        child._left = x;
        child._top = y;
        child._height = v;
        child._width =
            min(rect.left + rect.width - x, v > 0 ? child._area / v : 0);
        x += child._width;
      }
      child._width += rect.left + rect.width - x;
      rect.top += v;
      rect.height -= v;
    } else {
      if (flush || v > rect.width) {
        v = rect.width;
      }
      for (var i = 0; i < row.length; i++) {
        child = row[i];
        child._left = x;
        child._top = y;
        child._width = v;
        child._height =
            min(rect.top + rect.height - y, v > 0 ? child._area / v : 0);
        y += child._height;
      }
      child._height += rect.top + rect.height - y;
      rect.left += v;
      rect.width -= v;
    }
  }

  _scale(List<TreeNode> children, double k) {
    for (var child in children) {
      var area = child.value * (k < 0 ? 0 : k);
      child._area = area.isNaN || area <= 0 ? 0 : area;
    }
  }
}

class TreeMapBuilder extends StatelessWidget {
  final TreeNode root;
  final EdgeInsets padding;
  final bool sticky;
  final num ratio;
  final TreemapMode mode;

  TreeMapBuilder({
    this.root,
    this.padding = const EdgeInsets.all(2),
    this.sticky = false,
    this.ratio = 1.61803398875,
    this.mode = TreemapMode.Squarify,
  });

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        var treemap = TreeMap(
          root: root,
          size: Size(constraints.maxWidth, constraints.maxHeight),
          padding: padding,
          sticky: sticky,
          ratio: ratio,
          mode: mode,
        );

        return Stack(
          children: treemap.leafs.fold([], (result, node) {
            return result
              ..add(
                Positioned(
                  top: node._top,
                  left: node._left,
                  width: node._width,
                  height: node._height,
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
