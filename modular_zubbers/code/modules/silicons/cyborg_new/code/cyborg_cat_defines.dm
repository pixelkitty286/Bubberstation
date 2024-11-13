/*
 * # robot_defines
 *
 * Definitions for /mob/living/silicon/robocat and its children, including AI shells.
 *
 * A snowflake cyborg type ment to be kind of like a personal AI but can do things unlike a personal AI.
 */


/mob/living/silicon/robocat
	name = "F3-LINE K-1"
	icon = 'modular_zubbers/code/modules/silicons/cyborg_new/sprites/FELI.dmi'
	icon_state = "FELI-Standard"
	icon_dead = "FELI-Standard-wreck"
	desc = "A maintenance cyborg, a cut down version of the full sized cyborgs."
	held_lh = 'icons/mob/inhands/pai_item_lh.dmi'
	held_rh = 'icons/mob/inhands/pai_item_rh.dmi'
	held_state = "cat"
	maxHealth = 100
	health = 100
	bubble_icon = "robot"

	hud_type = /datum/hud/robot

	radio = /obj/item/radio/headset/silicon/robocat

	blocks_emissive = EMISSIVE_BLOCK_UNIQUE
	light_system = OVERLAY_LIGHT_DIRECTIONAL
	light_on = FALSE

	// Parts

	var/obj/item/stock_parts/power_store/cell = /obj/item/stock_parts/power_store/cell/high


//personal robot laws
/mob/living/silicon/robocat/make_laws()
	laws = new /datum/ai_laws/pai()
	return TRUE

//Radio
/obj/item/radio/headset/silicon/robocat
	name = "\proper Integrated Subspace Transceiver"
	keyslot2 = new /obj/item/encryptionkey/ai
	command = TRUE
