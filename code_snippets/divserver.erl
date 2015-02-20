#!/usr/local/bin/escript
%%! -smp enable -sname divserver

main([]) ->
    spawn(divsvc, supervisor, []),
    io:get_line("Return to exit...").
