import 'package:pixel_adventure/src/components/blocks/colision_block.dart';

import '../components/actors/player.dart';

bool checkCollision(Player player, CollisionBlock block) {
  // if the character is facing left it's X is also fliped
  final fixedX = player.scale.x < 0 ? player.x - player.width : player.x;
  // if its a platform then just check for bottom collisions
  final fixedY = block.isPlatform ? player.y + player.height : player.y;
  //if playerY is less than bottom block Y
  return (fixedY < block.y + block.height &&
      //if playerY + Height is less than top block Y
      player.position.y + player.height > block.y &&
      fixedX < block.x + block.width &&
      fixedX + player.width > block.x);
}
