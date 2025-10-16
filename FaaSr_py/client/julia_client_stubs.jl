import Base
import HTTP
import JSON


function faasr_return(return_value=nothing)
    return_json = Dict("FunctionResult"=>return_value)

    try
        res = HTTP.request("POST","http://127.0.0.1:8000/faasr-action", [], JSON.json(return_json))
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            err_msg = "{'faasr_return': 'HTTP POST returned an exception:\n$(e.response) ($(e.status))'"
        else
            err_msg = "{'faasr_return': 'Error making request to RPC server'}"
        end
        println(err_msg)
        return
    end

    return true
end

function faasr_exit(message=nothing, error=true)
    exit_json = Dict("Error"=>error, "Message"=>message)

    try
        res = HTTP.request("POST","http://127.0.0.1:8000/faasr-action", [], JSON.json(exit_json))
    catch e
        if isa(e, HTTP.ExceptionRequest.StatusError)
            err_msg = "{'faasr_exit': 'HTTP POST returned an exception:\n$(e.response) ($(e.status))'"
        else
            err_msg = "{'faasr_exit': 'Error making request to RPC server'}"
        end
        println(err_msg)
        return
    end

end
