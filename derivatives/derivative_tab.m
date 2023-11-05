classdef derivative_tab < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                  matlab.ui.Figure
        Button                    matlab.ui.control.Button
        Result                    matlab.ui.control.TextArea
        HinthktquTextAreaLabel    matlab.ui.control.Label
        MethodDropDown            matlab.ui.control.DropDown
        ChnphngphpDropDownLabel   matlab.ui.control.Label
        TrunErrorDropDown         matlab.ui.control.DropDown
        ChngitrsaisDropDownLabel  matlab.ui.control.Label
        XValue                    matlab.ui.control.NumericEditField
        NhpxgitrcntnhLabel        matlab.ui.control.Label
        StepValue                 matlab.ui.control.NumericEditField
        NhpbchEditFieldLabel      matlab.ui.control.Label
        Function                  matlab.ui.control.EditField
        NhphmsfxLabel             matlab.ui.control.Label
    end

    
    properties (Access = private)
        appendStr = 1
        noAppendStr = 0
    end
    
    methods (Access = private)
        
        function checkValidInputs(~, step, x, funcStr, method, trunError)
            % Check user entered inputs
            if step == 0 || x == 0
                error("Bước h hoặc giá trị x cần tìm phải khác 0");
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
            % Display messages to app.Result (TextArea) obj
            if isAppend
                newMessage = sprintf(message + "\n");
                if strlength(app.Result.Value) ~= 0
                    app.Result.Value = [app.Result.Value; newMessage];
                else
                    app.Result.Value = newMessage;
                end
            else
                % Clear previous message
                app.Result.Value = "";
                % Display new message
                app.Result.Value = message;
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
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: Button
        function ButtonPushed(app, event)
            try
                % Clear previous messages
                displayResult(app, app.noAppendStr, "");
                % Get inputs
                functionStr = app.Function.Value;
                stepValue = app.StepValue.Value;
                xValue = app.XValue.Value;
                method = app.MethodDropDown.Value;
                trunError = app.TrunErrorDropDown.Value;
                % Check if inputs are valid or not
                checkValidInputs(app, stepValue, xValue, functionStr, method, trunError);
                functionHandler = getFunctionHandler(app, functionStr);
                displayResult(app, app.appendStr, "[INFO]: Đã nhập f(x) = " + functionStr);
                % Call the truncation error func based on user input
                if trunError == '1'
                    result = calcTrunErrorOH(app, method, functionHandler, xValue, stepValue);
                else
                    result = calcTrunErrorOHH(app, method, functionHandler, xValue, stepValue);
                end
                % Display f(x) result
                displayResult(app, app.appendStr, "[INFO]: Kết quả f'(x): " + string(result))
                app.Button.BackgroundColor = 'g';
                pause(1);
                app.Button.BackgroundColor = 'w';
            catch ex
                message = "[ERROR]: " + ex.message;
                displayResult(app, app.noAppendStr, message);
                app.Button.BackgroundColor = 'r';
                pause(1);
                app.Button.BackgroundColor = 'w';
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
            app.NhphmsfxLabel.Position = [37 344 98 22];
            app.NhphmsfxLabel.Text = 'Nhập hàm số f(x)';

            % Create Function
            app.Function = uieditfield(app.UIFigure, 'text');
            app.Function.Position = [150 344 140 22];
            app.Function.Value = 'x^2';

            % Create NhpbchEditFieldLabel
            app.NhpbchEditFieldLabel = uilabel(app.UIFigure);
            app.NhpbchEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpbchEditFieldLabel.Position = [59 281 76 22];
            app.NhpbchEditFieldLabel.Text = 'Nhập bước h';

            % Create StepValue
            app.StepValue = uieditfield(app.UIFigure, 'numeric');
            app.StepValue.HorizontalAlignment = 'left';
            app.StepValue.Position = [150 281 140 22];
            app.StepValue.Value = 1;

            % Create NhpxgitrcntnhLabel
            app.NhpxgitrcntnhLabel = uilabel(app.UIFigure);
            app.NhpxgitrcntnhLabel.HorizontalAlignment = 'center';
            app.NhpxgitrcntnhLabel.Position = [46 211 89 28];
            app.NhpxgitrcntnhLabel.Text = {'Nhập x'; '(giá trị cần tính)'};

            % Create XValue
            app.XValue = uieditfield(app.UIFigure, 'numeric');
            app.XValue.HorizontalAlignment = 'left';
            app.XValue.Position = [150 217 140 22];
            app.XValue.Value = 2;

            % Create ChngitrsaisDropDownLabel
            app.ChngitrsaisDropDownLabel = uilabel(app.UIFigure);
            app.ChngitrsaisDropDownLabel.HorizontalAlignment = 'center';
            app.ChngitrsaisDropDownLabel.Position = [68 136 67 28];
            app.ChngitrsaisDropDownLabel.Text = {'Chọn giá trị'; 'sai số'};

            % Create TrunErrorDropDown
            app.TrunErrorDropDown = uidropdown(app.UIFigure);
            app.TrunErrorDropDown.Items = {'O(h)', 'O(h^2)'};
            app.TrunErrorDropDown.ItemsData = {'1', '2'};
            app.TrunErrorDropDown.Position = [150 142 140 22];
            app.TrunErrorDropDown.Value = '1';

            % Create ChnphngphpDropDownLabel
            app.ChnphngphpDropDownLabel = uilabel(app.UIFigure);
            app.ChnphngphpDropDownLabel.HorizontalAlignment = 'center';
            app.ChnphngphpDropDownLabel.Position = [58 69 78 28];
            app.ChnphngphpDropDownLabel.Text = {'Chọn'; 'phương pháp'};

            % Create MethodDropDown
            app.MethodDropDown = uidropdown(app.UIFigure);
            app.MethodDropDown.Items = {'Xấp xỉ tiến', 'Xấp xỉ lùi', 'Xấp xỉ trung tâm', ''};
            app.MethodDropDown.ItemsData = {'1', '2', '3'};
            app.MethodDropDown.Position = [151 75 139 22];
            app.MethodDropDown.Value = '1';

            % Create HinthktquTextAreaLabel
            app.HinthktquTextAreaLabel = uilabel(app.UIFigure);
            app.HinthktquTextAreaLabel.HorizontalAlignment = 'center';
            app.HinthktquTextAreaLabel.FontSize = 13;
            app.HinthktquTextAreaLabel.Position = [441 344 96 22];
            app.HinthktquTextAreaLabel.Text = 'Hiển thị kết quả';

            % Create Result
            app.Result = uitextarea(app.UIFigure);
            app.Result.FontSize = 13;
            app.Result.Position = [336 182 305 149];

            % Create Button
            app.Button = uibutton(app.UIFigure, 'push');
            app.Button.ButtonPushedFcn = createCallbackFcn(app, @ButtonPushed, true);
            app.Button.Position = [439 121 100 22];
            app.Button.Text = 'Tìm giá trị';

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