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
  local function setrefnums (reftype)
    return function (id, i)
      local refnum = {
        ['content'] = pandoc.Str(i),
        ['ref-type'] = reftype,
      }
      rawset(refnums, '#'..id, refnum)
    end
  end
  reftargets.tables:map(setrefnums('table'))
  reftargets.figures:map(setrefnums('figure'))
  return {
    Link = function (link)
      if not next (link.content) then
        local refobj = refnums[link.target]
        if refobj then
          link.attributes['ref-type'] = refobj['ref-type']
          link.content = refobj.content
          return link
        end
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
