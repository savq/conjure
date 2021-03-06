local _0_0 = nil
do
  local name_0_ = "conjure.client.guile.socket"
  local module_0_ = nil
  do
    local x_0_ = package.loaded[name_0_]
    if ("table" == type(x_0_)) then
      module_0_ = x_0_
    else
      module_0_ = {}
    end
  end
  module_0_["aniseed/module"] = name_0_
  module_0_["aniseed/locals"] = ((module_0_)["aniseed/locals"] or {})
  module_0_["aniseed/local-fns"] = ((module_0_)["aniseed/local-fns"] or {})
  package.loaded[name_0_] = module_0_
  _0_0 = module_0_
end
local function _1_(...)
  local ok_3f_0_, val_0_ = nil, nil
  local function _1_()
    return {require("conjure.aniseed.core"), require("conjure.client"), require("conjure.config"), require("conjure.extract"), require("conjure.log"), require("conjure.mapping"), require("conjure.aniseed.nvim"), require("conjure.remote.socket"), require("conjure.aniseed.string"), require("conjure.text")}
  end
  ok_3f_0_, val_0_ = pcall(_1_)
  if ok_3f_0_ then
    _0_0["aniseed/local-fns"] = {["require-macros"] = {["conjure.macros"] = true}, require = {a = "conjure.aniseed.core", client = "conjure.client", config = "conjure.config", extract = "conjure.extract", log = "conjure.log", mapping = "conjure.mapping", nvim = "conjure.aniseed.nvim", socket = "conjure.remote.socket", str = "conjure.aniseed.string", text = "conjure.text"}}
    return val_0_
  else
    return print(val_0_)
  end
end
local _local_0_ = _1_(...)
local a = _local_0_[1]
local text = _local_0_[10]
local client = _local_0_[2]
local config = _local_0_[3]
local extract = _local_0_[4]
local log = _local_0_[5]
local mapping = _local_0_[6]
local nvim = _local_0_[7]
local socket = _local_0_[8]
local str = _local_0_[9]
local _2amodule_2a = _0_0
local _2amodule_name_2a = "conjure.client.guile.socket"
do local _ = ({nil, _0_0, {{nil}, nil, nil, nil}})[2] end
config.merge({client = {guile = {socket = {mapping = {connect = "cc", disconnect = "cd"}, pipename = nil}}}})
local cfg = nil
do
  local v_0_ = config["get-in-fn"]({"client", "guile", "socket"})
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["cfg"] = v_0_
  cfg = v_0_
end
local state = nil
do
  local v_0_ = nil
  local function _2_()
    return {repl = nil}
  end
  v_0_ = (((_0_0)["aniseed/locals"]).state or client["new-state"](_2_))
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["state"] = v_0_
  state = v_0_
end
local buf_suffix = nil
do
  local v_0_ = nil
  do
    local v_0_0 = ".scm"
    _0_0["buf-suffix"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["buf-suffix"] = v_0_
  buf_suffix = v_0_
end
local comment_prefix = nil
do
  local v_0_ = nil
  do
    local v_0_0 = "; "
    _0_0["comment-prefix"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["comment-prefix"] = v_0_
  comment_prefix = v_0_
end
local context_pattern = nil
do
  local v_0_ = nil
  do
    local v_0_0 = "%(define%-module%s+(%([%g%s]-%))"
    _0_0["context-pattern"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["context-pattern"] = v_0_
  context_pattern = v_0_
end
local with_repl_or_warn = nil
do
  local v_0_ = nil
  local function with_repl_or_warn0(f, opts)
    local repl = state("repl")
    if (repl and ("connected" == repl.status)) then
      return f(repl)
    else
      return log.append({(comment_prefix .. "No REPL running")})
    end
  end
  v_0_ = with_repl_or_warn0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["with-repl-or-warn"] = v_0_
  with_repl_or_warn = v_0_
end
local format_message = nil
do
  local v_0_ = nil
  local function format_message0(msg)
    if msg.out then
      return text["split-lines"](msg.out)
    elseif msg.err then
      return text["prefixed-lines"](string.gsub(msg.err, "%s*Entering a new prompt%. .*]>%s*", ""), comment_prefix)
    else
      return {(comment_prefix .. "Empty result")}
    end
  end
  v_0_ = format_message0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["format-message"] = v_0_
  format_message = v_0_
end
local display_result = nil
do
  local v_0_ = nil
  local function display_result0(msg)
    local function _2_(_241)
      return ("" ~= _241)
    end
    return log.append(a.filter(_2_, format_message(msg)))
  end
  v_0_ = display_result0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["display-result"] = v_0_
  display_result = v_0_
end
local eval_str = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function eval_str0(opts)
      local function _2_(repl)
        local function _3_(msgs)
          if ((1 == a.count(msgs)) and ("" == a["get-in"](msgs, {1, "out"}))) then
            a["assoc-in"](msgs, {1, "out"}, (comment_prefix .. "Empty result"))
          end
          opts["on-result"](str.join("\n", format_message(a.last(msgs))))
          return a["run!"](display_result, msgs)
        end
        return repl.send(opts.code, _3_, {["batch?"] = true})
      end
      return with_repl_or_warn(_2_)
    end
    v_0_0 = eval_str0
    _0_0["eval-str"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["eval-str"] = v_0_
  eval_str = v_0_
end
local eval_file = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function eval_file0(opts)
      return eval_str(a.assoc(opts, "code", ("(load \"" .. opts["file-path"] .. "\")")))
    end
    v_0_0 = eval_file0
    _0_0["eval-file"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["eval-file"] = v_0_
  eval_file = v_0_
end
local doc_str = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function doc_str0(opts)
      local function _2_(_241)
        return ("(procedure-documentation " .. _241 .. ")")
      end
      return eval_str(a.update(opts, "code", _2_))
    end
    v_0_0 = doc_str0
    _0_0["doc-str"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["doc-str"] = v_0_
  doc_str = v_0_
end
local display_repl_status = nil
do
  local v_0_ = nil
  local function display_repl_status0()
    local repl = state("repl")
    if repl then
      local _2_
      do
        local pipename = a["get-in"](repl, {"opts", "pipename"})
        if pipename then
          _2_ = (pipename .. " ")
        else
          _2_ = ""
        end
      end
      local _3_
      do
        local err = a.get(repl, "err")
        if err then
          _3_ = (" " .. err)
        else
          _3_ = ""
        end
      end
      return log.append({(comment_prefix .. _2_ .. "(" .. repl.status .. _3_ .. ")")}, {["break?"] = true})
    end
  end
  v_0_ = display_repl_status0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["display-repl-status"] = v_0_
  display_repl_status = v_0_
end
local disconnect = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function disconnect0()
      local repl = state("repl")
      if repl then
        repl.destroy()
        a.assoc(repl, "status", "disconnected")
        display_repl_status()
        return a.assoc(state(), "repl", nil)
      end
    end
    v_0_0 = disconnect0
    _0_0["disconnect"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["disconnect"] = v_0_
  disconnect = v_0_
end
local parse_guile_result = nil
do
  local v_0_ = nil
  local function parse_guile_result0(s)
    if s:find("scheme@%([%w%-%s]+%)> ") then
      local ind1, ind2, result = s:find("%$%d+ = ([^\n]+)\n")
      return {["done?"] = true, ["error?"] = false, result = result}
    else
      if s:find("scheme@%([%w%-%s]+%) %[%d+%]>") then
        return {["done?"] = true, ["error?"] = true, result = nil}
      else
        return {["done?"] = false, ["error?"] = false, result = s}
      end
    end
  end
  v_0_ = parse_guile_result0
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["parse-guile-result"] = v_0_
  parse_guile_result = v_0_
end
local enter = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function enter0()
      local repl = state("repl")
      local c = extract.context()
      if (repl and ("connected" == repl.status)) then
        local function _2_()
        end
        return repl.send((",m " .. (c or "(guile-user)") .. "\n"), _2_)
      end
    end
    v_0_0 = enter0
    _0_0["enter"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["enter"] = v_0_
  enter = v_0_
end
local connect = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function connect0(opts)
      disconnect()
      local pipename = (cfg({"pipename"}) or a.get(opts, "port"))
      if ("string" ~= type(pipename)) then
        return log.append({(comment_prefix .. "g:conjure#client#guile#socket#pipename is not specified"), (comment_prefix .. "Please set it to the name of your Guile REPL pipe or pass it to :ConjureConnect [pipename]")})
      else
        local function _2_(msg, repl)
          display_result(msg)
          local function _3_()
          end
          return repl.send(",q\n", _3_)
        end
        local function _3_()
          display_repl_status()
          return enter()
        end
        return a.assoc(state(), "repl", socket.start({["on-close"] = disconnect, ["on-error"] = _2_, ["on-failure"] = disconnect, ["on-stray-output"] = display_result, ["on-success"] = _3_, ["parse-output"] = parse_guile_result, pipename = pipename}))
      end
    end
    v_0_0 = connect0
    _0_0["connect"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["connect"] = v_0_
  connect = v_0_
end
local on_load = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function on_load0()
      do
        nvim.ex.augroup("conjure-guile-socket-bufenter")
        nvim.ex.autocmd_()
        nvim.ex.autocmd("BufEnter", ("*" .. buf_suffix), ("lua require('" .. _2amodule_name_2a .. "')['" .. "enter" .. "']()"))
        nvim.ex.augroup("END")
      end
      return connect()
    end
    v_0_0 = on_load0
    _0_0["on-load"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["on-load"] = v_0_
  on_load = v_0_
end
local on_filetype = nil
do
  local v_0_ = nil
  do
    local v_0_0 = nil
    local function on_filetype0()
      mapping.buf("n", "GuileConnect", cfg({"mapping", "connect"}), _2amodule_name_2a, "connect")
      return mapping.buf("n", "GuileDisconnect", cfg({"mapping", "disconnect"}), _2amodule_name_2a, "disconnect")
    end
    v_0_0 = on_filetype0
    _0_0["on-filetype"] = v_0_0
    v_0_ = v_0_0
  end
  local t_0_ = (_0_0)["aniseed/locals"]
  t_0_["on-filetype"] = v_0_
  on_filetype = v_0_
end
return nil