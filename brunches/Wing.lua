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
			self.val.sm = 90;
			self.val.sfl = 90;
			self.val.sfr = 90;
			self.val.srl = 90;
			self.val.srr = 90;
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
			self.val.fl=180-(37+5+self.sensors.core.lvz*0.22)*(1+self.inputs.perHandle*0.2)*(1-self.modes.flight)*(1-self.inputs.normalBrake)  - 67.5 *self.inputs.normalBrake- 0 *self.inputs.sideBrake
			self.val.fr=180-(37+5+self.sensors.core.lvz*0.22)*(1-self.inputs.perHandle*0.2)*(1-self.modes.flight)*(1-self.inputs.normalBrake)   - 67.5 *self.inputs.normalBrake- 0*self.inputs.sideBrake 
			self.val.rl=0-(33+5+self.sensors.core.lvz*0.22)*(1+self.inputs.perHandle*0.2)*(1-self.modes.flight)*(1-self.inputs.normalBrake)  - 67.5 *self.inputs.normalBrake- 0 *self.inputs.sideBrake 
			self.val.rr=0-(33+5+self.sensors.core.lvz*0.22)*(1-self.inputs.perHandle*0.2)*(1-self.modes.flight)*(1-self.inputs.normalBrake)  - 67.5 *self.inputs.normalBrake- 0 *self.inputs.sideBrake

			do
				local Pitch = (self.inputs.pitch*20+self.sensors.core.wx*5)
				local Roll = (self.inputs.roll*20+self.sensors.core.wz*5)
				self.val.fl = self.val.fl + (self.modes.flight)*( - Roll - Pitch ) 
				self.val.fr = self.val.fr + (self.modes.flight)*(Roll - Pitch)
				self.val.rl = self.val.rl + (self.modes.flight)*(- Roll + Pitch )
				self.val.rr = self.val.rr + (self.modes.flight)*(Roll + Pitch )
			end
			
			if self.modes.flight == 0 then
				local gain1 = 0.6
				local gain2 = 40
				if _H(self.sensors.flRoot) >gain1 then
					self.val.fl = self.val.fl-30--self.val.fl - limit((_H(self.sensors.flRoot)-gain1)*gain2*1,0,10)
				end
				if _H(self.sensors.frRoot) >gain1 then
					self.val.fr = self.val.fr-30--self.val.fr - limit((_H(self.sensors.frRoot)-gain1)*gain2*1,0,10)
				end
				if _H(self.sensors.rlRoot) >gain1 then
					self.val.rl = self.val.rl-30--self.val.rl - limit((_H(self.sensors.rlRoot)-gain1)*gain2,0,10)
				end
				if _H(self.sensors.rrRoot) >gain1 then
					self.val.rr = self.val.rr-30--self.val.rr - limit((_H(self.sensors.rrRoot)-gain1)*gain2,0,10)
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
			do
				local vx = limit(math.abs(self.sensors.core.lvz)/10*2,2,99999999999999)
				local perMuK = 1
				-- out(0,"th = ",math.deg(math.pi/4+math.atan(1/perMuK)/2))
				local angSideDF = 90-math.deg(math.pi/4+math.atan(1/perMuK)/2)
				if self.sensors.core.lvx<-vx then
					self.val.sfl = ang(self.val.sfl, 90+angSideDF, 10*(1-self.modes.flight))
					self.val.sfr = ang(self.val.sfr, 90-angSideDF, 10*(1-self.modes.flight))
				elseif self.sensors.core.lvx>vx then
					self.val.sfl = ang(self.val.sfl, 90-angSideDF, 10*(1-self.modes.flight))
					self.val.sfr = ang(self.val.sfr, 90+angSideDF, 10*(1-self.modes.flight))
				else
					self.val.sfl = ang(self.val.sfl, 90, 10)
					self.val.sfr = ang(self.val.sfr, 90, 10)
				end
			
				
				if _VX(0)<-vx then
					self.val.sm = ang(self.val.sm, 90-angSideDF, 10*(1-self.modes.flight))
				elseif _VX(0)>vx then
					self.val.sm = ang(self.val.sm, 90+angSideDF, 10*(1-self.modes.flight))
				else
					self.val.sm = ang(self.val.sm, 90, 10)
				end

				if _VX(0)<-vx then
					self.val.srl = ang(self.val.srl, 90+angSideDF, 10*(1-self.modes.flight))
					self.val.srr = ang(self.val.srr, 90-angSideDF, 10*(1-self.modes.flight))
				elseif _VX(0)>vx then
					self.val.srl = ang(self.val.srl, 90-angSideDF, 10*(1-self.modes.flight))
					self.val.srr = ang(self.val.srr, 90+angSideDF, 10*(1-self.modes.flight))
				else
					self.val.srl = ang(self.val.srl, 90, 10)
					self.val.srr = ang(self.val.srr, 90, 10)
				end
				
			end
				
			self.val.sm = self.val.sm*(1-self.modes.flight) + 90*self.modes.flight
			self.val.sfl = self.val.sfl*(1-self.modes.flight) + 90*self.modes.flight
			self.val.sfr = self.val.sfr*(1-self.modes.flight) + 90*self.modes.flight
			self.val.srl = self.val.srl*(1-self.modes.flight) + 90*self.modes.flight
			self.val.srr = self.val.srr*(1-self.modes.flight) + 90*self.modes.flight

			self.val.sm = self.val.sm*(1-self.modes.snow) + 90*self.modes.snow
			self.val.sfl = self.val.sfl*(1-self.modes.snow) + 90*self.modes.snow 
			self.val.sfr = self.val.sfr*(1-self.modes.snow) + 90*self.modes.snow
			self.val.srl = self.val.srl*(1-self.modes.snow) + 90*self.modes.snow
			self.val.srr = self.val.srr*(1-self.modes.snow) + 90*self.modes.snow
		end);
		
		metamethod"__call"
		:body(function(self)
			self:Z();
			self:X();
			
		end);
	};
};
};
};