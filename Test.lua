do
	function deepcopy(orig)
		local orig_type = type(orig)
		local copy
		if orig_type == 'table' then
			copy = {}
			for orig_key, orig_value in next, orig, nil do
				copy[deepcopy(orig_key)] = deepcopy(orig_value)
			end
			setmetatable(copy, deepcopy(getmetatable(orig)))
		else -- number, string, boolean, etc
			copy = orig
		end
		return copy
	end
	function table.copy(t)
		local u = { }
		for k, v in pairs(t) do u[k] = v end
		return setmetatable(u, getmetatable(t))
	end
	table.deepcopy = deepcopy
end
namespace "trit"{
	namespace "model"{
		namespace "sorceress"{
			class "Gene"{
				metamethod"_init"
				:body(function(self,range, ticks)
					self.range = range --max speed [m/s]
					self.ticks = ticks --m/s

					self.wingAngle = {}
					self.enginePower = {}
					self.score = 0

					for i = 0, self.range/self.ticks do
						self.wingAngle[i] = {n = 38-i*10*0.22, s = 4}
						local np = (7.337*i*10)^2 + 508.7*i*10 + 1654 + 70000*2
						np = limit(np, 20000,1300000)
						self.enginePower[i] = {n = np, s = 4}
					end
				end);

				method "GetAngleValue"
				:body(function(self,x)
					local index = math.floor(x / self.ticks)
					if x<0 then
						return self.wingAngle[0].n
					elseif x >= self.range then
						return self.wingAngle[table.getn(self.wingAngle)].n
					else
						local a = (self.wingAngle[index+1].n - self.wingAngle[index].n)/self.ticks

						local b = self.wingAngle[index].n
						return a*(x-index*self.ticks) + b
					end
				end);

				method "GetPowerValue"
				:body(function(self,x)
					local index = math.floor(x / self.ticks)
					if x<0 then
						return self.enginePower[0].n
					elseif x >= self.range then
						return self.enginePower[table.getn(self.enginePower)].n
					else
						local a = (self.enginePower[index+1].n - self.enginePower[index].n)/self.ticks
						local b = self.enginePower[index].n
						return a*(x-index*self.ticks) + b
					end
				end);

				metamethod"__call"
				:body(function(self)
				end);
			};

			class "Test"{
				metamethod"_init"
				:body(function(self)
					self.inputs = {};
					self.inputs.handle = 0;
					self.inputs.accel = 0;
					self.inputs.normalBrake = 0;
					self.inputs.sideBrake = 0;
					self.inputs.deff = 0;
					self.inputs.roll = 0;
					self.inputs.pitch = 0;
					self.inputs.snowMode = 0;

					self.sensors = {};

					self.range = 140--max speed [m/s]
					self.ticks = 10

					self.globalSigma = 1

					self.maxSamples = 8
					self.maxScore = 400
					self.generations = 0

					self.isViewGraph = true

					--per 1 generation
					self.tmpData = {}
					self.bestGene = trit.model.sorceress.Gene:new(self.range,self.ticks)
					self.bestGene.score = self.maxScore-1

					table.insert(self.tmpData,trit.model.sorceress.Gene:new(self.range,self.ticks))
					self.tmpData[table.getn(self.tmpData)].score = self.maxScore
				end);

				method"GetInputs"
				:body(function(self)
					return self.inputs
				end);

				method "SetSensors"
				:body(function(self,sensors)
					self.sensors = sensors;
				end);
				method "GaussianRandom"
				:body(function(self,sigma,mu)
					-- InitMTRand(_NTICKS()+GetTickCount()+seed)
					local r1 = MTRandReal()
					local r2 = MTRandReal()

					return sigma*(-2*math.log(r1))^0.5 * math.cos(2*math.pi*r2) + mu
				end);

				method "InitGeneration"
				:body(function(self)
					local bestIndex = 1
					for i = 1, table.getn(self.tmpData) do
						if self.tmpData[i].score<=self.tmpData[bestIndex].score then
							bestIndex = i
						end
					end
					-- self.bestGene = trit.model.sorceress.Gene:new(self.range,self.ticks)
					--
					-- self.bestGene.score = self.tmpData[bestIndex].score
					-- self:SetBestGene(self.tmpData[bestIndex])
					-- out(0, self.tmpData[bestIndex].score)
					self.bestGene = table.deepcopy(self.tmpData[bestIndex])
					self.tmpData = {}
					table.insert(self.tmpData,self.bestGene)
				end);

				method "AddTmpGene"
				:body(function(self)
					table.insert(self.tmpData,trit.model.sorceress.Gene:new(self.range, self.ticks))
					local n = table.getn(self.tmpData)
					for i = 0, self.range/self.ticks do
						-- self.tmpData[n].wingAngle[i].s = self.bestGene.wingAngle[i].s + self:GaussianRandom(self.globalSigma,0)
						self.tmpData[n].wingAngle[i].n = self.bestGene.wingAngle[i].n + 0.5*self:GaussianRandom(self.tmpData[n].wingAngle[i].s,0)
						self.tmpData[n].wingAngle[i].n = limit(self.tmpData[n].wingAngle[i].n, 0,45)

						self.tmpData[n].enginePower[i].n = self.bestGene.enginePower[i].n + 20000 * self:GaussianRandom(self.tmpData[n].enginePower[i].s,0)
						self.tmpData[n].enginePower[i].n = limit(self.tmpData[n].enginePower[i].n, 15000,1400000)
					end
				end);

				method "TestScore"
				:body(function(self)
					self.inputs.accel = limit(self.inputs.accel+0.1,0,1)--ang(self.inputs.accel,1,0.2)
					self.inputs.handle = 0
					self.inputs.normalBrake = 0
					if math.abs(self.sensors.core.lvz)>self.range then
						self.inputs.accel = 0
						self.inputs.handle = 0
						return true
					else
						return false
					end
				end);

				method "SetScore"
				:body(function(self,score)
					self.tmpData[table.getn(self.tmpData)].score = score
				end);

				method "SetBestGene"
				:body(function(self,t)
					self.bestGene = t
				end);

				method "GetGene"
				:body(function(self)
					return self.tmpData[table.getn(self.tmpData)]
					-- return self.bestGene
				end);

				method "IsRange"
				:body(function(self, x, z, r)
					local d = ((x-self.sensors.core.x)^2+(z-self.sensors.core.z)^2)^0.5
					if d > r then
						return false
					else
						return true
					end
				end);

				method "ConvertGlobalToLocal"
				:body(function(self,wx,wy,wz,cn)
					local lx=_XX(cn)*wx+_XY(cn)*wy+_XZ(cn)*wz
					local ly=_YX(cn)*wx+_YY(cn)*wy+_YZ(cn)*wz
					local lz=_ZX(cn)*wx+_ZY(cn)*wy+_ZZ(cn)*wz
					return lx,ly,lz
				end);

				method "Move"
				:body(function(self,x,z,r)
					local d = ((x-self.sensors.core.x)^2+(z-self.sensors.core.z)^2)^0.5
					local lx,ly,lz = self:ConvertGlobalToLocal(x-self.sensors.core.x,40,z-self.sensors.core.z,0)
					local rad = limit(math.deg(math.atan2(lx,-lz)*1),-30,30)

					self.inputs.normalBrake = 0
					self.inputs.accel = limit(math.abs(d),0,20)/100
					-- self.inputs.handle = rad/20
					local drad = rad/30 - self.inputs.handle
					self.inputs.handle = ang(self.inputs.handle, drad, math.abs(limit(drad,-0.05,0.05)))

					if self:IsRange(x,z,r) then
						self.inputs.accel = 0
						self.inputs.handle = 0
						-- self.inputs.normalBrake = 1
						return true
					else
						return false
					end
				end);

				method "Stop"
				:body(function(self)
					local vx = self.sensors.core.vx
					local vy = self.sensors.core.vy
					local vz = self.sensors.core.vz
					local v = (vx^2+vy^2+vz^2)^0.5
					self.inputs.accel = 0
					self.inputs.handle = limit(self.inputs.handle,0,1)
					self.inputs.normalBrake = self.inputs.normalBrake + 0.01
					self.inputs.normalBrake = limit(self.inputs.normalBrake, 0, 0.5)
					if v > 1 then
						return false
					else


						return true
					end
				end);

				method "CoroutineBlock"
				:body(coroutine.wrap(function(self, func, p)
					local f = false
					while not f do
						f = func(self,unpack(p))
						coroutine.yield()
					end

					while true do
						coroutine.yield()
					end
				end));

				method "TestCo"
				:body(coroutine.wrap(function(self)
					local counter = 0
					while counter < 30*1 do
						out(1,"Wait")
						self.inputs.normalBrake = 0
						counter = counter + 1
						coroutine.yield()
					end
					while true do
						self:InitGeneration()
						while table.getn(self.tmpData) < self.maxSamples do


							self:AddTmpGene()
							local scoresPerGene = {}
							for i = 1, 8 do
								local f = false
								while not f do
									out(1,"Move")
									f = self:Move(0,0,10)
									coroutine.yield()
								end


								local f = false
								local counter = 0
								while not f or counter < 30*3 do
									out(1,"Stop")
									f = self:Stop()
									counter = counter + 1
									coroutine.yield()
								end

								local counter = 0
								while counter < 30*1 do
									out(1,"Wait")
									self.inputs.normalBrake = 0
									counter = counter + 1
									coroutine.yield()
								end


								local f = false
								local score = 0
								while not f and score < self.maxScore do
									out(1,"TestScore",math.abs(self.sensors.core.lvz))
									f = self:TestScore()
									score = score + 1
									coroutine.yield()
								end
								-- self.bestGene.score = score
								table.insert(scoresPerGene,score)

								local f = false
								local counter = 0
								while not f or counter < 30*1 do
									out(1,"Stop")
									out(5,"score : ", score)
									f = self:Stop()
									counter = counter + 1
									coroutine.yield()
								end
							end

							--calc avg
							local avgScore = 0
							for i = 1, table.getn(scoresPerGene) do
								avgScore = avgScore + scoresPerGene[i]
							end

							self:SetScore(avgScore/table.getn(scoresPerGene))

						end
						self.generations = self.generations + 1
					end
					while not false do
						out(1,"Wait...")
						coroutine.yield()
					end
				end));

				metamethod"__call"
				:body(function(self)
					self:TestCo()
					-- out(2,self.tmpData[table.getn(self.tmpData)]:GetAngleValue(-self.sensors.core.lvz))
					out(3,"generations : ",self.generations)
					out(4,"tmpDatas : ",table.getn(self.tmpData))
					out(6,"dcore : ",self.bestGene.score)

					function MoveTo(x, y)
						_MOVE2D(get_regulated_pos(x, y));
					end

					function LineTo(x, y)
						_LINE2D(get_regulated_pos(x, y));
					end

					if _KEYDOWN(4) == 1 then
						self.isViewGraph = not self.isViewGraph
					end

					if self.isViewGraph then
						_SETCOLOR(hsv(0,0,1))
						MoveTo(100,0)
						LineTo(100,100)
						LineTo(100+140*2,100)

						for i = 1, table.getn(self.tmpData) do
							_SETCOLOR(hsv(0,0,0.8*i/table.getn(self.tmpData)))
							MoveTo(100,100-self.tmpData[i]:GetAngleValue(0)*2)
							for x = 0,140 do
								local y = self.tmpData[i]:GetAngleValue(x)
								LineTo(x*2+100,-y*2+100)
							end
						end

						--bestGent
						_SETCOLOR(hsv(0,1,1))
						MoveTo(100,100-self.bestGene:GetAngleValue(0)*2)
						for x = 0,140 do
							local y = self.bestGene:GetAngleValue(x)
							LineTo(x*2+100,-y*2+100)
						end



						_SETCOLOR(hsv(0,0,1))
						MoveTo(100,100)
						LineTo(100,200)
						LineTo(100+140*2,200)
						local scale = 30000
						for i = 1, table.getn(self.tmpData) do
							_SETCOLOR(hsv(0,0,0.8*i/table.getn(self.tmpData)))
							MoveTo(100,200-self.tmpData[i]:GetPowerValue(0)/scale*2)
							for x = 0,140 do
								local y = self.tmpData[i]:GetPowerValue(x)/scale
								LineTo(x*2+100,-y*2+200)
							end
						end

						--bestGent
						_SETCOLOR(hsv(0,1,1))
						MoveTo(100,200-self.bestGene:GetPowerValue(0)/scale*2)
						for x = 0,140 do
							local y = self.bestGene:GetPowerValue(x)/scale
							LineTo(x*2+100,-y*2+200)
						end
					end
				end);


			}
		}--sorceress
	}--model
}--trit
