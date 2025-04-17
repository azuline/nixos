# Vendored from https://github.com/ddoroshev/pytest.fish

complete -c pytest -n "__fish_contains_opt -s k" -f -a '(pytest_complete_k)'
complete -c pytest -n "not __fish_contains_opt -s k" -f -a '(pytest_complete_path)'
