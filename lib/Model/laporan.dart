import 'package:equatable/equatable.dart';

class Laporan<E> extends Equatable {
  final List<E>? data;
  final String jenis;

  const Laporan({this.data, this.jenis = ''});

  Laporan copyWith({List<E>? data, String? jenis}) {
    return Laporan(
      data: data ?? this.data,
      jenis: jenis ?? this.jenis,
    );
  }

  static const empty = Laporan(data: [], jenis: '');

  bool get isEmpty => this == Laporan.empty;
  bool get isNotEmpty => this != Laporan.empty;

  @override
  List<Object?> get props => [data, jenis];
}
