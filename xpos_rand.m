function xpos=xpos_rand(height)
check=0;
r = normrnd(0,height/6);

while check==0;
    if abs(r)<height/2
        check = 1;
    else
       r = normrnd(0,height/8);
    end
end

xpos = r;
