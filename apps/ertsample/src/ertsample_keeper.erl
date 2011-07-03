-module(ertsample_keeper).
-export([emit/1, getall/0, clearall/0]).
-import(ertsample_keeper_chains).
-define(LIMIT, 2).

getcur() ->
	case get(last) of 
	undefined -> [];
	C -> C
	end.

addchain(undefined, Insert) ->
	put(chains, [Insert]);
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

emit(V) ->
	emit_internal(V, getcur()),
	[{last, getcur()}, {all, getall()}].

getall() ->
	get(chains).

clearall() ->
	put(chains, undefined),
	put(last, undefined).
