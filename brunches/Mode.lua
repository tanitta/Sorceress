namespace"trit"{
namespace"model"{
namespace"sorceress"{
	class "Mode"{
		metamethod"_init"
		:body(function(self)
			self.val = {};
			self.inputs = {};
			self.sensors = {};
			self.modes = {};
		end);
	
		method "SetSensors"
		:body(function(self,sensors)
			self.sensors = sensors;
		end);
		
		method"SetInputs"
		:body(function(self,inputs)
			self.inputs = inputs;
		end);

		method"GetVal"
		:body(function(self,str)
			return self.val[str]
		end);
		
		method"GetModes"
		:body(function(self)
			return self.modes;
		end);
		
		metamethod"__call"
		:body(function(self)
			if  self.inputs.accel < 0.2  and
				(_H(self.sensors.flRoot.cn)>1 or _H(self.sensors.flRoot.cn)<0.2) and
				(_H(self.sensors.frRoot.cn)>1 or _H(self.sensors.frRoot.cn)<0.2) and
				(_H(self.sensors.rlRoot.cn)>1 or _H(self.sensors.rlRoot.cn)<0.2) and
				(_H(self.sensors.rrRoot.cn)>1 or _H(self.sensors.rrRoot.cn)<0.2)
			then
				self.modes.flight=1;
			else
				self.modes.flight=0;
			end
			
			self.modes.snow = 0;
			
			
		end);
	};
};
};
};