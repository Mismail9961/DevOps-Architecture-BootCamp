#!/bin/bash

add() {
    echo "$1 + $2" | bc
}

min() {
    echo "$1 - $2" | bc
}

mul() {
    echo "$1 * $2" | bc
}

div() {
    if [ "$2" -eq 0 ]; then
        echo "Error: Division by zero is not allowed."
        exit 1
    fi
    echo "scale=2; $1 / $2" | bc
}

read -p "Enter first number: " result

while true; do
    read -p "Enter an operation (+, -, *, /) or 'exit' to quit: " op

    if [ "$op" = "exit" ]; then
        echo "Goodbye!"
        break
    fi

    read -p "Enter second number: " num2

    case "$op" in
        +)
            result=$(add "$result" "$num2")
            ;;
        -)
            result=$(min "$result" "$num2")
            ;;
        \*)
            result=$(mul "$result" "$num2")
            ;;
        /)
            result=$(div "$result" "$num2")
            ;;
        *)
            echo "Invalid operation. Please try again."
            continue
            ;;
    esac

    echo "Result: $result"
done