import 'package:flutter_test/flutter_test.dart';
import 'package:tuto/main.dart';
void main() {
  test('money formats Vietnamese currency', () { expect(money(1250000), '1.250.000 đ'); expect(money(-500), '-500 đ'); });
  test('pocket serialization', () { final p=Pocket('a','Du lịch','✈️',200); expect(Pocket.fromJson(p.toJson()).balance,200); });
}
