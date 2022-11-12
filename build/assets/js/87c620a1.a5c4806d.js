"use strict";(self.webpackChunkdocs=self.webpackChunkdocs||[]).push([[417],{70616:e=>{e.exports=JSON.parse('{"functions":[{"name":"GetService","desc":"Yields until that Luabased service is finished loading then returns it","params":[{"name":"Name","desc":"The services name","lua_type":"string"}],"returns":[{"desc":"The service you asked for","lua_type":"service"}],"function_type":"method","source":{"line":113,"path":"src/shared/Game/init.lua"}},{"name":"Create","desc":"Creates LuaObjects very quickly and easily","params":[{"name":"Type","desc":"the objects classname","lua_type":"string"},{"name":"...","desc":"extra stuff to shove in the .new or .bind","lua_type":"turple"}],"returns":[{"desc":"An brand new luaobject.","lua_type":"LuaObject"}],"function_type":"static","source":{"line":132,"path":"src/shared/Game/init.lua"}},{"name":"Track","desc":"Unlocks the ability to yield / resume remotely ","params":[{"name":"Script","desc":"just use script keyword","lua_type":"instance"},{"name":"Yield","desc":"True or false value determaining if it yields instantly","lua_type":"bool"}],"returns":[],"function_type":"method","source":{"line":172,"path":"src/shared/Game/init.lua"}},{"name":"Yield","desc":"Yields the script provided.(It has to be tracked with track)","params":[{"name":"Script","desc":"Script that you want to yield","lua_type":"instance"}],"returns":[],"function_type":"method","source":{"line":190,"path":"src/shared/Game/init.lua"}},{"name":"Release","desc":"Resumes the script provided.(It has to be tracked with track)","params":[{"name":"Script","desc":"Script that you want to resume","lua_type":"instance"}],"returns":[],"function_type":"method","source":{"line":207,"path":"src/shared/Game/init.lua"}},{"name":"YieldFolder","desc":"Yields the children of the instance provided.","params":[{"name":"Folder","desc":"Folder to get the children of","lua_type":"instance"}],"returns":[],"function_type":"method","source":{"line":222,"path":"src/shared/Game/init.lua"}},{"name":"ReleaseFolder","desc":"Resumes the children of the instance provided.","params":[{"name":"Folder","desc":"Instance to get the children of","lua_type":"instance"}],"returns":[],"function_type":"method","source":{"line":238,"path":"src/shared/Game/init.lua"}},{"name":"YieldFolderDeep","desc":"Yields the descendants of the instance provided.","params":[{"name":"Folder","desc":"Folder to get the descendants of","lua_type":"instance"}],"returns":[],"function_type":"method","source":{"line":254,"path":"src/shared/Game/init.lua"}},{"name":"ReleaseFolderDeep","desc":"resumes the descendants of the instance provided.","params":[{"name":"Folder","desc":"Folder to get the descendants of","lua_type":"instance"}],"returns":[],"function_type":"method","source":{"line":271,"path":"src/shared/Game/init.lua"}}],"properties":[],"types":[],"name":"Luagame","desc":"The way you access everything in the framework.\\nYou can access services and libraries and gameproperties through this example: \\n\\ngame.Workspace\\nruns getservice for the service\\n\\ngame.PlaceID\\ngives placeid\\n\\ngame.ModerationService","source":{"line":37,"path":"src/shared/Game/init.lua"}}')}}]);