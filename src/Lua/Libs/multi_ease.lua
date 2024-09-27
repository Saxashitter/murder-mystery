return function (ease, ease2, t, start, mid, finish)
	if finish == nil then finish = start end
	if t < FU then
		return ease(t, start, mid)
	else
		return ease2(t, mid, finish)
	end
end