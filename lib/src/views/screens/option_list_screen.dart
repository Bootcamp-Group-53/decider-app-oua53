import 'package:decider_app/src/views/widgets/card_flip.dart';
import 'package:decider_app/src/views/widgets/fortune_wheel_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

class OptionListScreen extends StatefulWidget {
  final Map<String, dynamic> model;

  const OptionListScreen({super.key, required this.model});

  @override
  State<OptionListScreen> createState() => OptionListScreenState();
}

class OptionListScreenState extends State<OptionListScreen> {
  final _formKey = GlobalKey<FormState>();
  final _controller = TextEditingController();
  final List<String> _items = [];

  void _addItem(String item) {
    if (_items.length < (widget.model['maxItem'] as int)) {
      setState(() {
        _items.add(item);
      });
      _controller.clear();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content:
              Text('Maksimum ${widget.model['maxItem']} öğe ekleyebilirsiniz.'),
        ),
      );
    }
  }

  void _deleteItem(int index) {
    setState(() {
      _items.removeAt(index);
    });
  }

  void _editItem(int index, String newItem) {
    setState(() {
      _items[index] = newItem;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Seçenekler'),
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            children: <Widget>[
              Form(
                key: _formKey,
                child: TextFormField(
                  controller: _controller,
                  decoration: InputDecoration(
                    labelText: 'Yeni öğe ekleyin',
                    suffixIcon: IconButton(
                      icon: const Icon(Icons.add),
                      onPressed: () {
                        if (_formKey.currentState!.validate()) {
                          _addItem(_controller.text);
                        }
                      },
                    ),
                  ),
                  validator: (value) {
                    if (value!.isEmpty) {
                      return 'Lütfen bir değer girin';
                    }
                    return null;
                  },
                ),
              ),
              Expanded(
                child: ListView.builder(
                  itemCount: _items.length,
                  itemBuilder: (context, index) {
                    return ListTile(
                      title: Text(_items[index]),
                      trailing: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: <Widget>[
                          IconButton(
                            icon: const Icon(Icons.edit),
                            onPressed: () async {
                              final newText = await showDialog<String>(
                                context: context,
                                builder: (BuildContext context) {
                                  String editedText = _items[index];
                                  return AlertDialog(
                                    title: const Text('Öğeyi düzenle'),
                                    content: TextFormField(
                                      initialValue: _items[index],
                                      onChanged: (value) {
                                        editedText = value;
                                      },
                                    ),
                                    actions: <Widget>[
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop();
                                        },
                                        child: const Text('İptal'),
                                      ),
                                      TextButton(
                                        onPressed: () {
                                          Navigator.of(context).pop(editedText);
                                        },
                                        child: const Text('Kaydet'),
                                      ),
                                    ],
                                  );
                                },
                              );
                              if (newText != null && newText.isNotEmpty) {
                                _editItem(index, newText);
                              }
                            },
                          ),
                          IconButton(
                            icon: const Icon(Icons.delete),
                            onPressed: () {
                              _deleteItem(index);
                            },
                          ),
                        ],
                      ),
                    );
                  },
                ),
              ),
              SizedBox(
                width: 0.80.sw,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color.fromARGB(255, 7, 63, 109),
                  ),
                  onPressed: () {
                    if (widget.model['onPressed'] == 'fortune') {
                      Navigator.pushNamed(
                        context,
                        '/action_screen',
                        arguments: FortuneWheelWidget(deciderList: _items),
                      );
                    } else if (widget.model['onPressed'] == 'card') {
                      Navigator.pushNamed(
                        context,
                        '/action_screen',
                        arguments: CardFlip(deciderList: _items),
                      );
                    }
                  },
                  child: Text(
                    'Devam Et',
                    style: TextStyle(
                      fontSize: 17.sp,
                      color: Colors.white,
                      fontWeight: FontWeight.w700,
                    ),
                    textAlign: TextAlign.center,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
