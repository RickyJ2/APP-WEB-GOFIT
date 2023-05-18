import 'package:equatable/equatable.dart';

class SesiGym extends Equatable {
  final String id;
  final String jamMulai;
  final String jamSelesai;

  SesiGym copyWith({
    String? id,
    String? jamMulai,
    String? jamSelesai,
  }) {
    return SesiGym(
      id: id ?? this.id,
      jamMulai: jamMulai ?? this.jamMulai,
      jamSelesai: jamSelesai ?? this.jamSelesai,
    );
  }

  const SesiGym({
    this.id = '',
    this.jamMulai = '',
    this.jamSelesai = '',
  });

  factory SesiGym.createSesiGym(Map<String, dynamic> object) {
    return SesiGym(
      id: object['id'].toString(),
      jamMulai: object['jam_mulai'].toString(),
      jamSelesai: object['jam_selesai'].toString(),
    );
  }

  static const empty = SesiGym();

  bool get isEmpty => this == SesiGym.empty;
  bool get isNotEmpty => this != SesiGym.empty;

  @override
  List<Object?> get props => [
        id,
        jamMulai,
        jamSelesai,
      ];
}
