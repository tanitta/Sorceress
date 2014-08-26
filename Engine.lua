namespace"trit"{
namespace"model"{
namespace"sorceress"{
	class "Engine"{
		metamethod"_init"
		:body(function(self)
			self.sensors = {};
			self.inputs = {};
			self.modes = {};
			self.val = {};
			self.TCS_FL = trit_Component.TCS_typeR:new(0.6)
			self.TCS_FR = trit_Component.TCS_typeR:new(0.6)
			self.TCS_RL = trit_Component.TCS_typeR:new(0.6)
			self.TCS_RR = trit_Component.TCS_typeR:new(0.6)
			self.numOriginPower = 70000;

-- 			torqueSplitRatio = (x, y) -1<=x<=1,-1<=y<=1
--			+:front
--			-:rear
			self.torqueSplitRatio = {x = 0, y = -0.8;}
		end);

		method"initTCS"
		:body(function(self)

		end);

		method "SetSensors"
		:body(function(self,sensors)
			self.sensors = sensors;
		end);

		method"SetInputs"
		:body(function(self,inputs)
			self.inputs = inputs;
		end);

		method"SetPerHandle"
		:body(function(self,per)
			self.inputs.perHandle = per;
		end);

		method"SetModes"
		:body(function(self,modes)
			self.modes = modes;
		end);

		method"GetVal"
		:body(function(self,str)
			return self.val[str]
		end);
		metamethod"__call"
		:body(function(self)
			self.TCS_FL:SetInput(self.sensors.flRoot.lvz, self.sensors.fl.nwy)
			self.TCS_FR:SetInput(self.sensors.frRoot.lvz, -self.sensors.fr.nwy)

			self.TCS_RL:SetInput(-self.sensors.rlRoot.lvz, self.sensors.rl.nwy)
			self.TCS_RR:SetInput(-self.sensors.rrRoot.lvz, -self.sensors.rr.nwy)

			self.TCS_FL()
			self.TCS_FR()
			self.TCS_RL()
			self.TCS_RR()

			local powMain=self.inputs.accel*(7.337*math.abs(self.sensors.core.lvz)^2 + 508.7*math.abs(self.sensors.core.lvz) ) + (1654 +self.numOriginPower*2)*self.inputs.accel
			self.val.fl=powMain*(1-self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_FL:GetOutput()*(1+self.torqueSplitRatio.y)*(1-self.modes.flight)
			self.val.fr=powMain*(1+self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_FR:GetOutput()*(1+self.torqueSplitRatio.y)*(1-self.modes.flight)
			self.val.rl=powMain*(1-self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_RL:GetOutput()*(1-self.torqueSplitRatio.y)*(1-self.modes.flight)
			self.val.rr=powMain*(1+self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_RR:GetOutput()*(1-self.torqueSplitRatio.y)*(1-self.modes.flight)
		end);
	};
};
};
};
