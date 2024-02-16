local custom = require("user.utils").custom

local palette = require("kanagawa.colors").setup { theme = custom "variant" }
local normalHl = vim.api.nvim_get_hl(0, { name = "Normal" })
local bg = normalHl.background or "NONE"

local custom_highlights = {
   -- general
   TitleString = { fg = palette.fujiWhite },
   TitleIcon = { fg = palette.peachRed },
   SagaBorder = { bg = bg, fg = palette.crystalBlue },
   SagaNormal = { bg = bg },
   SagaExpand = { fg = palette.peachRed },
   SagaCollapse = { fg = palette.peachRed },
   SagaBeacon = { bg = palette.winterBlue },
   -- code action
   ActionPreviewNormal = { link = "SagaNormal" },
   ActionPreviewBorder = { link = "SagaBorder" },
   ActionPreviewTitle = { fg = palette.oniViolet, bg = bg },
   CodeActionNormal = { link = "SagaNormal" },
   CodeActionBorder = { link = "SagaBorder" },
   CodeActionText = { fg = palette.surimiOrange },
   CodeActionNumber = { fg = palette.springGreen },
   -- finder
   FinderSelection = { fg = palette.waveAqua2, bold = true },
   FinderFileName = { fg = palette.fujiWhite },
   FinderCount = { link = "Label" },
   FinderIcon = { fg = palette.waveAqua2 },
   FinderType = { fg = palette.oniViolet },
   --finder spinner
   FinderSpinnerTitle = { fg = palette.winterBlue, bold = true },
   FinderSpinner = { fg = palette.winterBlue, bold = true },
   FinderPreviewSearch = { link = "Search" },
   FinderVirtText = { fg = palette.peachRed },
   FinderNormal = { link = "SagaNormal" },
   FinderBorder = { link = "SagaBorder" },
   FinderPreviewBorder = { link = "SagaBorder" },
   -- definition
   DefinitionBorder = { link = "SagaBorder" },
   DefinitionNormal = { link = "SagaNormal" },
   DefinitionSearch = { link = "Search" },
   -- hover
   HoverNormal = { link = "SagaNormal" },
   HoverBorder = { link = "SagaBorder" },
   -- rename
   RenameBorder = { link = "SagaBorder" },
   RenameNormal = { fg = palette.surimiOrange, bg = bg },
   RenameMatch = { link = "Search" },
   -- diagnostic
   DiagnosticBorder = { link = "SagaBorder" },
   DiagnosticSource = { fg = palette.fujiGray },
   DiagnosticNormal = { link = "SagaNormal" },
   DiagnosticErrorBorder = { link = "DiagnosticError" },
   DiagnosticWarnBorder = { link = "DiagnosticWarn" },
   DiagnosticHintBorder = { link = "DiagnosticHint" },
   DiagnosticInfoBorder = { link = "DiagnosticInfo" },
   DiagnosticPos = { fg = palette.sumiInk4 },
   DiagnosticWord = { fg = palette.fujiWhite },
   -- Call Hierachry
   CallHierarchyNormal = { link = "SagaNormal" },
   CallHierarchyBorder = { link = "SagaBorder" },
   CallHierarchyIcon = { fg = palette.oniViolet },
   CallHierarchyTitle = { fg = palette.peachRed },
   -- lightbulb
   LspSagaLightBulb = { link = "DiagnosticSignHint" },
   -- shadow
   SagaShadow = { bg = palette.sumiInk0 },
   -- Outline
   OutlineIndent = { fg = palette.winterBlue },
   OutlinePreviewBorder = { link = "SagaNormal" },
   OutlinePreviewNormal = { link = "SagaBorder" },
   -- Float term
   TerminalBorder = { link = "SagaBorder" },
   TerminalNormal = { link = "SagaNormal" },
}
for group, conf in pairs(custom_highlights) do
   vim.api.nvim_set_hl(0, group, vim.tbl_extend("keep", conf, { default = true }))
end
