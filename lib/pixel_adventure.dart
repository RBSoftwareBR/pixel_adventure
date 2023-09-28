import 'dart:async';
import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/src/components/actors/player.dart';
import 'package:pixel_adventure/assets.dart';
import 'package:pixel_adventure/src/helpers/asset_path_helper.dart';
import 'package:pixel_adventure/src/helpers/constants.dart';
import 'package:pixel_adventure/src/components/levels/level.dart';

class PixelAdventure extends FlameGame
    with HasKeyboardHandlerComponents, DragCallbacks {
  @override
  Color backgroundColor() => const Color(0xff211f30);
  @override
  late final CameraComponent camera;
  final player = Player(
    selectedCharacter:
        Assets.assets_images_main_characters_ninja_frog_idle_32x32_png,
  );
  late JoystickComponent joystick;

  @override
  void update(double dt) {
    if (SHOW_JOYSTICK) updateJoystick();
    super.update(dt);
  }

  @override
  FutureOr<Function?> onLoad() async {
    //Load all images into cache
    await images.loadAllImages();
    Level level01 = Level(
        levelPath: Assets.assets_tiles_level_02_tmx,
        size: Vector2.all(16),
        player: player);
    camera = CameraComponent.withFixedResolution(
        width: 640, height: 360, world: level01);
    camera.viewfinder.anchor = Anchor.topLeft;
    //add(Level());
    addAll([camera, level01]);
    if (SHOW_JOYSTICK) addJoystick();
    super.onLoad();
    return null;
  }

  void addJoystick() {
    joystick = JoystickComponent(
        knob: SpriteComponent(
          sprite: Sprite(images.fromCache(
              assetFromImageFolder(Assets.assets_images_hud_knob_png))),
        ),
        background: SpriteComponent(
          sprite: Sprite(images.fromCache(
              assetFromImageFolder(Assets.assets_images_hud_joystick_png))),
        ),
        margin: const EdgeInsets.only(left: 32, bottom: 32));
    add(joystick);
  }

  void updateJoystick() {
    switch (joystick.direction) {
      case JoystickDirection.left:
        player.horizontalMovement = -player.moveSpeed;
        break;
      case JoystickDirection.upLeft:
        player.horizontalMovement = -player.moveSpeed;
        break;
      case JoystickDirection.downLeft:
        player.horizontalMovement = -player.moveSpeed;
        break;
      case JoystickDirection.right:
        player.horizontalMovement = player.moveSpeed;
        break;
      case JoystickDirection.upRight:
        player.horizontalMovement = player.moveSpeed;
        break;
      case JoystickDirection.downRight:
        player.horizontalMovement = player.moveSpeed;
        break;
      default:
        player.horizontalMovement = 0;
        break;
    }
  }
}
