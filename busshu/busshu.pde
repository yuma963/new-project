
// 武器候補（例：部首・アルファベット・数字）
String[] weaponCandidates = {"氵", "A", "7", "木", "卩"};
boolean[] weaponSelected = {false, false, false, false, false};

int maxSelect = 3;
boolean battleStarted = false;
int[] selectedWeaponIdx = {-1, -1, -1}; // 選択した武器のインデックス
int currentWeapon = 0; // 0,1,2で切り替え

// 棒人間キャラクターの状態
float playerX = 200;
float playerY = 400;
float playerVX = 0;
float playerVY = 0;
boolean onGround = true;
boolean attacking = false;
int attackFrame = 0;
float walkAnim = 0;
boolean walking = false;

void setup() {
  size(800, 600);
  PFont font = createFont("Meiryo", 50);
  textFont(font);
}

void draw() {
  background(240);
  if (!battleStarted) {
    drawWeaponSelectScreen();
  } else {
    drawBattleScreen();
  }
}

void drawWeaponSelectScreen() {
  // タイトル
  textAlign(CENTER, CENTER);
  textSize(32);
  fill(50);
  text("武器を選んでね！", width/2, 60);

  // カード表示
  int cardW = 100;
  int cardH = 140;
  int gap = 40;
  int startX = (width - (cardW * weaponCandidates.length + gap * (weaponCandidates.length-1)))/2;
  int y = 160;
  textSize(48);
  for (int i=0; i<weaponCandidates.length; i++) {
    int x = startX + i * (cardW + gap);
    // カード枠
    stroke(weaponSelected[i] ? color(0,180,0) : 120);
    strokeWeight(3);
    fill(weaponSelected[i] ? color(220,255,220) : 255);
    rect(x, y, cardW, cardH, 16);
    // 武器文字
    fill(30);
    text(weaponCandidates[i], x+cardW/2, y+cardH/2);
    // 選択済みならチェックマーク
    if (weaponSelected[i]) {
      drawCheckMark(x+cardW-30, y+cardH-30);
    }
  }

  // 決定ボタン
  int btnW = 220;
  int btnH = 60;
  int btnX = width/2 - btnW/2;
  int btnY = height - 120;
  int selectedCount = 0;
  for (int j=0; j<weaponSelected.length; j++) if (weaponSelected[j]) selectedCount++;
  boolean btnEnabled = (selectedCount == maxSelect);
  stroke(0);
  strokeWeight(3);
  fill(btnEnabled ? color(0,180,0) : color(180));
  rect(btnX, btnY, btnW, btnH, 16);
  textSize(32);
  fill(255);
  text("決定する！", width/2, btnY+btnH/2);
}

void drawBattleScreen() {
  background(200,220,255);
  // 地面
  stroke(120);
  strokeWeight(2);
  line(0, 500, width, 500);

  // 棒人間の物理更新
  playerX += playerVX;
  playerY += playerVY;
  // 重力
  if (!onGround) {
    playerVY += 1.2;
  }
  // 地面判定
  if (playerY >= 400) {
    playerY = 400;
    playerVY = 0;
    onGround = true;
  }
  // 歩行アニメーション更新
  walking = abs(playerVX) > 0.1 && onGround;
  if (walking) {
    walkAnim += 0.18 * abs(playerVX)/6.0;
  } else if (onGround) {
    walkAnim = 0;
  }
  // 攻撃アニメーション
  if (attacking) {
    attackFrame++;
    if (attackFrame > 10) {
      attacking = false;
      attackFrame = 0;
    }
  }

  // 武器文字（選択した3つからcurrentWeaponで切り替え）
  String weaponStr = "";
  if (selectedWeaponIdx[currentWeapon] != -1) {
    weaponStr = weaponCandidates[selectedWeaponIdx[currentWeapon]];
  }
  drawStickMan(playerX, playerY, attacking, walkAnim, walking, !onGround, weaponStr);
}

void drawStickMan(float x, float y, boolean attack, float anim, boolean walking, boolean jumping, String weaponStr) {
  pushMatrix();
  translate(x, y);
  stroke(0);
  strokeWeight(8);
  // 頭
  fill(255);
  ellipse(0, -40, 32, 32);
  // 体
  line(0, -24, 0, 32);

  // 腕（肩→肘→手）
  float upperArmLen = 22;
  float lowerArmLen = 18;
  float armAngleR, elbowAngleR, armAngleL, elbowAngleL;
  if (attack) {
    // 攻撃時は右腕を前に伸ばす
    armAngleR = radians(-10);
    elbowAngleR = radians(10);
    armAngleL = radians(-150);
    elbowAngleL = radians(-10);
  } else if (jumping) {
    armAngleR = radians(-60);
    elbowAngleR = radians(0);
    armAngleL = radians(-120);
    elbowAngleL = radians(0);
  } else {
    // 停止時も歩行（走行）ポーズ（右腕をお腹の位置まで下げる）
    float swing = sin(anim)*28;
    armAngleR = radians(-1 + swing); // -50→-80で右腕をより下げる
    elbowAngleR = radians(40 + cos(anim)*10); // 18→40で肘を曲げて前に
    armAngleL = radians(-200 - swing);
    elbowAngleL = radians(18 - cos(anim)*18);
  }
  // 右腕
  float exR = upperArmLen*cos(armAngleR);
  float eyR = upperArmLen*sin(armAngleR);
  float hxR = exR + lowerArmLen*cos(armAngleR+elbowAngleR);
  float hyR = eyR + lowerArmLen*sin(armAngleR+elbowAngleR);
  line(0, 0, exR, eyR); // 肩→肘
  line(exR, eyR, hxR, hyR); // 肘→手
  pushStyle();
  if (weaponStr.length() > 0) {
    pushMatrix();
    translate(hxR, hyR);
    rotate(armAngleR + elbowAngleR + HALF_PI); // 武器を手の向きに合わせる
    fill(255, 220, 80);
    stroke(180, 120, 0);
    strokeWeight(4);
    rectMode(CENTER);
    rect(0, 0, 36, 36, 8); // 武器の背景を四角に
    fill(30);
    textAlign(CENTER, CENTER);
    textSize(32);
    text(weaponStr, 0, 2);
    popMatrix();
  }
  popStyle();
  // 左腕
  float exL = upperArmLen*cos(armAngleL);
  float eyL = upperArmLen*sin(armAngleL);
  float hxL = exL + lowerArmLen*cos(armAngleL+elbowAngleL);
  float hyL = eyL + lowerArmLen*sin(armAngleL+elbowAngleL);
  line(0, 0, exL, eyL);
  line(exL, eyL, hxL, hyL);

  // 足（股→膝→足）
  float upperLegLen = 24;
  float lowerLegLen = 22;
  float legAngleR, kneeAngleR, legAngleL, kneeAngleL;
  if (jumping) {
    legAngleR = radians(90);
    kneeAngleR = radians(0);
    legAngleL = radians(90);
    kneeAngleL = radians(0);
  } else {
    // 停止時も歩行（走行）ポーズ
    float swing = sin(anim)*40;
    legAngleR = radians(90 + swing);
    kneeAngleR = radians(30 + cos(anim)*30);
    legAngleL = radians(90 - swing);
    kneeAngleL = radians(30 - cos(anim)*30);
  }
  // 右足
  float kxR = upperLegLen*cos(legAngleR);
  float kyR = upperLegLen*sin(legAngleR);
  float fxR = kxR + lowerLegLen*cos(legAngleR+kneeAngleR);
  float fyR = kyR + lowerLegLen*sin(legAngleR+kneeAngleR);
  line(0, 32, kxR, kyR+32); // 股→膝
  line(kxR, kyR+32, fxR, fyR+32); // 膝→足
  // 左足
  float kxL = upperLegLen*cos(legAngleL);
  float kyL = upperLegLen*sin(legAngleL);
  float fxL = kxL + lowerLegLen*cos(legAngleL+kneeAngleL);
  float fyL = kyL + lowerLegLen*sin(legAngleL+kneeAngleL);
  line(0, 32, kxL, kyL+32);
  line(kxL, kyL+32, fxL, fyL+32);

  popMatrix();
}
void drawCheckMark(float cx, float cy) {
  stroke(0,180,0);
  strokeWeight(6);
  noFill();
  beginShape();
  vertex(cx-12, cy);
  vertex(cx, cy+12);
  vertex(cx+18, cy-18);
  endShape();
}

void mousePressed() {
  if (!battleStarted) {
    int cardW = 100;
    int cardH = 140;
    int gap = 40;
    int startX = (width - (cardW * weaponCandidates.length + gap * (weaponCandidates.length-1)))/2;
    int y = 160;
    for (int i=0; i<weaponCandidates.length; i++) {
      int x = startX + i * (cardW + gap);
      if (mouseX > x && mouseX < x+cardW && mouseY > y && mouseY < y+cardH) {
        int selectedCount = 0;
        for (int j=0; j<weaponSelected.length; j++) if (weaponSelected[j]) selectedCount++;
        if (!weaponSelected[i] && selectedCount < maxSelect) {
          weaponSelected[i] = true;
        } else if (weaponSelected[i]) {
          weaponSelected[i] = false;
        }
      }
    }
    // 選択した武器インデックスを更新
    int selectedCount2 = 0;
    for (int i=0; i<weaponSelected.length; i++) {
      if (weaponSelected[i]) {
        if (selectedCount2 < 3) selectedWeaponIdx[selectedCount2] = i;
        selectedCount2++;
      }
    }
    for (int i=selectedCount2; i<3; i++) selectedWeaponIdx[i] = -1;
    // 武器選択が変わったらcurrentWeaponを0にリセット
    currentWeapon = 0;
    // 決定ボタン判定
    int btnW = 220;
    int btnH = 60;
    int btnX = width/2 - btnW/2;
    int btnY = height - 120;
    int selectedCount = 0;
    for (int j=0; j<weaponSelected.length; j++) if (weaponSelected[j]) selectedCount++;
    boolean btnEnabled = (selectedCount == maxSelect);
    if (btnEnabled && mouseX > btnX && mouseX < btnX+btnW && mouseY > btnY && mouseY < btnY+btnH) {
      battleStarted = true;
    }
  }
}



void keyPressed() {
  if (battleStarted) {
    // 左右移動
    if (key == 'A' || key == 'a') {
      playerVX = -6;
    } else if (key == 'D' || key == 'd') {
      playerVX = 6;
    }
    // 武器切り替え
    if (key == '1') currentWeapon = 0;
    if (key == '2') currentWeapon = 1;
    if (key == '3') currentWeapon = 2;
    // ジャンプ
    if ((key == ' ' || keyCode == 32) && onGround) {
      playerVY = -18;
      onGround = false;
    }
    // 攻撃
    if (keyCode == ENTER || key == '\n') {
      attacking = true;
      attackFrame = 0;
    }
  }
}



void keyReleased() {
  if (battleStarted) {
    // 移動停止
    if (key == 'A' || key == 'a' || key == 'D' || key == 'd') {
      playerVX = 0;
    }
  }
}
