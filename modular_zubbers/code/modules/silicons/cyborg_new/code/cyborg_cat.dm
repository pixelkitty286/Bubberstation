/*
* A test mob to replace cyborg mobs
*
* Robocats are the test version of new cyborg code
*
*
*/

/mob/living/silicon/robocat/Initialize(mapload)
	spark_system = new /datum/effect_system/spark_spread()
	spark_system.set_up(5, 0, src)
	spark_system.attach(src)


/mob/living/silicon/robocat/create_modularInterface()
	if(!modularInterface)
		modularInterface = new /obj/item/modular_computer/pda/silicon/cyborg(src)
		modularInterface.imprint_id(job_name = "F3-LINE")
	return ..()



