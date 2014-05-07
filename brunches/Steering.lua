namespace"trit"{
namespace"model"{
namespace"sorceress"{
	class "Steering"{
		metamethod"_init"
		:body(function(self)
			self.val = {perM = 0, fl = 180, fr = 180, rl = 0, rr = 0}
			self.sensors = {};
			self.inputs = {};
			
			self.perFlightMode = 0;
			
			self.angHandle = {}
		end);
		
		method"GetVal"
		:body(function(self,str)
			return self.val[str]
		end);
	
		method "SetSensors"
		:body(function(self,sensors)
			self.sensors = sensors;
		end);
		
		method"SetInputs"
		:body(function(self,inputs)
			self.inputs = inputs;
		end);

		method "GetAngHandle"
		:body(function(self,str)
			return self.angHandle[str]
		end);

		method "GetPerHandleAngle"
		:body(function(self)
			return self.perHandleAngle
		end);
	
		metamethod"__call"
		:body(function(self)
			local angM =
				pid(
					0,
					(self.sensors.core.wy*20+self.inputs.handle*120),
					{0.3,0.15*1.5,0.04*1.5},
					--{0.2,0,0},
					{-8,8}
				)*(1200-math.abs(_VZ(0)*3.6))/1200*(1-self.perFlightMode)
			
			self.val.perM = angM/30
			
			local angTo_F = 1
			self.val.fl = angM-angTo_F+180
			self.val.fr = angM+angTo_F+180

			local angTo_R = 1
			self.val.rl = angTo_R+math.deg(math.atan2(self.sensors.core.vx/10,limit(-self.sensors.core.vz,10,9999999999))) --/10
			self.val.rr = angTo_R-math.deg(math.atan2(self.sensors.core.vx/10,limit(-self.sensors.core.vz,10,9999999999)))
		end);
	};
};
};
};