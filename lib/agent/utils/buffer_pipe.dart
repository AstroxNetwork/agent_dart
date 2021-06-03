import 'dart:collection';

class BufferPipe<T> {
  int _bytesRead = 0;
  int _bytesWrote = 0;
  final DoubleLinkedQueue<T> _buffer = DoubleLinkedQueue<T>();

  List<T> read(int length) {
    final list = <T>[];

    for (var i = 0; i < length && _buffer.isNotEmpty; i++) {
      list.add(_buffer.removeFirst());
      _bytesRead++;
    }

    return list;
  }

  BufferPipe(Iterable<T> list) {
    write(list);
  }

  void write(Iterable<T> data) {
    final oldLength = _buffer.length;
    _buffer.addAll(data);
    _bytesWrote += _buffer.length - oldLength;
  }

  bool get end => _buffer.isEmpty;
  int get bytesRead => _bytesRead;
  int get bytesWrote => _bytesWrote;
  int get length => _buffer.length;
  List<T> get buffer => _buffer.toList();
}
