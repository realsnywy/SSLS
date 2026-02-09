# SSLS - Snywy's Silly Little Script

<p align="center">
  <img src="https://github.com/user-attachments/assets/e8483ac8-a527-4f48-b5b0-714b7cca3c2a" width="150" alt="SSLS Logo">
</p>

Um utilitário de automação modular em PowerShell projetado para configurar o Windows 11 (e 10) rapidamente após uma formatação. Instale seus programas favoritos, aplique otimizações de sistema e acesse atalhos úteis com facilidade.

> **Nota:** Este projeto está em desenvolvimento e é destinado para uso pessoal. Este software será fornecido com os computadores que eu reparo.

<p align="center">
  <img src="screenshot_software.png" alt="Programas" width="45%">
  <img src="screenshot_tweaks.png" alt="Otimizações" width="45%">
</p>

## 🚀 Funcionalidades

* **Instalação em Massa (Estilo Ninite):** Selecione múltiplos programas de uma lista curada (Navegadores, Dev Tools, Mídia, Utilitários) e instale tudo de uma vez via `winget`.
* **Tweaks de Sistema (Windows 11 Ready):**
  * Restauração do Menu de Contexto Clássico.
  * Modo de Desempenho Máximo (Ultimate Performance) e Power Throttling.
  * Debloat (Remoção de Bing, Telemetria, Relatório de Erros e Sugestões).
  * Otimizações de Input Lag (Mouse, Tela Cheia e HAGS).
  * Ajustes de Privacidade, Rede e Visual (Modo Escuro, Transparência).
* **Atalhos Rápidos:** Acesso direto a configurações profundas do Windows (Ativação, Apps Padrão, etc.).
* **Extras e Manutenção:**
  * Executor de comandos manuais.
  * Criação rápida de Ponto de Restauração.
* **Recurso de Reversão (Undo):** Aplicou um tweak e não gostou? O script possui um botão dedicado para **desfazer** as alterações.

## 📦 Softwares Incluídos

A lista utiliza o repositório oficial do Windows Package Manager (Winget) e inclui softwares das seguintes categorias:

* **Internet**
* **Multimídia**
* **Gráficos**
* **Jogos**
* **Dev**
* **Sistema**

## ⚠️ Aviso Legal

Este script altera configurações do registro do Windows e instala softwares de terceiros. Embora tenha sido testado para ser seguro e inclua opções de reversão, **use por sua conta e risco**. Recomenda-se criar um Ponto de Restauração antes de aplicar modificações profundas no sistema.

---
*Feito para tornar a formatação menos dolorosa.*
