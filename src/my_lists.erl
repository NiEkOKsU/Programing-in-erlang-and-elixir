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
-export([contains/2]).

contains ([], _El) -> false;
contains([El|_], El) -> true;
contains([_H|T], El) -> contains(T, El).