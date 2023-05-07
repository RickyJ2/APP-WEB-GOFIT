import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:web_gofit/Repository/instruktur_repository.dart';

import 'package:web_gofit/Repository/member_repository.dart';

import '../Asset/confirmation_dialog.dart';
import '../Bloc/MemberBloc/member_bloc.dart';
import '../Bloc/MemberBloc/member_data_table_source.dart';
import '../Bloc/MemberBloc/member_event.dart';
import '../Bloc/MemberBloc/member_state.dart';
import '../StateBlocTemplate/form_submission_state.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';
import '../const.dart';

class MemberPage extends StatelessWidget {
  const MemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MemberBloc>(
        create: (context) => MemberBloc(
              memberRepository: MemberRepository(),
              instrukturRepository: InstrukturRepository(),
            ),
        child: const PaginatedDataTableMember());
  }
}

class PaginatedDataTableMember extends StatefulWidget {
  const PaginatedDataTableMember({super.key});

  @override
  State<PaginatedDataTableMember> createState() =>
      _PaginatedDataTableMemberState();
}

class _PaginatedDataTableMemberState extends State<PaginatedDataTableMember> {
  final TextEditingController searchController = TextEditingController();

  @override
  initState() {
    super.initState();
    BlocProvider.of<MemberBloc>(context).add(MemberDataFetched());
  }

  @override
  void dispose() {
    searchController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<MemberBloc, MemberState>(
      listener: (context, state) {
        if (state.pageFetchedDataState is PageFetchedDataFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  (state.pageFetchedDataState as PageFetchedDataFailed)
                      .exception),
            ),
          );
        }
        if (state.deleteFormSubmissionState is SubmissionSuccess) {
          BlocProvider.of<MemberBloc>(context).add(MemberDataFetched());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Data berhasil dihapus'),
            ),
          );
        }
        if (state.deleteFormSubmissionState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  (state.deleteFormSubmissionState as SubmissionFailed)
                      .exception),
            ),
          );
        }
        if (state.resetPasswordFormSubmissionState is SubmissionSuccess) {
          BlocProvider.of<MemberBloc>(context).add(MemberDataFetched());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reset Password Member berhasil'),
            ),
          );
        }
        if (state.resetPasswordFormSubmissionState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  (state.resetPasswordFormSubmissionState as SubmissionFailed)
                      .exception),
            ),
          );
        }
        if (state.resetDataMemberState is SubmissionSuccess) {
          BlocProvider.of<MemberBloc>(context).add(MemberDataFetched());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Reset Data Member Expired berhasil'),
            ),
          );
        }
        if (state.resetDataMemberState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text(
                  (state.resetDataMemberState as SubmissionFailed).exception),
            ),
          );
        }
        if (state.resetDataInstrukturState is SubmissionSuccess) {
          BlocProvider.of<MemberBloc>(context).add(MemberDataFetched());
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content:
                  Text('Reset Akumulasi Waktu Terlambat Instruktur berhasil'),
            ),
          );
        }
        if (state.resetDataInstrukturState is SubmissionFailed) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text((state.resetDataInstrukturState as SubmissionFailed)
                  .exception),
            ),
          );
        }
      },
      child: BlocBuilder<MemberBloc, MemberState>(
        builder: (context, state) {
          return state.pageFetchedDataState is PageFetchedDataLoading
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Row(
                      children: [
                        Expanded(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                RichText(
                                  text: const TextSpan(
                                    text: 'Data Member Gym ',
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
                                ),
                                const SizedBox(height: 20),
                                TextField(
                                  controller: searchController,
                                  decoration: InputDecoration(
                                    hintText: 'Cari data member',
                                    constraints: const BoxConstraints(
                                        maxHeight: 30, maxWidth: 400),
                                    suffixIcon: IconButton(
                                        onPressed: () {
                                          BlocProvider.of<MemberBloc>(context)
                                              .add(MemberFindDataRequested(
                                                  data: searchController.text));
                                        },
                                        icon: const Icon(Icons.search)),
                                  ),
                                ),
                                const SizedBox(height: 20),
                              ],
                            ),
                          ),
                        ),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.end,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                ElevatedButton(
                                  onPressed: () {
                                    void reset() {
                                      context.read<MemberBloc>().add(
                                          InstrukturResetDataInstrukturRequested());
                                    }

                                    showDialog(
                                      context: context,
                                      builder: (context) => ConfirmationDialog(
                                        title: 'Konfirmasi',
                                        message:
                                            'Apakah anda yakin ingin mereset data akumulasi terlambat instruktur bulan ini?',
                                        onYes: () {
                                          Navigator.pop(context);
                                          reset();
                                        },
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            errorTextColor),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                  child: state.resetDataInstrukturState
                                          is FormSubmitting
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            'Reset Akumulasi Terlambat Instruktur',
                                            style: TextStyle(
                                              fontFamily: 'SchibstedGrotesk',
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 10),
                                ElevatedButton(
                                  onPressed: () {
                                    void reset() {
                                      context.read<MemberBloc>().add(
                                          MemberResetDataMemberRequested());
                                    }

                                    showDialog(
                                      context: context,
                                      builder: (context) => ConfirmationDialog(
                                        title: 'Konfirmasi',
                                        message:
                                            'Apakah anda yakin ingin mereset data membership dan deposit kelas yang kadarluasa hari ini?',
                                        onYes: () {
                                          Navigator.pop(context);
                                          reset();
                                        },
                                      ),
                                    );
                                  },
                                  style: ButtonStyle(
                                    backgroundColor:
                                        MaterialStateProperty.all<Color>(
                                            errorTextColor),
                                    foregroundColor:
                                        MaterialStateProperty.all<Color>(
                                            Colors.white),
                                  ),
                                  child: state.resetDataMemberState
                                          is FormSubmitting
                                      ? const Center(
                                          child: CircularProgressIndicator(
                                            color: Colors.white,
                                          ),
                                        )
                                      : Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5),
                                          child: Text(
                                            'Reset Member Expired',
                                            style: TextStyle(
                                              fontFamily: 'SchibstedGrotesk',
                                              color: textColor,
                                            ),
                                          ),
                                        ),
                                ),
                                const SizedBox(width: 10),
                                IconButton(
                                  tooltip: "Refresh Data Member",
                                  onPressed: () {
                                    BlocProvider.of<MemberBloc>(context)
                                        .add(MemberDataFetched());
                                  },
                                  icon: const Icon(Icons.refresh,
                                      color: Colors.grey),
                                ),
                                IconButton(
                                  tooltip: "Tambah Data Member",
                                  icon:
                                      const Icon(Icons.add, color: Colors.grey),
                                  onPressed: () {
                                    context.go('/member/tambah');
                                  },
                                ),
                              ],
                            ),
                            const SizedBox(height: 15),
                            ToggleButtons(
                              onPressed: (int index) {
                                context.read<MemberBloc>().add(
                                    MemberToogleChanged(toogleState: index));
                              },
                              isSelected: state.toogleState,
                              borderRadius:
                                  const BorderRadius.all(Radius.circular(5)),
                              selectedColor: textColor,
                              fillColor: primaryColor,
                              color: accentColor,
                              constraints: const BoxConstraints(
                                minWidth: 150,
                                minHeight: 40,
                              ),
                              children: const [
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Semua'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Membership Kadarluasa'),
                                ),
                                Padding(
                                  padding: EdgeInsets.all(8.0),
                                  child: Text('Deposit Kelas Kadarluasa'),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ],
                    ),
                    PaginatedDataTable(
                      rowsPerPage: state.memberList.isEmpty
                          ? 1
                          : state.memberList.length < 10
                              ? state.memberList.length
                              : 10,
                      columns: const [
                        DataColumn(label: Text('Id')),
                        DataColumn(label: Text('Nama')),
                        DataColumn(label: Text('Username')),
                        DataColumn(label: Text('Alamat')),
                        DataColumn(label: Text('Tanggal Lahir')),
                        DataColumn(label: Text('No Telp')),
                        DataColumn(label: Text('Email')),
                        DataColumn(label: Text('Deactived Membership')),
                        DataColumn(label: Text('Deposit Reguler')),
                        DataColumn(label: Text('Deposit Paket')),
                        DataColumn(label: Text('Deactived Deposit Kelas')),
                        DataColumn(label: Text('Kelas Deposit Kelas')),
                        DataColumn(label: Text('Action')),
                      ],
                      source: MemberDataTableSource(data: state.memberList),
                    ),
                  ],
                );
        },
      ),
    );
  }
}
