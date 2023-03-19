local ReplicatedStorage = game:GetService("ReplicatedStorage");

local PACKAGE_ROOT_NAME = "lib";

local packagesRoot = ReplicatedStorage:WaitForChild(PACKAGE_ROOT_NAME);

local function packages(packageName: string) 
    return packagesRoot:FindFirstChild(packageName, true);
end

return packages;