local pandoc = require 'pandoc'
local List   = require 'pandoc.List'

local equation_class = 'equation'

local function fill_reftargets (reftargets)
  return  {
    traverse = 'topdown',
    Figure = function (fig)
      if fig.identifier ~= '' then
        reftargets.figures:insert(fig.identifier)
      end
    end,
    Span = function (span)
      if span.identifier and span.classes:includes(equation_class) then
        reftargets.equations:insert(span.identifier)
        return span, false
      end
    end,
    Math = function (mth)
      local formula, label = mth.text:match '^(.+)\\label%{(.+)%}%s*$'
      if formula and label then
        reftargets.equations:insert(label)
        mth.text = formula:gsub('%s*', '') -- trim end
        return pandoc.Span(mth, {label, {equation_class}}), false
      end
    end,
    Table = function (tbl)
      if tbl.identifier ~= '' then
        reftargets.tables:insert(tbl.identifier)
      end
    end,
  }
end

local function set_link_contents (reftargets)
  local refnums = {}
  -- See the JATS docs for suitable `reftype` values
  local function setrefnums (reftype)
    return function (id, i)
      local refnum = {
        ['content'] = pandoc.Str(i),
        ['ref-type'] = reftype,
      }
      rawset(refnums, '#'..id, refnum)
    end
  end
  reftargets.equations:map(setrefnums('eq'))
  reftargets.figures:map(setrefnums('figure'))
  reftargets.tables:map(setrefnums('table'))
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
        equations = List{},
        figures = List{},
        tables  = List{},
      }
      doc = doc:walk(fill_reftargets(reftargets))
      return doc:walk(set_link_contents(reftargets))
    end
}}
