classdef ApproximateValue_tab < matlab.apps.AppBase

    % Properties that correspond to app components
    properties (Access = public)
        UIFigure                 matlab.ui.Figure
        SecondLabel              matlab.ui.control.Label
        ToleranceField           matlab.ui.control.NumericEditField
        NhpsaisLabel             matlab.ui.control.Label
        bField                   matlab.ui.control.NumericEditField
        bEditFieldLabel          matlab.ui.control.Label
        aField                   matlab.ui.control.NumericEditField
        aEditFieldLabel          matlab.ui.control.Label
        Loop                     matlab.ui.control.TextArea
        SlnlpTextAreaLabel       matlab.ui.control.Label
        Result                   matlab.ui.control.TextArea
        KtquLabel                matlab.ui.control.Label
        CalcButton               matlab.ui.control.Button
        LoopFunctionField        matlab.ui.control.EditField
        Label                    matlab.ui.control.Label
        Method_2                 matlab.ui.control.DropDown
        ChnphngphpDropDownLabel  matlab.ui.control.Label
        FirstLabel               matlab.ui.control.Label
        FunctionField            matlab.ui.control.EditField
        NhphmLabel               matlab.ui.control.Label
        UIAxes_2                 matlab.ui.control.UIAxes
    end

    
    methods (Access = private)
        %%%check_error%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function [f,errorFlag] = error_check(app,a,b,tolerance,f_field)
            %check_khoảng_phân_ly
            if  isempty(a) || isempty(b)
                error('Không để trống khoảng phân ly');
            elseif a > b
                error('a phải nhỏ hơn b');
            end


            %check_saiso
            if isempty(tolerance)
                error('Không để trống sai số');
            elseif tolerance <= 0
                error('Sai số phải lớn hơn 0');
            elseif tolerance > (b - a) / 2
                error('[Warning] Sai số quá lớn so với khoảng phân ly');
            end


            %check_loi_empty_va_tinh_lien_tuc_cua_ham
            if isempty(f_field)
                error('Không để trống hàm');
            else
                try
                    f = str2func(['@(x)', f_field]);
                    f(0);
                catch
                    error('Hàm nhập sai định dạng Matlab');
                end
                valueToCheckContinuous = linspace(a,b);
                for i = valueToCheckContinuous
                    if ~isreal(f(i))
                        error('Hàm nhập tồn tại giá trị phức');
                    elseif ~isfinite(f(i))
                        error(['Hàm nhập không xác định tại x = ',num2str(i)]);
                    end
                end
            end
            %Check_loi_ve_tinh_don_dieu_cua_ham_so
            syms x;
            if f(a) * f(b) >= 0
                fplot(app.UIAxes_2,f);
                xlim(app.UIAxes_2,[a b]);
                error('f(a) và f(b) phải trái dấu');
            else
                f_dh = diff(f(x));
                result_diff = double(solve(f_dh == 0,x,"Real",true));
                for i = transpose(result_diff)
                    if (i > a) && (i < b)
                        fplot(app.UIAxes_2,f);
                        xlim(app.UIAxes_2,[a b]);
                        error('Hàm số không đơn điệu trong khoảng (a,b)');
                    end
                end
            end
            errorFlag = 0;
        end


        %%%hamlap%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

        function fl = loopFunctInit(~,fl_field,f,a,b)
            syms x;
            if isempty(fl_field)
                error('Không để trống hàm lặp');
            else
                try
                    fl = str2func("@(x)"+ fl_field);
                    fl(0);
                catch
                    error('Hàm lặp sai định dạng Matlab');
                end
                valueToCheckContinuous = linspace(a,b);
                for i = valueToCheckContinuous
                    if ~isreal(fl(i)) || ~isfinite(fl(i))
                        error(['Hàm lặp không xác định tại x = ', num2str(i)]);
                    end
                end
            end
            nghiemCheck = solve(f(x) == 0,"Real",true);
            nghiemLoopCheck = solve(fl(x) == x,"Real",true);
            checkDiff = setdiff(nghiemCheck,nghiemLoopCheck);
            if ~isempty(checkDiff) & ( (checkDiff > a) | (checkDiff < b))
                error('Hàm lặp phải là biến đổi từ hàm chính');
            end
            f_dh = str2func(['@(x)',char(diff(f(x)))]);
            for i = linspace(a,b)
                if f_dh(i) > 1
                    error(['Hàm lặp không hội tụ vì có đạo hàm lớn hơn 1 tại x = ',num2str(i)]);
                end
            end
        end

        %%%pased%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function bisectMethod(app, f , a, b, tolerance, loop)
            try
                if loop >= 1000
                    app.Result.Value = "Lỗi vào vòng lặp vô tận";
                else
                    c = (a + b) / 2;
                    if f(c)*f(a) >= 0 || f(c) == 0
                            a = c;
                    else
                            b = c;
                    end
                    if f(a) == 0
                        e = 0;
                    else
                        e = b - a;
                    end
                    if e < tolerance
                            app.Result.Value = num2str(a);
                            app.Loop.Value = num2str(loop);
                    else
                            loop = loop + 1;
                            bisectMethod(app,f, a, b, tolerance, loop);
                    end
                end
            catch er
                app.Result.Value = er.message;
            end
        end

        %%%passed%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        function loopMethod(app,fp, a, b, tolerance)
            try
                x_previous = b;
                x = a;
                times = 0 ;
                while (abs(x - x_previous) >= tolerance )
                    x_previous = x;
                    x = fp(x_previous);
                    times = times + 1;
                    if ( x < a ) || (x > b) 
                        error('Hàm lặp không hội tụ');
                    end
                    if times > 1000
                        error('Vào vòng lặp vô tận');
                    end
                end
                app.Result.Value = num2str(x);
                app.Loop.Value = num2str(times);
            catch er
                app.Result.Value = er.message;
            end
        end

        %%%
        function  newtonMethod(app,f, a, b, tolerance)
           try
            syms x;
            fd1 = str2func(['@(x)', char(diff(f(x)))]);
            nostop = 1;
            temp1 = double(solve(diff(f(x)) == 0,'Real',true));
            temp2 = double(solve(diff(fd1(x)) == 0,'Real',true));
            %Kiem tra f'(x) co doi dau trong khoang phan li nghiem hay khong
            if ~isempty(temp1)
                for i=1:length(temp1)
                    if (temp1(i)<b) && (temp1(i)>a)
                        error(['Hàm đạo hàm cấp 1 của f đổi dấu trong khoảng phân ly nghiệm tại ',num2str(temp1(i))]);
                    end
                end
            end
            %Kiem tra f"(x) co doi dau trong khoang phan li nghiem hay ko
            if ~isempty(temp2)
                for i=1:length(temp2)
                    if (temp2(i)<b) && (temp2(i)>a)
                        error(['Hàm đạo hàm cấp 2 của f đổi dấu trong khoảng phân ly nghiệm tại ',num2str(temp2(i))]);   
                    end
                end
            end
            if (nostop)  
                f_dhc1 = str2func(['@(x)',char(diff(f(x)))]);
                f_dhc2 = str2func(['@(x)',char(diff(f_dhc1(x)))]);
                x0 = a;
                while f(x0) * f_dhc2(x0) <= 0 
                    x0 = (x0 + b) / 2;
                end
                xi_previous = x0;
                xi = xi_previous - f(xi_previous)/f_dhc1(xi_previous);
                times = 1;
                while abs(xi - xi_previous) > tolerance
                    xi_previous = xi;
                    xi = xi_previous - f(xi_previous)/f_dhc1(xi_previous);
                    times = times + 1;
                    if times > 100
                        error('Vòng lặp vô tận xảy ra');
                    end
                end
                app.Result.Value = num2str(xi);
                app.Loop.Value = num2str(times);
             end
           catch er
                app.Result.Value = er.message;
           end
        end

        %%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
        %check startPoint & endPoint ?
        function approximationDraw(app,f,a,b)
            try
                fplot(app.UIAxes_2,f);
                xlim(app.UIAxes_2,[a b]);
            catch
                app.Result.Value = "Không vẽ được hàm số";
            end
        end
        
    end
    

    % Callbacks that handle component events
    methods (Access = private)

        % Button pushed function: CalcButton
        function CalcButtonPushed(app, event)
            app.Result.Value = "Calculating...";
            app.Loop.Value = "";
            pause(1);
            plot(app.UIAxes_2,0,0);
            syms x;
            errorFlag = 1 ;
            a = app.aField.Value;
            b = app.bField.Value;
            tolerance = app.ToleranceField.Value;
            f_field = app.FunctionField.Value;
            %check_error
            try
                [f,errorFlag] = error_check(app,a,b,tolerance,f_field);
            catch er
                app.Result.Value = er.message;
            end
            if app.Method_2.Value == "lặp" && ~errorFlag
                try
                    fp = loopFunctInit(app,app.LoopFunctionField.Value,f,a,b);
                catch er
                    errorFlag = 1;
                    app.Result.Value = er.message;
                end
            end
            %check_error_function
            if ~errorFlag
                if app.Method_2.Value == "Chia đôi" 
                    bisectMethod(app,f,a, b, tolerance, 0);
                elseif app.Method_2.Value == "lặp" 
                    loopMethod(app,fp,a, b, tolerance);
                elseif app.Method_2.Value == "Newton"
                    newtonMethod(app,f,a, b, tolerance);
                end
                approximationDraw(app,f,a,b);
            end
        end

        % Value changed function: Method_2
        function Method_2ValueChanged(app, event)
            %%turn on - off loop function field
            if app.Method_2.Value == "lặp"
                app.LoopFunctionField.Visible = "on";
            else
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

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.UIFigure);
            title(app.UIAxes_2, 'ĐỒ THỊ HÀM SỐ')
            xlabel(app.UIAxes_2, 'x')
            ylabel(app.UIAxes_2, 'f(x)')
            zlabel(app.UIAxes_2, 'Z')
            app.UIAxes_2.Colormap = [];
            app.UIAxes_2.XGrid = 'on';
            app.UIAxes_2.YGrid = 'on';
            app.UIAxes_2.FontSize = 14;
            app.UIAxes_2.Position = [262 142 337 275];

            % Create NhphmLabel
            app.NhphmLabel = uilabel(app.UIFigure);
            app.NhphmLabel.HorizontalAlignment = 'right';
            app.NhphmLabel.FontSize = 14;
            app.NhphmLabel.Position = [19 395 70 22];
            app.NhphmLabel.Text = 'Nhập hàm';

            % Create FunctionField
            app.FunctionField = uieditfield(app.UIFigure, 'text');
            app.FunctionField.Tag = 'FunctionField';
            app.FunctionField.HorizontalAlignment = 'right';
            app.FunctionField.FontSize = 14;
            app.FunctionField.Position = [98 395 165 22];
            app.FunctionField.Value = '3*x^3 - 8*x^2 - 20*x + 16';

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

            % Create Method_2
            app.Method_2 = uidropdown(app.UIFigure);
            app.Method_2.Items = {'Chia đôi', 'lặp', 'Newton'};
            app.Method_2.ValueChangedFcn = createCallbackFcn(app, @Method_2ValueChanged, true);
            app.Method_2.FontSize = 14;
            app.Method_2.Position = [144 201 100 22];
            app.Method_2.Value = 'Chia đôi';

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
            app.LoopFunctionField.Value = '(3*x^3 - 8*x^2 + 16)/20';

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
            app.KtquLabel.Position = [70 95 53 22];
            app.KtquLabel.Text = 'Kết quả';

            % Create Result
            app.Result = uitextarea(app.UIFigure);
            app.Result.Tag = 'Result';
            app.Result.HorizontalAlignment = 'right';
            app.Result.FontSize = 14;
            app.Result.Position = [128 80 170 51];

            % Create SlnlpTextAreaLabel
            app.SlnlpTextAreaLabel = uilabel(app.UIFigure);
            app.SlnlpTextAreaLabel.HorizontalAlignment = 'right';
            app.SlnlpTextAreaLabel.FontSize = 14;
            app.SlnlpTextAreaLabel.Position = [315 95 67 22];
            app.SlnlpTextAreaLabel.Text = 'Số lần lặp';

            % Create Loop
            app.Loop = uitextarea(app.UIFigure);
            app.Loop.Tag = 'Loop';
            app.Loop.FontSize = 14;
            app.Loop.Position = [397 95 150 23];

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
            app.aField.Value = 0.2;

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
            app.bField.Value = 0.8;

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
            app.ToleranceField.Value = 0.005;

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