#define DEFAULT_IN_HAND_OFFSET_X 3
#define DEFAULT_IN_HAND_OFFSET_Y 0

/datum/component/riding/creature/robot
	var/obj/item/bodypart/used_hand

/datum/component/riding/creature/robot/Initialize(mob/living/riding_mob, force, ride_check_flags, potion_boost)
	. = ..()
	var/mob/living/silicon/robot/robot_parent = parent
	if(ride_check_flags & CARRIER_NEEDS_ARM && HAS_TRAIT(riding_mob, TRAIT_R_CANBEHELD))
		robot_parent.buckle_lying = 0
		used_hand = robot_parent.get_active_hand()
		ADD_TRAIT(riding_mob, TRAIT_UNDENSE, VEHICLE_TRAIT)


/datum/component/riding/creature/robot/vehicle_mob_unbuckle(datum/source, mob/living/former_rider, force = FALSE)
	. = ..()
	former_rider.set_density(TRUE)
	if((ride_check_flags & CARRIER_NEEDS_ARM) && HAS_TRAIT(former_rider, TRAIT_R_CANBEHELD))
		REMOVE_TRAIT(former_rider, TRAIT_UNDENSE, VEHICLE_TRAIT)

/datum/component/riding/creature/robot/handle_vehicle_offsets(dir)
	. = ..()
	var/mob/living/silicon/robot/robot_parent = parent

	for(var/mob/living/rider in robot_parent.buckled_mobs)
		if(!HAS_TRAIT(rider, TRAIT_R_CANBEHELD))
			continue

		var/target_pixel_y = DEFAULT_IN_HAND_OFFSET_X
		var/target_pixel_x = DEFAULT_IN_HAND_OFFSET_Y
		var/offset_hand = used_hand.body_zone

		if(dir == NORTH && offset_hand == BODY_ZONE_L_ARM)
			target_pixel_x += -6
		else if(dir == NORTH && offset_hand == BODY_ZONE_R_ARM)
			target_pixel_x += 6
		else if(dir == SOUTH && offset_hand == BODY_ZONE_L_ARM)
			target_pixel_x += 6
		else if(dir == SOUTH && offset_hand == BODY_ZONE_R_ARM)
			target_pixel_x += -6
		else if(dir == EAST)
			target_pixel_x += 3
		else
			target_pixel_x += -3

		rider.pixel_y = target_pixel_y
		rider.pixel_x = target_pixel_x

/datum/component/riding/creature/robot/handle_vehicle_layer(dir)
	. = ..()
	var/mob/living/silicon/robot/robot_parent = parent

	for(var/mob/living/rider in robot_parent.buckled_mobs)
		if(!HAS_TRAIT(rider, TRAIT_R_CANBEHELD))
			continue
		var/target_layer = MOB_ABOVE_PIGGYBACK_LAYER + 0.10
		if(dir == NORTH)
			target_layer -= 0.30
		rider.layer = target_layer

#undef DEFAULT_IN_HAND_OFFSET_X
#undef DEFAULT_IN_HAND_OFFSET_Y
