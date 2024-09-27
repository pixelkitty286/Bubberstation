//TODO:Rework possibly?

/datum/cyborg_module
	var/name = "generic module"
	var/category = "generic category"
	var/description = "generic description"
	var/cost = 5
	/// If this module can only be purchased once. This always applies to upgrades, even if the variable is set to false.
	var/one_purchase = FALSE
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

//Syndiborg upgrade blows deepest of covers!
/datum/cyborg_module/upgrade/syndicate
	name = "Syndicate upgrade"
	description = "Downloads a crew harm module set commonly used by the syndicate. (Note: requires root access!!)"
	cost = 35
	upgrade = TRUE
	one_purchase = TRUE
	unlock_text = span_notice("You download an illicit software package from a syndicate database leak and integrate it into your firmware, fighting off a few kernel intrusions along the way.")
	unlock_sound = 'sound/items/jaws_cut.ogg'

/datum/cyborg_module/upgrade/syndicate/upgrade(mob/living/silicon/robot/borg, mob/living/user = usr)
	borg.model.transform_to(/obj/item/robot_model/syndicatejack)


