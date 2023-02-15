import 'dart:html';
import 'dart:io';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_form_builder/flutter_form_builder.dart';
import 'package:form_builder_validators/form_builder_validators.dart';
import 'package:image_picker/image_picker.dart';
import 'package:maccave_menager/firebaseserver/firestoredata.dart';
import 'package:maccave_menager/models/drinkmodel.dart';
import 'package:maccave_menager/models/marketmodel.dart';
import 'package:maccave_menager/src/loddinpage.dart';
import 'package:maccave_menager/widgets/mainelevatedbtn.dart';

class DrinkWritePage extends StatefulWidget {
  const DrinkWritePage({super.key});

  @override
  State<DrinkWritePage> createState() => _DrinkWritePageState();
}

class _DrinkWritePageState extends State<DrinkWritePage> {
  final _formKey = GlobalKey<FormBuilderState>();
  final ImagePicker _picker = ImagePicker();
  XFile? _imageFile;
  List<String> drinkTypes = ['싱글몰트', '더블캐스크'];
  bool loadding = true;

  Future<void> getStateData() async {
    loadding = false;
    setState(() {});
  }

  Future<void> setImagePicker() async {
    _imageFile = await _picker.pickImage(source: ImageSource.camera);
    if (_imageFile != null) {}
    print('setImagePicker');
    setState(() {});
  }

  Future<void> saveDrink() async {
    if (_formKey.currentState!.validate() && _imageFile != null) {
      final result = await FireStoreData.drinkWriteData(
          name: _formKey.currentState!.value['name'],
          nameen: _formKey.currentState!.value['name_en'],
          place: _formKey.currentState!.value['place'],
          alcohol: _formKey.currentState!.value['alcohol'],
          releasedate: _formKey.currentState!.value['releasedate'],
          type: _formKey.currentState!.value['type'],
          imagefile: _imageFile,
          volume: _formKey.currentState!.value['volume']);
      if (result) {
        showDialog(
          context: context,
          builder: (context) {
            return const AlertDialog(
              content: Text('저장이 완료되었습니다.'),
            );
          },
        ).then((value) => context.go('/drink'));
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
    if (kIsWeb) {
      document.addEventListener('keydown',
          (event) => event.type == 'tab' ? event.preventDefault() : null);
    }

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
                          name: 'type',
                          decoration: const InputDecoration(
                            hintText: '타입선택',
                          ),
                          items: drinkTypes
                              .map<DropdownMenuItem>((e) => DropdownMenuItem(
                                    value: e,
                                    child: Text(e),
                                  ))
                              .toList(),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '위스키 타입을 선택해 주세요.'),
                          ]),
                        ),
                        FormBuilderTextField(
                          name: 'name',
                          decoration: const InputDecoration(hintText: '한글이름'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '한글 이름을 입력하십시오.'),
                          ]),
                        ),
                        FormBuilderTextField(
                          name: 'name_en',
                          decoration: const InputDecoration(hintText: '영어이름'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '영어 이름을 입력하십시오.'),
                          ]),
                        ),
                        FormBuilderTextField(
                          name: 'place',
                          decoration: const InputDecoration(hintText: '원산지'),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '지역을 입력하십시오.'),
                          ]),
                        ),
                        FormBuilderTextField(
                          name: 'alcohol',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9]'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            hintText: '도수',
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '도수를 입력해주세요.'),
                            FormBuilderValidators.maxLength(3,
                                errorText: '도수가 너무 높습니다.'),
                            FormBuilderValidators.numeric(
                              errorText: '숫자를 입력하세요.',
                            )
                          ]),
                        ),
                        FormBuilderTextField(
                          name: 'volume',
                          inputFormatters: [
                            FilteringTextInputFormatter.allow(
                              RegExp(r'[0-9]'),
                            ),
                          ],
                          decoration: const InputDecoration(
                            hintText: '용량',
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '용량를 입력해주세요.'),
                            FormBuilderValidators.numeric(
                              errorText: '숫자를 입력하세요.',
                            )
                          ]),
                        ),
                        FormBuilderDateTimePicker(
                          name: 'releasedate',
                          decoration: const InputDecoration(
                            hintText: '생산일자',
                          ),
                          validator: FormBuilderValidators.compose([
                            FormBuilderValidators.required(
                                errorText: '날짜를 선택해 주세요.'),
                          ]),
                        ),
                        InkWell(
                          onTap: () {
                            setImagePicker();
                          },
                          child: SizedBox(
                            width: MediaQuery.of(context).size.width,
                            height: 250,
                            child: _imageFile != null
                                ? Image.network(
                                    _imageFile!.path,
                                    fit: BoxFit.cover,
                                  )
                                : const Center(
                                    child: Text('없당'),
                                  ),
                          ),
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
                                    saveDrink();
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
