local pandoc = require 'pandoc'
local List   = require 'pandoc.List'
local utils  = require 'pandoc.utils'

local ptype, stringify = utils.type, utils.stringify
local FORMAT = FORMAT

local equation_class = 'equation'

--- Get the ID of the last span in this block and unwrap the span
local function id_from_block (blk)
  if blk.t == 'Plain' or blk.t == 'Para' then
    local last_inline = blk.content:remove()
    if last_inline.t == 'Span' and last_inline.identifier ~= '' then
      local id = last_inline.identifier
      blk.content:extend(last_inline.content)  -- unwrap the span
      -- drop trailing whitespace
      local elemtype
      for i = #blk.content, 1, -1 do
        elemtype = blk.content[i].t
        if elemtype == 'Space' or elemtype == 'SoftBreak' then
          blk.content[i] = nil
        else
          break
        end
      end
      -- Drop the block if it's now empty
      return id, (next(blk.content) and blk or nil)
    else
      blk.content:insert(last_inline)
      return nil, blk
    end
  end
end

--- Extract the ID from the caption
local function set_id_from_caption (elem)
  local capt = elem.caption.long
  local last_block = capt[#capt]
  if last_block then
    local id
    id, last_block = id_from_block(last_block)
    if id then
      elem.identifier = id
      capt[#capt] = last_block
      elem.caption.long = capt
      return id, elem
    end
  end
  return nil, elem
end

--- Creates a filter that fills the given `reftargets` data structure.
local function fill_reftargets (reftargets, opts)
  local function add_to_reftargets(elem, key)
    -- If the element has no ID, try to get one from the caption.
    if elem.identifier == '' then
      local id
      id, elem = set_id_from_caption(elem)
      -- use `true` instead of an ID as a placeholder, so numbering
      -- will still work.
      reftargets[key]:insert(id or true)
      return elem
    else
      reftargets[key]:insert(elem.identifier)
    end
  end

  return  {
    traverse = 'topdown',
    Figure = function (fig)
      return add_to_reftargets(fig, 'figures')
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
      return add_to_reftargets(tbl, 'tables')
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
      if type(id) == 'string' then
        local refnum = {
          ['content'] = pandoc.Inlines{tostring(i)},
          ['ref-type'] = reftype,
        }
        rawset(refnums, '#'..id, refnum)
      end
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
          link.attributes['ref-type'] = opts['ref-types']
            and refobj['ref-type']
            or nil
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
  ['caption']         = default_captions,
  ['id-from-caption'] = true,
  ['labels']          = false,
  ['ref-types']       = false,
  ['separator']       = pandoc.Inlines{Space},
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
    elseif key == 'labels' then
      local labelsconf = useropts[key]
      if ptype(labelsconf) == 'List' then
        opts[key] = labelsconf:map(stringify):includes(FORMAT)
      else
        opts[key] = not not labelsconf  -- ensure boolean
      end
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
