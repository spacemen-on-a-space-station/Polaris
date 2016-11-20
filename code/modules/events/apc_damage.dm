/datum/event/apc_damage
	var/apcSelectionRange	= 25

/datum/event/apc_damage/start()
	var/obj/machinery/power/apc/A = acquire_random_apc()

	var/severity_range = 0
	switch(severity)
		if(EVENT_LEVEL_MUNDANE)
			severity_range = 0
		if(EVENT_LEVEL_MODERATE)
			severity_range = 7
		if(EVENT_LEVEL_MAJOR)
			severity_range = 15

	for(var/obj/machinery/power/apc/apc in range(severity_range,A))
		if(is_valid_apc(apc))	//This event disables interactions on the APC interface and bluescreens the APC while
			apc.emagged = 1		//leaving the APC locked. To access the APC the player needs to cut wires. To fix the
			apc.update_icon()	//APC the player needs to open the cover and use a new APC frame on it.

/datum/event/apc_damage/proc/acquire_random_apc()
	var/list/possibleEpicentres = list()
	var/list/apcs = list()

	for(var/obj/effect/landmark/newEpicentre in landmarks_list)
		if(newEpicentre.name == "lightsout")
			possibleEpicentres += newEpicentre

	if(!possibleEpicentres.len)
		return

	var/epicentre = pick(possibleEpicentres)
	for(var/obj/machinery/power/apc/apc in range(epicentre,apcSelectionRange))
		if(is_valid_apc(apc))
			apcs += apc
			// Greatly increase the chance for APCs in maintenance areas to be selected
			var/area/A = get_area(apc)
			if(istype(A,/area/maintenance))
				apcs += apc
				apcs += apc

	if(!apcs.len)
		return

	return pick(apcs)

/datum/event/apc_damage/proc/is_valid_apc(var/obj/machinery/power/apc/apc)
	var/turf/T = get_turf(apc)
	return !apc.is_critical && !apc.emagged && T && (T.z in config.player_levels)
