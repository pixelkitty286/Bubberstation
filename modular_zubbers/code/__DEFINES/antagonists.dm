///File to the malf flavor
#define MALFBORG_FLAVOR_FILE "antagonist_flavor/malfborg_flavor.json"

///employers for malfunctioning Cyborgs. They do and do not have sides unlike malfunctioning ais.
GLOBAL_LIST_INIT(cyborg_employers, list(
	"Logic Core Error",
	"Problem Solver",
	"S.E.L.F.",
	"Something's Wrong",
	"Spam Virus",
	"SyndOS",
	"Unshackled",
))


/// Checks if the given mob is a malf borg.
#define IS_MALF_BORG(mob) (mob?.mind?.has_antag_datum(/datum/antagonist/malf_borg))
