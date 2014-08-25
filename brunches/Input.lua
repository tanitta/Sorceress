namespace"trit"{
namespace"model"{
namespace"sorceress"{
	class "Input"{
		metamethod"_init"
		:body(function(self)
			self.analogs = {}
			self.analogs.handle = trit.input.Analog:new(0);
			self.analogs.pitch = trit.input.Analog:new(1);
			self.analogs.accel = trit.input.Analog:new(4);

			self.analogs.brake = trit.input.Analog:new(2);

			self.inputs = {};
			self.inputs.handle = 0;
			self.inputs.accel = 0;
			self.inputs.normalBrake = 0;
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
			self.inputs.handle = math.abs(self.analogs.handle())^1.2*self:sign(self.analogs.handle());
			self.inputs.accel = math.abs(self.analogs.accel())^2*self:sign(self.analogs.accel());

			self.inputs.normalBrake = math.abs(limit(self.analogs.brake(),-1,0));
			self.inputs.sideBrake = math.abs(limit(self.analogs.brake(),0,1));

			self.inputs.deff = math.abs(limit(self.analogs.brake(),0,1));

			self.inputs.roll = self.analogs.handle();
			self.inputs.pitch = self.analogs.pitch();
		end);
	};
};
};
};
