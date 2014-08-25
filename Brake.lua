namespace"trit"{
namespace"model"{
namespace"sorceress"{
	class "Brake"{
		metamethod"_init"
		:body(function(self)
			self.val = {};
			self.inputs = {};
			self.sensors = {};
			self.modes = {}
			
			self.ABS_FL = trit_Component.ABS_typeR:new(0.6)
			self.ABS_FR = trit_Component.ABS_typeR:new(0.6)
			self.ABS_RL = trit_Component.ABS_typeR:new(0.6)
			self.ABS_RR = trit_Component.ABS_typeR:new(0.6)
			self.ABS_FL:SetParameter(2,0.05)
			self.ABS_FR:SetParameter(2,0.05)
			self.ABS_RL:SetParameter(2,0.05)
			self.ABS_RR:SetParameter(2,0.05)
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
	
		method"GetVal"
		:body(function(self,str)
			return self.val[str]
		end);
		
		metamethod"__call"
		:body(function(self)
			self.ABS_FL:SetInput(-self.sensors.core.lvz, self.sensors.fl.nwy)
			self.ABS_FR:SetInput(-self.sensors.core.lvz, -self.sensors.fr.nwy)
			self.ABS_RL:SetInput(-self.sensors.core.lvz, self.sensors.rl.nwy)
			self.ABS_RR:SetInput(-self.sensors.core.lvz, -self.sensors.rr.nwy)

			self.ABS_FL()
			self.ABS_FR()
			self.ABS_RL()
			self.ABS_RR()

			local ib_m=0

			local ib_l=math.max(self.inputs.perHandle,0) *ib_m
			local ib_r=-math.min(self.inputs.perHandle,0)*ib_m
			
			self.val.fl=( self.inputs.normalBrake*800 + self.inputs.sideBrake*150 )*self.ABS_FL:GetOutput() + ib_l
			self.val.fr=( self.inputs.normalBrake*800 + self.inputs.sideBrake*150 )*self.ABS_FR:GetOutput() + ib_r
			self.val.rl=( self.inputs.normalBrake*800 + self.inputs.sideBrake*500 )*self.ABS_RL:GetOutput() + ib_l
			self.val.rr=( self.inputs.normalBrake*800 + self.inputs.sideBrake*500 )*self.ABS_RR:GetOutput() + ib_r
		end);
	};
};
};
};