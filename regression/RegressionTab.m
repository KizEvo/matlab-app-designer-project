classdef RegressionTab < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        RegressionFigure          matlab.ui.Figure
        RegressionResult          matlab.ui.control.Label
        RegressionButton          matlab.ui.control.Button
        RegressionPredicted       matlab.ui.control.NumericEditField
        NhpgitrdonEditFieldLabel  matlab.ui.control.Label
        RegressionMethod          matlab.ui.control.DropDown
        PhngphpDropDownLabel      matlab.ui.control.Label
        RegressionInputY          matlab.ui.control.EditField
        NhpXLabel_2               matlab.ui.control.Label
        RegressionInputX          matlab.ui.control.EditField
        NhpXLabel                 matlab.ui.control.Label
        RegressionAxes            matlab.ui.control.UIAxes
    end

    
methods (Access = private)
        
    function [loi,X,Y] = check_error(~,x,y,option)
           if isempty(x) || isempty(y)
                 error('Không để trống x,y ');
           elseif length(str2num(x)) ~= length(str2num(y))
                 error('x,y phải nhập đúng format là a,b,c và kích thước bằng nhau');
           else
                 X = str2num(x);
                 Y = str2num(y);
           end
           if option == '1'  %ham mu y = ae^bx
                 if (sum(sign(Y)) < length(Y))
                     error('Gia tri y phai lon hon 0');
                 end
                 loi = 0; 
           elseif option == '2' %ham mu y = ax^b
                 if (sum(sign(Y)) < length(Y)) && (sum(sign(X)) < length(X))
                     error('Gia tri x,y phai lon hon 0');
                 end
                 loi = 0;                  
           elseif option == '3'
                 if (sum(sign(X)) < length(X))
                     error('Gia tri x phai lon hon 0');
                 end
                 loi = 0; 
           else
                 loi = 0;
           end
    end
end

    % Callbacks that handle component events
    methods (Access = private)

        % Code that executes after component creation
        function startupFcn(app)

            app.RegressionResult.Visible = 0;
            app.RegressionResult.Interpreter = 'latex';
        end

        % Button pushed function: RegressionButton
        function RegressionButtonPushed(app, event)
            x_char = app.RegressionInputX.Value;
            y_char = app.RegressionInputY.Value;
            option = app.RegressionMethod.Value;
            Dudoan = app.RegressionPredicted.Value;
            loi = 1;
            try
                [loi,x_num,y_num] = check_error(app,x_char,y_char,option);
            catch er
                 app.RegressionResult.Visible = 'on';
                 app.RegressionResult.Text = ['[ERROR]: ' , er.message];
            end
            syms x;

            if loi == 0
                try
                if option == '0'
                    x_data = x_num;
                    y_data = y_num;
                    n = length(x_data);
                    sumx = sum(x_data);
                    sumy = sum(y_data);
                    sumxy = sum(x_data.*y_data);
                    sumx2 = sum(x_data.^2);
                    x_tb = sumx / n;
                    y_tb = sumy / n;
                    a1 = (n*sumxy - sumx*sumy)/(n*sumx2 - sumx*sumx);
                    a0 = y_tb - a1*x_tb;
                    Sr = sum((y_data-a0-a1*x_data).^2);
                    St = sum((y_data-y_tb).^2);
                    r2 = (St - Sr) / St;
                    f = @(x) (a0 + a1*x);
                elseif option == '1'   % a*e^(b*x)
                    x_data = x_num;
                    y_data = log(y_num);
                    n = length(x_data);
                    sumx = sum(x_data);
                    sumy = sum(y_data);
                    sumxy = sum(x_data.*y_data);
                    sumx2 = sum(x_data.^2);
                    x_tb = sumx / n;
                    y_tb = sumy / n;
                    a1 = (n*sumxy - sumx*sumy)/(n*sumx2 - sumx*sumx);
                    a0 = y_tb - a1*x_tb;
                    beta = a1;
                    alpha = exp(a0);
                    f = @(x) (alpha.*exp(x*beta));                    
                    Sr = sum((y_data-a0-a1*x_data).^2);
                    St = sum((y_data-y_tb).^2);
                    r2 = (St - Sr) / St;
                elseif option == '2'   % a*x^(b)
                    x_data = log(x_num);
                    y_data = log(y_num);
                    n = length(x_data);
                    sumx = sum(x_data);
                    sumy = sum(y_data);
                    sumxy = sum(x_data.*y_data);
                    sumx2 = sum(x_data.^2);
                    x_tb = sumx / n;
                    y_tb = sumy / n;
                    a1 = (n*sumxy - sumx*sumy)/(n*sumx2 - sumx*sumx);
                    a0 = y_tb - a1*x_tb;
                    beta = a1;
                    alpha = 10^a0;
                    f = @(x) (alpha*x^beta);    
                    Sr = sum((y_data-a0-a1*x_data).^2);
                    St = sum((y_data-y_tb).^2);
                    r2 = (St - Sr) / St;
                else %  aln(x) + b
                    x_data = log(x_num);
                    y_data = y_num;
                    n = length(x_data);
                    sumx = sum(x_data);
                    sumy = sum(y_data);
                    sumxy = sum(x_data.*y_data);
                    sumx2 = sum(x_data.^2);
                    x_tb = sumx / n;
                    y_tb = sumy / n;
                    a1 = (n*sumxy - sumx*sumy)/(n*sumx2 - sumx*sumx);
                    a0 = y_tb - a1*x_tb;
                    beta = a0;
                    alpha = a1;
                    f = @(x) (alpha*log(x) + beta);    
                    Sr = sum((y_data-a0-a1*x_data).^2);
                    St = sum((y_data-y_tb).^2);
                    r2 = (St - Sr) / St;
                end
                app.RegressionResult.Visible = 'on';
                fplot(app.RegressionAxes,f);
                hold(app.RegressionAxes,'on');
                scatter(app.RegressionAxes,x_num,y_num);
                x_axes_min = min(x_num) - (max(x_num) - min(x_num))/4;
                x_axes_max = max(x_num) + (max(x_num) - min(x_num))/4;
                xlim(app.RegressionAxes,[x_axes_min x_axes_max]);
                hold(app.RegressionAxes,'off');
                legend(app.RegressionAxes,'Predicted Value','True Value');
                Giatridudoan = double(f(Dudoan));
                app.RegressionResult.Text = {['Ket qua du doan: ',num2str(Giatridudoan)],['He so tuong quan: ',num2str(r2)]};
                catch
                app.RegressionResult.Text = '[ERROR]: Loi xay ra';
                end
            end
        end
    end

    % Component initialization
    methods (Access = private)

        % Create UIFigure and components
        function createComponents(app)

            % Create RegressionFigure and hide until all components are created
            app.RegressionFigure = uifigure('Visible', 'off');
            app.RegressionFigure.Position = [100 100 640 480];
            app.RegressionFigure.Name = 'MATLAB App';

            % Create RegressionAxes
            app.RegressionAxes = uiaxes(app.RegressionFigure);
            title(app.RegressionAxes, 'Biểu đồ hồi quy')
            xlabel(app.RegressionAxes, 'X')
            ylabel(app.RegressionAxes, 'Y')
            zlabel(app.RegressionAxes, 'Z')
            app.RegressionAxes.FontSize = 14;
            app.RegressionAxes.Position = [295 167 314 211];

            % Create NhpXLabel
            app.NhpXLabel = uilabel(app.RegressionFigure);
            app.NhpXLabel.HorizontalAlignment = 'right';
            app.NhpXLabel.Position = [103 343 46 22];
            app.NhpXLabel.Text = 'Nhập X';

            % Create RegressionInputX
            app.RegressionInputX = uieditfield(app.RegressionFigure, 'text');
            app.RegressionInputX.HorizontalAlignment = 'right';
            app.RegressionInputX.Position = [164 343 100 22];
            app.RegressionInputX.Value = '1,2,3';

            % Create NhpXLabel_2
            app.NhpXLabel_2 = uilabel(app.RegressionFigure);
            app.NhpXLabel_2.HorizontalAlignment = 'right';
            app.NhpXLabel_2.Position = [104 302 45 22];
            app.NhpXLabel_2.Text = 'Nhập Y';

            % Create RegressionInputY
            app.RegressionInputY = uieditfield(app.RegressionFigure, 'text');
            app.RegressionInputY.HorizontalAlignment = 'right';
            app.RegressionInputY.Position = [164 302 100 22];
            app.RegressionInputY.Value = '10,1,2';

            % Create PhngphpDropDownLabel
            app.PhngphpDropDownLabel = uilabel(app.RegressionFigure);
            app.PhngphpDropDownLabel.HorizontalAlignment = 'right';
            app.PhngphpDropDownLabel.Position = [43 261 79 22];
            app.PhngphpDropDownLabel.Text = 'Phương pháp';

            % Create RegressionMethod
            app.RegressionMethod = uidropdown(app.RegressionFigure);
            app.RegressionMethod.Items = {'Tuyến tính αx + β', 'Hàm mũ αeᵝˣ', 'Hàm mũ αxᵝ', 'Logarit αln(x) + β'};
            app.RegressionMethod.ItemsData = {'0', '1', '2', '3', ''};
            app.RegressionMethod.Position = [135 261 129 22];
            app.RegressionMethod.Value = '3';

            % Create NhpgitrdonEditFieldLabel
            app.NhpgitrdonEditFieldLabel = uilabel(app.RegressionFigure);
            app.NhpgitrdonEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpgitrdonEditFieldLabel.Position = [34 217 115 22];
            app.NhpgitrdonEditFieldLabel.Text = 'Nhập giá trị dự đoán';

            % Create RegressionPredicted
            app.RegressionPredicted = uieditfield(app.RegressionFigure, 'numeric');
            app.RegressionPredicted.Position = [164 217 100 22];
            app.RegressionPredicted.Value = 1.5;

            % Create RegressionButton
            app.RegressionButton = uibutton(app.RegressionFigure, 'push');
            app.RegressionButton.ButtonPushedFcn = createCallbackFcn(app, @RegressionButtonPushed, true);
            app.RegressionButton.FontSize = 14;
            app.RegressionButton.Position = [164 162 100 24];
            app.RegressionButton.Text = 'Tìm kết quả';

            % Create RegressionResult
            app.RegressionResult = uilabel(app.RegressionFigure);
            app.RegressionResult.BackgroundColor = [1 1 1];
            app.RegressionResult.VerticalAlignment = 'top';
            app.RegressionResult.WordWrap = 'on';
            app.RegressionResult.Position = [325 67 275 66];
            app.RegressionResult.Text = '';

            % Show the figure after all components are created
            app.RegressionFigure.Visible = 'on';
        end
    end

    % App creation and deletion
    methods (Access = public)

        % Construct app
        function app = RegressionTab

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.RegressionFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

            if nargout == 0
                clear app
            end
        end

        % Code that executes before app deletion
        function delete(app)

            % Delete UIFigure when app is deleted
            delete(app.RegressionFigure)
        end
    end
end