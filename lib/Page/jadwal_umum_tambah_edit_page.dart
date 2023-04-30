import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:web_gofit/Asset/create_text_form_field.dart';
import 'package:web_gofit/Bloc/JadwalUmumBloc/JadwalUmumTambahEditBloc/jadwal_umum_tambah_edit_event.dart';
import 'package:web_gofit/Bloc/JadwalUmumBloc/JadwalUmumTambahEditBloc/jadwal_umum_tambah_edit_state.dart';
import 'package:web_gofit/Model/instruktur.dart';
import 'package:web_gofit/Model/jadwal_umum.dart';
import 'package:web_gofit/Repository/instruktur_repository.dart';
import 'package:web_gofit/Repository/jadwal_umum_repository.dart';
import 'package:web_gofit/Repository/kelas_repository.dart';
import 'package:web_gofit/StateBlocTemplate/form_submission_state.dart';

import '../Asset/create_drop_down_button.dart';
import '../Bloc/JadwalUmumBloc/JadwalUmumTambahEditBloc/jadwal_umum_tambah_edit_bloc.dart';
import '../Model/kelas.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';
import '../const.dart';

class JadwalUmumTambahEditPage extends StatelessWidget {
  final String tambahEdit;
  final JadwalUmum jadwalUmum;
  const JadwalUmumTambahEditPage(
      {super.key, required this.tambahEdit, required this.jadwalUmum});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => JadwalUmumTambahEditBloc(
          instrukturRepository: InstrukturRepository(),
          jadwalUmumRepository: JadwalUmumRepository(),
          kelasRepository: KelasRepository()),
      child: BlocListener<JadwalUmumTambahEditBloc, JadwalUmumTambahEditState>(
        listenWhen: (previous, current) =>
            previous.formSubmissionState != current.formSubmissionState,
        listener: (context, state) {
          if (state.formSubmissionState is SubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data berhasil disimpan'),
              ),
            );
            context.go('/jadwal-umum');
          }
          if (state.formSubmissionState is SubmissionFailed) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(
                content: Text(
                  (state.formSubmissionState as SubmissionFailed)
                      .exception
                      .toString(),
                ),
              ),
            );
          }
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
        },
        child: JadwalUmumTambahEditView(
            jadwalUmum: jadwalUmum, tambahEdit: tambahEdit),
      ),
    );
  }
}

class JadwalUmumTambahEditView extends StatefulWidget {
  final String tambahEdit;
  final JadwalUmum jadwalUmum;
  const JadwalUmumTambahEditView(
      {super.key, required this.tambahEdit, required this.jadwalUmum});

  @override
  State<JadwalUmumTambahEditView> createState() =>
      _JadwalUmumTambahEditViewState();
}

class _JadwalUmumTambahEditViewState extends State<JadwalUmumTambahEditView> {
  @override
  void initState() {
    super.initState();
    if (widget.tambahEdit == 'edit') {
      context.read<JadwalUmumTambahEditBloc>().add(JadwalUmumUpdateTambahEdit(
          tambahEdit: TambahEdit.edit, jadwalUmum: widget.jadwalUmum));
    } else if (widget.tambahEdit == 'tambah') {
      context.read<JadwalUmumTambahEditBloc>().add(JadwalUmumUpdateTambahEdit(
          tambahEdit: TambahEdit.tambah, jadwalUmum: widget.jadwalUmum));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EditTambahLabel(),
        const SizedBox(height: 30),
        TambahEditForm(jadwalUmumInitial: widget.jadwalUmum),
      ],
    );
  }
}

class EditTambahLabel extends StatelessWidget {
  const EditTambahLabel({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JadwalUmumTambahEditBloc, JadwalUmumTambahEditState>(
        builder: (context, state) {
      return RichText(
        text: TextSpan(
          text: state.tambahEdit == TambahEdit.tambah
              ? 'Tambah Data Jadwal Umum '
              : 'Edit Data Jadwal Umum ',
          style: const TextStyle(
            fontFamily: 'Roboto',
            fontSize: 24,
          ),
          children: const [
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
    });
  }
}

class TambahEditForm extends StatefulWidget {
  final JadwalUmum jadwalUmumInitial;
  const TambahEditForm({super.key, required this.jadwalUmumInitial});

  @override
  State<TambahEditForm> createState() => _TambahEditFormState();
}

class _TambahEditFormState extends State<TambahEditForm> {
  final TextEditingController _jamMulaiController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _jamMulaiController.text = widget.jadwalUmumInitial.jamMulai;
    _jamMulaiController.addListener(_onJamMulaiChanged);
  }

  @override
  void dispose() {
    _jamMulaiController.dispose();
    super.dispose();
  }

  void _onJamMulaiChanged() {
    final newValue = _jamMulaiController.text;
    context.read<JadwalUmumTambahEditBloc>().add(
          JadwalUmumJamMulaiFormChanged(jamMulai: newValue),
        );
  }

  Future<void> _selectTime(BuildContext context) async {
    TimeOfDay initTime = TimeOfDay.now();
    if (_jamMulaiController.text.isNotEmpty) {
      initTime = TimeOfDay(
        hour: int.parse(_jamMulaiController.text.split(':')[0]),
        minute: int.parse(_jamMulaiController.text.split(':')[1]),
      );
    }
    final TimeOfDay? picked = await showTimePicker(
      context: context,
      initialTime: initTime,
    );
    if (picked != null) {
      _jamMulaiController.text =
          '${picked.hour.toString().padLeft(2, '0')}:${picked.minute.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<JadwalUmumTambahEditBloc, JadwalUmumTambahEditState>(
      builder: (context, state) {
        return state.pageFetchedDataState is PageFetchedDataLoading ||
                state.instrukturList.isEmpty ||
                state.kelasList.isEmpty
            ? const Center(child: CircularProgressIndicator())
            : Form(
                child: FractionallySizedBox(
                  alignment: Alignment.topLeft,
                  widthFactor:
                      MediaQuery.of(context).size.width > 800 ? 0.7 : 1,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.end,
                    children: [
                      CreateDropDownButton(
                        label: 'Instruktur',
                        errorText: state.jadwalUmumError.instruktur.id == ''
                            ? null
                            : state.jadwalUmumError.instruktur.id,
                        value: state.jadwalUmumForm.instruktur.isEmpty
                            ? state.instrukturList.first
                            : state.jadwalUmumForm.instruktur,
                        items: state.instrukturList.map((value) {
                          return DropdownMenuItem<Instruktur>(
                            value: value,
                            child: Text(value.nama),
                          );
                        }).toList(),
                        onChanged: (value) => context
                            .read<JadwalUmumTambahEditBloc>()
                            .add(JadwalUmumFormChanged(
                                jadwalUmum: state.jadwalUmumForm.copyWith(
                                    instruktur: value as Instruktur))),
                      ),
                      const SizedBox(height: 15),
                      CreateDropDownButton(
                        label: 'Kelas',
                        errorText: state.jadwalUmumError.kelas.id == ''
                            ? null
                            : state.jadwalUmumError.kelas.id,
                        value: state.jadwalUmumForm.kelas.isEmpty
                            ? state.kelasList.first
                            : state.jadwalUmumForm.kelas,
                        items: state.kelasList.map((value) {
                          return DropdownMenuItem<Kelas>(
                            value: value,
                            child: Text(value.nama),
                          );
                        }).toList(),
                        onChanged: (value) => context
                            .read<JadwalUmumTambahEditBloc>()
                            .add(JadwalUmumFormChanged(
                                jadwalUmum: state.jadwalUmumForm
                                    .copyWith(kelas: value as Kelas))),
                      ),
                      const SizedBox(height: 15),
                      CreateDropDownButton(
                        label: 'Hari',
                        errorText: state.jadwalUmumError.hari == ''
                            ? null
                            : state.jadwalUmumError.hari,
                        value: state.jadwalUmumForm.hari == ''
                            ? day.first
                            : state.jadwalUmumForm.hari,
                        items: day.map((value) {
                          return DropdownMenuItem<String>(
                            value: value,
                            child: Text(value),
                          );
                        }).toList(),
                        onChanged: (value) =>
                            context.read<JadwalUmumTambahEditBloc>().add(
                                  JadwalUmumFormChanged(
                                    jadwalUmum: state.jadwalUmumForm
                                        .copyWith(hari: value as String),
                                  ),
                                ),
                      ),
                      const SizedBox(height: 15),
                      CreateTextFormField(
                        controller: _jamMulaiController,
                        labelText: 'Jam Mulai',
                        hintText: 'Masukkan Jam Mulai',
                        validator: (value) =>
                            state.jadwalUmumError.jamMulai == ''
                                ? null
                                : state.jadwalUmumError.jamMulai,
                        onChanged: (value) => context
                            .read<JadwalUmumTambahEditBloc>()
                            .add(JadwalUmumFormChanged(
                                jadwalUmum: state.jadwalUmumForm
                                    .copyWith(jamMulai: value))),
                        suffixIcon: IconButton(
                          onPressed: () => _selectTime(context),
                          icon: const Icon(Icons.access_time),
                        ),
                        onTap: () => _selectTime(context),
                      ),
                      const SizedBox(height: 15),
                      state.jadwalUmumError.jamMulai != ''
                          ? const SizedBox.shrink()
                          : state.jamMulaiHelperText,
                      const SizedBox(height: 50),
                      ElevatedButton(
                        onPressed: () {
                          context
                              .read<JadwalUmumTambahEditBloc>()
                              .add(JadwalUmumTambahEditSubmitted());
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 20),
                          child: Text(
                            'Simpan',
                            style: TextStyle(
                              fontFamily: 'SchibstedGrotesk',
                              fontSize: 15,
                              color: textColor,
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              );
      },
    );
  }
}
