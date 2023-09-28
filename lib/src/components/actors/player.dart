import 'dart:async';

import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import 'package:pixel_adventure/src/components/actors/player_state.dart';
import 'package:pixel_adventure/assets.dart';
import 'package:pixel_adventure/pixel_adventure.dart';
import 'package:pixel_adventure/src/components/blocks/colision_block.dart';
import 'package:pixel_adventure/src/helpers/utils.dart';

import '../../helpers/constants.dart';

class Player extends SpriteAnimationGroupComponent
    with HasGameRef<PixelAdventure>, KeyboardHandler {
  final String selectedCharacter;
  late final SpriteAnimation idleAnimation;
  late final SpriteAnimation runningAnimation;
  late final SpriteAnimation fallAnimation;
  late final SpriteAnimation hitAnimation;
  late final SpriteAnimation jumpAnimation;
  late final SpriteAnimation wallJumpAnimation;
  late final SpriteAnimation doubleJumpAnimation;
  final double _jumpForce = 450;
  final double _terminalVelocity = 300;
  double horizontalMovement = 0;
  double moveSpeed = 10;
  Vector2 velocity = Vector2.zero();
  bool isOnGround = true;
  bool hasJumped = false;
  List<CollisionBlock> collisionsBlocks;

  Player(
      {this.selectedCharacter =
          Assets.assets_images_main_characters_ninja_frog_idle_32x32_png,
      this.collisionsBlocks = const <CollisionBlock>[],
      super.position});

  @override //DELTA TIME
  void update(double dt) {
    _updatePlayerState();
    _updatePlayerMovement(dt);
    _checkHorizontalCollisions();
    _applyGravity(dt);
    _checkVerticalCollisions();
    super.update(dt);
  }

  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalMovement = 0;
    final isLeftKeyPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowLeft) ||
            keysPressed.contains(LogicalKeyboardKey.keyA);
    final isRightPressed =
        keysPressed.contains(LogicalKeyboardKey.arrowRight) ||
            keysPressed.contains(LogicalKeyboardKey.keyD);
    hasJumped = keysPressed.contains(LogicalKeyboardKey.arrowUp) ||
        keysPressed.contains(LogicalKeyboardKey.keyW) ||
        keysPressed.contains(LogicalKeyboardKey.space);
    horizontalMovement += isLeftKeyPressed ? -moveSpeed : 0;
    horizontalMovement += isRightPressed ? moveSpeed : 0;

    return super.onKeyEvent(event, keysPressed);
  }

  @override
  FutureOr<void> onLoad() {
    _loadAnimations();
    return super.onLoad();
  }

  void _loadAnimations() {
    idleAnimation = _initAnimation(PlayerState.idle);
    runningAnimation = _initAnimation(PlayerState.running);
    fallAnimation = _initAnimation(PlayerState.fall);
    hitAnimation = _initAnimation(PlayerState.hit);
    jumpAnimation = _initAnimation(PlayerState.jump);
    wallJumpAnimation = _initAnimation(PlayerState.wallJump);
    doubleJumpAnimation = _initAnimation(PlayerState.doubleJump);
    //List of all animations
    animations = {
      PlayerState.idle: idleAnimation,
      PlayerState.running: runningAnimation,
      PlayerState.fall: fallAnimation,
      PlayerState.hit: hitAnimation,
      PlayerState.jump: jumpAnimation,
      PlayerState.wallJump: wallJumpAnimation,
      PlayerState.doubleJump: doubleJumpAnimation,
    };
    //Set current animation
    current = PlayerState.idle;
  }

  SpriteAnimation _initAnimation(PlayerState state) {
    return SpriteAnimation.fromFrameData(
        game.images
            .fromCache(getAnimationPathFromAsset(selectedCharacter, state)),
        SpriteAnimationData.sequenced(
            amount: state.amount,
            stepTime: STEP_TIME,
            textureSize: Vector2.all(32)));
  }

  void _updatePlayerMovement(double dt) {
    if (hasJumped && isOnGround)  _playerJump(dt);
    if(velocity.y > GRAVITY) isOnGround = false;
    velocity.x = horizontalMovement * moveSpeed;
    position.x += velocity.x * dt;

  }

  void _playerJump(dt) {
    velocity.y = -_jumpForce;
    position.y += velocity.y * dt;
    hasJumped = false;
    isOnGround = false;
  }

  void _updatePlayerState() {
    PlayerState playerState = PlayerState.idle;
    if (velocity.x < 0 && scale.x > 0) {
      flipHorizontallyAroundCenter();
    } else if (velocity.x > 0 && scale.x < 0) {
      flipHorizontallyAroundCenter();
    }
    if (velocity.x > 0 || velocity.x < 0) playerState = PlayerState.running;
    //check if falling
    if (velocity.y > 0) playerState = PlayerState.fall;
    if (velocity.y < 0) playerState = PlayerState.jump;
    current = playerState;
  }

  //handle collisions
  void _checkHorizontalCollisions() {
    if (velocity.x == 0) return; // No need to check if not moving horizontally.
    for (final block in collisionsBlocks) {
      if (!block.isPlatform) {
        if (checkCollision(this, block)) {
          if (velocity.x > 0) {
            velocity.x = 0;
            position.x = block.x - width;
            break;
          }
          if (velocity.x < 0) {
            velocity.x = 0;
            position.x = block.x + block.width + width;
            break;
          }
        }
      }
    }
  }

  void _applyGravity(double dt) {
    velocity.y += GRAVITY;
    velocity.y = velocity.y.clamp(-_jumpForce, _terminalVelocity);
    position.y += velocity.y * dt;
  }

  void _checkVerticalCollisions() {
    for (final block in collisionsBlocks) {
      if (checkCollision(this, block)) {
        if (velocity.y > 0) {
          velocity.y = 0;
          position.y = block.y - height;
          isOnGround = true;
          break;
        } else if (velocity.y < 0 && !block.isPlatform) {
          velocity.y = 0;
          position.y = block.y + block.height;
        }
      }
    }
  }
}
