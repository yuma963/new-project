// 文字（部首・アルファベット・数字）を武器として使うシューティングゲーム

// プレイヤー・敵・弾のクラス定義
class Player {
  float x, y;
  int hp = 3;
  Player(float x, float y) {
    this.x = x;
    this.y = y;
  }
  void move(int dir) {
    x += dir * 10;
    x = constrain(x, 30, width-30);
  }
  void show() {
    fill(0, 150, 255);
    ellipse(x, y, 40, 40);
    fill(0);
    textSize(16);
    text("自", x-10, y+5); // プレイヤーの文字
  }
}

class Enemy {
  float x, y;
  int hp = 3;
  Enemy(float x, float y) {
    this.x = x;
    this.y = y;
  }
  void show() {
    fill(255, 80, 80);
    ellipse(x, y, 40, 40);
    fill(0);
    textSize(16);
    text("敵", x-10, y+5); // 敵の文字
  }
}

class Bullet {
  float x, y;
  float vy;
  String moji;
  boolean fromPlayer;
  Bullet(float x, float y, float vy, String moji, boolean fromPlayer) {
    this.x = x;
    this.y = y;
    this.vy = vy;
    this.moji = moji;
    this.fromPlayer = fromPlayer;
  }
  void update() {
    y += vy;
  }
  void show() {
    fill(0);
    textSize(24);
    text(moji, x-8, y+8);
  }
}

Player player;
Enemy enemy;
ArrayList<Bullet> bullets;
String[] mojis = {"水", "火", "A", "B", "1", "2"}; // 武器の文字
int mojiIndex = 0;
boolean gameOver = false;
boolean win = false;

void setup() {
  size(600, 400);
  player = new Player(width/2, height-50);
  enemy = new Enemy(width/2, 50);
  bullets = new ArrayList<Bullet>();
  PFont font = createFont("Meiryo",50);
  textFont(font);
}

void draw() {
  background(240);
  if (gameOver) {
    textSize(32);
    fill(win ? color(0,200,0) : color(200,0,0));
    text(win ? "勝利!" : "ゲームオーバー", width/2-80, height/2);
    return;
  }
  player.show();
  enemy.show();
  // 弾の表示・更新
  for (int i=bullets.size()-1; i>=0; i--) {
    Bullet b = bullets.get(i);
    b.update();
    b.show();
    // プレイヤー弾が敵に当たる
    if (b.fromPlayer && dist(b.x, b.y, enemy.x, enemy.y) < 30) {
      enemy.hp--;
      bullets.remove(i);
      if (enemy.hp <= 0) {
        gameOver = true;
        win = true;
      }
      continue;
    }
    // 敵弾がプレイヤーに当たる
    if (!b.fromPlayer && dist(b.x, b.y, player.x, player.y) < 30) {
      player.hp--;
      bullets.remove(i);//a
      if (player.hp <= 0) {
        gameOver = true;
        win = false;
      }
      continue;
    }
    // 画面外
    if (b.y < 0 || b.y > height) {
      bullets.remove(i);
    }
  }
  // HP表示
  fill(0);
  textSize(16);
  text("自HP:"+player.hp, 20, height-20);
  text("敵HP:"+enemy.hp, 20, 30);
  // 武器選択表示
  text("武器: " + mojis[mojiIndex], width-120, height-20);
  // 敵の自動攻撃
  if (frameCount % 60 == 0 && !gameOver) {
    String emo = mojis[int(random(mojis.length))];
    bullets.add(new Bullet(enemy.x, enemy.y+20, 4, emo, false));
  }
}

void keyPressed() {
  if (gameOver) return;
  if (keyCode == LEFT) player.move(-1);
  if (keyCode == RIGHT) player.move(1);
  if (key == ' ') {
    // 弾発射
    bullets.add(new Bullet(player.x, player.y-20, -6, mojis[mojiIndex], true));
  }
  if (key == 'Z' || key == 'z') {
    mojiIndex = (mojiIndex+1) % mojis.length;
  }
  if (key == 'X' || key == 'x') {
    mojiIndex = (mojiIndex-1+mojis.length) % mojis.length;
  }
}
