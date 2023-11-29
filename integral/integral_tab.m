classdef integral_tab < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        IntegralFigure        matlab.ui.Figure
        IntegralNhapYField    matlab.ui.control.EditField
        NhpdyyEditFieldLabel  matlab.ui.control.Label
        IntegralNhapXField    matlab.ui.control.EditField
        NhpdyxEditFieldLabel  matlab.ui.control.Label
        IntegralKQField       matlab.ui.control.Label
        IntegralInputField    matlab.ui.control.DropDown
        CchnhpDropDownLabel   matlab.ui.control.Label
        IntegralNhapNField    matlab.ui.control.NumericEditField
        NhpNEditFieldLabel    matlab.ui.control.Label
        IntegralNhapCanField  matlab.ui.control.EditField
        NhpcnEditFieldLabel   matlab.ui.control.Label
        IntegralNhapHamField  matlab.ui.control.EditField
        NhphmfxLabel          matlab.ui.control.Label
        IntegralSelectOption  matlab.ui.control.DropDown
        PhngPhpLabel          matlab.ui.control.Label
        IntegralResultButton  matlab.ui.control.Button
        IntegralPlotField     matlab.ui.control.UIAxes
    end

    
    methods (Access = private)
        function [CanValue,f,loi] = check_error(~,OptionInput,x,y,HamField,CanField,N)
            if isempty(CanField) %xử lý lỗi ô cận
                error('Không để trống ô cận');
            elseif (CanField(1) ~= '[' || CanField(strlength(CanField)) ~= ']' )
                error('Vui lòng đúng format [a;b] hoặc [a,b]');
            elseif isempty(str2num(CanField(2:strlength(CanField)-1)))
                error('Vui lòng nhập ký tự số');
            else
                CanValue = str2num(CanField(2:strlength(CanField)-1));
            end
            if  isempty(N)
                error('Không để trống ô N');
            end
            if ~OptionInput
                if  isempty(HamField)
                    error('Không để trống hàm');
                else
                    len = length(HamField);
                    for i = 1: (len- 1)
                            if HamField(i) ~= '.' &&  HamField(i + 1) == '^'
                                HamField = [HamField(1:i),'.',HamField((i+1):len)];
                            end
                    end
                    try
                        f = str2func(['@(x)',HamField]);
                        f(1); 
                    catch
                        error('Nhập hàm không đúng format của Matlab');
                    end
                end
            else
                if isempty(x) || isempty(y)
                    error('Không để trống x,y ');
                elseif length(str2num(x)) ~= length(str2num(y))
                    error('x,y phải nhập đúng format là a,b,c và kích thước bằng nhau');
                else
                    xa = str2num(x);
                    ya = str2num(y);
                    f = Ham_Lagrange(xa,ya);
                end
            end
            loi = 0; %khong xay ra loi
        end
        
        function [value,continuous] = Check_continuous(~,f,a,b,N)
            value = 0;
            continuous = 1;
            step = (b-a)/N;
            x = a:step:b;
            for i = 1:N
                if ~isfinite(f(x(i)))
                    continuous = 0;
                    value = x(i);
                    break;
                end
            end
        end
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)
            app.IntegralKQField.Visible = 'off';
            app.IntegralNhapXField.Visible = 'off';
            app.IntegralNhapYField.Visible = 'off';
            app.NhpdyxEditFieldLabel.Visible = 'off';
            app.NhpdyyEditFieldLabel.Visible = 'off';
            app.IntegralKQField.Interpreter = 'latex';
        end

        % Value changing function: IntegralNhapCanField
        function IntegralNhapCanFieldValueChanging(app, event)

        end

        % Value changing function: IntegralNhapHamField
        function IntegralNhapHamFieldValueChanging(app, event)

        end

        % Button pushed function: IntegralResultButton
        function IntegralResultButtonPushed(app, event)
            %thông báo lỗi
            loi = 1;
            hamField = app.IntegralNhapHamField.Value;
            optionInput = str2num(app.IntegralInputField.Value);
            optionIntegral = str2num(app.IntegralSelectOption.Value);
            canField = app.IntegralNhapCanField.Value;
            X = app.IntegralNhapXField.Value;
            Y = app.IntegralNhapYField.Value;
            N = app.IntegralNhapNField.Value;
            try
                [CanValue,f,loi] = check_error(app,optionInput,X,Y,hamField,canField,N);
            catch er
                 app.IntegralKQField.Visible = 'on';
                 app.IntegralKQField.Text = ['[ERROR]: ' , er.message];
            end
        if loi == 0
            a = CanValue(1);
            b = CanValue(2);
            [value,continous] = Check_continuous(app,f,a,b,N);
            if continous
                %tính
                try
                    sum = f(a) + f(b);
                    h = (b-a)/N;
                    if ~optionIntegral
                        for i = 1:(N - 1)
                            sum = sum + 2*f(a+i*h);
                        end
                        sum = sum * h / 2;
                    elseif  optionIntegral == 1
                        for i = 1:(N - 1)
                            sum = sum + 2*(mod(i,2) + 1)*f(a+i*h);
                        end
                        sum = sum * h / 3;
                    else
                        for i = 1:(N - 1)
                            coef = ~mod(i,3)*2 + (1 - ~mod(i,3))*3;
                            sum = sum + coef*f(a+i*h);
                        end     
                    sum = sum *  3/8 * h;
                    end
                    sum = double(sum);
                    app.IntegralKQField.Visible = 'on';
                    app.IntegralKQField.Text = {['$Với$ $a = $',num2str(a)],['$Với$ $b = $',num2str(b)],['$\int_{a}^bf(x)dx$ = ',num2str(sum)]};
                    x = a:h:b;
                    y = f(x);
                    stem(app.IntegralPlotField,x,y);
                    app.IntegralPlotField.Visible = 'on';
                catch
                    app.IntegralKQField.Text = '[ERROR] Lỗi ngoài ý muốn xảy ra';
                end
            else
                app.IntegralKQField.Visible = 'on';
                app.IntegralKQField.Text = ['[ERROR] $f(x)$ không liên tục tại $x = ',num2str(value)];
            end
        end
        end

        % Value changed function: IntegralInputField
        function IntegralInputFieldValueChanged(app, event)
            value = app.IntegralInputField.Value;
            if value == '0' 
                app.IntegralNhapYField.Visible = 'off';
                app.NhpdyxEditFieldLabel.Visible = 'off';
                app.IntegralNhapXField.Visible = 'off';
                app.NhpdyyEditFieldLabel.Visible = 'off';
                app.IntegralNhapHamField.Visible = 'on';
                app.NhphmfxLabel.Visible = 'on';
            else
                app.IntegralNhapHamField.Visible = 'off';
                app.NhphmfxLabel.Visible = 'off';
                app.NhpdyxEditFieldLabel.Visible = 'on';
                app.IntegralNhapYField.Visible = 'on';
                app.NhpdyyEditFieldLabel.Visible = 'on';             
                app.IntegralNhapXField.Visible = 'on';
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create IntegralFigure and hide until all components are created
            app.IntegralFigure = uifigure('Visible', 'off');
            app.IntegralFigure.Position = [100 100 640 480];
            app.IntegralFigure.Name = 'MATLAB App';

            % Create IntegralPlotField
            app.IntegralPlotField = uiaxes(app.IntegralFigure);
            title(app.IntegralPlotField, 'Đồ thị của hàm số')
            xlabel(app.IntegralPlotField, 'X')
            ylabel(app.IntegralPlotField, 'Y')
            zlabel(app.IntegralPlotField, 'Z')
            app.IntegralPlotField.XGrid = 'on';
            app.IntegralPlotField.YGrid = 'on';
            app.IntegralPlotField.Position = [306 174 300 215];

            % Create IntegralResultButton
            app.IntegralResultButton = uibutton(app.IntegralFigure, 'push');
            app.IntegralResultButton.ButtonPushedFcn = createCallbackFcn(app, @IntegralResultButtonPushed, true);
            app.IntegralResultButton.FontSize = 14;
            app.IntegralResultButton.Position = [156 80 100 24];
            app.IntegralResultButton.Text = 'Tìm kết quả';

            % Create PhngPhpLabel
            app.PhngPhpLabel = uilabel(app.IntegralFigure);
            app.PhngPhpLabel.HorizontalAlignment = 'right';
            app.PhngPhpLabel.FontSize = 14;
            app.PhngPhpLabel.Position = [38 204 93 22];
            app.PhngPhpLabel.Text = 'Phương Pháp';

            % Create IntegralSelectOption
            app.IntegralSelectOption = uidropdown(app.IntegralFigure);
            app.IntegralSelectOption.Items = {'Hình thang', 'Simpson 1/3', 'Simpson 3/8'};
            app.IntegralSelectOption.ItemsData = {'0', '1', '2'};
            app.IntegralSelectOption.FontSize = 14;
            app.IntegralSelectOption.Position = [146 204 119 22];
            app.IntegralSelectOption.Value = '1';

            % Create NhphmfxLabel
            app.NhphmfxLabel = uilabel(app.IntegralFigure);
            app.NhphmfxLabel.HorizontalAlignment = 'right';
            app.NhphmfxLabel.FontSize = 14;
            app.NhphmfxLabel.Position = [40 302 94 22];
            app.NhphmfxLabel.Text = 'Nhập hàm f(x)';

            % Create IntegralNhapHamField
            app.IntegralNhapHamField = uieditfield(app.IntegralFigure, 'text');
            app.IntegralNhapHamField.ValueChangingFcn = createCallbackFcn(app, @IntegralNhapHamFieldValueChanging, true);
            app.IntegralNhapHamField.HorizontalAlignment = 'right';
            app.IntegralNhapHamField.FontSize = 14;
            app.IntegralNhapHamField.Position = [149 302 119 22];
            app.IntegralNhapHamField.Value = 'x.^2';

            % Create NhpcnEditFieldLabel
            app.NhpcnEditFieldLabel = uilabel(app.IntegralFigure);
            app.NhpcnEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpcnEditFieldLabel.FontSize = 14;
            app.NhpcnEditFieldLabel.Position = [69 247 65 22];
            app.NhpcnEditFieldLabel.Text = 'Nhập cận';

            % Create IntegralNhapCanField
            app.IntegralNhapCanField = uieditfield(app.IntegralFigure, 'text');
            app.IntegralNhapCanField.ValueChangingFcn = createCallbackFcn(app, @IntegralNhapCanFieldValueChanging, true);
            app.IntegralNhapCanField.HorizontalAlignment = 'right';
            app.IntegralNhapCanField.FontSize = 14;
            app.IntegralNhapCanField.Position = [149 247 119 22];
            app.IntegralNhapCanField.Value = '[0;1]';

            % Create NhpNEditFieldLabel
            app.NhpNEditFieldLabel = uilabel(app.IntegralFigure);
            app.NhpNEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpNEditFieldLabel.FontSize = 14;
            app.NhpNEditFieldLabel.Position = [38 161 89 22];
            app.NhpNEditFieldLabel.Text = 'Nhập N';

            % Create IntegralNhapNField
            app.IntegralNhapNField = uieditfield(app.IntegralFigure, 'numeric');
            app.IntegralNhapNField.FontSize = 14;
            app.IntegralNhapNField.Position = [146 161 119 22];
            app.IntegralNhapNField.Value = 100;

            % Create CchnhpDropDownLabel
            app.CchnhpDropDownLabel = uilabel(app.IntegralFigure);
            app.CchnhpDropDownLabel.HorizontalAlignment = 'right';
            app.CchnhpDropDownLabel.FontSize = 14;
            app.CchnhpDropDownLabel.Position = [47 354 84 22];
            app.CchnhpDropDownLabel.Text = 'Cách nhập';

            % Create IntegralInputField
            app.IntegralInputField = uidropdown(app.IntegralFigure);
            app.IntegralInputField.Items = {'Nhập f(x)', 'Nhập x,y'};
            app.IntegralInputField.ItemsData = {'0', '1'};
            app.IntegralInputField.ValueChangedFcn = createCallbackFcn(app, @IntegralInputFieldValueChanged, true);
            app.IntegralInputField.FontSize = 14;
            app.IntegralInputField.Position = [146 354 122 22];
            app.IntegralInputField.Value = '0';

            % Create IntegralKQField
            app.IntegralKQField = uilabel(app.IntegralFigure);
            app.IntegralKQField.BackgroundColor = [1 1 1];
            app.IntegralKQField.VerticalAlignment = 'top';
            app.IntegralKQField.WordWrap = 'on';
            app.IntegralKQField.Position = [334 46 272 69];
            app.IntegralKQField.Text = '';

            % Create NhpdyxEditFieldLabel
            app.NhpdyxEditFieldLabel = uilabel(app.IntegralFigure);
            app.NhpdyxEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpdyxEditFieldLabel.FontSize = 14;
            app.NhpdyxEditFieldLabel.Position = [58 314 76 22];
            app.NhpdyxEditFieldLabel.Text = 'Nhập dãy x';

            % Create IntegralNhapXField
            app.IntegralNhapXField = uieditfield(app.IntegralFigure, 'text');
            app.IntegralNhapXField.HorizontalAlignment = 'right';
            app.IntegralNhapXField.FontSize = 14;
            app.IntegralNhapXField.Position = [149 314 119 22];
            app.IntegralNhapXField.Value = '0,1,2,3';

            % Create NhpdyyEditFieldLabel
            app.NhpdyyEditFieldLabel = uilabel(app.IntegralFigure);
            app.NhpdyyEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpdyyEditFieldLabel.FontSize = 14;
            app.NhpdyyEditFieldLabel.Position = [58 281 76 22];
            app.NhpdyyEditFieldLabel.Text = 'Nhập dãy y';

            % Create IntegralNhapYField
            app.IntegralNhapYField = uieditfield(app.IntegralFigure, 'text');
            app.IntegralNhapYField.HorizontalAlignment = 'right';
            app.IntegralNhapYField.FontSize = 14;
            app.IntegralNhapYField.Position = [149 281 119 22];
            app.IntegralNhapYField.Value = '0,1,4,9';

            % Show the figure after all components are created
            app.IntegralFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = integral_tab

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.IntegralFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.IntegralFigure)
        end
    end
end
