//Component defines for Cyborgs. Some of this is based off carbon organs!

//Standard default health each component has before being rendered broken or failing
#define STANDARD_ROBOT_COMPONENT_THRESHOLD 30

/// Are we a standerd type of component?
#define ROBOT_COMPONENT_STANDARD (1<<0)
/// Are we a unusual type of component?
#define ROBOT_COMPONENT_UNUSUAL (1<<1)
/// Failing components act abnomally until repaired or replaced
#define ROBOT_COMPONENT_FAILING (1<<2)
/// EMPed components currently have no function but it could be come something in the future!
#define ROBOT_COMPONENT_EMPED (1<<3)
//TODO: MMI's currently are not considered components and will need to be refactored to be a component
/// MMIs or something to keep them from dying.
#define ROBOT_COMPONENT_VITAL (1<<4)
/// Component is not removable.
#define ROBOT_COMPONENT_UNREMOVABLE (1<<5)
/// Hidden by robotics scanner.
#define ROBOT_COMPONENT_HIDDEN (1<<6)
/// Has this component been used before?
#define ROBOT_COMPONENT_UNUSED (1<<7)
/// Determines if a component is able to be repaired.
#define ROBOT_COMPONENT_REPAIRABLE (1<<8)
