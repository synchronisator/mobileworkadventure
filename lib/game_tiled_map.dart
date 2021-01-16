import 'dart:math';

import 'package:bonfire/bonfire.dart';
import 'package:mobileworkadventure/decoration/barrel_dragable.dart';
import 'package:mobileworkadventure/decoration/chest.dart';
import 'package:mobileworkadventure/decoration/spikes.dart';
import 'package:mobileworkadventure/decoration/torch.dart';
import 'package:mobileworkadventure/enemy/goblin.dart';
import 'package:mobileworkadventure/interface/knight_interface.dart';
import 'package:mobileworkadventure/map/dungeon_map.dart';
import 'package:mobileworkadventure/player/knight.dart';
import 'package:flutter/foundation.dart' show kIsWeb;
import 'package:flutter/material.dart';

class GameTiledMap extends StatelessWidget {
  final int map;

  const GameTiledMap({Key key, this.map = 1}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        DungeonMap.tileSize = max(constraints.maxHeight, constraints.maxWidth) / (kIsWeb ? 25 : 22);
        return BonfireTiledWidget(
          joystick: Joystick(
            keyboardEnable: true,
            directional: JoystickDirectional(
              spriteBackgroundDirectional: Sprite('joystick_background.png'),
              spriteKnobDirectional: Sprite('joystick_knob.png'),
              size: 100,
              isFixed: false,
            ),
            actions: [
              JoystickAction(
                actionId: 0,
                sprite: Sprite('joystick_atack.png'),
                align: JoystickActionAlign.BOTTOM_RIGHT,
                size: 80,
                margin: EdgeInsets.only(bottom: 50, right: 50),
              ),
              JoystickAction(
                actionId: 1,
                sprite: Sprite('joystick_atack_range.png'),
                spriteBackgroundDirection: Sprite('joystick_background.png'),
                enableDirection: true,
                size: 50,
                margin: EdgeInsets.only(bottom: 50, right: 160),
              )
            ],
          ),
          player: Knight(
            Position((8 * DungeonMap.tileSize), (5 * DungeonMap.tileSize)),
          ),
          interface: KnightInterface(),
          map: TiledWorldMap(
            'tiled/mapa$map.json',
            forceTileSize: Size(DungeonMap.tileSize, DungeonMap.tileSize),
          )
            ..registerObject('goblin', (x, y, width, height) => Goblin(Position(x, y)))
            ..registerObject('torch', (x, y, width, height) => Torch(Position(x, y)))
            ..registerObject('barrel', (x, y, width, height) => BarrelDraggable(Position(x, y)))
            ..registerObject('spike', (x, y, width, height) => Spikes(Position(x, y)))
            ..registerObject('chest', (x, y, width, height) => Chest(Position(x, y))),
          background: BackgroundColorGame(Colors.blueGrey[900]),
          lightingColorGame: Colors.black.withOpacity(0.3),
          cameraZoom: 1.0, // you can change the game zoom here or directly on camera
        );
      },
    );
  }
}
