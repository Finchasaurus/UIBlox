local ReplicatedStorage = game:GetService("ReplicatedStorage");

local PACKAGE_ROOT_NAME = "lib";

local packagesRoot = ReplicatedStorage:WaitForChild(PACKAGE_ROOT_NAME);

local map = {}

local function packages(packageName: string) 
    if map[packageName] == nil then
        map[packageName] = packagesRoot:FindFirstChild(packageName, true);
    end
    return map[packageName];
end

return packages;