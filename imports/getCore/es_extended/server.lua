if not lib.player then lib.player() end

return function(resource)
	local ESX = exports[resource]:getSharedObject()
	-- Eventually add some functions here to simplify the creation of framework-agnostic resources.

	local CPlayer = lib.getPlayer()

	function lib.getPlayer(player)
		player = type(player) == 'table' and player.playerId or ESX.GetPlayerFromId(player)

		if not player then
			error(("'%s' is not a valid player"):format(player))
		end

		return setmetatable(player, CPlayer)
	end

	function CPlayer:hasGroup(filter)
		local type = type(filter)
		local job = self.getJob()
		
		if type == 'string' then
			if job.name == filter and job.onDuty then
				return job.name, job.grade
			end
		else
			local tabletype = table.type(filter)

			if tabletype == 'hash' then
				local grade = filter[job.name]

				if grade and grade <= job.grade and job.onDuty then
					return job.name, job.grade
				end
			elseif tabletype == 'array' then
				for i = 1, #filter do
					if job.name == filter[i] and job.onDuty then
						return job.name, job.grade
					end
				end
			end
		end
	end

	return ESX
end
