
// VARIABEL GLOBAL UNTUK KONTROL OBJEK 
float pitch = 0.3; // Posisi awal agar terlihat lebih baik
float yaw = -0.4;
float roll = 0;

float objX = 0;
float objY = 0;
float zoom = 1.0;

// Variabel Kecepatan untuk Gerakan Halus 
float pitchVelocity = 0;
float yawVelocity = 0;
float rollVelocity = 0;
float moveX_Velocity = 0; // Kecepatan gerak horizontal
float moveY_Velocity = 0; // Kecepatan gerak vertikal


//VARIABEL GLOBAL UNTUK KONTROL CAHAYA
float lightX = 200;
float lightY = -100;
float lightZ = 300;
int lightColorMode = 0; // 0:Putih, 1:Kuning, 2:Hijau, 3:Merah, 4:Biru
float lightR = 255, lightG = 255, lightB = 255;


//FUNGSI SETUP
void setup() {
  size(1000, 800, P3D);
  smooth(8);
}


//FUNGSI DRAW: Dijalankan berulang kali (loop utama) 
void draw() {
  background(20, 25, 30);
  
  pitch += pitchVelocity;
  yaw += yawVelocity;
  roll += rollVelocity;
  objX += moveX_Velocity;
  objY += moveY_Velocity;
  
  //Pengaturan Warna Cahaya 
  switch(lightColorMode) {
    case 0: lightR = 255; lightG = 255; lightB = 255; break; // Putih Murni
    case 1: lightR = 255; lightG = 255; lightB = 0; break;   // Kuning Stabilo
    case 2: lightR = 100; lightG = 255; lightB = 0; break;   // Hijau Stabilo
    case 3: lightR = 255; lightG = 0; lightB = 100; break;   // Pink Stabilo
    case 4: lightR = 0; lightG = 255; lightB = 255; break;   // Biru Cyan Stabilo
  }
  
  // Menggambar Bola Cahaya 
  pushMatrix();
  translate(lightX, lightY, lightZ);
  noStroke();
  fill(lightR, lightG, lightB);
  sphere(15);
  popMatrix();
  
  //  Pencahayaan Scene 
  lights();
  pointLight(lightR, lightG, lightB, lightX, lightY, lightZ);
  ambientLight(60, 60, 60); // Cahaya ambient dinaikkan sedikit agar objek tidak terlalu gelap

  // Transformasi & Posisi Objek SMR 
  pushMatrix();
  translate(width/2 + objX, height/2 + objY, 0);
  scale(zoom);
  rotateX(pitch);
  rotateY(yaw);
  rotateZ(roll);
  
  // Menggambar Objek Utama 
  // Panggilan drawShadow() sudah dihapus.
  drawSMR();
  
  popMatrix();
  
  //  Teks Bantuan di Layar
  drawInstructions();
}


// FUNGSI GAMBAR OBJEK 

void drawSMR() {
  stroke(0);
  strokeWeight(1);
  fill(150, 180, 255);
  
  pushMatrix(); translate(-150, 0, 0); drawS(); popMatrix();
  pushMatrix(); translate(0, 0, 0);   drawM(); popMatrix();
  pushMatrix(); translate(150, 0, 0); drawR(); popMatrix();
}


void drawS() {
  pushMatrix(); translate(0, -60, 0); box(80, 20, 20); popMatrix();
  pushMatrix(); translate(-30, -30, 0); box(20, 60, 20); popMatrix();
  pushMatrix(); translate(0, 0, 0); box(80, 20, 20); popMatrix();
  pushMatrix(); translate(30, 30, 0); box(20, 60, 20); popMatrix();
  pushMatrix(); translate(0, 60, 0); box(80, 20, 20); popMatrix();
}

void drawM() {
  pushMatrix(); translate(-40, 0, 0); box(20, 140, 20); popMatrix();
  pushMatrix(); translate(40, 0, 0); box(20, 140, 20); popMatrix();
  pushMatrix(); translate(-20, -10, 0); rotateZ(QUARTER_PI / 2); box(20, 80, 20); popMatrix();
  pushMatrix(); translate(20, -10, 0); rotateZ(-QUARTER_PI / 2); box(20, 80, 20); popMatrix();
}

void drawR() {
  pushMatrix(); translate(-30, 0, 0); box(20, 140, 20); popMatrix();
  pushMatrix(); translate(10, -50, 0); box(60, 20, 20); popMatrix();
  pushMatrix(); translate(30, -20, 0); box(20, 60, 20); popMatrix();
  pushMatrix(); translate(15, 30, 0); rotateZ(-QUARTER_PI); box(20, 80, 20); popMatrix();
}

// FUNGSI UNTUK MENAMPILKAN TEKS BANTUAN DI LAYAR 
void drawInstructions() {
  pushStyle();
  hint(DISABLE_DEPTH_TEST);
  camera();
  ortho();
  
  fill(255, 220);
  textSize(14);
  textAlign(LEFT, TOP);
  
  String helpText = "====== KONTROL PROGRAM ======\n" +
                    "Klik Kiri Drag       : Putar Objek\n" +
                    "Klik Kanan Drag      : Gerakkan Bola Cahaya\n\n" +
                    "--- Gerakan Halus ---\n" +
                    "Tahan W / S          : Geser Atas / Bawah\n" +
                    "Tahan J / L          : Geser Kiri / Kanan\n" +
                    "Tahan A / D          : Roll Kiri / Kanan\n" +
                    "Tahan Panah          : Pitch & Yaw\n\n" +
                    "--- Lainnya ---\n" +
                    "T                    : Ganti Warna Cahaya\n" +
                    "+ / -                : Zoom In / Out\n" +
                    "R                    : Reset";
                    
  text(helpText, 15, 15);
  
  hint(ENABLE_DEPTH_TEST);
  popStyle();
}


// KONTROL INPUT PENGGUNA

void mouseDragged() {
  float dx = mouseX - pmouseX; // Perubahan mouse X
  float dy = mouseY - pmouseY; // Perubahan mouse Y

  if (mouseButton == LEFT) {
    yaw += dx * 0.01;
    pitch += dy * 0.01;
  } else if (mouseButton == RIGHT) {
    lightX += dx;
    lightY += dy;
  }
}

void keyPressed() {
  float rotationSpeed = 0.02;
  float moveSpeed = 3; 
  
  if (keyCode == UP)   { pitchVelocity = -rotationSpeed; }
  if (keyCode == DOWN) { pitchVelocity = rotationSpeed; }
  if (keyCode == LEFT) { yawVelocity = -rotationSpeed; }
  if (keyCode == RIGHT){ yawVelocity = rotationSpeed; }
  
  switch(key) {
    case 'a': case 'A': rollVelocity = -rotationSpeed; break;
    case 'd': case 'D': rollVelocity = rotationSpeed; break;
    
    case 'w': case 'W': moveY_Velocity = -moveSpeed; break;
    case 's': case 'S': moveY_Velocity = moveSpeed; break;
    case 'j': case 'J': moveX_Velocity = -moveSpeed; break;
    case 'l': case 'L': moveX_Velocity = moveSpeed; break;
      
    case '+': case '=': zoom *= 1.1; break;
    case '-':           zoom *= 0.9; break;
    
    case 't': case 'T':
      lightColorMode = (lightColorMode + 1) % 5;
      break;
      
    case 'r': case 'R':
      pitch = 0.3; yaw = -0.4; roll = 0;
      pitchVelocity = 0; yawVelocity = 0; rollVelocity = 0;
      moveX_Velocity = 0; moveY_Velocity = 0;
      objX = 0; objY = 0; zoom = 1.0;
      lightX = 200; lightY = -100; lightZ = 300;
      lightColorMode = 0;
      break;
  }
}

void keyReleased() {
  if (keyCode == UP || keyCode == DOWN) { pitchVelocity = 0; }
  if (keyCode == LEFT || keyCode == RIGHT) { yawVelocity = 0; }
  
  switch(key) {
    case 'a': case 'A':
    case 'd': case 'D': rollVelocity = 0; break;
    case 'w': case 'W':
    case 's': case 'S': moveY_Velocity = 0; break;
    case 'j': case 'J':
    case 'l': case 'L': moveX_Velocity = 0; break;
  }
}
