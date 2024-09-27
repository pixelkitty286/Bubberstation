/// The datum and interface for the malf unlock menu, which lets them choose actions to unlock.
/datum/borg_module_picker
	var/name = "Malfunction Modules Menu"
	var/selected_cat
	var/compact_mode = FALSE
	var/processing_time = 50
	var/list/possible_modules

/datum/borg_module_picker/New()
	possible_modules = get_malf_modules()

/proc/cmp_malfborg_modules_priority(datum/cyborg_module/A, datum/cyborg_module/B)
	return B.cost - A.cost

/proc/get_malfborg_modules()
	var/list/filtered_modules = list()

	for(var/path in GLOB.malf_modules)
		var/datum/cyborg_module/AM = new path
		if(!AM.upgrade)
			continue
		if(!filtered_modules[AM.category])
			filtered_modules[AM.category] = list()
		filtered_modules[AM.category][AM] = AM

	for(var/category in filtered_modules)
		sortTim(filtered_modules[category], GLOBAL_PROC_REF(cmp_malfborg_modules_priority))

	return filtered_modules

/datum/borg_module_picker/ui_state(mob/user)
	return GLOB.always_state

/datum/borg_module_picker/ui_interact(mob/user, datum/tgui/ui)
	ui = SStgui.try_update_ui(user, src, ui)
	if(!ui)
		ui = new(user, src, "MalfunctionModulePicker", name)
		ui.open()

/datum/borg_module_picker/ui_data(mob/user)
	var/list/data = list()
	data["processingTime"] = processing_time
	data["compactMode"] = compact_mode
	return data

/datum/borg_module_picker/ui_static_data(mob/user)
	var/list/data = list()

	data["categories"] = list()
	for(var/category in possible_modules)
		var/list/cat = list(
			"name" = category,
			"items" = (category == selected_cat ? list() : null))
		for(var/module in possible_modules[category])
			var/datum/cyborg_module/AM = possible_modules[category][module]
			cat["items"] += list(list(
				"name" = AM.name,
				"cost" = AM.cost,
				"desc" = AM.description,
			))
		data["categories"] += list(cat)

	return data

/datum/borg_module_picker/ui_act(action, list/params)
	. = ..()
	if(.)
		return
	if(!iscyborg(usr))
		return
	switch(action)
		if("buy")
			var/item_name = params["name"]
			var/list/buyable_items = list()
			for(var/category in possible_modules)
				buyable_items += possible_modules[category]
			for(var/key in buyable_items)
				var/datum/cyborg_module/AM = buyable_items[key]
				if(AM.name == item_name)
					purchase_module(usr, AM)
					return TRUE
		if("select")
			selected_cat = params["category"]
			return TRUE
		if("compact_toggle")
			compact_mode = !compact_mode
			return TRUE

//TODO replace with borg upgrade modules
/datum/borg_module_picker/proc/purchase_module(mob/living/silicon/robot/CYBORG, datum/cyborg_module/AM)
	if(!istype(AM))
		return
	if(!CYBORG || CYBORG.stat == DEAD)
		return
	if(AM.cost > processing_time)
		return

	// Give the power and take away the money.
	if(AM.upgrade) //upgrade and upgrade() are separate, be careful!
		AM.upgrade(CYBORG)
		possible_modules[AM.category] -= AM
		if(AM.unlock_text)
			to_chat(CYBORG, AM.unlock_text)
		if(AM.unlock_sound)
			CYBORG.playsound_local(CYBORG, AM.unlock_sound, 50, 0)
		update_static_data(CYBORG)
	processing_time -= AM.cost
	log_malf_upgrades("[key_name(CYBORG)] purchased [AM.name]")
	SSblackbox.record_feedback("nested tally", "malfunction_modules_bought", 1, list("[initial(AM.name)]", "[AM.cost]"))
