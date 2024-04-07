/**
 * This file is for every borg item that is not a cyborg item.
 *
 *Used for  DIY Cyborgs.
 */
//DIY MINING - I'm mean

/obj/item/borg/upgrade/shovel
	name = "mining cyborg shovel"
	desc = "A shovel replacement mostly used in Cyborg building kits"
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = NULL

/obj/item/borg/upgrade/shovel/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/shovel/AC = locate() in R.model.modules
		if(AC)
			to_chat(user, span_warning("This unit is already equipped with A shovel!"))
			return FALSE
		AC = new(R.model)
		R.model.basic_modules += AC
		R.model.add_module(AC, FALSE, TRUE)

/obj/item/borg/upgrade/shovel/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/shovel/AC in R.model.modules)
			R.model.remove_module(AC, TRUE)


/obj/item/borg/upgrade/kinetic_accelerator
	name = "mining cyborg Kinetic Acceletrator"
	desc = "A Kinetic Acceletrator replacement mostly used in Cyborg building kits"
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = NULL

/obj/item/borg/upgrade/kinetic_accelerator/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/gun/energy/recharge/kinetic_accelerator/cyborg/AC = locate() in R.model.modules
		if(AC)
			to_chat(user, span_warning("This unit is already equipped with A Kinetic Acceletrator!"))
			return FALSE
		AC = new(R.model)
		R.model.basic_modules += AC
		R.model.add_module(AC, FALSE, TRUE)

/obj/item/borg/upgrade/kinetic_accelerator/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/gun/energy/recharge/kinetic_accelerator/cyborg/AC in R.model.modules)
			R.model.remove_module(AC, TRUE)


/obj/item/borg/upgrade/shovel
	name = "mining cyborg shovel"
	desc = "A shovel replacement mostly used in Cyborg building kits"
	icon_state = "cyborg_upgrade3"
	require_model = TRUE
	model_type = NULL

/obj/item/borg/upgrade/shovel/action(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if(.)
		var/obj/item/shovel/AC = locate() in R.model.modules
		if(AC)
			to_chat(user, span_warning("This unit is already equipped with A shovel!"))
			return FALSE
		AC = new(R.model)
		R.model.basic_modules += AC
		R.model.add_module(AC, FALSE, TRUE)

/obj/item/borg/upgrade/shovel/deactivate(mob/living/silicon/robot/R, user = usr)
	. = ..()
	if (.)
		for(var/obj/item/shovel/AC in R.model.modules)
			R.model.remove_module(AC, TRUE)
