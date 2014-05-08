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
			self:UnitInit("Engine")
			self.Engine:SetModes(self.Mode:GetModes())
			self:cOut("...loaded Engine");
			
			self:UnitInit("Wing")
			self.Wing:SetModes(self.Mode:GetModes())
			self:cOut("...loaded Wing");
			
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
			
			self.Engine:SetPerHandle(self.Steering:GetVal("perM"));
			
			self:Engine();
			
			self:Wing();
			
			self:cOut(tostring(_FPS()));
			
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

			-- _A_WING_SFL = self:GetAngWing("SFL")
			-- _A_WING_SFR = self:GetAngWing("SFR")
			-- _A_WING_SRL = self:GetAngWing("SRL")
			-- _A_WING_SRR = self:GetAngWing("SRR")

			-- _A_WING_SM = self:GetAngWing("SM")


			_P_FL = self.Engine:GetVal("fl")
			_P_FR = self.Engine:GetVal("fr")
			_P_RL = self.Engine:GetVal("rl")
			_P_RR = self.Engine:GetVal("rr")

			-- _B_FL = self:GetBraWheel("FL")
			-- _B_FR = self:GetBraWheel("FR")
			-- _B_RL = self:GetBraWheel("RL")
			-- _B_RR = self:GetBraWheel("RR")
			
			-- --Material
			-- _C_BODY_1 = self:GetColMaterial("Body_1")
			-- _C_BODY_2 = self:GetColMaterial("Body_2")
			-- _C_BODY_3 = self:GetColMaterial("Body_3")
			-- _C_CARBON = self:GetColMaterial("Carbon")
			-- _C_FRAME = self:GetColMaterial("Frame")
			-- _C_GLASS = self:GetColMaterial("Glass")
			-- _C_WHEEL = self:GetColMaterial("Wheel")

			-- _C_LIGHT_1 = self:GetColMaterial("Light_1")
			-- _C_LIGHT_2 = self:GetColMaterial("Light_2")

			-- _C_BRAKECALIPER = self:GetColMaterial("BrakeCaliper")

			-- _C_SHEET_1 = self:GetColMaterial("Sheet_1")
			-- _C_SHEET_2 = self:GetColMaterial("Sheet_2")

			-- _E_BODY_1 = self:GetEffMaterial("Body_1")
			-- _E_BODY_2 = self:GetEffMaterial("Body_2")
			-- _E_BODY_3 = self:GetEffMaterial("Body_3")
			-- _E_CARBON = self:GetEffMaterial("Carbon")
			-- _E_FRAME = self:GetEffMaterial("Frame")
			-- _E_GLASS = self:GetEffMaterial("Glass")
			-- _E_WHEEL = self:GetEffMaterial("Wheel")

			-- _E_LIGHT_1 = self:GetEffMaterial("Light_1")
			-- _E_LIGHT_2 = self:GetEffMaterial("Light_2")

			-- _C_BRAKEROTOR_FL = self:GetColMaterial("BrakeRotor_FL")
			-- _C_BRAKEROTOR_FR = self:GetColMaterial("BrakeRotor_FR")
			-- _C_BRAKEROTOR_RL = self:GetColMaterial("BrakeRotor_RL")
			-- _C_BRAKEROTOR_RR = self:GetColMaterial("BrakeRotor_RR")

			-- _E_BRAKEROTOR_FL = self:GetEffMaterial("BrakeRotor_FL")
			-- _E_BRAKEROTOR_FR = self:GetEffMaterial("BrakeRotor_FR")
			-- _E_BRAKEROTOR_RL = self:GetEffMaterial("BrakeRotor_RL")
			-- _E_BRAKEROTOR_RR = self:GetEffMaterial("BrakeRotor_RR")
		
		end);
		
		method"Draw"
		:attributes(override)
		:body(function(self)
		end);
		
	};
};
};
};