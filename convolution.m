answer=2;
while answer~=1 && answer~=0 %yes=1, no=0
    answer = input("Do you want to calculate convolution?(1/0): ");
end
if answer == 1
    getConvolution()
end

answer=2;
while answer~=1 && answer~=0 %yes=1, no=0
    answer = input("Do you want to record your voice?(1/0): ");
end

if answer == 1
    sn=0;
    while sn<=0
        sn = input("How many seconds do you want to record: ");
    end
    X = record(sn);
    
    answer=2;
    while answer~=1 && answer~=0 %yes=1, no=0
        answer = input("Do you want to play the recording?(1/0): ");
    end
    if answer == 1
        disp("playing X")
        sound(X)
        pause(sn)
    end
    
    M = input("What is the value of m: ");
    
    disp("This may take some time...")
    
    %Farklı M değerleri (2,3,4) için sistem çıktısı
    H = system(M);
    
    %X sinyali ile sistem çıktısının myConv konvolüsyonu
    myX_HConv = myConv(X,length(X),H,length(H));
    
    %X sinyali ile sistem çıktısının matlab hazır konvolüsyonu
    matlabsX_HConv = conv(X,H);
    
    disp("playing myX_HConv")
    sound(myX_HConv)
    
    disp("Graphics are being prepared...")
    
    subplot(4,1,1)
    stem(X);
    title('X Signal')
    subplot(4,1,2)
    stem(H);
    title('H Signal')
    subplot(4,1,3)
    stem(myX_HConv);
    title('myX_HConv Signal')
    subplot(4,1,4)
    stem(matlabsX_HConv);
    title('matlabsX_HConv Signal')
end

function X = record(sn)
    recObj = audiorecorder;
    disp('Start speaking')
    recordblocking(recObj,sn);
    disp('End of Recording');
    X = getaudiodata(recObj);
end


function getConvolution()
    n = input("Number of elements of X signal: ");% x sinyalinin boyutu
    x = input("Enter the elements of X signal: ");% x sinyalinin elemanları
    m = input("Number of elements of Y signal: ");% y sinyalinin boyutu
    y = input("Enter the elements of Y signal: ");% y sinyalinin elemanları
    x0 = input("x value of the first element of the x signal: ");% x sinyalinde girilen ilk elemanın x ekseni üzerindeki değeri
    y0 = input("x value of the first element of the y signal: ");% y sinyalinde girilen ilk elemanın x ekseni üzerindeki değeri
    
    convRes0 = x0+y0;%konvolüsyon fonksiyonun ilk elemanının x ekseni değeri
    myConvRes = myConv(x,n,y,m); % x'in y ile konvolüsyonu(benim yazdığım)
    matlabsConvRes = conv(x,y);% x'in y ile konvolüsyonu(matlab hazır fonk.)
    
    %x,y sinyalleri ve konvolüsyon sonuçlarının görselleştirilmesi
    subplot(2,2,1)
    stem(linspace(x0,x0+n-1,n),x);
    title('X Signal')
    
    subplot(2,2,2)
    stem(linspace(y0,y0+m-1,m),y);
    title('Y Signal')
    
    subplot(2,2,3)
    stem(linspace(convRes0,convRes0+length(myConvRes)-1,length(myConvRes)),myConvRes);
    title('My convolution')
    
    subplot(2,2,4)
    stem(linspace(convRes0,convRes0+length(matlabsConvRes)-1,length(matlabsConvRes)),matlabsConvRes);
    title('Matlabs convolution')
    
    %x,y sinyalleri ve konvolüsyon sonuçlarının yazdırılması
    disp("X signal: ")
    disp(x)
    disp("Y signal: ")
    disp(y)
    disp("My convolution: ")
    disp(myConvRes)
    disp("Matlabs convolution: ")
    disp(matlabsConvRes)

end

function res = myConv(x,n,y,m)% kendi yazdığım conv fonksiyonu
    lenConv = n+m-1;
    res = zeros(1,lenConv);
    for i=1:lenConv
        sum = 0;
        for j=1:n
            if ((i-j)>=0) && (m>i-j)
                sum = sum + x(j)*y(i-j+1);
            end
        end
        res(i) = sum;
    end
    
end

function Y = system(M)% 4. sorudaki y[n] bulma denklemi
    Y = zeros(1,400*M);
    Y(1)=1;
    for i=1:M
        Y(400*i+1)=0.8*i;
    end
end
