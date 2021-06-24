import 'package:treemap/src/tiles/tile.dart';
import 'package:treemap/src/treenode.dart';

class Binary extends Tile {
  List<TreeNode> _children;
  List<num> _sums;

  @override
  position(
      TreeNode node, double left, double top, double right, double bottom) {
    _children = node.children;

    var sum = 0;
    _sums = List<num>.generate(_children.length + 1, (index) {
      if (index == 0) return 0;

      sum += _children[index - 1].value;
      return sum;
    });

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
