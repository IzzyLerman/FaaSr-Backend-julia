using Base
import HTTP
import JSON

function parse_response(res, rpc_id)
    if get(JSON.parse(res), "Success", false)
        exit(0)
    else
        err_msg = "{\"$rpc_id\": \"Request to FaaSr RPC failed\"}"
        println(err_msg)
        exit(1)
    end
end

function handle_response_error(e, rpc_id)
    if isa(e, HTTP.ExceptionRequest.StatusError)
        err_msg = "{{\"$rpc_id\": \"HTTP request returned an exception:\n$(e.response) ($(e.status))\"}}"
    else
        err_msg = "{{\"$rpc_id\": \"Error making request to RPC server: $(typeof(e))\"}}"
    end
    println(err_msg)
    exit(1)
end


function faasr_put_file(local_file, remote_file, server_name="", local_folder=".", remote_folder=".")
    rpc_id="faasr_put_file"
    request_json = Dict(
        "ProcedureId"=>rpc_id,
        "Arguments"=>Dict(
            "local_file"=>string(local_file),
            "remote_file"=>string(remote_file),
            "server_name"=>server_name,
            "local_folder"=>string(local_folder),
            "remote_folder"=>string(remote_folder) 
        )
    )

    try
        res = HTTP.request("POST","http://127.0.0.1:8000/faasr-action", [], JSON.json(request_json))
        parse_response(res, rpc_id)
    catch e
        handle_response_error(e, rpc_id)
    end
end

function faasr_get_file(local_file, remote_file, server_name="", local_folder=".", remote_folder=".")
    rpc_id="faasr_get_file"
    request_json = Dict(
        "ProcedureId"=>rpc_id,
        "Arguments"=>Dict(
            "local_file"=>string(local_file),
            "remote_file"=>string(remote_file),
            "server_name"=>server_name,
            "local_folder"=>string(local_folder),
            "remote_folder"=>string(remote_folder) 
        )
    )

    try
        res = HTTP.request("POST","http://127.0.0.1:8000/faasr-action", [], JSON.json(request_json))
        parse_response(res, rpc_id)
    catch e
        handle_response_error(e, rpc_id)
    end
end

function faasr_delete_file(remote_file, server_name="", remote_folder=".")
    rpc_id="faasr_delete_file"
    request_json = Dict(
        "ProcedureId"=>rpc_id,
        "Arguments"=>Dict(
            "remote_file"=>string(remote_file),
            "server_name"=>server_name,
            "remote_folder"=>string(remote_folder) 
        )
    )

    try
        res = HTTP.request("POST","http://127.0.0.1:8000/faasr-action", [], JSON.json(request_json))
        parse_response(res, rpc_id)
    catch e
        handle_response_error(e, rpc_id)
    end
end

function faasr_log(log_message)
    if (log_message == nothing || log_message == "")
        err_msg = "{\"faasr_log\": \"ERROR -- empty log_message not allowed\"}"
        println(err_msg)
        exit(1)
    end
    
    rpc_id="faasr_log"
    request_json = Dict(
        "ProcedureID"=>rpc_id,
        "Arguments"=>Dict("log_message"=>log_message)
    )

    try
        res = HTTP.request("POST","http://127.0.0.1:8000/faasr-action", [], JSON.json(return_json))
        parse_response(res, rpc_id)
    catch e
        handle_response_error(e, rpc_id)
    end

end

function faasr_return(return_value=nothing)
    return_json = Dict("FunctionResult"=>return_value)
    rpc_id="faasr_return"

    try
        res = HTTP.request("POST","http://127.0.0.1:8000/faasr-action", [], JSON.json(return_json))
        parse_response(res, rpc_id)
    catch e
        handle_response_error(e, rpc_id)
    end
end

function faasr_exit(message=nothing, error=true)
    exit_json = Dict("Error"=>error, "Message"=>message)
    rpc_id="faasr_exit"

    try
        res = HTTP.request("POST","http://127.0.0.1:8000/faasr-action", [], JSON.json(exit_json))
        parse_response(res, rpc_id)
    catch e
        handle_response_error(e, rpc_id)
    end
end
