echo "C) 1957"
echo "D) 1937"
read std_ans

if [[ "$std_ans" == "$crt_ans" ]]; then
    echo "Your ans is correct"
    echo "Your ans: $std_ans"
else
    echo "Your ans is incorrect"
    echo "Correct ans is $crt_ans"
fi