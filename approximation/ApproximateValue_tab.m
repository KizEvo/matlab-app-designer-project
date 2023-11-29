classdef ApproximateValue_tab < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                   matlab.ui.Figure
        SecondLabel                matlab.ui.control.Label
        ToleranceField             matlab.ui.control.NumericEditField
        NhpsaisLabel               matlab.ui.control.Label
        bField                     matlab.ui.control.NumericEditField
        bEditFieldLabel            matlab.ui.control.Label
        aField                     matlab.ui.control.NumericEditField
        aEditFieldLabel            matlab.ui.control.Label
        Loop                       matlab.ui.control.TextArea
        SlnlpTextAreaLabel         matlab.ui.control.Label
        Result                     matlab.ui.control.TextArea
        KtquLabel                  matlab.ui.control.Label
        CalcButton                 matlab.ui.control.Button
        LoopFunctionField          matlab.ui.control.EditField
        Label                      matlab.ui.control.Label
        Method                     matlab.ui.control.DropDown
        ChnphngphpDropDownLabel    matlab.ui.control.Label
        FirstLabel                 matlab.ui.control.Label
        FunctionField              matlab.ui.control.EditField
        NhpphngtrnhEditFieldLabel  matlab.ui.control.Label
        UIAxes                     matlab.ui.control.UIAxes
    end

    
    methods (Access = private)
        %%%Passed%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function checkEmptyField = checkEmpty(app)
            if isempty(app.FunctionField.Value) 
                checkEmptyField = 101;                
            elseif isempty(app.aField.Value) || isempty(app.bField.Value)
                checkEmptyField = 102;                
            elseif isempty(app.ToleranceField.Value)
                checkEmptyField = 103;
            elseif isempty(app.LoopFunctionField.Value) && app.Method.ValueIndex == 2
                checkEmptyField = 104;
            else
                checkEmptyField = 000;
            end
        end

        %%%passed%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %%%create input function & loop function 
        function f = functInit(app)
            try   
                f = str2func("@(x)"+app.FunctionField.Value);
            catch
                app.Result.Value = "Nhập sai định dạng Matlab";
            end
        end

        function f = loopFunctInit(app)
            try   
                f = str2func("@(x)"+app.LoopFunctionField.Value);
            catch
                app.Result.Value = "Nhập sai định dạng Matlab";
            end
        end

        %%%pased%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function bisectMethod(app, a, b, tolerance, loop)
            f = app.functInit();
            if f(a)*f(b) > 0 
                app.Result.Value = "Vô nghiệm trong khoảng phân li";
            else
                c = (a + b) / 2;
                if f(c)*f(a) >= 0 
                    a = c;
                else
                    b = c;
                end
                e = b - a;
                if e < tolerance
                    app.Result.Value = num2str(a);
                    app.Loop.Value = num2str(loop);
                else
                    loop = loop + 1;
                    bisectMethod(app, a, b, tolerance, loop);
                end
            end

        end

        %%%passed%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function loopMethod(app, fp, a, b, tolerance, loop)
            firstValue = a;
            secondValue = fp(firstValue);
            b = firstValue;
            a = secondValue;
   
            e = abs(secondValue - firstValue);

            if e < tolerance
                app.Result.Value = giaTriSau;
                app.Loop.Value = loop;
            else
                loop = loop + 1;
                loopMethod(app,fb, a, b, saiso, loop);
            end
        end

        %%%checking
        function  newtonMethod(app, a, b, tolerance, loop)
            f = app.functInit();
            syms x;
            f_dh = str2func(["@(x)" ,char(diff(f(x)))]);
            f_dh2 = str2func(["@(x)" ,char(diff(f_dh(x)))]);

            nostop = 1;
            temp1 = double(solve(diff(f(x))));
            temp2 = double(solve(diff(f_dh(x))));

            %check f'(x)
            if ~isempty(temp1)
                for i=1:length(temp1)
                    if (temp1(i)<=b) && (temp1(i)>=a)
                        nostop=0;
                        app.Result.Value = "Không xác định";
                        app.Loop.Value = "Không xác định";
                        break;
                    end
                end
            end
            %check f"(x) 
            if ~isempty(temp2)
                for i=1:length(temp2)
                    if (temp2(i)<=b) && (temp2(i)>=a)
                        nostop=0;
                        app.Result.Value = "Không xác định";
                        app.Loop.Value = "Không xác định";
                        break;
                    end
                end
            end
            if (nostop)
                if (f_dh(a)*f_dh2(a)) <= 0
                    newtonMethod(app, f, (a+b)/2, b, tolerance, loop);
                else
                    firstValue = a;
                    secondValue = firstValue - f(firstValue)/f_dh(firstValue);
                    e = abs(secondValue - firstValue);

                    if e < tolerance
                        app.Result.Value = secondValue+"";
                        app.Loop.Value = loop+"";
                    else
                        loop = loop + 1;
                        newtonMethod(app, f, secondValue, b, tolerance, loop);
                    end
                end 
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %check startPoint & endPoint ?
        function draw(app,f,a,b)
            x = a:0.01:b;
            y = f(x);
            plot(app.UIAxes,x,y);
        end
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalcButton
        function CalcButtonPushed(app, event)

            %%%%check error before
              passedFlag = 000; %%flag executes each task
                switch app.checkEmpty()
                  case 101
                       app.Result.Value = "Hãy nhập hàm cần tính";
                  case 102
                       app.Result.Value = "Hãy nhập khoảng phân li nghiệm";
                  case 103
                       app.Result.Value = "Hãy nhập sai số cho phép";
                  case 104
                       app.Result.Value = "Hãy nhập hàm lặp";
                  case 000
                      passedFlag = 201;
                end
            % %%%%%%%%%%%%%%
            % %%%calculate
            % 
            if passedFlag == 201
                a = app.aField.Value;
                b = app.bField.Value;
                tolerance = app.ToleranceField.Value;

                if app.Method.ValueIndex == 1
                    app.bisectMethod(a, b, tolerance, 0);
                    passedFlag = 202;

                elseif app.Method.ValueIndex == 2
                    fp = app.loopFunctInit();
                    app.loopMehod(fp, a, b, tolerance, 0);
                    passedFlag = 202;
                    
                elseif app.Method.ValueIndex == 3
                    app.newtonMethod(a, b, tolerance, 0);
                    passedFlag = 202;
                end
            else
                %nothing to do
            end

            %%%draw plot
            if passedFlag == 202
                f = app.functInit();
                draw(app,f,a,b);
            else
                % nothing to do
            end
        end

        % Value changed function: Method
        function MethodValueChanged(app, event)
            %%turn on - off loop function field
            if app.Method.ValueIndex == 2
                app.clear;
                app.LoopFunctionField.Visible = "on";
            else
                app.clear;
                app.LoopFunctionField.Visible = "off";
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create UIFigure and hide until all components are created
            app.UIFigure = uifigure('Visible', 'off');
            app.UIFigure.Position = [100 100 640 480];
            app.UIFigure.Name = 'MATLAB App';

            % Create UIAxes
            app.UIAxes = uiaxes(app.UIFigure);
            title(app.UIAxes, 'ĐỒ THỊ HÀM SỐ')
            xlabel(app.UIAxes, 'x')
            ylabel(app.UIAxes, 'f(x)')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.FontSize = 14;
            app.UIAxes.Position = [262 142 337 275];

            % Create NhpphngtrnhEditFieldLabel
            app.NhpphngtrnhEditFieldLabel = uilabel(app.UIFigure);
            app.NhpphngtrnhEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpphngtrnhEditFieldLabel.FontSize = 14;
            app.NhpphngtrnhEditFieldLabel.Position = [2 395 128 22];
            app.NhpphngtrnhEditFieldLabel.Text = 'Nhập phương trình ';

            % Create FunctionField
            app.FunctionField = uieditfield(app.UIFigure, 'text');
            app.FunctionField.Tag = 'FunctionField';
            app.FunctionField.FontSize = 14;
            app.FunctionField.Position = [145 395 100 22];

            % Create FirstLabel
            app.FirstLabel = uilabel(app.UIFigure);
            app.FirstLabel.Tag = 'FirstLabel';
            app.FirstLabel.FontSize = 14;
            app.FirstLabel.Position = [16 344 217 22];
            app.FirstLabel.Text = 'Nhập khoảng phân li nghiệm (a,b)';

            % Create ChnphngphpDropDownLabel
            app.ChnphngphpDropDownLabel = uilabel(app.UIFigure);
            app.ChnphngphpDropDownLabel.HorizontalAlignment = 'right';
            app.ChnphngphpDropDownLabel.FontSize = 14;
            app.ChnphngphpDropDownLabel.Position = [2 201 127 22];
            app.ChnphngphpDropDownLabel.Text = 'Chọn phương pháp';

            % Create Method
            app.Method = uidropdown(app.UIFigure);
            app.Method.Items = {'Chia đôi', 'lặp', 'Newton'};
            app.Method.ValueChangedFcn = createCallbackFcn(app, @MethodValueChanged, true);
            app.Method.FontSize = 14;
            app.Method.Position = [144 201 100 22];
            app.Method.Value = 'Chia đôi';

            % Create Label
            app.Label = uilabel(app.UIFigure);
            app.Label.HorizontalAlignment = 'right';
            app.Label.FontSize = 14;
            app.Label.Position = [108 150 25 22];
            app.Label.Text = '';

            % Create LoopFunctionField
            app.LoopFunctionField = uieditfield(app.UIFigure, 'text');
            app.LoopFunctionField.Tag = 'LoopFunctionField';
            app.LoopFunctionField.FontSize = 14;
            app.LoopFunctionField.Visible = 'off';
            app.LoopFunctionField.Position = [109 150 154 22];

            % Create CalcButton
            app.CalcButton = uibutton(app.UIFigure, 'push');
            app.CalcButton.ButtonPushedFcn = createCallbackFcn(app, @CalcButtonPushed, true);
            app.CalcButton.FontSize = 14;
            app.CalcButton.Position = [272 20 100 25];
            app.CalcButton.Text = 'Tính';

            % Create KtquLabel
            app.KtquLabel = uilabel(app.UIFigure);
            app.KtquLabel.HorizontalAlignment = 'right';
            app.KtquLabel.FontSize = 14;
            app.KtquLabel.Position = [70 81 53 22];
            app.KtquLabel.Text = 'Kết quả';

            % Create Result
            app.Result = uitextarea(app.UIFigure);
            app.Result.Tag = 'Result';
            app.Result.FontSize = 14;
            app.Result.Position = [128 80 170 23];

            % Create SlnlpTextAreaLabel
            app.SlnlpTextAreaLabel = uilabel(app.UIFigure);
            app.SlnlpTextAreaLabel.HorizontalAlignment = 'right';
            app.SlnlpTextAreaLabel.FontSize = 14;
            app.SlnlpTextAreaLabel.Position = [314 79 67 22];
            app.SlnlpTextAreaLabel.Text = 'Số lần lặp';

            % Create Loop
            app.Loop = uitextarea(app.UIFigure);
            app.Loop.Tag = 'Loop';
            app.Loop.FontSize = 14;
            app.Loop.Position = [396 79 150 23];

            % Create aEditFieldLabel
            app.aEditFieldLabel = uilabel(app.UIFigure);
            app.aEditFieldLabel.HorizontalAlignment = 'right';
            app.aEditFieldLabel.FontSize = 14;
            app.aEditFieldLabel.Position = [17 315 25 22];
            app.aEditFieldLabel.Text = 'a';

            % Create aField
            app.aField = uieditfield(app.UIFigure, 'numeric');
            app.aField.FontSize = 14;
            app.aField.Position = [57 315 42 22];

            % Create bEditFieldLabel
            app.bEditFieldLabel = uilabel(app.UIFigure);
            app.bEditFieldLabel.HorizontalAlignment = 'right';
            app.bEditFieldLabel.FontSize = 14;
            app.bEditFieldLabel.Position = [142 315 25 22];
            app.bEditFieldLabel.Text = 'b';

            % Create bField
            app.bField = uieditfield(app.UIFigure, 'numeric');
            app.bField.FontSize = 14;
            app.bField.Position = [182 315 52 22];

            % Create NhpsaisLabel
            app.NhpsaisLabel = uilabel(app.UIFigure);
            app.NhpsaisLabel.HorizontalAlignment = 'right';
            app.NhpsaisLabel.FontSize = 14;
            app.NhpsaisLabel.Position = [18 268 79 22];
            app.NhpsaisLabel.Text = 'Nhập sai số';

            % Create ToleranceField
            app.ToleranceField = uieditfield(app.UIFigure, 'numeric');
            app.ToleranceField.FontSize = 14;
            app.ToleranceField.Position = [114 268 120 22];

            % Create SecondLabel
            app.SecondLabel = uilabel(app.UIFigure);
            app.SecondLabel.FontSize = 14;
            app.SecondLabel.Position = [17 150 92 22];
            app.SecondLabel.Text = 'Nhập hàm lặp';

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = ApproximateValue_tab

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