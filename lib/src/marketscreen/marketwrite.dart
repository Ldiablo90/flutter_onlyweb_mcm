import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:maccave_menager/firebaseserver/firestoredata.dart';
import 'package:maccave_menager/src/loddinpage.dart';
import 'package:maccave_menager/widgets/mainelevatedbtn.dart';

class MarketWritePage extends StatefulWidget {
  const MarketWritePage({super.key});

  @override
  State<MarketWritePage> createState() => _MarketWritePageState();
}

class _MarketWritePageState extends State<MarketWritePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  bool loadding = true;

  Future<void> setDataInitState() async {
    loadding = false;
    setState(() {});
  }

  Future<void> saveMarket() async {
    if (_formKey.currentState!.validate()) {
      final result = await FireStoreData.marketWriteData(
        name: _formKey.currentState!.value['name'],
        col: _formKey.currentState!.value['col'],
        opening: _formKey.currentState!.value['opening'],
      );
      if (result) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('저장이 완료되었습니다.'),
            );
          },
        ).then((value) => context.go('/market'));
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
    setDataInitState();
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
                        FormBuilderTextField(
                          name: 'name',
                          decoration: const InputDecoration(
                            hintText: '마트 명',
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '마트명을 입력해주세요.')
                          ]),
                        ),
                        FormBuilderTextField(
                          name: 'col',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9.-]'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            hintText: '연락처',
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '연락처를 입력해주세요.'),
                            FormBuilderValidators.maxLength(13,
                                errorText: '연락처 자리수를 초과하였습니다.'),
                          ]),
                        ),
                        FormBuilderTextField(
                          name: 'opening',
                          decoration: const InputDecoration(
                            hintText: '월-목 08:00~22:00/금-일08:00~21:00',
                            helperText: '다양한시간이 있으면 "/"를 사용해주세요.',
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '영업시간을 입력해주세요.')
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
                                    saveMarket();
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
