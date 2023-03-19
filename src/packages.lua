local ReplicatedStorage = game:GetService("ReplicatedStorage");

local PACKAGE_ROOT_NAME = "lib";

local packagesRoot = ReplicatedStorage:WaitForChild(PACKAGE_ROOT_NAME);

local map = {}

local function packages(packageName: string)
    if map[packageName] == nil then
        local found = packagesRoot:FindFirstChild(packageName, true);
        if found:IsA("ModuleScript") then 
            return found 
        else 
            return found:FindFirstChild(packageName, true); 
        end
    end
    return map[packageName];
end

return packages;