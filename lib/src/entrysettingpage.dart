import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter/material.dart';
import 'package:maccave_menager/firebaseserver/firestoredata.dart';
import 'package:maccave_menager/models/drinkmodel.dart';
import 'package:maccave_menager/models/entrymodel.dart';
import 'package:maccave_menager/models/marketmodel.dart';
import 'package:maccave_menager/src/loddinpage.dart';

class EntrySettingPage extends StatefulWidget {
  const EntrySettingPage({super.key});

  @override
  State<EntrySettingPage> createState() => _EntrySettingPageState();
}

class _EntrySettingPageState extends State<EntrySettingPage> {
  late List<EntryModel> yesterday;
  late List<EntryModel> today;
  late List<EntryModel> tomorrow;
  bool loadding = true;

  Future<void> setInitStateData() async {
    print('setInitStateData');
    yesterday = await FireStoreData.getEntrysData('yesterday');
    today = await FireStoreData.getEntrysData('today');
    tomorrow = await FireStoreData.getEntrysData('tomorrow');
    loadding = false;
    setState(() {});
  }

  @override
  void initState() {
    setInitStateData();
    super.initState();
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
              context.go('/entry/write');
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
                  Row(
                    children: const [
                      Text('명일 이후 정보'),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green,
                    ),
                    child: tomorrow.isNotEmpty
                        ? EntryTable(data: tomorrow)
                        : const Center(
                            child: Text('예정 정보가 없습니다.'),
                          ),
                  ),
                  Row(
                    children: const [
                      Text('금일 예정 중인 정보'),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: today.isNotEmpty
                        ? EntryTable(data: today)
                        : const Center(
                            child: Text('진행 정보가 없습니다.'),
                          ),
                  ),
                  Row(
                    children: const [
                      Text('진행 종료 된 정보'),
                    ],
                  ),
                  Container(
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(20),
                      color: Colors.green,
                    ),
                    padding: const EdgeInsets.all(15),
                    child: yesterday.isNotEmpty
                        ? EntryTable(data: yesterday)
                        : const Center(
                            child: Text('종료 정보가 없습니다.'),
                          ),
                  ),
                ],
              ),
            )
          : LoadingPage(height: 200),
    );
  }
}

class EntryTable extends StatefulWidget {
  const EntryTable({super.key, required this.data});
  final List<EntryModel> data;

  @override
  State<EntryTable> createState() => _EntryTableState();
}

class _EntryTableState extends State<EntryTable> {
  final ScrollController _controllerOne = ScrollController();

  late List<DrinkModel> drinks;
  late List<MarketModel> markets;
  bool loadding = true;
  String formatReleaseDate(DateTime time) {
    final result = DateFormat('yyyy-MM-dd hh:mm').format(time);
    return result;
  }

  Future<void> setDataInitState() async {
    drinks = await Future.wait(widget.data
        .map((e) async => await FireStoreData.getDrinkItem(e.drinkid)));
    markets = await Future.wait(widget.data
        .map((e) async => await FireStoreData.getMarketItem(e.marketid)));
    loadding = false;
    setState(() {});
  }

  @override
  void initState() {
    super.initState();
    setDataInitState();
  }

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _controllerOne.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scrollbar(
      controller: _controllerOne,
      trackVisibility: true,
      child: SingleChildScrollView(
        controller: _controllerOne,
        scrollDirection: Axis.horizontal,
        child: !loadding
            ? DataTable(
                showCheckboxColumn: false,
                columns: const [
                  DataColumn(label: Center(child: Text('상품타입'))),
                  DataColumn(label: Center(child: Text('이미지'))),
                  DataColumn(label: Center(child: Text('상품명'))),
                  DataColumn(label: Center(child: Text('위치'))),
                  DataColumn(label: Center(child: Text('가격'))),
                  DataColumn(label: Center(child: Text('발매일자'))),
                  DataColumn(label: Center(child: Text('생성일'))),
                ],
                rows: widget.data
                    .asMap()
                    .entries
                    .map<DataRow>((mapEntry) => DataRow(
                          onSelectChanged: (value) {
                            if (value!) {
                              context.pushNamed('entryread', params: {
                                'id': mapEntry.value.id,
                              });
                            }
                          },
                          cells: <DataCell>[
                            DataCell(Text(mapEntry.value.type)),
                            DataCell(
                              SizedBox(
                                width: 100,
                                height: 100,
                                child: Image.network(
                                  drinks[mapEntry.key].image,
                                  fit: BoxFit.fitHeight,
                                ),
                              ),
                            ),
                            DataCell(Text(drinks[mapEntry.key].name)),
                            DataCell(Text(markets[mapEntry.key].name)),
                            DataCell(Text('${mapEntry.value.price}')),
                            DataCell(Text(
                                formatReleaseDate(mapEntry.value.releasedate))),
                            DataCell(Text(
                                formatReleaseDate(mapEntry.value.createdate!))),
                          ],
                        ))
                    .toList(),
              )
            : LoadingPage(height: 30),
      ),
    );
  }
}
