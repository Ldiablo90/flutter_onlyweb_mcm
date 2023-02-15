import 'package:flutter/material.dart';
import 'package:maccave_menager/firebaseserver/firestoredata.dart';
import 'package:maccave_menager/models/marketmodel.dart';
import 'package:maccave_menager/src/loddinpage.dart';
import 'package:go_router/go_router.dart';

class MarketSettingPage extends StatefulWidget {
  const MarketSettingPage({super.key});

  @override
  State<MarketSettingPage> createState() => _MarketSettingPageState();
}

class _MarketSettingPageState extends State<MarketSettingPage> {
  late List<MarketModel> marketlist = [];
  bool loadding = true;
  final ScrollController _controllerOne = ScrollController();

  Future<void> setDataInitState() async {
    marketlist = await FireStoreData.getAllMarkets();
    loadding = false;
    setState(() {});
  }

  String openingFormat(String opening) {
    final result = opening.replaceAll('/', '  ');
    return result;
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
              context.push('/market/write');
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
                    width: MediaQuery.of(context).size.width,
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
                              DataColumn(label: Text('마켓이름')),
                              DataColumn(label: Text('연락처')),
                              DataColumn(label: Text('영업시간')),
                            ],
                            rows: marketlist
                                .map<DataRow>(
                                  (drink) => DataRow(
                                    onSelectChanged: (value) {},
                                    cells: [
                                      DataCell(Text(drink.name)),
                                      DataCell(Text(drink.col)),
                                      DataCell(
                                        Text(openingFormat(drink.opening)),
                                      ),
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
