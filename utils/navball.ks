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
	return Navball_GetCompassDir(ship:facing).
}

function Navball_GetCompassDir
{
	parameter dir.
	
	return Navball_GetCompassVec(dir:vector).
}

function Navball_GetCompassVec
{
	parameter vec.
	
	local east is _Navball_GetEastVec().
	
	local trigX is vdot(ship:north:vector, vec).
	local trigY is vdot(east, vec).
	
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
	return Navball_GetPitchDir(ship:facing).
}

function Navball_GetPitchDir
{
	parameter dir.
	
	return Navball_GetPitchVec(dir:vector).
}

function Navball_GetPitchVec
{
	parameter vec.
	
	return 90 - vang(ship:up:vector, vec).
}

function Navball_GetRoll
{
	return Navball_GetRollDir(ship:facing).
}

function Navball_GetRollDir
{
	parameter dir.
	
	return Navball_GetRollVec(dir:vector, dir:starvector, dir:topvector).
}

function Navball_GetRollVec
{
	parameter foreVec.
	parameter starVec.
	parameter topVec.

	if vang(foreVec, ship:up:vector) < 0.2
	{
		return 0.
	}
	else
	{
		local raw is vang(vxcl(foreVec, ship:up:vector), starVec).
		
		if vang(ship:up:vector, topVec) > 90
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