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
    return child: TreeMapLayout(
      tile: Binary(),
      root: TreeNode.node(
        // padding: EdgeInsets.symmetric(horizontal: 20),
        children: [
          TreeNode.leaf(
            value: 16,
            margin: EdgeInsets.all(5),
          ),
          TreeNode.leaf(
            value: 57,
            margin: EdgeInsets.all(5),
          ),
          TreeNode.leaf(
            value: 97,
            margin: EdgeInsets.all(5),
          ),
          TreeNode.leaf(
            value: 3,
            margin: EdgeInsets.all(5),
          ),
          TreeNode.leaf(
            value: 43,
            margin: EdgeInsets.all(5),
          ),
          TreeNode.leaf(
            value: 54,
            margin: EdgeInsets.all(5),
          ),
        ]),
    );
  }
```

### Run the example

See the `example/` folder for a working example app.