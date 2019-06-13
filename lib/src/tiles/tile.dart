import 'package:treemap/src/treenode.dart';
import 'package:treemap/src/treenode_base.dart';

abstract class Tile {
  const Tile();

  position(TreeNode node, double left, double top, double right, double bottom);

  dice(
      TreeNodeBase node, double left, double top, double right, double bottom) {
    var k = (right - left) / node.value;

    for (var child in node.children) {
      child.left = left;
      child.top = top;
      child.right = left += child.value * k;
      child.bottom = bottom;
    }
  }

  slice(
      TreeNodeBase node, double left, double top, double right, double bottom) {
    var k = (bottom - top) / node.value;

    for (var child in node.children) {
      child.left = left;
      child.top = top;
      child.right = right;
      child.bottom = top += child.value * k;
    }
  }
}
