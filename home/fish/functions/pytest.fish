# Vendored from https://github.com/ddoroshev/pytest.fish

function find_test_functions
    set filename $argv[1]
    if not test -f $filename
        echo "Error: File '$filename' not found"
        return 1
    end

    rg '^\s*(async )?def test_' $filename | while read -l line
        set name (echo $line | sed 's/(async )?def //' | string split '(' | head -n 1)
        echo $name
    end
end

function pytest_complete_k -d "Complete pytest tests"
    for file in (fd '.*_test.py')
        find_test_functions $file
    end
end

function pytest_complete_path
    for file in (fd '.*_test.py')
        set relative_path (string replace "./" "" -- $file)
        echo $relative_path
        find_test_functions $file | while read -l test_name
            echo "$relative_path::$test_name"
        end
    end
end
