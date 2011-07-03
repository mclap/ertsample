-module(ertsample_keeper_chains).
-export([delmin/1, delmin/2]).
-import(lists).

%% [ {L, [ITEMS]}, ... ]
%%

%delmin(ListOfLists) ->
%	Lengths=lists:map(fun(S) -> element(1,S) end, ListOfLists),
%	MinLength=lists:min(Lengths),
%	MinLength.

% h:delmin([{2,[1,2]}, {1,[99]}, {3,[2,3,4]}]).

%54> h:delmin([{2,[1,2]}, {1,[99]}, {3,[2,3,4]}, {1,[42]}]).
%deleting 1
%[{2,[1,2]},{3,[2,3,4]},{1,"*"}]


%% remove smallest item from the head
removehead(ListOfLists,_,0) ->
	ListOfLists;
removehead([Head|Tail],MinLen,Count) ->
	if element(1,Head) > MinLen ->
		[Head|removehead(Tail,MinLen,Count)];
	true ->
		%io:format("deleting ~w~n", [element(1,Head)]),
		removehead(Tail,MinLen,Count-1)
	end.

%% @doc remove smallest item from the tail
removetail([Tail],MinLen) ->
	case element(1, Tail) > MinLen of 
		true -> [Tail];
		false -> []
	end;
removetail([Head|Tail],MinLen) ->
	FTail=removetail(Tail,MinLen),
	case length(FTail)==length(Tail) of
		true -> removetail([Head],MinLen) ++ Tail;
		false -> [Head | FTail]
	end.

%% @doc delete smallest list
delmin_single(ListOfLists, MinLength, fromtail) ->
	removetail(ListOfLists, MinLength);
delmin_single(ListOfLists, MinLength, fromhead) ->
	removehead(ListOfLists, MinLength,1).

% thing_to_list(X) when is_atom(X)    -> atom_to_list(X);

%% @doc Delete one list with minimal sice from the head or tail.
%% Direction ::= fromhead | fromtail
delmin(ListOfLists,Direction) when is_atom(Direction) ->
	Lengths=lists:map(fun(S) -> element(1,S) end, ListOfLists),
	MinLength=lists:min(Lengths),
	delmin_single(ListOfLists,MinLength,Direction).

%% @doc Delete one list with minimal sice from the tail only
delmin(ListOfLists) ->
	delmin(ListOfLists, fromtail).
