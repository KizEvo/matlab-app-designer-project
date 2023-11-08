classdef derivative_tab < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        DeriTextWarningMethodInput  matlab.ui.control.Label
        DeriXInput                  matlab.ui.control.EditField
        NhpxEditFieldLabel          matlab.ui.control.Label
        DeriYInput                  matlab.ui.control.EditField
        NhpyEditFieldLabel          matlab.ui.control.Label
        DeriMethodInputDropDown     matlab.ui.control.DropDown
        ChnnhpxyhmsLabel            matlab.ui.control.Label
        DeriButton                  matlab.ui.control.Button
        DeriResult                  matlab.ui.control.TextArea
        HinthktquTextAreaLabel      matlab.ui.control.Label
        DeriMethodDropDown          matlab.ui.control.DropDown
        ChnphngphpDropDownLabel     matlab.ui.control.Label
        DeriTrunErrorDropDown       matlab.ui.control.DropDown
        ChngitrsaisDropDownLabel    matlab.ui.control.Label
        DeriXValue                  matlab.ui.control.NumericEditField
        NhpxgitrcntnhLabel          matlab.ui.control.Label
        DeriStepValue               matlab.ui.control.NumericEditField
        NhpbchEditFieldLabel        matlab.ui.control.Label
        DeriFunction                matlab.ui.control.EditField
        NhphmsfxLabel               matlab.ui.control.Label
    end

    
    properties (Access = private)
        appendStr = 1
        noAppendStr = 0
    end
    
    methods (Access = private)
        
        function checkValidInputs(~, step, funcStr, method, trunError)
            % Check user entered inputs
            if step == 0
                error("Bước h phải khác 0");
            end
            if strlength(funcStr) <= 0
                error("Hàm số f(x) không được để trống");
            end
            if method == '3' && trunError == '1'
                error("Phương pháp trung tâm không có sai số O(h)");
            end
        end
        
        function f = getFunctionHandler(~, funcStr)
            % Get function handler obj and pass value to funct handler to
            % check if it was created successfully
            try
                f = str2func("@(x)"+funcStr);
                testFxValue = f(1);
            catch
                error("Hàm số f(x) nhập không đúng format hoặc sai cú pháp hàm có sẵn trong MATLAB");
            end
        end
        
        function displayResult(app, isAppend, message)
            % Display messages to app.DeriResult (TextArea) obj
            if isAppend
                newMessage = sprintf(message + "\n");
                if strlength(app.DeriResult.Value) ~= 0
                    app.DeriResult.Value = [app.DeriResult.Value; newMessage];
                else
                    app.DeriResult.Value = newMessage;
                end
            else
                % Clear previous message
                app.DeriResult.Value = "";
                % Display new message
                app.DeriResult.Value = message;
            end
        end
        
        function f_diff = calcTrunErrorOH(~, method, f, x, step)
            % Truncation error O(h) for forward/backward methods
           if method == '1'
               f_diff = double((f(x + step) - f(x))/step);
           else
               f_diff = double((-f(x - step) + f(x))/step);
           end
        end

        function f_diff = calcTrunErrorOHH(~, method, f, x, step)
            % Truncation error O(h^2) for all three methods
            if method == '1'
                f_diff = double((4*f(x + step) - 3*f(x) - f(x + 2*step))/(2*step));
            elseif method == '2'
                f_diff = double((-4*f(x - step) + 3*f(x) + f(x - 2*step))/(2*step));
            else
                f_diff = double((-f(x - step) + f(x + step))/(2*step));
            end
        end
        
        function [xa,ya] = transformXYMethodInput(app)
            try
                xStr = app.DeriXInput.Value;
                yStr = app.DeriYInput.Value;
                xStrArr = split(xStr, ",");
                yStrArr = split(yStr, ",");
                xa = str2double(xStrArr);
                ya = str2double(yStrArr);
                p = inputParser;
                argName = 'num';
                validationFcn = @(x) isnumeric(x) && ~isnan(x);
                addRequired(p,argName,validationFcn)
                for i = 1:length(xa)
                    parse(p, xa(i))
                    parse(p, ya(i))
                end
            catch
                error("Nhập x/y không đúng format, x/y không có kích thước giống nhau hoặc đang để trống")
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: DeriButton
        function DeriButtonPushed(app, event)
            try
                % Clear previous messages
                displayResult(app, app.noAppendStr, "");
                % Check input method for derivative (f(x), x/y or none) 
                switch app.DeriMethodInputDropDown.Value
                    case '0'
                        error("Chưa chọn dữ liệu đầu vào")
                    case '1'
                        functionStr = app.DeriFunction.Value;
                    case '2'
                        [xa, ya] = transformXYMethodInput(app);
                        % Lagrange/Newton Interpolation function here
                        % xa, xy are params for the function to get
                        % functionStr
                        error("Chưa có hàm nội suy, thiết kế sau")
                end
                % Get inputs
                stepValue = app.DeriStepValue.Value;
                xValue = app.DeriXValue.Value;
                method = app.DeriMethodDropDown.Value;
                trunError = app.DeriTrunErrorDropDown.Value;
                % Check if inputs are valid or not
                checkValidInputs(app, stepValue, functionStr, method, trunError);
                functionHandler = getFunctionHandler(app, functionStr);
                displayResult(app, app.appendStr, "[INFO]: Đã nhập f(x) = " + functionStr);
                % Call the truncation error func based on user input
                if trunError == '1'
                    result = calcTrunErrorOH(app, method, functionHandler, xValue, stepValue);
                else
                    result = calcTrunErrorOHH(app, method, functionHandler, xValue, stepValue);
                end
                % Display f(x) result
                displayResult(app, app.appendStr, "[INFO]: Kết quả f'(x) = " + string(result))
                app.DeriButton.BackgroundColor = 'g';
                pause(1);
                app.DeriButton.BackgroundColor = 'w';
            catch ex
                message = "[ERROR]: " + ex.message;
                displayResult(app, app.noAppendStr, message);
                app.DeriButton.BackgroundColor = 'r';
                pause(1);
                app.DeriButton.BackgroundColor = 'w';
            end
        end

        % Value changed function: DeriMethodInputDropDown
        function DeriMethodInputDropDownValueChanged(app, event)
            value = app.DeriMethodInputDropDown.Value;
            app.DeriTextWarningMethodInput.Visible = 'off';
            app.DeriXInput.Value = "";
            app.DeriYInput.Value = "";
            app.DeriFunction.Value = "";
            if value == '1'
                app.DeriXInput.Visible = 'off';
                app.NhpxEditFieldLabel.Visible = 'off';
                app.DeriYInput.Visible = 'off';
                app.NhpyEditFieldLabel.Visible = 'off';
                app.DeriFunction.Visible = 'on';
                app.NhphmsfxLabel.Visible = 'on';
            elseif value == '2'
                app.DeriFunction.Visible = 'off';
                app.NhphmsfxLabel.Visible = 'off';
                app.DeriXInput.Visible = 'on';
                app.NhpxEditFieldLabel.Visible = 'on';
                app.DeriYInput.Visible = 'on';
                app.NhpyEditFieldLabel.Visible = 'on';
            else
                app.DeriXInput.Visible = 'off';
                app.NhpxEditFieldLabel.Visible = 'off';
                app.DeriYInput.Visible = 'off';
                app.NhpyEditFieldLabel.Visible = 'off';
                app.DeriFunction.Visible = 'off';
                app.NhphmsfxLabel.Visible = 'off';
                app.DeriTextWarningMethodInput.Visible = 'on';
            end
            
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.AutoResizeChildren = 'off';
            app.UIFigure.Position = [100 100 666 455];
            app.UIFigure.Name = 'MATLAB App';
            app.UIFigure.Resize = 'off';

            % Create NhphmsfxLabel
            app.NhphmsfxLabel = uilabel(app.UIFigure);
            app.NhphmsfxLabel.HorizontalAlignment = 'right';
            app.NhphmsfxLabel.Visible = 'off';
            app.NhphmsfxLabel.Position = [35 309 98 22];
            app.NhphmsfxLabel.Text = 'Nhập hàm số f(x)';

            % Create DeriFunction
            app.DeriFunction = uieditfield(app.UIFigure, 'text');
            app.DeriFunction.Visible = 'off';
            app.DeriFunction.Position = [148 309 140 22];
            app.DeriFunction.Value = 'x^2';

            % Create NhpbchEditFieldLabel
            app.NhpbchEditFieldLabel = uilabel(app.UIFigure);
            app.NhpbchEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpbchEditFieldLabel.Position = [58 228 76 22];
            app.NhpbchEditFieldLabel.Text = 'Nhập bước h';

            % Create DeriStepValue
            app.DeriStepValue = uieditfield(app.UIFigure, 'numeric');
            app.DeriStepValue.HorizontalAlignment = 'left';
            app.DeriStepValue.Position = [149 228 140 22];
            app.DeriStepValue.Value = 1;

            % Create NhpxgitrcntnhLabel
            app.NhpxgitrcntnhLabel = uilabel(app.UIFigure);
            app.NhpxgitrcntnhLabel.HorizontalAlignment = 'center';
            app.NhpxgitrcntnhLabel.Position = [45 182 89 28];
            app.NhpxgitrcntnhLabel.Text = {'Nhập x'; '(giá trị cần tính)'};

            % Create DeriXValue
            app.DeriXValue = uieditfield(app.UIFigure, 'numeric');
            app.DeriXValue.HorizontalAlignment = 'left';
            app.DeriXValue.Position = [149 188 140 22];
            app.DeriXValue.Value = 2;

            % Create ChngitrsaisDropDownLabel
            app.ChngitrsaisDropDownLabel = uilabel(app.UIFigure);
            app.ChngitrsaisDropDownLabel.HorizontalAlignment = 'center';
            app.ChngitrsaisDropDownLabel.Position = [67 137 67 28];
            app.ChngitrsaisDropDownLabel.Text = {'Chọn giá trị'; 'sai số'};

            % Create DeriTrunErrorDropDown
            app.DeriTrunErrorDropDown = uidropdown(app.UIFigure);
            app.DeriTrunErrorDropDown.Items = {'O(h)', 'O(h^2)'};
            app.DeriTrunErrorDropDown.ItemsData = {'1', '2'};
            app.DeriTrunErrorDropDown.Position = [149 143 140 22];
            app.DeriTrunErrorDropDown.Value = '1';

            % Create ChnphngphpDropDownLabel
            app.ChnphngphpDropDownLabel = uilabel(app.UIFigure);
            app.ChnphngphpDropDownLabel.HorizontalAlignment = 'center';
            app.ChnphngphpDropDownLabel.Position = [56 97 78 28];
            app.ChnphngphpDropDownLabel.Text = {'Chọn'; 'phương pháp'};

            % Create DeriMethodDropDown
            app.DeriMethodDropDown = uidropdown(app.UIFigure);
            app.DeriMethodDropDown.Items = {'Xấp xỉ tiến', 'Xấp xỉ lùi', 'Xấp xỉ trung tâm', ''};
            app.DeriMethodDropDown.ItemsData = {'1', '2', '3'};
            app.DeriMethodDropDown.Position = [149 103 139 22];
            app.DeriMethodDropDown.Value = '1';

            % Create HinthktquTextAreaLabel
            app.HinthktquTextAreaLabel = uilabel(app.UIFigure);
            app.HinthktquTextAreaLabel.HorizontalAlignment = 'center';
            app.HinthktquTextAreaLabel.FontSize = 13;
            app.HinthktquTextAreaLabel.Position = [441 344 96 22];
            app.HinthktquTextAreaLabel.Text = 'Hiển thị kết quả';

            % Create DeriResult
            app.DeriResult = uitextarea(app.UIFigure);
            app.DeriResult.FontSize = 13;
            app.DeriResult.Position = [336 182 305 149];

            % Create DeriButton
            app.DeriButton = uibutton(app.UIFigure, 'push');
            app.DeriButton.ButtonPushedFcn = createCallbackFcn(app, @DeriButtonPushed, true);
            app.DeriButton.Position = [439 121 100 22];
            app.DeriButton.Text = 'Tìm giá trị';

            % Create ChnnhpxyhmsLabel
            app.ChnnhpxyhmsLabel = uilabel(app.UIFigure);
            app.ChnnhpxyhmsLabel.HorizontalAlignment = 'center';
            app.ChnnhpxyhmsLabel.Position = [47 379 102 28];
            app.ChnnhpxyhmsLabel.Text = {'Chọn dữ liệu'; 'đầu vào'};

            % Create DeriMethodInputDropDown
            app.DeriMethodInputDropDown = uidropdown(app.UIFigure);
            app.DeriMethodInputDropDown.Items = {'Chưa chọn', 'Nhập hàm số', 'Nhập x / y'};
            app.DeriMethodInputDropDown.ItemsData = {'0', '1', '2'};
            app.DeriMethodInputDropDown.ValueChangedFcn = createCallbackFcn(app, @DeriMethodInputDropDownValueChanged, true);
            app.DeriMethodInputDropDown.Position = [149 385 140 22];
            app.DeriMethodInputDropDown.Value = '0';

            % Create NhpyEditFieldLabel
            app.NhpyEditFieldLabel = uilabel(app.UIFigure);
            app.NhpyEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpyEditFieldLabel.Visible = 'off';
            app.NhpyEditFieldLabel.Position = [89 288 44 22];
            app.NhpyEditFieldLabel.Text = 'Nhập y';

            % Create DeriYInput
            app.DeriYInput = uieditfield(app.UIFigure, 'text');
            app.DeriYInput.Visible = 'off';
            app.DeriYInput.Position = [148 288 140 22];

            % Create NhpxEditFieldLabel
            app.NhpxEditFieldLabel = uilabel(app.UIFigure);
            app.NhpxEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpxEditFieldLabel.Visible = 'off';
            app.NhpxEditFieldLabel.Position = [89 330 44 22];
            app.NhpxEditFieldLabel.Text = 'Nhập x';

            % Create DeriXInput
            app.DeriXInput = uieditfield(app.UIFigure, 'text');
            app.DeriXInput.Visible = 'off';
            app.DeriXInput.Position = [148 330 140 22];

            % Create DeriTextWarningMethodInput
            app.DeriTextWarningMethodInput = uilabel(app.UIFigure);
            app.DeriTextWarningMethodInput.FontWeight = 'bold';
            app.DeriTextWarningMethodInput.Position = [91 309 152 22];
            app.DeriTextWarningMethodInput.Text = 'Hãy chọn dữ liệu đầu vào';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = derivative_tab

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.UIFigure)
        end
    end
end
