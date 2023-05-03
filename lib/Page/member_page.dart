import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';

import 'package:web_gofit/Repository/member_repository.dart';

import '../Bloc/MemberBloc/member_bloc.dart';
import '../Bloc/MemberBloc/member_data_table_source.dart';
import '../Bloc/MemberBloc/member_event.dart';
import '../Bloc/MemberBloc/member_state.dart';
import '../StateBlocTemplate/form_submission_state.dart';
import '../StateBlocTemplate/page_fetched_data_state.dart';

class MemberPage extends StatelessWidget {
  const MemberPage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider<MemberBloc>(
        create: (context) => MemberBloc(memberRepository: MemberRepository()),
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
      },
      child: BlocBuilder<MemberBloc, MemberState>(
        builder: (context, state) {
          return state.pageFetchedDataState is PageFetchedDataLoading
              ? const Center(child: CircularProgressIndicator())
              : Scrollbar(
                  child: Column(
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
                                  const SizedBox(height: 8),
                                  TextField(
                                    controller: searchController,
                                    decoration: InputDecoration(
                                      hintText: 'Cari data member',
                                      constraints: const BoxConstraints(
                                          maxHeight: 30, maxWidth: 500),
                                      suffixIcon: IconButton(
                                          onPressed: () {
                                            BlocProvider.of<MemberBloc>(context)
                                                .add(MemberFindDataRequested(
                                                    data:
                                                        searchController.text));
                                          },
                                          icon: const Icon(Icons.search)),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          IconButton(
                            tooltip: "Refresh Data Member",
                            onPressed: () {
                              BlocProvider.of<MemberBloc>(context)
                                  .add(MemberDataFetched());
                            },
                            icon: const Icon(Icons.refresh, color: Colors.grey),
                          ),
                          IconButton(
                            tooltip: "Tambah Data Member",
                            icon: const Icon(Icons.add, color: Colors.grey),
                            onPressed: () {
                              context.go('/member/tambah');
                            },
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
                  ),
                );
        },
      ),
    );
  }
}
