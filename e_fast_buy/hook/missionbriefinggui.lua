-- remove "buy all" confirmation dialog
local AssetsItem_open_assets_buy_all = AssetsItem.open_assets_buy_all
function AssetsItem:open_assets_buy_all()
  if E:get("fast_buy_assets_confirm") then
    AssetsItem_open_assets_buy_all(self)
  else
    managers.assets:unlock_all_availible_assets()
  end
end

Hooks:PostHook(MissionBriefingGui, "create_asset_tab", "E.fast_buy MissingBriefingGui:create_asset_tab", function(self)
  -- auto-buy all
  if E:get("fast_buy_assets_auto") and self._assets_item then
    self._assets_item:open_assets_buy_all()
  end
end)
