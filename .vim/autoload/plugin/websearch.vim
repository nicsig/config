vim9script noclear

def plugin#websearch#main()
    # Double quotes can break `xdg-open(1)`.{{{
    #
    #     $ xdg-open 'https://www.startpage.com/do/search?query="foo bar"'
    #
    # `xdg-open(1)`  starts  a  second  web browser  window,  in  which one  tab
    # searches for `foo`, and another tab points to this url: https://www.bar.com/
    #
    # I think the issue is due to the space inside the double quotes.
    # For the moment, I don't care about double quotes being preserved in the search.
    # I care about the search being  more predictable, even when it contains special
    # characters.
    #}}}
    var query: string = getline('.')->substitute('"', '', 'g')
    # An ampersand can truncate the query.{{{
    #
    #     $ xdg-open 'https://www.startpage.com/do/search?query=foo & bar'
    #
    # The browser correctly opens this url:
    #
    #     https://www.startpage.com/do/search?query=foo & bar
    #
    # But the search engine (startpage atm) only searches `foo`.
    #}}}
    query = substitute(query, '&', '%26', 'g')
    # same issue with an equal sign
    query = substitute(query, '=', '%3d', 'g')
    sil system('xdg-open ' .. shellescape(b:url .. query))
    q!
enddef
