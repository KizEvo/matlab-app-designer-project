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

        function [xa,ya,x, emptyFlag] = checkEmpty(app)
            try
                emptyFlag = 0;
                if isempty(app.Value4Interpolation.Value)
                    x = 0;
                elseif isempty(app.xDataField.Value) || isempty(app.yDataField.Value)
                    app.ResultInter.Value = "Chưa nhập đủ dữ liệu";
                else
                    xa = str2num(app.xDataField.Value);
                    ya = str2num(app.yDataField.Value);
                    x = app.Value4Interpolation.Value;
                    if isempty(xa) || isempty(ya)
                        app.ResultInter.Value = "Kiểu dữ liệu đầu vào phải là số học"; 
                    elseif length(xa)~=length(ya)
                        app.ResultInter.Value = "2 mảng phải cùng kích thước"; %2 mang khac kich thuoc
                    elseif length(xa) == 1
                        app.ResultInter.Value = "Kích thước mảng phải lớn hơn 1"; %2mang co 1 gia tri
                    elseif sum([~isfinite(xa),~isreal(xa),~isfinite(ya),~isreal(ya)])
                        app.ResultInter.Value = "Mảng nhập vào chỉ là số thực";
                    else
                        emptyFlag = 1; %%passed
                    end
                end
            catch
                app.ResultInter.Value = "Kiểm tra lại dữ liệu nhập vào";
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%
        function result = lagrangeMethodInterpolation(~, xa, ya, x)
            try
                sum = 0;
                for i = 1: length(xa)
                    product = 1;
                    for j = 1: length(xa) 
                        if j ~= i
                            product = product*(x - xa(j))/(xa(i) - xa(j));
                        end 
                    end 
                    sum = sum + product*ya(i);
                end 
                result = num2str(sum);
            catch
                result = "Không tính được";
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%

        %%%f
        function result = newtonMethodInterpolation(~, xa, ya, x)
            try
                n = length(xa);
                a(1) = ya(1);
                for k = 1 : n - 1
                   d(k, 1) = (ya(k+1) - ya(k))/(xa(k+1) - xa(k));
                end
                for j = 2 : n - 1
                   for k = 1 : n - j
                      d(k, j) = (d(k+1, j - 1) - d(k, j - 1))/(xa(k+j) - xa(k));
                   end
                end
                for j = 2 : n
                   a(j) = d(1, j-1);
                end
                Df(1) = 1;
                c(1) = a(1);
                for j = 2 : n
                   Df(j)=(x - xa(j-1)) .* Df(j-1);
                   c(j) = a(j) .* Df(j);
                end
                result = num2str(sum(c));
            catch
                result = "Không tính được";
            end
        end
        %}

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function draw(app , xa, ya, method)
            try
                syms x;
                if method == 1
                    f(x) = app.findLagrangeFuntion(xa, ya);
                elseif method == 2
                    f(x) = app.findNewtonFunction(xa, ya);
                end
                fplot(app.UIAxes, f);
                x_min = min(xa) - (max(xa) - min(xa))/4;
                x_max = max(xa) + (max(xa) - min(xa))/4;
                xlim(app.UIAxes,[x_min x_max]);
            catch
                app.ResultInter.Value = "Lỗi vẽ đồ thị";
            end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function resultLagrange = findLagrangeFuntion(app, xData, yData)
            try
                syms x;
                n = length(xData);
                resultLagrange = 0;
                for i = (1:n)
                    temp = 1;
                    for j = (1:n)
                        if i ~= j
                            temp = simplify( temp * ( (x - xData(j)) / (xData(i) - xData(j)))); 
                        end
                    end
                    resultLagrange = resultLagrange + temp*yData(i);
                end
                resultLagrange(x) = resultLagrange;
                digits(5);
                resultLagrange(x) = resultLagrange;
                collect(resultLagrange);
                simplify(resultLagrange);
                resultLagrange = vpa(resultLagrange); 
            catch
                app.ResultInter.Value = "Lỗi ngoài ý muốn" ;
            end
        end
        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function resultNewton = findNewtonFunction(app, xData, yData)
            try
                syms x;
                n = length(xData);
                da = yData;
                for i = 1:n
                    for j = 1:(i-1)
                        da(i) = (da(j) - da(i))/(xData(j) - xData(i));
                    end
                end
                resultNewton = da(n);
                for i = n-1:-1:1
                    resultNewton = resultNewton * (x - xData(i)) + da(i);
                end
                digits(5);
                resultNewton(x) = resultNewton;
                collect(resultNewton);
                simplify(resultNewton);
                resultNewton = vpa(resultNewton); 
            catch
                app.ResultInter.Value = "Lỗi ngoài ý muốn" ;
            end
        end
    end

     
    
    


    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalcButton1
        function CalcButton1Pushed(app, event)
            app.ResultInter.Value = "";
            plot(app.UIAxes,0);
            try
                [xa, ya, x, emptyFlag] = app.checkEmpty();
                if emptyFlag == 1
                    syms x;
                    xData = xa;
                    yData = ya;
                    if app.Method.Value == "Lagrange" && emptyFlag
                        f(x) = app.findLagrangeFuntion(xData, yData);
                        app.ResultInter.Value = "y = " + string(collect(f(x)));
                        app.draw(xData, yData, 1);
                    elseif app.Method.Value == "Newton" && emptyFlag
                        f(x) = app.findNewtonFunction(xData, yData);
                        app.ResultInter.Value = "y = " + string(collect(f(x)));
                        app.draw(xData, yData, 2);
                    end
                end           
            catch 
               app.ResultInter.Value = "Lỗi ngoài ý muốn";
            end
        end

        % Button pushed function: CalcButton2
        function CalcButton2Pushed(app, event)
            try
                app.ResultInter2.Value = "";
                [xa, ya, x, emptyFlag] = app.checkEmpty();
               % app.ResultInter.Value = app.ResultInter.Value;
                if app.Method.Value == "Newton"  && emptyFlag == 1
                    result = app.newtonMethodInterpolation(xa, ya, x);  
                    app.ResultInter2.Value = result;
                elseif app.Method.Value == "Lagrange" && emptyFlag == 1
                    result = app.lagrangeMethodInterpolation(xa, ya, x);
                    app.ResultInter2.Value = result;
                end
            catch ex
                app.ResultInter.Value = "Lỗi xảy ra do người dùng nhập không đúng input";
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
            app.UIAxes.Colormap = [];
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.Position = [272 169 322 261];

            % Create NhpdliuxEditFieldLabel
            app.NhpdliuxEditFieldLabel = uilabel(app.UIFigure);
            app.NhpdliuxEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpdliuxEditFieldLabel.FontSize = 14;
            app.NhpdliuxEditFieldLabel.Position = [9 374 96 22];
            app.NhpdliuxEditFieldLabel.Text = 'Nhập dữ liệu x';

            % Create xDataField
            app.xDataField = uieditfield(app.UIFigure, 'text');
            app.xDataField.Tag = 'xDataField';
            app.xDataField.HorizontalAlignment = 'right';
            app.xDataField.FontSize = 14;
            app.xDataField.Position = [125 374 119 22];
            app.xDataField.Value = '0.1, 0.2, 0.3, 0.4';

            % Create NhpdliuyEditFieldLabel
            app.NhpdliuyEditFieldLabel = uilabel(app.UIFigure);
            app.NhpdliuyEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpdliuyEditFieldLabel.FontSize = 14;
            app.NhpdliuyEditFieldLabel.Position = [10 300 95 22];
            app.NhpdliuyEditFieldLabel.Text = 'Nhập dữ liệu y';

            % Create yDataField
            app.yDataField = uieditfield(app.UIFigure, 'text');
            app.yDataField.Tag = 'yDataField';
            app.yDataField.HorizontalAlignment = 'right';
            app.yDataField.FontSize = 14;
            app.yDataField.Position = [125 300 119 22];
            app.yDataField.Value = '0.09983, 0.19867, 0.29552, 0.38942';

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
            app.KtquathcnisuyTextAreaLabel.Position = [9 103 153 22];
            app.KtquathcnisuyTextAreaLabel.Text = 'Kết quả đa thức nội suy';

            % Create ResultInter
            app.ResultInter = uitextarea(app.UIFigure);
            app.ResultInter.FontSize = 14;
            app.ResultInter.Position = [176 83 137 61];

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
            app.KtqunisuyLabel.Position = [392 46 104 22];
            app.KtqunisuyLabel.Text = 'Kết quả nội suy';

            % Create ResultInter2
            app.ResultInter2 = uitextarea(app.UIFigure);
            app.ResultInter2.FontSize = 14;
            app.ResultInter2.Position = [504 44 90 25];

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