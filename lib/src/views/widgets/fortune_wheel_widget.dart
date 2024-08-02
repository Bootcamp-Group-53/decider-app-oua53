// ignore_for_file: use_build_context_synchronously

import 'package:decider_app/src/core/constants/app_route_constants.dart';
import 'package:flutter/material.dart';
import 'package:flutter_fortune_wheel/flutter_fortune_wheel.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:rxdart/subjects.dart';
import '../../core/helper/decider_storage_helper.dart';

class FortuneWheelWidget extends StatefulWidget {
  final List<String> deciderList;
  const FortuneWheelWidget({super.key, required this.deciderList});

  @override
  State<FortuneWheelWidget> createState() => _FortuneWheelWidgetState();
}

class _FortuneWheelWidgetState extends State<FortuneWheelWidget> {
  final selected = BehaviorSubject<int>();
  String selectedLetter = "";
  final DeciderStorageHelper _storageHelper = DeciderStorageHelper();

  @override
  void dispose() {
    selected.close();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Çarkı Çevir'),
      ),
      body: FortuneWheelWidgetWidget(
        selected: selected,
        selectedLetter: selectedLetter,
        onAnimationEnd: _onAnimationEnd,
        onPressed: swipeFortuneLetter,
        deciderList: widget.deciderList,
      ),
    );
  }

  void swipeFortuneLetter() {
    setState(() {
      selected.add(Fortune.randomInt(0, widget.deciderList.length));
    });
  }

  void _onAnimationEnd() async {
    final int selectedIndex = selected.value;
    final String selectedOption = widget.deciderList[selectedIndex];

    // Seçilen seçeneği güncelle
    setState(() {
      selectedLetter = selectedOption;
    });

    // Yeni kararı kaydet
    await _storageHelper.saveDecision(
        options: widget.deciderList, selectedOption: selectedOption);

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text('Karar kaydedildi: $selectedOption'),
      ),
    );
  }
}

class FortuneWheelWidgetWidget extends StatefulWidget {
  const FortuneWheelWidgetWidget({
    super.key,
    required this.selected,
    required this.selectedLetter,
    required this.onAnimationEnd,
    required this.onPressed,
    required this.deciderList,
  });

  final BehaviorSubject<int> selected;
  final String selectedLetter;
  final Function() onAnimationEnd;
  final void Function() onPressed;
  final List<String> deciderList;

  @override
  State<FortuneWheelWidgetWidget> createState() =>
      _FortuneWheelWidgetWidgetState();
}

class _FortuneWheelWidgetWidgetState extends State<FortuneWheelWidgetWidget> {
  bool _isButtonDisabled = false;

  void _handlePress() {
    widget.onPressed();
    setState(() {
      _isButtonDisabled = true;
    });
  }

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      bottom: true,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          SizedBox(height: 0.02.sh),
          Text(
            "Karar: ${widget.selectedLetter}",
          ),
          const Spacer(),
          Center(
            child: LetterFortuneWheel(
              selected: widget.selected,
              onAnimationEnd: () {
                widget.onAnimationEnd();
                setState(() {
                  _isButtonDisabled = false;
                });
              },
              deciderList: widget.deciderList,
            ),
          ),
          const Spacer(),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 7, 63, 109),
            ),
            onPressed: _isButtonDisabled ? null : _handlePress,
            child: Text(
              'Döndür',
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
          const Spacer(),
        ],
      ),
    );
  }
}

class LetterFortuneWheel extends StatelessWidget {
  const LetterFortuneWheel({
    super.key,
    required this.selected,
    required this.onAnimationEnd,
    required this.deciderList,
  });

  final BehaviorSubject<int> selected;
  final Function() onAnimationEnd;
  final List<String> deciderList;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 0.5.sh,
      width: 0.90.sw,
      child: FortuneWheel(
        duration: const Duration(seconds: 6, milliseconds: 800),
        selected: selected.stream,
        animateFirst: false,
        indicators: <FortuneIndicator>[
          FortuneIndicator(
            alignment: Alignment.topCenter,
            child: TriangleIndicator(
              color: Colors.amber,
              width: 25.w,
              height: 25.h,
              elevation: 5,
            ),
          ),
        ],
        items: [
          for (int i = 0; i < deciderList.length; i++) ...<FortuneItem>{
            FortuneItem(
              style: FortuneItemStyle(
                textStyle: TextStyle(
                  color: Colors.black,
                  fontSize: 20.sp,
                ),
                color: const Color.fromARGB(255, 7, 63, 109),
                borderWidth: 0.5,
                borderColor: Colors.white,
              ),
              child: Transform.rotate(
                angle: 1.5708,
                child: Align(
                  alignment: Alignment.topCenter,
                  child: Padding(
                    padding: EdgeInsets.symmetric(vertical: 25.h),
                    child: Text(
                      deciderList[i],
                      style: TextStyle(
                        color: Colors.white,
                        fontSize: 20.sp,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          }
        ],
        onAnimationEnd: onAnimationEnd,
      ),
    );
  }
}
