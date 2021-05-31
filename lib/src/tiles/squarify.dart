import 'dart:math';

import 'package:treemap/src/tiles/tile.dart';
import 'package:treemap/src/treenode.dart';
import 'package:treemap/src/treenode_base.dart';

class Squarify extends Tile {
  static double _ratio = (1 + sqrt(5.0)) / 2;

  double get ratio => _ratio;

  set _setRatio(double x) => _ratio = x > 1 ? x : 1.0;

  const Squarify();

  factory Squarify.ratio(double ratio) {
    return Squarify().._setRatio = ratio;
  }

  @override
  position(TreeNode node, double left, double top, double right, double bottom) {
    int i0 = 0, i1 = 0;
    num? sumValue, minValue, maxValue, childValue;
    var value = node.value;
    var nodes = node.children!;

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
        sumValue = sumValue! + (childValue = nodes[i1].value);
        if (childValue < minValue!) minValue = childValue;
        if (childValue > maxValue!) maxValue = childValue;
        beta = sumValue * sumValue * alpha;
        newRatio = max(maxValue / beta, beta / minValue);
        if (newRatio > minRatio) {
          sumValue -= childValue;
          break;
        }
        minRatio = newRatio;
      }

      // Position and record the row orientation.
      var row = TreeNodeBase(children: nodes.sublist(i0, i1), value: sumValue);
      if (width < height)
        dice(row, left, top, right, value > 0 ? top += height * sumValue! / value : bottom);
      else
        slice(row, left, top, value > 0 ? left += width * sumValue! / value : right, bottom);

      value -= sumValue!;
      i0 = i1;
    }
  }
}
