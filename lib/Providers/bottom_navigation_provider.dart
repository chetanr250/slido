import 'package:flutter_riverpod/flutter_riverpod.dart';

class BottomNavigationButtonState {
  bool isLeftEnabled;
  bool isRightEnabled;
  String leftText;
  String rightText;
  int modeIndex;
  bool isEnabled;

  BottomNavigationButtonState({
    required this.isLeftEnabled,
    required this.isRightEnabled,
    required this.leftText,
    required this.rightText,
    this.modeIndex = 0,
    required this.isEnabled,
  });
}

class BottomNavigationButtonNotifier
    extends StateNotifier<BottomNavigationButtonState> {
  BottomNavigationButtonNotifier()
      : super(BottomNavigationButtonState(
          isLeftEnabled: true,
          isRightEnabled: true,
          leftText: 'Left Button',
          rightText: 'Right Button',
          isEnabled: true,
        ));

  // void toggleButton() {
  //   state = BottomNavigationButtonState(
  //       isLeftEnabled: !state.isLeftEnabled,
  //       isRightEnabled: !state.isRightEnabled,
  //       leftText: state.leftText,
  //       rightText: state.rightText);
  // }

  void updateText(String newText) {
    state = BottomNavigationButtonState(
      isLeftEnabled: state.isLeftEnabled,
      isRightEnabled: state.isRightEnabled,
      leftText: newText,
      rightText: state.rightText,
      isEnabled: state.isEnabled,
    );
  }

  void decrementModeIndex() {
    state = BottomNavigationButtonState(
      isLeftEnabled: state.isLeftEnabled,
      isRightEnabled: state.isRightEnabled,
      leftText: state.leftText,
      rightText: state.rightText,
      modeIndex: state.modeIndex - 1,
      isEnabled: state.isEnabled,
    );
  }
}

final bottomNavigationButtonProvider = StateNotifierProvider<
    BottomNavigationButtonNotifier, BottomNavigationButtonState>((ref) {
  return BottomNavigationButtonNotifier();
});

// class BottomNavigationProviderExample extends ConsumerWidget {
//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     final buttonState = ref.watch(bottomNavigationButtonProvider);

//     return Scaffold(
//       appBar: AppBar(
//         title: Text('Bottom Navigation Provider Example'),
//       ),
//       body: Center(
//         child: Column(
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             ElevatedButton(
//               onPressed: buttonState.isEnabled ? () {} : null,
//               child: Text(buttonState.text),
//             ),
//             SizedBox(height: 20),
//             ElevatedButton(
//               onPressed: () => ref
//                   .read(bottomNavigationButtonProvider.notifier)
//                   .toggleButton(),
//               child: Text('Toggle Button'),
//             ),
//             SizedBox(height: 20),
//             TextField(
//               onChanged: (newText) => ref
//                   .read(bottomNavigationButtonProvider.notifier)
//                   .updateText(newText),
//               decoration: InputDecoration(labelText: 'Edit Button Text'),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }

// void main() {
//   runApp(ProviderScope(
//       child: MaterialApp(home: BottomNavigationProviderExample())));
// }
