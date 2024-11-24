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
						Grinders oh god oh fuck
***********************************************************************/

//TODO: Matter decompiler.
/obj/item/matter_grinder
	name = "Matter grinder"
	desc = "A trash eating module designed to clean up small and useless trash"
	icon = 'icons/mob/silicon/robot_items.dmi'
	icon_state = "connector"
	hitsound = 'sound/items/weapons/circsawhit.ogg'
	force = 15

	//Trash
	var/list/trash = list(
		/obj/item/cigbutt,
		/obj/item/light,
		/obj/effect/decal/remains/robot,
		/obj/effect/decal/cleanable/robot_debris,
		/obj/item/ammo_casing,
		/obj/item/shrapnel,
		/obj/item/trash,
		/obj/item/shard,
		/obj/item/food/grown,
		/obj/item/pipe,

	)

	//List of tiny mobs (instant grinding)
	var/list/mob/tinymob = list()
	//List of small mobs (Longer time to grind)
	var/list/mob/smallmob = list()
	//List of large mobs (Very long time) HOLY SHIT IT GIBBED THEM!!!
	var/list/mob/largemob = list()


	//Metal, glass, wood, plastic.
	var/datum/robot_energy_storage/material/iron = null
	var/datum/robot_energy_storage/material/glass = null
	var/datum/robot_energy_storage/material/wood = null
	var/datum/robot_energy_storage/material/plastic = null

/obj/item/matter_grinder/Destroy()
	iron = null
	glass = null
	wood = null
	plastic = null
	return ..()

/obj/item/matter_grinder/interact_with_atom(atom/interacting_with as mob|obj|turf|area, mob/living/user as mob|obj, list/modifiers)
	. = ..()
	if(. == COMPONENT_CANCEL_ATTACK_CHAIN)
		return ITEM_INTERACT_SUCCESS

	//We only want to deal with using this on turfs. Specific items aren't important.
	var/turf/T = get_turf(interacting_with)
	if(!istype(T))
		return

	//Trash grinding
	for(var/obj/W in T)
		var/grindcheck = FALSE
		for(var/grindable in trash)
			if(istype(interacting_with, grindable))
				grindcheck = TRUE
				break
		if(grindcheck)
			playsound(src.loc, 'sound/items/weapons/drill.ogg', 50, vary = TRUE)
			if(!do_after(user, 2 SECONDS))
				to_chat(user, span_notice("You deploy your decompiler and start to clear out the contents of \the [T]."))
				return FALSE
			qdel(trash)
			return TRUE
		else
			continue

	//Mob Grinding
	for(var/mob/M in T)
		var/grindcheck = FALSE
		for(var/mob/grindable in tinymob)
			if(istype(interacting_with, grindable))
				grindcheck = TRUE
				break
		if(grindcheck)
			playsound(src.loc, 'sound/items/weapons/circsawhit.ogg', 50, vary = TRUE)
			to_chat(user, span_notice("It's a bit of a struggle, but you manage to suck [M] into your decompiler. It makes a series of visceral crunching noises."))
			qdel(tinymob)
			return TRUE
		else
			continue

	for(var/mob/M in T)
		var/grindcheck = FALSE
		for(var/mob/grindable in smallmob)
			if(istype(interacting_with, grindable))
				grindcheck = TRUE
				break
		if(grindcheck)
			playsound(src.loc, 'sound/items/weapons/circsawhit.ogg', 50, vary = TRUE)
			if(!do_after(user, 2 SECONDS))
				to_chat(user, span_notice("It's a bit of a struggle, but you manage to suck [M] into your decompiler. It makes a series of visceral crunching noises."))
				return FALSE
			qdel(smallmob)
			return TRUE
		else
			continue

/*
	//Used to give the right message.
	var/grabbed_something = 0

	for(var/mob/M in T)
		if(istype(M,small))
			src.loc.visible_message("<span class='danger'>[src.loc] sucks [M] into its decompiler. There's a horrible crunching noise.</span>","<span class='danger'>It's a bit of a struggle, but you manage to suck [M] into your decompiler. It makes a series of visceral crunching noises.</span>")
			playsound(src.loc, 'sound/items/weapons/circsawhit.ogg', 50, vary = TRUE)
			new/obj/effect/decal/cleanable/blood/splatter(get_turf(src))
			qdel(M)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			return

		else if(istype(M,/mob/living/basic/drone) && !M.client)

			var/mob/living/silicon/robot/D = src.loc

			if(!istype(D))
				return

			to_chat(D, "<span class='danger'>You begin decompiling [M].</span>")

			if(!do_after(D,50))
				to_chat(D, "<span class='danger'>You need to remain still while decompiling such a large object.</span>")
				return

			if(!M || !D) return

			to_chat(D, "<span class='danger'>You carefully and thoroughly decompile [M], storing as much of its resources as you can within yourself.</span>")
			qdel(M)
			playsound(src.loc, 'sound/items/weapons/drill.ogg', 50, vary = TRUE)
			new/obj/effect/decal/cleanable/oil(get_turf(src))

			if(iron)
				iron.add_charge(15000)
			if(glass)
				glass.add_charge(15000)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(1000)
			return

		else if(istype(M,/mob/living/basic/cockroach))
			src.loc.visible_message("<span class='danger'>[src.loc] sucks [M] into its decompiler. There's a horrible crunching noise.</span>","<span class='danger'>It's a bit of a struggle, but you manage to suck [M] into your decompiler. It makes a series of visceral crunching noises.</span>")
			playsound(src.loc, 'sound/items/weapons/circsawhit.ogg', 50, vary = TRUE)
			new/obj/effect/decal/cleanable/insectguts(get_turf(src))
			qdel(M)
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			return
		else
			continue

	for(var/obj/W in T)
		//Different classes of items give different commodities.
		if(istype(W,/obj/item/cigbutt))
			if(plastic)
				plastic.add_charge(500)
		else if(istype(W,/mob/living/basic/spider/growing/spiderling))
			if(wood)
				wood.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
		else if(istype(W,/obj/item/light))
			var/obj/item/light/L = W
			if(L.status >= 2) //In before someone changes the inexplicably local defines. ~ Z
				if(iron)
					iron.add_charge(250)
				if(glass)
					glass.add_charge(250)
			else
				continue
		else if(istype(W,/obj/effect/decal/remains/robot))
			if(iron)
				iron.add_charge(2000)
			if(plastic)
				plastic.add_charge(2000)
			if(glass)
				glass.add_charge(1000)
		else if(istype(W,/obj/item/trash))
			if(iron)
				iron.add_charge(1000)
			if(plastic)
				plastic.add_charge(3000)
		else if(istype(W,/obj/effect/decal/cleanable/robot_debris))
			if(iron)
				iron.add_charge(2000)
			if(glass)
				glass.add_charge(2000)
		else if(istype(W,/obj/item/ammo_casing))
			if(iron)
				iron.add_charge(1000)
		else if(istype(W,/obj/item/shrapnel))
			if(iron)
				iron.add_charge(1000)
		else if(istype(W,/obj/item/shard))
			if(glass)
				glass.add_charge(1000)
		else if(istype(W,/obj/item/food/grown))
			if(wood)
				wood.add_charge(4000)
		else if(istype(W,/obj/item/pipe))
			// This allows drones and engiborgs to clear pipe assemblies from floors.
		else
			continue

		qdel(W)
		grabbed_something = 1

	if(grabbed_something)
		to_chat(user, span_notice("You deploy your decompiler and clear out the contents of \the [T]."))
		playsound(src.loc, 'sound/items/weapons/drill.ogg', 50, vary = TRUE)
	else
		to_chat(user, span_alert("Nothing on \the [T] is useful to you."))
	return
*/
/obj/item/robot_model/janitor/Initialize(mapload)
	basic_modules += /obj/item/matter_grinder
	. = ..()
