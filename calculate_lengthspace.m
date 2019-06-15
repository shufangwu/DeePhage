function calculate = calculate_lengthspace(length,unit)
num = ceil(length/unit);
calculate = [1];
i = 1;
a = length;
    while a>unit
        calculate = [calculate;(1+i*1800)];
        a = length-i*unit;
        i = i+1;
    end

end