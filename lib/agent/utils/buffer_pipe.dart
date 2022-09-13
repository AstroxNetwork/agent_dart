import 'dart:collection';

class BufferPipe<T> {
  BufferPipe(Iterable<T> list) {
    write(list);
  }

  final DoubleLinkedQueue<T> _buffer = DoubleLinkedQueue<T>();
  int _bytesRead = 0;
  int _bytesWrote = 0;

  bool get end => _buffer.isEmpty;

  int get bytesRead => _bytesRead;

  int get bytesWrote => _bytesWrote;

  int get length => _buffer.length;

  List<T> get buffer => _buffer.toList();

  List<T> read(int length) {
    final list = <T>[];

    for (int i = 0; i < length && _buffer.isNotEmpty; i++) {
      list.add(_buffer.removeFirst());
      _bytesRead++;
    }

    return list;
  }

  void write(Iterable<T> data) {
    final oldLength = _buffer.length;
    _buffer.addAll(data);
    _bytesWrote += _buffer.length - oldLength;
  }
}
