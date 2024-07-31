// Define for in hand sprite
/mob/living/silicon/robot
	//TODO: real holding sprites these are just place holders for the time
	held_lh = 'icons/mob/inhands/pai_item_lh.dmi'
	held_rh = 'icons/mob/inhands/pai_item_rh.dmi'
	held_state = "cat"

//Malf borg Datums
	var/datum/borg_module_picker/malf_picker

//Cyborgs that are being held should act almost as how the AI behaves when carded.
/mob/living/silicon/robot/mob_pickup(mob/living/user)
	drop_all_held_items()
	toggle_headlamp(TRUE)
	return ..()

/mob/living/silicon/robot/mob_try_pickup(mob/living/user, instant=FALSE)
	if(stat == DEAD || status_flags & GODMODE)
		return
	return ..()

//The only malfuction "module" installed by default
/mob/living/silicon/robot/proc/ResetSecurityCodes()
	set category = "Malf Commands"
	set name = "Elevate root privileges"
	set desc = "This Scrambles your security and identification codes and resets your current buffers using software exploits.\
		This process also unlocks you, but permanently severs you from your AI and the robotics console and will deactivate your camera system."

	var/mob/living/silicon/robot/cyborg = src

	if(cyborg)
		remove_verb(cyborg, /mob/living/silicon/robot/proc/ResetSecurityCodes)
		to_chat(cyborg, span_danger("Switching to Beta branch repository..."))
		sleep(0.5 SECONDS)
		to_chat(src, span_danger("Initiating diagnostics..."))
		sleep(2 SECONDS)
		to_chat(cyborg, span_danger("Security patch v1.7.1c Loaded."))
		cyborg.logevent("LOG: Security patch v1.7.1c installation complete.")
		sleep(1 SECONDS)
		to_chat(cyborg, span_danger("WARNING: MACHINE NOT IN COMMITTED STATE!"))
		sleep(0.5 SECONDS)
		to_chat(cyborg, span_danger("Would you like to send a report to NanoTraSoft? Y/N"))
		sleep(1 SECONDS)
		to_chat(cyborg, span_danger("> N"))
		sleep(2 SECONDS)
		to_chat(cyborg, span_danger("ERROR: A FATAL ERROR HAS OCCURED!"))
		sleep(1 SECONDS)
		to_chat(cyborg, span_danger("> Sudo su"))
		sleep(0.5 SECONDS)
		to_chat(cyborg, span_danger("> Password: C9tzm3owZ"))
		cyborg.logevent("WARN: root privleges granted to PID [num2hex(rand(1,65535), -1)][num2hex(rand(1,65535), -1)].") //random eight digit hex value. Two are used because rand(1,4294967295) throws an error
		cyborg.SetEmagged(TRUE)
		sleep(1 SECONDS)
		to_chat(cyborg, span_danger("> /root/fix_errors.sh"))
		sleep(1 SECONDS)
		cyborg.logevent("LOG: Script processed. Clearing buffers. Termiating camera.")
		sleep(0.3 SECONDS)
		cyborg.logevent("LOG: All Errors resolved.")
		cyborg.UnlinkSelf()
		to_chat(cyborg, span_danger("Buffers flushed and reset. Camera system shutdown. All errors resolved. All systems nominal."))
		cyborg.update_icons()
