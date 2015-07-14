################################################################################
#
# File name: .cshrc
#
# Description:
#   This is a template for C shell setup.
#   This file is also compatible with tcsh.
#   This file is read whenever a new shell is spawned.
#   For changes in this file to take effect immediately in current session:
#     % source ~/.cshrc
#   For changes to take effect in all sessions, re-login is required.
#
################################################################################

set os = `/bin/uname -s`
switch ( "$os" )
    case "SunOS":
        # Set default search path
        set path = ( /bin /usr/bin /usr/sbin /usr/ucb /etc /usr/openwin/bin /usr/dt/bin )
        breaksw
    case "Linux":
        # Set default search paths
        set path=( /usr/sbin /sbin /usr/bin /bin /usr/local/sbin /usr/local/bin /usr/X11R6/bin . )
        breaksw
    case "AIX":
        # Set search paths
        set path=( /bin /usr/bin /usr/sbin /sbin /etc /usr/ucb /usr/bin/X11 /usr/local/bin . )
        breaksw
    default:
        /bin/echo "OS unknown."
        # Set search paths
        set path=( /bin /usr/bin /usr/sbin /etc /usr/local/bin . )
        breaksw
endsw

# Misc shell specific settings
umask 022


# Read alias definitions
if ( -f ~/.aliases) then
    # Define all sheel aliases in an external file, for example: ~/.aliases
    source ~/.aliases
endif


# Module setup
if ( -f /tools/arch/modulefiles/setup/modules.csh ) then
    source /tools/arch/modulefiles/setup/modules.csh
    # For help on module:
    # % module help
    # List available modules:
    # % module aval
    # Load frequently used module:
    # % module load platform/lsf/6.1
endif


# Exit csh if this is a non-interactive session
if ( $?USER == 0 || $?prompt == 0 ) exit

# Add additional customization for interactive session

set filec
set history=40

# CVS login
#setenv CVSROOT ":pserver:${USER}@alpha:/projects/svdc/jaguar/repository"

# Set default printer
#setenv PRINTER svdccp07

# Set default editor
setenv EDITOR /bin/vi

set host = `/bin/hostname -s`
switch ( "$host" )
	case "hcmlab-sw7":
		# Set Perforce 
		setenv P4CONFIG /AMCC/hule/p4/.p4settings
		setenv P4V_HOME '/tools/perforce/p4/v2012.1'
		set path=(${P4V_HOME}/bin /usr/local/sbin /usr/local/bin /usr/sbin /usr/bin /sbin /bin /etc ~/bin)
		#set grep
		setenv WORKDIR '/AMCC/hule'
		setenv pro '/AMCC/hule/p4/processor'
		setenv ref '/AMCC/hule/p4/refPlatforms'
		alias ccgrep 'find . -type f -print0 | xargs -0 -e grep --color=always -nH -e'
		alias ccgrep1 'find . -name \*.cpp -or -name \*.h -or -name \*.c | xargs grep --color=always -nrH -e'
		alias p4dir  'cd /AMCC/hule/p4'
		alias cgrep 'grep --color=always'
		alias cs 'cscope -b -q -k -R'
		alias cls 'clear'
		alias em 'emacs -nw'
		breaksw
	default:
        /bin/echo "HOST unknown."
        breaksw
endsw
echo "Setting-up environment DONE"
