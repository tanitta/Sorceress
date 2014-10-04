namespace "trit"{
	namespace "model"{
		namespace "sorceress"{
			class "Gene"{
				metamethod"_init"
				:body(function(self,range, ticks)
					self.range = range --max speed [m/s]
					self.ticks = ticks --m/s

					self.wingAngle = {}
					self.enginePowor = {}
					self.score = 0
					for i = 0, self.range/self.ticks do
						self.wingAngle[i] = {n = 10*i, s = 1}
						self.enginePowor[i] = {n = 100, s = 1}
					end
				end);

				method "GetAngleValue"
				:body(function(self,x)
					local index = math.floor(x / self.ticks)
					if x<0 then
						return self.wingAngle[0].n
					elseif x > self.range then
						return self.wingAngle[table.getn(self.wingAngle)].n
					else
						local a = (self.wingAngle[index+1].n - self.wingAngle[index].n)/self.ticks
						local b = self.wingAngle[index].n
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
					--per 1 generation
					self.tmpData = {}
					self.bestGene = self.tmpData,trit.model.sorceress.Gene:new(self.range,self.ticks)
					table.insert(self.tmpData,trit.model.sorceress.Gene:new(self.range,self.ticks))

					self.maxSamples = 10
				end);
				method "SetCOut"
				:body(function(self,func)
					self.cOut = func
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
					InitMTRand(_NTICKS())
					local r1 = MTRandReal()
					InitMTRand(_NTICKS()+r1)
					local r2 = MTRandReal()

					return sigma*(-2*math.log(r1))^0.5 * math.cos(2*math.pi*r2) + mu
				end);
				method "InitGeneration"
				:body(function(self)
					local bestIndex = 0
					for i = 0, self.range/ticks do
						if self.tmpData[i].score<self.tmpData[bestIndex].score then
							bestIndex = i
						end
					end
					self.bestGene = self.tmpData[bestGene]
					self.tmpData = {}
				end);

				method "TestScore"
				:body(function(self)
					self.inputs.accel = limit(self.inputs.accel+0.1,0,1)--ang(self.inputs.accel,1,0.2)
					self.inputs.handle = 0
					self.inputs.normalBrake = 0
					if math.abs(self.sensors.core.lvz)>self.range then
						self.inputs.accel = 0
						return true
					else
						return false
					end
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
					local rad = limit(math.deg(math.atan2(lx,-lz)*1),-20,20)
					out(0,d)

						self.inputs.normalBrake = 0
					self.inputs.accel = limit(math.abs(d),0,20)/200
					self.inputs.handle = rad/20

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
					self.inputs.handle = 0
					self.inputs.normalBrake = 1
					if v > 5 then
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
					while true do
						local sampleCounter = 0

						local f = false
						while not f do
							out(1,"Move")
							f = self:Move(0,0,1)
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
						while not f do
							out(1,"TestScore",math.abs(self.sensors.core.lvz))
							f = self:TestScore()
							coroutine.yield()
						end

						local f = false
						local counter = 0
						while not f or counter < 30*1 do
							out(1,"Stop")
							f = self:Stop()
							counter = counter + 1
							coroutine.yield()
						end

						coroutine.yield()
					end
					while not false do
						out(1,"Wait...")
						coroutine.yield()
					end
				end));

				metamethod"__call"
				:body(function(self)
					self:TestCo()
					out(2,self.tmpData[1]:GetAngleValue(-self.sensors.core.lvz))
					out(3,self:GaussianRandom(1,0))
				end);


			}
		}--sorceress
	}--model
}--trit
