classdef Interpolations < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                    matlab.ui.Figure
        Value4Interpolation         matlab.ui.control.NumericEditField
        GitrcnnisuyEditFieldLabel   matlab.ui.control.Label
        ResultInter2                matlab.ui.control.TextArea
        KtqunisuyLabel              matlab.ui.control.Label
        CalcButton2                 matlab.ui.control.Button
        ResultInter                 matlab.ui.control.TextArea
        KtquathcnisuyTextAreaLabel  matlab.ui.control.Label
        CalcButton1                 matlab.ui.control.Button
        Method                      matlab.ui.control.DropDown
        PhngphpDropDownLabel        matlab.ui.control.Label
        yDataField                  matlab.ui.control.EditField
        NhpdliuyEditFieldLabel      matlab.ui.control.Label
        xDataField                  matlab.ui.control.EditField
        NhpdliuxEditFieldLabel      matlab.ui.control.Label
        UIAxes                      matlab.ui.control.UIAxes
    end


    methods (Access = private)

        function [xa,ya,x, emptyFlag] = dataInput(app)
            emptyFlag = 0;
            if isempty(app.Value4Interpolation.Value)
                app.ResultInter2.Value = "Nhập chưa đủ dữ liệu";
            else
                xa = str2num(app.xDataField.Value);
                ya = str2num(app.yDataField.Value);
                x = app.Value4Interpolation.Value;
                emptyFlag = 1;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%
        function  langrangeMethod(app, xa, ya, x)
            sum = 0;
            for i = 1: length(xa)
                product = ya(i);
                for j = 1: length(xa) 
                    if i ~= j 
                        product = product*(x - xa(i))/(xa(i) - xa(j));
                    end 
                end 
                sum = sum + product;
            end 
            result = sum;
            app.ResultInter2.Value = num2str(result);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%
        function d = dividedDifference(~, xa, ya)
           n = length(xa);
           d = ya;
           for i = 1 : n 
               for j = 1 : i-1 
                   d(i)=(d(j) - d(i))/(xa(j)- xa(i));
               end 
           end 
        end

        function result = newtonForm(~, xa, da, x)
            n = length(da);
            result = da(n);
            for i = n-1:1 
                result = result * (x - xa(i)) + da(i);
            end
        end
        
        function newtonMethod = newtonInterpolation(app, xa, ya, x)
            newtonMethod = app.newtonForm(xa, app.dividedDifference(xa,ya) ,x);
            app.ResultInter2.Value = num2str(newtonMethod);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function draw(app, xa, ya)
            plot(app.UIAxes,xa,ya);
        end
    end
    
    


    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalcButton1
        function CalcButton1Pushed(app, event)
            [xa, ya, x, emptyFlag] = app.dataInput();
            if app.Method.ValueIndex == 2 && emptyFlag
                %%%ket qua da thuc noi suy???
            elseif app.Method.ValueIndex == 1 && emptyFlag
                %%%ket qua da thuc noi suy???
            end            

        end

        % Button pushed function: CalcButton2
        function CalcButton2Pushed(app, event)
         
            [xa, ya, x, emptyFlag] = app.dataInput();
            if app.Method.ValueIndex == 2 && emptyFlag
                app.langrangeMethod(xa, ya, x);
                app.draw(xa, ya);
            elseif app.Method.ValueIndex == 1 && emptyFlag
                app.newtonInterpolation(xa, ya, x);   
                app.draw(xa, ya);
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
            title(app.UIAxes, 'ĐỒ THỊ ')
            xlabel(app.UIAxes, 'x')
            ylabel(app.UIAxes, 'y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [272 169 322 261];

            % Create NhpdliuxEditFieldLabel
            app.NhpdliuxEditFieldLabel = uilabel(app.UIFigure);
            app.NhpdliuxEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpdliuxEditFieldLabel.FontSize = 14;
            app.NhpdliuxEditFieldLabel.Position = [33 374 96 22];
            app.NhpdliuxEditFieldLabel.Text = 'Nhập dữ liệu x';

            % Create xDataField
            app.xDataField = uieditfield(app.UIFigure, 'text');
            app.xDataField.Tag = 'xDataField';
            app.xDataField.FontSize = 14;
            app.xDataField.Position = [144 374 100 22];

            % Create NhpdliuyEditFieldLabel
            app.NhpdliuyEditFieldLabel = uilabel(app.UIFigure);
            app.NhpdliuyEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpdliuyEditFieldLabel.FontSize = 14;
            app.NhpdliuyEditFieldLabel.Position = [33 300 96 22];
            app.NhpdliuyEditFieldLabel.Text = 'Nhập dữ liệu y';

            % Create yDataField
            app.yDataField = uieditfield(app.UIFigure, 'text');
            app.yDataField.Tag = 'yDataField';
            app.yDataField.FontSize = 14;
            app.yDataField.Position = [144 300 100 22];

            % Create PhngphpDropDownLabel
            app.PhngphpDropDownLabel = uilabel(app.UIFigure);
            app.PhngphpDropDownLabel.HorizontalAlignment = 'right';
            app.PhngphpDropDownLabel.FontSize = 14;
            app.PhngphpDropDownLabel.Position = [35 230 91 22];
            app.PhngphpDropDownLabel.Text = 'Phương pháp';

            % Create Method
            app.Method = uidropdown(app.UIFigure);
            app.Method.Items = {'Newton', 'Lagrange'};
            app.Method.FontSize = 14;
            app.Method.Position = [141 230 100 22];
            app.Method.Value = 'Newton';

            % Create CalcButton1
            app.CalcButton1 = uibutton(app.UIFigure, 'push');
            app.CalcButton1.ButtonPushedFcn = createCallbackFcn(app, @CalcButton1Pushed, true);
            app.CalcButton1.FontSize = 14;
            app.CalcButton1.Position = [92 169 100 25];
            app.CalcButton1.Text = 'Tính';

            % Create KtquathcnisuyTextAreaLabel
            app.KtquathcnisuyTextAreaLabel = uilabel(app.UIFigure);
            app.KtquathcnisuyTextAreaLabel.HorizontalAlignment = 'right';
            app.KtquathcnisuyTextAreaLabel.FontSize = 14;
            app.KtquathcnisuyTextAreaLabel.Position = [9 120 153 22];
            app.KtquathcnisuyTextAreaLabel.Text = 'Kết quả đa thức nội suy';

            % Create ResultInter
            app.ResultInter = uitextarea(app.UIFigure);
            app.ResultInter.FontSize = 14;
            app.ResultInter.Position = [176 118 137 26];

            % Create CalcButton2
            app.CalcButton2 = uibutton(app.UIFigure, 'push');
            app.CalcButton2.ButtonPushedFcn = createCallbackFcn(app, @CalcButton2Pushed, true);
            app.CalcButton2.FontSize = 14;
            app.CalcButton2.Position = [272 44 100 25];
            app.CalcButton2.Text = 'Tính';

            % Create KtqunisuyLabel
            app.KtqunisuyLabel = uilabel(app.UIFigure);
            app.KtqunisuyLabel.HorizontalAlignment = 'right';
            app.KtqunisuyLabel.FontSize = 14;
            app.KtqunisuyLabel.Position = [392 45 104 22];
            app.KtqunisuyLabel.Text = 'Kết quả nội suy';

            % Create ResultInter2
            app.ResultInter2 = uitextarea(app.UIFigure);
            app.ResultInter2.FontSize = 14;
            app.ResultInter2.Position = [504 43 90 26];

            % Create GitrcnnisuyEditFieldLabel
            app.GitrcnnisuyEditFieldLabel = uilabel(app.UIFigure);
            app.GitrcnnisuyEditFieldLabel.HorizontalAlignment = 'right';
            app.GitrcnnisuyEditFieldLabel.FontSize = 14;
            app.GitrcnnisuyEditFieldLabel.Position = [10 45 117 22];
            app.GitrcnnisuyEditFieldLabel.Text = 'Giá trị cần nội suy';

            % Create Value4Interpolation
            app.Value4Interpolation = uieditfield(app.UIFigure, 'numeric');
            app.Value4Interpolation.Tag = 'Value4Interpolation';
            app.Value4Interpolation.FontSize = 14;
            app.Value4Interpolation.Position = [142 45 100 22];

            % Show the figure after all components are created
            app.UIFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = Interpolations

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
