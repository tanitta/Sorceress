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
		
		method"GetVal"
		:body(function(self,str)
			return self.val[str]
		end);
		metamethod"__call"
		:body(function(self)
		self.numOriginPower = limit(self.numOriginPower + 4000*(_KEY(7)-_KEY(4)),0,400000)
				-- do
				-- 	out(2,"■TCS_Output : ",(self.TCS_FL:GetOutput()+self.TCS_FR:GetOutput()+self.TCS_RL:GetOutput()+self.TCS_RR:GetOutput())/4)
				-- 	local str = ""
				-- 	for i = 1,(self.TCS_FL:GetOutput()+self.TCS_FR:GetOutput()+self.TCS_RL:GetOutput()+self.TCS_RR:GetOutput())/4*40 do
				-- 		str = str..">"
				-- 	end
					
				-- 	for i = 1,40-(self.TCS_FL:GetOutput()+self.TCS_FR:GetOutput()+self.TCS_RL:GetOutput()+self.TCS_RR:GetOutput())/4*40 do
				-- 		str = str.."-."
				-- 	end
					
				-- 	out(3,str)
				-- end
				-- do
				-- 	out(4,"■OrignPower : ",self.numOriginPower/400000*100,"%")
				-- 	local str = ""
				-- 	for i = 1,self.numOriginPower/400000*40 do
				-- 		str = str..">"
				-- 	end
					
				-- 	for i = 1,40-self.numOriginPower/400000*40 do
				-- 		str = str.."-."
				-- 	end
					
				-- 	out(5,str)
				-- end
			self.TCS_FL:SetInput(self.sensors.flRoot.lvz, self.sensors.fl.nwy)
			self.TCS_FR:SetInput(self.sensors.frRoot.lvz, -self.sensors.fr.nwy)
			self.TCS_RL:SetInput(-self.sensors.rlRoot.lvz, self.sensors.rl.nwy)
			self.TCS_RR:SetInput(-self.sensors.rrRoot.lvz, -self.sensors.rr.nwy)
			
			-- self.TCS_FL:SetInput(_VZ(_N_FL-1),self.sensors.fl.nwy)
			-- self.TCS_FR:SetInput(_VZ(_N_FR-1),-self.sensors.fr.nwy)
			-- self.TCS_RL:SetInput(-_VZ(_N_RL-1),self.sensors.rl.nwy)
			-- self.TCS_RR:SetInput(-_VZ(_N_RR-1),-self.sensors.rr.nwy)
			
			self.TCS_FL()
			self.TCS_FR()
			self.TCS_RL()
			self.TCS_RR()
			
			-- local powMain=self.inputs.accel*1200*0.9;

			-- self.val.fl=powMain*(1-self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_FL:GetOutput()*0.7*1.5 *(self.sensors.fl.nwy+100)
			-- self.val.fr=powMain*(1+self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_FR:GetOutput()*0.7*1.5 *(-self.sensors.fr.nwy+100)

			-- self.val.rl=powMain*(1-self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_RL:GetOutput()*1.3*1.5 *(self.sensors.rl.nwy+100)
			-- self.val.rr=powMain*(1+self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_RR:GetOutput()*1.3*1.5 *(-self.sensors.rr.nwy+100)
			local powMain=self.inputs.accel*(7.337*math.abs(self.sensors.core.lvz)^2 + 508.7*math.abs(self.sensors.core.lvz) ) + (1654 +self.numOriginPower*2)*self.inputs.accel
			--local powMain=self.inputs.accel*240000
			self.val.fl=powMain*(1-self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_FL:GetOutput()*0.7
			self.val.fr=powMain*(1+self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_FR:GetOutput()*0.7

			self.val.rl=powMain*(1-self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_RL:GetOutput()*1.3
			self.val.rr=powMain*(1+self.inputs.perHandle*(0.3+self.inputs.deff*0.7))*self.TCS_RR:GetOutput()*1.3
			out(0,self.sensors.fl.wy)
			out(1,self.sensors.fr.wy)
			out(2,self.sensors.rl.wy)
			out(3,self.sensors.rr.wy)
		end);
	};
};
};
};