classdef Kiv_final < matlab.apps.AppBase

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
        IntegralNhapHamField        matlab.ui.control.EditField
        NhphmfxLabel                matlab.ui.control.Label
        IntegralNhapNField          matlab.ui.control.NumericEditField
        NhpNEditFieldLabel          matlab.ui.control.Label
        IntegralSelectOption        matlab.ui.control.DropDown
        PhngPhpLabel                matlab.ui.control.Label
        IntegralKQField             matlab.ui.control.Label
        IntegralNhapYField          matlab.ui.control.EditField
        NhpdyyEditFieldLabel        matlab.ui.control.Label
        IntegralNhapXField          matlab.ui.control.EditField
        NhpdyxEditFieldLabel        matlab.ui.control.Label
        IntegralInputField          matlab.ui.control.DropDown
        CchnhpDropDownLabel         matlab.ui.control.Label
        IntegralNhapCanField        matlab.ui.control.EditField
        NhpcnEditFieldLabel         matlab.ui.control.Label
        IntegralResultButton        matlab.ui.control.Button
        IntegralPlotField           matlab.ui.control.UIAxes
        ApproximationTab            matlab.ui.container.Tab
        ToleranceField              matlab.ui.control.NumericEditField
        NhpsaisLabel                matlab.ui.control.Label
        bField                      matlab.ui.control.NumericEditField
        bEditFieldLabel             matlab.ui.control.Label
        aField                      matlab.ui.control.NumericEditField
        aEditFieldLabel             matlab.ui.control.Label
        Loop                        matlab.ui.control.TextArea
        SlnlpTextAreaLabel          matlab.ui.control.Label
        Result                      matlab.ui.control.TextArea
        KtquLabel                   matlab.ui.control.Label
        LoopFunctionField           matlab.ui.control.EditField
        Label                       matlab.ui.control.Label
        Method_2                    matlab.ui.control.DropDown
        ChnphngphpDropDownLabel_2   matlab.ui.control.Label
        FunctionField               matlab.ui.control.EditField
        NhphmLabel                  matlab.ui.control.Label
        SecondLabel                 matlab.ui.control.Label
        CalcButton                  matlab.ui.control.Button
        FirstLabel                  matlab.ui.control.Label
        UIAxes_2                    matlab.ui.control.UIAxes
        InterpolationTab            matlab.ui.container.Tab
        Value4Interpolation         matlab.ui.control.NumericEditField
        GitrcnnisuyEditFieldLabel   matlab.ui.control.Label
        ResultInter2                matlab.ui.control.TextArea
        KtqunisuyLabel              matlab.ui.control.Label
        ResultInter                 matlab.ui.control.TextArea
        KtquathcnisuyTextAreaLabel  matlab.ui.control.Label
        Method                      matlab.ui.control.DropDown
        PhngphpDropDownLabel_2      matlab.ui.control.Label
        yDataField                  matlab.ui.control.EditField
        NhpdliuyEditFieldLabel      matlab.ui.control.Label
        xDataField                  matlab.ui.control.EditField
        NhpdliuxEditFieldLabel      matlab.ui.control.Label
        CalcButton2                 matlab.ui.control.Button
        CalcButton1                 matlab.ui.control.Button
        UIAxes                      matlab.ui.control.UIAxes
        HoiQuyTab                   matlab.ui.container.Tab
        KtquhiquyLabel              matlab.ui.control.Label
        RegressionPredicted         matlab.ui.control.NumericEditField
        NhpgitrdonEditFieldLabel    matlab.ui.control.Label
        RegressionMethod            matlab.ui.control.DropDown
        PhngphpDropDownLabel        matlab.ui.control.Label
        RegressionInputY            matlab.ui.control.EditField
        NhpXLabel_2                 matlab.ui.control.Label
        RegressionInputX            matlab.ui.control.EditField
        NhpXLabel                   matlab.ui.control.Label
        RegressionResult            matlab.ui.control.Label
        RegressionButton            matlab.ui.control.Button
        RegressionAxes              matlab.ui.control.UIAxes
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
            % check if it was created successfully and it's not complex
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
                validationFcn = @(x) isreal(x) && ~isnan(x);
                addRequired(p,argName,validationFcn)
                % Check if inputs are number
                for i = 1:length(xa)
                    parse(p, xa(i))
                    parse(p, ya(i))
                end
                if length(unique(xa)) ~= length(ya)
                    error('');
                end
            catch
                error("Nhập x/y sai format hãy nhập theo format <a1,a2,a3> (không bao gồm <> và không có dấu cách) hoặc x/y không có kích thước giống nhau hoặc đang để trống hoặc là số phức")
            end
        end

        function [loi,X,Y] = regression_check_error(~,x,y,option)
           if isempty(x) || isempty(y)
                 error('Không để trống x,y ');
           elseif (length(str2num(x)) ~= length(str2num(y))) | isempty(str2num(x))
                 error('x,y phải nhập đúng format là a,b,c với a,b,c là các con số và kích thước bằng nhau');
           else
                 X = str2num(x);
                 Y = str2num(y);
           end
           if (length(X) <= 1 || length(Y) <= 1)
               error('Mảng hồi quy kích thước phải lớn hơn 1');
           elseif ~isreal(X) && sum(isfinite(X)) ~= length(X)
               error('x không được là số phức hoặc giá trị vô hạn');
           elseif ~isreal(Y) && sum(isfinite(Y)) ~= length(Y)
               error('y không được là số phức hoặc giá trị vô hạn');
           elseif length(unique(X)) ~= length(X)
               error('Giá trị của mảng X không được trùng nhau');
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
       
        function [CanValue,f,loi] = integral_check_error(app,OptionInput,x,y,HamField,CanField,N)
            if isempty(CanField) %xử lý lỗi ô cận
                error('Không để trống ô cận');
            elseif (CanField(1) ~= '[' || CanField(strlength(CanField)) ~= ']' )
                error('Vui lòng đúng format [a;b], [a,b] hoặc [a b]');
            elseif isempty(str2num(CanField(2:strlength(CanField)-1)))
                error('Vui lòng nhập đúng format của Matlab');
            elseif length(str2num(CanField(2:strlength(CanField)-1))) ~= 2
                error('Vui lòng chỉ nhập 2 ký tự số');
            else
                CanValue = str2num(CanField(2:strlength(CanField)-1));
            end
            if  isempty(N)
                error('Không để trống ô N');
            elseif N <= 0 && ~isinteger(N)
                error('N phải là số nguyên dương')
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
                end
                if length(xa) <= 1 || length(ya) <= 1
                    error('Mảng x,y cần phải có độ dài lớn hớn 1');
                elseif sum([~isfinite(xa),~isreal(xa),~isfinite(ya),~isreal(ya)])
                    error('Mảng nhập vào chỉ được là số thực');
                elseif length(unique(xa)) ~= length(ya)
                    error('Giá trị của mảng X không được trùng nhau');
                end
                f = findLagrangeFuntion(app, xa, ya);
            end
            loi = 0; %khong xay ra loi
        end
        
        function [value,continuous] = Check_continuous(~,f,a,b,N)
            value = 0;
            continuous = 1;
            step = (b-a)/N;
            x = a:step:b;
            for i = 1:N
                if (~isfinite(f(x(i))) || ~isreal(f(x(i))))
                    continuous = 0;
                    value = x(i);
                    break;
                end
            end
        end

        function [a,b,r2] = regression_linear(~,x_num,y_num) %y = ax + b
            x_data = x_num;
            y_data = y_num;
            n = length(x_data);
            sumx = sum(x_data);
            sumy = sum(y_data);
            sumxy = sum(x_data.*y_data);
            sumx2 = sum(x_data.^2);
            x_tb = sumx / n;
            y_tb = sumy / n;
            a = (n*sumxy - sumx*sumy)/(n*sumx2 - sumx*sumx);
            b = y_tb - a*x_tb;
            Sr = sum((y_data-b-a*x_data).^2);
            St = sum((y_data-y_tb).^2);
            r2 = (St - Sr) / St;
        end

        function [a,b,r2] = regression_nonlinear_expx(app,x_num,y_num) %y = ae^(bx)
            x_data = x_num;
            y_data = log(y_num);
            [a_temp, b_temp, r2] = regression_linear(app,x_data,y_data);
            b = a_temp;
            a = exp(b_temp);
        end

        function [a,b,r2] = regression_nonlinear_logarit(app,x_num,y_num)
            x_data = log(x_num);
            y_data = y_num;
            [a_temp, b_temp, r2] = regression_linear(app,x_data,y_data);
            a = a_temp;
            b = b_temp;
        end

        function  [a,b,r2] = regression_nonlinear_xpower(app, x_num,y_num)
            x_data = log(x_num);
            y_data = log(y_num);
            [a_temp, b_temp, r2] = regression_linear(app,x_data,y_data);
            b = a_temp;
            a = b_temp;
        end

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
                    elseif length(unique(xa)) ~= length(xa)
                        error('Giá trị của mảng X không được trùng nhau');
                    else    
                        emptyFlag = 1; %%passed
                    end
                end
            catch
                app.ResultInter.Value = "Kiểm tra lại dữ liệu nhập vào";
            end
        end

        function draw(app , xa, ya, method)
            try
                if method == 1
                    f = app.findLagrangeFuntion(xa, ya);
                elseif method == 2
                    f = app.findNewtonFunction(xa, ya);
                end
                fplot(app.UIAxes, f);
                x_min = min(xa) - (max(xa) - min(xa))/4;
                x_max = max(xa) + (max(xa) - min(xa))/4;
                xlim(app.UIAxes,[x_min x_max]);
            catch
                app.ResultInter.Value = "Lỗi vẽ đồ thị";
            end
        end

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
                digits(3);
                resultLagrange(x) = resultLagrange;
                resultLagrange = collect(resultLagrange);
                resultLagrange = vpa(resultLagrange);
            catch
                app.ResultInter.Value = "Lỗi ngoài ý muốn" ;
            end
        end

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
                digits(3);
                resultNewton(x) = resultNewton;
                resultNewton = collect(resultNewton);
                resultNewton = vpa(resultNewton); 
            catch
                app.ResultInter.Value = "Lỗi ngoài ý muốn" ;
            end
        end

        function [sum,h] = integral_simpson13(app,f,a,b,N)
            sum = f(a) + f(b);
            h = (b-a)/N;
            for i = 1:(N - 1)
                 sum = sum + 2*(mod(i,2) + 1)*f(a+i*h);
            end
            sum = sum * h / 3;
        end

        function [sum,h] = integral_simpson38(app,f,a,b,N)
            sum = f(a) + f(b);
            h = (b-a)/N;
            for i = 1:(N - 1)
                 coef = ~mod(i,3)*2 + (1 - ~mod(i,3))*3;
                 sum = sum + coef*f(a+i*h);
            end
            sum = sum * 3 * h / 8;
        end

        function [sum,h] = integral_hinhthang(app,f,a,b,N)
            sum = f(a) + f(b);
            h = (b-a)/N;
            for i = 1:(N - 1)
                 sum = sum + 2*f(a+i*h);
            end
            sum = sum * h / 2;
        end

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

        % Code that executes after component creation
        function startupFcn(app)
            app.IntegralKQField.Visible = 'off';
            app.IntegralNhapXField.Visible = 'off';
            app.IntegralNhapYField.Visible = 'off';
            app.NhpdyxEditFieldLabel.Visible = 'off';
            app.NhpdyyEditFieldLabel.Visible = 'off';
            app.IntegralKQField.Interpreter = 'latex';
            app.RegressionResult.Visible = 0;
            app.RegressionResult.Interpreter = 'latex';
        end

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
                        functionStr = string(app.findLagrangeFuntion(xa, ya));
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
                % Check if function is complex
                if ~isreal(functionHandler(1))
                    error("Hàm số f(x) không được là hàm phức")
                end
                if isinf(functionHandler(1))
                    error("Hàm số f(x) không xác định");
                end
                % Check if the function str input have 'x' as variable name
                if ~(~isnan(str2double(functionStr)))
                    % Check continuous property of the function
                    funSyms = str2sym(functionStr);
                    symsVariable = symvar(funSyms);
                    if isnan(limit(funSyms, symsVariable, xValue))
                        error("Hàm số không liên tục tại x = " + xValue)
                    end
                end
                % Call the truncation error func based on user input
                if trunError == '1'
                    result = calcTrunErrorOH(app, method, functionHandler, xValue, stepValue);
                else
                    result = calcTrunErrorOHH(app, method, functionHandler, xValue, stepValue);
                end
                % Check if result is complex
                if ~(isreal(result))
                    error("Hàm số không xác định tại x = " + xValue)
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

        % Button pushed function: IntegralResultButton
        function IntegralResultButtonPushed(app, event)
            %thông báo lỗi
            loi = 1;
            app.IntegralKQField.Visible = 1;
            app.IntegralKQField.Text = ["Calculating..."];
            pause(1);
            plot(app.IntegralPlotField,0,0);
            hamField = app.IntegralNhapHamField.Value;
            optionInput = str2num(app.IntegralInputField.Value);
            optionIntegral = str2num(app.IntegralSelectOption.Value);
            canField = app.IntegralNhapCanField.Value;
            X = app.IntegralNhapXField.Value;
            Y = app.IntegralNhapYField.Value;
            N = app.IntegralNhapNField.Value;
            try
                [CanValue,f,loi] = integral_check_error(app,optionInput,X,Y,hamField,canField,N);
            catch er
                 app.IntegralKQField.Visible = 'on';
                 app.IntegralKQField.Text = ['[ERROR]: ' , er.message];
            end
        if loi == 0
            try
            a = CanValue(1);
            b = CanValue(2);
            [value,continous] = Check_continuous(app,f,a,b,N);
            if continous
                %tính
                    if ~optionIntegral
                        [sum,h] = app.integral_hinhthang(f,a,b,N);
                    elseif  optionIntegral == 1
                        [sum,h] = app.integral_simpson13(f,a,b,N);
                    else
                        [sum,h] = app.integral_simpson38(f,a,b,N);
                    end
                    sum = double(sum);
                    app.IntegralKQField.Text = {['$Với$ $a = $',num2str(a)],['$Với$ $b = $',num2str(b)],['$\int_{a}^bf(x)dx$ = ',num2str(sum)]};
                    x = a:h:b;
                    for i = 1:length(x)
                        y(i) = f(x(i));
                    end
                    stem(app.IntegralPlotField,x,y);

            else
                app.IntegralKQField.Text = ['[ERROR] $f(x)$ không liên tục hoặc không xác định tại $x = ',num2str(value)];
            end
            catch ex
                app.IntegralKQField.Text = ['[ERROR] ',ex.message];
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

        % Button pushed function: RegressionButton
        function RegressionButtonPushed(app, event)
            app.RegressionResult.Visible = 1;
            app.RegressionResult.Text = ["Calculating..."];
            cla(app.RegressionAxes);
            pause(1);
            x_char = app.RegressionInputX.Value;
            y_char = app.RegressionInputY.Value;
            option = app.RegressionMethod.Value;
            Dudoan = app.RegressionPredicted.Value;
            loi = 1;
            try
                [loi,x_num,y_num] = regression_check_error(app,x_char,y_char,option);
            catch er
                 app.RegressionResult.Text = ['[ERROR]: ' , er.message];
            end
            syms x;
            if loi == 0
                try
                    if option == '0'
                        [a,b,r2] = regression_linear(app, x_num,y_num);
                        f = @(x) (a*x + b);
                        b_text = num2str(b,'%.3f');
                        a_text = num2str(a,'%.3f');
                        f_text = [b_text,' + x * ',a_text];
                    elseif option == '1'   % a*e^(b*x)
                        [a,b,r2] = regression_nonlinear_expx(app, x_num,y_num);
                        f = @(x) (a.*exp(x.*b));
                        a_text = num2str(a,'%.3f');
                        b_text = num2str(b,'%.3f');
                        f_text = [a_text,'*e^(x*',b_text,')'];
                    elseif option == '2'   % a*x^(b)
                        [a,b,r2] = regression_nonlinear_xpower(app, x_num,y_num);
                        f = @(x) (a*x^b);
                        a_text = num2str(a,'%.3f');
                        b_text = num2str(b,'%.3f');
                        f_text = [a_text,'*x^',b_text];
                    else %  aln(x) + b
                        [a,b,r2] = regression_nonlinear_logarit(app, x_num,y_num);
                        f = @(x) (a*log(x) + b);
                        a_text = num2str(a,'%.3f');
                        b_text = num2str(b,'%.3f');
                        f_text = [a_text,' * ln(x) + ',b_text];
                    end
                    if ( ~isreal(f(Dudoan)) || ~isfinite(f(Dudoan)))
                        error('Hàm số hổi quy không xác định với giá trị dự đoán');
                    end
                    fplot(app.RegressionAxes,f);
                    hold(app.RegressionAxes,'on');
                    scatter(app.RegressionAxes,x_num,y_num);
                    x_axes_min = min(x_num) - (max(x_num) - min(x_num))/4;
                    x_axes_max = max(x_num) + (max(x_num) - min(x_num))/4;
                    xlim(app.RegressionAxes,[x_axes_min x_axes_max]);
                    hold(app.RegressionAxes,'off');
                    legend(app.RegressionAxes,'Predicted Value','True Value');
                    Giatridudoan = double(f(Dudoan));
                    app.RegressionResult.Text = {['Kết quả dự đoán: ',num2str(Giatridudoan)],['Hệ số tương quan: ',num2str(r2)],['f(x) = ',f_text]};
                catch er
                    app.RegressionResult.Text = ['[ERROR]: ',er.message];
                end
            end
        end

        % Button pushed function: CalcButton1
        function CalcButton1Pushed(app, event)
            app.ResultInter.Value = "";
            plot(app.UIAxes,0);
            try
                [xa, ya, x, emptyFlag] = app.checkEmpty();
                if emptyFlag == 1
                    xData = xa;
                    yData = ya;
                    if app.Method.Value == "Lagrange" && emptyFlag
                        f = app.findLagrangeFuntion(xData, yData);
                        app.ResultInter.Value = "y = " + string(collect(f));
                        app.draw(xData, yData, 1);
                    elseif app.Method.Value == "Newton" && emptyFlag
                        f = app.findNewtonFunction(xData, yData);
                        app.ResultInter.Value = "y = " + string(collect(f));
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
                    result = app.findNewtonFunction(xa, ya);  
                    app.ResultInter2.Value = string(double(result(x)));
                elseif app.Method.Value == "Lagrange" && emptyFlag == 1
                    result = app.findLagrangeFuntion(xa, ya);
                    app.ResultInter2.Value = string(double(result(x)));
                end
            catch ex
                app.ResultInter.Value = "Lỗi xảy ra do người dùng nhập không đúng input";
            end
        end

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
            app.HinthktquTextAreaLabel.FontSize = 14;
            app.HinthktquTextAreaLabel.FontWeight = 'bold';
            app.HinthktquTextAreaLabel.Position = [428 324 110 22];
            app.HinthktquTextAreaLabel.Text = 'Hiển thị kết quả';

            % Create DeriResult
            app.DeriResult = uitextarea(app.DerivativesTab);
            app.DeriResult.Editable = 'off';
            app.DeriResult.FontSize = 14;
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

            % Create IntegralPlotField
            app.IntegralPlotField = uiaxes(app.IntegralTab);
            title(app.IntegralPlotField, 'Đồ thị của hàm số')
            xlabel(app.IntegralPlotField, 'X')
            ylabel(app.IntegralPlotField, 'Y')
            zlabel(app.IntegralPlotField, 'Z')
            app.IntegralPlotField.XGrid = 'on';
            app.IntegralPlotField.YGrid = 'on';
            app.IntegralPlotField.FontSize = 14;
            app.IntegralPlotField.Position = [334 162 300 215];

            % Create IntegralResultButton
            app.IntegralResultButton = uibutton(app.IntegralTab, 'push');
            app.IntegralResultButton.ButtonPushedFcn = createCallbackFcn(app, @IntegralResultButtonPushed, true);
            app.IntegralResultButton.Position = [157 77 100 22];
            app.IntegralResultButton.Text = 'Tìm kết quả';

            % Create NhpcnEditFieldLabel
            app.NhpcnEditFieldLabel = uilabel(app.IntegralTab);
            app.NhpcnEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpcnEditFieldLabel.Position = [69 248 57 22];
            app.NhpcnEditFieldLabel.Text = 'Nhập cận';

            % Create IntegralNhapCanField
            app.IntegralNhapCanField = uieditfield(app.IntegralTab, 'text');
            app.IntegralNhapCanField.HorizontalAlignment = 'right';
            app.IntegralNhapCanField.Position = [141 248 119 22];
            app.IntegralNhapCanField.Value = '[0;1]';

            % Create CchnhpDropDownLabel
            app.CchnhpDropDownLabel = uilabel(app.IntegralTab);
            app.CchnhpDropDownLabel.HorizontalAlignment = 'right';
            app.CchnhpDropDownLabel.Position = [39 355 84 22];
            app.CchnhpDropDownLabel.Text = 'Cách nhập';

            % Create IntegralInputField
            app.IntegralInputField = uidropdown(app.IntegralTab);
            app.IntegralInputField.Items = {'Nhập f(x)', 'Nhập x,y'};
            app.IntegralInputField.ItemsData = {'0', '1'};
            app.IntegralInputField.ValueChangedFcn = createCallbackFcn(app, @IntegralInputFieldValueChanged, true);
            app.IntegralInputField.Position = [141 355 122 22];
            app.IntegralInputField.Value = '0';

            % Create NhpdyxEditFieldLabel
            app.NhpdyxEditFieldLabel = uilabel(app.IntegralTab);
            app.NhpdyxEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpdyxEditFieldLabel.Position = [58 323 66 22];
            app.NhpdyxEditFieldLabel.Text = 'Nhập dãy x';

            % Create IntegralNhapXField
            app.IntegralNhapXField = uieditfield(app.IntegralTab, 'text');
            app.IntegralNhapXField.HorizontalAlignment = 'right';
            app.IntegralNhapXField.Position = [141 323 119 22];
            app.IntegralNhapXField.Value = '0,1,2,3';

            % Create NhpdyyEditFieldLabel
            app.NhpdyyEditFieldLabel = uilabel(app.IntegralTab);
            app.NhpdyyEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpdyyEditFieldLabel.Position = [60 282 66 22];
            app.NhpdyyEditFieldLabel.Text = 'Nhập dãy y';

            % Create IntegralNhapYField
            app.IntegralNhapYField = uieditfield(app.IntegralTab, 'text');
            app.IntegralNhapYField.HorizontalAlignment = 'right';
            app.IntegralNhapYField.Position = [141 282 119 22];
            app.IntegralNhapYField.Value = '0,1,4,9';

            % Create IntegralKQField
            app.IntegralKQField = uilabel(app.IntegralTab);
            app.IntegralKQField.BackgroundColor = [1 1 1];
            app.IntegralKQField.VerticalAlignment = 'top';
            app.IntegralKQField.WordWrap = 'on';
            app.IntegralKQField.Position = [362 52 272 69];
            app.IntegralKQField.Text = '';

            % Create PhngPhpLabel
            app.PhngPhpLabel = uilabel(app.IntegralTab);
            app.PhngPhpLabel.HorizontalAlignment = 'right';
            app.PhngPhpLabel.Position = [42 212 81 22];
            app.PhngPhpLabel.Text = 'Phương Pháp';

            % Create IntegralSelectOption
            app.IntegralSelectOption = uidropdown(app.IntegralTab);
            app.IntegralSelectOption.Items = {'Hình thang', 'Simpson 1/3', 'Simpson 3/8'};
            app.IntegralSelectOption.ItemsData = {'0', '1', '2'};
            app.IntegralSelectOption.Position = [141 212 119 22];
            app.IntegralSelectOption.Value = '1';

            % Create NhpNEditFieldLabel
            app.NhpNEditFieldLabel = uilabel(app.IntegralTab);
            app.NhpNEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpNEditFieldLabel.Position = [30 169 89 22];
            app.NhpNEditFieldLabel.Text = 'Nhập N';

            % Create IntegralNhapNField
            app.IntegralNhapNField = uieditfield(app.IntegralTab, 'numeric');
            app.IntegralNhapNField.Position = [141 169 119 22];
            app.IntegralNhapNField.Value = 100;

            % Create NhphmfxLabel
            app.NhphmfxLabel = uilabel(app.IntegralTab);
            app.NhphmfxLabel.HorizontalAlignment = 'right';
            app.NhphmfxLabel.Position = [41 303 82 22];
            app.NhphmfxLabel.Text = 'Nhập hàm f(x)';

            % Create IntegralNhapHamField
            app.IntegralNhapHamField = uieditfield(app.IntegralTab, 'text');
            app.IntegralNhapHamField.HorizontalAlignment = 'right';
            app.IntegralNhapHamField.Position = [141 303 119 22];
            app.IntegralNhapHamField.Value = 'x.^2';

            % Create ApproximationTab
            app.ApproximationTab = uitab(app.TabGroup);
            app.ApproximationTab.Title = 'Nghiệm';

            % Create UIAxes_2
            app.UIAxes_2 = uiaxes(app.ApproximationTab);
            title(app.UIAxes_2, 'ĐỒ THỊ HÀM SỐ')
            xlabel(app.UIAxes_2, 'x')
            ylabel(app.UIAxes_2, 'f(x)')
            zlabel(app.UIAxes_2, 'Z')
            app.UIAxes_2.Colormap = zeros(0,3);
            app.UIAxes_2.XGrid = 'on';
            app.UIAxes_2.YGrid = 'on';
            app.UIAxes_2.FontSize = 14;
            app.UIAxes_2.Position = [308 123 337 275];

            % Create FirstLabel
            app.FirstLabel = uilabel(app.ApproximationTab);
            app.FirstLabel.Tag = 'FirstLabel';
            app.FirstLabel.FontSize = 14;
            app.FirstLabel.Position = [58 345 217 22];
            app.FirstLabel.Text = 'Nhập khoảng phân li nghiệm (a,b)';

            % Create CalcButton
            app.CalcButton = uibutton(app.ApproximationTab, 'push');
            app.CalcButton.ButtonPushedFcn = createCallbackFcn(app, @CalcButtonPushed, true);
            app.CalcButton.FontSize = 14;
            app.CalcButton.Position = [263 21 100 25];
            app.CalcButton.Text = 'Tính';

            % Create SecondLabel
            app.SecondLabel = uilabel(app.ApproximationTab);
            app.SecondLabel.FontSize = 14;
            app.SecondLabel.Position = [19 140 92 22];
            app.SecondLabel.Text = 'Nhập hàm lặp';

            % Create NhphmLabel
            app.NhphmLabel = uilabel(app.ApproximationTab);
            app.NhphmLabel.HorizontalAlignment = 'right';
            app.NhphmLabel.FontSize = 14;
            app.NhphmLabel.Position = [54 385 70 22];
            app.NhphmLabel.Text = 'Nhập hàm';

            % Create FunctionField
            app.FunctionField = uieditfield(app.ApproximationTab, 'text');
            app.FunctionField.Tag = 'FunctionField';
            app.FunctionField.HorizontalAlignment = 'right';
            app.FunctionField.FontSize = 14;
            app.FunctionField.Position = [133 385 142 22];
            app.FunctionField.Value = '3*x^3 - 8*x^2 - 20*x + 16';

            % Create ChnphngphpDropDownLabel_2
            app.ChnphngphpDropDownLabel_2 = uilabel(app.ApproximationTab);
            app.ChnphngphpDropDownLabel_2.HorizontalAlignment = 'right';
            app.ChnphngphpDropDownLabel_2.FontSize = 14;
            app.ChnphngphpDropDownLabel_2.Position = [33 191 127 22];
            app.ChnphngphpDropDownLabel_2.Text = 'Chọn phương pháp';

            % Create Method_2
            app.Method_2 = uidropdown(app.ApproximationTab);
            app.Method_2.Items = {'Chia đôi', 'lặp', 'Newton'};
            app.Method_2.ValueChangedFcn = createCallbackFcn(app, @Method_2ValueChanged, true);
            app.Method_2.FontSize = 14;
            app.Method_2.Position = [175 191 100 22];
            app.Method_2.Value = 'Chia đôi';

            % Create Label
            app.Label = uilabel(app.ApproximationTab);
            app.Label.HorizontalAlignment = 'right';
            app.Label.FontSize = 14;
            app.Label.Position = [110 140 25 22];
            app.Label.Text = '';

            % Create LoopFunctionField
            app.LoopFunctionField = uieditfield(app.ApproximationTab, 'text');
            app.LoopFunctionField.Tag = 'LoopFunctionField';
            app.LoopFunctionField.FontSize = 14;
            app.LoopFunctionField.Visible = 'off';
            app.LoopFunctionField.Position = [111 140 169 22];
            app.LoopFunctionField.Value = '(3*x^3 - 8*x^2 + 16)/20';

            % Create KtquLabel
            app.KtquLabel = uilabel(app.ApproximationTab);
            app.KtquLabel.HorizontalAlignment = 'right';
            app.KtquLabel.FontSize = 14;
            app.KtquLabel.Position = [52 80 53 22];
            app.KtquLabel.Text = 'Kết quả';

            % Create Result
            app.Result = uitextarea(app.ApproximationTab);
            app.Result.Tag = 'Result';
            app.Result.HorizontalAlignment = 'right';
            app.Result.FontSize = 14;
            app.Result.Position = [110 65 170 51];

            % Create SlnlpTextAreaLabel
            app.SlnlpTextAreaLabel = uilabel(app.ApproximationTab);
            app.SlnlpTextAreaLabel.HorizontalAlignment = 'right';
            app.SlnlpTextAreaLabel.FontSize = 14;
            app.SlnlpTextAreaLabel.Position = [350 79 67 22];
            app.SlnlpTextAreaLabel.Text = 'Số lần lặp';

            % Create Loop
            app.Loop = uitextarea(app.ApproximationTab);
            app.Loop.Tag = 'Loop';
            app.Loop.FontSize = 14;
            app.Loop.Position = [432 79 150 23];

            % Create aEditFieldLabel
            app.aEditFieldLabel = uilabel(app.ApproximationTab);
            app.aEditFieldLabel.HorizontalAlignment = 'right';
            app.aEditFieldLabel.FontSize = 14;
            app.aEditFieldLabel.Position = [52 305 25 22];
            app.aEditFieldLabel.Text = 'a';

            % Create aField
            app.aField = uieditfield(app.ApproximationTab, 'numeric');
            app.aField.FontSize = 14;
            app.aField.Position = [92 305 48 22];
            app.aField.Value = 0.2;

            % Create bEditFieldLabel
            app.bEditFieldLabel = uilabel(app.ApproximationTab);
            app.bEditFieldLabel.HorizontalAlignment = 'right';
            app.bEditFieldLabel.FontSize = 14;
            app.bEditFieldLabel.Position = [177 305 25 22];
            app.bEditFieldLabel.Text = 'b';

            % Create bField
            app.bField = uieditfield(app.ApproximationTab, 'numeric');
            app.bField.FontSize = 14;
            app.bField.Position = [217 305 58 22];
            app.bField.Value = 0.8;

            % Create NhpsaisLabel
            app.NhpsaisLabel = uilabel(app.ApproximationTab);
            app.NhpsaisLabel.HorizontalAlignment = 'right';
            app.NhpsaisLabel.FontSize = 14;
            app.NhpsaisLabel.Position = [58 243 79 22];
            app.NhpsaisLabel.Text = 'Nhập sai số';

            % Create ToleranceField
            app.ToleranceField = uieditfield(app.ApproximationTab, 'numeric');
            app.ToleranceField.FontSize = 14;
            app.ToleranceField.Position = [154 243 120 22];
            app.ToleranceField.Value = 0.005;

            % Create InterpolationTab
            app.InterpolationTab = uitab(app.TabGroup);
            app.InterpolationTab.Title = 'Nội suy';

            % Create UIAxes
            app.UIAxes = uiaxes(app.InterpolationTab);
            title(app.UIAxes, 'Đồ thị của hàm số')
            xlabel(app.UIAxes, 'x')
            ylabel(app.UIAxes, 'y')
            zlabel(app.UIAxes, 'Z')
            app.UIAxes.Colormap = zeros(0,3);
            app.UIAxes.XGrid = 'on';
            app.UIAxes.YGrid = 'on';
            app.UIAxes.FontSize = 14;
            app.UIAxes.Position = [321 154 322 261];

            % Create CalcButton1
            app.CalcButton1 = uibutton(app.InterpolationTab, 'push');
            app.CalcButton1.ButtonPushedFcn = createCallbackFcn(app, @CalcButton1Pushed, true);
            app.CalcButton1.IconAlignment = 'center';
            app.CalcButton1.Position = [107 18 100 25];
            app.CalcButton1.Text = 'Tìm đa thức';

            % Create CalcButton2
            app.CalcButton2 = uibutton(app.InterpolationTab, 'push');
            app.CalcButton2.ButtonPushedFcn = createCallbackFcn(app, @CalcButton2Pushed, true);
            app.CalcButton2.Position = [448 18 100 25];
            app.CalcButton2.Text = 'Tính';

            % Create NhpdliuxEditFieldLabel
            app.NhpdliuxEditFieldLabel = uilabel(app.InterpolationTab);
            app.NhpdliuxEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpdliuxEditFieldLabel.Position = [40 340 96 22];
            app.NhpdliuxEditFieldLabel.Text = 'Nhập dữ liệu x';

            % Create xDataField
            app.xDataField = uieditfield(app.InterpolationTab, 'text');
            app.xDataField.Tag = 'xDataField';
            app.xDataField.HorizontalAlignment = 'right';
            app.xDataField.Position = [141 340 119 22];
            app.xDataField.Value = '0.1, 0.2, 0.3, 0.4';

            % Create NhpdliuyEditFieldLabel
            app.NhpdliuyEditFieldLabel = uilabel(app.InterpolationTab);
            app.NhpdliuyEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpdliuyEditFieldLabel.Position = [40 306 96 22];
            app.NhpdliuyEditFieldLabel.Text = 'Nhập dữ liệu y';

            % Create yDataField
            app.yDataField = uieditfield(app.InterpolationTab, 'text');
            app.yDataField.Tag = 'yDataField';
            app.yDataField.HorizontalAlignment = 'right';
            app.yDataField.Position = [141 306 119 22];
            app.yDataField.Value = '0.09983, 0.19867, 0.29552, 0.38942';

            % Create PhngphpDropDownLabel_2
            app.PhngphpDropDownLabel_2 = uilabel(app.InterpolationTab);
            app.PhngphpDropDownLabel_2.HorizontalAlignment = 'right';
            app.PhngphpDropDownLabel_2.Position = [56 264 78 22];
            app.PhngphpDropDownLabel_2.Text = 'Phương pháp';

            % Create Method
            app.Method = uidropdown(app.InterpolationTab);
            app.Method.Items = {'Newton', 'Lagrange'};
            app.Method.Position = [139 264 121 22];
            app.Method.Value = 'Newton';

            % Create KtquathcnisuyTextAreaLabel
            app.KtquathcnisuyTextAreaLabel = uilabel(app.InterpolationTab);
            app.KtquathcnisuyTextAreaLabel.HorizontalAlignment = 'right';
            app.KtquathcnisuyTextAreaLabel.Position = [96 120 138 22];
            app.KtquathcnisuyTextAreaLabel.Text = 'Kết quả đa thức nội suy';

            % Create ResultInter
            app.ResultInter = uitextarea(app.InterpolationTab);
            app.ResultInter.Editable = 'off';
            app.ResultInter.Position = [55 60 220 61];

            % Create KtqunisuyLabel
            app.KtqunisuyLabel = uilabel(app.InterpolationTab);
            app.KtqunisuyLabel.HorizontalAlignment = 'right';
            app.KtqunisuyLabel.Position = [453 120 85 22];
            app.KtqunisuyLabel.Text = 'Kết quả nội suy';

            % Create ResultInter2
            app.ResultInter2 = uitextarea(app.InterpolationTab);
            app.ResultInter2.Editable = 'off';
            app.ResultInter2.Position = [386 60 220 61];

            % Create GitrcnnisuyEditFieldLabel
            app.GitrcnnisuyEditFieldLabel = uilabel(app.InterpolationTab);
            app.GitrcnnisuyEditFieldLabel.HorizontalAlignment = 'right';
            app.GitrcnnisuyEditFieldLabel.Position = [38 218 97 22];
            app.GitrcnnisuyEditFieldLabel.Text = 'Giá trị cần nội suy';

            % Create Value4Interpolation
            app.Value4Interpolation = uieditfield(app.InterpolationTab, 'numeric');
            app.Value4Interpolation.Tag = 'Value4Interpolation';
            app.Value4Interpolation.Position = [141 218 119 22];

            % Create HoiQuyTab
            app.HoiQuyTab = uitab(app.TabGroup);
            app.HoiQuyTab.Title = 'Hồi quy';

            % Create RegressionAxes
            app.RegressionAxes = uiaxes(app.HoiQuyTab);
            title(app.RegressionAxes, 'Biểu đồ hồi quy')
            xlabel(app.RegressionAxes, 'X')
            ylabel(app.RegressionAxes, 'Y')
            zlabel(app.RegressionAxes, 'Z')
            app.RegressionAxes.FontSize = 14;
            app.RegressionAxes.Position = [334 162 300 215];

            % Create RegressionButton
            app.RegressionButton = uibutton(app.HoiQuyTab, 'push');
            app.RegressionButton.ButtonPushedFcn = createCallbackFcn(app, @RegressionButtonPushed, true);
            app.RegressionButton.Position = [157 77 100 22];
            app.RegressionButton.Text = 'Tìm kết quả';

            % Create RegressionResult
            app.RegressionResult = uilabel(app.HoiQuyTab);
            app.RegressionResult.BackgroundColor = [1 1 1];
            app.RegressionResult.VerticalAlignment = 'top';
            app.RegressionResult.WordWrap = 'on';
            app.RegressionResult.Position = [362 52 272 69];
            app.RegressionResult.Text = '';

            % Create NhpXLabel
            app.NhpXLabel = uilabel(app.HoiQuyTab);
            app.NhpXLabel.HorizontalAlignment = 'right';
            app.NhpXLabel.Position = [102 331 46 22];
            app.NhpXLabel.Text = 'Nhập X';

            % Create RegressionInputX
            app.RegressionInputX = uieditfield(app.HoiQuyTab, 'text');
            app.RegressionInputX.HorizontalAlignment = 'right';
            app.RegressionInputX.Position = [163 331 100 22];
            app.RegressionInputX.Value = '1,2,3';

            % Create NhpXLabel_2
            app.NhpXLabel_2 = uilabel(app.HoiQuyTab);
            app.NhpXLabel_2.HorizontalAlignment = 'right';
            app.NhpXLabel_2.Position = [103 290 45 22];
            app.NhpXLabel_2.Text = 'Nhập Y';

            % Create RegressionInputY
            app.RegressionInputY = uieditfield(app.HoiQuyTab, 'text');
            app.RegressionInputY.HorizontalAlignment = 'right';
            app.RegressionInputY.Position = [163 290 100 22];
            app.RegressionInputY.Value = '10,1,2';

            % Create PhngphpDropDownLabel
            app.PhngphpDropDownLabel = uilabel(app.HoiQuyTab);
            app.PhngphpDropDownLabel.HorizontalAlignment = 'right';
            app.PhngphpDropDownLabel.Position = [42 249 79 22];
            app.PhngphpDropDownLabel.Text = 'Phương pháp';

            % Create RegressionMethod
            app.RegressionMethod = uidropdown(app.HoiQuyTab);
            app.RegressionMethod.Items = {'Tuyến tính αx + β', 'Hàm mũ αeᵝˣ', 'Hàm mũ αxᵝ', 'Logarit αln(x) + β'};
            app.RegressionMethod.ItemsData = {'0', '1', '2', '3', ''};
            app.RegressionMethod.Position = [134 249 129 22];
            app.RegressionMethod.Value = '3';

            % Create NhpgitrdonEditFieldLabel
            app.NhpgitrdonEditFieldLabel = uilabel(app.HoiQuyTab);
            app.NhpgitrdonEditFieldLabel.HorizontalAlignment = 'right';
            app.NhpgitrdonEditFieldLabel.Position = [33 205 115 22];
            app.NhpgitrdonEditFieldLabel.Text = 'Nhập giá trị dự đoán';

            % Create RegressionPredicted
            app.RegressionPredicted = uieditfield(app.HoiQuyTab, 'numeric');
            app.RegressionPredicted.Position = [163 205 100 22];
            app.RegressionPredicted.Value = 1.5;

            % Create KtquhiquyLabel
            app.KtquhiquyLabel = uilabel(app.HoiQuyTab);
            app.KtquhiquyLabel.Position = [453 123 89 22];
            app.KtquhiquyLabel.Text = 'Kết quả hồi quy';

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
        function app = Kiv_final

            % Create UIFigure and components
            createComponents(app)

            % Register the app with App Designer
            registerApp(app, app.UIFigure)

            % Execute the startup function
            runStartupFcn(app, @startupFcn)

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