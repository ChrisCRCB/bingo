import 'dart:math';

import 'package:backstreets_widgets/screens.dart';
import 'package:backstreets_widgets/util.dart';
import 'package:backstreets_widgets/widgets.dart';
import 'package:bingo/src/bingo_numbers.dart';
import 'package:flutter/material.dart';

/// A screen which chooses numbers.
class BingoScreen extends StatefulWidget {
  /// Create an instance.
  const BingoScreen({
    super.key,
  });

  /// Create state for this widget.
  @override
  BingoScreenState createState() => BingoScreenState();
}

/// State for [BingoScreen].
class BingoScreenState extends State<BingoScreen> {
  /// The random number generator to use.
  late final Random random;

  /// The numbers which have not yet been called.
  late final List<int> uncalledNumbers;

  /// The numbers which have already been called.
  late final List<int> calledNumbers;

  /// Initialise state.
  @override
  void initState() {
    super.initState();
    random = Random();
    uncalledNumbers = [];
    calledNumbers = [];
    populateNumbers();
  }

  /// Build a widget.
  @override
  Widget build(BuildContext context) {
    final String buttonTitle;
    if (calledNumbers.isEmpty) {
      buttonTitle = 'Start game';
    } else if (uncalledNumbers.isEmpty) {
      buttonTitle = 'Reset game';
    } else {
      buttonTitle = bingoNumbers[calledNumbers.last - 1];
    }
    return SimpleScaffold(
      title: 'Bingo (${calledNumbers.length} / ${uncalledNumbers.length})',
      actions: [
        ElevatedButton(
            onPressed: resetGame,
            child: const Icon(
              Icons.refresh,
              semanticLabel: 'Refresh game',
            ))
      ],
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Expanded(
            flex: 2,
            child: TextButton(
              onPressed: () {
                if (uncalledNumbers.isNotEmpty) {
                  callNumber();
                } else {
                  resetGame();
                }
                setState(() {});
              },
              autofocus: true,
              child: Semantics(
                liveRegion: true,
                child: Text(
                  buttonTitle,
                  textAlign: TextAlign.center,
                  style: const TextStyle(fontSize: 48),
                ),
              ),
            ),
          ),
          Expanded(
            flex: 8,
            child: calledNumbers.isEmpty
                ? const CenterText(
                    text: 'No numbers have been called yet.',
                    textStyle: TextStyle(fontSize: 20),
                    autofocus: false,
                  )
                : ListViewBuilder(
                    itemBuilder: (context, index) {
                      final number = calledNumbers.reversed.toList()[index];
                      return ListTile(
                        title: Text(
                          number.toString(),
                          style: const TextStyle(fontSize: 20),
                        ),
                        onTap: () {},
                      );
                    },
                    itemCount: calledNumbers.length,
                  ),
          )
        ],
      ),
    );
  }

  /// Populate [uncalledNumbers], and clear [calledNumbers].
  void populateNumbers() {
    uncalledNumbers.clear();
    calledNumbers.clear();
    for (var i = 0; i < bingoNumbers.length; i++) {
      uncalledNumbers.add(i + 1);
    }
  }

  /// Pop a random number from [uncalledNumbers] into [calledNumbers].
  void callNumber() {
    final number = uncalledNumbers.removeAt(
      random.nextInt(uncalledNumbers.length),
    );
    calledNumbers.add(number);
  }

  /// Reset the game.
  Future<void> resetGame() => confirm(
        context: context,
        message: 'Are you sure you want to reset the game?',
        yesCallback: () {
          Navigator.pop(context);
          populateNumbers();
          callNumber();
          setState(() {});
        },
        title: 'Reset Game',
      );
}
