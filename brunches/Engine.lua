namespace"trit"{
namespace"model"{
namespace"sorceress"{
	class "Engine"{
		metamethod"_init"
		:body(function(self)
			self.sensors = {};
			self.inputs = {};
			self.val = {};
			
			self.TCS_FL = trit_Component.TCS_typeR:new(0.6)
			self.TCS_FR = trit_Component.TCS_typeR:new(0.6)
			self.TCS_RL = trit_Component.TCS_typeR:new(0.6)
			self.TCS_RR = trit_Component.TCS_typeR:new(0.6)
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
		method"GetVal"
		:body(function(self,str)
			return self.val[str]
		end);
		metamethod"__call"
		:body(function(self)
			self.TCS_FL:SetInput(self.sensors.flRoot.vz,self.sensors.fl.nwy)
			self.TCS_FR:SetInput(self.sensors.frRoot.vz,-self.sensors.fr.nwy)
			self.TCS_RL:SetInput(-self.sensors.rlRoot.vz,self.sensors.rl.nwy)
			self.TCS_RR:SetInput(-self.sensors.rrRoot.vz,-self.sensors.rr.nwy)
			
			self.TCS_FL()
			self.TCS_FR()
			self.TCS_RL()
			self.TCS_RR()
			
			local powMain=self.inputs.accel*1200*0.9;

			self.val.fl=powMain*(1-self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_FL:GetOutput()*0.7*1.5 *(self.sensors.fl.nwy+100)
			self.val.fr=powMain*(1+self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_FR:GetOutput()*0.7*1.5 *(-self.sensors.fr.nwy+100)

			self.val.rl=powMain*(1-self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_RL:GetOutput()*1.3*1.5 *(self.sensors.rl.nwy+100)
			self.val.rr=powMain*(1+self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_RR:GetOutput()*1.3*1.5 *(-self.sensors.rr.nwy+100)
		end);
	};
};
};
};