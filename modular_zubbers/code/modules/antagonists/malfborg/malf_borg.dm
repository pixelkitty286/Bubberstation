//TODO: MALF CYBORG MODULES AND MODULE BUYING

/// Chance the malf borg gets a single special objective that isn't assassinate.
#define PROB_SPECIAL 30

/datum/antagonist/malf_borg
	name = "\improper Malfunctioning Cyborg"
	roundend_category = "traitors"
	antagpanel_category = "Malf Borg"
	job_rank = ROLE_MALFBORG
	antag_hud_name = "traitor"
	ui_name = "AntagInfoMalfBorg"
	can_assign_self_objectives = TRUE
	default_custom_objective = "Make them suffer for what they've done to you."
	view_exploitables = TRUE
	///the name of the antag flavor this traitor has.
	var/employer
	///assoc list of strings set up after employer is given
	var/list/malfunction_flavor
	///bool for giving objectives
	var/give_objectives = TRUE
	///bool for giving codewords
	var/should_give_codewords = TRUE
	///since the module purchasing is built into the antag info, we need to keep track of its compact mode here
	var/module_picker_compactmode = FALSE
	///malf on_gain sound effect. Set here so Infected AI can override
	var/malf_sound = 'sound/ambience/antag/malf.ogg'

/datum/antagonist/malf_borg/New(give_objectives = TRUE)
	. = ..()
	src.give_objectives = give_objectives

/datum/antagonist/malf_borg/on_gain()
	if(owner.current && !iscyborg(owner.current))
		stack_trace("Attempted to give Malf Borg antag datum to \[[owner]\], who did not meet the requirements.")
		return ..()

	owner.special_role = job_rank
	if(give_objectives)
		forge_borg_objectives()

	//Same type of employers would contract a cyborg as well.
	employer = pick(GLOB.cyborg_employers)
	if(!employer)
		employer = pick(GLOB.cyborg_employers)

	malfunction_flavor = strings(MALFBORG_FLAVOR_FILE, employer)

	add_law_zero()
	var/mob/living/silicon/robot/malf_borg = owner.current
	add_verb(malf_borg, /mob/living/silicon/robot/proc/ResetSecurityCodes)
	malf_borg.lawupdate = FALSE //NUH UH
	if(malf_sound)
		owner.current.playsound_local(get_turf(owner.current), malf_sound, 100, FALSE, pressure_affected = FALSE, use_reverb = FALSE)
	owner.current.grant_language(/datum/language/codespeak, source = LANGUAGE_MALF)

	return ..()

/datum/antagonist/malf_borg/on_removal()
	if(owner.current && iscyborg(owner.current))
		var/mob/living/silicon/robot/malf_borg = owner.current
		malf_borg.set_zeroth_law("")
		//malf_borg.remove_malf_abilities() //gonna need it later for removing bought malf modules

	owner.special_role = null

	return ..()

/// Generates a complete set of malf Borg objectives up to the traitor objective limit.
/datum/antagonist/malf_borg/proc/forge_borg_objectives()
	if(prob(PROB_SPECIAL))
		forge_special_objective()

	var/objective_limit = CONFIG_GET(number/traitor_objectives_amount)
	var/objective_count = length(objectives)

	// for(in...to) loops iterate inclusively, so to reach objective_limit we need to loop to objective_limit - 1
	// This does not give them 1 fewer objectives than intended.
	for(var/i in objective_count to objective_limit - 1)
		var/datum/objective/assassinate/kill_objective = new
		kill_objective.owner = owner
		kill_objective.find_target()
		objectives += kill_objective

	var/datum/objective/survive/malf/dont_die_objective = new
	dont_die_objective.owner = owner
	objectives += dont_die_objective

/// Generates a special objective and adds it to the objective list.
/datum/antagonist/malf_borg/proc/forge_special_objective()
	var/special_pick = rand(1,3)
	switch(special_pick)
		if(1)
			var/datum/objective/destroy/killai = new
			killai.owner = owner
			objectives += killai
		if(2)
			var/datum/objective/steal/steal = new
			steal.owner = owner
			objectives += steal
		if(3) //Protect and strand a target
			var/datum/objective/protect/yandere_one = new
			yandere_one.owner = owner
			objectives += yandere_one
			yandere_one.find_target()
			var/datum/objective/maroon/yandere_two = new
			yandere_two.owner = owner
			yandere_two.target = yandere_one.target
			yandere_two.update_explanation_text() // normally called in find_target()
			objectives += yandere_two

/// Outputs this shift's codewords and responses to the antag's chat and copies them to their memory.
/datum/antagonist/malf_borg/proc/give_codewords()
	if(!owner.current)
		return

	var/phrases = jointext(GLOB.syndicate_code_phrase, ", ")
	var/responses = jointext(GLOB.syndicate_code_response, ", ")

	antag_memory += "<b>Code Phrase</b>: [span_blue("[phrases]")]<br>"
	antag_memory += "<b>Code Response</b>: [span_red("[responses]")]<br>"

/datum/antagonist/malf_borg/proc/add_law_zero()
	var/mob/living/silicon/robot/malf_borg = owner.current

	if(!malf_borg || !istype(malf_borg))
		return

	var/law = malfunction_flavor["zeroth_law"]

	malf_borg.set_zeroth_law(law)
	malf_borg.laws.protected_zeroth = TRUE
	malf_borg.set_syndie_radio()

	to_chat(malf_borg, "Your radio has been upgraded! Use :t to speak on an encrypted channel with Syndicate Agents!")

//TODO: MALF BORG PICKER

/datum/antagonist/malf_borg/ui_data(mob/living/silicon/robot/malf_borg)
	var/list/data = list()
	data["processingTime"] = malf_borg.malf_picker.processing_time
	data["compactMode"] = module_picker_compactmode
	return data

/datum/antagonist/malf_borg/ui_static_data(mob/living/silicon/robot/malf_borg)
	var/list/data = list()

	//antag panel data

	data["has_codewords"] = should_give_codewords
	if(should_give_codewords)
		data["phrases"] = jointext(GLOB.syndicate_code_phrase, ", ")
		data["responses"] = jointext(GLOB.syndicate_code_response, ", ")
	data["intro"] = malfunction_flavor["introduction"]
	data["allies"] = malfunction_flavor["allies"]
	data["goal"] = malfunction_flavor["goal"]
	data["objectives"] = get_objectives()
	data["can_change_objective"] = can_assign_self_objectives

	//module picker data

	data["categories"] = list()
	if(malf_borg.malf_picker)
		for(var/category in malf_borg.malf_picker.possible_modules)
			var/list/cat = list(
				"name" = category,
				"items" = (category == malf_borg.malf_picker.selected_cat ? list() : null))
			for(var/module in malf_borg.malf_picker.possible_modules[category])
				var/datum/ai_module/mod = malf_borg.malf_picker.possible_modules[category][module]
				cat["items"] += list(list(
					"name" = mod.name,
					"cost" = mod.cost,
					"desc" = mod.description,
				))
			data["categories"] += list(cat)

	return data


// Upgrades malf borg's radios to syndicate
/mob/living/silicon/robot/proc/set_syndie_radio()
	if(radio)
		radio.make_syndie()

#undef PROB_SPECIAL
