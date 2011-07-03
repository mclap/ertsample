all: deps compile doc

deps:
	rebar get-deps

compile:
	rebar compile

doc:
	rebar skip_deps=true doc

clean:
	rebar clean

distclean: clean
	rebar delete-deps

update:
	rebar update-deps