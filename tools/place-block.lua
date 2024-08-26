--- Update documentation in the README
-- Copyright: © 2024 Albert Krewinkel
-- License: MIT

local pandoc = require 'pandoc'
local tostring= tostring
local Blocks = pandoc.Blocks
local RawBlock = pandoc.RawBlock

local marker = '\n<%!%-%- DO NOT EDIT AFTER THIS LINE![^\n]* %-%->'

--- Create a raw Markdown block.
-- @param str  Markdown text
-- @return Block
local rawmd = function (str)
  return RawBlock('markdown', str)
end

--- Generate documentation for content marked for auto-generation.
-- Skips all other contents and includes it as raw Markdown.
local function process_document (input, blocks, start)
  start = start or 1
  local _, mstop = input:find(marker, start)
  mstop = mstop or #input
  blocks:insert(rawmd(input:sub(start, mstop)))
  return blocks
end

--- Treat the first file as raw Markdown, parse and append the rest.
function Reader (inputs)
  local template = inputs:remove(1)
  local blocks = process_document(tostring(template), Blocks{}, 1)
  local doc = pandoc.read(inputs, 'markdown')
  doc.blocks = blocks .. doc.blocks
  return doc
end
