namespace"trit"{
namespace"model"{
namespace"sorceress"{
	class "Steering"{
		metamethod"_init"
		:body(function(self)
			self.val = {FL = 180, FR = 180, RL = 0, RR = 0}
			self.sensors = {};
		end);
		
		method"GetVal"
		:body(function(self,str)
			return self.val[str]
		end);
	
		method "SetSensors"
		:body(function(self,sensors)
			self.sensors = sensors;
		end);

		method "GetAngHandle"
		:body(function(self,str)
			return self.angHandle[str]
		end);

		method "GetPerHandleAngle"
		:body(function(self)
			return self.perHandleAngle
		end);
	
		metamethod"__call"
		:body(function(self)
			-- self.angHandle.M=
			-- 	pid(
			-- 		0,
			-- 		(self.sensors.core.wy*20+self.perHandleAngle*120),
			-- 		{0.3,0.15*1.5,0.04*1.5},
			-- 		--{0.2,0,0},
			-- 		{-8,8}
			-- 	)*(1200-math.abs(_VZ(0)*3.6))/1200*self.perFlightMode
			
			-- self.perangHandle = self.angHandle.M/30
			
			-- local angTo_F=1
			-- self.angHandle.FL=self.angHandle.M-angTo_F+180 -- -math.deg(math.atan2(_VX(0)/5,limit(-_VZ(0),10,9999999999)))
			-- self.angHandle.FR=self.angHandle.M+angTo_F+180 -- -math.deg(math.atan2(_VX(0)/5,limit(-_VZ(0),10,9999999999)))

			-- local angTo_R=1
			-- self.angHandle.RL=angTo_R+math.deg(math.atan2(_VX(0)/10,limit(-_VZ(0),10,9999999999))) --/10
			-- self.angHandle.RR=angTo_R-math.deg(math.atan2(_VX(0)/10,limit(-_VZ(0),10,9999999999)))
		end);
	};
};
};
};