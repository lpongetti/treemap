import 'package:flutter_test/flutter_test.dart';
import 'package:treemap/treemap.dart';

void main() {
  TreeNode treenode;

  setUp(() {
    treenode = new TreeNode.node(children: [
      TreeNode.node(
        children: [
          TreeNode.leaf(value: 1),
        ],
      ),
    ]);
  });

  test('treenode children lenght', () {
    expect(treenode.children.length, 1);
  });

  test('treenode root depth', () {
    expect(treenode.depth, 0);
  });

  test('treenode children depth', () {
    expect(treenode.children[0].depth, 1);
  });

  test('treenode leaves lenght', () {
    expect(treenode.leaves.length, 1);
  });

  test('treenode leaves depth', () {
    expect(treenode.leaves[0].depth, 2);
  });

  test('treenode eachBefore', () {
    int i = 0;
    treenode.eachBefore((node) {
      expect(node.depth, i);
      i++;
    });
  });

  test('treenode parent', () {
    expect(treenode.parent, null);
    expect(treenode.children[0].parent, treenode);
  });
}
