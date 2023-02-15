import 'package:flutter/material.dart';
import 'package:maccave_menager/firebaseserver/firestoredata.dart';
import 'package:maccave_menager/models/drinkmodel.dart';
import 'package:maccave_menager/models/entrymodel.dart';
import 'package:maccave_menager/models/marketmodel.dart';
import 'package:maccave_menager/src/loddinpage.dart';

class EntryReadPage extends StatefulWidget {
  const EntryReadPage({super.key, required this.entryid});
  final String entryid;
  @override
  State<EntryReadPage> createState() => _EntryReadPageState();
}

class _EntryReadPageState extends State<EntryReadPage> {
  late EntryModel entry;
  late DrinkModel drink;
  late MarketModel market;
  bool loadding = true;
  Future<void> setDataInitState() async {
    entry = await FireStoreData.getEntryItem(widget.entryid);
    drink = await FireStoreData.getDrinkItem(entry.drinkid);
    market = await FireStoreData.getMarketItem(entry.marketid);
    loadding = false;
    setState(() {});
  }

  @override
  void initState() {
    setDataInitState();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !loadding
          ? SingleChildScrollView(
              child: Column(
                children: [
                  SizedBox(
                    width: 130,
                    height: 130,
                    child: Image.network(
                      drink.image,
                      fit: BoxFit.cover,
                    ),
                  ),
                  Text(drink.name)
                ],
              ),
            )
          : LoadingPage(height: 200),
    );
  }
}
