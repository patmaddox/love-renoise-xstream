--[[===========================================================================
Chorder.lua
===========================================================================]]--

return {
arguments = {
  {
      ["locked"] = false,
      ["name"] = "chord.root",
      ["linked"] = false,
      ["value"] = 57,
      ["properties"] = {
          ["min"] = 0,
          ["max"] = 119,
          ["display_as"] = "note",
      },
      ["description"] = "",
  },
  {
      ["locked"] = false,
      ["name"] = "chord.quality",
      ["linked"] = false,
      ["value"] = 2,
      ["properties"] = {
          ["max"] = 2,
          ["items"] = {
              "major",
              "minor",
          },
          ["display_as"] = "popup",
          ["min"] = 1,
      },
      ["description"] = "",
  },
  {
      ["locked"] = false,
      ["name"] = "ext.quality_7",
      ["linked"] = false,
      ["value"] = 3,
      ["properties"] = {
          ["max"] = 3,
          ["items"] = {
              "none",
              "major",
              "minor",
          },
          ["display_as"] = "popup",
          ["min"] = 1,
      },
      ["description"] = "",
  },
  {
      ["locked"] = false,
      ["name"] = "bass.octave",
      ["linked"] = false,
      ["value"] = 3,
      ["properties"] = {
          ["max"] = 8,
          ["zero_based"] = false,
          ["display_as"] = "integer",
          ["min"] = 0,
      },
      ["description"] = "",
  },
  {
      ["locked"] = false,
      ["name"] = "chord.inversion",
      ["linked"] = false,
      ["value"] = -1,
      ["properties"] = {
          ["max"] = 3,
          ["zero_based"] = false,
          ["display_as"] = "integer",
          ["min"] = -3,
      },
      ["description"] = "",
  },
},
presets = {
  {
      ["chord.root"] = 60,
      ["name"] = "Cmaj7",
      ["chord.quality"] = 1,
      ["ext.quality_7"] = 2,
      ["bass.octave"] = 3,
      ["chord.inversion"] = 0,
  },
  {
      ["chord.root"] = 64.284,
      ["name"] = "Emin7 (-1i)",
      ["chord.quality"] = 2,
      ["ext.quality_7"] = 3,
      ["bass.octave"] = 3,
      ["chord.inversion"] = -1,
  },
},
data = {
  ["noteFifth"] = [[return function()
  return data.argsRoot() + data.interval_fifth
end]],
  ["interval_minor_third"] = "return 3",
  ["noteRoot"] = [[return function()
  return data.argsRoot()
end]],
  ["noteSeventh"] = [[return function()
  local seventh_quality = data.seventh_qualities[args.ext.quality_7]
  local seventh_value
  if seventh_quality == "major" then
    seventh_value = data.interval_major_seventh
  elseif seventh_quality == "minor" then
    seventh_value = data.interval_minor_seventh
  end

  return data.argsRoot() + seventh_value
end]],
  ["interval_major_third"] = "return 4",
  ["interval_minor_seventh"] = "return 10",
  ["invert"] = [[return function()
  local first = 1
  local last = data.argsInversion()
  local interval = data.interval_octave
  
  if data.argsInversion() < 0 then
    first = #notes + data.argsInversion()
    last = #notes
    interval = -data.interval_octave
  end
  
  for i=first, last do
    notes[i] = notes[i] + interval
  end
end]],
  ["root"] = [[return function()
  return data.noteRoot()
end]],
  ["noteBass"] = [[return function()
  local root_octave = math.floor(data.argsRoot()/ data.interval_octave)
  local octave_diff = root_octave - args.bass.octave

  return data.argsRoot() - (octave_diff * data.interval_octave)
end]],
  ["interval_fifth"] = "return 7",
  ["argsInversion"] = [[return function()
  return tonumber(args.chord.inversion)
end]],
  ["interval_octave"] = "return 12",
  ["argsRoot"] = [[return function()
  return math.floor(args.chord.root)
end]],
  ["seventh_qualities"] = "return { \"none\", \"major\", \"minor\" }",
  ["noteThird"] = [[return function()
  local quality = data.chord_qualities[args.chord.quality]

  local third_value
  if quality == "major" then
    third_value = data.interval_major_third
  elseif quality == "minor" then
    third_value = data.interval_minor_third
  end

  return data.argsRoot() + third_value
end]],
  ["chord_qualities"] = "return { \"major\", \"minor\" }",
  ["interval_major_seventh"] = "return 11",
},
events = {
},
options = {
 color = 0x000000,
},
callback = [[
xline = table.rcopy(EMPTY_XLINE)


notes = {
  data.noteRoot(),
  data.noteThird(),
  data.noteFifth(),
  data.noteSeventh(),
}

notes[#notes+1] = data.noteBass()
data.invert()

table.sort(notes)
rprint(notes)

print("success!")

for i=1,#notes do
  xline.note_columns[i].note_value = notes[i]
end
]],
}