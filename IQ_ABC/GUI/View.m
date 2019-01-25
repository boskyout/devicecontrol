classdef View
    %UNTITLED4 Summary of this class goes here
    %   Detailed explanation goes here
    
    properties
        hfig;
        viewSize;
        text;
        balanceBox;
        numBox;
        drawButton;
        depositButton;
        modelObj;
        controlObj;
    end
    
    properties (Dependent)
        input;
    end
    
    methods
        function obj = View(modelObj)
            obj.viewSize = [400 400 300 200];
            obj = obj.buildUI();
            obj.modelObj = modelObj;
            obj.modelObj.addlistener('balanceChanged',@obj.updateBalance);
            obj.controlObj = obj.makeController();
            obj.attachToController(obj.controlObj);
        end
        function obj = buildUI(obj)
            obj.hfig = figure('pos',obj.viewSize,'NumberTitle','off','Menubar','none',...
                'Toolbar','none');
            mainLayout = uiextras.VBox('Parent',obj.hfig,'Padding',5,'Spacing',10);
            topLayout = uiextras.HBox('Parent',mainLayout,'Spacing',5);
            middleLayout = uiextras.HBox('Parent',mainLayout,'Spacing',5);
            lowerLayout = uiextras.HBox('Parent',mainLayout,'Spacing',5);
            
            obj.text = uicontrol('parent',topLayout,'style','text','string','Balance');
            obj.balanceBox = uicontrol('parent',topLayout,'style','edit','background','w');
            
            obj.numBox = uicontrol('parent',middleLayout,'style','edit','background','w');
            
            obj.drawButton = uicontrol('parent',lowerLayout,'style','pushbutton',...
                'string','Withdraw');
            obj.depositButton = uicontrol('parent',lowerLayout,'style','pushbutton',...
                'string','Deposit');
            
            set(topLayout,'Sizes',[-1,-1]);
            set(lowerLayout,'Sizes',[-1,-1]);
            obj.updateBalance;
        end
        function updateBalance(obj,src,data)
            set(obj.balanceBox,'string',num2str(obj.modelObj.balance));
        end
        function controlObj = makeController(obj)
            controlObj = Controller(obj,obj.modelObj);
        end
        function attachToController(obj,controller)
            funcH = @controller.callback_drawbutton;
            set(obj.drawButton,'callback', funcH) ;
            funcH = @controller.callback_depositbutton;
            set(obj.depositButton,'callback',funcH);
        end
        function input = get.input(obj)
            input = get(obj.numBox,'string');
            input = str2double(input);
        end
    end
    
end

