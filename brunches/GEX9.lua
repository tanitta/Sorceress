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
			self.val.fl = 0;
			self.val.fr = 0;
			self.val.rl = 0;
			self.val.rr = 0;
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

			local gain1 = 8
			local gain2 = 1000
			local gain3 = 200
			
			local target = self.inputs.accel*gain1
			
			self.val.fl = self.val.fl+(target*0.7+self.TCS_FL:GetSlip())*gain2
			self.val.fr = self.val.fr+(target*0.7+self.TCS_FR:GetSlip())*gain2
			self.val.rl = self.val.rl+(target*1.3+self.TCS_RL:GetSlip())*gain2
			self.val.rr = self.val.rr+(target*1.3+self.TCS_RR:GetSlip())*gain2
			
			-- self.val.fl = pid(0,(target+self.TCS_FL:GetSlip()*0.7),{gain2,gain3,0},{-8,8})
			-- self.val.fr = pid(0,(target+self.TCS_FR:GetSlip()*0.7),{gain2,gain3,0},{-8,8})
			-- self.val.rl = pid(0,(target+self.TCS_RL:GetSlip()*1.3),{gain2,gain3,0},{-8,8})
			-- self.val.rr = pid(0,(target+self.TCS_RR:GetSlip()*1.3),{gain2,gain3,0},{-8,8})
			
			out(0,self.TCS_FL:GetSlip())
			out(1,self.TCS_FR:GetSlip())
			out(2,self.TCS_RL:GetSlip())
			out(3,self.TCS_RR:GetSlip())
		end);
	};
};
};
};