/datum/cyborg_module
	var/name = "generic module"
	var/category = "generic category"
	var/description = "generic description"
	var/cost = 5
	/// If this module can only be purchased once. This always applies to upgrades, even if the variable is set to false.
	var/one_purchase = FALSE
	/*
	/// If the module gives an active ability, use this. Mutually exclusive with upgrade.
	var/power_type = /datum/action/innate/ai
	*/
	/// If the module gives a passive upgrade, use this. Mutually exclusive with power_type.
	var/upgrade = FALSE
	/// Text shown when an ability is unlocked
	var/unlock_text = span_notice("Hello World!")
	/// Sound played when an ability is unlocked
	var/unlock_sound

/// Applies upgrades
/datum/cyborg_module/proc/upgrade(mob/living/silicon/robot/CYBORG)
	return

/// Modules causing destruction
/datum/cyborg_module/destructive
	category = "Destructive Modules"

/// Modules with stealthy and utility uses
/datum/cyborg_module/utility
	category = "Utility Modules"

/// Modules that are improving AI abilities and assets
/datum/cyborg_module/upgrade
	category = "Upgrade Modules"
