let b:did_ftplugin = 1

" to be able to make a search from several Vim instances
setl noswf

" to avoid polluting the buffer list
setl bh=wipe nobl

setl nowrap

setl cul

let &l:stl = '%!g:statusline_winid == win_getid() ? "%y%=%l " : "%y"'

nno <buffer><expr><nowait><silent> q reg_recording() != '' ? 'q' : ':<c-u>q!<cr>'
" Why `command-prompt`?  Why not running the command directly (`system('tmux ' .. getline('.'))`)?{{{
"
" First, it lets you review the command before it's run.
" So you  can check that tmux  will indeed run  what you've written in  your Vim
" buffer, and that nothing (Vim, shell) interfered.
"
" Besides, if you run the command directly, the result may not be the one you expect.
" For example, write this in your `tmuxprompt` buffer:
"
"     display '#{mouse_any_flag}'
"
" And press Enter.
" If you run the command directly, the output will be 0.
" But if you run the command on tmux command prompt, the output is 1.
"
" ---
"
" Another example of unexpected output:
"
"     foo
"
" This should output:
"
"     Unknown command: foo
"
" But it doesn't output anything, because `system()` only outputs tmux's stdout,
" not stderr.
"
" ---
"
" And this:
"
"     if true { display 'test' }
"
" should output `test`.
" But in Vim, it raises an error:
"
"     :call system('tmux if true {display test}')
"     E484: Can't open file /tmp/vyr65Lg/73~
"
" This is probably because the braces are  interpreted by the shell, so you need
" to quote them:
"
"     :call system('tmux if true "{display test}"')
"
" But this still fails, because using tmux braces from the shell is tricky.
" See our notes in the format.md file of the tmux wiki.
" You need to add an extra `if -F 1`:
"
"     :call system('tmux if true "if -F 1 {display test}"')
"
" And all of this is just for a simple command with just one pair of braces.
" Imagine the kind  of transformation we would need to apply  for a more complex
" command...
"}}}
" Why `job_start()`?  Why not `system()`?{{{
"
" To avoid starting a shell, which would require escaping some characters:
"
"     :<c-u>sil system('tmux command-prompt -I '
"         \ .. getline('.')->substitute('#', '##', 'g')->shellescape())<cr>
"         "                                              ^-----------^
"}}}
" Why do you double the number signs?  Why don't you use `#{l:}` instead?{{{
"
" It wouldn't work if the current line contains braces:
"
"     $ tmux command-prompt -I "#{l:{a} {b}}"
"     {a {b}}~
"           ^
"           ✘
"}}}
nno <buffer><nowait><silent> <cr>
    \ :<c-u>call job_start([
    \     'tmux',
    \     'command-prompt',
    \     '-I',
    \     getline('.')->substitute('#', '##', 'g')
    \ ])<cr>

nmap <buffer><nowait><silent> ZZ <cr>

" Teardown {{{1

let b:undo_ftplugin = get(b:, 'undo_ftplugin', 'exe')
    \ .. '| call tmuxprompt#undo_ftplugin()'

