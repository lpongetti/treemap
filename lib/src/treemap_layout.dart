import 'package:flutter/material.dart';
import 'package:treemap/src/tiles/squarify.dart';
import 'package:treemap/src/tiles/tile.dart';
import 'package:treemap/src/treemap.dart';
import 'package:treemap/src/treenode.dart';

class TreeMapLayout extends StatelessWidget {
  final TreeNode root;
  final Tile tile;
  final bool round;
  final Duration? duration;

  TreeMapLayout({
    required this.root,
    this.tile = const Squarify(),
    this.round = false,
    this.duration,
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
            final child = node.builder != null
                ? node.builder!(context)
                : InkWell(
                    child: Container(
                      decoration: BoxDecoration(
                        color: node.options?.color ??
                            Theme.of(context).primaryColor,
                        border: node.options?.border ??
                            Border.all(
                              width: 1,
                              color: Colors.black,
                            ),
                      ),
                      child: node.options?.child,
                    ),
                    onTap: node.options?.onTap,
                  );

            return result
              ..add(
                this.duration == null
                    ? Positioned(
                        top: node.top,
                        left: node.left,
                        width: node.right - node.left,
                        height: node.bottom - node.top,
                        child: child,
                      )
                    : AnimatedPositioned(
                        top: node.top,
                        left: node.left,
                        width: node.right - node.left,
                        height: node.bottom - node.top,
                        duration: duration!,
                        child: child,
                      ),
              );
          }),
        );
      },
    );
  }
}
