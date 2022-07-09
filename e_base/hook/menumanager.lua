function MenuCallbackHandler:E_slider_option(item)
  E:set_option(item:parameters().E_option, item:value())
end
function MenuCallbackHandler:E_toggle_option(item)
  E:set_option(item:parameters().E_option, item:value() == "on")
end
function MenuCallbackHandler:E_multi_choice_option(item)
  E:set_option(item:parameters().E_option, item:value())
end
