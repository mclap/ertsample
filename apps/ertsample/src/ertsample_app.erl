-module(ertsample_app).

-behaviour(application).

%% Application callbacks
-export([start/2, stop/1]).

%% ===================================================================
%% Application callbacks
%% ===================================================================

start(_StartType, StartArgs) ->
	case ertsample_sup:start_link(StartArgs) of
		{ok, Pid} -> {ok, Pid};
		Error -> Error
	end.

stop(_State) ->
    ok.
