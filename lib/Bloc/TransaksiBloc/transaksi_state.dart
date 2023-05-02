import 'package:web_gofit/Model/transaksi.dart';

import '../../Model/kelas.dart';
import '../../Model/member.dart';
import '../../Model/promo.dart';
import '../../StateBlocTemplate/form_submission_state.dart';
import '../../StateBlocTemplate/page_fetched_data_state.dart';

class TransaksiState {
  final List<Promo> promoList;
  final List<Member> memberList;
  final List<Kelas> kelasList;
  final PageFetchedDataState pageFetchedDataState;
  final FormSubmissionState transaksiFormSubmissionState;
  final Transaksi transaksiForm;
  final Transaksi transaksiError;
  final bool jenisTransaksiEnabled;
  final bool nominalEnabled;
  final String nominalPrefix;
  final bool kelasEnabled;
  final bool cashEnabled;
  final int cashInputForm;
  final bool submitButtonEnabled;

  TransaksiState({
    this.promoList = const [],
    this.memberList = const [],
    this.kelasList = const [],
    this.pageFetchedDataState = const InitialPageFetchedDataState(),
    this.transaksiFormSubmissionState = const InitialFormState(),
    this.transaksiForm = const Transaksi(),
    this.transaksiError = const Transaksi(),
    this.jenisTransaksiEnabled = false,
    this.nominalEnabled = false,
    this.nominalPrefix = '',
    this.kelasEnabled = false,
    this.cashEnabled = false,
    this.cashInputForm = 0,
    this.submitButtonEnabled = false,
  });

  TransaksiState copyWith(
      {List<Promo>? promoList,
      List<Member>? memberList,
      List<Kelas>? kelasList,
      PageFetchedDataState? pageFetchedDataState,
      FormSubmissionState? transaksiFormSubmissionState,
      Transaksi? transaksiForm,
      Transaksi? transaksiError,
      bool? jenisTransaksiEnabled,
      bool? nominalEnabled,
      String? nominalPrefix,
      bool? kelasEnabled,
      bool? cashEnabled,
      int? cashInputForm,
      bool? submitButtonEnabled}) {
    return TransaksiState(
      promoList: promoList ?? this.promoList,
      memberList: memberList ?? this.memberList,
      kelasList: kelasList ?? this.kelasList,
      pageFetchedDataState: pageFetchedDataState ?? this.pageFetchedDataState,
      transaksiFormSubmissionState:
          transaksiFormSubmissionState ?? this.transaksiFormSubmissionState,
      transaksiForm: transaksiForm ?? this.transaksiForm,
      transaksiError: transaksiError ?? this.transaksiError,
      jenisTransaksiEnabled:
          jenisTransaksiEnabled ?? this.jenisTransaksiEnabled,
      nominalEnabled: nominalEnabled ?? this.nominalEnabled,
      nominalPrefix: nominalPrefix ?? this.nominalPrefix,
      kelasEnabled: kelasEnabled ?? this.kelasEnabled,
      cashEnabled: cashEnabled ?? this.cashEnabled,
      cashInputForm: cashInputForm ?? this.cashInputForm,
      submitButtonEnabled: submitButtonEnabled ?? this.submitButtonEnabled,
    );
  }
}
