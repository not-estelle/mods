Hooks:PreHook(CopBrain, "on_alarm_pager_interaction", "E.antiannoy CopBrain:on_alarm_pager_interaction", function(self, status, player)
  if status == "complete" then
    local nr_previous_bluffs = managers.groupai:state():get_nr_successful_alarm_pager_bluffs()
    if nr_previous_bluffs >= 4 then
      E.blame:notify_by_player(player, "answered too many pagers")
    end
  elseif status == "interrupted" then
    E.blame:notify_by_player(player, "hung up the pager")
  end
end)
