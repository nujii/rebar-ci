Rebar-CI: The Opinionated Continuous Integration Server for Erlang
==================================================================

Rebar-CI aims to do the following

* Integrate the language and build system
* Easy release management
* Simple API
* Distributed
* Test mulitple environments

In order to acheive these goals, Rebar-CI uses the very opinionated build tool, [rebar](https://github.com/basho/rebar).

Let's get started
-----------------

Prereqs

* Erlang R14B4 or higher
* make
* more to come...

Start by cloning the repository
	
	git clone git://github.com/nujii/rebar-ci.git

Now build it

	cd rebar-ci
	make && make rel

Now start it!

	./rel/rebar-ci/bin/rebar-ci start

Open up http://localhost:8048

