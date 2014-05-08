namespace"trit"{
namespace"model"{
namespace"sorceress"{
	class "GEX9"{
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
			self.numOriginPower = limit(self.numOriginPower + 4000*(_KEY(7)-_KEY(4)),0,400000)
			self.TCS_FL:SetInput(self.sensors.flRoot.lvz, self.sensors.fl.nwy)
			self.TCS_FR:SetInput(self.sensors.frRoot.lvz, -self.sensors.fr.nwy)
			self.TCS_RL:SetInput(-self.sensors.rlRoot.lvz, self.sensors.rl.nwy)
			self.TCS_RR:SetInput(-self.sensors.rrRoot.lvz, -self.sensors.rr.nwy)
			
			self.TCS_FL()
			self.TCS_FR()
			self.TCS_RL()
			self.TCS_RR()
			
			local powMain=self.inputs.accel*(7.337*math.abs(self.sensors.core.lvz)^2 + 508.7*math.abs(self.sensors.core.lvz) ) + (1654 +self.numOriginPower*2)*self.inputs.accel

			self.val.fl=powMain*(1-self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_FL:GetOutput()*0.7*(1-self.modes.flight)
			self.val.fr=powMain*(1+self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_FR:GetOutput()*0.7*(1-self.modes.flight)
			self.val.rl=powMain*(1-self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_RL:GetOutput()*1.3*(1-self.modes.flight)
			self.val.rr=powMain*(1+self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_RR:GetOutput()*1.3*(1-self.modes.flight)
			
			local gain1 = 30
			local gain2 = 1000
			local target = self.inputs.accel*gain1
			self.val.fl = self.val.fl+(target+self.TCS_FL:GetSlip())*gain2
			self.val.fr = self.val.fr+(target+self.TCS_FR:GetSlip())*gain2
			self.val.rl = self.val.rl+(target+self.TCS_RL:GetSlip())*gain2
			self.val.rr = self.val.rr+(target+self.TCS_RR:GetSlip())*gain2
			out(0,self.TCS_FL:GetSlip())
		end);
	};
};
};
};