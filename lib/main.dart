import 'dart:async';
import 'package:flutter/material.dart';

import 'package:flame/components.dart';
import 'package:flame/events.dart';
import 'package:flame/game.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

import 'package:testforgeangrybirds/components/box.dart' as box;
import 'package:testforgeangrybirds/components/player.dart';
import 'package:testforgeangrybirds/utils/boundaries.dart';

void main() {
  runApp(GameWidget(game: MyGame()));
}

class MyGame extends Forge2DGame
    with TapDetector, HasKeyboardHandlerComponents {
  PlayerBody? playerBody;

  int _currentLevel = 0;

  double _boxTimer = 0.0;
  int _boxIndex = 0;

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
    world.addAll(createBoundaries(this));
  }

  _addBoxs(double dt) {
    if (_boxIndex < box.getCurrentLevel(level: _currentLevel).length) {
      if (_boxTimer >=
          box.getCurrentLevel(level: _currentLevel)[_boxIndex].timeToAdd) {
        final boxBody = box.BoxBody(
            position:
                box.getCurrentLevel(level: _currentLevel)[_boxIndex].position);
        world.add(boxBody);
        _boxIndex++;
        _boxTimer = 0;
      }
      _boxTimer += dt;
    }
  }

  @override
  void update(double dt) {
    _addBoxs(dt);
    super.update(dt);
  }
}
