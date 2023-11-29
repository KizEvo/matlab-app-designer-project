classdef Interpolations_tab < matlab.apps.AppBase

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
                emptyFlag = 1; %o nhap x trong
            else
                xa = str2num(app.xDataField.Value);
                ya = str2num(app.yDataField.Value);
                x = app.Value4Interpolation.Value;

                if length(xa)~=length(ya)
                    app.ResultInter.Value = "2 mảng phải cùng kích thước" %2 mang khac kich thuoc
                elseif length(xa) == 1
                    app.ResultInter.Value = "Kích thước mảng phải lớn hơn 1" %2mang co 1 gia tri
                else
                    emptyFlag = 2; %%passed
                end
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%
        function result = lagrangeMethodInterpolation(~, xa, ya, x)
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
        end

        %%%%%%%%%%%%%%%%%%%%%%%%
        
        function result = newtonMethodInterpolation(~, xa, ya, x)
            n= length(xa);
            d = ya;
            for i = 1:n
                for j = 1:i-1
                    d(i) = (d(j) -d(i)) / (xa(j) - xa(i));
                end
            end
            
            f = zeros(n,n);
            f(:, 1) = ya;
            for j = 2:n
                for i = 1:n-j+1
                    f(i,j) = (f(i+1,j-1) - f(i, j-1)) / (xa(i+j-1) - xa(i));
                end
            end

            result = f(1,1);
            for j = 2:n
                term = 1;
                for i = 1:j-1
                    term = term * (x - xa(i));
                end
                result = result + f(1,j)*term;
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function draw(app, xa, ya)
            plot(app.UIAxes,xa,ya);
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        
        function resultLagrange = findLagrangeFuntion(app, xData, yData)
           syms x;
           n = length(xData);
           lagrangePolynomial = 0;

           for i=1:n
               Li = 1;
               for j=1:n
                   if j~=i
                       Li = Li*(x -  xData(j)) / (xData(i) - xData(j));
                   end
               end
               lagrangePolynomial = lagrangePolynomial +Li*yData(i);
           end
           resultLagrange = lagrangePolynomial;
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function resultNewton = findNewtonFunction(~, xData, yData)
            syms x;
            n = length(xData);
            d = yData;
            for i = 1:n
                for j = 1:i-1
                    d(i) = (d(j) - d(i)) / (xData(j) - xData(i));
                end
            end
            newtonPolynomial = d(1,1);

            for i=2:n
                term = 1;
                for j=1:i-1
                    term = term*(x-xData(j));
                end
                newtonPolynomial = newtonPolynomial  + d(1,i) * term;
            end

            resultNewton = newtonPolynomial;
        end

    end

     
    
    


    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalcButton1
        function CalcButton1Pushed(app, event)
            [xa, ya, x, emptyFlag] = app.dataInput();
            if emptyFlag == 2

                syms x;
                xData = str2num(app.xDataField.Value);
                yData = str2num(app.yDataField.Value);
    
                if app.Method.ValueIndex == 2 && emptyFlag
                    f(x) = app.findLagrangeFuntion(xData, yData);
                    app.ResultInter.Value = "y = " + string(f);
                    app.draw(xa, ya);
                elseif app.Method.ValueIndex == 1 && emptyFlag
                    f(x) = app.findNewtonFunction(xData, yData);
                    app.ResultInter.Value = "y = " + string(f);
                    app.draw(xa, ya);
                end
            
            end            

        end

        % Button pushed function: CalcButton2
        function CalcButton2Pushed(app, event)
         
            [xa, ya, x, emptyFlag] = app.dataInput();
            if emptyFlag == 1 &&  app.Method.ValueIndex == 2
                result = app.newtonMethodInterpolation(xa, ya, x);  
                app.ResultInter2.Value = num2str(result);
                app.draw(xa, ya);
            elseif app.Method.ValueIndex == 2 && emptyFlag == 2
                result = app.lagrangeMethodInterpolation(xa, ya, x);
                app.ResultInter2.Value = num2str(result);
                app.draw(xa, ya);
            elseif emptyFlag == 1
                app.ResultInter2.Value = "Nhập giá trị cần nội suy";
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
            app.CalcButton1.IconAlignment = 'center';
            app.CalcButton1.FontSize = 14;
            app.CalcButton1.Position = [92 169 100 25];
            app.CalcButton1.Text = 'Tìm đa thức';

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
        function app = Interpolations_tab

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