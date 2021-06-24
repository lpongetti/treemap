class TreeNodeBase<T> {
  List<T> _children;
  num? _value;

  List<T>? get children => _children;
  num? get value => _value;

  TreeNodeBase({
    required List<T> children,
    num? value,
  })  : _children = children,
        _value = value;
}
