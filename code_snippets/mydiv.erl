#!/usr/local/bin/escript
%%! -smp enable -sname mydiv

-mode(compile).  % for better performance

mydiv(_X, 0) -> {error, "Divide by zero, dumbass."};
mydiv(X, Y) -> {X div Y, X rem Y}.

main([Xstr, Ystr]) ->
    parseInt(Xstr, fun (X) ->
        parseInt(Ystr, fun (Y) ->
            display(X, Y)
        end)
    end).

display(X, Y) ->
    case mydiv(X, Y) of
        {error, Msg} ->
            io:format("Error: ~s~n", [Msg]);
        {Div, Mod} ->
            io:format("X:~w, Y:~w, div:~w, mod:~w~n", [X, Y, Div, Mod])
    end.

parseInt(IntStr, Success) ->
    case string:to_integer(IntStr) of
        {error, Reason} ->
            io:format("Error parsing ~s: ~w~n", [IntStr, Reason]);
        {Val, ""} ->
            Success(Val);
        {Val, Rest} ->
            io:format("What's with the '~s' crap?~n", [Rest]),
            Success(Val)
    end.
