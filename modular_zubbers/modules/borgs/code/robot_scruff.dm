/datum/component/scruff
//Time for when getting scruffed
var/scruff_time = 3 SECONDS
//Check for if the borg is being held or not
var/is_held = FALSE
//Checks for are they gripped by holder
var/is_gripped = FALSE

/datum/component/scruff/Initialize(
	scruff_time = 3 SECONDS,
)

	if(!isliving(parent))
		return COMPONENT_INCOMPATIBLE

	src.scruff_time = scruff_time


/datum/component/scruff/RegisterWithParent()
	RegisterSignal(parent, COMSIG_ATOM_ATTACK_HAND_SECONDARY, PROC_REF(interact_with_scruff))

/datum/component/scruff/proc/try_scruff(mob/living/scruffed_mob, mob/scruffer)
	if(scruffed_mob.stat != CONSCIOUS && !HAS_TRAIT(scruffed_mob, TRAIT_FORCED_STANDING))
		return

	if(pre_tipped_callback?.Invoke(scruffer))
		return

	if(tip_time > 0)
		to_chat(scruffer, span_warning("You begin tipping over [scruffed_mob]..."))
		scruffed_mob.visible_message(
			span_warning("[scruffer] begins scruffing [scruffed_mob]."),
			span_userdanger("[scruffer] begins grabbing you by the scruff!"),
			ignored_mobs = scruffer
		)

		if(!do_after(scruffer, scruff_time, target = scruffed_mob))
			if(!isnull(scruffed_mob.client))
				scruffed_mob.log_message("was attempted to be scruffed by [key_name(scruffer)]", LOG_VICTIM, log_globally = FALSE)
				scruffer.log_message("failed to scruff [key_name(scruffed_mob)]", LOG_ATTACK)
			to_chat(scruffer, span_danger("You fail to scruff [scruffed_mob]."))
			return
	do_tip(scruffed_mob, scruffer)
