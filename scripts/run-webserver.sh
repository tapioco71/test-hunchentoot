#!/bin/bash

interpreter="ecl"
ecl_program=`which ecl`
sbcl_program=`which sbcl`
lisp_form="(ql:quickload :ssl-smt-webserver)"

case $interpreter in
    "ecl") if [ -x $ecl_program ]; then
	       nohup $ecl_program --eval "$lisp_form" > output.txt 2>&1 &
	   fi
	   ;;
    "sbcl") if [ -x $sbcl_program ]; then
		nohup $sbcl_program --eval "$lisp_form"  > output.txt 2>&1 &
	    fi
	    ;;
esac
