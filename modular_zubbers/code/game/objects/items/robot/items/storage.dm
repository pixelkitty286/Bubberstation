/obj/item/borg/apparatus/paper_manipulator
	name = "paperwork manipulation apparatus"
	desc = "An apparatus for carrying, deploying, and manipulating sheets of paper."
	icon_state = "borg_stack_apparatus"
	storable = list(/obj/item/paper)

/obj/item/borg/apparatus/tank_manipulator
	name = "tank manipulation apparatus"
	desc = "An apparatus for carrying and manipulating handheld tanks."
	icon_state = "borg_beaker_apparatus"
	storable = list(/obj/item/tank)

/obj/item/borg/apparatus/tank_manipulator/update_overlays()
	. = ..()
	var/mutable_appearance/arm = mutable_appearance(icon = icon, icon_state = "borg_beaker_apparatus")
	if(stored)
		stored.pixel_x = 0
		stored.pixel_y = 0
		var/mutable_appearance/stored_copy = new /mutable_appearance(stored)
		stored_copy.layer = FLOAT_LAYER
		stored_copy.plane = FLOAT_PLANE
		. += stored_copy
	else
		arm.pixel_y = arm.pixel_y - 5
	. += arm

/obj/item/robot_model/syndicatejack/Initialize(mapload)
	basic_modules += list(
		/obj/item/borg/apparatus/tank_manipulator,
		/obj/item/borg/apparatus/engineering,
	)
	. = ..()

/obj/item/robot_model/ninja_saboteur/Initialize(mapload)
	basic_modules += list(
		/obj/item/borg/apparatus/tank_manipulator,
		/obj/item/borg/apparatus/engineering,
	)
	. = ..()

/obj/item/robot_model/engineering/Initialize(mapload)
	basic_modules += list(
		/obj/item/borg/apparatus/tank_manipulator,
		/obj/item/borg/apparatus/engineering,
	)
	. = ..()

/obj/item/robot_model/saboteur/Initialize(mapload)
	basic_modules += list(
		/obj/item/borg/apparatus/tank_manipulator,
		/obj/item/borg/apparatus/engineering,
	)
	. = ..()

/obj/item/borg/apparatus/sheet_manipulator/Initialize(mapload)
	. = ..()
	storable += /obj/item/stack/rods

	// Adds Crowbars to borg models which do not have them so they do not get stuck behind unpowered doors

/obj/item/robot_model/clown/Initialize(mapload)
	name = "Clown"
	basic_modules += list(
		/obj/item/crowbar/cyborg,
	)
	. = ..()

/obj/item/robot_model/medical/Initialize(mapload)
	name = "Medical"
	basic_modules += list(
		/obj/item/crowbar/cyborg,
	)
	. = ..()

/obj/item/robot_model/peacekeeper/Initialize(mapload)
	name = "Peacekeeper"
	basic_modules += list(
		/obj/item/crowbar/cyborg,
	)
	. = ..()

/obj/item/robot_model/security/Initialize(mapload)
	name = "Security"
	basic_modules += list(
		/obj/item/crowbar/cyborg,
	)
	. = ..()

/obj/item/robot_model/service/Initialize(mapload)
	name = "Service"
	basic_modules += list(
		/obj/item/crowbar/cyborg,
	)
	. = ..()



//Engineering cyborg apparatus
/obj/item/borg/apparatus/engineering
	name = "Engineering manipulation gripper"
	desc = "A simple grasping tool for interacting with various engineering related items, such as circuits, gas tanks, conveyer belts and more."
	icon = 'modular_zubbers/icons/mob/silicon/robot_items.dmi'
	icon_state = "gripper"
	storable = list(
					/obj/item/vending_refill,
					/obj/item/stack/tile,
					/obj/item/light,
					/obj/item/stack/conveyor,
					/obj/item/conveyor_switch_construct,
					/obj/item/wallframe,
					/obj/item/tank,
					/obj/item/stock_parts,
					/obj/item/assembly/control,
					/obj/item/electronics/airlock
					)

//Mining cyborg apparatus
/obj/item/borg/apparatus/mining
	name = "Mining manipulation gripper"
	desc = "A simple grasping tool suited to assist in an array of mining applications."
	icon = 'modular_zubbers/icons/mob/silicon/robot_items.dmi'
	icon_state = "gripper_mining"
	storable = list(
					/obj/item/organ/monster_core/,
					/obj/item/xenoarch/useless_relic/,
					/obj/item/xenoarch/broken_item,
					/obj/item/xenoarch/strange_rock,
					/obj/item/stack/sheet/animalhide/,
					/obj/item/stack/sheet/sinew,
					/obj/item/survivalcapsule/,
					/obj/item/extraction_pack,
					/obj/item/fulton_core,
					)

/obj/item/robot_model/miner/Initialize(mapload)
	name = "Miner"
	basic_modules += list(
		/obj/item/borg/apparatus/mining/,
	)
	. = ..()

/obj/item/borg/apparatus/mining/examine()
	. = ..()
	if(stored)
		. += "The gripper currently has [stored] secured."
	. += span_notice(" <i>Alt-click</i> will drop the currently held item. ")
