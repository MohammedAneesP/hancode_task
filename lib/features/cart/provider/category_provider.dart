import 'package:flutter_riverpod/legacy.dart';

final categoryProvider = StateProvider<int>((ref) => 0);
// default index = 0
final selectedCategoryProvider = StateProvider<int>((ref) => 1);
