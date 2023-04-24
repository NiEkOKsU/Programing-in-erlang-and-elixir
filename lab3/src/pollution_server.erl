-module(pollution_server).
%% API
-export([start/0, stop/0, init/0]).
-export([add_station/2, add_value/4, remove_value/3, get_one_value/3, get_station_mean/2, get_daily_mean/2, get_daily_average_data_count/0]).

start() ->
  PID = spawn(?MODULE, init, []),
  register (pollutionServer, PID).
init() ->
  loop(pollution:create_monitor()).

loop(Monitor) ->
  receive
    {request, Pid, add_station, Name, Coords} ->
      NewMonitor = pollution:add_station(Name, Coords, Monitor),
      Pid ! {reply, NewMonitor},
      loop(NewMonitor);
    {request, Pid, add_value, Name, Data, Type, Value} ->
      NewMonitor = pollution:add_value(Name, Data, Type, Value, Monitor),
      Pid ! {reply, NewMonitor},
      loop(NewMonitor);
    {request, Pid, remove_value, Name,Data, Type} ->
      NewMonitor = pollution:remove_value(Name,Data, Type, Monitor),
      Pid ! {reply, NewMonitor},
      loop(NewMonitor);
    {request, Pid, get_one_value, Name,Data, Type} ->
      Value = pollution:get_one_value(Name,Data, Type, Monitor),
      Pid ! {reply, Value},
      loop(Monitor);
    {request, Pid, get_station_mean, Name, Type} ->
      Avg = pollution:get_station_mean(Name, Type, Monitor),
      Pid ! {reply, Avg},
      loop(Monitor);
    {request, Pid, get_daily_mean, Date, Type} ->
      Avg = pollution:get_daily_mean(Date, Type, Monitor),
      Pid ! {reply, Avg},
      loop(Monitor);
    {request, Pid, get_daily_average_data_count} ->
      Avg = pollution:get_daily_average_data_count(Monitor),
      Pid ! {reply, Avg},
      loop(Monitor);
    {request, Pid, stop} ->
      Pid ! {reply, ok}
  end.

call(Message) ->
  pollutionServer ! {request, self(), Message},
  receive
    {reply, Reply} -> Reply
  end.
call(Message, Arg1, Arg2) ->
  pollutionServer ! {request, self(), Message, Arg1, Arg2},
  receive
    {reply, Reply} -> Reply
  end.
call(Message, Arg1, Arg2, Arg3) ->
  pollutionServer ! {request, self(), Message, Arg1, Arg2, Arg3},
  receive
    {reply, Reply} -> Reply
  end.
call(Message, Arg1, Arg2, Arg3, Arg4) ->
  pollutionServer ! {request, self(), Message, Arg1, Arg2, Arg3, Arg4},
  receive
    {reply, Reply} -> Reply
  end.

add_station(Name, Coords) -> call(add_station,Name, Coords).
add_value(Name,Data, Type, Value) -> call(add_value, Name, Data, Type, Value).
remove_value(Name,Data, Type) -> call(remove_value,Name,Data, Type).
get_one_value(Name,Data, Type) -> call(get_one_value,Name,Data, Type).
get_station_mean(Name, Type) -> call(get_station_mean,Name, Type).
get_daily_mean(Date, Type) -> call(get_daily_mean,Date, Type).
get_daily_average_data_count() -> call(get_daily_average_data_count).
stop() -> call(stop).
