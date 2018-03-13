" We postpone the  loading of some plugins or some  of their configuration after
" 1s has elapsed.
augroup lazy_load_plugins
    au!
    au VimEnter * call timer_start(1000, {->  execute('runtime  autoload/toggle_settings.vim
    \|                                                 runtime! autoload/plugin_conf/lazy_load/*.vim', '')
    \                                    })
    \|            exe 'au! lazy_load_plugins'
    \|            aug! lazy_load_plugins
augroup END
