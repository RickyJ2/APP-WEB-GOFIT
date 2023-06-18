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
                                Row(
                                  children: [
                                    const TitleMemberPage(),
                                    MediaQuery.of(context).size.width < 1000
                                        ? const Row(
                                            children: [
                                              RefreshButton(),
                                              AddMemberButton(),
                                            ],
                                          )
                                        : Container(),
                                  ],
                                ),
                                const SizedBox(height: 20),
                                MemberSearchField(
                                    searchController: searchController),
                                const SizedBox(height: 20),
                                MediaQuery.of(context).size.width < 1000
                                    ? const Column(
                                        children: [
                                          FilterMemberToogle(),
                                          SizedBox(height: 15),
                                          Row(
                                            children: [
                                              Expanded(
                                                  child:
                                                      ResetInstrukturButton()),
                                              SizedBox(width: 10),
                                              Expanded(
                                                  child: ResetMemberButton()),
                                            ],
                                          ),
                                        ],
                                      )
                                    : Container(),
                              ],
                            ),
                          ),
                        ),
                        MediaQuery.of(context).size.width > 1000
                            ? const Column(
                                crossAxisAlignment: CrossAxisAlignment.end,
                                children: [
                                  Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: [
                                      ResetInstrukturButton(),
                                      SizedBox(width: 10),
                                      ResetMemberButton(),
                                      SizedBox(width: 10),
                                      RefreshButton(),
                                      AddMemberButton(),
                                    ],
                                  ),
                                  SizedBox(height: 15),
                                  FilterMemberToogle(),
                                ],
                              )
                            : Container(),
                      ],
                    ),
                    const SizedBox(height: 20),
                    PaginatedDataTable(
                      rowsPerPage: state.memberList.isEmpty
                          ? 1
                          : state.memberList.length < 10
                              ? state.memberList.length
                              : 10,
                      columns: const [
                        DataColumn(label: Text('Id')),
                        DataColumn(label: Text('Nama')),
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

class FilterMemberToogle extends StatelessWidget {
  const FilterMemberToogle({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(builder: (context, state) {
      return ToggleButtons(
        onPressed: (int index) {
          context
              .read<MemberBloc>()
              .add(MemberToogleChanged(toogleState: index));
        },
        isSelected: state.toogleState,
        borderRadius: const BorderRadius.all(Radius.circular(5)),
        selectedColor: textColor,
        fillColor: primaryColor,
        color: accentColor,
        constraints: BoxConstraints(
          minWidth: 80,
          maxWidth: MediaQuery.of(context).size.width / 3 - 5,
          minHeight: 40,
        ),
        children: const [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Semua',
              textAlign: TextAlign.center,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Membership Kadarluasa',
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Text(
              'Deposit Kelas Kadarluasa',
              textAlign: TextAlign.center,
              softWrap: true,
            ),
          ),
        ],
      );
    });
  }
}

class AddMemberButton extends StatelessWidget {
  const AddMemberButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Tambah Data Member",
      icon: const Icon(Icons.add, color: Colors.grey),
      onPressed: () {
        context.go('/member/tambah');
      },
    );
  }
}

class RefreshButton extends StatelessWidget {
  const RefreshButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      tooltip: "Refresh Data Member",
      onPressed: () {
        BlocProvider.of<MemberBloc>(context).add(MemberDataFetched());
      },
      icon: const Icon(Icons.refresh, color: Colors.grey),
    );
  }
}

class ResetMemberButton extends StatelessWidget {
  const ResetMemberButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(builder: (context, state) {
      return ElevatedButton(
        onPressed: () {
          void reset() {
            context.read<MemberBloc>().add(MemberResetDataMemberRequested());
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
          backgroundColor: MaterialStateProperty.all<Color>(errorTextColor),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        child: state.resetDataMemberState is FormSubmitting
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Text(
                  'Reset Member Expired',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SchibstedGrotesk',
                    color: textColor,
                  ),
                ),
              ),
      );
    });
  }
}

class ResetInstrukturButton extends StatelessWidget {
  const ResetInstrukturButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MemberBloc, MemberState>(builder: (context, state) {
      return ElevatedButton(
        onPressed: () {
          void reset() {
            context
                .read<MemberBloc>()
                .add(InstrukturResetDataInstrukturRequested());
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
          backgroundColor: MaterialStateProperty.all<Color>(errorTextColor),
          foregroundColor: MaterialStateProperty.all<Color>(Colors.white),
        ),
        child: state.resetDataInstrukturState is FormSubmitting
            ? const Center(
                child: CircularProgressIndicator(
                  color: Colors.white,
                ),
              )
            : Padding(
                padding: const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 5,
                ),
                child: Text(
                  'Reset Terlambat Instruktur',
                  softWrap: true,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontFamily: 'SchibstedGrotesk',
                    color: textColor,
                  ),
                ),
              ),
      );
    });
  }
}

class MemberSearchField extends StatelessWidget {
  const MemberSearchField({
    super.key,
    required this.searchController,
  });

  final TextEditingController searchController;

  @override
  Widget build(BuildContext context) {
    return TextField(
      controller: searchController,
      decoration: InputDecoration(
        hintText: 'Cari data member',
        constraints: const BoxConstraints(maxHeight: 30, maxWidth: 400),
        suffixIcon: IconButton(
            onPressed: () {
              BlocProvider.of<MemberBloc>(context)
                  .add(MemberFindDataRequested(data: searchController.text));
            },
            icon: const Icon(Icons.search)),
      ),
    );
  }
}

class TitleMemberPage extends StatelessWidget {
  const TitleMemberPage({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        text: 'Data Member Gym ',
        style: TextStyle(
          fontFamily: 'Roboto',
          fontSize: 24,
          color: accentColor,
        ),
        children: [
          TextSpan(
            text: 'GoFit',
            style: TextStyle(
              fontFamily: 'SchibstedGrotesk',
              fontSize: 24,
              fontWeight: FontWeight.bold,
              color: accentColor,
            ),
          ),
        ],
      ),
    );
  }
}
