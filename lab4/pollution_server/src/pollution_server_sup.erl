%%%-------------------------------------------------------------------
%% @doc pollution_server top level supervisor.
%% @end
%%%-------------------------------------------------------------------

-module(pollution_server_sup).

-behaviour(supervisor).

-export([start_link/0]).

-export([init/1]).

-define(SERVER, ?MODULE).

start_link() ->
    supervisor:start_link({local, ?SERVER}, ?MODULE, []).


init([]) ->
    SupFlags = #{strategy => one_for_all,
                 intensity => 2,
                 period => 2000},
    ChildSpecs = [{pollution_gen_server,
      {pollution_gen_server, start_link, []},
      permanent,
      brutal_kill,
      worker,
      [pollution_gen_server]},
      {pollution_value_collector_gen_statem,
        {pollution_value_collector_gen_statem, start_link, []},
        permanent,
        brutal_kill,
        worker,
        [pollution_value_collector_gen_statem]}],
    {ok, {SupFlags, ChildSpecs}}.

%% internal functions
