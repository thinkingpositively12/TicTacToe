# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## How to run

No build step. Open `index.html` directly in a browser:

```powershell
Start-Process index.html
```

The repo is also published via GitHub Pages at `https://thinkingpositively12.github.io/TicTacToe/`.

## Architecture

Single-file app: all HTML, CSS, and JS live in `index.html`.

### Game state

The board is a flat 9-element array (`board`), where each index maps to a cell via `data-index`. `null` = empty, `'X'` = player, `'O'` = opponent.

Winning lines are defined in `WINNING` — an array of 8 index triples (3 rows, 3 cols, 2 diagonals).

Two global state flags: `gameOver` (boolean) and `mode` (`'pvc'` | `'pvp'`).

Scores are tracked in the `scores` object (`{ player, computer, draw }`) and persist across rounds; only switching modes triggers a full reset.

### Rendering

`renderBoard()` is the single render path — it wipes all cell classes/text and rebuilds them from the `board` array. It does not touch the game-over or disabled state of cells directly; those are managed separately by `enableBoard()` and `highlightWin()`.

### AI (minimax)

The computer plays as `'O'` using a recursive minimax search over the full game tree. It scores terminal states as +10 (O wins), -10 (X wins), or 0 (draw). The AI is unbeatable — optimal play by the human always ends in a draw.

`computerMove()` iterates empty cells, simulates each with minimax, and picks the highest-scoring move. A 350ms `setTimeout` before the computer move gives the illusion of thinking and prevents race conditions on rapid clicks.

### Turn flow (PvC mode)

1. Player clicks cell → `onCellClick` fires
2. Board is immediately disabled (`enableBoard(false)`) to block double-clicks
3. Player's X is placed, `checkEnd()` runs
4. After 350ms, computer's O is placed, `checkEnd()` runs again
5. If no winner, board is re-enabled and status shows "Your turn"

### CSS theme

All colors are CSS custom properties in `:root` — change them there to re-theme the entire game. The palette uses a dark background (`--bg: #1a1a2e`) with red X (`--x-color: #e94560`), cyan O (`--o-color: #53d8fb`), and gold win glow (`--win-glow: #f5c542`).

### Cell class contract

Cells carry state via CSS classes:
- `.taken` — cell is occupied (prevents hover effects and clicks)
- `.disabled` — board interaction is blocked (computer thinking, game over)
- `.x` / `.o` — which player occupies the cell
- `.win-cell` — part of the winning line (pulse animation)
- `.pop-in` — triggers the entry animation on move

## Git workflow

```powershell
git add -A
git commit -m "..."                   # use descriptive, imperative commits
git push
```

The remote is `origin/master` → `thinkingpositively12/TicTacToe` on GitHub. Commits follow the format established in the initial commit (imperative summary line, bulleted details, `Co-Authored-By` trailer).
