# dotfiles

## Setup

1. このリポジトリ clone
2. `./scripts/bootstrap.sh` を実行
3. `source ~/.zshrc` を実行

`~/.zshrc` と `~/.config/starship.toml` のリンクを作成し、依存ツールのインストールスクリプトを実行

ターミナルは `MesloLGS Nerd Font` を使用

## Structure

- `scripts/`: bootstrap と install 用のスクリプト
- `zsh/`: Zsh 設定
- `**/`: ツール別の設定
- `starship/`: Starship のテーマ/設定

## Guidelines

- 設定はツール単位または役割単位でまとめる
  - ツール名をフォルダ名に採用
- シェル設定は小さく役割の明確なファイルに分割
- 再利用できるセットアップ処理は `scripts/` に配置
- シークレットや端末固有の個人データのコミットは厳禁
