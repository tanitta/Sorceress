namespace"trit"{
	namespace"model"{
		namespace"sorceress"{
			class "Sensor"{
				metamethod"_init"
				:body(function(self)
					self.val = {FL = 180, FR = 180, RL = 0, RR = 0}
					self.sensors = {};

					self.isAdvanced = false

					local nwyCheck = BasePhysic.new(0)
					if nwyCheck.nwy == nil then
						self.isAdvanced = false
					else
						self.isAdvanced = true
					end
				end);

				method"SetChipName"
				:body(function(self,sensorName,chipName)
					-- table.insert(self.names,sensorName)
					self.sensors[sensorName] = BasePhysic.new(chipName);
					-- table.insert(self.sensors,)
				end);

				method"GetSensor"
				:body(function(self,sensorName)
					return self.sensors[sensorName]
				end);

				method"GetSensors"
				:body(function(self,sensorName)
					return self.sensors
				end);

				method"GetVal"
				:body(function(self,str)
					return self.val[str]
				end);

				metamethod"__call"
				:body(function(self)
					for key, value in pairs(self.sensors) do
						self.sensors[key]:Renew()
					end

					if not self.isAdvanced then
						self.sensors.core.nwy = self.sensors.core.wy
						self.sensors.fl.nwy = _WY(self.sensors.fl.cn)
						self.sensors.fr.nwy = _WY(self.sensors.fr.cn)
						self.sensors.rl.nwy = _WY(self.sensors.rl.cn)
						self.sensors.rr.nwy = _WY(self.sensors.rr.cn)
					end
					out(0,self.sensors.fl.nwy)
					out(1,self.sensors.fr.nwy)
					out(2,self.sensors.rl.nwy)
					out(3,self.sensors.rr.nwy)
					out(4,self.isAdvanced)
				end);
			};
		};
	};
};
