local Math = {}

--// CONSTANTS //--

--// VARIABLES //--

--// FUNCTIONS //--

function Math.Lerp(x, y, a)
	return x + (y - x) * a
end

return Math
