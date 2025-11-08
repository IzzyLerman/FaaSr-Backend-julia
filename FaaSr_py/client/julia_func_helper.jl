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
                println("included $path/$file")
                try
                    println("function $func_name: $(isdefined(Main, fn))")
                    if isdefined(Main, fn)
                        return fn
                    end
                catch e
                end
            end
        end
    end
    return nothing

end

