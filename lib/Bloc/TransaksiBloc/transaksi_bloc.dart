import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/TransaksiBloc/transaksi_event.dart';
import 'package:web_gofit/Bloc/TransaksiBloc/transaksi_state.dart';
import 'package:web_gofit/Model/kelas.dart';
import 'package:web_gofit/Repository/kelas_repository.dart';
import 'package:web_gofit/Repository/member_repository.dart';
import 'package:web_gofit/Repository/promo_repository.dart';
import 'package:web_gofit/Repository/transaksi_repository.dart';
import 'package:web_gofit/StateBlocTemplate/page_fetched_data_state.dart';

import '../../Asset/thousands_formater.dart';
import '../../Model/member.dart';
import '../../Model/promo.dart';
import '../../StateBlocTemplate/form_submission_state.dart';
import '../../const.dart';
import '../AppBloc/app_bloc.dart';

class TransaksiBloc extends Bloc<TransaksiEvent, TransaksiState> {
  final TransaksiRepository transaksiRepository;
  final PromoRepository promoRepository;
  final KelasRepository kelasRepository;
  final MemberRepository memberRepository;
  final AppBloc appBloc;

  TransaksiBloc(
      {required this.appBloc,
      required this.transaksiRepository,
      required this.kelasRepository,
      required this.promoRepository,
      required this.memberRepository})
      : super(TransaksiState()) {
    on<PageDataFetched>((event, emit) => _onPageDataFetched(event, emit));
    on<TransaksiFormChanged>(
        (event, emit) => _onTransaksiFormChanged(event, emit));
    on<MemberFormChanged>((event, emit) => _onMemberFormChanged(event, emit));
    on<JenisTransaksiFormChanged>(
        (event, emit) => _onJenisTransaksiFormChanged(event, emit));
    on<NominalFormChanged>((event, emit) => _onNominalFormChanged(event, emit));
    on<KelasFormChanged>((event, emit) => _onKelasFormChanged(event, emit));
    on<CashFormChanged>((event, emit) => _onCashFormChanged(event, emit));
    on<TransaksiFormInputErrorChanged>(
        (event, emit) => _onTransaksiFormInputErrorChanged(event, emit));

    on<CancelTransaksiRequested>(
        (event, emit) => _onCancelTransaksiRequested(event, emit));
    on<TransaksiFormSubmitted>(
        (event, emit) => _onTransaksiFormSubmitted(event, emit));
  }

  void _onPageDataFetched(
      PageDataFetched event, Emitter<TransaksiState> emit) async {
    emit(state.copyWith(
      pageFetchedDataState: PageFetchedDataLoading(),
      transaksiFormSubmissionState: const InitialFormState(),
    ));
    try {
      final kelasList = await kelasRepository.get();
      final promoList = await promoRepository.get();
      final memberList = await memberRepository.get();
      kelasList.insert(0, Kelas.empty);
      promoList.insert(0, Promo.empty);
      memberList.insert(0, Member.empty);
      emit(state.copyWith(
        kelasList: kelasList,
        promoList: promoList,
        memberList: memberList,
        transaksiForm: state.transaksiForm.copyWith(
          kelas: kelasList[0],
          promo: promoList[0],
          member: memberList[0],
          kasir: appBloc.state.user,
          jenisTransaksi: jenisTransaksi[0],
          tanggalTransaksi:
              '${DateTime.now().year}-${DateTime.now().month.toString().padLeft(2, '0')}-${DateTime.now().day.toString().padLeft(2, '0')}',
        ),
        pageFetchedDataState: PageFetchedDataSuccess(kelasList),
      ));
    } on FailedToLoadKelas catch (e) {
      emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataFailed(e.message.toString()),
      ));
    } on FailedToLoadPromo catch (e) {
      emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataFailed(e.message.toString()),
      ));
    } on FailedToLoadMember catch (e) {
      emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataFailed(e.message.toString()),
      ));
    } catch (e) {
      emit(state.copyWith(
        pageFetchedDataState: PageFetchedDataFailed(e.toString()),
      ));
    }
  }

  void _onTransaksiFormChanged(
      TransaksiFormChanged event, Emitter<TransaksiState> emit) {
    emit(state.copyWith(
      transaksiForm: event.transaksiFrom,
      transaksiFormSubmissionState: const InitialFormState(),
    ));
  }

  void _onMemberFormChanged(
      MemberFormChanged event, Emitter<TransaksiState> emit) {
    emit(state.copyWith(
      transaksiForm: state.transaksiForm.copyWith(
        member: event.member,
        jenisTransaksi: jenisTransaksi[0],
        promo: Promo.empty,
        nominalDeposit: '',
        kelas: Kelas.empty,
      ),
      jenisTransaksiEnabled: true,
      nominalEnabled: false,
      nominalPrefix: '',
      kelasEnabled: false,
      cashEnabled: false,
      submitButtonEnabled: false,
      transaksiFormSubmissionState: const InitialFormState(),
    ));
  }

  void _onJenisTransaksiFormChanged(
      JenisTransaksiFormChanged event, Emitter<TransaksiState> emit) {
    emit(state.copyWith(
      transaksiForm: state.transaksiForm.copyWith(
        jenisTransaksi: event.jenisTransaksi,
        promo: Promo.empty,
        nominalDeposit: '',
        kelas: Kelas.empty,
      ),
      cashEnabled: false,
      submitButtonEnabled: false,
      transaksiFormSubmissionState: const InitialFormState(),
    ));
    if (event.jenisTransaksi == jenisTransaksi[0]) {
      emit(state.copyWith(
        nominalEnabled: false,
        nominalPrefix: '',
        kelasEnabled: false,
        cashEnabled: false,
        submitButtonEnabled: false,
      ));
    } else if (event.jenisTransaksi == jenisTransaksi[1]) {
      emit(state.copyWith(
        nominalEnabled: false,
        nominalPrefix: 'Rp ',
        kelasEnabled: false,
        cashEnabled: true,
        submitButtonEnabled: false,
      ));
    } else if (event.jenisTransaksi == jenisTransaksi[2]) {
      emit(state.copyWith(
        nominalEnabled: true,
        nominalPrefix: 'Rp ',
        kelasEnabled: false,
        cashEnabled: false,
        submitButtonEnabled: false,
      ));
    } else {
      if (state.transaksiForm.member.depositKelasPaket != 0) {
        emit(state.copyWith(
          transaksiFormSubmissionState: const SubmissionFailed(
              "Member sudah mempunyai deposit Kelas Paket"),
          transaksiForm: state.transaksiForm.copyWith(
            jenisTransaksi: jenisTransaksi[0],
          ),
          nominalEnabled: false,
          nominalPrefix: '',
          kelasEnabled: false,
          cashEnabled: false,
          submitButtonEnabled: false,
        ));
      }
      emit(state.copyWith(
        nominalEnabled: true,
        nominalPrefix: '',
        kelasEnabled: true,
        cashEnabled: false,
        submitButtonEnabled: false,
      ));
    }
  }

  void _onNominalFormChanged(
      NominalFormChanged event, Emitter<TransaksiState> emit) {
    emit(state.copyWith(
      transaksiForm: state.transaksiForm.copyWith(
        promo: Promo.empty,
        nominalDeposit: event.nominal,
      ),
      cashEnabled: false,
      submitButtonEnabled: false,
      transaksiFormSubmissionState: const InitialFormState(),
    ));
    if (int.parse(event.nominal) <
            appBloc.state.informasiUmum.minDepositReguler &&
        state.transaksiForm.jenisTransaksi == jenisTransaksi[2]) {
      emit(state.copyWith(
        transaksiError: state.transaksiError.copyWith(
            nominalDeposit:
                "Min Rp ${ThousandsFormatterString.format(appBloc.state.informasiUmum.minDepositReguler.toString())}"),
      ));
    } else {
      emit(state.copyWith(
        transaksiError: state.transaksiError.copyWith(nominalDeposit: ''),
      ));
    }
    if (state.transaksiForm.jenisTransaksi == jenisTransaksi[2] ||
        state.transaksiForm.jenisTransaksi == jenisTransaksi[3] &&
            event.nominal != '') {
      Promo getPromo = Promo.empty;
      for (var promo in state.promoList) {
        if (state.transaksiForm.jenisTransaksi == promo.jenisTransaksi &&
            int.parse(event.nominal) >= promo.kriteriaPembelian) {
          getPromo = promo;
        }
      }
      emit(state.copyWith(
        transaksiForm: state.transaksiForm.copyWith(
          promo: getPromo,
        ),
        cashEnabled: true,
      ));
    }
  }

  void _onKelasFormChanged(
      KelasFormChanged event, Emitter<TransaksiState> emit) {
    emit(state.copyWith(
      transaksiForm: state.transaksiForm.copyWith(
        promo: Promo.empty,
        kelas: event.kelas,
      ),
      cashEnabled: false,
      submitButtonEnabled: false,
      transaksiFormSubmissionState: const InitialFormState(),
    ));
    if (state.transaksiForm.jenisTransaksi == jenisTransaksi[3] &&
        state.transaksiForm.nominalDeposit != '') {
      Promo getPromo = Promo.empty;
      for (var promo in state.promoList) {
        if (state.transaksiForm.jenisTransaksi == promo.jenisTransaksi &&
            int.parse(state.transaksiForm.nominalDeposit) >=
                promo.kriteriaPembelian) {
          getPromo = promo;
        }
      }
      emit(state.copyWith(
        transaksiForm: state.transaksiForm.copyWith(
          promo: getPromo,
        ),
        cashEnabled: true,
      ));
    }
  }

  void _onCashFormChanged(CashFormChanged event, Emitter<TransaksiState> emit) {
    emit(state.copyWith(cashInputForm: event.cash));
    if (event.cash >= int.parse(hitungGrandTotal())) {
      emit(state.copyWith(submitButtonEnabled: true));
    } else {
      emit(state.copyWith(submitButtonEnabled: false));
    }
    if (state.transaksiError.isNoEmpty) {
      emit(state.copyWith(submitButtonEnabled: false));
    }
  }

  void _onTransaksiFormInputErrorChanged(
      TransaksiFormInputErrorChanged event, Emitter<TransaksiState> emit) {
    emit(state.copyWith(
      transaksiError: event.transaksiError,
      transaksiFormSubmissionState: const InitialFormState(),
    ));
  }

  void _onCancelTransaksiRequested(
      CancelTransaksiRequested event, Emitter<TransaksiState> emit) {
    emit(state.copyWith(
      transaksiForm: state.transaksiForm.copyWith(
        kelas: state.kelasList[0],
        promo: state.promoList[0],
        member: state.memberList[0],
        kasir: appBloc.state.user,
        jenisTransaksi: jenisTransaksi[0],
        tanggalTransaksi:
            '${DateTime.now().year}-${DateTime.now().month}-${DateTime.now().day}',
        nominalDeposit: '',
        sisaDeposit: 0,
        totalDeposit: 0,
      ),
      transaksiFormSubmissionState: const InitialFormState(),
      jenisTransaksiEnabled: false,
      nominalEnabled: false,
      nominalPrefix: '',
      kelasEnabled: false,
      cashEnabled: false,
      submitButtonEnabled: false,
    ));
  }

  void _onTransaksiFormSubmitted(
      TransaksiFormSubmitted event, Emitter<TransaksiState> emit) async {
    emit(state.copyWith(
      transaksiFormSubmissionState: FormSubmitting(),
    ));
    try {
      if (state.transaksiForm.jenisTransaksi == jenisTransaksi[1]) {
        await transaksiRepository.aktivasi(state.transaksiForm);
      } else if (state.transaksiForm.jenisTransaksi == jenisTransaksi[2]) {
        await transaksiRepository.depositReguler(state.transaksiForm);
      } else {
        await transaksiRepository.depositKelasPaket(state.transaksiForm);
      }
      emit(state.copyWith(transaksiFormSubmissionState: SubmissionSuccess()));
    } on ErrorValidateFromTransaksi catch (e) {
      emit(state.copyWith(
          transaksiError: e.transaksi,
          transaksiFormSubmissionState: SubmissionFailed(e.toString())));
    } catch (e) {
      emit(state.copyWith(
          transaksiFormSubmissionState: SubmissionFailed(e.toString())));
    }
  }

  String hitungGrandTotal() {
    if (state.transaksiForm.jenisTransaksi == jenisTransaksi[0]) {
      return '0';
    } else if (state.transaksiForm.jenisTransaksi == jenisTransaksi[1]) {
      return appBloc.state.informasiUmum.biayaAktivasiMembership.toString();
    } else if (state.transaksiForm.jenisTransaksi == jenisTransaksi[2] &&
        state.transaksiForm.nominalDeposit != '') {
      return state.transaksiForm.nominalDeposit;
    } else if (state.transaksiForm.jenisTransaksi == jenisTransaksi[3] &&
        state.transaksiForm.nominalDeposit != '' &&
        state.transaksiForm.kelas.isNoEmpty) {
      return (int.parse(state.transaksiForm.kelas.harga) *
              int.parse(state.transaksiForm.nominalDeposit))
          .toString();
    } else {
      return '0';
    }
  }
}
