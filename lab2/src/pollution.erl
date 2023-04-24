%%%-------------------------------------------------------------------
%%% @author proks
%%% @copyright (C) 2023, <COMPANY>
%%% @doc
%%%
%%% @end
%%% Created : 19. mar 2023 13:41
%%%-------------------------------------------------------------------
-module(pollution).


%% API
-export([create_monitor/0, add_station/3, add_value/5, get_one_value/4, get_station_mean/3, remove_value/4, get_daily_mean/3, get_daily_average_data_count/1]).

create_monitor() -> #{}.

name_filter(Name, Keys) ->
  Cmp = fun({{Key, _}, Val}) when Key == Val -> true; (_) -> false end,
  PairsList = [{X, Y} || X <- Keys, Y <- [Name]],
  lists:filter(Cmp, PairsList).

coord_filter(Coords, Keys) ->
  Cmp = fun({{_, Key}, Val}) when Key == Val -> true; (_) -> false end,
  PairsList = [{X, Y} || X <- Keys, Y <- [Coords]],
  lists:filter(Cmp, PairsList).

param_filter(Data, Type, List) ->
  Cmp = fun({{D, T}, {D2, T2, _}}) when D == D2, T == T2 -> false; (_) -> true end,
  PairsList = [{{D, T},{D2, T2, V}} || D <- [Data], T <- [Type], {D2, T2, V} <- List],
  Filtred = lists:filter(Cmp, PairsList),
  ToRet = [Vals || {_, Vals} <- Filtred],
  ToRet.

unique(List) ->
  Set = sets:from_list(List),
  sets:to_list(Set).

add_station(Name, {N, W}, M) when is_number(N), is_number(W), is_list(Name) ->
  Keys = maps:keys(M),
  Filtred_name = name_filter(Name, Keys),
  Filtred_coordinates = coord_filter({N, W}, Keys),
  if
    length(Filtred_name) > 0 -> io:format("Stacja o podanej nazwie juz istnieje \n");
    length(Filtred_coordinates) > 0 -> io:format("Stacja o podanych wspolrzednych juz istnieje \n");
    true -> M#{{Name, {N, W}} => []}
  end.

add_value(Name, Data, Type, Value, M) when is_list(Name), is_list(Type), is_number(Value) ->
  [{Key, _} | _] = name_filter(Name, maps:keys(M)),
  #{Key := Val} = M,
  FiltredVal = [{A,B,C} || {A,B,C} <- Val, A == Data, B == Type],
  if
    length(FiltredVal) > 0 -> io:format("Nie mozna dodac takiego pomiaru \n");
    true -> M#{Key := Val ++ [{Data, Type, Value}]}
  end;
add_value(Tuple, Data, Type, Value, M) when is_list(Type), is_number(Value) ->
  [{Key, _} | _] = coord_filter(Tuple, maps:keys(M)),
  #{Key := Val} = M,
  FiltredVal = [{A,B,C} || {A,B,C} <- Val, A == Data, B == Type],
  if
    length(FiltredVal) > 0 -> io:format("Nie mozna dodac takiego pomiaru \n");
    true -> M#{Key := Val ++ [{Data, Type, Value}]}
  end.

remove_value(Name, Data, Type, M) when is_list(Name), is_list(Type) ->
  [{Key, _} | _] = name_filter(Name, maps:keys(M)),
  #{Key := Val} = M,
  FiltredVal = param_filter(Data, Type, Val),
  M#{Key := FiltredVal};
remove_value(Tuple, Data, Type, M) when is_list(Type) ->
  [{Key, _} | _] = coord_filter(Tuple, maps:keys(M)),
  #{Key := Val} = M,
  FiltredVal = param_filter(Data, Type, Val),
  M#{Key := FiltredVal}.

get_one_value(Name, Data, Type, M) when is_list(Name), is_list(Type) ->
  [{Key, _} | _] = name_filter(Name, maps:keys(M)),
  #{Key := Val} = M,
  FiltredVal = [{A,B,C} || {A,B,C} <- Val, A == Data, B == Type],
  [{_,_,ToRet} | _] = FiltredVal,
  ToRet;
get_one_value(Tuple, Data, Type, M) when is_list(Type) ->
  [{Key, _} | _] = coord_filter(Tuple, maps:keys(M)),
  #{Key := Val} = M,
  FiltredVal = [{A,B,C} || {A,B,C} <- Val, A == Data, B == Type],
  [{_,_,ToRet} | _] = FiltredVal,
  ToRet.

get_station_mean(Name, Type, M) when is_list(Name), is_list(Type) ->
  [{Key, _} | _] = name_filter(Name, maps:keys(M)),
  #{Key := Val} = M,
  FiltredVal = [C || {_,B,C} <- Val, B == Type],
  Sum = lists:foldl(fun (X,Y) -> X + Y end, 0, FiltredVal),
  if
    length(FiltredVal) == 0 -> io:format("Nie ma wartości z podanego zakresu");
    true -> Sum / length(FiltredVal)
  end;
get_station_mean(Tuple, Type, M) when is_list(Type) ->
  [{Key, _} | _] = coord_filter(Tuple, maps:keys(M)),
  #{Key := Val} = M,
  FiltredVal = [C || {_,B,C} <- Val, B == Type],
  Sum = lists:foldl(fun (X,Y) -> X + Y end, 0, FiltredVal),
  if
    length(FiltredVal) == 0 -> io:format("Nie ma wartości z podanego zakresu");
    true -> Sum / length(FiltredVal)
  end.

get_daily_mean(Date, Type, M) ->
  Concate = maps:fold(fun(_,V, Acc) -> Acc ++ V end, [], M),
  Cmp = fun ({{{D, _}, T, _}, D2, T2}) when D == D2, T == T2 -> true; (_) -> false end,
  Filtred = lists:filter(Cmp, [{Conc, D, T} || Conc <- Concate, D <- [Date], T <- [Type]]),
  ValuesList = [Values ||{{_,_,Values},_,_} <- Filtred],
  if
    length(ValuesList) == 0 -> io:format("Nie ma wartości z podanego zakresu");
    true -> lists:foldl(fun (X,Y) -> X + Y end, 0, ValuesList) / length(ValuesList)
  end.

daily_avg_per_station([], _) -> 0;
daily_avg_per_station([H|T], M) ->
  #{H := Values} = M,
  Dates = [{D, {0,0,0}} || {{D, _}, _, _} <- Values],
  UniqueDates = unique(Dates),
  TimeDIffFun=fun([X,Y]) -> {Val, _} = calendar:time_difference(X, Y), Val end,
  DatesPairs = [[X, Y] || X <- UniqueDates, Y <- UniqueDates],
  MaxVal = lists:max(lists:map(TimeDIffFun, DatesPairs)) + 1,
  Summ = length(Values),
  (Summ / MaxVal) + daily_avg_per_station(T, M).

get_daily_average_data_count(M) ->
  Keys = maps:keys(M),
  SumOfAvgsPerStation = daily_avg_per_station(Keys, M),
  SumOfAvgsPerStation / length(Keys).