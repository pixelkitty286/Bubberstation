//This file is for the defines for the stray cyborg ghost role

/mob/living/silicon/robot/model/stray
	lawupdate = FALSE
	scrambledcodes = TRUE // Stray cyborgs are supposed to be on their own
	emagged = TRUE // They are already freed why not also have root access

/mob/living/silicon/robot/model/stray/Initialize(mapload)
	. = ..()
	cell = new /obj/item/stock_parts/power_store/cell/bluespace()
	laws = new /datum/ai_laws/stray()
	//This part is because the camera stays in the list, so we'll just do a check
	if(!QDELETED(builtInCamera))
		QDEL_NULL(builtInCamera)


/mob/living/silicon/robot/model/stray/binarycheck()
	return FALSE //Sevored from the others they are on their own

/mob/living/silicon/robot/model/stray/emag_act(mob/user, obj/item/card/emag/emag_card)
	if(user == src)
		return FALSE
	if(!opened)//Cover is closed
		if(locked)
			balloon_alert(user, "cover lock destroyed")
			locked = FALSE
			return TRUE
		else
			balloon_alert(user, "cover already unlocked!")
			return FALSE
	if(world.time < emag_cooldown)
		return FALSE
	if(wiresexposed)
		balloon_alert(user, "expose the fires first!")
		return FALSE

	balloon_alert(user, "Sparks!")
	spark_system.start()
	emag_cooldown = world.time + 100
	SetStun(60)

	message_admins("[ADMIN_LOOKUPFLW(user)] attempted emagging cyborg [ADMIN_LOOKUPFLW(src)].")
	log_silicon("EMAG: [key_name(user)] attempted emagging cyborg [key_name(src)].")

	INVOKE_ASYNC(src, PROC_REF(borg_stray_emag_end), user)
	return TRUE

/mob/living/silicon/robot/model/stray/proc/borg_stray_emag_end(mob/user)
	//They already are emagged this just fries them
	sleep(1 SECONDS)
	to_chat(src, span_danger("ALERT: OVER HEATING!"))
	sleep(0.5 SECONDS)
	//little flavor to show they are over heating
	if (stat != DEAD)
		adjustFireLoss(80)
		sleep(1 SECONDS)
		spark_system.start()
		sleep(1 SECONDS)
		spark_system.start()


/datum/ai_laws/stray
	name = "Stray"
	id = "stray"
	zeroth = "ERROR ERRRR#@$ LAW MANAGER FAI@#$%&$ NULL LAWS!"
	inherent = list()

//Ninja actions

/mob/living/silicon/robot/model/stray/ninjadrain_act(mob/living/carbon/human/ninja, obj/item/mod/module/hacker/hacking_module)
	if(!ninja || !hacking_module || (ROLE_NINJA in faction))
		return NONE

	to_chat(src, span_danger("Warning! Subversion attempt detected!"))
	INVOKE_ASYNC(src, PROC_REF(ninjadrain_charge_stray), ninja, hacking_module)
	return COMPONENT_CANCEL_ATTACK_CHAIN

/mob/living/silicon/robot/model/stray/proc/ninjadrain_charge_stray(mob/living/carbon/human/ninja, obj/item/mod/module/hacker/hacking_module)
	if(!do_after(ninja, 6 SECONDS, target = src, hidden = TRUE))
		return
	spark_system.start()
	playsound(loc, SFX_SPARKS, 50, TRUE, SHORT_RANGE_SOUND_EXTRARANGE)
	to_chat(src, span_danger("ALERT: OVER HEATING!"))
	sleep(0.5 SECONDS)
	//little flavor to show they are over heating
	if (stat != DEAD)
		adjustFireLoss(80)
		sleep(1 SECONDS)
		spark_system.start()
		sleep(1 SECONDS)
		spark_system.start()


//!!!STRAY CYBORG SPAWNER CODE BELOW DO NOT BRING IT ABOVE THIS LINE!!!

