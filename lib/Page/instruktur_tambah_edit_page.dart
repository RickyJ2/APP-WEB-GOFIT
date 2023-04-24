import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:web_gofit/InstrukturBloc/instruktur_repository.dart';
import 'package:web_gofit/InstrukturTambahEditBloc/instruktur_tambah_edit_bloc.dart';
import 'package:web_gofit/const.dart';
import 'package:web_gofit/StateBlocTemplate/form_submission_state.dart';
import '../InstrukturTambahEditBloc/instruktur_tambah_edit_event.dart';
import '../InstrukturTambahEditBloc/instruktur_tambah_edit_state.dart';
import '../Model/instruktur.dart';

class InstrukturTambahEditPage extends StatelessWidget {
  final String tambahEdit;
  final Instruktur instruktur;
  const InstrukturTambahEditPage(
      {super.key, required this.tambahEdit, required this.instruktur});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => InstrukturTambahEditBloc(
          instrukturRepository: InstrukturRepository()),
      child: BlocListener<InstrukturTambahEditBloc, InstrukturTambahEditState>(
        listenWhen: (previous, current) =>
            previous.formSubmissionState != current.formSubmissionState,
        listener: (context, state) {
          if (state.formSubmissionState is SubmissionSuccess) {
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(
                content: Text('Data berhasil disimpan'),
              ),
            );
            context.go('/instruktur');
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
        },
        child: InstrukturTambahEditView(
            tambahEdit: tambahEdit, instruktur: instruktur),
      ),
    );
  }
}

class InstrukturTambahEditView extends StatefulWidget {
  final String tambahEdit;
  final Instruktur instruktur;
  const InstrukturTambahEditView(
      {super.key, required this.tambahEdit, required this.instruktur});

  @override
  State<InstrukturTambahEditView> createState() =>
      _InstrukturTambahEditViewState();
}

class _InstrukturTambahEditViewState extends State<InstrukturTambahEditView> {
  @override
  void initState() {
    super.initState();
    if (widget.tambahEdit == 'edit') {
      context.read<InstrukturTambahEditBloc>().add(UpdateTambahEdit(
          tambahEdit: TambahEdit.edit, instruktur: widget.instruktur));
    } else if (widget.tambahEdit == 'tambah') {
      context.read<InstrukturTambahEditBloc>().add(UpdateTambahEdit(
          tambahEdit: TambahEdit.tambah, instruktur: widget.instruktur));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EditTambahLabel(),
        const SizedBox(height: 30),
        TambahEditForm(
          instrukturInitial: widget.instruktur,
        ),
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
    return BlocBuilder<InstrukturTambahEditBloc, InstrukturTambahEditState>(
        builder: (context, state) {
      return RichText(
        text: TextSpan(
          text: state.tambahEdit == TambahEdit.tambah
              ? 'Tambah Data Instruktur '
              : 'Edit Data Instruktur ',
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
  final Instruktur instrukturInitial;
  const TambahEditForm({super.key, required this.instrukturInitial});

  @override
  State<TambahEditForm> createState() => _TambahEditFormState();
}

class _TambahEditFormState extends State<TambahEditForm> {
  final TextEditingController _tglLahirController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _tglLahirController.text = widget.instrukturInitial.tglLahir;
    _tglLahirController.addListener(_onTglLahirChanged);
  }

  @override
  void dispose() {
    _tglLahirController.dispose();
    super.dispose();
  }

  void _onTglLahirChanged() {
    final newValue = _tglLahirController.text;
    context.read<InstrukturTambahEditBloc>().add(
          InstrukturFormChanged(
            instruktur: context
                .read<InstrukturTambahEditBloc>()
                .state
                .instrukturForm
                .copyWith(tglLahir: newValue),
          ),
        );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(1900),
      lastDate: DateTime.now(),
    );
    if (picked != null) {
      _tglLahirController.text =
          '${picked.year.toString()}-${picked.month.toString().padLeft(2, '0')}-${picked.day.toString().padLeft(2, '0')}';
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<InstrukturTambahEditBloc, InstrukturTambahEditState>(
        builder: (context, state) {
      return Form(
        child: FractionallySizedBox(
          alignment: Alignment.topLeft,
          widthFactor: MediaQuery.of(context).size.width > 800 ? 0.7 : 1,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              CreateTextFormField(
                labelText: 'Nama Lengkap',
                hintText: 'Masukkan nama lengkap instruktur',
                initialValue: widget.instrukturInitial.nama,
                validator: (value) => state.instrukturError.nama == ''
                    ? null
                    : state.instrukturError.nama,
                onChanged: (value) => context
                    .read<InstrukturTambahEditBloc>()
                    .add(
                      InstrukturFormChanged(
                        instruktur: state.instrukturForm.copyWith(nama: value),
                      ),
                    ),
              ),
              const SizedBox(height: 15),
              CreateTextFormField(
                labelText: 'Alamat',
                hintText: 'Masukkan alamat instruktur',
                initialValue: widget.instrukturInitial.alamat,
                validator: (value) => state.instrukturError.alamat == ''
                    ? null
                    : state.instrukturError.alamat,
                onChanged: (value) =>
                    context.read<InstrukturTambahEditBloc>().add(
                          InstrukturFormChanged(
                            instruktur:
                                state.instrukturForm.copyWith(alamat: value),
                          ),
                        ),
              ),
              const SizedBox(height: 15),
              CreateTextFormField(
                controller: _tglLahirController,
                labelText: 'Tanggal Lahir',
                hintText: 'Masukkan tanggal lahir instruktur',
                validator: (value) => state.instrukturError.tglLahir == ''
                    ? null
                    : state.instrukturError.tglLahir,
                onChanged: (value) =>
                    context.read<InstrukturTambahEditBloc>().add(
                          InstrukturFormChanged(
                            instruktur:
                                state.instrukturForm.copyWith(tglLahir: value),
                          ),
                        ),
                suffixIcon: IconButton(
                  onPressed: () {
                    _selectDate(context);
                  },
                  icon: const Icon(Icons.calendar_today),
                ),
              ),
              const SizedBox(height: 15),
              CreateTextFormField(
                labelText: 'Nomor Telepon',
                hintText: 'Masukkan nomor telepon instruktur',
                initialValue: widget.instrukturInitial.noTelp,
                keyboardType: TextInputType.number,
                inputFormatter: FilteringTextInputFormatter.digitsOnly,
                validator: (value) => state.instrukturError.noTelp == ''
                    ? null
                    : state.instrukturError.noTelp,
                onChanged: (value) =>
                    context.read<InstrukturTambahEditBloc>().add(
                          InstrukturFormChanged(
                            instruktur:
                                state.instrukturForm.copyWith(noTelp: value),
                          ),
                        ),
              ),
              const SizedBox(height: 15),
              CreateTextFormField(
                labelText: 'Username',
                hintText: 'Masukkan username instruktur',
                initialValue: widget.instrukturInitial.username,
                validator: (value) => state.instrukturError.username == ''
                    ? null
                    : state.instrukturError.username,
                onChanged: (value) =>
                    context.read<InstrukturTambahEditBloc>().add(
                          InstrukturFormChanged(
                            instruktur:
                                state.instrukturForm.copyWith(username: value),
                          ),
                        ),
              ),
              const SizedBox(height: 15),
              state.tambahEdit == TambahEdit.tambah
                  ? CreateTextFormField(
                      labelText: 'Password',
                      hintText: 'Masukkan password instruktur',
                      suffixIcon: IconButton(
                        onPressed: () {
                          context
                              .read<InstrukturTambahEditBloc>()
                              .add(PasswordVisibleChanged());
                        },
                        icon: Icon(
                          state.isPasswordVisible
                              ? Icons.visibility
                              : Icons.visibility_off,
                          color: state.isPasswordVisible
                              ? primaryColor
                              : textColorSecond,
                        ),
                      ),
                      obscureText: !state.isPasswordVisible,
                      initialValue: widget.instrukturInitial.password,
                      validator: (value) => state.instrukturError.password == ''
                          ? null
                          : state.instrukturError.password,
                      onChanged: (value) =>
                          context.read<InstrukturTambahEditBloc>().add(
                                InstrukturFormChanged(
                                  instruktur: state.instrukturForm
                                      .copyWith(password: value),
                                ),
                              ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<InstrukturTambahEditBloc>()
                      .add(InstrukturTambahEditSubmitted());
                },
                child: Padding(
                  padding:
                      const EdgeInsets.symmetric(vertical: 15, horizontal: 20),
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
    });
  }
}

class CreateTextFormField extends StatelessWidget {
  final TextEditingController? controller;
  final String labelText;
  final String hintText;
  final String? initialValue;
  final String? Function(String?)? validator;
  final void Function(String?)? onChanged;
  final IconButton? suffixIcon;
  final TextInputType? keyboardType;
  final TextInputFormatter? inputFormatter;
  final bool? obscureText;

  const CreateTextFormField({
    super.key,
    this.controller,
    required this.labelText,
    required this.hintText,
    this.initialValue,
    required this.validator,
    required this.onChanged,
    this.suffixIcon,
    this.keyboardType,
    this.inputFormatter,
    this.obscureText,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        labelText: labelText,
        hintText: hintText,
        suffixIcon: suffixIcon,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: primaryColor),
        ),
        border: OutlineInputBorder(
          borderSide: BorderSide(color: accentColor),
        ),
        errorBorder: const OutlineInputBorder(
          borderSide: BorderSide(color: Colors.red),
        ),
      ),
      keyboardType: keyboardType,
      inputFormatters: inputFormatter != null ? [inputFormatter!] : null,
      initialValue: initialValue,
      autovalidateMode: AutovalidateMode.always,
      validator: validator,
      onChanged: onChanged,
      obscureText: obscureText ?? false,
    );
  }
}
