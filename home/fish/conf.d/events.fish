function pre_prompt --on-event fish_postexec
    echo -n -e "\n"
end

function clear_ld_library_path --on-event fish_preexec
    # this started getting set by $work's nix shellhook.. breaks my shit
    set -x LD_LIBRARY_PATH ""
end

