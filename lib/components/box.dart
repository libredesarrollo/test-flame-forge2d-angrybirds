import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class Box {
  Vector2 position;
  double timeToAdd;

  Box({required this.position, this.timeToAdd = .5});
}

// levels
List<Box> getCurrentLevel({int level = 1}) {
  switch (level) {
    case 2:
      return [
        Box(position: Vector2(2, 2)),
        Box(position: Vector2(6, 5)),
        Box(position: Vector2(5, 5)),
      ];
    default:
      return [
        Box(position: Vector2(10, 0)),
        Box(position: Vector2(15, 0)),
        Box(position: Vector2(5, 0)),
      ];
  }
}

class BoxBody extends BodyComponent {
  Vector2 position;

  BoxBody({required this.position});

  @override
  Body createBody() {
    Shape shape = PolygonShape()..setAsBoxXY(5, 5);

    BodyDef bodyDef = BodyDef(position: position, type: BodyType.dynamic);

    FixtureDef fixtureDef =
        FixtureDef(shape, friction: 1, density: 1, restitution: 0);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  Future<void> onLoad() async {
    add(BoxComponent());
    return super.onLoad();
  }
}

class BoxComponent extends SpriteComponent {
  BoxComponent() : super(anchor: Anchor.center, size: Vector2.all(10));
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('box.png');

    return super.onLoad();
  }
}
