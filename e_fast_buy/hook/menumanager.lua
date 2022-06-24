local MenuCallbackHandler_buy_crimenet_contract = MenuCallbackHandler.buy_crimenet_contract
function MenuCallbackHandler:buy_crimenet_contract(item, node)
  if E:get("fast_buy_contract_confirm") then
    MenuCallbackHandler_buy_crimenet_contract(self, item, node)
  else
    self:_buy_crimenet_contract(item, node)
  end
end
