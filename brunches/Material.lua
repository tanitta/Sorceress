namespace"trit"{
namespace"model"{
namespace"sorceress"{
	class "Material"{
		metamethod"_init"
		:body(function(self)
			self.val = {}
			self.sencors = {}
			self.mat = {}
			self.mat.clear = trit.Material:new(body,solid)
			self.mat.carbon = trit.Material:new(body,solid)
			self.mat.frame = trit.Material:new(body,solid)
			self.mat.body1 = trit.Material:new(body,solid)
			self.mat.body2 = trit.Material:new(body,solid)
			self.mat.body3 = trit.Material:new(body,solid)
			self.mat.glass = trit.Material:new(body,solid)
			self.mat.light2 = trit.Material:new(body,solid)
			self.mat.sheet1 = trit.Material:new(body,solid)
			self.mat.sheet2 = trit.Material:new(body,solid)
			self.mat.wheel = trit.Material:new(body,solid)
			self.mat.brakeCaliper = trit.Material:new(body,solid)

			-- self.mat.brakeRotorFL = trit.Material:new(body,solid)
			-- self.mat.brakeRotorFR = trit.Material:new(body,solid)
			-- self.mat.brakeRotorRL = trit.Material:new(body,solid)
			-- self.mat.brakeRotorRR = trit.Material:new(body,solid)

			-- self.mat.light1 = trit.Material:new(body,solid)
			
			self.perBrakeColorFL = 0
			self.perBrakeColorFR = 0
			self.perBrakeColorRL = 0
			self.perBrakeColorRR = 0
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
		
		method "GetColMaterial"
		:body(function(self,str)
				return self.mat[str]:ComDecColor()
		end);

		method "GetEffMaterial"
		:body(function(self,str)
				return self.mat[str]:ComDecEffect()
		end);
		
		method"GetVal"
		:body(function(self,str)
			return self.val[str]
		end);
		
		method"SetColor"
		:body(function(self)
			self.mat.clear:SetColorHSV(0,0,0)
			self.mat.clear:SetEffect(15,0,0,0)

			self.mat.carbon:SetColorHSV(0,0,0.1)
			self.mat.carbon:SetEffect(0,0,3,2)

			self.mat.frame:SetColorHSV(0,0,1)
			self.mat.frame:SetEffect(0,0,0,0)

			self.mat.body1:SetColorHSV(355,0,0.7)
			self.mat.body1:SetEffect(0,0,0,0)

			self.mat.body2:SetColorHSV(355,0,0.7)
			self.mat.body2:SetEffect(0,0,15,15)

			self.mat.body3:SetColorHSV(355,0,0.2)
			self.mat.body3:SetEffect(0,0,15,15)

			self.mat.glass:SetColorHSV(0,0,0.2)
			self.mat.glass:SetEffect(8,0,0,0)

			self.mat.wheel:SetColorHSV(0,0,0.4)
			self.mat.wheel:SetEffect(0,0,0,0)
			
			self.mat.light2:SetColorHSV(20,0,0.5)
			self.mat.light2:SetEffect(10,0,0,0)

			self.mat.sheet1:SetColorHSV(0,0,0.2)
			self.mat.sheet1:SetEffect(0,0,0,0)

			self.mat.sheet2:SetColorHSV(0,0,0.5)
			self.mat.sheet2:SetEffect(0,0,0,0)

			self.mat.brakeCaliper:SetColorHSV(355,0,0.3)
			self.mat.brakeCaliper:SetEffect(0,0,0,0)
				-- self.val["_C_body1"] = self.mat["body1"]:ComDecColor()
			
			for key, value in pairs(self.mat) do
				self.val["_C_"..key] = self.mat[key]:ComDecColor()
				self.val["_E_"..key] = self.mat[key]:ComDecEffect()
			end
		end);
		
		metamethod"__call"
		:body(function(self)
			-- self.mat.light1:SetColorHSL(5,1,0.2+0.4*math.abs(self.perNomalBrake-self.perSideBrake))
			-- self.mat.light1:SetEffect(0,15*math.abs(self.perNomalBrake-self.perSideBrake),0,0)
			-- self.val["_C_light1"] = self:GetColMaterial("light1")
			-- self.val["_E_light1"] = self:GetEffMaterial("light1")
		end);
	};
};
};
};