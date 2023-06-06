import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:web_gofit/Repository/member_repository.dart';
import 'package:web_gofit/const.dart';

import '../Asset/create_text_form_field.dart';
import '../Bloc/MemberBloc/MemberTambahEditBloc/member_tambah_edit_bloc.dart';
import '../Bloc/MemberBloc/MemberTambahEditBloc/member_tambah_edit_event.dart';
import '../Bloc/MemberBloc/MemberTambahEditBloc/member_tambah_edit_state.dart';
import '../Model/member.dart';
import '../StateBlocTemplate/form_submission_state.dart';

class MemberTambahEditPage extends StatelessWidget {
  final String tambahEdit;
  final Member member;
  const MemberTambahEditPage(
      {super.key, required this.tambahEdit, required this.member});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
        create: (context) =>
            MemberTambahEditBloc(memberRepository: MemberRepository()),
        child: BlocListener<MemberTambahEditBloc, MemberTambahEditState>(
            listenWhen: (previous, current) =>
                previous.formSubmissionState != current.formSubmissionState,
            listener: (context, state) {
              if (state.formSubmissionState is SubmissionSuccess) {
                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text('Data berhasil disimpan'),
                  ),
                );
                context.go('/member');
              }
              if (state.formSubmissionState is SubmissionFailed) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                    content: Text(
                        (state.formSubmissionState as SubmissionFailed)
                            .exception
                            .toString())));
              }
            },
            child:
                MemberTambahEditView(tambahEdit: tambahEdit, member: member)));
  }
}

class MemberTambahEditView extends StatefulWidget {
  final String tambahEdit;
  final Member member;
  const MemberTambahEditView(
      {super.key, required this.tambahEdit, required this.member});

  @override
  State<MemberTambahEditView> createState() => _MemberTambahEditViewState();
}

class _MemberTambahEditViewState extends State<MemberTambahEditView> {
  @override
  void initState() {
    super.initState();
    if (widget.tambahEdit == 'edit') {
      context.read<MemberTambahEditBloc>().add(MemberUpdateTambahEdit(
          tambahEdit: TambahEdit.edit, member: widget.member));
    } else if (widget.tambahEdit == 'tambah') {
      context.read<MemberTambahEditBloc>().add(MemberUpdateTambahEdit(
          tambahEdit: TambahEdit.tambah, member: widget.member));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const EditTambahLabel(),
        const SizedBox(height: 20),
        TambahEditForm(memberInitial: widget.member),
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
    return BlocBuilder<MemberTambahEditBloc, MemberTambahEditState>(
        builder: (context, state) {
      return RichText(
        text: TextSpan(
          text: state.tambahEdit == TambahEdit.tambah
              ? 'Tambah Data Member '
              : 'Edit Data Member ',
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
  final Member memberInitial;
  const TambahEditForm({super.key, required this.memberInitial});

  @override
  State<TambahEditForm> createState() => _TambahEditFormState();
}

class _TambahEditFormState extends State<TambahEditForm> {
  final TextEditingController _tglLahirController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _tglLahirController.text = widget.memberInitial.tglLahir;
    _tglLahirController.addListener(_onTglLahirChanged);
  }

  @override
  void dispose() {
    _tglLahirController.dispose();
    super.dispose();
  }

  void _onTglLahirChanged() {
    final newValue = _tglLahirController.text;
    context.read<MemberTambahEditBloc>().add(
          MemberFormChanged(
            member: context
                .read<MemberTambahEditBloc>()
                .state
                .memberForm
                .copyWith(tglLahir: newValue),
          ),
        );
  }

  Future<void> _selectDate(BuildContext context) async {
    DateTime initTime = DateTime.now();
    if (_tglLahirController.text.isNotEmpty) {
      initTime = DateTime.parse(_tglLahirController.text);
    }
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: initTime,
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
    return BlocBuilder<MemberTambahEditBloc, MemberTambahEditState>(
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
                hintText: 'Masukkan nama lengkap member',
                initialValue: widget.memberInitial.nama,
                validator: (value) => state.memberError.nama == ''
                    ? null
                    : state.memberError.nama,
                onChanged: (value) => context.read<MemberTambahEditBloc>().add(
                      MemberFormChanged(
                        member: state.memberForm.copyWith(nama: value),
                      ),
                    ),
              ),
              const SizedBox(height: 15),
              CreateTextFormField(
                labelText: 'Alamat',
                hintText: 'Masukkan alamat member',
                initialValue: widget.memberInitial.alamat,
                validator: (value) => state.memberError.alamat == ''
                    ? null
                    : state.memberError.alamat,
                onChanged: (value) => context.read<MemberTambahEditBloc>().add(
                      MemberFormChanged(
                        member: state.memberForm.copyWith(alamat: value),
                      ),
                    ),
              ),
              const SizedBox(height: 15),
              CreateTextFormField(
                controller: _tglLahirController,
                labelText: 'Tanggal Lahir',
                hintText: 'Masukkan tanggal lahir member',
                validator: (value) => state.memberError.tglLahir == ''
                    ? null
                    : state.memberError.tglLahir,
                onChanged: (value) => context.read<MemberTambahEditBloc>().add(
                      MemberFormChanged(
                        member: state.memberForm.copyWith(tglLahir: value),
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
                hintText: 'Masukkan nomor telepon member',
                initialValue: widget.memberInitial.noTelp,
                keyboardType: TextInputType.number,
                inputFormatter: [FilteringTextInputFormatter.digitsOnly],
                validator: (value) => state.memberError.noTelp == ''
                    ? null
                    : state.memberError.noTelp,
                onChanged: (value) => context.read<MemberTambahEditBloc>().add(
                      MemberFormChanged(
                        member: state.memberForm.copyWith(noTelp: value),
                      ),
                    ),
              ),
              const SizedBox(height: 15),
              CreateTextFormField(
                labelText: 'Email',
                hintText: 'Masukkan email member',
                initialValue: widget.memberInitial.email,
                validator: (value) => state.memberError.email == ''
                    ? null
                    : state.memberError.email,
                onChanged: (value) => context.read<MemberTambahEditBloc>().add(
                      MemberFormChanged(
                        member: state.memberForm.copyWith(email: value),
                      ),
                    ),
              ),
              const SizedBox(height: 15),
              state.tambahEdit == TambahEdit.tambah
                  ? CreateTextFormField(
                      labelText: 'Password',
                      hintText: 'Masukkan password member',
                      suffixIcon: IconButton(
                        onPressed: () {
                          context
                              .read<MemberTambahEditBloc>()
                              .add(MemberPasswordVisibleChanged());
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
                      validator: (value) => state.memberError.password == ''
                          ? null
                          : state.memberError.password,
                      onChanged: (value) =>
                          context.read<MemberTambahEditBloc>().add(
                                MemberFormChanged(
                                  member: state.memberForm
                                      .copyWith(password: value),
                                ),
                              ),
                    )
                  : const SizedBox.shrink(),
              const SizedBox(height: 50),
              ElevatedButton(
                onPressed: () {
                  context
                      .read<MemberTambahEditBloc>()
                      .add(MemberTambahEditSubmitted());
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
              ),
            ],
          ),
        ),
      );
    });
  }
}
