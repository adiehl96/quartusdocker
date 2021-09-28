#!/bin/bash
# Copyright (c) 2012 Altera Corporation. All rights reserved.


# Your use of Altera Corporation's design tools, logic functions and other
# software and tools, and its AMPP partner logic functions, and any output files
# any of the foregoing (including device programming or simulation files), and
# any associated documentation or information are expressly subject to the terms
# and conditions of the Altera Program License Subscription Agreement, Altera
# Intel FPGA IP License Agreement, or other applicable license agreement,
# including, without limitation, that your use is for the sole purpose of
# programming logic devices manufactured by Altera and sold by Altera or its
# authorized distributors.  Please refer to the applicable agreement for
# further details.

if test ! "${QUARTUS_QENV-UNSET}" != UNSET ; then
	export QUARTUS_QENV=1
	export QENV_STATUS=0

	if test ! "${QUARTUS_ROOTDIR-UNSET}" != UNSET ; then
		echo "You must set the QUARTUS_ROOTDIR environment variable"
		echo "to point to a valid Quartus II installation before"
		echo "sourcing this script!"
		exit
	fi

	##### Reset paths

	# Save original paths we inherited from the caller
	export QUARTUS_ORIG_PATH=$PATH

	# Save original library path if exists
	if test "${LD_LIBRARY_PATH-UNSET}" != UNSET ; then
		export QUARTUS_ORIG_LIBPATH=$LD_LIBRARY_PATH
	fi

	##### Basic settings

	if test ! "${TMP-UNSET}" != UNSET ; then
		export TMP=/tmp
	elif test ! -d $TMP ; then
		export TMP=/tmp
	fi

	# quartus doesn't support other languages
	# so if LANG is set make sure its C
	if test "${LANG-UNSET}" != UNSET ; then
		if test "$LANG" != "C" ; then export LANG=C ; fi
	fi
	# if any LC_* variable is set, set LC_ALL to C to override
	env | grep LC_ > /dev/null 2>&1
	if test $? = 0 ; then export LC_ALL=C ; fi

	export QUARTUS_BIT_TYPE=32
	export UNAME_SYSTEM=`uname -s`
	export UNAME_REVISION=`uname -r`
	UNAME_VERSION=`uname -v`
	export UNAME_VERSION="$UNAME_VERSION"

	if test ! "${CMD_NAME-UNSET}" != UNSET ; then export CMD_NAME=`basename $0` ; fi

	##### Platform settings

	if test $UNAME_SYSTEM = "Linux" ; then
		export QUARTUS_PLATFORM=linux
		export PATCH_CMD=""
		export AWK_CMD="awk"
		lc_setting=`locale -a | grep en_US$`

	        if test "$lc_setting" != "en_US" ; then
			lc_setting="en_US.UTF-8"
		fi

		if test "${LC_CTYPE-UNSET}" != UNSET ; then
			if test "$LC_CTYPE" = "POSIX" ; then
				export LC_CTYPE=$lc_setting
			fi
			if test "$LC_CTYPE" = "C" ; then
				export LC_CTYPE=$lc_setting
			fi
		else
			unset LC_ALL
			export LC_CTYPE=$lc_setting
		fi

		# Memory manager crashes if LD_ASSUME_KERNEL is used:
		unset LD_ASSUME_KERNEL

	fi
fi

if test `uname -m` = "x86_64" ; then
	export QUARTUS_BIT_TYPE=64
fi

# We don't support processors without SSE extensions (e.g. Pentium II and older CPUs).
# cpumodel=`grep 'model name' /proc/cpuinfo | sed -e's/model name.*: //g' | uniq`
# export cpumodel="$cpumodel"
# grep sse /proc/cpuinfo > /dev/null 2>&1
# if test $? != 0 ; then
# 	echo ""
# 	echo "The Quartus II software is optimized for the Intel Pentium III processor"
#	echo "and newer processors.  The required extensions were not found on:"
#	echo "'$cpumodel'"
#	echo ""
#	echo "The Quartus II software will not function properly on this processor model."
#	echo "Terminating..."
#	export QENV_STATUS=-1
# fi

##### Determine what bitness executables we should use

QBINDIR32=$QUARTUS_ROOTDIR/$QUARTUS_PLATFORM
QBINDIR64=$QUARTUS_ROOTDIR/${QUARTUS_PLATFORM}64

if test $QUARTUS_BIT_TYPE = "32" ; then
    # On a 32-bit system the only option is to use 32-bit
    if test -d $QBINDIR32 ; then
        export QUARTUS_BINDIR=$QBINDIR32
    else
	    echo "Error: Can not run the 64-bit Quartus II software on a 32-bit machine."
	    export QENV_STATUS=-1
    fi
else
    # On a 64-bit system use 64-bit if its present, otherwise use 32-bit
    if test -d $QBINDIR64 ; then
        export QUARTUS_BINDIR=$QBINDIR64
    elif test -d $QBINDIR32 ; then
        export QUARTUS_BINDIR=$QBINDIR32
    else
	    echo "Error: The Quartus II software installation is incomplete, please re-install."
	    export QENV_STATUS=-1
    fi
fi

##### Quartus path setup

export PATH=$QUARTUS_BINDIR:$PATH
export LD_LIBRARY_PATH=$QUARTUS_BINDIR:$LD_LIBRARY_PATH

# Add <qdir>/adm to path, it has some helper tools
export PATH=$QUARTUS_ROOTDIR/adm:$PATH

if test -f $QUARTUS_ROOTDIR/adm/qtb.sh ; then
	. $QUARTUS_ROOTDIR/adm/qtb.sh
fi
