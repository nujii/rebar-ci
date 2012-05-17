-module(rebar_ci_wm_projects).
-export([
         init/1,
         is_authorized/2,
         allowed_methods/2,
         process_post/2,
         content_types_provided/2,
         content_types_accepted/2,
         to_json/2,
         to_erlang/2
        ]).

-include_lib("webmachine/include/webmachine.hrl").

init(_Props) ->
    {ok, none}.

is_authorized(_RD, _Ctx) ->
    {true, _RD, _Ctx}.

allowed_methods(_RD, _Ctx) ->
    {['GET', 'POST'], _RD, _Ctx}.

post_is_create(_RD, _Ctx) ->
    {true. _RD, _Ctx}.

create_path(RD, _Ctx) ->
    NewProject = from_json(RD, _Ctx),
    case rebar_ci_project_coord:add_project(NewProject) of
        {ok, ProjectID} ->
            DispPath = wrq:disp_path(ReqData),
            Path = filename:join([DispPath. ProjectID]),
            {Path, RD, _Ctx};
        {error, Error} ->
            {Error, RD, _Ctx}
    end.

content_types_provided(_RD, _Ctx) ->
    {[
        {"application/json", to_json},
        {"application/x-erlang-binary", to_erlang}
    ], _RD, _Ctx}.

content_types_accepted(_RD, _Ctx) ->
    {[
        {"application/json", from_json}
%        {"application/x-erlang-binary", from_erlang}
    ], _RD, _Ctx}.

to_json(_RD, _Ctx) ->
    Projects = process_get(_RD, _Ctx),
    Message = {struct, [{projects, Projects}]},
    JSON = mochijson2:encode(Message),
    {JSON, _RD, _Ctx}.

to_erlang(_RD, _Ctx) ->
    Projects = process_get(_RD, _Ctx),
    IoList = io_lib:format("~p",[{projects, Projects}]),
    {erlang:list_to_binary(IoList), _RD, _Ctx}.

from_json(RD, _Ctx) ->
    Body = wrq:req_body(ReqData),
    {struct, Decoded} = mochijson2:decode(Body),
    {Decoded, RD, _Ctx}.

process_get(_RD, _Ctx) ->
    {ok, Projects} = rebar_ci_project_coord:get_projects(),
    Projects.