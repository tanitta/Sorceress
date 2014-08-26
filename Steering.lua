namespace"trit"{
namespace"model"{
namespace"sorceress"{
	class "Steering"{
		metamethod"_init"
		:body(function(self)
			self.val = {perM = 0, fl = 180, fr = 180, rl = 0, rr = 0}
			self.sensors = {};
			self.inputs = {};
			self.modes = {};
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

		method"SetModes"
		:body(function(self,modes)
			self.modes = modes;
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
			local velXExp = 0
			velXExp = 1-math.exp(-math.abs(self.sensors.core.lvz/2))
			velXExp = limit(velXExp,0,1)
			local angM = 0
			do
				local verX = pid(
					0,
					(self.sensors.core.nwy*14*velXExp+self.inputs.handle*80),
					{0.5,0.15*1.5,0.04*1.5},
					--{0.2,0,0},
					{-8,8}
				)
				angM = math.atan2(verX*1,limit(math.abs(self.sensors.core.lvz),30*3.6,999999))*180/math.pi
			end
			self.val.perM = angM/30

			local angTo_F = 1
			self.val.fl = (angM-angTo_F)*(1-self.modes.flight)+180
			self.val.fr = (angM+angTo_F)*(1-self.modes.flight)+180

			local angTo_R = 1
			self.val.rl = (angTo_R+math.deg(math.atan2(self.sensors.core.lvx/10*1.1,limit(-self.sensors.core.lvz,10,9999999999))))*(1-self.modes.flight)
			self.val.rr = (angTo_R-math.deg(math.atan2(self.sensors.core.lvx/10*1.1,limit(-self.sensors.core.lvz,10,9999999999))))*(1-self.modes.flight)
		end);
	};
};
};
};
