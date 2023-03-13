%%%-------------------------------------------------------------------
%%% @author proks
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 28. lut 2023 15:59
%%%-------------------------------------------------------------------
-module(my_first_module).

%% API
-export([mojapierwszafunkcja/0, f1/1, factorial/1, power / 2]).


mojapierwszafunkcja () -> 23 + mojadrugafunkcja().

mojadrugafunkcja () -> 34.

f1 (Z) -> Z ++ Z.

factorial (1) -> 1;
factorial (V) -> V * factorial(V-1).

power (_, 0) -> 1;
power (A, 1) -> A;
power (A, B) -> A * power(A, B - 1).