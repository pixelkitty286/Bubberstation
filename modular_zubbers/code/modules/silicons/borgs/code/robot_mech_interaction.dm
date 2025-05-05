/*
/obj/vehicle/sealed/mecha/attack_robot(mob/living/silicon/robot/user)
	if(!iscyborg(user))
		return
	//Allows the Malf to scan a mech's status and loadout, helping it to decide if it is a worthy chariot.
	examine(user)
	if(length(return_occupants()) >= max_occupants)
		to_chat(user, span_warning("This exosuit has a pilot and cannot be controlled."))
		return
	var/can_control_mech = FALSE
	for(var/obj/item/mecha_parts/mecha_tracking/ai_control/A in trackers)
		can_control_mech = TRUE
		to_chat(user, "[span_notice("[icon2html(src, user)] Status of [name]:")]\n[A.get_mecha_info()]")
		break
	if(!can_control_mech)
		to_chat(user, span_warning("You cannot control exosuits without AI control beacons installed."))
		return
	to_chat(user, "<a href='byond://?src=[REF(user)];ai_take_control=[REF(src)]'>[span_boldnotice("Take control of exosuit?")]</a><br>")
*/


///Hack and From Card interactions share some code, so leave that here for both to use.
/obj/vehicle/sealed/mecha/proc/cyborg_enter_mech(mob/living/silicon/robot/cyborg)
	mecha_flags |= SILICON_PILOT
	moved_inside(cyborg)
	cyborg.remote_control = src
	add_occupant(cyborg)
	to_chat(cyborg, "<span class='reallybig boldnotice'>Use Middle-Mouse or the action button in your HUD to toggle equipment safety. Clicks with safety enabled will pass cyborg commands.</span>")


//The item to interface with

// Does not really do much other than allow you to go in
/obj/item/borg/mech_connector
	desc = "A tool used to all cyborgs to interface with mechs"
	icon_state = "charger_charge"

/obj/item/borg/mech_connector/interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	if(ismecha(interacting_with))
		//Allows the Malf to scan a mech's status and loadout, helping it to decide if it is a worthy chariot.
		examine(user)
		var/obj/vehicle/sealed/mecha/interact = interacting_with
		if(length(interact.return_occupants()) >= interact.max_occupants)
			to_chat(user, span_warning("This exosuit has a pilot and cannot be controlled."))
			return
		var/can_control_mech = FALSE
		for(var/obj/item/mecha_parts/mecha_tracking/ai_control/A in interact.trackers)
			can_control_mech = TRUE
		if(!can_control_mech)
			to_chat(user, span_warning("You cannot control exosuits without AI control beacons installed."))
			return

		balloon_alert(user, "Interfacing with exosuit...")
		if(!do_after(user, 3 SECONDS))
			return
		interact.cyborg_enter_mech(user)
	return
