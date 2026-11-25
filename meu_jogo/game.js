const canvas = document.getElementById("gameCanvas");
const ctx = canvas.getContext("2d");

const largura = canvas.width;
const altura = canvas.height;

// Carregar imagens
const imgNave = new Image();
imgNave.src = "imagens/nave-spritesheet.png";

const imgTiro = new Image();
imgTiro.src = "imagens/tiro.png";

const imgInimigo = new Image();
imgInimigo.src = "imagens/inimigo.png";

const imgExplosao = new Image();
imgExplosao.src = "imagens/explosao.png";

// Jogador
const jogador = {
  x: largura / 2 - 32,
  y: altura - 100,
  largura: 64,
  altura: 64,
  frame: 0,
  totalFrames: 4,
  animTimer: 0,
  animInterval: 10
};

const teclas = {};
const tiros = [];
const inimigos = [];
const explosoes = [];

document.addEventListener("keydown", (e) => {
  teclas[e.key] = true;
  if (e.key === " ") atirar();
});

document.addEventListener("keyup", (e) => {
  teclas[e.key] = false;
});

function moverJogador() {
  const velocidade = 5;
  if (teclas["ArrowLeft"] && jogador.x > 0) {
    jogador.x -= velocidade;
  }
  if (teclas["ArrowRight"] && jogador.x + jogador.largura < largura) {
    jogador.x += velocidade;
  }
}

function atirar() {
  tiros.push({
    x: jogador.x + jogador.largura / 2 - 5,
    y: jogador.y,
    largura: 10,
    altura: 20,
    velocidade: 8
  });
}

function desenharTiros() {
  for (let i = tiros.length - 1; i >= 0; i--) {
    const t = tiros[i];
    ctx.drawImage(imgTiro, t.x, t.y, t.largura, t.altura);
    t.y -= t.velocidade;
    if (t.y < 0) tiros.splice(i, 1);
  }
}

function criarInimigo() {
  inimigos.push({
    x: Math.random() * (largura - 50),
    y: -50,
    largura: 50,
    altura: 50,
    velocidade: 2 + Math.random() * 2
  });
}

function desenharInimigos() {
  for (let i = inimigos.length - 1; i >= 0; i--) {
    const inimigo = inimigos[i];
    ctx.drawImage(imgInimigo, inimigo.x, inimigo.y, inimigo.largura, inimigo.altura);
    inimigo.y += inimigo.velocidade;

    if (inimigo.y > altura) {
      inimigos.splice(i, 1);
    }
  }
}

function criarExplosao(x, y) {
  explosoes.push({ x, y, tempo: 20 });
}

function desenharExplosoes() {
  for (let i = explosoes.length - 1; i >= 0; i--) {
    const e = explosoes[i];
    ctx.drawImage(imgExplosao, e.x, e.y, 64, 64);
    e.tempo--;
    if (e.tempo <= 0) explosoes.splice(i, 1);
  }
}

function animarNave() {
  jogador.animTimer++;
  if (jogador.animTimer >= jogador.animInterval) {
    jogador.animTimer = 0;
    jogador.frame = (jogador.frame + 1) % jogador.totalFrames;
  }

  ctx.drawImage(
    imgNave,
    jogador.frame * jogador.largura,
    0,
    jogador.largura,
    jogador.altura,
    jogador.x,
    jogador.y,
    jogador.largura,
    jogador.altura
  );
}

function checarColisoes() {
  for (let i = inimigos.length - 1; i >= 0; i--) {
    const inimigo = inimigos[i];
    for (let j = tiros.length - 1; j >= 0; j--) {
      const tiro = tiros[j];

      if (
        tiro.x < inimigo.x + inimigo.largura &&
        tiro.x + tiro.largura > inimigo.x &&
        tiro.y < inimigo.y + inimigo.altura &&
        tiro.y + tiro.altura > inimigo.y
      ) {
        criarExplosao(inimigo.x, inimigo.y);
        inimigos.splice(i, 1);
        tiros.splice(j, 1);
        break;
      }
    }
  }
}

function loop() {
  ctx.clearRect(0, 0, largura, altura);

  moverJogador();
  animarNave();
  desenharTiros();
  desenharInimigos();
  desenharExplosoes();
  checarColisoes();

  requestAnimationFrame(loop);
}

// Iniciar
setInterval(criarInimigo, 2000);
loop();
