// list.ks

function LIST_IndexOf
{
	parameter lst.
	parameter value.
	
	set i to lst:iterator.
	until not i:next
	{
		if i:value = value
		{
			return i:index.
		}
	}
	
	return -1.
}