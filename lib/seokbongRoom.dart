import 'dart:ui';
// import 'package:flutter/material.dart';
import 'package:flame/components.dart';
import 'package:flame/game.dart';
import 'components/player/player.dart';
import 'package:flame/events.dart';

// FlameGame을 상속하고 HasKeyboardHandlerComponents를 구현함.
// 해당 클래스는 게임의 업데이트 및 랜더링 로직 구현
class SeokbongRoom extends FlameGame with HasKeyboardHandlerComponents {
  SeokbongRoom();

  // 나중에 초기화(late)
  late Player _player;

  // 백그라운드 이미지
  late SpriteComponent _background;

  // onLoad Override,
  // onLoad() : 게임이 로드되면 실행, 게임 오브젝트를 초기화하고 리소스를 로드함.
  @override
  Future<void> onLoad() async {
    // 이미지 리소스 로드
    await images.loadAll([
      // 'CITY_MEGA.png',
      'ember.png',
    ]);

    // 배경 이미지 설정
    // _background = SpriteComponent(
    //   sprite: await Sprite.load('background.png'),
    // );

    // Player 오브젝트 생성, _player 초기화.
    _player = Player(
      // Player의 초기 위치 (바닥은 해당 값을 기준으로 계산함)
      position: Vector2(128, canvasSize.y -70),
    );

    // add : 해당 메서드를 사용하여 게임에 추가.
    // add(_background);
    add(_player);
  }
}
