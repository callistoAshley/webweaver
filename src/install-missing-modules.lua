return function()
    local ModuleManager = require("module-manager")
    local deps = require("deps")

    local dep_requires = {}
    for _, v in pairs(deps) do
        table.insert(dep_requires, v.require_name)
    end

    local missing_modules = ModuleManager.find_missing(dep_requires)
    if #missing_modules > 0 then
        print("The following modules will be installed:")
        for _, mod in ipairs(missing_modules) do
            print("  ", mod)
        end

        local input
        while true do
            print("Confirm? (y/n)")
            input = io.read():lower():gsub("\n", "")

            if input == "n" then
                print("Refusing to continue without installing dependencies.")
                return os.exit(false)
            elseif input == "y" then

                for _, installee in ipairs(missing_modules) do
                    for _, dep in ipairs(deps) do

                        if dep.require_name == installee then
                            local status = ModuleManager.install(dep.install_name)
                            if not status then
                                print(string.format("Failed to install %s (%s).", dep.install_name, dep.require_name))
                                os.exit(false)
                            end
                        end

                    end
                end

                break
            end
        end
    end
end
