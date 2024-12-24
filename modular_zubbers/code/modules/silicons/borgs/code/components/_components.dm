/**********************************************************************
						Components oh god oh fuck
***********************************************************************/
/*
If you have any bit of sanity do your self a favor and not read how components work all this runs off hopes and dreams!!!!

Components work in several ways:
	1- vital organs for cyborgs
	2 - Armor
	3 Features and functions on a cyborg
*/

/mob/living/silicon/robot/proc/initialize_components()



//the actual physical components for a cyborg
/obj/item/robot_component
	name = "Robotic component"
	desc = "You should not be seeing this contact a coder today!"
	icon = 'modular_zubbers/code/modules/silicons/borgs/sprites/robot_component.dmi'
	icon_state = "working"
	w_class = WEIGHT_CLASS_SMALL
	throwforce = 0
	var/icon_state_broken = "broken"
	/// Random flags that describe this organ
	var/component_flags = ROBOT_COMPONENT_STANDARD | ROBOT_COMPONENT_REPAIRABLE | ROBOT_COMPONENT_USED
	/// Maximum damage the organ can take, ever.
	var/maxHealth = STANDARD_ROBOT_COMPONENT_THRESHOLD
	//How much damage has this component taken?
	var/damage = 0
	//determines if the component is functional or not
	var/functional = FALSE

	var/high_threshold = STANDARD_ROBOT_COMPONENT_THRESHOLD * 0.45 //when severe component damage occurs
	var/low_threshold = STANDARD_ROBOT_COMPONENT_THRESHOLD * 0.1 //when minor component damage occurs

	/obj/item/robot_component/examine(mob/user)
	. = ..()

	if(component_flags & ROBOT_COMPONENT_FAILING)
		. += span_warning("[src] [failing_desc]")
		return

	if(damage > high_threshold)

		. += span_warning("[src] seems to be malfunctioning.")


/obj/item/robot_component/binary_communication_device
	name = "binary communication device"
	desc = "A strange device that seems to allow the cyborgs to communicate to eachother"
	icon_state = "binradio"
	icon_state_broken = "binradio_broken"

/obj/item/robot_component/actuator
	name = "actuator"
	icon_state = "motor"
	icon_state_broken = "motor_broken"

/obj/item/robot_component/armour
	name = "armour plating"
	icon_state = "armor"
	icon_state_broken = "armor_broken"

/obj/item/robot_component/camera
	name = "camera"
	icon_state = "camera"
	icon_state_broken = "camera_broken"

/obj/item/robot_component/diagnosis_unit
	name = "diagnosis unit"
	icon_state = "analyser"
	icon_state_broken = "analyser_broken"

/obj/item/robot_component/radio
	name = "radio"
	icon_state = "radio"
	icon_state_broken = "radio_broken"
