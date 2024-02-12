/**
 *  Scruffing, used for small cyborgs
 */
/mob/living

	var/can_be_scruffed = FALSE

//WA WA
/mob/living/MouseDrop_T(atom/dropping, atom/user)
	var/mob/living/U = user
	if(isliving(dropping))
		var/mob/living/M = dropping
		if(M.can_be_scruffed && U.pulling == M)
			return M.mob_try_scruff(U)
	. = ..()

/mob/living/proc/mob_try_scruff(mob/living/user, mob/living/M, instant=FALSE)
	if(!ishuman(user))
		return FALSE
	if(!user.get_empty_held_indexes())
		to_chat(user, span_warning("Your hands are full!"))
		return FALSE
	if(buckled)
		to_chat(user, span_warning("[src] is buckled to something!"))
		return FALSE
	if(!instant)
		user.visible_message(span_warning("[user] starts trying to scruff [src]!"), \
						span_danger("You start trying to scruff [src]..."), null, null, src)
		to_chat(src, span_userdanger("[user] starts trying to scruff you!"))
		if(!do_after(user, 2 SECONDS, target = src))
			return FALSE
	mob_scruff(M)
	return TRUE

/mob/living/proc/mob_scruff(mob/living/carbon/target)
	buckle_mob(target, TRUE, FALSE, RIDER_NEEDS_ARMS)



