/**
 * Cargoborg specific items
 *
 * Refer to modular_skyrat/modules/cargoborg/code/robot_items.dm for original definitions
 */

// Override the mail clamp to be able to dispense into mail chutes
/obj/item/borg/hydraulic_clamp/mail/pre_attack(atom/attacked_atom, mob/living/silicon/robot/user, params)
	var/obj/machinery/disposal/delivery_chute/chute = attacked_atom
	if(istype(attacked_atom, /obj/structure/plasticflaps))	// If we attacked flaps, try locating the chute under them
		var/obj/structure/plasticflaps/flaps = attacked_atom
		chute = locate(/obj/machinery/disposal/delivery_chute) in flaps.loc.contents
	if(!istype(chute))	// This is one way to say we didn't attack a chute or flaps over a chute
		return ..()

	if(!istype(user) || !user.Adjacent(attacked_atom) || !COOLDOWN_FINISHED(src, clamp_cooldown) || in_use)
		return

	// Not enough charge
	if(user?.cell.charge < charge_cost)
		balloon_alert(user, "low charge!")
		return

	user.cell.use(charge_cost)
	in_use = TRUE
	COOLDOWN_START(src, clamp_cooldown, cooldown_duration)

	if(!contents.len)
		in_use = FALSE
		return

	var/extraction_index = selected_item_index ? selected_item_index : contents.len
	var/atom/movable/extracted_item = contents[extraction_index]
	selected_item_index = 0

	if (unloading_time > 0.5 SECONDS) // Chat spam reduction
		balloon_alert(user, "unloading")
	playsound(src, clamp_sound, clamp_sound_volume, FALSE, -5)
	COOLDOWN_START(src, clamp_cooldown, cooldown_duration)

	if(!do_after(user, unloading_time, attacked_atom))
		in_use = FALSE
		return

	chute.place_item_in_disposal(extracted_item)
	visible_message(span_notice("[src.loc] unloads [extracted_item] from [src]."))
	log_silicon("[user] unloaded [extracted_item] onto [chute] ([AREACOORD(chute)]).")
	in_use = FALSE
	return
/**
 * Cargoborg specific items
 *
 * Refer to modular_skyrat/modules/cargoborg/code/robot_items.dm for original definitions
 */

// Override the mail clamp to be able to dispense into mail chutes
/obj/item/borg/hydraulic_clamp/mail/pre_attack(atom/attacked_atom, mob/living/silicon/robot/user, params)
	var/obj/machinery/disposal/delivery_chute/chute = attacked_atom
	if(istype(attacked_atom, /obj/structure/plasticflaps))	// If we attacked flaps, try locating the chute under them
		var/obj/structure/plasticflaps/flaps = attacked_atom
		chute = locate(/obj/machinery/disposal/delivery_chute) in flaps.loc.contents
	if(!istype(chute))	// This is one way to say we didn't attack a chute or flaps over a chute
		return ..()

	if(!istype(user) || !user.Adjacent(attacked_atom) || !COOLDOWN_FINISHED(src, clamp_cooldown) || in_use)
		return

	// Not enough charge
	if(user?.cell.charge < charge_cost)
		balloon_alert(user, "low charge!")
		return

	user.cell.use(charge_cost)
	in_use = TRUE
	COOLDOWN_START(src, clamp_cooldown, cooldown_duration)

	if(!contents.len)
		in_use = FALSE
		return

	var/extraction_index = selected_item_index ? selected_item_index : contents.len
	var/atom/movable/extracted_item = contents[extraction_index]
	selected_item_index = 0

	if (unloading_time > 0.5 SECONDS) // Chat spam reduction
		balloon_alert(user, "unloading")
	playsound(src, clamp_sound, clamp_sound_volume, FALSE, -5)
	COOLDOWN_START(src, clamp_cooldown, cooldown_duration)

	if(!do_after(user, unloading_time, attacked_atom))
		in_use = FALSE
		return

	chute.place_item_in_disposal(extracted_item)
	visible_message(span_notice("[src.loc] unloads [extracted_item] from [src]."))
	log_silicon("[user] unloaded [extracted_item] onto [chute] ([AREACOORD(chute)]).")
	in_use = FALSE
	return


/obj/item/gun/energy/recharge/kinetic_accelerator/cyborg
	max_mod_capacity = 100

//Research borg stuff
/obj/item/inducer/cyborg/sci
	icon = 'icons/obj/tools.dmi'
	icon_state = "inducer-sci"

//Illegal experimental Dash module

/obj/item/experimental_dash
	name = "Exerimental Dash"
	desc = "An experimental module that allows for dashing."
	desc_controls = "Left-click to dash."
	icon = 'icons/mob/actions/actions_items.dmi'
	icon_state = "jetboot"
	w_class = WEIGHT_CLASS_NORMAL
	resistance_flags = LAVA_PROOF | FIRE_PROOF | ACID_PROOF
	var/charge_cost = (STANDARD_CELL_CHARGE *  3.2)
	var/datum/effect_system/spark_spread/spark_system
	var/datum/action/innate/dash/research/jaunt
	var/mob/living/silicon/robot/cyborg

/obj/item/experimental_dash/Initialize(mapload)
	. = ..()
	jaunt = new(src)
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)


/obj/item/experimental_dash/ranged_interact_with_atom(atom/interacting_with, mob/living/user, list/modifiers)
	. = ..()
	if(. == SECONDARY_ATTACK_CANCEL_ATTACK_CHAIN)
		return ITEM_INTERACT_SUCCESS
	if(cyborg.cell.charge <= charge_cost)//Prevents usage when charge is low
		user.balloon_alert(user, "Low charge!")
		return ITEM_INTERACT_SUCCESS
	if(!interacting_with.density && jaunt?.teleport(user, interacting_with))
		cyborg?.cell?.use(charge_cost)
		return ITEM_INTERACT_SUCCESS
	return NONE

/obj/item/experimental_dash/equipped(mob/user, slot, initial)
	. = ..()
	if(!QDELETED(jaunt))
		jaunt.Grant(user, src)
	cyborg = user

/obj/item/experimental_dash/dropped(mob/user)
	. = ..()
	if(!QDELETED(jaunt))
		jaunt.Remove(user)
	cyborg = null

/obj/item/experimental_dash/Destroy()
	QDEL_NULL(spark_system)
	QDEL_NULL(jaunt)
	return ..()

/datum/action/innate/dash/research
	current_charges = 1
	max_charges = 1
	charge_rate = 15 SECONDS
	beam_length = 1 SECONDS
	recharge_sound = 'sound/machines/ding.ogg'
	beam_effect = "plasmabeam"

/datum/action/innate/dash/research/GiveAction(mob/viewer) //this action should be invisible
	return

/datum/action/innate/dash/research/HideFrom(mob/viewer)
	return

//No more ghetto
/obj/item/screwdriver/cyborg/power
	sharpness = NONE

//Research cyborg omnitool

/obj/item/borg/cyborg_omnitool/research
	name = "research omni-toolset"
	desc = "A set of engineering tools with a addition of tools to allow synthetic repairs."

	omni_toolkit = list(
		/obj/item/surgical_drapes/cyborg,
		/obj/item/bonesetter/cyborg,
	)

/**********************************************************************
					Trash shreader oh god oh fuck
***********************************************************************/

/obj/item/trash_shreader
	name = "Trash Shreader"
	desc = "A trash eating module designed to clean up small and useless trash"
	icon = 'icons/mob/silicon/robot_items.dmi'
	icon_state = "connector"
	hitsound = 'sound/items/weapons/circsawhit.ogg'
	force = 15

	// Sounds

	var/trash_grinding = 'sound/items/weapons/drill.ogg'
	var/trash_grinded = 'sound/items/tools/welder.ogg'
	var/smob_grind = 'sound/items/weapons/circsawhit.ogg'
	var/lmob_grind = 'sound/machines/juicer.ogg'
	var/grind_gib = 'sound/misc/splort.ogg'


	//Trash
	var/list/trash = list(
		/obj/item/cigbutt,
		/obj/item/light,
		/obj/effect/decal/remains,
		/obj/effect/decal/cleanable/robot_debris,
		/obj/item/ammo_casing,
		/obj/item/shrapnel,
		/obj/item/trash,
		/obj/item/shard,
		/obj/item/food/grown,
		/obj/item/pipe,
		/obj/effect/decal/cleanable/garbage,
		/obj/item/food,
	)

	//List of small mobs (instant grinding)
	var/list/mob/living/small_mob = list(
		/mob/living/basic/mouse,
		/mob/living/basic/axolotl,
		/mob/living/basic/butterfly,
		/mob/living/basic/cockroach,
		/mob/living/basic/frog,
		/mob/living/basic/lizard,
		/mob/living/basic/bat,
		/mob/living/basic/bee,
		/mob/living/basic/crab,
		/mob/living/basic/chick,
	)
	//List of medium mobs (Longer time to grind) HOLY SHIT IT GIBBED THEM!!!
	var/list/mob/living/medium_mob = list(
		/mob/living/basic/mothroach,
		/mob/living/basic/drone,
		/mob/living/basic/pet,
		/mob/living/basic/parrot,
		/mob/living/basic/slime, // what did you think the grinder was ment for xeno bio?
		/mob/living/basic/headslug,
		/mob/living/basic/regal_rat,
		/mob/living/basic/chicken,

	)
	//List of large mobs (Very long time)
	var/list/mob/living/large_mob = list(
		/mob/living/carbon/human,
		/mob/living/carbon/alien,
		/mob/living/silicon,
		/mob/living/basic/space_dragon,
		/mob/living/basic/carp,
		/mob/living/basic/bear,
		/mob/living/basic/spider,
	)

/// This is to deal handle interactions with trash and small rodents.
/obj/item/trash_shreader/interact_with_atom(atom/atom as mob|obj|turf|area, mob/living/user as mob|obj, list/modifiers)
	. = ..()
	if(istype(atom.loc, /mob/living/silicon/robot) || istype(atom.loc, /obj/item/robot_model) || HAS_TRAIT(atom, TRAIT_NODROP))
		return ..()
	if(. == COMPONENT_CANCEL_ATTACK_CHAIN)
		return ITEM_INTERACT_SUCCESS

	//Trash check
	if(is_type_in_list (atom, trash))
		playsound(src.loc, trash_grinding, 50, vary = TRUE)
		to_chat(user, span_notice("You deploy your shreader and start to shread \the [atom]."))
		if(!do_after(user, 0.2 SECONDS))
			return
		playsound(src.loc, trash_grinded, 50, vary = TRUE)
		qdel(atom)
		return TRUE

	//small mob check
	else if(is_type_in_list (atom, small_mob))
		if(!user.combat_mode)
			return
		playsound(src.loc, smob_grind, 50, vary = TRUE)
		if(!do_after(user, 0.3 SECONDS))
			return
		to_chat(user, span_notice("It's a bit of a struggle, but you manage to suck [atom] into your shreader. It makes a series of visceral crunching noises."))
		new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
		playsound(src.loc, grind_gib, 50, vary = TRUE)
		qdel(atom)
		return TRUE

	//Medium mobs hide your pets!
	else if(is_type_in_list (atom, medium_mob))
		if(!user.combat_mode)
			return
		var/mob/living/M = atom
		if(M.stat == DEAD)
			playsound(src.loc, smob_grind, 50, vary = TRUE)
			if(!do_after(user, 3 SECONDS))
				return
			to_chat(user, span_danger("It's a bit of a struggle, but you manage to suck [M] into your shreader! It makes a series of visceral crunching noises and sends gore every where!"))
			M.gib(DROP_ALL_REMAINS)
			playsound(src.loc, grind_gib, 50, vary = TRUE)
			return TRUE

	//Large mobs HUMANS?!
	else if(is_type_in_list (atom, large_mob))
		if(!user.combat_mode)
			return
		var/mob/living/silicon/robot/robot_user = user
		if(robot_user.emagged)
			var/mob/living/M = atom
			if(M.stat == DEAD)
				playsound(src.loc, lmob_grind, 50, vary = TRUE)
				if(!do_after(user, 6 SECONDS))
					return
				to_chat(user, span_danger("It's a bit of a struggle, but you manage to suck [M] into your shreader! It makes a series of visceral crunching noises and sends gore every where!"))
				M.gib(DROP_ALL_REMAINS)
				playsound(src.loc, grind_gib, 50, vary = TRUE)
				return TRUE
	return

/obj/item/robot_model/janitor/Initialize(mapload)
	basic_modules += /obj/item/trash_shreader
	. = ..()
