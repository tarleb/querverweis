local pandoc = require 'pandoc'
local List   = require 'pandoc.List'

local equation_class = 'equation'

--- Creates a filter that fills the given `reftargets` data structure.
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

--- A pandoc Space element. Created once for optimization.
local Space = pandoc.Space()

local function make_label (refnum, conf, sep)
  local num = refnum and refnum.content or pandoc.Inlines('?')

  return pandoc.Span(
    {conf.name, Space} .. num .. sep,
    {class="caption-label"}
  )
end

--- Add a label to a referenceable element.
local function add_label (refnums, opts)
  return function (element)
    local elementconf = opts.caption[element.t:lower()]
    assert(elementconf, "Don't know how to make a label for " .. element.t)

    local refnum = refnums['#' .. element.identifier]
    local label = make_label(refnum, elementconf, opts.separator)
    local cpt = element.caption and element.caption.long
    if label and cpt then
      if cpt[1] and List{'Plain', 'Para'}:includes(cpt[1].t) then
        cpt[1].content = {label} .. cpt[1].content
      else
        cpt:insert(pandoc.Plain(label))
      end
      element.caption.long = cpt
    end
    return element
  end
end

--- Returns a map from id to reference number
local function get_refnums (reftargets)
  local refnums = {}
  -- Reftype is a JATS reftype
  local function setrefnums (reftype)
    return function (id, i)
      local refnum = {
        ['content'] = pandoc.Inlines{tostring(i)},
        ['ref-type'] = reftype,
      }
      rawset(refnums, '#'..id, refnum)
    end
  end
  -- See the JATS docs for suitable `reftype` values
  reftargets.equations:map(setrefnums('disp-formula'))
  reftargets.figures:map(setrefnums('figure'))
  reftargets.tables:map(setrefnums('table'))
  return refnums
end

local function set_labels (refnums, opts)
  return {
    Table = opts.labels and add_label(refnums, opts) or nil,
    Figure = opts.labels and add_label(refnums, opts) or nil,

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

--- Set of default caption options.
local default_captions = {
  ['figure'] = {
    name = 'Figure',
  },
  ['table'] = {
    name = 'Table',
  },
}

--- Set of default options.
local default_options = {
  labels = false,
  separator = pandoc.Inlines{Space},
  caption = default_captions,
}

--- Create querverweis options
local function make_opts (useropts)
  useropts = useropts or {}
  local opts = {}
  for key, value in pairs(default_options) do
    if key == 'separator' then
      opts[key] =
        (useropts.separator == 'colon' and pandoc.Inlines{':', Space}) or
        (useropts.separator == 'period' and pandoc.Inlines{'.', Space}) or
        value
    else
      opts[key] = useropts[key] or value
    end
  end

  return opts
end

return {{
    Pandoc = function (doc)
      local opts = make_opts(doc.meta.querverweis)
      doc.meta.querverweis = nil

      local reftargets = {
        equations = List{},
        figures = List{},
        tables  = List{},
      }
      doc = doc:walk(fill_reftargets(reftargets))

      local refnums = get_refnums(reftargets)
      return doc:walk(set_labels(refnums, opts))
    end
}}
