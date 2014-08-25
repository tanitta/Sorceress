namespace"trit"{
namespace"model"{
namespace"sorceress"{
	class "Sensor"{
		metamethod"_init"
		:body(function(self)
			self.val = {FL = 180, FR = 180, RL = 0, RR = 0}
			self.sensors = {};
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
		end);
	};
};
};
};