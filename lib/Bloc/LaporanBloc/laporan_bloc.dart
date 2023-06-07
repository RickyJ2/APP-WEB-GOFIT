import 'dart:typed_data';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:web_gofit/Bloc/LaporanBloc/laporan_event.dart';
import 'package:web_gofit/Bloc/LaporanBloc/laporan_state.dart';
import 'package:web_gofit/Model/laporan_aktivitas_gym.dart';
import 'package:web_gofit/Model/laporan_aktivitas_kelas.dart';
import 'package:web_gofit/Model/laporan_kinerja_instruktur.dart';
import 'package:web_gofit/Model/laporan_pendapatan.dart';
import 'package:web_gofit/Repository/laporan_repository.dart';
import 'package:web_gofit/StateBlocTemplate/form_submission_state.dart';
import 'package:web_gofit/const.dart';
import '../../Asset/thousands_formater.dart';
import '../../Model/informasi_umum.dart';
import '../../Model/laporan.dart';
import 'package:pdf/pdf.dart';
import 'package:printing/printing.dart';
import 'package:pdf/widgets.dart' as pw;

import '../AppBloc/app_bloc.dart';

class LaporanBloc extends Bloc<LaporanEvent, LaporanState> {
  final LaporanRepository laporanRepository;
  final AppBloc appBloc;

  LaporanBloc({required this.laporanRepository, required this.appBloc})
      : super(LaporanState()) {
    on<LaporanFormSubmitted>(
        (event, emit) => _onLaporanFormSubmitted(event, emit));
    on<LaporanTypeChanged>((event, emit) => _onLaporanTypeChanged(event, emit));
    on<LaporanBulanChanged>(
        (event, emit) => _onLaporanBulanChanged(event, emit));
    on<LaporanTahunChanged>(
        (event, emit) => _onLaporanTahunChanged(event, emit));
  }

  void _onLaporanFormSubmitted(
      LaporanFormSubmitted event, Emitter<LaporanState> emit) async {
    if (state.laporanType != laporanTypeList[0] && state.bulanForm == '') {
      emit(state.copyWith(bulanError: 'Bulan tidak boleh kosong'));
    }
    if (state.tahunForm == '') {
      emit(state.copyWith(tahunError: 'Tahun tidak boleh kosong'));
    }
    if (state.bulanError != '' || state.tahunError != '') {
      return;
    }
    emit(state.copyWith(formSubmissionState: FormSubmitting()));
    try {
      if (state.laporanType == laporanTypeList[0]) {
        List<LaporanPendapatan> laporanPendapatan =
            await laporanRepository.laporanPendapatan(state.tahunForm);
        Laporan laporan =
            Laporan(jenis: laporanTypeList[0], data: laporanPendapatan);
        emit(state.copyWith(
            formSubmissionState: SubmissionSuccess(), laporan: laporan));
      } else if (state.laporanType == laporanTypeList[1]) {
        List<LaporanAktivitasKelas> laporanAktivitasKelas =
            await laporanRepository.laporanAktivitasKelas(
                state.tahunForm, state.bulanForm);
        Laporan laporan =
            Laporan(jenis: laporanTypeList[1], data: laporanAktivitasKelas);
        emit(state.copyWith(
            formSubmissionState: SubmissionSuccess(), laporan: laporan));
      } else if (state.laporanType == laporanTypeList[2]) {
        List<LaporanAktivitasGym> laporanAktivitasGym = await laporanRepository
            .laporanAktivitasGym(state.tahunForm, state.bulanForm);
        Laporan laporan =
            Laporan(jenis: laporanTypeList[2], data: laporanAktivitasGym);
        emit(state.copyWith(
            formSubmissionState: SubmissionSuccess(), laporan: laporan));
      } else if (state.laporanType == laporanTypeList[3]) {
        List<LaporanKinerjaInstruktur> laporanKinerjaInstruktur =
            await laporanRepository.laporanKinerjaInstruktur(
                state.tahunForm, state.bulanForm);
        Laporan laporan =
            Laporan(jenis: laporanTypeList[3], data: laporanKinerjaInstruktur);
        emit(state.copyWith(
            formSubmissionState: SubmissionSuccess(), laporan: laporan));
      } else {
        emit(state.copyWith(
            formSubmissionState: const SubmissionFailed("Failed")));
      }
      //cetak struk
      Printing.layoutPdf(onLayout: (PdfPageFormat format) {
        return buildPdf(format, state.laporan, appBloc.state.informasiUmum);
      });
    } catch (e) {
      emit(state.copyWith(formSubmissionState: SubmissionFailed(e.toString())));
    }
  }

  void _onLaporanTypeChanged(
      LaporanTypeChanged event, Emitter<LaporanState> emit) {
    emit(state.copyWith(
        laporanType: event.laporanType,
        formSubmissionState: const InitialFormState()));
  }

  void _onLaporanBulanChanged(
      LaporanBulanChanged event, Emitter<LaporanState> emit) {
    emit(state.copyWith(
        bulanForm: event.bulan, formSubmissionState: const InitialFormState()));
  }

  void _onLaporanTahunChanged(
      LaporanTahunChanged event, Emitter<LaporanState> emit) {
    emit(state.copyWith(
        tahunForm: event.tahun, formSubmissionState: const InitialFormState()));
  }

  Future<Uint8List> buildPdf(
      PdfPageFormat format, Laporan data, InformasiUmum informasiUmum) async {
    final pw.Document doc = pw.Document();

    doc.addPage(pw.Page(
        pageFormat: format,
        build: (pw.Context context) {
          return pw.Container(
            padding: const pw.EdgeInsets.all(10),
            child: pw.Column(
              crossAxisAlignment: pw.CrossAxisAlignment.start,
              children: [
                pw.Expanded(
                  flex: 2,
                  child: pw.Column(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Text(informasiUmum.nama,
                          style: pw.TextStyle(
                              fontSize: 12, fontWeight: pw.FontWeight.bold)),
                      pw.Text(informasiUmum.alamat,
                          style: const pw.TextStyle(fontSize: 12)),
                      pw.SizedBox(height: 15),
                      pw.Text(
                        data.jenis,
                        style: pw.TextStyle(
                          fontSize: 12,
                          fontWeight: pw.FontWeight.bold,
                          decoration: pw.TextDecoration.underline,
                        ),
                      ),
                      data.jenis == laporanTypeList[0]
                          ? pw.Text(
                              'Periode ${state.tahunForm}',
                              style: const pw.TextStyle(
                                fontSize: 12,
                              ),
                            )
                          : pw.Text(
                              'Bulan: ${state.bulanForm} Tahun: ${state.tahunForm}',
                              style: const pw.TextStyle(
                                fontSize: 12,
                                decoration: pw.TextDecoration.underline,
                              ),
                            ),
                      pw.Text(
                        'Tanggal cetak ${DateFormat('EEEE, dd MMMM yyyy', 'id').format(DateTime.now())}',
                        style: const pw.TextStyle(
                          fontSize: 12,
                        ),
                      ),
                      pw.SizedBox(height: 15),
                      data.jenis == laporanTypeList[0]
                          ? pw.Table(
                              border: pw.TableBorder.all(),
                              children: [
                                pw.TableRow(
                                  children: [
                                    pw.Text('Bulan'),
                                    pw.Text('Aktivasi'),
                                    pw.Text('Deposit'),
                                    pw.Text('Total'),
                                  ],
                                ),
                                for (var index = 0;
                                    index <
                                        (data.data as List<LaporanPendapatan>)
                                                .length -
                                            1;
                                    index++)
                                  pw.TableRow(
                                    children: [
                                      pw.Text((data.data
                                              as List<LaporanPendapatan>)[index]
                                          .bulan),
                                      pw.Text(
                                          'Rp ${ThousandsFormatterString.format((data.data as List<LaporanPendapatan>)[index].aktivitas.toString())}'),
                                      pw.Text(
                                          'Rp ${ThousandsFormatterString.format((data.data as List<LaporanPendapatan>)[index].deposit.toString())}'),
                                      pw.Text(
                                          'Rp ${ThousandsFormatterString.format((data.data as List<LaporanPendapatan>)[index].total.toString())}'),
                                    ],
                                  ),
                                pw.TableRow(
                                  children: [
                                    pw.Text(''),
                                    pw.Text(''),
                                    pw.Text('Total'),
                                    pw.Text(
                                        'Rp ${ThousandsFormatterString.format((data.data as List<LaporanPendapatan>)[(data.data as List<LaporanPendapatan>).length - 1].total.toString())}'),
                                  ],
                                ),
                              ],
                            )
                          : data.jenis == laporanTypeList[1]
                              ? pw.Table(
                                  border: pw.TableBorder.all(),
                                  children: [
                                    pw.TableRow(
                                      children: [
                                        pw.Text('Kelas'),
                                        pw.Text('Instruktur'),
                                        pw.Text('Jumlah Peserta'),
                                        pw.Text('Jumlah Libur'),
                                      ],
                                    ),
                                    for (var item in (data.data
                                        as List<LaporanAktivitasKelas>))
                                      pw.TableRow(
                                        children: [
                                          pw.Text(item.kelas),
                                          pw.Text(item.instruktur),
                                          pw.Text(
                                              item.jumlahPeserta.toString()),
                                          pw.Text(item.jumlahLibur.toString()),
                                        ],
                                      ),
                                  ],
                                )
                              : data.jenis == laporanTypeList[2]
                                  ? pw.Table(
                                      border: pw.TableBorder.all(),
                                      children: [
                                        pw.TableRow(
                                          children: [
                                            pw.Text('Tanggal'),
                                            pw.Text('Jumlah Member'),
                                          ],
                                        ),
                                        for (var item in (data.data
                                            as List<LaporanAktivitasGym>))
                                          pw.TableRow(
                                            children: [
                                              item.tanggal == 'Total'
                                                  ? pw.Text('Total')
                                                  : pw.Text(DateFormat(
                                                          'dd MMMM yyyy', 'id')
                                                      .format(DateTime.parse(
                                                          item.tanggal))),
                                              pw.Text(item.jumlahMember),
                                            ],
                                          ),
                                      ],
                                    )
                                  : pw.Table(
                                      border: pw.TableBorder.all(),
                                      children: [
                                        pw.TableRow(
                                          children: [
                                            pw.Text('Nama'),
                                            pw.Text('Jumlah Hadir'),
                                            pw.Text('Jumlah Libur'),
                                            pw.Text('Waktu Terlambat (detik)'),
                                          ],
                                        ),
                                        for (var item in (data.data
                                            as List<LaporanKinerjaInstruktur>))
                                          pw.TableRow(
                                            children: [
                                              pw.Text(item.namaInstruktur),
                                              pw.Text(item.jumlahHadir),
                                              pw.Text(item.jumlahLibur),
                                              pw.Text(item.totalWaktuTerlambat),
                                            ],
                                          ),
                                      ],
                                    ),
                      pw.SizedBox(height: 30),
                      // data.jenis == laporanTypeList[0]
                      //     ? pw.Expanded(
                      //         child: pw.Chart(
                      //           grid: pw.CartesianGrid(
                      //             xAxis: pw.FixedAxis.fromStrings(
                      //               List.generate(
                      //                   (data.data as List<LaporanPendapatan>)
                      //                           .length -
                      //                       1,
                      //                   (index) => (data.data as List<
                      //                           LaporanPendapatan>)[index]
                      //                       .bulan
                      //                       .substring(0, 3)),
                      //               marginStart: 30,
                      //               marginEnd: 30,
                      //               ticks: true,
                      //             ),
                      //             yAxis: pw.FixedAxis(
                      //               [
                      //                 0,
                      //                 150000000,
                      //                 300000000,
                      //                 500000000,
                      //                 750000000,
                      //               ],
                      //               format: (v) =>
                      //                   'Rp${ThousandsFormatterString.format(v.toString())}}',
                      //               divisions: true,
                      //             ),
                      //           ),
                      //           datasets: [
                      //             pw.BarDataSet(
                      //               legend: 'Total',
                      //               width: 15,
                      //               offset: -10,
                      //               data: List<pw.PointChartValue>.generate(
                      //                 (data.data as List<LaporanPendapatan>)
                      //                         .length -
                      //                     1,
                      //                 (index) {
                      //                   final v = (data.data as List<
                      //                           LaporanPendapatan>)[index]
                      //                       .total;
                      //                   return pw.PointChartValue(
                      //                       index.toDouble(),
                      //                       int.parse(v).toDouble());
                      //                 },
                      //               ),
                      //               color: PdfColors.blue,
                      //             ),
                      //           ],
                      //         ),
                      //       )
                      //     : pw.SizedBox(),
                    ],
                  ),
                ),
              ],
            ),
          );
        }));

    return await doc.save();
  }
}
