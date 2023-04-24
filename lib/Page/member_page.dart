import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:web_gofit/MemberBloc/member_bloc.dart';
import 'package:web_gofit/MemberBloc/member_data_table_source.dart';
import 'package:web_gofit/MemberBloc/member_repository.dart';
import 'package:web_gofit/MemberBloc/member_state.dart';

import '../MemberBloc/member_event.dart';
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
      },
      child: BlocBuilder<MemberBloc, MemberState>(builder: (context, state) {
        return SizedBox(
          width: double.infinity,
          child: Center(
            child: state.pageFetchedDataState is PageFetchedDataLoading
                ? const CircularProgressIndicator()
                : PaginatedDataTable(
                    header: Column(
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
                        Expanded(
                          child: TextField(
                            controller: searchController,
                            decoration: InputDecoration(
                              hintText: 'Cari data instruktur',
                              constraints: const BoxConstraints(
                                  maxHeight: 30, maxWidth: 300),
                              suffixIcon: IconButton(
                                  onPressed: () {
                                    BlocProvider.of<MemberBloc>(context).add(
                                        MemberFindDataRequested(
                                            data: searchController.text));
                                  },
                                  icon: const Icon(Icons.search)),
                            ),
                          ),
                        ),
                      ],
                    ),
                    columns: const [
                      DataColumn(label: Text('Nama')),
                      DataColumn(label: Text('Username')),
                      DataColumn(label: Text('Alamat')),
                      DataColumn(label: Text('Tanggal Lahir')),
                      DataColumn(label: Text('No Telp')),
                      DataColumn(label: Text('Email')),
                      DataColumn(label: Text('Action')),
                    ],
                    source: MemberDataTableSource(data: state.memberList),
                    actions: [
                      IconButton(
                        onPressed: () {
                          BlocProvider.of<MemberBloc>(context)
                              .add(MemberDataFetched());
                        },
                        icon: const Icon(Icons.refresh),
                      ),
                      IconButton(
                        icon: const Icon(Icons.add),
                        onPressed: () {
                          context.go('/member/tambah');
                        },
                      ),
                    ],
                  ),
          ),
        );
      }),
    );
  }
}