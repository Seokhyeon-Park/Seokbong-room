import 'package:flame/components.dart';
import 'package:flutter/services.dart';
import '../../seokbongRoom.dart';

// SpriteAnimationComponent : Flame 엔진에서 스프라이트 에니메이션을 처리하는 데 사용.
// KeyboardHandler : 키보드 이벤트를 처리하기 위한 메소드 구현.
// HasGameRef :
class Player extends SpriteAnimationComponent with KeyboardHandler, HasGameRef<SeokbongRoom> {
  Player({
    required super.position,
  }) : super(size: Vector2.all(64), anchor: Anchor.center);

  // Player의 X축 속도 및 이동속도 지정
  final Vector2 velocity = Vector2.zero();
  final double moveSpeed = 300;

  // Player의 y축(점프) 속도 및 여부 확인
  bool isJumping = false;
  bool isFalling = false;

  final double jumpSpeed = -500;
  final double gravity = 1000;
  // Player의 좌, 우 이동방향 저장
  int horizontalDirection = 0;

  // SpriteAnimation 초기화 및 로드 (게임 오브젝트가 로드되면 호출)
  @override
  Future<void> onLoad() async {
    // SpriteAnimation : 스프라이트 시퀀스를 처리하고 애니메이션을 구현하는 데 사용.
    // SpriteAnimation.fromFrameData() : SpriteAnimation 객체 생성.
    // game.images.fromCache() : 이미지 로드.
    animation = SpriteAnimation.fromFrameData(
      game.images.fromCache('ember.png'),
      SpriteAnimationData.sequenced(
        amount: 4,    // 스프라잍트 수
        stepTime: 0.12,   //스프라이트의 시간 간격
        textureSize: Vector2.all(16),   // 스프라이트 텍스처 사이즈
      ),
    );
  }

  // 점프 기능 추가
  void jump() {
    // 점프 중 인 경우, return
    if (isJumping || isFalling) return;

    isJumping = true;
    velocity.y = jumpSpeed;
  }

  // 키보드 이벤트 처리
  // keysPressed 매개 변수를 통해 현재 눌린 키 목록을 가져옴.
  @override
  bool onKeyEvent(RawKeyEvent event, Set<LogicalKeyboardKey> keysPressed) {
    horizontalDirection = 0;

    // 좌 화살표가 눌린 경우 horizontalDirection -1
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.arrowLeft))
        ? -1
        : 0;
    // 우 화살표가 눌린 경우 horizontalDirection +1
    horizontalDirection += (keysPressed.contains(LogicalKeyboardKey.arrowRight))
        ? 1
        : 0;
    if (event is RawKeyDownEvent && (event.logicalKey == LogicalKeyboardKey.space || event.logicalKey == LogicalKeyboardKey.arrowUp)) {
      jump();
    }

    // 이벤트 처리를 완료함
    return true;
  }

  // 게임 오브젝트가 업데이트 될 때마다 호출됨.
  @override
  void update(double dt) {
    // 방향 * 이동속도
    velocity.x = horizontalDirection * moveSpeed;

    // 좌우 벽에 닿았는지 확인
    // 벽에서 팅겨냄, (*주의) 키를 계속 누르고 있으면 계속 해당 방향을 향함
    // 아래 코드를 지워도 문제는 없음. (케릭터가 벽을 넘어갈 뿐)
    if (position.x <= 0) { // 좌측 벽에 닿은 경우
      horizontalDirection = 1; // 오른쪽으로 이동하도록 방향을 변경
      position.x = 0; // 위치를 벽에 붙도록 수정
    } else if (position.x + size.x >= game.size.x) { // 우측 벽에 닿은 경우
      horizontalDirection = -1; // 왼쪽으로 이동하도록 방향을 변경
      position.x = game.size.x - size.x; // 위치를 벽에 붙도록 수정
    }

    // 점프 중인데 땅에 착지한 경우
    if (isJumping) {
      velocity.y += gravity * dt;
      if (velocity.y >= 0) {
        isJumping = false;
        isFalling = true;
      }
    } else if (isFalling) {
      velocity.y += gravity * dt;
      // 플레이어가 바닥에 닿았을 때
      // gameRef.size.y : 화면 높이
      // size.y : 케릭터 높이
      final ground = gameRef.size.y - (size.y / 2);
      if (position.y + (size.y / 2) >= ground) {
        isFalling = false;
        velocity.y = 0;
        position.y = ground - size.y / 2;
      }
    }

    // 플레이어 이동 (dt는 마지막 프레임으로 부터 경가된 시간[초])
    position += velocity * dt;

    // horizontalDirection에 따라 스프라이트를 좌/우 반전
    if (horizontalDirection < 0 && scale.x > 0) {
      flipHorizontally();
    } else if (horizontalDirection > 0 && scale.x < 0) {
      flipHorizontally();
    }

    // 스프라이트 애니메이션 업데이트
    super.update(dt);
  }
}