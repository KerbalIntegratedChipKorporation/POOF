// enum.ks

Include("listutil").

function Enum_GetValue
{
	parameter enum.
	parameter val.
	
	if val:typename = "Scalar"
	{
		return val.
	}
	else
	{
		return List_IndexOf(enum, val).
	}
}

function Enum_CompareValues
{
	parameter enum.
	parameter value1.
	parameter value2.
	
	if Enum_GetValue(enum, value1) = Enum_GetValue(enum, value2)
	{
		return true.
	}
	else
	{
		return false.
	}
}