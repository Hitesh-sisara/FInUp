import 'package:flutter_riverpod/flutter_riverpod.dart';

// class BottomNavNotifier extends StateNotifier<int> {
//   BottomNavNotifier() : super(0);

//   void changeSelectedIndex(int newIndex) {
//     state = newIndex;
//   }
// }

// final bottomNavProvider = StateNotifierProvider<BottomNavNotifier, int>(
//   (ref) => BottomNavNotifier(),
// );

final navIndexProvider = StateProvider<int>((ref) => 0);
