TODO: This directory is a mess. Reorganize it.

Current layout:

        .
        ├── ./my-completions/
        │   ├── ./my-completions/_ccheat
        │   ├── ./my-completions/_cheat
        │   ├── ./my-completions/file
        │   ├── ./my-completions/_mcheat
        │   ├── ./my-completions/README
        │   ├── ./my-completions/_srr
        │   └── ./my-completions/_vc
        ├── ./plugins/
        │   ├── ./plugins/zaw/
        │   ├── ./plugins/zsh-interactive-cd/
        │   └── ./plugins/zsh-syntax-highlighting/
        ├── ./zsh-completions/
        │   ├── ./zsh-completions/.git/
        │   ├── ./zsh-completions/src/
        │   ├── ./zsh-completions/.editorconfig
        │   ├── ./zsh-completions/.gitignore
        │   ├── ./zsh-completions/LICENSE
        │   ├── ./zsh-completions/README.md
        │   ├── ./zsh-completions/zsh-completions-howto.org
        │   └── ./zsh-completions/zsh-completions.plugin.zsh
        └── ./README.md

TODO:

From our `.zshrc`, find  a way to clone the plugins if  they're missing, like we
do in `.vim/vimrc` with `vim-plug`.
Atm, we use the following plugins:

   * zaw
   * zsh-interactive-cd
   * zsh-syntax-highlighting
   * zsh-completions

They're not versioned here.
