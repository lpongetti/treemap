# Treemap

[![pub package](https://img.shields.io/pub/v/treemap.svg)](https://pub.dartlang.org/packages/treemap) ![travis](https://api.travis-ci.com/lpongetti/treemap.svg?branch=master)

A simple Dart implementation of treemap.

<div style="text-align: center"><table><tr>
  <td style="text-align: center">
  <a href="https://github.com/lpongetti/treemap/blob/master/example.png">
    <img src="https://github.com/lpongetti/treemap/blob/master/example.png" width="200"/></a>
</td>
</tr></table></div>

## Usage

Add treemap to your pubspec:

```yaml
dependencies:
  treemap: any # or the latest version on Pub
```

Add in you project.

```dart
  Widget build(BuildContext context) {
    return TreeMapBuilder(
      padding: EdgeInsets.symmetric(horizontal: 20),
      mode: TreemapMode.Squarify,
      root: TreeNode.node(children: [
        TreeNode.leaf(value: 4),
        TreeNode.leaf(value: 4),
        TreeNode.leaf(value: 4),
        TreeNode.leaf(value: 3),
        TreeNode.leaf(value: 3),
        TreeNode.leaf(value: 3),
        TreeNode.leaf(value: 2),
        TreeNode.leaf(value: 2),
        TreeNode.leaf(value: 2),
        TreeNode.leaf(value: 1),
        TreeNode.leaf(value: 1),
        TreeNode.leaf(value: 1),
        TreeNode.leaf(value: 1),
      ]),
    );
  }
```

### Run the example

See the `example/` folder for a working example app.