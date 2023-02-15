import 'package:flutter/material.dart';
import 'package:maccave_menager/firebaseserver/firestoredata.dart';
import 'package:maccave_menager/models/drinkmodel.dart';
import 'package:maccave_menager/src/loddinpage.dart';
import 'package:go_router/go_router.dart';

class DrinkSettingPage extends StatefulWidget {
  const DrinkSettingPage({super.key});

  @override
  State<DrinkSettingPage> createState() => _DrinkSettingPageState();
}

class _DrinkSettingPageState extends State<DrinkSettingPage> {
  final ScrollController _controllerOne = ScrollController();

  late List<DrinkModel> drinklist;
  bool loadding = true;
  Future<void> setDataInitState() async {
    drinklist = await FireStoreData.getAllDrinks();
    loadding = false;
    setState(() {});
  }

  @override
  void initState() {
    setDataInitState();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _controllerOne.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: SizedBox(
        width: 50,
        height: 50,
        child: FittedBox(
          child: FloatingActionButton(
            onPressed: () {
              context.push('/drink/write');
            },
            backgroundColor: Colors.green,
            child: const Icon(Icons.add),
          ),
        ),
      ),
      body: !loadding
          ? SingleChildScrollView(
              child: Column(
                children: [
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.green,
                      borderRadius: BorderRadius.circular(15),
                    ),
                    child: Scrollbar(
                      controller: _controllerOne,
                      trackVisibility: true,
                      child: SingleChildScrollView(
                        controller: _controllerOne,
                        scrollDirection: Axis.horizontal,
                        child: DataTable(
                            showCheckboxColumn: false,
                            columns: const <DataColumn>[
                              DataColumn(label: Text('위스키타입')),
                              DataColumn(label: Text('이미지')),
                              DataColumn(label: Text('이름')),
                              DataColumn(label: Text('영어이름')),
                              DataColumn(label: Text('나라')),
                              DataColumn(label: Text('알코올')),
                            ],
                            rows: drinklist
                                .map<DataRow>(
                                  (drink) => DataRow(
                                    onSelectChanged: (value) {},
                                    cells: [
                                      DataCell(Text(drink.type)),
                                      DataCell(
                                        SizedBox(
                                          width: 100,
                                          height: 100,
                                          child: Image.network(
                                            drink.image,
                                            fit: BoxFit.fitHeight,
                                          ),
                                        ),
                                      ),
                                      DataCell(Text(drink.name)),
                                      DataCell(Text(drink.name_en)),
                                      DataCell(Text(drink.place)),
                                      DataCell(Text('${drink.alcohol}')),
                                    ],
                                  ),
                                )
                                .toList()),
                      ),
                    ),
                  )
                ],
              ),
            )
          : LoadingPage(height: 200),
    );
  }
}

class DrinkTable extends StatelessWidget {
  const DrinkTable({super.key});

  @override
  Widget build(BuildContext context) {
    return Container();
  }
}
