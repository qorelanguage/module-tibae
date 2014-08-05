# Process this file with autoconf to produce a configure script.

# AC_PREREQ(2.59)
AC_INIT([qore-tibae-module], [1.0.5],
        [David Nichols <david@qore.org>],
        [qore-tibae-module])
AM_INIT_AUTOMAKE
AC_CONFIG_HEADER([config.h])

AC_LANG(C++)
AC_PROG_CXX
AC_PROG_CC
AC_DISABLE_STATIC
AC_LIBTOOL_DLOPEN
AM_PROG_LIBTOOL
AC_PROG_INSTALL

# fix for building with older autotools
if test ! -d m4; then mkdir m4; fi

AC_CONFIG_MACRO_DIR([m4])

#LT_PREREQ([2.2])
#LT_INIT([disable-shared])
#AC_SUBST([LIBTOOL_DEPS])

# set system variables
OS=`uname -s`
if test "$OS" = "HP-UX"; then
   if test "$host_cpu" = "ia64"; then
      ARCH=itanium
   else
      ARCH=PA-RISC
   fi
else
   ARCH=`uname -p`
   if test "$ARCH" = unknown; then
      ARCH=`uname -m`
   fi
   if test $ARCH = i686 -o $ARCH = i586 -o $ARCH = athlon ; then
      ARCH=i386
   fi
fi

# set find prefix
if test -n "$prefix" -a "$prefix" != "NONE"; then
   find_prefix="$prefix"
fi

#AC_CANONICAL_HOST
# get CPU family
case "${host_cpu}" in
   i[[3456]]86) cpu_family=i386 ;;
   amd64)       cpu_family=x86_64 ;;
   *)           cpu_family=${host_cpu} ;;
esac

# set OS-specific variables
SHLIB_SUFFIX=so
#echo host_os=${host_os}sss
case "${host_os}" in
     *linux*)   AC_DEFINE(NEED_ICONV_TRANSLIT, 1, Define to 1 if //TRANSLIT should be added to the destination character set code) 
		# set compile flags for Linux
		CPPFLAGS="${CPPFLAGS} -D_GNU_SOURCE"
		SHLIB_SUFFIX=so
		AC_DEFINE(LINUX, 1, if compiling on Linux)
		;;
     *solaris*) # set compile flags for Solaris
		CPPFLAGS="${CPPFLAGS} -D_POSIX_C_SOURCE=199506L -D_XPG4_2 -D_XPG5 -D__EXTENSIONS__"
		# for checking for some network functions on Solaris
		LDFLAGS="$LDFLAGS -lnsl"
		# assume we are using CC if not using g++, add -norunpath to link flags in this case
		if test "$GXX" != "yes"; then
		   CXXFLAGS="${CXXFLAGS} -mt"
		   LDFLAGS="$LDFLAGS -norunpath -mt"
		fi
		AC_DEFINE(SOLARIS, 1, if compiling on Solaris)
		# add -ldl to libs if on Solaris 8
		if test "${host_os}" = "solaris2.8"; then
		   OTHER_LIBS="$OTHER_LIBS -ldl"
		fi
		solaris=yes
	        ;;
     *darwin*)  SHLIB_SUFFIX=dylib
		# libtool 1.5.* is creating modules on Darwin 8.* (OS/X 10.4.*) with a .so suffix for some reason
		MODULE_SUFFIX=so
		AC_DEFINE(DARWIN, 1, [if compiling on Darwin])
		# use gnutar on darwin to avoid getting those pesky resource files
		AMTAR=gnutar
		darwin=true
		;;
     *hpux*)    if test "$host_cpu" = "ia64"; then
     		   SHLIB_SUFFIX=so
		else  # assume hppa (PA-RISC)
     		   SHLIB_SUFFIX=sl
		   AC_DEFINE(SHLIB_SUFFIX, "sl", shared library suffix)
		fi
		# add "-AA" and -D__STDC_EXT__ to aCC commandline to enable a clean compile
		if test -n "`echo $CXX|grep aCC`"; then
		   CXXFLAGS="$CXXFLAGS -AA -D__STDC_EXT__ -D_RWSTD_MULTI_THREAD"
		   AC_DEFINE(HPUX_ACC_SOCKLEN_HACK, 1, [if compiling on HP-UX with aCC and need to use int instead of socklen_t])
		fi
		AC_DEFINE(HPUX, 1, if compiling on HP-UX)
		AC_DEFINE(NEED_ENVIRON_LOCK, 1, [if the environment operations need explicit locking])
		;;
     *cygwin*)  SHLIB_SUFFIX=dll
                CPPFLAGS=-mwin32
                windows=yes
                # turn off signal handling for cygwin; cygwin supports it, but it's emulated/slow/non-native
                no_sig_handling=yes
                ;;
     *mingw32*) SHLIB_SUFFIX=dll
                windows=yes
                mingw=yes
                need_user_dl=yes # set to make sure there's a user-provided dlfcn.h and libdl.(a|dll) available
                # DEBUG
                #make_dll=no
                # libraries to find
                need_libs="$need_libs wsock32 ws2_32 gdi32 iconv pthread"
                # DEBUG: cannot create dll without these libraries for some reason
                #need_libs="$need_libs user32 gdi32 iberty msvcrt advapi32 mingwex moldname kernel32"
                # turn off signal handling for windows
                no_sig_handling=yes
                # have to set _WIN32_WINNT level so that some networking APIs are available
                CPPFLAGS="$CPPFLAGS -D_WIN32_WINNT=0x0501"
                # have to set a flag when building the library so symbols are exported correctly
                QORE_LIB_CPPFLAGS="-DBUILDING_DLL=1"
                # make sure OS is set to Windows when cross-compiling
                OS=Windows
                # set LIB_PREFIX if not already set
                if test -z "$LIB_PREFIX"; then
                   AC_MSG_CHECKING([for mingw32 library prefix])
                   cc_loc=`which $CXX|head -1`
                   mingw_base=`dirname $cc_loc|sed 's/\/@<:@^/@:>@*$//'`
                   cc_targ=`echo $CXX|sed s/-g++$//`
                   if test -d $mingw_base/$cc_targ; then
                      LIB_PREFIX=$mingw_base/$cc_targ
                      AC_MSG_RESULT([$LIB_PREFIX])
                   else
                      AC_MSG_RESULT([not found])
                   fi
                fi
                # need a native g++ compiler for native targets (ie qpp)
                if test -z "$NATIVE_CXX"; then
                   NATIVE_CXX=`which g++|head -1 2>/dev/null`
                   if test -z "$NATIVE_CXX"; then
                      AC_MSG_ERROR(unable to find a native c++ compiler; please set NATIVE_CXX to the path to the native c++ compiler for building qpp)
                   fi
                fi
                if test -z "$NATIVE_CXX"; then
                   NATIVE_CXX=$CXX
                fi
                AC_SUBST(NATIVE_CXX)
                AC_SUBST(NATIVE_CPPFLAGS)
                AC_SUBST(NATIVE_LDDFLAGS)
                ;;
     *)         AC_WARN(Unknown platform ${host_os})
                ;;
esac
AC_SUBST(SHLIB_SUFFIX)
if test -z "$MODULE_SUFFIX" ; then
   MODULE_SUFFIX=$SHLIB_SUFFIX
fi
AC_SUBST(MODULE_SUFFIX)

AC_ARG_ENABLE([64bit],
  [AS_HELP_STRING([--enable-64bit],
		  [enable 64bit support (default: auto)])],
  [case "${enable_64bit}" in
       yes|no) ;;
       *)      AC_MSG_ERROR(bad value ${enable_64bit} for --enable-64bit) ;;
      esac],
  [enable_64bit=auto])

if test "$enable_64bit" = "auto"; then
   # turn on 64-bit by default if compiling on a 64-bit platform
   case "${host_cpu}" in
       *64*)
                 enable_64bit=yes 
                 ;;
       s390x)
                 enable_64bit=yes 
                 ;;
       *)        case "${host_os}" in
                     darwin*)   mv=`uname -r|cut -f1 -d.`
 		                if test $mv -ge 10 -a "${host_cpu}" = "i386"; then
		         	    enable_64bit=yes
		      		fi
		     ;;
		     solaris*)  if test "${host_cpu}" = "i386"; then
		     	            # if we are running on a 64-bit machine, then enable a 64-bit build
				    if test -n "`isainfo -v 2>/dev/null| grep 64-bit`"; then
		         	        enable_64bit=yes
		     		    fi
		     	        fi
		     ;;
       		 esac
		 if test "$enable_64bit" = "auto"; then
		     enable_64bit=no
		 fi
                 ;;
    esac
fi

# see if we know how to set flags properly for different hosts and architectures
# FIXME: add test on HP-UX if the compiler can generate the appropriate binaries
if test "$enable_64bit" = "yes"; then
   case "${host_os}" in
      *linux*)	if test "$GXX" = "yes"; then
		   CXXFLAGS="$CXXFLAGS -m64"
		fi
		# only set LIBSUFFIX=64 if /usr/lib64 exists
		if test -d /usr/lib64; then
		   LIBSUFFIX=64
                fi
                target="${host_cpu}-${host_os}"
                if test -d /usr/lib/$target; then
                   LIBSUFFIX=/$target
                fi
		AC_SUBST(LIBSUFFIX)
		;;
      *hpux*)	if test "$host_cpu" = "ia64"; then
                    if test -n "`echo $CXX|grep aCC`"; then
                        CXXFLAGS="$CXXFLAGS +DD64"
                    elif test "$GXX" = "yes"; then
                        CXXFLAGS="$CXXFLAGS -mlp64"
                    fi
                else
		    if test -n "`echo $CXX|grep aCC`"; then
		        CXXFLAGS="$CXXFLAGS +DA2.0W"
		    elif test "$GXX" = "yes"; then
			CXXFLAGS="$CXXFLAGS -march=2.0"
		    fi
		fi
		;;
     *solaris*) if test "$GXX" = "yes"; then
		    if test "$host_cpu" = "sparc"; then
		        CXXFLAGS="$CXXFLAGS -mcpu=ultrasparc3 -m64"  # NOTE we compile for minimum ultrasparc 3 in 64-bit mode
		    else
		        CXXFLAGS="$CXXFLAGS -m64"
		    fi
		else
		    CC_MAJOR=`$CXX -V 2>&1 | head -1| cut -f1 -d.|cut -d\  -f4`
		    CC_MINOR=`$CXX -V 2>&1 | head -1| cut -f2 -d.|cut -d\  -f1`
		    if test "$CC_MAJOR" -gt 5 -o \( "$CC_MAJOR" -eq 5 -a "$CC_MINOR" -ge 10 \); then
		        CXXFLAGS="$CXXFLAGS -m64"
		    else
			CXXFLAGS="$CXXFLAGS -xarch=generic64"
		    fi
		fi
		;;
     *darwin*)	if test "$GXX" = "yes"; then
		   CXXFLAGS="$CXXFLAGS -m64"
		fi
		# set ARCH to x86_64 to be consistent with other intel 64-bit builds
		if test "$host_cpu" = "i386"; then
		   ARCH=x86_64
		fi
		;;
   esac
   SYBLIBSUFFIX=64
   RVLIBSUFFIX=64
   bits=64
else
   case "${host_os}" in
     *linux*)	if test "$GXX" = "yes"; then
		   CXXFLAGS="$CXXFLAGS -m32"
		fi
                # multiarch
                if test -a "$host_cpu" = "x86_64" -a -d /usr/lib32; then
                   LIBSUFFIX=32
                fi
                AC_SUBST(LIBSUFFIX)
		;;
     *darwin*)  if test "$GXX" = "yes"; then
                   CXXFLAGS="$CXXFLAGS -m32"
                fi
                ;;
     *hpux*)	if test "$host_cpu" != "ia64"; then
		    if test "$GXX" = "yes"; then
		        CXXFLAGS="$CXXFLAGS -march=2.0"
		    elif test -n "`echo $CXX|grep aCC`" -a "$host_cpu" != "ia64"; then
		        CXXFLAGS="$CXXFLAGS +DA2.0N"   # NOTE we compile for PA-RISC 2.0 32-bit, not PA-RISC 1.1
		    fi
		fi
		;;
     *solaris*) if test "$GXX" = "yes"; then
		    if test "$host_cpu" = "sparc"; then
		        CXXFLAGS="$CXXFLAGS -mcpu=v8 -m32"
		    else
		        CXXFLAGS="$CXXFLAGS -m32"
		    fi
		else
		    CXXFLAGS="$CXXFLAGS -xarch=generic"
		fi
		;;
   esac
   if test "$host_cpu" = "x86_64"; then
      cpu_family=i386
   fi
   bits=32
fi

# checks for how to build threads
ACX_PTHREAD
if test "$acx_pthread_ok" = "no"; then
   AC_MSG_ERROR(POSIX threads do not seem to be supported on this platform, aborting)
fi
CXXFLAGS="$CXXFLAGS $PTHREAD_CFLAGS"
#LDFLAGS="$LDFLAGS $PTHREAD_LIBS"

AC_ARG_ENABLE([single-compilation-unit],
  [AS_HELP_STRING([--enable-single-compilation-unit],
                  [enable compilation as a single unit (default: on)])],
  [case "${enable_single_compilation_unit}" in
       yes|no) ;;
       *)      AC_MSG_ERROR(bad value ${enable_single_compilation_unit} for --enable-single-compilation-unit) ;;
      esac],
  [enable_single_compilation_unit=yes])

# allow the user to set a generic search prefix for libraries, includes, etc
AC_ARG_WITH([lib-prefix],
  [AS_HELP_STRING([--with-lib-prefix@<:@=DIR@:>@],
                  [generic search prefix for libraries, includes, etc])],
  [if test ! -d "${with_lib_prefix}"; then AC_MSG_ERROR([bad value ${with_lib_prefix} for --with-lib-prefix]); unset with_lib_prefix; fi],
  [with_lib_prefix="$LIB_PREFIX"])

AC_ARG_WITH([tibrv],
  [AS_HELP_STRING([--with-tibrv@<:@=DIR@:>@],
		  [TIBCO Rendezvous directory (defaults to $RV_ROOT)])],
  [if test ! -d "${with_tibrv}"; then AC_MSG_ERROR(bad value ${with_tibrv} for --with-tibrv); unset with_tibrv; fi])

AC_MSG_CHECKING([TIBCO Rendezvous])
if test -n "$with_tibrv"; then
   if test ! -e "$with_tibrv/tibrv/tibrv.h"; then
      AC_MSG_ERROR([can't find tibrv.h in $with_tibrv/tibrv])
   elif test ! -e "$with_tibrv/lib/libtibrv.a"; then
      AC_MSG_ERROR([can't find libtibrv.a in $with_tibrv/lib])
   else
      AC_MSG_RESULT([$with_tibrv])
   fi
else
   if test -n "$RV_ROOT" -a -f "$RV_ROOT/include/tibrv/tibrv.h" -a -e "$RV_ROOT/lib/libtibrv.a"; then
      AC_MSG_RESULT([$RV_ROOT])
      with_tibrv=$RV_ROOT
   elif test -f /opt/tibrv/include/tibrv/tibrv.h -a -f /opt/tibrv/lib/libtibrv.a; then
      AC_MSG_RESULT([/opt/tibrv])
      with_tibrv=/opt/tibrv
   elif test -f /opt/tibco/tibrv/include/tibrv/tibrv.h -a -f /opt/tibco/tibrv/lib/libtibrv.a; then
      AC_MSG_RESULT([/opt/tibco/tibrv])
      with_tibrv=/opt/tibco/tibrv
   elif test -f /usr/tibrv/include/tibrv/tibrv.h -a -f /usr/tibrv/lib/libtibrv.a; then
      AC_MSG_RESULT([/usr/tibrv])
      with_tibrv=/usr/tibrv
   elif test -f /usr/tibco/tibrv/include/tibrv/tibrv.h -a -f /usr/tibco/tibrv/lib/libtibrv.a; then
      AC_MSG_RESULT([/usr/tibco/tibrv])
      with_tibrv=/usr/tibco/tibrv
   elif test -f /usr/local/tibco/tibrv/include/tibrv/tibrv.h -a -f /usr/local/tibco/tibrv/lib/libtibrv.a; then
      AC_MSG_RESULT([/usr/tibco/local/tibrv])
      with_tibrv=/usr/local/tibco/tibrv
   else
      AC_MSG_ERROR([not found])
      unset with_tibrv
   fi
fi

if test -n "$with_tibrv"; then
   rv_found="$with_tibrv"

   # setup tibrv compile and link vars
   TIBRV_CPPFLAGS="-I${with_tibrv}/include"
   TIBRV_LDFLAGS="-L${with_tibrv}/lib -ltibrv${RVLIBSUFFIX} -ltibrvcm${RVLIBSUFFIX} -ltibrvcmq${RVLIBSUFFIX} -ltibrvft${RVLIBSUFFIX}"

   AC_SUBST(TIBRV_CPPFLAGS)
   AC_SUBST(TIBRV_LDFLAGS)
   AC_DEFINE(TIBRV, 1, Define if TIBCO Rendezvous support should be included)
fi

# set SDK_ROOT to TRA_ROOT if TRA_ROOT is set and SDK_ROOT is not
if test -n "$TRA_ROOT" -a -z "$SDK_ROOT"; then SDK_ROOT=$TRA_ROOT; fi

AC_ARG_WITH([tibae],
  [AS_HELP_STRING([--with-tibae@<:@=DIR@:>@],
		  [TIBCO Adapters SDK directory (defaults to $SDK_ROOT)])],
  [if test ! -d "${with_tibae}"; then AC_MSG_ERROR(bad value ${with_tibae} for --with-tibae); unset with_tibae; fi])

AC_MSG_CHECKING([TIBCO Adapters SDK])
if test -n "$with_tibae"; then
   if test ! -e "$with_tibae/include/sdk/Maverick.h" -a ! -e "$with_tibae/include/Maverick.h"; then
      AC_MSG_ERROR([can't find Maverick.h in $with_tibae/include/sdk or in $with_tibae/include])
   else
      AC_MSG_RESULT([$with_tibae])
   fi
else
   # disable AE SDK on HP-UX PA-RISC, it requires compiling without the -AA flag which we don't support
   if test "$OS" = "HP-UX" -a $host_cpu != "ia64"; then
      AC_MSG_WARN([TIBCO Adapters SDK not supported on HP-UX])
      unset with_tibae
   elif test -n "$SDK_ROOT" -a \( -f "$SDK_ROOT/include/sdk/Maverick.h" -o -f "$SDK_ROOT/include/Maverick.h" \) 2>/dev/null; then
      AC_MSG_RESULT([$SDK_ROOT])
      with_tibae=$SDK_ROOT      
   else
      AC_MSG_ERROR([not found; cannot build without AE SDK support])
      unset with_tibae
   fi
fi

AC_ARG_WITH([tibco-ems],
  [AS_HELP_STRING([--with-tibco-ems@<:@=DIR@:>@],
		  [TIBCO EMS directory (defaults to $JMS_ROOT)])],
  [if test ! -d "${with_tibco_ems}"; then AC_MSG_ERROR(bad value ${with_tibco_ems} for --with-tibco-ems); unset with_tibco_ems; fi])

AC_MSG_CHECKING([TIBCO EMS])
if test -n "$with_tibco_ems"; then
   if test ! -e "$with_tibco_ems/clients/c/include/tibems/types.h"; then
      AC_MSG_ERROR([can't find clients/c/include/tibems/types.h in $with_tibco_ems])
   else
      AC_MSG_RESULT([$with_tibco_ems])
   fi
else
   if test -n "$JMS_ROOT" -a \( -f "$JMS_ROOT/clients/c/include/tibems/types.h" \) 2>/dev/null; then
      AC_MSG_RESULT([$JMS_ROOT])
      with_tibco_ems=$JMS_ROOT
   else
      AC_MSG_RESULT([not found])
      unset with_tibco_ems
   fi
fi

if test -n "$with_tibae"; then
   if test -z "$rv_found"; then
      AC_MSG_ERROR([TIBCO Adapters SDK and TRA found, but no Rendezvous found, disabling tibae support])
      unset with_tibae
   else
      AC_MSG_CHECKING([TIBCO Adapters SDK version])
      if test -e "$with_tibae"/prodinfo; then
	 TIBCO_SDK_VERSION=`grep SDK "$with_tibae"/prodinfo|head -1|cut -f2`
      elif test -e "$with_tibae"/version.txt; then
         TIBCO_SDK_VERSION=`grep SDK "$with_tibae"/version.txt|head -1|cut -b25- | cut -f1 -d\ `
      else
         AC_MSG_ERROR([unable to determine TIBCO Adapters SDK version, disabling tibae support])
         unset with_tibae
      fi

      if test -n "$TIBCO_SDK_VERSION"; then
         AC_MSG_RESULT($TIBCO_SDK_VERSION)
      fi
      # exit this structure otherwise the nesting gets too deep :-)
   fi
fi

if test -n "$with_tibae"; then
   # check if we need TPCL (third-party libraries)
   if test `echo $TIBCO_SDK_VERSION|cut -b1` -gt 4; then
      AC_ARG_WITH([tibae-tpcl],
        [AS_HELP_STRING([--with-tibae-tpcl@<:@=DIR@:>@],
		        [TIBCO Adpaters TPCL directory (defaults to $TPCL_ROOT)])],
			[if test ! -d "${with_tibae_tpcl}"; then AC_MSG_ERROR(bad value ${with_tibae_tpcl} for --with-tibae-tpcl); unset with_tibae_tpcl; fi])
      AC_MSG_CHECKING([TIBCO Adapters TPCL])
      if test -n "$with_tibae_tpcl"; then
	 if test ! -e "$with_tibae_tpcl/lib/libssl.a"; then
	    AC_MSG_ERROR([can't find libssl.a in $with_tibae_tpcl/lib, disabling tibae support])
	    unset with_tibae_tpcl
	    unset with_tibae
	 else
	    AC_MSG_RESULT([$with_tibae_tpcl])
	 fi
      else
	 if test -n "$TPCL_ROOT" -a -f "$TPCL_ROOT/lib/libssl.a"; then
	    AC_MSG_RESULT([$TPCL_ROOT])
	    with_tibae_tpcl=$TPCL_ROOT
	 else
	    AC_MSG_ERROR([not found, disabling tibae support])
	    unset with_tibae_tpcl
	    unset with_tibae
	 fi
      fi
   fi
fi

if test -z "$with_tibae" -o -z "$with_tibae_tpcl"; then
   AC_MSG_ERROR([])
fi

case "$TIBCO_SDK_VERSION" in
	4.1.2) TIBAE_LDFLAGS="-L${with_tibae}/lib -lmaverick41 -lpthread"
	       TIBAE_CPPFLAGS="-I${with_tibae}/include"
	       AC_DEFINE(TIBCO_SDK, 4, [define for TIBCO SDK 4.*])
	       ;;
	4.1.3) TIBAE_LDFLAGS="-L${with_tibae}/lib -lmaverick41 -lpthread"
	       TIBAE_CPPFLAGS="-I${with_tibae}/include"
	       AC_DEFINE(TIBCO_SDK, 4, [define for TIBCO SDK 4.*])
	       ;;
        5.0.*) TIBAE_LDFLAGS="-L${with_tibae}/lib -L${with_tibae_tpcl}/lib -lmaverick50 -lrepowww532 -lxerces-c2_1 -lssl -lcrypto -lpthread"
	       TIBAE_CPPFLAGS="-I${with_tibae}/include/sdk"
	       AC_DEFINE(TIBCO_SDK, 5, [define for TIBCO SDK 5.*])
	       ;;
        5.3.*) TIBAE_LDFLAGS="-L${with_tibae}/lib -L${with_tibae_tpcl}/lib -lmaverick53 -lrepowww532 -lxerces-c2_1 -lssl -lcrypto -licuuc -lpthread"
	       TIBAE_CPPFLAGS="-I${with_tibae}/include/sdk"
	       AC_DEFINE(TIBCO_SDK, 5, [define for TIBCO SDK 5.*])
	       ;;
        5.4.*) TIBAE_LDFLAGS="-L${with_tibae}/lib -L${with_tibae_tpcl}/lib -lmaverick53 -lrepowww532 -lxerces-c2_1 -lssl -lcrypto -licuuc -lpthread"
               TIBAE_CPPFLAGS="-I${with_tibae}/include"
               AC_DEFINE(TIBCO_SDK, 5, [define for TIBCO SDK 5.*])
               ;;
        5.5.*) if test -z "${with_tibco_ems}"; then AC_MSG_ERROR([SDK 5.5 requires TIBCO EMS, but TIBCO EMS was not found]); fi
	       if test "$enable_64bit" = "yes"; then
	          TIBAE_LDFLAGS="-L${with_tibae}/lib -L${with_tibae}/lib/64 -L${with_tibae_tpcl}/lib -L${with_tibae_tpcl}/lib/64 -lmaverick55${LIBSUFFIX} -lrepowww550${LIBSUFFIX} -lxerces-c2_7 -lxerces-depdom2_7 -lssl -lcrypto -licuuc -licudata -lpthread"
	       else
	          TIBAE_LDFLAGS="-L${with_tibae}/lib -L${with_tibae_tpcl}/lib -lmaverick55${LIBSUFFIX} -lrepowww550${LIBSUFFIX} -lxerces-c2_7 -lssl -lcrypto -licuuc -licudata -lpthread"
	       fi
               TIBAE_CPPFLAGS="-I${with_tibae}/include -I${with_tibae}/include/xercesc -I${with_tibco_ems}/clients/c/include"
               AC_DEFINE(TIBCO_SDK, 5, [define for TIBCO SDK 5.*])
               ;;
        5.8.*) if test -z "${with_tibco_ems}"; then AC_MSG_ERROR([SDK 5.8 requires TIBCO EMS, but TIBCO EMS was not found]); fi
	       if test "$enable_64bit" = "yes"; then
	          TIBAE_LDFLAGS="-L${with_tibae}/lib -L${with_tibae}/lib/64 -L${with_tibae_tpcl}/lib -L${with_tibae_tpcl}/lib/64 -lmaverick58${LIBSUFFIX} -ltibrv${LIBSUFFIX} -ltibrvcm${LIBSUFFIX} -ltibrvcmq${LIBSUFFIX} -ltibrvft${LIBSUFFIX} -ldl -lrepowww580${LIBSUFFIX} -lxerces-c2_8 -lssl -lcrypto -licuuc -lpthread"
	       else
	          TIBAE_LDFLAGS="-L${with_tibae}/lib -L${with_tibae_tpcl}/lib -lmaverick58${LIBSUFFIX}  -ltibrv${LIBSUFFIX} -ltibrvcm${LIBSUFFIX} -ltibrvcmq${LIBSUFFIX} -ltibrvft${LIBSUFFIX} -ldl -lrepowww580${LIBSUFFIX} -lxerces-c2_8 -lssl -lcrypto -licuuc -lpthread"
	       fi
               TIBAE_CPPFLAGS="-I${with_tibae}/include -I${with_tibae}/include/xercesc -I${with_tibco_ems}/clients/c/include -DLINUX24"
               AC_DEFINE(TIBCO_SDK, 5, [define for TIBCO SDK 5.*])
               ;;
	*)     AC_MSG_ERROR(Unsupported TIBCO SDK Version) 
	       ;;
esac

case "${host_os}" in
     *linux*)	TIBAE_CPPFLAGS="$TIBAE_CPPFLAGS -DLINUX24 -ldl"
		;;
     *hpux*)    TIBAE_CPPFLAGS="$TIBAE_CPPFLAGS -DHP_UX +DAportable"
		;;
     *)		TIBAE_CPPFLAGS="$TIBAE_CPPFLAGS -ldl"
		;; 
esac

# check if C++ compiler can link with TIBCO libs
SAVE_CPPFLAGS="$CPPFLAGS"
SAVE_LDFLAGS="$LDFLAGS"
CPPFLAGS="$CPPFLAGS $TIBAE_CPPFLAGS $TIBRV_CPPFLAGS"
LDFLAGS="$LDFLAGS $TIBAE_LDFLAGS $TIBRV_LDFLAGS"
AC_MSG_CHECKING([if we can link to the TIBCO AE SDK])
AC_LINK_IFELSE([AC_LANG_PROGRAM([[
#include <Maverick.h>
class TApp : public MApp
{
      virtual void onTermination() throw (MException) {}
      virtual void onInitialization() throw (MException) {}
   public:
      inline TApp(MAppProperties *pm) : MApp(pm) {}
};

	 ]],[[
TApp ma(NULL);
	]])], tibae_links=yes, tibae_links=no)

CPPFLAGS="$SAVE_CPPFLAGS"
LDFLAGS="$SAVE_LDFLAGS"

if test "$tibae_links" = "no"; then
   AC_MSG_ERROR([failed with this C++ compiler, try CXX=<comp> configure, disabling tibae support])
   unset with_tibae
else
   AC_MSG_RESULT([ok])
   AC_SUBST(TIBAE_LDFLAGS)
   AC_SUBST(TIBAE_CPPFLAGS)
   AC_DEFINE(TIBAE, 1, [Define if TIBCO Adapters support should be included])
   with_tibae=yes
fi

set_qore_cppflags() {
    QORE_INC_DIR=$1
    if test "$1" != "/usr/include"; then
        QORE_CPPFLAGS=-I$1
    fi
}

find_qore() {
    a="$1"
    if test \( "$a" = "/" -o -z "$a" \) -a -h "$a/lib${LIBSUFFIX}"; then
        a=/usr
    fi
    lib=$a/lib${LIBSUFFIX}

    # if we only want the static qore libraries
    if test -n "$qore_static"; then
        if test -f "$lib/libqore.a"; then
            QORE_LDFLAGS="$lib/libqore.a"
            AC_MSG_RESULT([$lib (forced static)])
        fi
    else
        if test -f "$lib/libqore.${SHLIB_SUFFIX}"; then
            if test "$lib" != "/lib" -a "$lib" != "/usr/lib"; then
                QORE_LDFLAGS="-L$lib"
            fi
            QORE_LDFLAGS="$QORE_LDFLAGS -lqore"
            AC_MSG_RESULT([$lib (shared)])
        elif test -f "$lib/libqore.a"; then
            if test "$lib" != "/lib" -a "$lib" != "/usr/lib"; then
                QORE_LDFLAGS="-L$lib"
            fi
            QORE_LDFLAGS="$QORE_LDFLAGS -lqore"
            AC_MSG_RESULT([$lib (static)])
        fi
    fi
    if test -z "$QORE_LDFLAGS"; then
        return
    fi

    AC_MSG_CHECKING([for qore include files])
    # try to find include files
    if test "$a" = "/"; then
        inc=/usr/include
    else
        inc=$a/include
    fi
    if test -f "$inc/qore/Qore.h"; then
        AC_MSG_RESULT([found: $inc])
        set_qore_cppflags $inc
    else
        AC_MSG_ERROR([not found])
    fi

    AC_SUBST(QORE_LDFLAGS)
    AC_SUBST(QORE_CPPFLAGS)
}

# see if we can figure out where the qore library is
AC_ARG_WITH([qore-dir],
  [AS_HELP_STRING([--with-qore-dir@<:@=DIR@:>@],
                  [Qore directory])],
  [if test ! -d "${with_qore_dir}"; then AC_MSG_ERROR(bad value ${with_qore_dir} for --with-qore-dir); unset with_qore_dir; fi],
  [with_qore_dir="$QORE_DIR"])

AC_MSG_CHECKING([for qore libraries and header files])
for dir in "${with_qore_dir}" "${with_lib_prefix}" "${find_prefix}" /usr / /usr/local /opt/gnu /opt/qore /usr/local/qore /opt/local /sw /usr/sfw /opt/sfw; do
    find_qore $dir
    if test -n "$QORE_LDFLAGS"; then
        break
    fi
done
if test -z "$QORE_LDFLAGS"; then
    AC_MSG_ERROR([no qore library found])
else
   # test qore version
   AC_MSG_CHECKING([qore library version])

   # get qore version code
   qvc=`grep QORE_VERSION_CODE $QORE_INC_DIR/qore/qore-version.h|cut -f3 -d\  2>/dev/null`

   # get qore version string
   qore_version=`grep QORE_VERSION.\" $QORE_INC_DIR/qore/qore-version.h|cut -f3 -d\ |sed s/\"//g 2>/dev/null`

   # if version code not present, may be qore 0.7.0 or earlier
   if test -z "$qvc"; then
      qv_major=`grep QORE_VERSION_MAJOR $QORE_INC_DIR/qore/qore-version.h|cut -f3 -d\  2>/dev/null`
      if test -z "$qv_major"; then
         AC_MSG_ERROR([cannot determine; check Qore header files in $QORE_INC_DIR])
      fi

      qv_minor=`grep QORE_VERSION_MINOR $QORE_INC_DIR/qore/qore-version.h|cut -f3 -d\  2>/dev/null`
      qv_sub=`grep QORE_VERSION_SUB $QORE_INC_DIR/qore/qore-version.h|cut -f3 -d\  2>/dev/null`

      if test "$qv_major" -gt 0; then
         qvc=`printf "%d%02d%02d" $qv_major $qv_minor $qv_sub`
      else
         qvc=`printf "%d%02d" $qv_major $qv_minor $qv_sub`
      fi
      AC_DEFINE_UNQUOTED([QORE_VERSION_CODE], $qvc, [define when missing in Qore headers])
   fi

   if test $qvc -lt 701; then
      AC_MSG_ERROR([found $qore_version; this module requires at least version 0.7.1])
   fi

   AC_MSG_RESULT([${qore_version} OK])

   MODULE_API=`qore --module-api`
   AC_SUBST(MODULE_API)

   if test -z "${prefix}" -o "${prefix}" = "NONE"; then
      libdir=`qore --module-dir`
   else
      libdir="$prefix/lib${LIBSUFFIX}/qore-modules"
      qlibdir=`qore --module-dir`
      if test "$libdir" != "$qlibdir"; then
         AC_MSG_WARN([warning, installed qore's module dir is $qlibdir, this module will be installed in $libdir])
      fi
   fi
fi

AC_ARG_ENABLE([profile],
     [AS_HELP_STRING([--enable-profile],
		     [turn on profiling support (default=no)])],
     [case "${enable_profile}" in
       yes|no) ;;
       *)      AC_MSG_ERROR(bad value ${enable_profile} for --enable-profile) ;;
      esac],
     [enable_profile=no])

AC_ARG_ENABLE([debug],
     [AS_HELP_STRING([--enable-debug],
		     [turn on debugging (default=no)])],
     [case "${enable_debug}" in
       yes|no) ;;
       *)      AC_MSG_ERROR(bad value ${enable_debug} for --enable-debug) ;;
      esac],
     [enable_debug=yes])

if test "${enable_debug}" = yes; then
   AC_DEFINE(DEBUG, 1, Define if debugging support should be included)
   # remove -O2 from CXXFLAGS so valgrind can report properly
   CXXFLAGS=`echo $CXXFLAGS | sed 's/\-O2//'`
else
   AC_DEFINE(NDEBUG, 1, Define if assert() declarations should be suppressed)
fi

if test "${enable_profile}" = yes; then
   AC_DEFINE(PROFILE, 1, Define if profiling support should be included)
fi

AC_ARG_ENABLE([optimization],
     [AS_HELP_STRING([--enable-optimization],
		     [turn on optimization (default=auto (yes unless debugging is enabled)])],
     [case "${enable_optimization}" in
       yes|no) ;;
       *)      AC_MSG_ERROR(bad value ${enable_optimization} for --enable-optimization) ;;
      esac],
     [enable_optimization=auto])

if test "$enable_optimization" = "auto"; then
   if test "${enable_debug}" = yes; then
      enable_optimization=no
   else
      enable_optimization=yes
   fi
fi

# check for gcc visibility support
AC_MSG_CHECKING([for gcc visibility support])
if test "$GXX" = "yes"; then
   gcc_version=`$CXX -dumpversion`
   if test "$gcc_version" \> "4"; then
      AC_DEFINE(HAVE_GCC_VISIBILITY, 1, if compiling with g++ and visibility support is available)
      AC_MSG_RESULT([yes, $CXX $gcc_version])
      # turn off strict aliasing for g++
      CXXFLAGS="$CXXFLAGS -fno-strict-aliasing"
   else
      AC_MSG_RESULT([no, gcc $gcc_version])
   fi
else
   AC_MSG_RESULT([no, $CXX])
fi

# Checks for typedefs, structures, and compiler characteristics.
AC_HEADER_STDBOOL
AC_C_CONST
AC_C_INLINE
AC_TYPE_PID_T
AC_TYPE_SIZE_T
AC_CHECK_MEMBERS([struct stat.st_blksize])
AC_STRUCT_ST_BLOCKS
AC_CHECK_MEMBERS([struct stat.st_rdev])
AC_HEADER_TIME
AC_STRUCT_TM
AC_C_VOLATILE

# turn on optimizations if we know how
if test "$enable_optimization" = "yes"; then
    if test "$GXX" = "yes"; then
        CXXFLAGS="$CXXFLAGS -O3"  # gcc
    elif test "$CXX" = "CC" -a "`echo $host_os|cut -b-7`" = "solaris"; then
        # remove -g with Solaris CC as it reduces optimization levels
	CXXFLAGS="`echo $CXXFLAGS| sed s/-g//` -xO5" # Solaris CC
    elif test -n "`echo $CXX|grep aCC`"; then 
        # remove -g with HP-UX aCC as it reduces optimization levels
	CXXFLAGS="`echo $CXXFLAGS| sed s/-g//` +O4" # HP-UX aCC
    fi
else
    if test "$GXX" = "yes"; then
        CXXFLAGS="`echo $CXXFLAGS| sed s/-O2//`"  # gcc
    fi
fi

# turn on some build flags for non-debugging, non-profiling builds
#if test "$enable_debug" = "no" -a "$enable_profile" = "no" -a "$enable_optimization" = "yes" ; then
    # we can no longer strip binaries and libraries with non-debugging, non-profiling builds on Darwin with -Wl,-x because it breaks linking :(
#fi

# turn on warnings if we know how
if test "$GXX" = "yes"; then
   CXXFLAGS="$CXXFLAGS -Wall"  # gcc
else
   if test "$solaris" = yes; then
      # turn on all warnings for the oracle sun studio compiler
      CXXFLAGS="$CXXFLAGS +w"
   fi
fi

AC_SUBST(OTHER_LIBS)

# save more version information in config.h
VERSION_MAJOR=`echo $PACKAGE_VERSION | cut -f3 -d\  | sed s/\"//g | cut -f1 -d.`
VERSION_MINOR=`echo $PACKAGE_VERSION | cut -f3 -d\  | sed s/\"//g | cut -f2 -d.`
VERSION_SUB=`echo $PACKAGE_VERSION | cut -f3 -d\  | sed s/\"//g | cut -f3 -d.`

# set version information
AC_DEFINE_UNQUOTED([VERSION_MAJOR], $VERSION_MAJOR, [major version number])
AC_DEFINE_UNQUOTED([VERSION_MINOR], $VERSION_MINOR, [minor version number])
AC_DEFINE_UNQUOTED([VERSION_SUB], $VERSION_SUB, [sub version number])
AC_DEFINE_UNQUOTED([TARGET_ARCH], "$ARCH", [host type])
AC_DEFINE_UNQUOTED([TARGET_OS], "$OS", [host type])
AC_DEFINE_UNQUOTED([TARGET_BITS], $bits, [32 or 64 bit build])

AM_CONDITIONAL([COND_DEBUG],      [test "$enable_debug" = yes])
AM_CONDITIONAL([COND_PROFILE],    [test "$enable_profile" = yes])
AM_CONDITIONAL([COND_SINGLE_COMPILATION_UNIT], [test "$enable_single_compilation_unit" = yes])

AC_CONFIG_FILES([Makefile src/Makefile])
AC_OUTPUT

echo "*** MODULE FEATURES ***"
printf "%-24s: %s %s" module "$OS" "$cpu_family"
if test "$enable_64bit" = "yes"; then
   printf " (64-bit)\n"
else
   printf " (32-bit)\n"
fi

show_library_feature() {
   printf "%-24s: " "$1"
   if test "$2" = "yes"; then
      printf "%-8s" yes
   else
      printf disabled
   fi
   if test -n "$3"; then
      printf " (%s)" $3
   fi
   echo
}

show_library_feature optimizations $enable_optimization
show_library_feature debug $enable_debug
show_library_feature profiling $enable_profile
