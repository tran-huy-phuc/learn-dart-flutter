class Stack<E> {
  final _list = <E>[];

  /// Add an element to the stack
  void push(E value) => _list.add(value);

  /// Get the top element in the stack AND remove it
  E pop() => _list.removeLast();

  /// Get the top element in the stack but don't remove it
  E get peek => _list.last;

  bool get isEmpty => _list.isEmpty;
  bool get isNotEmpty => _list.isNotEmpty;

  int get length => _list.length;

  @override
  String toString() => _list.toString();
}