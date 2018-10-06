require "busted.runner" ()
kpse.set_program_name "luatex"

local fontobj = require "htflibs.fontobj"

describe("Fontobj test", function()
  -- local fonts = fontobj("libertine")
  local fonts = fontobj("pdftex")

  fonts.maxvf = 10
  it("Should load the map file", function()
    assert.is_table(fonts.map)
  end)
  fonts:load_virtual_font(kpse.expand_var("$TEXMFDIST") .. "/fonts/vf/public/libertine/LinLibertineT-tlf-sc-t1.vf")
  -- fonts:load_virtual_font(kpse.expand_var("$TEXMFDIST") .. "/fonts/vf/public/newtx/ntxmia.vf", "ntxmia")
  -- fonts:load_virtual_fonts("public/libertine")
  -- fonts:load_font("LinLibertineO-tlf-t1")
end)