%%%-------------------------------------------------------------------
%%% @author proks
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. lut 2023 16:22
%%%-------------------------------------------------------------------
-module(my_lists).


%% API
-export([contains/2, duplicateElements/1, sumFloats/1, sumFloats2/1]).

contains ([], _El) -> false;
contains([El|_], El) -> true;
contains([_H|T], El) -> contains(T, El).

duplicateElements([T | []]) -> [T | [T]];
duplicateElements([T | H]) -> [T | [T | duplicateElements(H)]].

sumFloats([H | []]) -> H;
sumFloats([H | T]) -> H + sumFloats(T).

sumFloats2(Tab) -> sumFloats2(0, Tab).
sumFloats2(Acc, [H | []]) -> Acc + H;
sumFloats2(Acc, [H | T]) -> sumFloats2(Acc + H, T).