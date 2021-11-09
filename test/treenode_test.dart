import 'package:flutter_test/flutter_test.dart';
import 'package:treemap/treemap.dart';

void main() {
  TreeNode? treenode;

  setUp(() {
    treenode = new TreeNode.node(children: [
      TreeNode.node(
        children: [
          TreeNode.leaf(
            value: 25,
          ),
          TreeNode.leaf(
            value: 50,
          )
        ],
      ),
    ]);
  });

  test('treenode children lenght', () {
    expect(treenode!.children!.length, 1);
  });

  test('treenode root depth', () {
    expect(treenode!.depth, 0);
  });

  test('treenode children depth', () {
    expect(treenode!.children![0].depth, 1);
  });

  test('treenode leaves lenght', () {
    expect(treenode!.leaves.length, 3);
  });

  test('treenode leaves depth', () {
    expect(treenode!.leaves[1].depth, 2);
  });

  test('treenode eachBefore', () {
    int i = 0;
    treenode!.eachBefore((node) {
      expect(node.depth, i);
      if (i < 2) {
        i++;
      }
    });
  });

  test('treenode parent', () {
    expect(treenode!.parent, null);
    expect(treenode!.children![0].parent, treenode);
  });

  test('treenode value', () {
    expect(treenode!.value, 75);
    treenode!.children![0].children![0].value += 1;
    expect(treenode!.value, 76);
  });
}
