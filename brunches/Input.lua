namespace"trit"{
namespace"model"{
namespace"sorceress"{
	class "Input"{metamethod"_init"
		:body(	function(self)
			self.analogs = {}
			self.analogs.handle = self.trit.input.Analog:new(0);
			self.analogs.accel = self.trit.input.Analog:new(4);
			
			self.analogs.brake = self.trit.input.Analog:new(2);
			
			self.inputs = {};
			self.inputs.handle = 0;
			self.inputs.accel = 0;
			self.inputs.nomalBrake = 0;
			self.inputs.sideBrake = 0;
			self.inputs.deff = 0;
			self.inputs.roll = 0;
			self.inputs.pitch = 0;
			self.inputs.snowMode = 0;
		end);
		
		method"GetInputs"
		:body(function(self)
			return self.inputs
		end);

		method"sign"
		:body(function(self,num)
			if num > 0 then
				return math.abs(num)/num
			elseif num < 0 then
				return math.abs(num)/num
			else
				return 1
			end
		end);

		metamethod"__call"
		:body(function(self)
		end);
	};
};
};
};