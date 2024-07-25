local pandoc = require 'pandoc'
local List   = require 'pandoc.List'

local function fill_reftargets (reftargets)
  return  {
    traverse = 'topdown',
    Figure = function (fig)
      if fig.identifier ~= '' then
        reftargets.figures:insert(fig.identifier)
      end
    end,
    Table = function (tbl)
      if tbl.identifier ~= '' then
        reftargets.tables:insert(tbl.identifier)
      end
    end
  }
end

local function set_link_contents (reftargets)
  local refnums = {}
  local function setrefnums (id, i) rawset(refnums, '#'..id, pandoc.Str(i)) end
  reftargets.tables:map(setrefnums)
  reftargets.figures:map(setrefnums)
  return {
    Link = function (link)
      print(link.target)
      if not next (link.content) then
        link.content = refnums[link.target] or link.content
        return link
      end
    end
  }
end

return {{
    Pandoc = function (doc)
      local reftargets = {
        figures = List{},
        tables  = List{},
      }
      doc:walk(fill_reftargets(reftargets))
      return doc:walk(set_link_contents(reftargets))
    end
}}
