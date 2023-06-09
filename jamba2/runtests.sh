#!/usr/bin/env bash

PLC="stack run "

globallog=runtests.log
rm -f $globallog
error=
keep=

# Destination directory for generated files (log excepted)
mkdir -p out

# Set time limit
ulimit -t 5

Usage() {
    echo "Usage: runtests.sh [options] [files]"
    echo "-k    Keep intermediate files"
    echo "-h    Print this help"
    exit 1
}

# NoteGen <filename>
# Remember that the given filename was generated so we can clean up
NoteGen() {
  generatedfiles="$generatedfiles $1"
}

SignalError() {
    if [ -z "$error" ] ; then
        echo "FAILED"
        error=1
    fi
    echo "  $1"
}

# Compare <outfile> <reffile> <difffile>
# Compares the outfile with reffile.  Differences, if any, written to difffile
Compare() {
    NoteGen "$3"
    if ! [ -f "$2" ] ; then
      SignalError "$2 not found"	
      echo "$2 not found" 1>&2
    else
	echo diff -b $1 $2 ">" $3 1>&2
	diff -b "$1" "$2" > "$3" 2>&1 || {
	    SignalError "$1 differs"
	    echo "FAILED $1 differs from $2" 1>&2
	    cat $3 >&2
	}
    fi
}

# Run <args>
# Report the command, run it, and report any errors
Run() {
    echo $* 1>&2
    eval $* || {
	SignalError "failed: $*"
	return 1
    }
}

# RunFail <args>
# Report the command, run it, and expect an error
RunFail() {
    echo $* 1>&2
    eval $* && {
	SignalError "failed: $* did not report an error"
	return 1
    }
    return 0
}

# Run the parser on the given file
Check() {
    error=
    basename=`basename $1 | sed 's/[.][^.]*$//'`
    reffile=`echo $1 | sed 's/[.][^.]*$//'`
    basedir=`dirname $1`

    echo -n "$basename..."

    echo 1>&2
    echo "###### Testing $basename" 1>&2

    generatedfiles=

    # Run the parser
    result="out/${basename}.out"
    reference="${reffile}.out"
    diff="out/${basename}.diff"
    NoteGen "${result} ${diff}"
    
    Run $PLC "$1" ">" "${result}" &&
    Compare "${result}" "${reference}" "${diff}"

    if [ -z "$error" ] ; then
	if [ -z "$keep" ] ; then
	    rm -f $generatedfiles
	fi
	echo "OK"
	echo "###### SUCCESS" 1>&2
    else
	echo "###### FAILED" 1>&2
	globalerror=$error
    fi
}

# Run the compiler and expect an error
CheckFail() {
    error=
    basename=`basename $1 | sed 's/[.][^.]*$//'`
    reffile=`echo $1 | sed 's/[.][^.]*$//'`
    basedir=`dirname $1`

    echo -n "$basename..."

    echo 1>&2
    echo "###### Testing failure $basename" 1>&2

    generatedfiles=

    # Run the parser

    parsed="out/${basename}.jj"
    difffile="out/${basename}.diff"
    NoteGen "${parsed} ${difffile}"
    RunFail $PLC "<" "$1" ">" "${parsed}" "2>" "${errfile}" &&
    Compare "${errfile}" "${reffile}.err" "${difffile}"

    # Report the status and clean up the generated files

    if [ -z "$error" ] ; then
	if [ -z "$keep" ] ; then
	    rm -f $generatedfiles
	fi
	echo "OK"
	echo "###### SUCCESS" 1>&2
    else
	echo "###### FAILED" 1>&2
	globalerror=$error
    fi
}

while getopts kh c; do
    case $c in
	k) # Keep intermediate files
	    keep=1
	    ;;
	h) # Help
	    Usage
	    ;;
    esac
done

shift `expr $OPTIND - 1`

if [ $# -ge 1 ]
then
    files=$@
else
    files="tests/*.jj"
fi

for file in $files
do
  case "$file" in
    *-fail.jj)
	  CheckFail "$file" 2>> $globallog
	  ;;
    *)
	  Check "$file" 2>> $globallog
	  ;;
  esac    
done

exit $globalerror
