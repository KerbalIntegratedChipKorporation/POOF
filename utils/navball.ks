// navball.ks
// Gets the angle values represented by the navball.

@lazyglobal off.

// Gets the vector towards the east.
function _Navball_GetEastVec
{
	return VectorCrossProduct(ship:up:vector, ship:north:vector).
}

function Navball_GetCompass
{
	local pointing is ship:facing:forevector.
	local east is _Navball_GetEastVec().
	
	local trigX is vdot(ship:north:vector, pointing).
	local trigY is vdot(east, pointing).
	
	local result is arctan2(trigY, trigX).
	
	if result < 0
	{
		return 360 + result.
	}
	else
	{
		return result.
	}
}

function Navball_GetPitch
{
	return 90 - vang(ship:up:vector, ship:facing:forevector).
}

function Navball_GetRoll
{
	if vang(ship:facing:vector, ship:up:vector) < 0.2
	{
		return 0.
	}
	else
	{
		local raw is vang(vxcl(ship:facing:vector, ship:up:vector), ship:facing:starvector).
		
		if vang(ship:up:vector, ship:facing:topvector) > 90
		{
			if raw > 90
			{
				return 270 - raw.
			}
			else
			{
				return -90 - raw.
			}
		}
		else
		{
			return raw - 90.
		}
	}
}