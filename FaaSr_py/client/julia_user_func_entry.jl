include("./julia_func_helper.jl")
include("./julia_client_stubs.jl")


function run_julia_function(faasr, func_name, args)

    try
        user_function = faasr_import_function_walk(
            func_name, directory="/tmp/functions/${faasr["InvocationID"]}"
        )
    catch e
        err_msg = "failed to get the user functions"
        faasr_exit(err_msg)
    end

    if user_function == nothing
        err_msg = "failed to get the user functions"
        faasr_exit(err_msg)
    end

    try
        result = user_function(args)
    catch e
        faasr_exit("Error while running user function")
    end

    faasr_return(result)
end









end
