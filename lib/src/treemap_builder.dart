import 'package:flutter/material.dart';
import 'package:treemap/src/tiles/squarify.dart';
import 'package:treemap/src/tiles/tile.dart';
import 'package:treemap/src/treemap.dart';
import 'package:treemap/src/treenode.dart';

class TreeMapBuilder extends StatelessWidget {
  final TreeNode root;
  final Tile tile;
  final bool round;

  TreeMapBuilder({
    this.root,
    this.tile = const Squarify(),
    this.round = false,
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
                      ? node.builder(context)
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
