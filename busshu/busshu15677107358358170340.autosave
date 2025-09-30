
// 武器候補（例：部首・アルファベット・数字）
String[] weaponCandidates = {"氵", "A", "7", "木", "B"};
boolean[] weaponSelected = {false, false, false, false, false};
int maxSelect = 3;

void setup() {
	size(800, 600);
  PFont font = createFont("Meiryo", 50);
  textFont(font);
}

void draw() {
	background(240);
	drawWeaponSelectScreen();
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
}
