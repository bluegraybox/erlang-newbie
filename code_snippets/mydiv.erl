#!/usr/local/bin/escript
%%! -smp enable -sname mydiv

-mode(compile).  % for better performance

f(_X, 0) -> {error, "Divide by zero, dumbass."};
f(X, Y) -> {X div Y, X rem Y}.

main([Xstr, Ystr]) ->
    case string:to_integer(Xstr) of
        {error, Reason} -> io:format("Error parsing ~s: ~w~n", [Xstr, Reason]);
        {X, ""} ->
            case string:to_integer(Ystr) of
                {error, Reason} -> io:format("Error parsing Y: ~w~n", [Reason]);
                {Y, ""} ->
                    case f(X, Y) of
                        {error, Msg} -> io:format("Error: ~s~n", [Msg]);
                        {Div, Mod} -> io:format("X:~w, Y:~w, div:~w, mod:~w~n", [X, Y, Div, Mod])
                    end;
                {_Y, YRest} -> io:format("What's with the '~s' crap?~n", [YRest])
            end;
        {_X, XRest} -> io:format("What's with the '~s' crap?~n", [XRest])
    end.
