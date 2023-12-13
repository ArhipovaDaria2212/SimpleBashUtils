file1="test1.txt"
file2="test2.txt"
file3="test3.txt"

e="-e the"
i="-i"
v="-v"
c="-c"
l="-l"
n="-n"
s="-s"
h="-h"
f="-f patterns.txt"
o="-o"

reg="the"

success=0
fails=0
num=0

diff_success_message="Files log_s21_grep.txt and log_grep.txt are identical"

rm -rf log_grep.txt log_s21_grep.txt

for file in $file1 $file2 $file3
do

    # grep with -e (it require modified tests)

    for flag1 in $i $v $c $l $n $s $h $o
    do
        num=$(( $num + 1 ))
        grep $flag1 $file $e > log_grep.txt
        ./s21_grep $flag1 $file $e > log_s21_grep.txt
        put=$( diff -s log_s21_grep.txt log_grep.txt )

        if [ "$diff_success_message" = "$put" ]
        then 
            success=$(( $success + 1 ))
            echo "$num test: success grep $flag1 $file $e"
        else 
            fails=$(( $fails + 1 ))
            echo "$num test: fails grep $flag1 $file $e"
        fi
    done

    for flag1 in $i $v $c $l $n $s $h $o
    do
        for flag2 in $i $v $c $l $n $s $h $o
        do
            num=$(( $num + 1 ))
            grep $flag1 $flag2 $file $e > log_grep.txt
            ./s21_grep $flag1 $flag2 $file $e > log_s21_grep.txt
            put=$( diff -s log_s21_grep.txt log_grep.txt )

            if [ "$diff_success_message" = "$put" ]
            then 
                success=$(( $success + 1 ))
                echo "$num test: success grep $flag1 $flag2 $file $e"
            else 
                fails=$(( $fails + 1 ))
                echo "$num test: fails grep $flag1 $flag2 $file $e"
            fi
        done
    done

    # grep with -f (it require modified tests)

    for flag1 in $i $v $c $l $n $s $h $o
    do
        num=$(( $num + 1 ))
        grep $flag1 $file $f > log_grep.txt
        ./s21_grep $flag1 $file $f > log_s21_grep.txt
        put=$( diff -s log_s21_grep.txt log_grep.txt )

        if [ "$diff_success_message" = "$put" ]
        then 
            success=$(( $success + 1 ))
            echo "$num test: success grep $flag1 $file $f"
        else 
            fails=$(( $fails + 1 ))
            echo "$num test: fails grep $flag1 $file $f"
        fi
    done

    for flag1 in $i $v $c $l $n $s $h $o
    do
        for flag2 in $i $v $c $l $n $s $h $o
        do
            num=$(( $num + 1 ))
            grep $flag1 $flag2 $file $f > log_grep.txt
            ./s21_grep $flag1 $flag2 $file $f > log_s21_grep.txt
            put=$( diff -s log_s21_grep.txt log_grep.txt )

            if [ "$diff_success_message" = "$put" ]
            then 
                success=$(( $success + 1 ))
                echo "$num test: success grep $flag1 $flag2 $file $f"
            else 
                fails=$(( $fails + 1 ))
                echo "$num test: fails grep $flag1 $flag2 $file $f"
            fi
        done
    done

done

for file in $file1 $file2 $file3
do

    # grep with 1 flag

    for flag1 in $i $v $c $l $n $s $h $o
    do
        num=$(( $num + 1 ))
        grep $flag1 $reg $file > log_grep.txt
        ./s21_grep $flag1 $reg $file > log_s21_grep.txt
        put=$( diff -s log_s21_grep.txt log_grep.txt )

        if [ "$diff_success_message" = "$put" ]
        then 
            success=$(( $success + 1 ))
            echo "$num test: success grep $flag1 $reg $file"
        else 
            fails=$(( $fails + 1 ))
            echo "$num test: fails grep $flag1 $reg $file"
        fi
    done

    # grep with 2 flag

    for flag1 in $i $v $c $l $n $s $o
    do
        for flag2 in $i $v $c $l $n $s $h $o
        do
            if [ $flag1 != $flag2 ]
            then
                num=$(( $num + 1 ))
                grep $flag1 $flag2 $reg $file > log_grep.txt
                ./s21_grep $flag1 $flag2 $reg $file > log_s21_grep.txt
                put=$( diff -s log_s21_grep.txt log_grep.txt )
                rm -rf log_grep.txt log_s21_grep.txt
                if [ "$diff_success_message" = "$put" ]
                then 
                    success=$(( $success + 1 ))
                    echo "test $num : success grep $flag1 $flag2 $reg $file"
                else 
                    fails=$(( $fails + 1 ))
                    echo "test $num : fails grep $flag1 $flag2 $reg $file"
                fi
            fi
        done
    done

    # grep with 3 flag

    for flag1 in $i $v $c $l $n $o
    do
        for flag2 in $i $v $c $l $n $s $o
        do
            for flag3 in $i $v $c $l $n $s $h $o
            do
                if [ $flag1 != $flag2 ] && [ $flag2 != $flag3 ] && [ $flag1 != $flag3 ]
                then
                    num=$(( $num + 1 ))
                    grep $flag1 $flag2 $flag3 $reg $file > log_grep.txt
                    ./s21_grep $flag1 $flag2 $flag3 $reg $file > log_s21_grep.txt
                    put=$( diff -s log_s21_grep.txt log_grep.txt )

                    if [ "$diff_success_message" = "$put" ]
                    then 
                        success=$(( $success + 1 ))
                        echo "$num test: success grep $flag1 $flag2 $flag3 $reg $file"
                    else 
                        fails=$(( $fails + 1 ))
                        echo "$num test: fails grep $flag1 $flag2 $flag3 $reg $file"
                    fi
                fi
            done
        done
    done

    # grep with 4 flag

    for flag1 in $i $v $c $l $o
    do
        for flag2 in $i $v $c $l $n $o
        do
            for flag3 in $i $v $c $l $n $s $o
            do
                for flag4 in $i $v $c $l $n $s $h $o
                do
                    if [ $flag1 != $flag2 ] && [ $flag2 != $flag3 ] && [ $flag1 != $flag3 ] && [ $flag1 != $flag4 ] && [ $flag2 != $flag4 ] && [ $flag3 != $flag4 ]
                    then
                        num=$(( $num + 1 ))
                        grep $flag1 $flag2 $flag3 $flag4 $reg $file > log_grep.txt
                        ./s21_grep $flag1 $flag2 $flag3 $flag4 $reg $file > log_s21_grep.txt
                        put=$( diff -s log_s21_grep.txt log_grep.txt )

                        if [ "$diff_success_message" = "$put" ]
                        then 
                            success=$(( $success + 1 ))
                            echo "$num test: success grep $flag1 $flag2 $flag3 $flag4 $reg $file"
                        else 
                            fails=$(( $fails + 1 ))
                            echo "$num test: fails grep $flag1 $flag2 $flag3 $flag4 $reg $file"
                        fi
                    fi
                done
            done
        done
    done

done

# miltifile with 1 flag

for flag1 in $i $v $c $l $n $s $h $o
do
    num=$(( $num + 1 ))
    grep $flag1 $reg $file1 $file2 > log_grep.txt
    ./s21_grep $flag1 $reg $file1 $file2 > log_s21_grep.txt
    put=$( diff -s log_s21_grep.txt log_grep.txt )

    if [ "$diff_success_message" = "$put" ]
    then 
        success=$(( $success + 1 ))
        echo "$num test: success grep $flag1 $reg $file1 $file2"
    else 
        fails=$(( $fails + 1 ))
        echo "$num test: fails grep $flag1 $reg $file1 $file2"
    fi
done

# miltifile with 2 flags

for flag1 in $i $v $c $l $n $s $h $o
do
    for flag2 in $i $v $c $l $n $s $h $o
    do
        if [ $flag1 != $flag2 ]
        then
            num=$(( $num + 1 ))
            grep $flag1 $flag2 $reg $file1 $file2 > log_grep.txt
            ./s21_grep $flag1 $flag2 $reg $file1 $file2 > log_s21_grep.txt
            put=$( diff -s log_s21_grep.txt log_grep.txt )

            if [ "$diff_success_message" = "$put" ]
            then 
                success=$(( $success + 1 ))
                echo "$num test: success grep $flag1 $flag2 $reg $file1 $file2"
            else 
                fails=$(( $fails + 1 ))
                echo "$num test: fails grep $flag1 $flag2 $reg $file1 $file2"
            fi
        fi
    done
done

# miltifile with 3 flags

for flag1 in $i $v $c $l $n $s $h $o
do
    for flag2 in $i $v $c $l $n $s $h $o
    do
        for flag3 in $i $v $c $l $n $s $h $o
        do
            if [ $flag1 != $flag2 ] && [ $flag2 != $flag3 ] && [ $flag1 != $flag3 ]
            then
                num=$(( $num + 1 ))
                grep $flag1 $flag2 $flag3 $reg $file1 $file2 > log_grep.txt
                ./s21_grep $flag1 $flag2 $flag3 $reg $file1 $file2 > log_s21_grep.txt
                put=$( diff -s log_s21_grep.txt log_grep.txt )

                if [ "$diff_success_message" = "$put" ]
                then 
                    success=$(( $success + 1 ))
                    echo "$num test: success grep $flag1 $flag2 $flag3 $reg $file2 $file3"
                else 
                    fails=$(( $fails + 1 ))
                    echo "$num test: fails grep $flag1 $flag2 $flag3 $reg $file2 $file3"
                fi
            fi
        done
    done
done



rm -rf log_grep.txt log_s21_grep.txt

echo "\n\ntests: $num\nsuccess: $success\nfails: $fails"