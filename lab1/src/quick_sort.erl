%%%-------------------------------------------------------------------
%%% @author proks
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 14. mar 2023 15:21
%%%-------------------------------------------------------------------
-module(quick_sort).

%% API
-export([less_than/2, grt_eq_than/2, qs/1, random_elems/3, compare_speeds/3]).

less_than(List, Arg) -> [X || X<-List, X < Arg].

grt_eq_than(List, Arg) -> [X || X<-List, X >= Arg].

qs([]) -> [];
qs([Pivot|Tail]) -> qs( less_than(Tail,Pivot) ) ++ [Pivot] ++ qs( grt_eq_than(Tail,Pivot) ).

random_elems(N,Min,Max)-> [rand:uniform(Max - Min) + Min || _<-lists:seq(1,N)].

compare_speeds(List, Fun1, Fun2) ->
  {Time1, _} = timer:tc(Fun1, [List]),
  {Time2, _} = timer:tc(Fun2, [List]),
  io:format("~w", [Time1]),
  io:format("\n"),
  io:format("~w", [Time2]).