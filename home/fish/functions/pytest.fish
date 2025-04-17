# Vendored from https://github.com/ddoroshev/pytest.fish

function find_test_functions
    set filename $argv[1]
    if not test -f $filename
        echo "Error: File '$filename' not found"
        return 1
    end

    grep -E "^\s*def test_" $filename | while read -l line
        set name (echo $line | string replace "def " "" | string split '(' | head -n 1)
        echo $name
    end
end

function pytest_complete_k -d "Complete pytest tests"
    for file in (find . -name '*_test.py' -o -name 'test_*.py')
        find_test_functions $file
    end
end

function pytest_complete_path
    for file in (find . -name '*_test.py' -o -name 'test_*.py')
        set relative_path (string replace "./" "" -- $file)
        echo $relative_path
        find_test_functions $file | while read -l test_name
            echo "$relative_path::$test_name"
        end
    end
end
