import 'package:flame/components.dart';

class CollisionBlock extends PositionComponent {
  final bool isPlatform;
  CollisionBlock({this.isPlatform = false, super.position, super.size});
}
