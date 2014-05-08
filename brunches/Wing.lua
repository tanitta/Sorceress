namespace"trit"{
namespace"model"{
namespace"sorceress"{
	class "Wing"{
		metamethod"_init"
		:body(function(self)
			self.val = {};
			self.inputs = {};
			self.sensors = {};
			self.modes = {}
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
		
		method"Z"
		:body(function(self)
			self.val.fl=180-(37+5+self.sensors.core.lvz*0.22)*(1+self.inputs.perHandle*0.2)*self.modes.flight*(1-self.inputs.normalBrake)  - 67.5 *self.inputs.normalBrake- 0 *self.inputs.sideBrake
			self.val.fr=180-(37+5+self.sensors.core.lvz*0.22)*(1-self.inputs.perHandle*0.2)*self.modes.flight*(1-self.inputs.normalBrake)   - 67.5 *self.inputs.normalBrake- 0*self.inputs.sideBrake 
			self.val.rl=0-(33+5+self.sensors.core.lvz*0.22)*(1+self.inputs.perHandle*0.2)*self.modes.flight*(1-self.inputs.normalBrake)  - 67.5 *self.inputs.normalBrake- 0 *self.inputs.sideBrake 
			self.val.rr=0-(33+5+self.sensors.core.lvz*0.22)*(1-self.inputs.perHandle*0.2)*self.modes.flight*(1-self.inputs.normalBrake)  - 67.5 *self.inputs.normalBrake- 0 *self.inputs.sideBrake

			do
				local Pitch = (self.inputs.pitch*20+self.sensors.core.wx*5)
				local Roll = (self.inputs.roll*20+self.sensors.core.wz*5)
				self.val.fl = self.val.fl + (1-self.modes.flight)*( - Roll - Pitch ) 
				self.val.fr = self.val.fr + (1-self.modes.flight)*(Roll - Pitch)
				self.val.rl = self.val.rl + (1-self.modes.flight)*(- Roll + Pitch )
				self.val.rr = self.val.rr + (1-self.modes.flight)*(Roll + Pitch )
			end
			
			if self.modes.flight == 1 then
				local gain1 = 0.6
				local gain2 = 40
				if _H(self.sensors.flRoot) >gain1 then
					self.val.fl = self.val.fl - limit((_H(self.sensors.flRoot)-gain1)*gain2*1.3,0,10*1.3)
				end
				if _H(self.sensors.frRoot) >gain1 then
					self.val.fr = self.val.fr - limit((_H(self.sensors.frRoot)-gain1)*gain2*1.3,0,10*1.3)
				end
				if _H(self.sensors.rlRoot) >gain1 then
					self.val.rl = self.val.rl - limit((_H(self.sensors.rlRoot)-gain1)*gain2,0,10)
				end
				if _H(self.sensors.rrRoot) >gain1 then
					self.val.rr = self.val.rr - limit((_H(self.sensors.rrRoot)-gain1)*gain2,0,10)
				end
			else
				self.val.fl = self.val.fl - 30
				self.val.fr = self.val.fr - 30
				self.val.rl = self.val.rl - 30
				self.val.rr = self.val.rr - 30
				
			end
		end);
		
		method"X"
		:body(function(self)
		end);
		
		metamethod"__call"
		:body(function(self)
			self:Z();
		end);
	};
};
};
};