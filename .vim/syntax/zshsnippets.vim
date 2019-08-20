if exists('b:current_syntax')
    finish
endif

syn match zshSnippetsComment /§.*/

hi link zshSnippetsComment Comment

let b:current_syntax = 'zshsnippets'
