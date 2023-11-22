classdef derivative_tab < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        TabGroup                    matlab.ui.container.TabGroup
        DerivativesTab              matlab.ui.container.Tab
        DeriXInput                  matlab.ui.control.EditField
        NhpxEditFieldLabel          matlab.ui.control.Label
        DeriYInput                  matlab.ui.control.EditField
        NhpyEditFieldLabel          matlab.ui.control.Label
        DeriMethodInputDropDown     matlab.ui.control.DropDown
        ChnnhpxyhmsLabel            matlab.ui.control.Label
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
        DeriTextWarningMethodInput  matlab.ui.control.Label
        DeriButton                  matlab.ui.control.Button
        IntegralTab                 matlab.ui.container.Tab
        ApproximationTab            matlab.ui.container.Tab
        InterpolationTab            matlab.ui.container.Tab
        HoiQuyTab                   matlab.ui.container.Tab
        GioiThieuTab                matlab.ui.container.Tab
        GioiThieuGridLayout         matlab.ui.container.GridLayout
        GioiThieuGridLayout2        matlab.ui.container.GridLayout
        GioiThieuLabelMission_3     matlab.ui.control.EditField
        nhgiLabel                   matlab.ui.control.Label
        GioiThieuLabelMission_2     matlab.ui.control.EditField
        EditField_2Label            matlab.ui.control.Label
        GioiThieuLabelMission_1     matlab.ui.control.EditField
        EditFieldLabel              matlab.ui.control.Label
        GioiThieuLabelJob           matlab.ui.control.EditField
        NhimvEditFieldLabel         matlab.ui.control.Label
        GioiThieuLabelMSSV          matlab.ui.control.EditField
        MSSVEditFieldLabel          matlab.ui.control.Label
        GioiThieuLabelCol_2         matlab.ui.control.Label
        GioiThieuMemberNames        matlab.ui.container.ButtonGroup
        GioiThieuButtonMinh         matlab.ui.control.ToggleButton
        GioiThieuButtonManh         matlab.ui.control.ToggleButton
        GioiThieuButtonPhu          matlab.ui.control.ToggleButton
        GioiThieuLabelCol_1         matlab.ui.control.Label
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
        
        function results = Ham_Lagrange(xa,ya)
            syms x;
            n = length(xa);
            results = 0;
            for i = (1:n)
                temp = 1;
                for j = (1:n)
                    if i ~= j
                        temp = simplify( temp * ( (x - xa(j)) / (xa(i) - xa(j)))); 
                    end
                end
                results = results + temp*ya(i);
                simplify(results);
            end
            results(x) = results;
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
                        functionStr = string(Ham_Lagrange(xa,ya));
                        % error("Chưa có hàm nội suy, thiết kế sau")
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
                displayResult(app, app.appendStr, "[INFO]: Kết quả f '(x) = " + string(result))
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

        % Selection changed function: GioiThieuMemberNames
        function GioiThieuMemberNamesSelectionChanged(app, event)
            selectedButtonObj = app.GioiThieuMemberNames.SelectedObject;
            switch selectedButtonObj
                case app.GioiThieuButtonManh
                    app.GioiThieuLabelMSSV.Value = "21200312";
                    app.GioiThieuLabelJob.Value = "Thư ký";
                    app.GioiThieuLabelMission_1.Value = "Viết báo cáo words";
                    app.GioiThieuLabelMission_2.Value = "Thực hiện tab tích phân, hồi quy";
                    app.GioiThieuLabelMission_3.Value = "100%";
                case app.GioiThieuButtonPhu
                    app.GioiThieuLabelMSSV.Value = "21200328";
                    app.GioiThieuLabelJob.Value = "Nhóm trưởng";
                    app.GioiThieuLabelMission_1.Value = "Tổng hợp files và hỗ trợ nhóm";
                    app.GioiThieuLabelMission_2.Value = "Thực hiện tab đạo hàm, giới thiệu";
                    app.GioiThieuLabelMission_3.Value = "100%";
                otherwise
                    app.GioiThieuLabelMSSV.Value = "21200313";
                    app.GioiThieuLabelJob.Value = "Thành viên";
                    app.GioiThieuLabelMission_1.Value = "Hỗ trợ debug code";
                    app.GioiThieuLabelMission_2.Value = "Thực hiện tab nghiệm, nội suy";
                    app.GioiThieuLabelMission_3.Value = "100%";
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

            % Create TabGroup
            app.TabGroup = uitabgroup(app.UIFigure);
            app.TabGroup.AutoResizeChildren = 'off';
            app.TabGroup.Position = [1 1 666 455];

            % Create DerivativesTab
            app.DerivativesTab = uitab(app.TabGroup);
            app.DerivativesTab.AutoResizeChildren = 'off';
            app.DerivativesTab.Title = 'Đạo hàm';

            % Create DeriButton
            app.DeriButton = uibutton(app.DerivativesTab, 'push');
            app.DeriButton.ButtonPushedFcn = createCallbackFcn(app, @DeriButtonPushed, true);
            app.DeriButton.Position = [432 101 100 22];
            app.DeriButton.Text = 'Tìm giá trị';

            % Create DeriTextWarningMethodInput
            app.DeriTextWarningMethodInput = uilabel(app.DerivativesTab);
            app.DeriTextWarningMethodInput.FontWeight = 'bold';
            app.DeriTextWarningMethodInput.Position = [84 289 152 22];
            app.DeriTextWarningMethodInput.Text = 'Hãy chọn dữ liệu đầu vào';

            % Create NhphmsfxLabel
            app.NhphmsfxLabel = uilabel(app.DerivativesTab);
            app.NhphmsfxLabel.HorizontalAlignment = 'right';
            app.NhphmsfxLabel.Visible = 'off';
            app.NhphmsfxLabel.Position = [28 289 98 22];
            app.NhphmsfxLabel.Text = 'Nhập hàm số f(x)';

            % Create DeriFunction
            app.DeriFunction = uieditfield(app.DerivativesTab, 'text');
            app.DeriFunction.Visible = 'off';
            app.DeriFunction.Position = [141 289 140 22];
            app.DeriFunction.Value = 'x^2';

            % Create NhpbchEditFieldLabel
            app.NhpbchEditFieldLabel = uilabel(app.DerivativesTab);
            app.NhpbchEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpbchEditFieldLabel.Position = [51 208 76 22];
            app.NhpbchEditFieldLabel.Text = 'Nhập bước h';

            % Create DeriStepValue
            app.DeriStepValue = uieditfield(app.DerivativesTab, 'numeric');
            app.DeriStepValue.HorizontalAlignment = 'left';
            app.DeriStepValue.Position = [142 208 140 22];
            app.DeriStepValue.Value = 1;

            % Create NhpxgitrcntnhLabel
            app.NhpxgitrcntnhLabel = uilabel(app.DerivativesTab);
            app.NhpxgitrcntnhLabel.HorizontalAlignment = 'center';
            app.NhpxgitrcntnhLabel.Position = [38 162 89 28];
            app.NhpxgitrcntnhLabel.Text = {'Nhập x'; '(giá trị cần tính)'};

            % Create DeriXValue
            app.DeriXValue = uieditfield(app.DerivativesTab, 'numeric');
            app.DeriXValue.HorizontalAlignment = 'left';
            app.DeriXValue.Position = [142 168 140 22];
            app.DeriXValue.Value = 2;

            % Create ChngitrsaisDropDownLabel
            app.ChngitrsaisDropDownLabel = uilabel(app.DerivativesTab);
            app.ChngitrsaisDropDownLabel.HorizontalAlignment = 'center';
            app.ChngitrsaisDropDownLabel.Position = [60 117 67 28];
            app.ChngitrsaisDropDownLabel.Text = {'Chọn giá trị'; 'sai số'};

            % Create DeriTrunErrorDropDown
            app.DeriTrunErrorDropDown = uidropdown(app.DerivativesTab);
            app.DeriTrunErrorDropDown.Items = {'O(h)', 'O(h^2)'};
            app.DeriTrunErrorDropDown.ItemsData = {'1', '2'};
            app.DeriTrunErrorDropDown.Position = [142 123 140 22];
            app.DeriTrunErrorDropDown.Value = '1';

            % Create ChnphngphpDropDownLabel
            app.ChnphngphpDropDownLabel = uilabel(app.DerivativesTab);
            app.ChnphngphpDropDownLabel.HorizontalAlignment = 'center';
            app.ChnphngphpDropDownLabel.Position = [49 77 78 28];
            app.ChnphngphpDropDownLabel.Text = {'Chọn'; 'phương pháp'};

            % Create DeriMethodDropDown
            app.DeriMethodDropDown = uidropdown(app.DerivativesTab);
            app.DeriMethodDropDown.Items = {'Xấp xỉ tiến', 'Xấp xỉ lùi', 'Xấp xỉ trung tâm', ''};
            app.DeriMethodDropDown.ItemsData = {'1', '2', '3'};
            app.DeriMethodDropDown.Position = [142 83 139 22];
            app.DeriMethodDropDown.Value = '1';

            % Create HinthktquTextAreaLabel
            app.HinthktquTextAreaLabel = uilabel(app.DerivativesTab);
            app.HinthktquTextAreaLabel.HorizontalAlignment = 'center';
            app.HinthktquTextAreaLabel.FontSize = 13;
            app.HinthktquTextAreaLabel.Position = [434 324 96 22];
            app.HinthktquTextAreaLabel.Text = 'Hiển thị kết quả';

            % Create DeriResult
            app.DeriResult = uitextarea(app.DerivativesTab);
            app.DeriResult.FontSize = 13;
            app.DeriResult.Position = [329 162 305 149];

            % Create ChnnhpxyhmsLabel
            app.ChnnhpxyhmsLabel = uilabel(app.DerivativesTab);
            app.ChnnhpxyhmsLabel.HorizontalAlignment = 'center';
            app.ChnnhpxyhmsLabel.Position = [40 359 102 28];
            app.ChnnhpxyhmsLabel.Text = {'Chọn dữ liệu'; 'đầu vào'};

            % Create DeriMethodInputDropDown
            app.DeriMethodInputDropDown = uidropdown(app.DerivativesTab);
            app.DeriMethodInputDropDown.Items = {'Chưa chọn', 'Nhập hàm số', 'Nhập x / y'};
            app.DeriMethodInputDropDown.ItemsData = {'0', '1', '2'};
            app.DeriMethodInputDropDown.ValueChangedFcn = createCallbackFcn(app, @DeriMethodInputDropDownValueChanged, true);
            app.DeriMethodInputDropDown.Position = [142 365 140 22];
            app.DeriMethodInputDropDown.Value = '0';

            % Create NhpyEditFieldLabel
            app.NhpyEditFieldLabel = uilabel(app.DerivativesTab);
            app.NhpyEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpyEditFieldLabel.Visible = 'off';
            app.NhpyEditFieldLabel.Position = [82 268 44 22];
            app.NhpyEditFieldLabel.Text = 'Nhập y';

            % Create DeriYInput
            app.DeriYInput = uieditfield(app.DerivativesTab, 'text');
            app.DeriYInput.Visible = 'off';
            app.DeriYInput.Position = [141 268 140 22];

            % Create NhpxEditFieldLabel
            app.NhpxEditFieldLabel = uilabel(app.DerivativesTab);
            app.NhpxEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpxEditFieldLabel.Visible = 'off';
            app.NhpxEditFieldLabel.Position = [82 310 44 22];
            app.NhpxEditFieldLabel.Text = 'Nhập x';

            % Create DeriXInput
            app.DeriXInput = uieditfield(app.DerivativesTab, 'text');
            app.DeriXInput.Visible = 'off';
            app.DeriXInput.Position = [141 310 140 22];

            % Create IntegralTab
            app.IntegralTab = uitab(app.TabGroup);
            app.IntegralTab.AutoResizeChildren = 'off';
            app.IntegralTab.Title = 'Tích phân';

            % Create ApproximationTab
            app.ApproximationTab = uitab(app.TabGroup);
            app.ApproximationTab.Title = 'Nghiệm';

            % Create InterpolationTab
            app.InterpolationTab = uitab(app.TabGroup);
            app.InterpolationTab.Title = 'Nội suy';

            % Create HoiQuyTab
            app.HoiQuyTab = uitab(app.TabGroup);
            app.HoiQuyTab.Title = 'Hồi quy';

            % Create GioiThieuTab
            app.GioiThieuTab = uitab(app.TabGroup);
            app.GioiThieuTab.Title = 'Giới thiệu nhóm';

            % Create GioiThieuGridLayout
            app.GioiThieuGridLayout = uigridlayout(app.GioiThieuTab);
            app.GioiThieuGridLayout.ColumnWidth = {200, '7.06x'};
            app.GioiThieuGridLayout.RowHeight = {100, '6.22x'};

            % Create GioiThieuLabelCol_1
            app.GioiThieuLabelCol_1 = uilabel(app.GioiThieuGridLayout);
            app.GioiThieuLabelCol_1.BackgroundColor = [1 1 1];
            app.GioiThieuLabelCol_1.HorizontalAlignment = 'center';
            app.GioiThieuLabelCol_1.FontSize = 14;
            app.GioiThieuLabelCol_1.FontWeight = 'bold';
            app.GioiThieuLabelCol_1.Layout.Row = 1;
            app.GioiThieuLabelCol_1.Layout.Column = 1;
            app.GioiThieuLabelCol_1.Text = 'Thành viên';

            % Create GioiThieuMemberNames
            app.GioiThieuMemberNames = uibuttongroup(app.GioiThieuGridLayout);
            app.GioiThieuMemberNames.SelectionChangedFcn = createCallbackFcn(app, @GioiThieuMemberNamesSelectionChanged, true);
            app.GioiThieuMemberNames.TitlePosition = 'centertop';
            app.GioiThieuMemberNames.Title = 'Tên';
            app.GioiThieuMemberNames.BackgroundColor = [1 1 1];
            app.GioiThieuMemberNames.Layout.Row = 2;
            app.GioiThieuMemberNames.Layout.Column = 1;

            % Create GioiThieuButtonPhu
            app.GioiThieuButtonPhu = uitogglebutton(app.GioiThieuMemberNames);
            app.GioiThieuButtonPhu.Text = 'Nguyễn Đức Phú';
            app.GioiThieuButtonPhu.Position = [21 188 150 22];
            app.GioiThieuButtonPhu.Value = true;

            % Create GioiThieuButtonManh
            app.GioiThieuButtonManh = uitogglebutton(app.GioiThieuMemberNames);
            app.GioiThieuButtonManh.Text = 'Nguyễn Đặng Duy Mạnh';
            app.GioiThieuButtonManh.Position = [21 157 150 22];

            % Create GioiThieuButtonMinh
            app.GioiThieuButtonMinh = uitogglebutton(app.GioiThieuMemberNames);
            app.GioiThieuButtonMinh.Text = {'Nguyễn Công Minh'; ''};
            app.GioiThieuButtonMinh.Position = [21 126 150 22];

            % Create GioiThieuLabelCol_2
            app.GioiThieuLabelCol_2 = uilabel(app.GioiThieuGridLayout);
            app.GioiThieuLabelCol_2.BackgroundColor = [1 1 1];
            app.GioiThieuLabelCol_2.HorizontalAlignment = 'center';
            app.GioiThieuLabelCol_2.FontSize = 14;
            app.GioiThieuLabelCol_2.FontWeight = 'bold';
            app.GioiThieuLabelCol_2.Layout.Row = 1;
            app.GioiThieuLabelCol_2.Layout.Column = 2;
            app.GioiThieuLabelCol_2.Text = 'Giới thiệu và nhiệm vụ';

            % Create GioiThieuGridLayout2
            app.GioiThieuGridLayout2 = uigridlayout(app.GioiThieuGridLayout);
            app.GioiThieuGridLayout2.RowHeight = {'1x', '1x', '1x', '1x', '1x'};
            app.GioiThieuGridLayout2.Layout.Row = 2;
            app.GioiThieuGridLayout2.Layout.Column = 2;

            % Create MSSVEditFieldLabel
            app.MSSVEditFieldLabel = uilabel(app.GioiThieuGridLayout2);
            app.MSSVEditFieldLabel.BackgroundColor = [1 1 1];
            app.MSSVEditFieldLabel.HorizontalAlignment = 'center';
            app.MSSVEditFieldLabel.FontWeight = 'bold';
            app.MSSVEditFieldLabel.FontColor = [0.851 0.3255 0.098];
            app.MSSVEditFieldLabel.Layout.Row = 1;
            app.MSSVEditFieldLabel.Layout.Column = 1;
            app.MSSVEditFieldLabel.Text = 'MSSV';

            % Create GioiThieuLabelMSSV
            app.GioiThieuLabelMSSV = uieditfield(app.GioiThieuGridLayout2, 'text');
            app.GioiThieuLabelMSSV.HorizontalAlignment = 'center';
            app.GioiThieuLabelMSSV.Layout.Row = 1;
            app.GioiThieuLabelMSSV.Layout.Column = 2;
            app.GioiThieuLabelMSSV.Value = '21200328';

            % Create NhimvEditFieldLabel
            app.NhimvEditFieldLabel = uilabel(app.GioiThieuGridLayout2);
            app.NhimvEditFieldLabel.BackgroundColor = [1 1 1];
            app.NhimvEditFieldLabel.HorizontalAlignment = 'center';
            app.NhimvEditFieldLabel.FontWeight = 'bold';
            app.NhimvEditFieldLabel.FontColor = [0.851 0.3255 0.098];
            app.NhimvEditFieldLabel.Layout.Row = 2;
            app.NhimvEditFieldLabel.Layout.Column = 1;
            app.NhimvEditFieldLabel.Text = 'Nhiệm vụ';

            % Create GioiThieuLabelJob
            app.GioiThieuLabelJob = uieditfield(app.GioiThieuGridLayout2, 'text');
            app.GioiThieuLabelJob.HorizontalAlignment = 'center';
            app.GioiThieuLabelJob.Layout.Row = 2;
            app.GioiThieuLabelJob.Layout.Column = 2;
            app.GioiThieuLabelJob.Value = 'Nhóm trưởng';

            % Create EditFieldLabel
            app.EditFieldLabel = uilabel(app.GioiThieuGridLayout2);
            app.EditFieldLabel.HorizontalAlignment = 'right';
            app.EditFieldLabel.Layout.Row = 3;
            app.EditFieldLabel.Layout.Column = 1;
            app.EditFieldLabel.Text = '';

            % Create GioiThieuLabelMission_1
            app.GioiThieuLabelMission_1 = uieditfield(app.GioiThieuGridLayout2, 'text');
            app.GioiThieuLabelMission_1.HorizontalAlignment = 'center';
            app.GioiThieuLabelMission_1.Layout.Row = 3;
            app.GioiThieuLabelMission_1.Layout.Column = 2;
            app.GioiThieuLabelMission_1.Value = 'Dẫn dắt và hỗ trợ các thành viên';

            % Create EditField_2Label
            app.EditField_2Label = uilabel(app.GioiThieuGridLayout2);
            app.EditField_2Label.HorizontalAlignment = 'right';
            app.EditField_2Label.Layout.Row = 4;
            app.EditField_2Label.Layout.Column = 1;
            app.EditField_2Label.Text = '';

            % Create GioiThieuLabelMission_2
            app.GioiThieuLabelMission_2 = uieditfield(app.GioiThieuGridLayout2, 'text');
            app.GioiThieuLabelMission_2.HorizontalAlignment = 'center';
            app.GioiThieuLabelMission_2.Layout.Row = 4;
            app.GioiThieuLabelMission_2.Layout.Column = 2;
            app.GioiThieuLabelMission_2.Value = 'Thực hiện tab đạo hàm, giới thiệu';

            % Create nhgiLabel
            app.nhgiLabel = uilabel(app.GioiThieuGridLayout2);
            app.nhgiLabel.BackgroundColor = [1 1 1];
            app.nhgiLabel.HorizontalAlignment = 'center';
            app.nhgiLabel.FontWeight = 'bold';
            app.nhgiLabel.FontColor = [0.851 0.3255 0.098];
            app.nhgiLabel.Layout.Row = 5;
            app.nhgiLabel.Layout.Column = 1;
            app.nhgiLabel.Text = 'Đánh giá mức độ hoàn thành';

            % Create GioiThieuLabelMission_3
            app.GioiThieuLabelMission_3 = uieditfield(app.GioiThieuGridLayout2, 'text');
            app.GioiThieuLabelMission_3.HorizontalAlignment = 'center';
            app.GioiThieuLabelMission_3.Layout.Row = 5;
            app.GioiThieuLabelMission_3.Layout.Column = 2;
            app.GioiThieuLabelMission_3.Value = '100%';

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