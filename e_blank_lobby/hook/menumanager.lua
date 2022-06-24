local original_start_job = MenuCallbackHandler.start_job
function MenuCallbackHandler:start_job(job_data)
  if not job_data.job_id then

    Global.game_settings.level_id = "branchbank"
    Global.game_settings.mission = ""
    Global.game_settings.world_setting = ""
    Global.game_settings.difficulty = "sm_wish"
    Global.game_settings.one_down = false
    Global.game_settings.weekly_skirmish = false

    if managers.platform then
      managers.platform:update_discord_heist()
    end
    managers.job:deactivate_current_job()
    self:create_lobby()
    managers.platform:refresh_rich_presence()
    return
  end
  original_start_job(self, job_data)
end
