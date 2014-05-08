namespace"trit"{
namespace"model"{
namespace"sorceress"{
	class"BaseComponent"{
		field"val"
		:attributes(static)
		:init({});
    	metamethod"_init"
    	:body(function(self)
    	end);

    	metamethod"__call"
    	:body(function(self)
    	end);
	};
	
	class "Core"
	:inherits(trit.spine.BaseDriver)
	:description("SorceressControlUnit"){
		field"strName"
		:attributes(static)
		:init("Sorceress");
	
		method"UnitInit"
		:body(function(self,strName)
			self[strName] = trit.model.sorceress[strName]:new();
			self[strName]:SetSensors(self.Sensor:GetSensors());
			self[strName]:SetInputs(self.Input:GetInputs());
		end);
	
		method"Init"
		:attributes(override)
		:body(function(self)
			self.Input = trit.model.sorceress.Input:new();
			self:cOut("...loaded Input");
			
			self.Sensor = trit.model.sorceress.Sensor:new();
			self.Sensor:SetChipName("core",0);
			self.Sensor:SetChipName("fl",_G["_N_FL"]);
			self.Sensor:SetChipName("fr",_G["_N_FR"]);
			self.Sensor:SetChipName("rl",_G["_N_RL"]);
			self.Sensor:SetChipName("rr",_G["_N_RR"]);
			self.Sensor:SetChipName("flRoot",_G["_N_FL"]-1);
			self.Sensor:SetChipName("frRoot",_G["_N_FR"]-1);
			self.Sensor:SetChipName("rlRoot",_G["_N_RL"]-1);
			self.Sensor:SetChipName("rrRoot",_G["_N_RR"]-1);
			self:cOut("...loaded Sensor");

			self:UnitInit("Mode")
			self:cOut("...loaded Mode");

			self:UnitInit("Steering")
			self.Steering:SetModes(self.Mode:GetModes())
			self:cOut("...loaded Steering");
			
			self.Engines = {};
			self.Engines[1] = trit.model.sorceress.Engine:new();
			self.Engines[1]:SetSensors(self.Sensor:GetSensors());
			self.Engines[1]:SetInputs(self.Input:GetInputs());
			self.Engines[1]:SetModes(self.Mode:GetModes())
			self.numEngine = 1
			self:cOut("...loaded Engine");
			
			self:UnitInit("Wing")
			self.Wing:SetModes(self.Mode:GetModes())
			self:cOut("...loaded Wing");
			
			self:UnitInit("Brake")
			self.Brake:SetModes(self.Mode:GetModes())
			self:cOut("...loaded Brake");
			
			self:UnitInit("Material")
			self.Material:SetModes(self.Mode:GetModes())
			self.Material:SetColor();
			
			self:cOut("...loaded Material");
			
			self:cOut("...loaded Sorceress Driver");
		end);
		
		method"Input"
		:body(function(self)
		end);
		
		method"Call"
		:attributes(override)
		:body(function(self)
			self:Input();
			self:Sensor();
			self:Mode()
			self:Steering();
			
			self.Engines[self.numEngine]:SetPerHandle(self.Steering:GetVal("perM"));
			self.Engines[self.numEngine]();
			
			self:Wing();
			self:Brake();
			
			self.Material:SetBrake("fl",self.Brake:GetVal("fl"))
			self.Material:SetBrake("fr",self.Brake:GetVal("fr"))
			self.Material:SetBrake("rl",self.Brake:GetVal("rl"))
			self.Material:SetBrake("rr",self.Brake:GetVal("rr"))
			self:Material();
		end);
		
		method"Value"
		:attributes(override)
		:body(function(self)
			_A_HANDLE_FL = self.Steering:GetVal("fl")
			_A_HANDLE_FR = self.Steering:GetVal("fr")
			_A_HANDLE_RL = self.Steering:GetVal("rl")
			_A_HANDLE_RR = self.Steering:GetVal("rr")

			_A_WING_FL = self.Wing:GetVal("fl")
			_A_WING_FR = self.Wing:GetVal("fr")
			_A_WING_RL = self.Wing:GetVal("rl")
			_A_WING_RR = self.Wing:GetVal("rr")
			
			_A_WING_SFL = self.Wing:GetVal("sfl")
			_A_WING_SFR = self.Wing:GetVal("sfr")
			_A_WING_SRL = self.Wing:GetVal("srl")
			_A_WING_SRR = self.Wing:GetVal("srr")
			_A_WING_SM = self.Wing:GetVal("sm")

			_P_FL = self.Engines[self.numEngine]:GetVal("fl")
			_P_FR = self.Engines[self.numEngine]:GetVal("fr")
			_P_RL = self.Engines[self.numEngine]:GetVal("rl")
			_P_RR = self.Engines[self.numEngine]:GetVal("rr")

			_B_FL = self.Brake:GetVal("fl")
			_B_FR = self.Brake:GetVal("fr")
			_B_RL = self.Brake:GetVal("rl")
			_B_RR = self.Brake:GetVal("rr")
			
			_C_BODY_1 = self.Material:GetVal("_C_body1")
			_C_BODY_2 = self.Material:GetVal("_C_body2")
			_C_BODY_3 = self.Material:GetVal("_C_body3")
			_C_CARBON = self.Material:GetVal("_C_carbon")
			_C_FRAME = self.Material:GetVal("_C_frame")
			_C_GLASS = self.Material:GetVal("_C_glass")
			_C_SHEET_1 = self.Material:GetVal("_C_sheet1")
			_C_SHEET_2 = self.Material:GetVal("_C_sheet2")
			_C_WHEEL = self.Material:GetVal("_C_wheel")
			_C_BRAKECALIPER = self.Material:GetVal("_C_brakeCaliper")
			_C_LIGHT_2 = self.Material:GetVal("_C_light2")
			
			_E_BODY_1 = self.Material:GetVal("_E_body1")
			_E_BODY_2 = self.Material:GetVal("_E_body2")
			_E_BODY_3 = self.Material:GetVal("_E_body3")
			_E_CARBON = self.Material:GetVal("_E_carbon")
			_E_FRAME = self.Material:GetVal("_E_frame")
			_E_GLASS = self.Material:GetVal("_E_glass")
			_E_SHEET_1 = self.Material:GetVal("_E_sheet1")
			_E_SHEET_2 = self.Material:GetVal("_E_sheet2")
			_E_WHEEL = self.Material:GetVal("_E_wheel")
			_E_BRAKECALIPER = self.Material:GetVal("_E_brakeCaliper")
			_E_LIGHT_2 = self.Material:GetVal("_E_light2")
			
			_C_LIGHT_1 = self.Material:GetVal("_C_light1")
			_E_LIGHT_1 = self.Material:GetVal("_E_light1")

			_C_BRAKEROTOR_FL = self.Material:GetVal("_C_brakeRotorFL")
			_C_BRAKEROTOR_FR = self.Material:GetVal("_C_brakeRotorFR")
			_C_BRAKEROTOR_RL = self.Material:GetVal("_C_brakeRotorRL")
			_C_BRAKEROTOR_RR = self.Material:GetVal("_C_brakeRotorRR")

			_E_BRAKEROTOR_FL = self.Material:GetVal("_E_brakeRotorFL")
			_E_BRAKEROTOR_FR = self.Material:GetVal("_E_brakeRotorFR")
			_E_BRAKEROTOR_RL = self.Material:GetVal("_E_brakeRotorRL")
			_E_BRAKEROTOR_RR = self.Material:GetVal("_E_brakeRotorRR")
		end);
		
		method"Draw"
		:attributes(override)
		:body(function(self)
		end);
		
	};
};
};
};