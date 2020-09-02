-- Copies weapon data and sets some values from a crew weapon version
local function based_on(weap, crew_weap)
  local w = deep_clone(weap)
  w.sounds.prefix = crew_weap.sounds.prefix
  w.muzzleflash = crew_weap.muzzleflash
  w.shell_ejection = crew_weap.shell_ejection
  w.hold = crew_weap.hold
  w.reload = crew_weap.reload
  w.anim_usage = crew_weap.anim_usage or crew_weap.usage
  return w
end


Hooks:PostHook(WeaponTweakData, "init", "sh_init", function(self)
  self.ak47_npc.DAMAGE = 1
  self.saiga_npc.CLIP_AMMO_MAX = 20
  self.saiga_npc.auto.fire_rate = 0.18

  -- Fix existing weapons sounds
  self.mac11_npc.sounds.prefix = self.mac10_crew.sounds.prefix
  self.akmsu_smg_npc.sounds.prefix = self.akmsu_crew.sounds.prefix
  self.asval_smg_npc.sounds.prefix = self.asval_crew.sounds.prefix
  --self.ump_npc.sounds.prefix = self.schakal_crew.sounds.prefix
  self.benelli_npc.sounds.prefix = self.ben_crew.sounds.prefix
  self.ak47_ass_npc.sounds.prefix = self.ak47_crew.sounds.prefix
  self.sr2_smg_npc.sounds.prefix = self.sr2_crew.sounds.prefix
  self.rpk_lmg_npc.sounds.prefix = self.rpk_crew.sounds.prefix

  -- Make weapons of the same type have the same stats (damage increase is handled by weapon presets)
  -- This ensures consistent damage scaling independent of the weapon use of different factions
  self.scar_npc = based_on(self.m4_npc, self.scar_crew)
  self.mp5_npc = based_on(self.m4_npc, self.mp5_crew)
  self.g36_npc = based_on(self.m4_npc, self.g36_crew)
  self.spas12_npc = based_on(self.r870_npc, self.spas12_crew)

  self._orig_npc_dmg = {}
  for k, v in pairs(self) do
    if k:sub(-4) == "_npc" then
      self._orig_npc_dmg[k] = v.DAMAGE
    end
  end
end)


local function restore_npc_weapon_dmg(self)
  for k, v in pairs(self._orig_npc_dmg) do
    self[k].DAMAGE = v
  end
end


-- Since Overkill decided to mess with weapon stats based on difficulty instead of adjusting the presets
-- we have to restore the weapon damage values after they have been modified by those functions
Hooks:PostHook(WeaponTweakData, "_set_normal", "sh__set_normal", restore_npc_weapon_dmg)
Hooks:PostHook(WeaponTweakData, "_set_hard", "sh__set_hard", restore_npc_weapon_dmg)
Hooks:PostHook(WeaponTweakData, "_set_overkill", "sh__set_overkill", restore_npc_weapon_dmg)
Hooks:PostHook(WeaponTweakData, "_set_overkill_145", "sh__set_overkill_145", restore_npc_weapon_dmg)
Hooks:PostHook(WeaponTweakData, "_set_easy_wish", "sh__set_easy_wish", restore_npc_weapon_dmg)
Hooks:PostHook(WeaponTweakData, "_set_overkill_290", "sh__set_overkill_290", restore_npc_weapon_dmg)
Hooks:PostHook(WeaponTweakData, "_set_sm_wish", "sh__set_sm_wish", restore_npc_weapon_dmg)
