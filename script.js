// --- TRANSIÇÃO DE ONDA SUAVE (MAR SUBINDO NA TELA) ---
function transicaoPagina(event, targetId) {
    event.preventDefault();
    const wave = document.getElementById('wave-transition');
    
    // Faz a onda subir cobrindo a tela suavemente
    wave.classList.add('ativo');

    // No momento em que a onda cobre totalmente a tela (metade da animação)
    setTimeout(() => {
        const sections = document.querySelectorAll('.content-section');
        sections.forEach(sec => sec.classList.remove('active'));

        const targetSection = document.getElementById(targetId);
        if (targetSection) {
            targetSection.classList.add('active');
        }

        window.scrollTo(0, 0);

        // Retira a onda para baixo revelando a nova página (como a água recuando na areia)
        setTimeout(() => {
            wave.classList.remove('ativo');
        }, 300);

    }, 400); // Sincronizado com a curva de transição CSS
}

// --- CONTROLE DE MODAL ---
function abrirModal() {
    const modal = document.getElementById('modalCadastro');
    if (modal) {
        modal.style.display = 'flex';
    }
}

function fecharModal() {
    const modal = document.getElementById('modalCadastro');
    if (modal) {
        modal.style.display = 'none';
    }
}

window.onclick = function(event) {
    const modal = document.getElementById('modalCadastro');
    if (event.target === modal) {
        modal.style.display = 'none';
    }
};