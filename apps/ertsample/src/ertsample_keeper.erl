-module(ertsample_keeper).
-behaviour(gen_event).

-export([emit/1, getall/0, clearall/0]).
-export([start_link/0, init/1, handle_event/2, code_change/3]).
-import(ertsample_keeper_chains).
-define(LIMIT, 2).

getcur() ->
	case get(last) of 
	undefined -> [];
	C -> C
	end.

addchain(Chains, Insert) when length(Chains) < ?LIMIT ->
	put(chains, [Insert | Chains]);
addchain(Chains, Insert) ->
	put(chains, ertsample_keeper_chains:delmin([Insert | Chains])).

addchain(L) ->
	Insert={length(L),L},
	addchain(getall(), Insert).

emit_internal(V, []) ->
	_=put(last, [V]);

emit_internal(V, Current) ->
	[Head|_] = Current,
	if Head < V ->
		% new value to the chain
		_=put(last, [V|Current]);
	true ->
		% chain is over
		addchain(Current),
		_=put(last, [V])
	end.

%% @doc emit single value to the keeper
emit(V) ->
	emit_internal(V, getcur()),
	[{last, getcur()}, {all, getall()}].

%% @doc get all values
getall() ->
	case get(chains) of 
	undefined -> [];
	C -> C
	end.

%% @doc reset the values
clearall() ->
	put(chains, undefined),
	put(last, undefined).

start_link() ->
	gen_server:start_link({local, ertsample_keeper}, ertsample_keeper, [], []).

init(_Args) ->
	{ok, none}.

handle_event({emit, Value}, _From) ->
	{ok, emit(Value)};

handle_event({getall}, _From) ->
	{ok, getall()};

handle_event({clearall}, _From) ->
	{ok, clearall()}.

code_change(_OldVsn, _State, _Extra) ->
	{ok, _State}.
