/*
 * Insert the component into the select mob.
*/

/obj/item/robot_component/proc/Insert(mob/living/silicon/robot/receiver, special = FALSE, movement_flags)
	SHOULD_CALL_PARENT(TRUE)

	mob_insert(receiver, special, movement_flags)
	bodypart_insert(limb_owner = receiver, movement_flags = movement_flags)

	return TRUE

