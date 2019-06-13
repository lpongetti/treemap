import 'package:treemap/src/tiles/tile.dart';
import 'package:treemap/src/treemap.dart';
import 'package:treemap/src/treenode.dart';

class SliceDice extends Tile {
  @override
  position(
      TreeNode node, double left, double top, double right, double bottom) {
    (node.depth & 1 > 0 ? slice : dice)(node, left, top, right, bottom);
  }
}
