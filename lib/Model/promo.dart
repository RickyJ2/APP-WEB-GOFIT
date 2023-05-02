import 'package:equatable/equatable.dart';

class Promo extends Equatable {
  final String id;
  final String jenisTransaksi;
  final int kriteriaPembelian;
  final int bonus;

  const Promo({
    this.id = '',
    this.jenisTransaksi = '',
    this.kriteriaPembelian = 0,
    this.bonus = 0,
  });

  factory Promo.createPromo(Map<String, dynamic> object) {
    return Promo(
      id: object['id'].toString(),
      jenisTransaksi: object['jenis_promo'].toString(),
      kriteriaPembelian: object['kriteria_pembelian'].toInt(),
      bonus: object['bonus'].toInt(),
    );
  }

  static const empty = Promo(
    id: '',
    jenisTransaksi: '',
    kriteriaPembelian: 0,
    bonus: 0,
  );

  bool get isEmpty => this == Promo.empty;
  bool get isNoEmpty => this != Promo.empty;
  @override
  List<Object?> get props => [id, jenisTransaksi, kriteriaPembelian, bonus];
}
