if exists("g:loaded_pohelper")
  finish
endif
let g:loaded_pohelper = 1

command! NewPBI lua require("pohelper").new_pbi()
command! PBIRefine lua require("pohelper.ai").run_prompt_on_selection("PBI_Refine")
command! TranslateEn lua require("pohelper.ai").run_prompt_on_selection("Translate_En")
command! NewMeeting lua require("pohelper").new_meeting()
command! ActionSync lua require("pohelper").action_sync()
