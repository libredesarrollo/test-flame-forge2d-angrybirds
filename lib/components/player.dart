import 'package:flame/events.dart';
import 'package:flutter/services.dart';

import 'package:flame/sprite.dart';
import 'package:flame/flame.dart';
import 'package:flame/components.dart';
import 'package:flame_forge2d/flame_forge2d.dart';

class PlayerBody extends BodyComponent with ContactCallbacks, DragCallbacks {
  Vector2 position;
  late Vector2 originalPosition;
  late Vector2 maxDistance = Vector2.all(10);

  // sprite
  // late PlayerComponent playerComponent;

  PlayerBody({required this.position}) : super() {
    renderBody = true;
    originalPosition = position;
  }

  @override
  Future<void> onLoad() async {
    await super.onLoad();

    // playerComponent = PlayerComponent(mapSize: mapSize);
    // add(playerComponent);
  }

  @override
  Body createBody() {
    final shape = CircleShape()..radius = 2;
    final bodyDef =
        BodyDef(position: position, type: BodyType.kinematic, userData: this);
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
    super.update(dt);
  }

  @override
  void onDragUpdate(DragUpdateEvent event) {
    // con la resta de lso vectores A y B se obtiene un vector que va de A a B
    // con la magnitud/length se obtiene la distancia entre los vectores A y B
    // final distancePositions = (body.position - originalPosition).length;
    final distancePositions =
        (game.screenToWorld(event.canvasPosition) - originalPosition).length;
    print(distancePositions);
    if (distancePositions < 15) {
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
                  15),
          0);
    }

    super.onDragUpdate(event);
  }

  @override
  void onDragEnd(DragEndEvent event) {
    body.setType(BodyType.dynamic);
    body.applyForce((position - body.position) * 400);
    super.onDragEnd(event);
  }
}

// class PlayerComponent extends SpriteAnimationComponent with DragCallbacks {


//   @override
//   void onDragUpdate(DragUpdateEvent event) {
//     final camera =
//         game.firstChild<CameraComponent>()!; // gameRef.cameraComponent;
//     // camera.moveBy(event.delta);
//     camera.viewfinder.position += event.delta / camera.viewfinder.zoom;

//     position = camera.viewfinder.position;

//     super.onDragUpdate(event);
//   }
// }