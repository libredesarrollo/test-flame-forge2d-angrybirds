import 'package:flame/events.dart';
import 'package:flutter/services.dart';

import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';
import 'package:testforgeangrybirds/utils/create_animation_by_limit.dart';

class PlayerBody extends BodyComponent with ContactCallbacks, DragCallbacks {
  late Vector2 originalPosition;
  final double maxDistance = 15.0;

  bool _throwPlayer = false;

  double _elapseTimeToRemove = 0;
  final double _timeToRemove = 10;

  // sprite
  late PlayerComponent _playerComponent;

  PlayerBody({required this.originalPosition}) : super() {
    renderBody = true;
  }

  @override
  Future<void> onLoad() async {
    _playerComponent = PlayerComponent();
    add(_playerComponent);

    await super.onLoad();
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 2;
    final bodyDef = BodyDef(
        position: originalPosition, type: BodyType.kinematic, userData: this);
    FixtureDef fixtureDef =
        FixtureDef(shape, friction: 1, density: 0, restitution: 0);
    return world.createBody(bodyDef)..createFixture(fixtureDef);
  }

  @override
  void beginContact(Object other, Contact contact) {
    super.beginContact(other, contact);
  }

  @override
  void endContact(Object other, Contact contact) {
    super.endContact(other, contact);
  }

  @override
  void update(double dt) {
    if (_throwPlayer) {
      if (_elapseTimeToRemove < _timeToRemove) {
        _elapseTimeToRemove += dt;
      } else if (_elapseTimeToRemove > _timeToRemove) {
        removeFromParent();
      }
    }

    super.update(dt);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // con la resta de los vectores A y B se obtiene un vector que va de A a B
    // con la magnitud/length se obtiene la distancia entre los vectores A y B
    // final distancePositions = (body.position - originalPosition).length;
    final distancePositions =
        (game.screenToWorld(event.canvasPosition) - originalPosition).length;
    print(distancePositions);
    if (distancePositions < maxDistance) {
      // body.setTransform(body.position + game.screenToWorld(event.delta), 0);
      body.setTransform(game.screenToWorld(event.canvasPosition), 0);
    } else {
      // obtenemos el vector que va desde la posicion original a la del canvas
      // game.screenToWorld(event.canvasPosition) - originalPosition

      // llevamos a un vector unitario
      // (game.screenToWorld(event.canvasPosition) - originalPosition).normalized()

      // llevamos el vector unitario al maximo tamano permitido
      // ((game.screenToWorld(event.canvasPosition) - originalPosition) .normalized() * 15)

      // le sumanos la posicion original

      body.setTransform(
          originalPosition +
              ((game.screenToWorld(event.canvasPosition) - originalPosition)
                      .normalized() *
                  maxDistance),
          0);
    }

    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    body.setType(BodyType.dynamic);
    body.applyForce((originalPosition - body.position) * 400);
    _playerComponent.animation = _playerComponent.flyAnimation;
    _throwPlayer = true;

    super.onDragEnd(event);
  }
}

class PlayerComponent extends SpriteAnimationComponent {
  late SpriteAnimation idleAnimation, flyAnimation;

  PlayerComponent() : super(anchor: Anchor.center, size: Vector2.all(10)) {
    size = Vector2.all(10);
    anchor = Anchor.center;
  }
  @override
  onLoad() async {
    final spriteImage = await Flame.images.load('birds.png');
    final spriteSheet =
        SpriteSheet(image: spriteImage, srcSize: Vector2.all(125));

    // init animation
    idleAnimation = spriteSheet.createAnimationByLimit(
        xInit: 0, yInit: 0, step: 3, sizeX: 3, stepTime: .08);
    flyAnimation = spriteSheet.createAnimationByLimit(
        xInit: 1, yInit: 0, step: 3, sizeX: 3, stepTime: .08);

    animation = idleAnimation;

    return super.onLoad();
  }
}
