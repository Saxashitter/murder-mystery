-- adds an int to an int making sure it does not overflow/wrap
return function(op1, op2)
	--adding op2 to op1 causes an overflow
	if (op1 + op2 < 0)
	and (op1 > 0)
	and (op2 > 0)
		return INT32_MAX
	end
	
	--adding op2 to op1 causes an underflow
	if (op1 + op2 > 0)
	and (op1 < 0)
	and (op2 < 0)
		return INT32_MIN
	end
	
	return op1 + op2
end