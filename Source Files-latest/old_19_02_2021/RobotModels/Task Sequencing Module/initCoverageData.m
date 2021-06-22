%--
function coverageData=initCoverageData()

coverageData.MinCoverage=0.5; % [0 1]
coverageData.RayTracying=initRayTracying();

coverageData.ScatterModel.Enable=true;
coverageData.ScatterModel.RawData=importdata('scatter_data.txt');
coverageData.ScatterModel.Degree=12;
coverageData.ScatterModel.MaxScatterAngle=50; % deg

coverageData.ScatterModel.Coefficient=fitRawDataScatterModel(coverageData.ScatterModel.RawData, coverageData.ScatterModel.Degree);

%-----------------------------------------------------------------------
% calculate regression coefficient of raw data (scatter reflection data)
function coeff=fitRawDataScatterModel(rawdata, degree)

% rawdata: [angle (radians), scatter value]
% degree: polynomial degree

x=rawdata(:,1); % angle (radians)
Y=rawdata(:,2); % scatter value

np=size(x,1);

X=zeros(np,degree+1);
X(:,1)=ones(np,1);

for i=1:degree
    X(:,i+1)=x.^i;
end

% solve least square problem and get solution
coeff=X\Y;

