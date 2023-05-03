import 'package:flutter/material.dart';

import '../../api/admin/admin_get_faculties.dart';

import '../../models/faculty_model.dart';

import '../../widgets/admin/admin_app_drawer.dart';
import '../../widgets/spinner.dart';
import '../../widgets/error_display.dart';

import './admin_view_faculty_detail_screen.dart';

class AdminViewFacultiesScreen extends StatefulWidget {
  const AdminViewFacultiesScreen({Key key}) : super(key: key);

  static const routeName = '/admin-view-faculties-screen';

  @override
  State<AdminViewFacultiesScreen> createState() => _AdminViewFacultiesState();
}

class _AdminViewFacultiesState extends State<AdminViewFacultiesScreen> {
  List<Faculty> _data = [];

  var _isLoading = true;
  var _isSuccess = false;

  Future<void> _fetchFaculties() async {
    _data = [];

    setState(() {
      _isLoading = true;
    });

    var res = await adminGetFaculties(context: context);
    _isSuccess = res[0];
    if (_isSuccess) {
      _data = res[1] as List<Faculty>;
    }

    setState(() {
      _isLoading = false;
    });
  }

  @override
  void initState() {
    Future.delayed(Duration.zero).then((_) async {
      setState(() {
        _isLoading = true;
      });
      await _fetchFaculties();
      setState(() {
        _isLoading = false;
      });
    });
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Faculties"),
        actions: [
          IconButton(
            onPressed: _fetchFaculties,
            icon: const Icon(Icons.replay_outlined),
          ),
        ],
      ),
      drawer: const AdminAppDrawer(),
      body: _isLoading
          ? const Spinner()
          : _isSuccess
              ? _data.isEmpty
                  ? errorDisplay("No Faculties")
                  : ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        final individualFaculty = _data[index];

                        return SizedBox(
                          width: double.infinity,
                          child: Column(
                            children: [
                              const SizedBox(
                                height: 5,
                              ),
                              Padding(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 8.0),
                                child: Card(
                                  child: ListTile(
                                    leading: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: [
                                        Text(individualFaculty.department),
                                        Text(individualFaculty.facultyId),
                                      ],
                                    ),
                                    title: Column(
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          individualFaculty.name,
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Text(individualFaculty.email),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                      ],
                                    ),
                                    trailing: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.spaceAround,
                                      children: const [
                                        Icon(Icons.arrow_forward_sharp),
                                      ],
                                    ),
                                    onTap: () {
                                      Navigator.of(context).pushNamed(
                                        AdminViewFacultyDetailScreen.routeName,
                                        arguments: individualFaculty,
                                      );
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
              : errorDisplay("Couldn't fetch faculties"),
    );
  }
}
