classdef Controller < handle
    %UNTITLED9 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        viewObj;
        modelObj;
    end
    
    methods
        function obj = Controller(viewObj,modelObj)
            obj.viewObj = viewObj;
            obj.modelObj = modelObj;
        end
        function callback_drawbutton(obj,src,event)
            obj.modelObj.withdraw(obj.viewObj.input);
        end
        function callback_depositbutton(obj,src,event)
            obj.modelObj.deposit(obj.viewObj.input);
        end
    end
    
end

