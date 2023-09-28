import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame_tiled/flame_tiled.dart';
import 'package:pixel_adventure/src/components/actors/player.dart';
import 'package:pixel_adventure/src/components/blocks/colision_block.dart';

class Level extends World {
  final String levelPath;
  final Vector2 size;
  final Player player;
  List<CollisionBlock> blocksToCheck = [];
  Level({required this.levelPath, required this.size, required this.player});

  late TiledComponent level;
  @override
  FutureOr<Function?> onLoad() async {
    //TODO This might cause some pain when dealing with levels in subfolders
    level = await TiledComponent.load(levelPath.split('/').last, size);
    add(level);
    final spawnPointsLayer = level.tileMap.getLayer<ObjectGroup>('Spawnpoints');
    if (spawnPointsLayer != null) {
      for (final spawnPoint in spawnPointsLayer.objects) {
        switch (spawnPoint.class_) {
          case 'Player':
            player.position = Vector2(spawnPoint.x, spawnPoint.y);
            add(player);
        }
      }
    }
    final collisionsLayer = level.tileMap.getLayer<ObjectGroup>('Colisions');
    if (collisionsLayer != null) {
      for (final collision in collisionsLayer.objects) {
        CollisionBlock platform = CollisionBlock(
            position: Vector2(collision.x, collision.y),
            size: Vector2(collision.width, collision.height),
            isPlatform: collision.class_ == "Platform"); // TODO MAKE THIS AN ENUM
        blocksToCheck.add(platform);
        add(platform);
      }
    }
    player.collisionsBlocks = blocksToCheck;
    super.onLoad();
    return null;
  }
}
