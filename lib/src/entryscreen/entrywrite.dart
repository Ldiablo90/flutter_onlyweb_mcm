import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:maccave_menager/firebaseserver/firestoredata.dart';
import 'package:maccave_menager/models/drinkmodel.dart';
import 'package:maccave_menager/models/marketmodel.dart';
import 'package:maccave_menager/src/loddinpage.dart';
import 'package:maccave_menager/widgets/mainelevatedbtn.dart';

class EntryWritePage extends StatefulWidget {
  const EntryWritePage({super.key});

  @override
  State<EntryWritePage> createState() => _EntryWritePageState();
}

class _EntryWritePageState extends State<EntryWritePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  List<DrinkModel> allDrinks = [];
  List<MarketModel> allMarkets = [];
  List<String> entryTypes = ['발매정보', '실시간 정보'];
  bool loadding = true;

  Future<void> getStateData() async {
    allDrinks = await FireStoreData.getAllDrinks();
    allMarkets = await FireStoreData.getAllMarkets();
    loadding = false;
    setState(() {});
  }

  Future<void> saveEntry() async {
    if (_formKey.currentState!.validate()) {
      print(_formKey.currentState!.value);
      final result = await FireStoreData.entryWriteData(
        drinkid: _formKey.currentState!.value['drinkid'],
        marketid: _formKey.currentState!.value['marketid'],
        releasedate: _formKey.currentState!.value['releasedate'],
        entrytype: _formKey.currentState!.value['entrytype'],
        price: _formKey.currentState!.value['price'],
      );
      if (result) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('저장이 완료되었습니다.'),
            );
          },
        ).then((value) => context.go('/entry'));
      } else {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('저장이 실패되었습니다.'),
            );
          },
        );
      }
    }
  }

  @override
  void initState() {
    getStateData();
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
    _formKey.currentState?.fields.clear();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: !loadding
          ? SingleChildScrollView(
              child: Column(
                children: [
                  FormBuilder(
                    key: _formKey,
                    onChanged: () {
                      _formKey.currentState!.save();
                    },
                    child: Column(
                      children: [
                        FormBuilderDropdown(
                          name: 'entrytype',
                          decoration: const InputDecoration(
                            hintText: '등록타입선택',
                          ),
                          items: entryTypes
                              .map<DropdownMenuItem>((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '등록 타입을 등록해주세요.'),
                          ]),
                        ),
                        FormBuilderDropdown(
                          name: 'drinkid',
                          decoration: const InputDecoration(
                            hintText: '주류선택',
                          ),
                          items: allDrinks
                              .map<DropdownMenuItem>((e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.name),
                                  ))
                              .toList(),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '주류를 선택해 주세요.'),
                          ]),
                        ),
                        FormBuilderDropdown(
                          name: 'marketid',
                          decoration: const InputDecoration(
                            hintText: '지점선택',
                          ),
                          items: allMarkets
                              .map<DropdownMenuItem>((e) => DropdownMenuItem(
                                    value: e.id,
                                    child: Text(e.name),
                                  ))
                              .toList(),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '지점을 선택해 주세요.'),
                          ]),
                        ),
                        FormBuilderDateTimePicker(
                          name: 'releasedate',
                          decoration: const InputDecoration(
                            hintText: '발매일정',
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '날짜를 선택해 주세요.'),
                          ]),
                        ),
                        FormBuilderTextField(
                          name: 'price',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9]'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            hintText: '가격',
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '가격을 입력해주세요.'),
                            FormBuilderValidators.minLength(4,
                                errorText: '천원단위 이상 금액을 입력하세요.'),
                            FormBuilderValidators.numeric(
                              errorText: '숫자를 입력하세요.',
                            )
                          ]),
                        ),
                        Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.spaceAround,
                            children: [
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: 50,
                                child: MainElevatedButton(
                                  onPressed: () {
                                    context.pop();
                                  },
                                  child: const Text('뒤로가기'),
                                ),
                              ),
                              SizedBox(
                                width: MediaQuery.of(context).size.width * 0.45,
                                height: 50,
                                child: MainElevatedButton(
                                  onPressed: () {
                                    saveEntry();
                                  },
                                  color: Colors.green,
                                  child: const Text('저장하기'),
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),
                  )
                ],
              ),
            )
          : LoadingPage(height: 300),
    );
  }
}
