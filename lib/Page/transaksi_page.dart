import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/TransaksiBloc/transaksi_state.dart';

import '../Asset/create_drop_down_button.dart';
import '../Asset/create_text_form_field.dart';
import '../Asset/create_text_to_text_field.dart';
import '../Asset/create_type_ahead_form_field.dart';
import '../Asset/thousands_formater.dart';
import '../Bloc/AppBloc/app_bloc.dart';
import '../Bloc/TransaksiBloc/transaksi_bloc.dart';
import '../Bloc/TransaksiBloc/transaksi_event.dart';
import '../Repository/kelas_repository.dart';
import '../Repository/member_repository.dart';
import '../Repository/promo_repository.dart';
import '../Repository/transaksi_repository.dart';
import '../StateBlocTemplate/form_submission_state.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';
import '../const.dart';

class TransaksiPage extends StatelessWidget {
  const TransaksiPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => TransaksiBloc(
        appBloc: BlocProvider.of<AppBloc>(context),
        transaksiRepository: TransaksiRepository(),
        kelasRepository: KelasRepository(),
        promoRepository: PromoRepository(),
        memberRepository: MemberRepository(),
      ),
      child: const Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TitleLabel(),
          SizedBox(height: 30),
          TransaksiView(),
        ],
      ),
    );
  }
}

class TitleLabel extends StatelessWidget {
  const TitleLabel({super.key});

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: const TextSpan(
        text: 'Transaksi ',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 24,
        ),
        children: [
          TextSpan(
            text: 'GoFit',
            style: TextStyle(
              fontFamily: 'SchibstedGrotesk',
              fontSize: 24,
              fontWeight: FontWeight.bold,
            ),
          ),
        ],
      ),
    );
  }
}

class TransaksiView extends StatefulWidget {
  const TransaksiView({super.key});

  @override
  State<TransaksiView> createState() => _TransaksiViewState();
}

class _TransaksiViewState extends State<TransaksiView> {
  @override
  void initState() {
    super.initState();
    context.read<TransaksiBloc>().add(PageDataFetched());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransaksiBloc, TransaksiState>(
      listenWhen: (previous, current) =>
          previous.pageFetchedDataState != current.pageFetchedDataState ||
          previous.transaksiFormSubmissionState !=
              current.transaksiFormSubmissionState,
      listener: (context, state) {
        if (state.pageFetchedDataState is PageFetchedDataFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                (state.pageFetchedDataState as PageFetchedDataFailed)
                    .exception
                    .toString(),
              ),
            ),
          );
        }
        if (state.transaksiFormSubmissionState is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Transaksi berhasil dibuat'),
            ),
          );
          context.read<TransaksiBloc>().add(PageDataFetched());
        }
        if (state.transaksiFormSubmissionState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                (state.transaksiFormSubmissionState as SubmissionFailed)
                    .exception
                    .toString(),
              ),
            ),
          );
        }
      },
      child: BlocBuilder<TransaksiBloc, TransaksiState>(
        builder: (context, state) {
          return state.pageFetchedDataState is PageFetchedDataLoading ||
                  state.kelasList.isEmpty ||
                  state.memberList.isEmpty ||
                  state.promoList.isEmpty
              ? const Center(child: CircularProgressIndicator())
              : Form(
                  child: Column(
                    children: [
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Flexible(
                            fit: FlexFit.loose,
                            child: Section1(),
                          ),
                          SizedBox(width: 20),
                          Flexible(
                            fit: FlexFit.loose,
                            child: Section2(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      const Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Expanded(
                            flex: 1,
                            child: DaftarHargaPromoViewSection(),
                          ),
                          Expanded(
                            flex: 1,
                            child: Padding(
                              padding: EdgeInsets.only(left: 30, right: 30),
                              child: SummarySection(),
                            ),
                          ),
                          Flexible(
                            flex: 2,
                            fit: FlexFit.loose,
                            child: PaymentSection(),
                          ),
                        ],
                      ),
                      const SizedBox(height: 30),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.end,
                        children: [
                          ElevatedButton(
                            onPressed: () {
                              context
                                  .read<TransaksiBloc>()
                                  .add(CancelTransaksiRequested());
                            },
                            style: ButtonStyle(
                              backgroundColor: MaterialStateProperty.all<Color>(
                                  errorTextColor),
                              foregroundColor: MaterialStateProperty.all<Color>(
                                  Colors.white),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              child: Text(
                                'Cancel',
                                style: TextStyle(
                                  fontFamily: 'SchibstedGrotesk',
                                  fontSize: 15,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 15),
                          ElevatedButton(
                            onPressed: state.submitButtonEnabled
                                ? () {
                                    context
                                        .read<TransaksiBloc>()
                                        .add(TransaksiFormSubmitted());
                                  }
                                : null,
                            style: ButtonStyle(
                              backgroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.grey; // Disabled button color
                                  }
                                  return Colors.green; // Default button color
                                },
                              ),
                              foregroundColor:
                                  MaterialStateProperty.resolveWith<Color>(
                                (Set<MaterialState> states) {
                                  if (states.contains(MaterialState.disabled)) {
                                    return Colors.black.withOpacity(
                                        0.5); // Disabled button text color
                                  }
                                  return Colors
                                      .white; // Default button text color
                                },
                              ),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 20),
                              child: Text(
                                'Proses Transaksi',
                                style: TextStyle(
                                  fontFamily: 'SchibstedGrotesk',
                                  fontSize: 15,
                                  color: textColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                );
        },
      ),
    );
  }
}

class Section1 extends StatefulWidget {
  const Section1({super.key});

  @override
  State<Section1> createState() => _Section1State();
}

class _Section1State extends State<Section1> {
  final TextEditingController _memberTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _memberTextController.text =
        '${context.read<TransaksiBloc>().state.transaksiForm.member.id} - ${context.read<TransaksiBloc>().state.transaksiForm.member.nama}';
  }

  @override
  void dispose() {
    _memberTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransaksiBloc, TransaksiState>(
      listenWhen: (previous, current) => current.transaksiForm.member.isEmpty,
      listener: (context, state) {
        if (state.transaksiForm.member.isEmpty) {
          _memberTextController.text = '-';
        }
      },
      child: BlocBuilder<TransaksiBloc, TransaksiState>(
        builder: (context, state) {
          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              CreateTextToTextField(
                label: 'Tanggal Transaksi',
                textField: CreateTextFormField(
                  hintText: 'Tanggal transaksi',
                  enabled: false,
                  initialValue: state.transaksiForm.tanggalTransaksi,
                ),
              ),
              const SizedBox(height: 10),
              CreateTextToTextField(
                label: 'Kasir',
                textField: CreateTextFormField(
                  hintText: 'Kasir',
                  enabled: false,
                  initialValue:
                      '${state.transaksiForm.kasir.id} - ${state.transaksiForm.kasir.nama}',
                ),
              ),
              const SizedBox(height: 10),
              CreateTextToTextField(
                label: 'Member',
                textField: CreateTypeAheadFormField(
                  controller: _memberTextController,
                  hintText: 'Pilih Member yang melakukan transaksi',
                  suggestionsCallback: (pattern) async {
                    return state.memberList
                        .where((element) => '${element.id} - ${element.nama}'
                            .toLowerCase()
                            .contains(pattern.toLowerCase()))
                        .toList();
                  },
                  itemBuilder: (context, member) {
                    return ListTile(
                      title: Text('${member.id} - ${member.nama}'),
                    );
                  },
                  onSuggestionSelected: (member) {
                    _memberTextController.text =
                        '${member.id} - ${member.nama}';
                    context
                        .read<TransaksiBloc>()
                        .add(MemberFormChanged(member: member));
                  },
                  validator: (value) => state.transaksiError.member.id == ''
                      ? null
                      : state.transaksiError.member.id,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}

class Section2 extends StatefulWidget {
  const Section2({super.key});

  @override
  State<Section2> createState() => _Section2State();
}

class _Section2State extends State<Section2> {
  final TextEditingController _kelasTextController = TextEditingController();
  final TextEditingController _nominalTextController = TextEditingController();
  final TextEditingController _promoTextController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _kelasTextController.text =
        context.read<TransaksiBloc>().state.transaksiForm.kelas.nama;
    _nominalTextController.text = '';
    _promoTextController.text = '';
  }

  @override
  void dispose() {
    _kelasTextController.dispose();
    _nominalTextController.dispose();
    _promoTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransaksiBloc, TransaksiState>(
      listenWhen: (previous, current) =>
          previous.transaksiForm.promo != current.transaksiForm.promo ||
          (current.transaksiForm.nominalDeposit == '' &&
              _nominalTextController.text != '') ||
          (current.transaksiForm.kelas.isEmpty &&
              _kelasTextController.text != ''),
      listener: (context, state) {
        _promoTextController.text = ThousandsFormatterString.format(
            state.transaksiForm.promo.bonus.toString());
        if (state.transaksiForm.nominalDeposit == '') {
          _nominalTextController.text = state.transaksiForm.nominalDeposit;
        }
        if (state.transaksiForm.kelas.isEmpty) {
          _kelasTextController.text = state.transaksiForm.kelas.nama;
        }
      },
      child:
          BlocBuilder<TransaksiBloc, TransaksiState>(builder: (context, state) {
        return Column(
          children: [
            CreateTextToTextField(
              label: 'Jenis Transaksi',
              textField: CreateDropDownButton(
                errorText: state.transaksiError.jenisTransaksi == ''
                    ? null
                    : state.transaksiError.jenisTransaksi,
                value: state.transaksiForm.jenisTransaksi,
                items: jenisTransaksi.map((String value) {
                  return DropdownMenuItem<String>(
                    value: value,
                    child: Text(value),
                  );
                }).toList(),
                onChanged: state.jenisTransaksiEnabled
                    ? (value) {
                        context.read<TransaksiBloc>().add(
                            JenisTransaksiFormChanged(
                                jenisTransaksi: value.toString()));
                      }
                    : null,
              ),
            ),
            const SizedBox(height: 10),
            Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                Flexible(
                  flex: 1,
                  child: CreateTextToTextField(
                    textFlex: 1,
                    textFieldFlex: 1,
                    label: 'Nominal',
                    textField: state.transaksiForm.jenisTransaksi ==
                            jenisTransaksi[3]
                        ? CreateDropDownButton(
                            value: state.transaksiForm.nominalDeposit,
                            items: const [
                              DropdownMenuItem<String>(
                                value: '',
                                child: Text(''),
                              ),
                              DropdownMenuItem<String>(
                                value: '5',
                                child: Text('5'),
                              ),
                              DropdownMenuItem<String>(
                                value: '10',
                                child: Text('10'),
                              ),
                            ],
                            onChanged: state.nominalEnabled
                                ? (value) {
                                    context.read<TransaksiBloc>().add(
                                        NominalFormChanged(
                                            nominal: (value ?? '')
                                                .toString()
                                                .replaceAll(',', '')));
                                  }
                                : null,
                            errorText: state.transaksiError.nominalDeposit == ''
                                ? null
                                : state.transaksiError.nominalDeposit,
                          )
                        : CreateTextFormField(
                            controller: _nominalTextController,
                            prefix: Text(state.nominalPrefix),
                            hintText:
                                'Nominal Deposit ${state.transaksiForm.jenisTransaksi}',
                            keyboardType: TextInputType.number,
                            inputFormatter: [
                              FilteringTextInputFormatter.digitsOnly,
                              ThousandsFormatter(),
                            ],
                            onChanged: (value) {
                              context.read<TransaksiBloc>().add(
                                  NominalFormChanged(
                                      nominal:
                                          (value ?? '').replaceAll(',', '')));
                            },
                            enabled: state.nominalEnabled,
                            validator: (value) =>
                                state.transaksiError.nominalDeposit == ''
                                    ? null
                                    : state.transaksiError.nominalDeposit,
                          ),
                  ),
                ),
                Flexible(
                  flex: 1,
                  child: Padding(
                    padding: const EdgeInsets.only(left: 15),
                    child: CreateTextToTextField(
                      label: 'Kelas',
                      textField: CreateTypeAheadFormField(
                        controller: _kelasTextController,
                        hintText: 'Pilih Kelas Deposit Kelas Paket',
                        suggestionsCallback: (pattern) async {
                          return state.kelasList
                              .where((element) => element.nama
                                  .toLowerCase()
                                  .contains(pattern.toLowerCase()))
                              .toList();
                        },
                        itemBuilder: (context, kelas) {
                          return ListTile(
                            title: Text(kelas.nama),
                          );
                        },
                        onSuggestionSelected: (kelas) {
                          _kelasTextController.text = kelas.nama;
                          context
                              .read<TransaksiBloc>()
                              .add(KelasFormChanged(kelas: kelas));
                        },
                        validator: (value) =>
                            state.transaksiError.kelas.id == ''
                                ? null
                                : state.transaksiError.kelas.id,
                        enabled: state.kelasEnabled,
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 10),
            CreateTextToTextField(
              label: 'Promo',
              textField: CreateTextFormField(
                prefix: Text(state.nominalPrefix),
                controller: _promoTextController,
                hintText: 'Belum ada promo yang dapat teraplikasikan',
                enabled: false,
              ),
            ),
          ],
        );
      }),
    );
  }
}

class DaftarHargaPromoViewSection extends StatelessWidget {
  const DaftarHargaPromoViewSection({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        RichText(
          text: const TextSpan(
            text: 'Daftar Harga dan Promo ',
            style: TextStyle(
              fontFamily: 'Roboto',
              fontSize: 14,
              fontWeight: FontWeight.bold,
            ),
            children: [
              TextSpan(
                text: 'GoFit',
                style: TextStyle(
                  fontFamily: 'SchibstedGrotesk',
                  fontSize: 14,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 5),
        Text(
          'Biaya aktivasi membership 1 tahun : Rp ${ThousandsFormatterString.format(BlocProvider.of<AppBloc>(context).state.informasiUmum.biayaAktivasiMembership.toString())}',
          softWrap: true,
        ),
        const SizedBox(height: 10),
        const Text('Promo Deposit Reguler',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: BlocProvider.of<TransaksiBloc>(context)
              .state
              .promoList
              .map((promo) {
            return promo.jenisTransaksi == jenisTransaksi[2]
                ? Text(
                    'Setiap pembelian deposit reguler Rp ${ThousandsFormatterString.format(promo.kriteriaPembelian.toString())} dapatkan bonus deposit reguler Rp ${ThousandsFormatterString.format(promo.bonus.toString())}',
                    softWrap: true,
                  )
                : const SizedBox();
          }).toList(),
        ),
        const SizedBox(height: 10),
        const Text('Promo Deposit Kelas Paket',
            style: TextStyle(fontWeight: FontWeight.bold)),
        const SizedBox(height: 5),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: BlocProvider.of<TransaksiBloc>(context)
              .state
              .promoList
              .map((promo) {
            return promo.jenisTransaksi == jenisTransaksi[3]
                ? Text(
                    'Setiap pembelian deposit kelas paket ${promo.kriteriaPembelian} dapatkan bonus deposit kelas paket ${promo.bonus}',
                    softWrap: true,
                  )
                : const SizedBox();
          }).toList(),
        ),
      ],
    );
  }
}

class SummarySection extends StatelessWidget {
  const SummarySection({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<TransaksiBloc, TransaksiState>(
        builder: (context, state) {
      return Column(
        mainAxisAlignment: MainAxisAlignment.start,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text('SUMMARY TRANSAKSI',
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(
            height: 10,
          ),
          Text(
              'Member: ${state.transaksiForm.member.id} - ${state.transaksiForm.member.nama}'),
          const SizedBox(height: 10),
          state.transaksiForm.jenisTransaksi == jenisTransaksi[1]
              ? const Text('Masa aktif membership 1 Tahun')
              : const SizedBox(),
          state.transaksiForm.jenisTransaksi == jenisTransaksi[2]
              ? Text(
                  'Total Deposit Reguler: Rp ${ThousandsFormatterString.format((int.parse(state.transaksiForm.nominalDeposit == '' ? '0' : state.transaksiForm.nominalDeposit) + state.transaksiForm.promo.bonus).toString())}')
              : const SizedBox(),
          state.transaksiForm.jenisTransaksi == jenisTransaksi[3]
              ? Text(
                  'Total Deposit kelas Paket: ${int.parse(state.transaksiForm.nominalDeposit == '' ? '0' : state.transaksiForm.nominalDeposit) + state.transaksiForm.promo.bonus}')
              : const SizedBox(),
          state.transaksiForm.jenisTransaksi == jenisTransaksi[3]
              ? Text(
                  'Masa aktif deposit kelas paket: ${(int.parse(state.transaksiForm.nominalDeposit == '' ? '0' : state.transaksiForm.nominalDeposit)) > 10 ? 2 : 1} Bulan')
              : const SizedBox(),
          Text(
              'Grand Total: Rp ${ThousandsFormatterString.format(context.read<TransaksiBloc>().hitungGrandTotal())}'),
          const SizedBox(height: 10),
        ],
      );
    });
  }
}

class PaymentSection extends StatefulWidget {
  const PaymentSection({super.key});

  @override
  State<PaymentSection> createState() => _PaymentSectionState();
}

class _PaymentSectionState extends State<PaymentSection> {
  final TextEditingController _grandTotalTextController =
      TextEditingController();
  final TextEditingController _cashTextController = TextEditingController();
  final TextEditingController _kembalianTextController =
      TextEditingController();
  @override
  void initState() {
    super.initState();
    _grandTotalTextController.text = ThousandsFormatterString.format(
        context.read<TransaksiBloc>().hitungGrandTotal());
    _cashTextController.text = '';
    _kembalianTextController.text = '';
  }

  @override
  void dispose() {
    _grandTotalTextController.dispose();
    _cashTextController.dispose();
    _kembalianTextController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<TransaksiBloc, TransaksiState>(
      listenWhen: (previous, current) =>
          previous.transaksiForm != current.transaksiForm ||
          previous.cashEnabled != current.cashEnabled,
      listener: (context, state) {
        _grandTotalTextController.text = ThousandsFormatterString.format(
            context.read<TransaksiBloc>().hitungGrandTotal());
        _cashTextController.text = '';
        _kembalianTextController.text = '';
      },
      child:
          BlocBuilder<TransaksiBloc, TransaksiState>(builder: (context, state) {
        return Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            CreateTextToTextField(
              label: 'Grand Total',
              textField: CreateTextFormField(
                prefix: const Text('Rp '),
                controller: _grandTotalTextController,
                hintText: 'Grand Total',
                enabled: false,
              ),
            ),
            const SizedBox(height: 10),
            CreateTextToTextField(
              label: 'Tunai',
              textField: CreateTextFormField(
                enabled: state.cashEnabled,
                prefix: const Text('Rp '),
                controller: _cashTextController,
                hintText: 'Tunai',
                keyboardType: TextInputType.number,
                inputFormatter: [
                  FilteringTextInputFormatter.digitsOnly,
                  ThousandsFormatter(),
                ],
                onChanged: (value) {
                  context.read<TransaksiBloc>().add(CashFormChanged(
                      cash: int.parse((value ?? '0').replaceAll(',', ''))));
                  if (value != null) {
                    _kembalianTextController.text =
                        ThousandsFormatterString.format(
                            (int.parse(value.replaceAll(',', '')) -
                                    int.parse(_grandTotalTextController.text
                                        .replaceAll(',', '')))
                                .toString());
                  } else {
                    _kembalianTextController.text = '';
                  }
                },
              ),
            ),
            const SizedBox(height: 10),
            CreateTextToTextField(
              label: 'Kembalian',
              textField: CreateTextFormField(
                prefix: const Text('Rp '),
                controller: _kembalianTextController,
                hintText: 'Kembalian',
                enabled: false,
              ),
            ),
          ],
        );
      }),
    );
  }
}
