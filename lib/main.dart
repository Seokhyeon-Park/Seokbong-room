import 'package:flame/game.dart';
import 'package:flutter/widgets.dart';

import 'seokbongRoom.dart';

void main() {
  runApp(
    // controlled : 해당 값은 'true'로 설정되면 게임 루프가 제어되고 고정된 FPS로 실행됨.
    // gameFactory : 'SeokbongRoom' 객체를 만들기 위한 팩토리 함수 지정
    // SeokbongRoom 게임 오브젝트를 생성 -> GameWidget 초기화 -> 어플리케이션 실행(RunApp), controlled가 true 이므로 게임 루프가 제어되고 고정된 FPS로 게임이 실행됨.
    const GameWidget<SeokbongRoom>.controlled( gameFactory: SeokbongRoom.new ),
  );
}