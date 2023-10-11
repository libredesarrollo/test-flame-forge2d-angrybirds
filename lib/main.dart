import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:testforgeangrybirds/components/player.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends Forge2DGame
    with TapDetector, HasKeyboardHandlerComponents {
  PlayerBody? playerBody;

  MyGame() : super(gravity: Vector2(0, 40));

  void onTapDown(TapDownInfo info) {
    if (playerBody == null || playerBody!.isRemoved) {
      playerBody =
          PlayerBody(originalPosition: screenToWorld(info.eventPosition.game));
      world.add(playerBody!);
    }

    super.onTapDown(info);
  }

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
  }
}
