abstract class LaporanEvent {}

class LaporanFormSubmitted extends LaporanEvent {}

class LaporanTypeChanged extends LaporanEvent {
  final String laporanType;

  LaporanTypeChanged({required this.laporanType});
}

class LaporanBulanChanged extends LaporanEvent {
  final String bulan;

  LaporanBulanChanged({required this.bulan});
}

class LaporanTahunChanged extends LaporanEvent {
  final String tahun;

  LaporanTahunChanged({required this.tahun});
}
