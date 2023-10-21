import 'dart:async';

import 'package:flame/components.dart';
import 'package:flame/flame.dart';
import 'package:flame/sprite.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:testforgeangrybirds/utils/create_animation_by_limit.dart';

class Box {
  Vector2 position;
  double timeToAdd;

  Box({required this.position, this.timeToAdd = .8});
}

// levels
List<Box> getCurrentLevel({int level = 1}) {
  switch (level) {
    case 1:
      return [
        //line 1
        Box(position: Vector2(800, 10)),
        Box(position: Vector2(840, 10)),
        Box(position: Vector2(880, 10)),
        Box(position: Vector2(920, 10)),
        Box(position: Vector2(960, 10)),
        //line 2
        Box(position: Vector2(820, 10)),
        Box(position: Vector2(860, 10)),
        Box(position: Vector2(900, 10)),
        Box(position: Vector2(940, 10)),
        //line 3
        Box(position: Vector2(840, 10)),
        Box(position: Vector2(880, 10)),
        Box(position: Vector2(920, 10)),
        //line 3
        Box(position: Vector2(860, 10)),
        Box(position: Vector2(900, 10)),
        //line 4
        Box(position: Vector2(880, 10))
      ];
    default:
      return [
        //line 1
        Box(position: Vector2(800, 10)),
        Box(position: Vector2(840, 10)),
        Box(position: Vector2(880, 10)),
        Box(position: Vector2(920, 10)),
        Box(position: Vector2(960, 10)),
        Box(position: Vector2(1000, 10)),
        //line 2
        Box(position: Vector2(800, 10)),
        Box(position: Vector2(840, 10)),

        Box(position: Vector2(960, 10)),
        Box(position: Vector2(1000, 10)),
      ];
  }
}

class BoxBody extends BodyComponent {
  Vector2 position;
  double valueToDestroy;
  double greaterImpact = 0;
  bool boxAdded = false;

  late final SpriteAnimation explotionAnimation;

  BoxBody({required this.position, this.valueToDestroy = 200});

  @override
  Body createBody() {
    Shape shape = PolygonShape()..setAsBoxXY(2, 2);

    BodyDef bodyDef = BodyDef(position: position, type: BodyType.dynamic);

    FixtureDef fixtureDef = FixtureDef(shape,
        friction: 1, density: 1, restitution: 0, userData: this);

    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void update(double dt) {
    if (greaterImpact < body.linearVelocity.length2 && boxAdded) {
      greaterImpact = body.linearVelocity.length2;
      if (body.linearVelocity.length2 >= valueToDestroy) {
        world.add(SpriteAnimationComponent(
          position: body.position,
          animation: explotionAnimation.clone(),
          anchor: Anchor.center,
          size: Vector2.all(50),
          removeOnFinish: true,
        ));

        removeFromParent();
      }
      // print(body.linearVelocity.toString());
      // print(greaterImpact);
    }
    if (body.linearVelocity == Vector2.all(0) && !boxAdded) {
      boxAdded = true;
    }
    // print(greaterImpact);
    super.update(dt);
  }

  @override
  Future<void> onLoad() async {
    final spriteImageExplotion = await Flame.images.load('explotion.png');
    final spriteSheetExplotion =
        SpriteSheet(image: spriteImageExplotion, srcSize: Vector2(306, 295));
    explotionAnimation = spriteSheetExplotion.createAnimationByLimit(
        xInit: 0, yInit: 0, step: 6, sizeX: 3, stepTime: .03, loop: false);

    add(BoxComponent());
    return super.onLoad();
  }
}

class BoxComponent extends SpriteComponent {
  BoxComponent() : super(anchor: Anchor.center, size: Vector2.all(4));
  @override
  FutureOr<void> onLoad() async {
    sprite = await Sprite.load('box.png');

    return super.onLoad();
  }
}
