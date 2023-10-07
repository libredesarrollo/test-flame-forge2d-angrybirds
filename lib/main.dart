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
  late PlayerBody playerBody;

  bool _addPlayer = false;
  double _elapseTimeToRemove = 0;
  final double _timeToRemove = 5;

  MyGame() : super(gravity: Vector2(0, 40));

  void onTapDown(TapDownInfo info) {
    if (_elapseTimeToRemove == 0 && !_addPlayer) {
      playerBody = PlayerBody(position: screenToWorld(info.eventPosition.game));
      _addPlayer = true;
    }

    world.add(playerBody);
    super.onTapDown(info);

    // world.add(Box(info.eventPosition.game));
  }

  @override
  void update(double dt) {
    if (_addPlayer) {
      if (_elapseTimeToRemove < _timeToRemove) {
        _elapseTimeToRemove += dt;
      } else if (_elapseTimeToRemove > _timeToRemove) {
        playerBody.removeFromParent();
        _elapseTimeToRemove = 0;
        _addPlayer = false;
      }
    }

    super.update(dt);
  }

  // late TileMapComponent background;

  //final cameraWorld = camera.World();
  // late final CameraComponent cameraComponent;

  // late PlayerBody playerBody;

  @override
  Future<void> onLoad() async {
    camera.viewfinder.anchor = Anchor.topLeft;
    // Vector2 gameSize = screenToWorld(camera.viewport.size);

    // playerBody = PlayerBody(mapSize: gameSize);
    // world.add(playerBody);

    // playerBody.loaded.then((value) {
    //   playerBody.playerComponent.loaded.then((value) {
    //     camera.follow(playerBody.playerComponent);
    //     camera.viewfinder.anchor = Anchor.center;
    //   });
    // });

    // world.add(background);

    // background.loaded.then(
    //   (value) {
    //   },
    // );

    // playerBody.loaded.then((value) {
    // print("loaded");
    // playerBody.body.position = Vector2(20, 10);
    // });
  }
}
