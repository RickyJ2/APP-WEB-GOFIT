import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:web_gofit/Bloc/AppBloc/app_bloc.dart';
import 'package:web_gofit/Bloc/LaporanBloc/laporan_bloc.dart';
import 'package:web_gofit/Bloc/LaporanBloc/laporan_event.dart';
import 'package:web_gofit/Bloc/LaporanBloc/laporan_state.dart';
import 'package:web_gofit/Repository/laporan_repository.dart';

import '../Asset/create_drop_down_button.dart';
import '../StateBlocTemplate/form_submission_state.dart';
import '../const.dart';

class LaporanPage extends StatelessWidget {
  const LaporanPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<LaporanBloc>(
      create: (context) => LaporanBloc(
          laporanRepository: LaporanRepository(),
          appBloc: BlocProvider.of<AppBloc>(context)),
      child: const LaporanView(),
    );
  }
}

class LaporanView extends StatefulWidget {
  const LaporanView({super.key});

  @override
  State<LaporanView> createState() => _LaporanViewState();
}

class _LaporanViewState extends State<LaporanView> {
  @override
  Widget build(BuildContext context) {
    return BlocListener<LaporanBloc, LaporanState>(
      listener: (context, state) {
        if (state.formSubmissionState is SubmissionSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text("Laporan Berhasil digenerate"),
            ),
          );
          //print laporan
        }
        if (state.formSubmissionState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  (state.formSubmissionState as SubmissionFailed).exception),
            ),
          );
        }
      },
      child: BlocBuilder<LaporanBloc, LaporanState>(
        builder: (context, state) => Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const TitleLabel(),
            const SizedBox(height: 30),
            FractionallySizedBox(
              alignment: Alignment.topLeft,
              widthFactor: MediaQuery.of(context).size.width > 800 ? 0.7 : 1,
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.end,
                children: [
                  CreateDropDownButton(
                    label: "Jenis Laporan",
                    value: state.laporanType,
                    items: laporanTypeList
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      context.read<LaporanBloc>().add(
                          LaporanTypeChanged(laporanType: value.toString()));
                    },
                  ),
                  const SizedBox(height: 30),
                  CreateDropDownButton(
                    label: "Bulan",
                    errorText: state.bulanError == '' ? null : state.bulanError,
                    value: state.bulanForm,
                    items: bulan
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: state.laporanType == laporanTypeList[0]
                        ? null
                        : (value) {
                            context.read<LaporanBloc>().add(
                                LaporanBulanChanged(bulan: value.toString()));
                          },
                  ),
                  const SizedBox(height: 30),
                  CreateDropDownButton(
                    label: "Tahun",
                    errorText: state.tahunError == '' ? null : state.tahunError,
                    value: state.tahunForm,
                    items: yearList
                        .map((e) => DropdownMenuItem(
                              value: e,
                              child: Text(e),
                            ))
                        .toList(),
                    onChanged: (value) {
                      context
                          .read<LaporanBloc>()
                          .add(LaporanTahunChanged(tahun: value.toString()));
                    },
                  ),
                  const SizedBox(height: 30),
                  ElevatedButton(
                    onPressed: (state.laporanType == laporanTypeList[0] &&
                                state.tahunForm != '') ||
                            (state.bulanForm != '' && state.tahunForm != '')
                        ? () {
                            context
                                .read<LaporanBloc>()
                                .add(LaporanFormSubmitted());
                          }
                        : null,
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          vertical: 15, horizontal: 20),
                      child: Text(
                        'Generate',
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
            ),
          ],
        ),
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
        text: 'Laporan ',
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
