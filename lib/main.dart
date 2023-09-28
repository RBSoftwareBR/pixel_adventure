import 'package:flame/flame.dart';
import 'package:flame/game.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:pixel_adventure/pixel_adventure.dart';

final PixelAdventure game = PixelAdventure();
void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Flame.device.fullScreen(); // On real devices runApp may run before setting fullscren/landscape
  await Flame.device.setLandscape();
  runApp(GameWidget(game: kDebugMode? PixelAdventure():game));
}
