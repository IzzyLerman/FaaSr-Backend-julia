import Base

function faasr_import_function_walk(func_name, directory=".")
    ignore_files = [
        "julia_func_helper.jl",
        "julia_user_func_entry.jl"
    ]

    fn = Symbol(func_name)

    for (path, dirs, files) in Base.Filesystem.walkdir(directory)
        for file in files
            if Base.endswith(file, ".jl") && !(file in ignore_files)
                include("$path/$file")
                try
                    user_func = getfield(Main, fn)
                    return user_func
                catch e
                end
            end
        end
    end
    return nothing

end

