function MenuCallbackHandler:is_modded_client()
    return not E.dekink.enabled
end

function MenuCallbackHandler:is_not_modded_client()
    return E.dekink.enabled
end

local build_mods_list = MenuCallbackHandler.build_mods_list
function MenuCallbackHandler:build_mods_list()
    if E.dekink.enabled then
        return {}
    else
        return build_mods_list(self)
    end
end
