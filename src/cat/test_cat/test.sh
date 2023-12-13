file1="test1.txt"
file2="test2.txt"
file3="test3.txt"

b="-b"
e="-e"
n="-n"
s="-s"
t="-t"

success=0
fails=0
num=0

diff_success_message="Files log_s21_cat.txt and log_cat.txt are identical"

rm -rf log_grep.txt log_s21_grep.txt

# check error situations
# wrong flags place

num=$(( $num + 1 ))
cat $b $e $file1 $s > log_cat.txt
./s21_cat $b $e $file1 $s > log_s21_cat.txt
put=$( diff -s log_s21_cat.txt log_cat.txt )

if [ "$diff_success_message" = "$put" ]
then 
    echo "$num test: success cat $b $e $file1 $s"
    success=$(( $success + 1 ))
else 
    echo "$num test: fails cat $b $e $file1 $s"
    fails=$(( $fails + 1 ))
fi



for file in $file1 $file2 $file3
do

    # cat with 1 flag

    for flag in $b $e $n $s $t
    do
        num=$(( $num + 1 ))
        cat $flag $file > log_cat.txt
        ./s21_cat $flag $file > log_s21_cat.txt
        put=$( diff -s log_s21_cat.txt log_cat.txt )

        if [ "$diff_success_message" = "$put" ]
        then 
            echo "$num test: success cat $flag $file"
            success=$(( $success + 1 ))
        else 
            echo "$num test: fails cat $flag $file"
            fails=$(( $fails + 1 ))
        fi
    done

    # cat with 2 flags

    for flag1 in $b $e $n $s $t
    do
        for flag2 in $b $e $n $s $t
        do
            if [ $flag1 != $flag2 ]
            then
                num=$(( $num + 1 ))
                cat $flag1 $flag2 $file > log_cat.txt
                ./s21_cat $flag1 $flag2 $file > log_s21_cat.txt
                put=$( diff -s log_s21_cat.txt log_cat.txt )

                if [ "$diff_success_message" = "$put" ]
                then 
                    echo "$num test: success cat $flag1 $flag2 $file"
                    success=$(( $success + 1 ))
                else 
                    echo "$num test: fails cat $flag1 $flag2 $file"
                    fails=$(( $fails + 1 ))
                fi
            fi
        done
    done

    # cat with 3 flags

    for flag1 in $b $e $n $s $t
    do
        for flag2 in $b $e $n $s $t
        do
            for flag3 in $b $e $n $s $t
            do
                if [ $flag1 != $flag2 ] && [ $flag2 != $flag3 ] && [ $flag1 != $flag3 ]
                then
                    num=$(( $num + 1 ))
                    cat $flag1 $flag2 $flag3 $file > log_cat.txt
                    ./s21_cat $flag1 $flag2 $flag3 $file > log_s21_cat.txt
                    put=$( diff -s log_s21_cat.txt log_cat.txt )

                    if [ "$diff_success_message" = "$put" ]
                    then 
                        echo "$num test: success cat $flag1 $flag2 $flag3 $file"
                        success=$(( $success + 1 ))
                    else 
                        echo "$num test: fails cat $flag1 $flag2 $flag3 $file"
                        fails=$(( $fails + 1 ))
                    fi
                fi
            done
        done
    done

   # cat with 4 flags

    for flag1 in $b $e $n $s $t
    do
        for flag2 in $b $e $n $s $t
        do
            for flag3 in $b $e $n $s $t
            do
                for flag4 in $b $e $n $s $t
                do
                    if [ $flag1 != $flag2 ] && [ $flag2 != $flag3 ] && [ $flag1 != $flag3 ] && [ $flag1 != $flag4 ] && [ $flag2 != $flag4 ] && [ $flag3 != $flag4 ]
                    then
                        num=$(( $num + 1 ))
                        cat $flag1 $flag2 $flag3 $flag4 $file > log_cat.txt
                        ./s21_cat $flag1 $flag2 $flag3 $flag4 $file > log_s21_cat.txt
                        put=$( diff -s log_s21_cat.txt log_cat.txt )

                        if [ "$diff_success_message" = "$put" ]
                        then 
                            echo "$num test: success cat $flag1 $flag2 $flag3 $flag4 $file"
                            success=$(( $success + 1 ))
                        else 
                            echo "$num test: fails cat $flag1 $flag2 $flag3 $flag4 $file"
                            fails=$(( $fails + 1 ))
                        fi
                    fi
                done
            done
        done
    done

    # cat with 5 flags

    num=$(( $num + 1 ))
    cat $b $e $n $s $t $file > log_cat.txt
    ./s21_cat $b $e $n $s $t $file > log_s21_cat.txt
    put=$( diff -s log_s21_cat.txt log_cat.txt )

    if [ "$diff_success_message" = "$put" ]
    then 
        echo "$num test: success cat $b $e $n $s $t $file"
        success=$(( $success + 1 ))
    else 
        echo "$num test: fails cat $b $e $n $s $t $file"
        fails=$(( $fails + 1 ))
    fi

done

# miltifile with 2 flag

for flag1 in $b $e $n $s $t
do
    for flag2 in $b $e $n $s $t
    do
        if [ $flag1 != $flag2 ]
        then
            num=$(( $num + 1 ))
            cat $flag1 $flag2 $file1 $file2 > log_cat.txt
            ./s21_cat $flag1 $flag2 $file1 $file2 > log_s21_cat.txt
            put=$( diff -s log_s21_cat.txt log_cat.txt )

            if [ "$diff_success_message" = "$put" ]
            then 
                echo "$num test: success cat $flag1 $flag2 $file1 $file2"
                success=$(( $success + 1 ))
            else 
                echo "$num test: fails cat $flag1 $flag2 $file1 $file2"
                fails=$(( $fails + 1 ))
            fi
        fi
    done
done

# miltifile with 4 flag

for flag1 in $b $e $n $s $t
do
    for flag2 in $b $e $n $s $t
    do
        for flag3 in $b $e $n $s $t
        do
            for flag4 in $b $e $n $s $t
            do
                if [ $flag1 != $flag2 ] && [ $flag2 != $flag3 ] && [ $flag1 != $flag3 ] && [ $flag1 != $flag4 ] && [ $flag2 != $flag4 ] && [ $flag3 != $flag4 ]
                then
                    num=$(( $num + 1 ))
                    cat $flag1 $flag2 $flag3 $flag4 $file1 $file2 > log_cat.txt
                    ./s21_cat $flag1 $flag2 $flag3 $flag4 $file1 $file2 > log_s21_cat.txt
                    put=$( diff -s log_s21_cat.txt log_cat.txt )

                    if [ "$diff_success_message" = "$put" ]
                    then 
                        echo "$num test: success cat $flag1 $flag2 $flag3 $flag4 $file1 $file2"
                        success=$(( $success + 1 ))
                    else 
                        echo "$num test: fails cat $flag1 $flag2 $flag3 $flag4 $file1 $file2"
                        fails=$(( $fails + 1 ))
                    fi
                fi
            done
        done
    done
done

rm -rf log_cat.txt log_s21_cat.txt

echo "\n\ntests: $num\nsuccess: $success\nfails: $fails"