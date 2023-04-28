import 'package:equatable/equatable.dart';

class Kelas extends Equatable {
  final String id;
  final String nama;
  final String harga;

  Kelas copyWith({
    String? id,
    String? nama,
    String? harga,
  }) {
    return Kelas(
      id: id ?? this.id,
      nama: nama ?? this.nama,
      harga: harga ?? this.harga,
    );
  }

  const Kelas({
    this.id = '',
    this.nama = '',
    this.harga = '',
  });

  factory Kelas.createKelas(Map<String, dynamic> object) {
    return Kelas(
      id: object['id'].toString(),
      nama: object['nama'].toString(),
      harga: object['harga'].toString(),
    );
  }

  static const empty = Kelas(
    id: '',
    nama: '',
    harga: '',
  );

  bool get isEmpty => this == Kelas.empty;
  bool get isNoEmpty => this != Kelas.empty;

  @override
  List<Object> get props => [
        id,
        nama,
        harga,
      ];
}
