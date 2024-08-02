// ignore_for_file: use_build_context_synchronously

import 'dart:math';
import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';

import '../../core/constants/app_route_constants.dart';
import '../../core/helper/decider_storage_helper.dart';

class CardFlip extends StatefulWidget {
  final List<String> deciderList;

  const CardFlip({super.key, required this.deciderList});

  @override
  State<CardFlip> createState() => _CardSelectionPageState();
}

class _CardSelectionPageState extends State<CardFlip>
    with SingleTickerProviderStateMixin {
  List<bool> _isFlipped = [];
  List<bool> _isSelected = [];
  bool _selectionComplete = false;
  late AnimationController _controller;
  late Animation<double> _animation;
  late List<String> _currentDeciderList;
  final DeciderStorageHelper _storageHelper = DeciderStorageHelper();

  @override
  void initState() {
    widget.deciderList.shuffle();
    super.initState();
    _isFlipped = List.filled(widget.deciderList.length, false);
    _isSelected = List.filled(widget.deciderList.length, false);

    _currentDeciderList = List.from(widget.deciderList);

    _controller = AnimationController(
      vsync: this,
      duration: const Duration(milliseconds: 500),
    );
    _animation = Tween<double>(begin: 0, end: 1).animate(_controller);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  void _resetSelection() {
    setState(() {
      _currentDeciderList.shuffle();
      _isFlipped = List.filled(widget.deciderList.length, false);
      _isSelected = List.filled(widget.deciderList.length, false);
      _selectionComplete = false;

      _controller.reset();
    });
  }

  void _selectCard(int index) async {
    if (_selectionComplete || _isFlipped[index]) return;

    setState(() {
      _isFlipped[index] = true;
      _isSelected[index] = true;

      _selectionComplete = true;
      for (int i = 0; i < _isFlipped.length; i++) {
        _isFlipped[i] = true;
      }
    });

    _controller.forward(from: 0);

    await _storageHelper.saveDecision(
      options: _currentDeciderList,
      selectedOption: _currentDeciderList[index],
    );

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Karar kaydedildi: ${_currentDeciderList[index]}'),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Card Selection Game'),
      ),
      body: Column(
        children: [
          Expanded(
            child: GridView.builder(
              padding: EdgeInsets.all(16.w),
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 3,
                crossAxisSpacing: 10.0,
                mainAxisSpacing: 10.0,
              ),
              itemCount: _currentDeciderList.length,
              itemBuilder: (context, index) {
                return GestureDetector(
                  onTap: () => _selectCard(index),
                  child: AnimatedBuilder(
                    animation: _animation,
                    builder: (context, child) {
                      return Transform(
                        transform: Matrix4.rotationY(
                          pi * (_isFlipped[index] ? _animation.value : 0),
                        ),
                        alignment: Alignment.center,
                        child: _isFlipped[index]
                            ? Transform(
                                transform: Matrix4.rotationY(
                                  pi * (_animation.value > 0.5 ? 1 : 0),
                                ),
                                alignment: Alignment.center,
                                child: Card(
                                  elevation: 5,
                                  shape: RoundedRectangleBorder(
                                    side: BorderSide(
                                      color: _isSelected[index]
                                          ? Colors.green
                                          : Colors.transparent,
                                      width: 3,
                                    ),
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  child: Center(
                                    child: Text(
                                      _currentDeciderList[index],
                                      style: TextStyle(
                                        fontSize: 18.sp,
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                  ),
                                ),
                              )
                            : const Card(
                                elevation: 5,
                                child: Center(
                                  child: Icon(
                                    Icons.question_mark,
                                    size: 40,
                                    color: Colors.grey,
                                  ),
                                ),
                              ),
                      );
                    },
                  ),
                );
              },
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 7, 63, 109),
            ),
            onPressed: _resetSelection,
            child: Text(
              'Tekrar Seç',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 7, 63, 109),
            ),
            onPressed: () {
              Navigator.pushNamedAndRemoveUntil(
                  context, RouteConstants.deciderListScreen, (route) => false);
            },
            child: Text(
              'Anasayfa',
              style: TextStyle(
                fontSize: 14.sp,
                color: Colors.white,
                fontWeight: FontWeight.bold,
              ),
              textAlign: TextAlign.center,
            ),
          ),
          SizedBox(height: 16.h),
        ],
      ),
    );
  }
}
