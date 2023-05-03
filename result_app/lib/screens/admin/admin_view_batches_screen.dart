import 'package:flutter/material.dart';
import 'package:result_app/helpers/colors.dart';

import '../../api/admin/admin_get_batches.dart';

import '../../models/batch_model.dart';

import '../../widgets/admin/admin_app_drawer.dart';
import '../../widgets/spinner.dart';
import '../../widgets/error_display.dart';

import './admin_view_students_screen.dart';
import './admin_enrollment_screen.dart';

class AdminViewBatchesScreen extends StatefulWidget {
  const AdminViewBatchesScreen({Key key}) : super(key: key);

  static const routeName = '/admin-view-batches-screen';

  @override
  State<AdminViewBatchesScreen> createState() => _AdminViewBatchesScreenState();
}

class _AdminViewBatchesScreenState extends State<AdminViewBatchesScreen> {
  List<Batch> _data = [];

  var _isLoading = true;
  var _isSuccess = false;

  Future<void> _fetchBatches() async {
    _data = [];

    setState(() {
      _isLoading = true;
    });

    var res = await adminGetBatches(context: context);
    _isSuccess = res[0];
    if (_isSuccess) {
      _data = res[1] as List<Batch>;
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
      await _fetchBatches();
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
        title: const Text("Batches"),
        actions: [
          IconButton(
            onPressed: _fetchBatches,
            icon: const Icon(Icons.replay_outlined),
          ),
        ],
      ),
      drawer: const AdminAppDrawer(),
      body: _isLoading
          ? const Spinner()
          : _isSuccess
              ? _data.isEmpty
                  ? errorDisplay("No Batches")
                  : ListView.builder(
                      itemCount: _data.length,
                      itemBuilder: (context, index) {
                        final individualBatch = _data[index];

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
                                        Text(individualBatch.batchYear
                                            .toString()),
                                        Text(individualBatch.dept),
                                      ],
                                    ),
                                    title: Column(
                                      children: [
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                          "Semester: ${individualBatch.currentSem}",
                                          style: Theme.of(context)
                                              .textTheme
                                              .bodyText2,
                                        ),
                                        const Divider(),
                                      ],
                                    ),
                                    subtitle: Column(
                                      children: [
                                        Text(
                                            "Total Students: ${individualBatch.students.length}"),
                                        const SizedBox(
                                          height: 5,
                                        ),
                                        Text(
                                            "Current Courses: ${individualBatch.currentCourses.length}"),
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
                                      showDialog(
                                          context: context,
                                          builder: (context) {
                                            return Dialog(
                                              shape: RoundedRectangleBorder(
                                                borderRadius:
                                                    BorderRadius.circular(20),
                                              ),
                                              child: Padding(
                                                padding:
                                                    const EdgeInsets.all(8),
                                                child: Column(
                                                  mainAxisSize:
                                                      MainAxisSize.min,
                                                  mainAxisAlignment:
                                                      MainAxisAlignment.center,
                                                  children: [
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Text(
                                                      "Select an option",
                                                      style: TextStyle(
                                                        fontWeight:
                                                            FontWeight.bold,
                                                      ),
                                                    ),
                                                    const SizedBox(
                                                      height: 10,
                                                    ),
                                                    const Divider(
                                                      thickness: 0.5,
                                                    ),
                                                    Padding(
                                                      padding: const EdgeInsets
                                                          .symmetric(
                                                        horizontal: 10,
                                                        vertical: 5,
                                                      ),
                                                      child: Row(
                                                        mainAxisAlignment:
                                                            MainAxisAlignment
                                                                .end,
                                                        children: [
                                                          OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                AdminEnrollmentScreen
                                                                    .routeName,
                                                                arguments:
                                                                    individualBatch,
                                                              );
                                                            },
                                                            child: Text(
                                                              "View Courses",
                                                              style: TextStyle(
                                                                color:
                                                                    mainColor,
                                                              ),
                                                            ),
                                                          ),
                                                          const SizedBox(
                                                            width: 15,
                                                          ),
                                                          OutlinedButton(
                                                            onPressed: () {
                                                              Navigator.of(
                                                                      context)
                                                                  .pop();
                                                              Navigator.of(
                                                                      context)
                                                                  .pushNamed(
                                                                AdminViewStudentsScreen
                                                                    .routeName,
                                                                arguments:
                                                                    individualBatch,
                                                              );
                                                            },
                                                            child: Text(
                                                              "View Students",
                                                              style: TextStyle(
                                                                color:
                                                                    mainColor,
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
                                          });
                                    },
                                  ),
                                ),
                              ),
                            ],
                          ),
                        );
                      },
                    )
              : errorDisplay("Couldn't fetch batches"),
    );
  }
}
