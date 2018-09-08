// listutil.ks

function List_IndexOf
{
	parameter l.
	parameter item.

	if l:contains(item)
	{
		from { local i is 0. } until i = l:length step { set i to i + 1. } do
		{
			if l[i] = item { return i. }
		}
	}
	
	return -1.
}