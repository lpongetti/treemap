import 'package:treemap/src/tiles/tile.dart';
import 'package:treemap/src/treemap.dart';
import 'package:treemap/src/treenode.dart';

class Slice extends Tile {
  @override
  position(
      TreeNode node, double left, double top, double right, double bottom) {
    slice(node, left, top, right, bottom);
  }
}
