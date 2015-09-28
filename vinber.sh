#!/usr/bin/env bash
# =============================================================================
# Vinber: The Unitex/GramLab Build Automation Service
# https://github.com/UnitexGramLab/vinber-backend
# =============================================================================
# Copyright (C) 2015 Université Paris-Est Marne-la-Vallée <unitex@univ-mlv.fr>
# 
# This program is free software; you can redistribute it and/or
# modify it under the terms of the GNU Lesser General Public
# License as published by the Free Software Foundation; either
# version 2.1 of the License, or (at your option) any later version.
# 
# This library is distributed in the hope that it will be useful,
# but WITHOUT ANY WARRANTY; without even the implied warranty of
# MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
# Lesser General Public License for more details.
# 
# You should have received a copy of the GNU Lesser General Public
# License along with this program; if not, write to the Free Software
# Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA.
#
# cristian.martinez@univ-paris-est.fr (martinec)
#
# =============================================================================
# Vinber is a lightweight build automation service (continuous integration +
# continuous delivery) used to produce the Unitex/GramLab project releases.
# =============================================================================
# Vinber code must be ShellCheck-compliant @see http://www.shellcheck.net/about.html
# for information about how to run ShellCheck locally
# e.g shellcheck -s bash vinber.sh
# =============================================================================
# This program is loosely based on a previous work by Sebastien Paumier 
# (paumier). The Unitex creator and former project maintainer.
# =============================================================================
UNITEX_BUILD_VINBER_VERSION="1.6.2"
UNITEX_BUILD_VINBER_CODENAME="Vinber"
UNITEX_BUILD_VINBER_DESCRIPTION="Unitex/GramLab Build Automation Service"
UNITEX_BUILD_VINBER_REPOSITORY_URL="https://github.com/UnitexGramLab/vinber-backend"
# =============================================================================
# Minimal Bash version
UNITEX_BUILD_MINIMAL_BASH_VERSION_STRING="4.2.0"
UNITEX_BUILD_MINIMAL_BASH_VERSION_NUMBER=$((4 * 100000 + 2 * 1000 + 0))
# =============================================================================
# Script name
SCRIPT_NAME=${0##*/}
# Script base directory
# This snippet is from @source http://stackoverflow.com/a/246128
SCRIPT_BASEDIR=$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )
# Script file including the normalized path
SCRIPT_FILE="$SCRIPT_BASEDIR/$SCRIPT_NAME"
# Time of last modification of this script
SCRIPT_TIMESTAMP=$(stat -c %y "$SCRIPT_FILE")
# =============================================================================
# shellcheck disable=SC2034
UNITEX_BUILD_SIGNAL_INT=INT
# shellcheck disable=SC2034
UNITEX_BUILD_SIGNAL_QUIT=QUIT
# shellcheck disable=SC2034
UNITEX_BUILD_SIGNAL_TERM=TERM
# shellcheck disable=SC2034
UNITEX_BUILD_SIGNAL_EXIT=EXIT
# =============================================================================
UNITEX_BUILD_NOT_DEFINED="not-defined"
UNITEX_BUILD_UNTRACED="untraced"
# =============================================================================
UNITEX_BUILD_STATUS_FAILED="failed"
UNITEX_BUILD_STATUS_PASSED="passed"
UNITEX_BUILD_STATUS_UNKNOWN="unknown"
UNITEX_BUILD_STATUS_ERROR="error"
UNITEX_BUILD_STATUS_INACC="inaccessible"
# =============================================================================
UNITEX_BUILD_PREVIOUS_STATUS="$UNITEX_BUILD_STATUS_UNKNOWN"
# =============================================================================
# Reset in case getopts has been used previously in the shell
# This is from @source http://bash.cumulonim.biz/BashFAQ%282f%29035.html
OPTIND=1
# =============================================================================
UNITEX_BUILD_VINBER_CODENAME_LOWERCASE="${UNITEX_BUILD_VINBER_CODENAME,,}"
# =============================================================================
UNITEX_BUILDER_NAME=$UNITEX_BUILD_VINBER_CODENAME
UNITEX_BUILD_CURRENT_STAGE=$UNITEX_BUILDER_NAME
UNITEX_BUILD_PREVIOUS_STAGE=""
# =============================================================================
# Default command line variables
UNITEX_BUILD_VERBOSITY=1
UNITEX_BUILD_VERBOSITY_LEVELS='^[0-7]$'
UNITEX_BUILD_CONFIG_FILENAME="$UNITEX_BUILD_VINBER_CODENAME_LOWERCASE.conf"
UNITEX_BUILD_CONFIG_TEMPLATE_FILENAME="$UNITEX_BUILD_VINBER_CODENAME_LOWERCASE.conf.in"
# =============================================================================
UNITEX_BUILD_DEPS_FILENAME="$UNITEX_BUILD_VINBER_CODENAME_LOWERCASE.deps"
UNITEX_BUILD_AUTHORS_FILENAME="$UNITEX_BUILD_VINBER_CODENAME_LOWERCASE.commit.authors"
# =============================================================================
# Unitex/GramLab
# =============================================================================
#!UNITEX_TYPE="Project"
#!UNITEX_KEYWORDS="NPL,RTN"
UNITEX_LICENSE="LGPL-2.1"
UNITEX_PACKAGE_NAME="Unitex-GramLab"
UNITEX_PRETTYAPPNAME="Unitex/GramLab"
UNITEX_COPYRIGHT_HOLDER="Universite Paris-Est Marne-la-Vallee"
UNITEX_SHORTDESCRIPTION="corpus processing suite"
UNITEX_DESCRIPTION="an open source, cross-platform, multilingual, lexicon- and grammar-based $UNITEX_SHORTDESCRIPTION"
UNITEX_VER_MAJOR=3
UNITEX_VER_MINOR=1
UNITEX_VER_SUFFIX=beta
# =============================================================================
# Unitex/GramLab related URLs
# =============================================================================
UNITEX_DOMAIN_NAME="unitexgramlab.org"
UNITEX_HOMEPAGE_URL="http://$UNITEX_DOMAIN_NAME"
UNITEX_RELEASES_URL="http://unitex.univ-mlv.fr/releases"
UNITEX_SOURCE_URL="https://github.com/UnitexGramLab"
#!UNITEX_ABOUT_URL="$UNITEX_HOMEPAGE_URL/index.php?page=1"
#!UNITEX_UPDATE_URL="$UNITEX_HOMEPAGE_URL/index.php?page=3"
UNITEX_BUG_URL="$UNITEX_HOMEPAGE_URL/index.php?page=6"
#!UNITEX_LGPL_LR_URL="http://bit.do/LGPL-LR" 
#!UNITEX_LGPL_URL="http://www.gnu.org/licenses/lgpl.html"
UNITEX_FORUM_URL="http://forum.$UNITEX_DOMAIN_NAME"
UNITEX_DOCS_URL="http://docs.$UNITEX_DOMAIN_NAME"
UNITEX_GOVERNANCE_URL="$UNITEX_SOURCE_URL/unitex-governance"
UNITEX_BUILD_DEPLOYMENT_DESTINATION="/mnt/pantheon/sdb1/unitex/W3" # Website local path
UNITEX_WEBSITE_URL="http://unitex.univ-mlv.fr"           # Website URL
# =============================================================================
UNITEX_BUILD_SVN_LOG_LIMIT=100
UNITEX_BUILD_MINGW32_COMMAND_PREFIX="mingw32-"
UNITEX_BUILD_MINGW64_COMMAND_PREFIX="x86_64-w64-mingw32-"
# =============================================================================
UNITEX_BUILD_VINBER_BACKEND_UPDATE=0
UNITEX_BUILD_DOCS_UPDATE=0
UNITEX_BUILD_PACK_UPDATE=0
UNITEX_BUILD_LING_UPDATE=0
UNITEX_BUILD_CLASSIC_IDE_UPDATE=0
UNITEX_BUILD_GRAMLAB_IDE_UPDATE=0
UNITEX_BUILD_LOGS_UPDATE=0
UNITEX_BUILD_CORE_UPDATE=0
# =============================================================================
UNITEX_BUILD_VINBER_BACKEND_FORCE_UPDATE=0
UNITEX_BUILD_DOCS_FORCE_UPDATE=0
UNITEX_BUILD_PACK_FORCE_UPDATE=0
UNITEX_BUILD_LING_FORCE_UPDATE=0
UNITEX_BUILD_CLASSIC_IDE_FORCE_UPDATE=0
UNITEX_BUILD_GRAMLAB_IDE_FORCE_UPDATE=0
UNITEX_BUILD_LOGS_FORCE_UPDATE=0
UNITEX_BUILD_CORE_FORCE_UPDATE=0
# =============================================================================
UNITEX_BUILD_FORCE_UPDATE=0
# =============================================================================
UNITEX_BUILD_VINBER_BACKEND_HAS_ERRORS=0
UNITEX_BUILD_DOCS_HAS_ERRORS=0
UNITEX_BUILD_PACK_HAS_ERRORS=0
UNITEX_BUILD_LING_HAS_ERRORS=0
UNITEX_BUILD_CLASSIC_IDE_HAS_ERRORS=0
UNITEX_BUILD_GRAMLAB_IDE_HAS_ERRORS=0
UNITEX_BUILD_LOGS_HAS_ERRORS=0
UNITEX_BUILD_CORE_HAS_ERRORS=0
# =============================================================================
UNITEX_BUILD_DOCS_DEPLOYMENT=0
UNITEX_BUILD_PACK_DEPLOYMENT=0
UNITEX_BUILD_LING_DEPLOYMENT=0
UNITEX_BUILD_CLASSIC_IDE_DEPLOYMENT=0
UNITEX_BUILD_GRAMLAB_IDE_DEPLOYMENT=0
#!UNITEX_BUILD_LOGS_DEPLOYMENT=0
UNITEX_BUILD_CORE_DEPLOYMENT=0
# =============================================================================
UNITEX_BUILD_DOCS_FORCE_DEPLOYMENT=0
UNITEX_BUILD_PACK_FORCE_DEPLOYMENT=0
UNITEX_BUILD_LING_FORCE_DEPLOYMENT=0
UNITEX_BUILD_CLASSIC_IDE_FORCE_DEPLOYMENT=0
UNITEX_BUILD_GRAMLAB_IDE_FORCE_DEPLOYMENT=0
#!UNITEX_BUILD_LOGS_FORCE_DEPLOYMENT=0
UNITEX_BUILD_CORE_FORCE_DEPLOYMENT=0
# =============================================================================
#UNITEX_BUILD_DOCS_DIST=0
#UNITEX_BUILD_PACK_DIST=0
#UNITEX_BUILD_LING_DIST=0
#UNITEX_BUILD_CLASSIC_IDE_DIST=0
#UNITEX_BUILD_GRAMLAB_IDE_DIST=0
##!UNITEX_BUILD_LOGS_DIST=0
#UNITEX_BUILD_CORE_DIST=0
# =============================================================================
#UNITEX_BUILD_DOCS_FORCE_DIST=0
#UNITEX_BUILD_PACK_FORCE_DIST=0
#UNITEX_BUILD_LING_FORCE_DIST=0
#UNITEX_BUILD_CLASSIC_IDE_FORCE_DIST=0
#UNITEX_BUILD_GRAMLAB_IDE_FORCE_DIST=0
##!UNITEX_BUILD_LOGS_FORCE_DIST=0
#UNITEX_BUILD_CORE_FORCE_DIST=0
# =============================================================================
UNITEX_BUILD_TEST_ONLY_DEPLOYMENT=1
# =============================================================================
UNITEX_BUILD_FORCE_DEPLOYMENT=0
# =============================================================================
UNITEX_BUILD_SKIP_STAGE_VINBER_BACKEND=0
UNITEX_BUILD_SKIP_STAGE_DOCS=0
UNITEX_BUILD_SKIP_STAGE_PACK=0
UNITEX_BUILD_SKIP_STAGE_LING=0
UNITEX_BUILD_SKIP_STAGE_CLASSIC_IDE=0
UNITEX_BUILD_SKIP_STAGE_GRAMLAB_IDE=0
UNITEX_BUILD_SKIP_STAGE_LOGS=0
UNITEX_BUILD_SKIP_STAGE_CORE=0
# =============================================================================
UNITEX_BUILD_SKIP_DEPLOYMENT=0
UNITEX_BUILD_SKIP_ULP_TESTS=0
UNITEX_BUILD_SKIP_ULP_VALGRIND_TESTS=0
# =============================================================================
UNITEX_BUILD_BUNDLE_NAME="nightly"
UNITEX_BUILD_LATEST_NAME="latest"
# =============================================================================
UNITEX_BUILD_COMMAND_EXECUTION_ERROR_COUNT=0
UNITEX_BUILD_COMMAND_EXECUTION_COUNT=0
UNITEX_BUILD_FINISH_WITH_ERROR_COUNT=0
# =============================================================================
# shellcheck disable=SC2034
UNITEX_BUILD_CURRENT_STDOUT=/dev/stdout
# shellcheck disable=SC2034
UNITEX_BUILD_PREVIOUS_STDOUT=/dev/stdout
# =============================================================================
# shellcheck disable=SC2034
UNITEX_BUILD_CURRENT_STDERR=/dev/stderr
# shellcheck disable=SC2034
UNITEX_BUILD_PREVIOUS_STDERR=/dev/stderr
# =============================================================================
UNITEX_BUILD_SEND_LOG_FILE_ATTACHMENT=0
UNITEX_BUILD_SEND_ZIPPED_LOG_WORKSPACE_ATTACHMENT=0
# =============================================================================
# There are four types of notification recipients:
#
# 1. The development list  (UNITEX_BUILD_DEVEL_LIST)
# 2. The extra recipients  (UNITEX_BUILD_EXTRA_RECIPIENTS)
# 3. The last committer    (UNITEX_BUILD_LAST_ACTION_AUTHOR_EMAIL)
# 4. The Vinber maintainer (UNITEX_BUILD_VINBER_MAINTAINER_EMAIL)
#
# By default #2 and #3 are empty (we use "$UNITEX_BUILD_NOT_DEFINED" to symbolize that)
# Recipients in category #2 are supposed to be passed within the configuration
# Last committer email is update for each svn_info or git_info call
# The development list will be always in CC, except if EXTRA_RECIPIENTS and 
# LAST_COMMITTER are also assigned to development list
# If neither extra recipients nor last committer are assigned the message will be
# only addressed to the vinber maintainer
#
# The priority choosing the main recipient will be:
#                                                        
# EXTRA_RECIPIENTS ?
#   SUCESS TO=EXTRA_RECIPIENTS  CC=DEVEL_LIST
#   FAIL   TO=EXTRA_RECIPIENTS  CC=DEVEL_LIST
#   FIXED  TO=EXTRA_RECIPIENTS  CC=DEVEL_LIST
# LAST_COMMITTER  ?
#   SUCESS TO=(NONE)            CC=(NONE)
#   FAIL   TO=LAST_COMMITTER    CC=DEVEL_LIST
#   FIXED  TO=LAST_COMMITTER    CC=DEVEL_LIST
# NO EXTRA_RECIPIENTS, NO LAST_COMMITTER
#   SUCESS TO=(NONE)            CC=(NONE)
#   FAIL   TO=VINBER_MAINTAINER CC=(NONE)
#   FIXED  TO=(NONE)            CC=(NONE)
# =============================================================================
UNITEX_BUILD_DEVEL_LIST="unitex-devel@univ-mlv.fr"
UNITEX_BUILD_NOTIFY_DEVEL_LIST=1
# =============================================================================
UNITEX_BUILD_EXTRA_RECIPIENTS="$UNITEX_BUILD_NOT_DEFINED"
UNITEX_BUILD_NOTIFY_EXTRA_RECIPIENTS=1
# =============================================================================
UNITEX_BUILD_NOTIFY_LAST_COMMITTER=1
# =============================================================================
UNITEX_BUILD_VINBER_MAINTAINER_EMAIL="cristian.martinez@univ-paris-est.fr"
UNITEX_BUILD_NOTIFY_MAINTAINER=1
# =============================================================================
UNITEX_BUILD_NOTIFY_ON_SUCESS=0
UNITEX_BUILD_NOTIFY_ON_FAILURE=1
UNITEX_BUILD_NOTIFY_ON_FIXED=1
# =============================================================================
UNITEX_BUILD_SERVICE_GITTER_NOTIFICATIONS=0
UNITEX_BUILD_SERVICE_GITTER_WEBHOOK_URL="https://webhooks.gitter.im/e"
# =============================================================================
# Hold a list of used repositories
declare -A VINBER_BUILD_REPOSITORIES
VINBER_BUILD_REPOSITORIES[$UNITEX_BUILD_NOT_DEFINED]=$(echo -ne\
             "$UNITEX_BUILD_NOT_DEFINED\n" \
             "$UNITEX_BUILD_NOT_DEFINED\n" \
             "$UNITEX_BUILD_NOT_DEFINED\n" \
             "1970-01-01 00:00:00 UTC\n"   \
             "$UNITEX_BUILD_NOT_DEFINED\n" \
             "$UNITEX_BUILD_NOT_DEFINED\n" \
             "$UNITEX_BUILD_NOT_DEFINED\n" \
             "$UNITEX_BUILD_NOT_DEFINED\n" \
             "$UNITEX_BUILD_NOT_DEFINED\n" \
             "$UNITEX_BUILD_NOT_DEFINED\n" \
  | sed -e 's:^\s*:: ; s|^\(../\)*||g' )
# =============================================================================
VINBER_BUILD_REPOSITORY=1
#VINBER_BUILD_REVISION=2
VINBER_BUILD_AUTHOR=3
VINBER_BUILD_DATE=4
VINBER_BUILD_MESSAGE=5
VINBER_BUILD_AUTHOR_EMAIL=6
VINBER_BUILD_AUTHOR_NAME=7
VINBER_BUILD_REPOSITORY_URL=8
VINBER_BUILD_REPOSITORY_TYPE=9
VINBER_BUILD_COMMIT=10
# =============================================================================
VINBER_BUILD_REPOSITORIES_ARRAY_SIZE=10
# =============================================================================
# Active repository when first issue was detected
UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY="$UNITEX_BUILD_NOT_DEFINED"
# Active repository when latest issue was detected
UNITEX_BUILD_LOG_LATEST_ISSUE_REPOSITORY="$UNITEX_BUILD_NOT_DEFINED"
# The latest changed repository 
UNITEX_BUILD_LATEST_CHANGED_REPOSITORY="$UNITEX_BUILD_NOT_DEFINED"
# Last action repository
UNITEX_BUILD_LAST_ACTION_REPOSITORY="$UNITEX_BUILD_NOT_DEFINED"
# =============================================================================
UNITEX_BUILD_GLOBAL_DEPLOYMENT=0
#UNITEX_BUILD_PROGRAMS_DEPLOYMENT=0
# =============================================================================
UNITEX_BUILD_SOURCE_HOME="src"
UNITEX_BUILD_DIST_HOME="dist"
UNITEX_BUILD_TIMESTAMP_HOME="timestamp"
UNITEX_BUILD_VINBER_HOME_NAME="v6"
UNITEX_BUILD_VINBER_BUNDLE_HOME_NAME="bundle"
UNITEX_BUILD_VINBER_BUILD_HOME_NAME="build"
UNITEX_BUILD_VINBER_BUILDS_LOG_NAME="builds"
# =============================================================================
UNITEX_BUILD_RELEASES_HOME_NAME="releases"
UNITEX_BUILD_RELEASES_SOURCE_HOME_NAME="source"
UNITEX_BUILD_RELEASES_LING_HOME_NAME="lingua"
UNITEX_BUILD_RELEASES_CHANGES_HOME_NAME="changes"
UNITEX_BUILD_RELEASES_MAN_HOME_NAME="man"
UNITEX_BUILD_RELEASES_WIN32_HOME_NAME="win32"
UNITEX_BUILD_RELEASES_WIN64_HOME_NAME="win64"
UNITEX_BUILD_RELEASES_OSX_HOME_NAME="osx"
UNITEX_BUILD_RELEASES_LINUX_I686_HOME_NAME="linux-i686"
UNITEX_BUILD_RELEASES_LINUX_X86_64_HOME_NAME="linux-x86_64"
UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME="platform"
# =============================================================================
UNITEX_BUILD_PACKAGE_APP_SUFFIX="-application"
UNITEX_BUILD_PACKAGE_SOURCE_SUFFIX="-source"
UNITEX_BUILD_PACKAGE_SOURCE_DISTRIBUTION_SUFFIX="-source-distribution"
UNITEX_BUILD_PACKAGE_MAN_SUFFIX="-usermanual"
UNITEX_BUILD_PACKAGE_SETUP_SUFFIX="-setup"
UNITEX_BUILD_PACKAGE_SETUP_WIN32_TAG="_$UNITEX_BUILD_RELEASES_WIN32_HOME_NAME"
UNITEX_BUILD_PACKAGE_SETUP_WIN64_TAG="_$UNITEX_BUILD_RELEASES_WIN64_HOME_NAME"
UNITEX_BUILD_PACKAGE_OSX_SUFFIX="-$UNITEX_BUILD_RELEASES_OSX_HOME_NAME"
UNITEX_BUILD_PACKAGE_LINUX_I686_SUFFIX="-$UNITEX_BUILD_RELEASES_LINUX_I686_HOME_NAME"
UNITEX_BUILD_PACKAGE_LINUX_X86_64_SUFFIX="-$UNITEX_BUILD_RELEASES_LINUX_X86_64_HOME_NAME"
# =============================================================================
UNITEX_RELEASES_LATEST_BETA="$UNITEX_RELEASES_URL/$UNITEX_BUILD_LATEST_NAME-beta"
UNITEX_RELEASES_LATEST_BETA_WIN32_URL="$UNITEX_RELEASES_LATEST_BETA/$UNITEX_BUILD_RELEASES_WIN32_HOME_NAME"
UNITEX_RELEASES_LATEST_BETA_SOURCE_URL="$UNITEX_RELEASES_LATEST_BETA/$UNITEX_BUILD_RELEASES_SOURCE_HOME_NAME"
# =============================================================================
#! UNITEX_BUILD_VINBER_HOME_PATH="$SCRIPT_BASEDIR/$UNITEX_BUILD_VINBER_HOME_NAME"
#! UNITEX_BUILD_VINBER_BUNDLE_HOME_PATH="$SCRIPT_BASEDIR/$UNITEX_BUILD_VINBER_BUNDLE_HOME_NAME"
# =============================================================================
UNITEX_BUILD_LOG_FILE_EXT="log"
# =============================================================================
UNITEX_BUILD_LOG_JSON_EXT="json"
UNITEX_BUILD_LOG_JSON_VINBER_DATA_KEY="aaData"
UNITEX_BUILD_LOG_JSON_VINBER_BUILD_KEY="oBuild"
# =============================================================================
UNITEX_BUILD_LOG_FIRST_ISSUE_NUMBER=0
UNITEX_BUILD_LOG_FIRST_ISSUE_TYPE="$UNITEX_BUILD_NOT_DEFINED"
UNITEX_BUILD_LOG_FIRST_ISSUE_MESSAGE="$UNITEX_BUILD_NOT_DEFINED"
UNITEX_BUILD_LOG_FIRST_ISSUE_DESCRIPTION="$UNITEX_BUILD_NOT_DEFINED"
UNITEX_BUILD_LOG_LAST_ISSUE_NUMBER=0
UNITEX_BUILD_LOG_LAST_ISSUE_TYPE="$UNITEX_BUILD_NOT_DEFINED"
UNITEX_BUILD_LOG_LAST_ISSUE_MESSAGE="$UNITEX_BUILD_NOT_DEFINED"
UNITEX_BUILD_LOG_LAST_ISSUE_DESCRIPTION="$UNITEX_BUILD_NOT_DEFINED"
# =============================================================================
# Hold a list of languages supported by Unitex
# Codes are produced using the ISO 639-3 code tables in combination
# with the ISO 3166-1 alpha-2 country code to represent a language
# belonging to a specific country or region
# @see http://www-01.sil.org/iso639-3/codes.asp
# @see http://en.wikipedia.org/wiki/ISO_3166-1_alpha-2
declare -A ISO639_3_LANGUAGES=(                        \
            ["Arabic"]="ara"                           \
            ["English"]="eng"                          \
            ["Finnish"]="fin"                          \
            ["French"]="fra"                           \
            ["Georgian (Ancient)"]="kat"               \
            ["German"]="deu"                           \
            ["Greek (Ancient)"]="grc"                  \
            ["Greek (Modern)"]="ell"                   \
            ["Italian"]="ita"                          \
            ["Korean"]="kor"                           \
            ["Latin"]="lat"                            \
            ["Malagasy"]="mlg"                         \
            ["Norwegian (Bokmal)"]="nob"               \
            ["Norwegian (Nynorsk)"]="nno"              \
            ["Polish"]="pol"                           \
            ["Portuguese (Brazil)"]="por-br"           \
            ["Portuguese (Portugal)"]="por-pt"         \
            ["Russian"]="rus"                          \
            ["Serbian-Cyrillic"]="srp"                 \
            ["Serbian-Latin"]="rsb"                    \
            ["Spanish"]="spa"                          \
            ["Thai"]="tha"                             \
            ["XAlign"]="zxx"                           \
)
# =============================================================================
UNITEX_BUILD_LOG_LEVEL_COUNTER=(0 0 0 0 0 0 0 0)
UNITEX_BUILD_LOG_MESSAGE_COUNT=0
# =============================================================================
UNITEX_BUILD_LOG_LEVEL_ALIAS=("%%" "II" "!!" "WW" "EE" "CC" "^^" "@@" "")
UNITEX_BUILD_LOG_LEVEL_NAME=("Debug" "Information" "Notice" "Warning" \
                             "Error" "Critical" "Alert"  "Panic" "")

# UNITEX_BUILD_LOG_FORMAT
# printf format string format for printing info in log files       
# 1 : log message level : !!, II, WW, EE, ??                       -b1-4
# 2 : stage name : User Manual, Core Components, IDE Java ...      -b6-20
# 3 : action                                                       -b23-43
# 4 : description                                                  -b44-
#                            1       2      3     4
UNITEX_BUILD_LOG_FORMAT="(%.2s) [%-13s]  %-20s : %s\n"
#                        1    4 6    20  23  44

# seconds since 1970-01-01 00:00:00 UTC
START_SECONDS=$(date +%s)

# Start date timestamp        : e.g. Fri Mar 22 00:10:29 CET 2013
TIMESTAMP_START_C="$(date -d now)"

# Start short date timestamp  : e.g. 2013-03-22-00-10-29
TIMESTAMP_START_S=$(date +"%Y-%m-%d-%H-%M-%S")

# Start Timestamp             : e.g. 2013-03-22 00:10:29 +0200
TIMESTAMP_START_A=$(date +"%F %T %z")

# Finish Timestamp            : e.g. 2013-03-22 00:10:29 +0200
TIMESTAMP_FINISH_A=

# Total build elapsed time
TOTAL_ELAPSED_TIME=

# =============================================================================
# Logger levels e.g. log_[level_name] "action" "details"
# =============================================================================
# 0. (%%) [debug]       a debug message
# 1. (II) [info]rmation a purely informational message
# 2. (!!) [notice]      a normal but significant condition
# 3. (WW) [warning]     warning condition
# 4. (EE) [error]       error condition
# 5. (CC) [critical]    critical condition
# 6. (^^) [alert]       action must be taken immediately
# 7. (@@) [panic]       unusable condition
# 8                     not a logging message
# =============================================================================
# debug log          
log_debug()    { log 0  "${UNITEX_BUILD_LOG_LEVEL_ALIAS[0]}" "$1" "$2"; }

# information log
log_info()     { log 1  "${UNITEX_BUILD_LOG_LEVEL_ALIAS[1]}" "$1" "$2"; }

# notice log
log_notice()   { log 2  "${UNITEX_BUILD_LOG_LEVEL_ALIAS[2]}" "$1" "$2"; }

# warning log
log_warn()     { log 3  "${UNITEX_BUILD_LOG_LEVEL_ALIAS[3]}" "$1" "$2"; }

# error log          
log_error()    { log 4  "${UNITEX_BUILD_LOG_LEVEL_ALIAS[4]}" "$1" "$2"; }

# critical log       
log_critical() { log 5  "${UNITEX_BUILD_LOG_LEVEL_ALIAS[5]}" "$1" "$2"; }

# alert log          
log_alert()    { log 6  "${UNITEX_BUILD_LOG_LEVEL_ALIAS[6]}" "$1" "$2"; }

# panic log          
log_panic()    { log 7  "${UNITEX_BUILD_LOG_LEVEL_ALIAS[7]}" "$1" "$2"; }

# none log          
log_none()     { log 8  "${UNITEX_BUILD_LOG_LEVEL_ALIAS[8]}" "$1" ""  ; }

# main logging function
# avoid call this function directly, use instead :
# log_[level] "message" "description"
# 1:LEVEL, 2:ALIAS, 3:MESSAGE, 4:DESCRIPTION
function log() { 
  if [ "$1" -ge ${UNITEX_BUILD_VERBOSITY} -a "$1" -le 7 ]; then
    # Increment log level counter
    (( UNITEX_BUILD_LOG_LEVEL_COUNTER[$1]++ ))
    # If the Unitex Build Log File has not been created yet or it's empty we
    # put the log entry directly to the STDOUT
    if [ ! -e "$UNITEX_BUILD_LOG_FILE" -o ! -s "$UNITEX_BUILD_LOG_FILE" ]; then
    {
      # shellcheck disable=SC2059
      printf "$UNITEX_BUILD_LOG_FORMAT" "$2" "$UNITEX_BUILD_CURRENT_STAGE" \
             "$3" "$4"
    } >&3    
    else
      # Increment the number of logged messages
      (( UNITEX_BUILD_LOG_MESSAGE_COUNT++ )) 
      # If it's an error message 
      if [ "$1" -ge 3 -a "$1" -le 7 ]; then
         # Save once the related information of the first issue encountered
         if [ $UNITEX_BUILD_LOG_FIRST_ISSUE_NUMBER -eq 0 ]; then
          UNITEX_BUILD_LOG_FIRST_ISSUE_NUMBER=$UNITEX_BUILD_LOG_MESSAGE_COUNT
          UNITEX_BUILD_LOG_FIRST_ISSUE_TYPE="${UNITEX_BUILD_LOG_LEVEL_NAME[$1]}"
          UNITEX_BUILD_LOG_FIRST_ISSUE_MESSAGE="$3"
          UNITEX_BUILD_LOG_FIRST_ISSUE_DESCRIPTION="$4"
          UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY="$UNITEX_BUILD_LAST_ACTION_REPOSITORY"
         fi
         # Save the related information of the last issue encountered
         UNITEX_BUILD_LOG_LAST_ISSUE_NUMBER=$UNITEX_BUILD_LOG_MESSAGE_COUNT
         UNITEX_BUILD_LOG_LAST_ISSUE_TYPE="${UNITEX_BUILD_LOG_LEVEL_NAME[$1]}"
         UNITEX_BUILD_LOG_LAST_ISSUE_MESSAGE="$3"
         UNITEX_BUILD_LOG_LAST_ISSUE_DESCRIPTION="$4"
         # Update the latest issue repository only when needed
         if [[ "$UNITEX_BUILD_LAST_ACTION_REPOSITORY" != \
               "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_LATEST_ISSUE_REPOSITORY" $VINBER_BUILD_REPOSITORY)" ]]; then
                UNITEX_BUILD_LOG_LATEST_ISSUE_REPOSITORY="$UNITEX_BUILD_LAST_ACTION_REPOSITORY"
         fi
      fi        
      # .log
      # Replace
      # 1. UNITEX_BUILD_DEPLOYMENT_DESTINATION(/mnt/pantheon/sdb1/unitex/W3)
      #    UNITEX_WEBSITE_URL(http://unitex.univ-mlv.fr)
      #
      # 2. UNITEX_BUILD_RELEASES_DIR(/mnt/pantheon/unitex/compile/build/Unitex-GramLab/nightly/releases)
      #    UNITEX_WEBSITE_URL(http://unitex.univ-mlv.fr/build/nightly/releases)
      #
      # 3. UNITEX_BUILD_LOG_WORKSPACE(/mnt/pantheon/unitex/compile/v6/bundle/nightly/build/2015-04-06-21-34-48)
      #    ""
      #
      # 4. UNITEX_BUILD_LOGGER_PATH(/mnt/pantheon/unitex/compile/v6/bundle/nightly/build')
      #    UNITEX_BUILD_LOGGER_WEB_HOME(http://unitex.univ-mlv.fr/v6/bundle/nightly/build)
      #
      # 5. UNITEX_BUILD_BASEDIR(/mnt/pantheon/unitex/compile/build)
      #    ""
      {
       # shellcheck disable=SC2059 
       printf "$UNITEX_BUILD_LOG_FORMAT" "$2" "$UNITEX_BUILD_CURRENT_STAGE"\
              "$3" "$4"
      } | sed -e "s|$UNITEX_BUILD_DEPLOYMENT_DESTINATION|$UNITEX_WEBSITE_URL|g" \
        | sed -e "s|$UNITEX_BUILD_RELEASES_BASEDIR|$UNITEX_WEBSITE_URL/$UNITEX_BUILD_VINBER_BUILD_HOME_NAME/$UNITEX_BUILD_BUNDLE_NAME/$UNITEX_BUILD_RELEASES_HOME_NAME|g"   \
        | sed -e "s|$UNITEX_BUILD_LOG_WORKSPACE/||g" \
        | sed -e "s|$UNITEX_BUILD_LOGGER_PATH|$UNITEX_BUILD_LOGGER_WEB_HOME|g" \
        | sed -e "s|$UNITEX_BUILD_BASEDIR/||g" \
        | tee -a "$UNITEX_BUILD_LOG_FILE" >&3
      # .json
      {
       # shellcheck disable=SC2005 
       echo "$(json_printf "$1" "$UNITEX_BUILD_LOG_MESSAGE_COUNT" \
                          "$UNITEX_BUILD_CURRENT_STAGE" "$3" "$4")"
      } >> "$UNITEX_BUILD_LOG_JSON"
    fi
  # log_none messages are not formatted, we send them directly to the STDOUT!
  elif [ "$1" -eq 8 ]; then
    echo "$3" >&3
  fi
}

# =============================================================================
# JSON escape
# Attention this function doesn't handle unicode escapes
function json_escape() {
    local json_string="$*"
    local -r json_escaped_string=$(echo -nE "$json_string" |\
                                sed "s:\([\"\f\n\r\t\v\\]\):\\\\\1:g")
    echo "$json_escaped_string"  
}

# =============================================================================
# JSON message formatter
# Never directly call this function
# ARGS= $1:LEVEL, $2:MESSAGE_NUMBER, $3:CURRENT_STAGE, $4:MESSAGE, $5:DESCRIPTION
function json_printf() {
  local message_level="${UNITEX_BUILD_LOG_LEVEL_NAME[$1]}"
  local message_number="$2"
  local -r message_stage=$(json_escape "$3")
  local -r message_action=$(json_escape "$4")
  local message_description="$5"
  
  # Executed commands will be associated with the 
  # current log output (i.e. $UNITEX_BUILD_CURRENT_STDOUT)
  if [[ "$UNITEX_BUILD_CURRENT_STDOUT" != "/dev/stdout" && \
        "$UNITEX_BUILD_CURRENT_STDOUT" != *"$UNITEX_BUILD_UNTRACED"* || \
      ( "$UNITEX_BUILD_CURRENT_STDOUT" == *"$UNITEX_BUILD_UNTRACED"* && \
     -s "$UNITEX_BUILD_CURRENT_STDOUT" ) ]]; then
     local -r message_stdout="$(basename $UNITEX_BUILD_CURRENT_STDOUT)"
     message_description="<a data-has_console=\"true\" href=\"bundle/$UNITEX_BUILD_BUNDLE_NAME/$UNITEX_BUILD_VINBER_BUILD_HOME_NAME/$UNITEX_BUILD_LOG_NAME/$message_stdout\">$message_description</a>"   
  fi  

  message_description=$(json_escape "$(echo -n "$message_description" |\
        sed -e "s|$UNITEX_BUILD_DEPLOYMENT_DESTINATION|$UNITEX_WEBSITE_URL|g ; s|$UNITEX_BUILD_RELEASES_BASEDIR|$UNITEX_WEBSITE_URL/$UNITEX_BUILD_VINBER_BUILD_HOME_NAME/$UNITEX_BUILD_BUNDLE_NAME/$UNITEX_BUILD_RELEASES_HOME_NAME|g ; s|$UNITEX_BUILD_LOG_WORKSPACE/||g ; s|$UNITEX_BUILD_LOGGER_PATH|$UNITEX_BUILD_LOGGER_WEB_HOME|g ; s|$UNITEX_BUILD_BASEDIR/||g"\
        )")

  echo -E  "        {"
  echo -E  "            \"number\": \"$message_number\","
  echo -E  "            \"level\": \"$message_level\","
  echo -E  "            \"stage\": \"$message_stage\","
  echo -E  "            \"message\": \"$message_action\","
  echo -E  "            \"description\": \"$message_description\""
  echo -E  "        },"
}

# =============================================================================
# exec_logged_command "logfile_name" "command_name" "command_args"
function exec_logged_command() {
  # DEPRECATED(logfile_name) starting 1.4.0
  # logfile_name="$(echo -n  "$1" | sed -e 's/[^A-Za-z0-9_-]/_/g')"
  shift
  
  # binary command name
  command_name="$1"
  shift

  # all the rest are parameters
  command_args="$*"

  # pretty_command_args
  # 1. anonymize passwords      (--password *****) and users (--username *****)
  # 2. anonymize mail addresses (foo-at-bar.com => foo-at-b**.com)
  # 3. anonymize paths          (foo/bar        => bar)
  pretty_command_args=$(echo -n "$command_args" |\
  sed 's%\(user\(name\)\?\|pass\(word\)\?\)\( \)\+\([^ ]\+\)%\1 ********%g' |\
  sed -e :a -e 's/@\([^* .][^* .]\)\(\**\)[^* .]\([^*]*\.[^* .]*\)$/@\1\2*\3/;ta' |\
  sed -e "s|$UNITEX_BUILD_SOURCE_DIR/||g" |\
  sed -e "s|$UNITEX_BUILD_DEPLOYMENT_DESTINATION|$UNITEX_WEBSITE_URL|g")
  
  # test if command_name isn't empty
  if [ ! "$command_name" ]; then
     die_with_critical_error "Aborting" "Trying to execute empty command"
  fi

  # test if command exists
  command -v "$command_name" > /dev/null || \
  {
    die_with_critical_error "Aborting" "$command_name is required but it's not installed"
  }

  # redirect stdout and stderr to logfile
  # starting 1.4.0 redirect_std_name is defined here as
  redirect_std_name=$(printf "%0.3d_%s_%s"                    \
                      "$((UNITEX_BUILD_LOG_MESSAGE_COUNT+1))" \
                      "$UNITEX_BUILD_CURRENT_STAGE"           \
                      "$command_name")
  # do not to use especial characters for the file name
  redirect_std_name="$(echo -n  "${redirect_std_name,,}" | sed -e 's/[^a-z0-9_-]/_/g')"
  redirect_std "$redirect_std_name"
  
  
  command_line=( $command_name "$command_args" )

  MAX_COMMAND_LINE_LENGTH=119
  pretty_command_name=$(basename "$command_name")
  pretty_command_line=$(echo -n "$pretty_command_name $pretty_command_args" | \
                        cut -c 1-$MAX_COMMAND_LINE_LENGTH)

  if [[ ${#pretty_command_line} -ge $MAX_COMMAND_LINE_LENGTH ]]; then
    pretty_command_line="$pretty_command_line..."
  fi
  
  COMMAND_START_SECONDS=$(date +%s)
  COMMAND_TIMESTAMP_START_C="$(date -d now)"
  
  # command logging header
  echo "# $UNITEX_BUILD_VINBER_CODENAME Command Logging $COMMAND_TIMESTAMP_START_C"
  # shellcheck disable=SC2001
  echo "# $(echo "$UNITEX_BUILD_CURRENT_STDOUT" |\
                 sed "s|^.*$UNITEX_BUILD_VINBER_HOME_NAME/*$UNITEX_BUILD_VINBER_BUNDLE_HOME_NAME/*||g")"
  echo "# $pretty_command_name $pretty_command_args"

  # logging information
  log_info "Executing" "$pretty_command_line"

  {
    # execute command
    eval "${command_line[@]}"
    
    # save return code
    exit_status=$?
  }
  
  # elapsed time
  COMMAND_END_SECONDS=$(date +%s)
  COMMAND_DIFF_SECONDS=$(( COMMAND_END_SECONDS - COMMAND_START_SECONDS ))
  COMMAND_ELAPSED_TIME=$(echo -n $COMMAND_DIFF_SECONDS | awk '{print strftime("%H:%M:%S", $1,1)}')

   # Increment command execution counter
  (( UNITEX_BUILD_COMMAND_EXECUTION_COUNT++ ))
  
  # test return code
  if [ $exit_status -ne 0 ]; then
    log_error "Error executing" "$pretty_command_line"
    echo      "# Finished with errors"
    echo      "# Return status : $exit_status"
    # Increment fail execution counter
    (( UNITEX_BUILD_COMMAND_EXECUTION_ERROR_COUNT++ ))
  else
    echo      "# Successfully finished"
  fi

  # command logging footer
  echo "# Elapsed time  : $COMMAND_ELAPSED_TIME"

  # restore stdout and stderr
  if [ ! -z "$UNITEX_BUILD_CURRENT_STAGE" ]; then
    # All untraced execution commands, i.e. not running thorough
    # exec_logged_command call, will be kept in an .untraced.log file
    # starting 1.4.0 redirect_std_name is defined here as
    redirect_std_name=$(printf "%s_%0.3d_%s_%s"                 \
                      "$UNITEX_BUILD_UNTRACED"                  \
                      "$((UNITEX_BUILD_LOG_MESSAGE_COUNT + 1))" \
                      "$UNITEX_BUILD_CURRENT_STAGE"             \
                      "$command_name")
    redirect_std_name="$(echo -n  "${redirect_std_name,,}" | sed -e 's/[^a-z0-9_-]/_/g')"                       
    redirect_std "$redirect_std_name" NO_LOG_DEBUG
  fi
  
  # return the status
  return $exit_status
}

# =============================================================================
function push_stage() {
  if [ "$UNITEX_BUILD_PREVIOUS_STAGE" != "$1" ]; then
    UNITEX_BUILD_PREVIOUS_STAGE="$UNITEX_BUILD_CURRENT_STAGE"
    UNITEX_BUILD_CURRENT_STAGE="$1"
    # Every time that the Vinber stage changes the last action repository will be
    # reinitialized to "not-defined"
    UNITEX_BUILD_LAST_ACTION_REPOSITORY="$UNITEX_BUILD_NOT_DEFINED"
  fi  
}

# =============================================================================
function pop_build_stage() {
  if [ "$UNITEX_BUILD_CURRENT_STAGE" != "$UNITEX_BUILD_PREVIOUS_STAGE" ]; then
    UNITEX_BUILD_CURRENT_STAGE=$UNITEX_BUILD_PREVIOUS_STAGE
  fi  
}

# =============================================================================
function stage_unitex_doc_checkout() {
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  svn_checkout "--trust-server-cert --non-interactive --username anonsvn --password anonsvn" \
               "https://svnigm.univ-mlv.fr/svn/unitex/$UNITEX_BUILD_REPOSITORY_USERMANUAL_NAME"   \
               "$UNITEX_BUILD_REPOSITORY_USERMANUAL_NAME"
               
  svn_info     DOC_SVN_CHECKOUT_DETAILS   \
               "$UNITEX_BUILD_REPOSITORY_USERMANUAL_NAME"

  # Saving SVN last date changed
  echo "${DOC_SVN_CHECKOUT_DETAILS[2]}" > "$UNITEX_BUILD_TIMESTAMP_DIR/$UNITEX_BUILD_REPOSITORY_USERMANUAL_NAME.current"             

  pop_directory            
}  # stage_unitex_doc_checkout()

function stage_unitex_doc_make() {
  push_directory "$UNITEX_BUILD_REPOSITORY_USERMANUAL_LOCAL_PATH"

  UNITEX_BUILD_DOCS_HAS_ERRORS=0
  if [ $UNITEX_BUILD_DOCS_UPDATE -ne 0 ]; then
    # English User Manual
    log_info "Building manual" "Making Makefile_EN_utf8 - English User Manual"
    exec_logged_command "make.Makefile_EN_utf8" "$UNITEX_BUILD_TOOL_MAKE" \
                        -f Makefile_EN_utf8 || {
      UNITEX_BUILD_DOCS_HAS_ERRORS=1
    }

    # French User Manual
    log_info "Building manual" "Making Makefile_FR_utf8 - French User Manual"
    exec_logged_command "make.Makefile_FR_utf8" "$UNITEX_BUILD_TOOL_MAKE" \
                        -f Makefile_FR_utf8 || {
      UNITEX_BUILD_DOCS_HAS_ERRORS=1                    
    }
    
    if [ $UNITEX_BUILD_DOCS_HAS_ERRORS -ne 0 ]; then
      log_error "Compilation failed" "Unitex Documentation sources do not compile"
      # Force update until the successful compilation of the code is assured
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_DOCS_FORCE_UPDATE=./UNITEX_BUILD_DOCS_FORCE_UPDATE=2/'  \
                                  "$UNITEX_BUILD_CONFIG_FILENAME"
    else
      log_info "Compilation finished" "Compilation completed successfully"
      # Release update lock
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_DOCS_FORCE_UPDATE=2/UNITEX_BUILD_DOCS_FORCE_UPDATE=0/' \
                                   "$UNITEX_BUILD_CONFIG_FILENAME" 
    fi
  fi

  pop_directory   
}  # stage_unitex_doc_make()

# =============================================================================
# Output variable
# Last checkout filename
# Force update vars
# =============================================================================
function check_for_updates() {
  local __update_status=${1:?Return variable required}
  shift

  local update_checkout_file="$1"
  shift
  
  push_directory "$UNITEX_BUILD_BUNDLE_BASEDIR"
  update_required=$(( 0 || UNITEX_BUILD_FORCE_UPDATE ))

  while [ $update_required -eq 0 -a \
          ${#} -gt 0 ]; do
     if [ "$1" -eq 0 -o \
          "$1" -eq 1 -o \
          "$1" -eq 2 ]; then
     update_required=$(( $1 || update_required ))
    else
     die_with_critical_error "Bad parameter" \
      "The parameter \"$1\" passed to the check_for_updates function is invalid"
    fi
    shift
  done

  if [ $update_required -eq 0 ]; then
    if [ -f "$UNITEX_BUILD_TIMESTAMP_DIR/$update_checkout_file.last" ]; then
      log_debug "Checkout last file" "$update_checkout_file.last"
      log_debug "Checkout curr file" "$update_checkout_file.current"
      diff "$UNITEX_BUILD_TIMESTAMP_DIR/$update_checkout_file.last"    \
           "$UNITEX_BUILD_TIMESTAMP_DIR/$update_checkout_file.current" > /dev/null
      if [ $? -eq 1 ]; then
        update_required=1
        rm -f "$UNITEX_BUILD_TIMESTAMP_DIR/$update_checkout_file.last"
      fi
    else
      update_required=1
    fi

    if [ $update_required -ne 0 ]; then
      log_info "Update detected"    \
        "$UNITEX_PRETTYAPPNAME $UNITEX_BUILD_CURRENT_STAGE Components have been updated"
    else
      log_info "No updates detected" \
       "No updates detected for $UNITEX_PRETTYAPPNAME $UNITEX_BUILD_CURRENT_STAGE Components"
    fi
  else
      log_info "Force update" \
       "Forcing $UNITEX_PRETTYAPPNAME $UNITEX_BUILD_CURRENT_STAGE components update"
  fi

  mv "$UNITEX_BUILD_TIMESTAMP_DIR/$update_checkout_file.current" \
     "$UNITEX_BUILD_TIMESTAMP_DIR/$update_checkout_file.last"

  pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"

  # Normalize update status
  if [ $update_required -ge 2 ]; then
    update_required=1
  fi

  # shellcheck disable=SC2140
  eval "$__update_status"="'$update_required'"
}  # unitex_build_check_for_updates

# =============================================================================
# 
# =============================================================================
function stage_unitex_doc_dist() {
  push_stage "DocsDist"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  UNITEX_BUILD_DOCS_DEPLOYMENT=$(( ! UNITEX_BUILD_DOCS_HAS_ERRORS && ( UNITEX_BUILD_DOCS_FORCE_DEPLOYMENT  || UNITEX_BUILD_FORCE_DEPLOYMENT ) ))
  if [ $UNITEX_BUILD_DOCS_DEPLOYMENT -eq 0 ]; then
    if [ $UNITEX_BUILD_DOCS_UPDATE     -ne 0 -a \
         $UNITEX_BUILD_DOCS_HAS_ERRORS -eq 0 ]; then
      UNITEX_BUILD_DOCS_DEPLOYMENT=1   
      log_info "Preparing dist" "Documentation distribution is being prepared..."
      
      # copy UnitexManual_EN_utf8.pdf to App/manual/en
      mkdir -p "$UNITEX_BUILD_RELEASE_APP_MANUAL_DIR/en"
      cp "$UNITEX_BUILD_REPOSITORY_USERMANUAL_LOCAL_PATH/UnitexManual_EN_utf8.pdf" "$UNITEX_BUILD_RELEASE_APP_MANUAL_DIR/en/UnitexManual.pdf"

      # copy UnitexManual_FR_utf8.pdf to App/manual/fr
      mkdir -p "$UNITEX_BUILD_RELEASE_APP_MANUAL_DIR/fr"
      cp "$UNITEX_BUILD_REPOSITORY_USERMANUAL_LOCAL_PATH/UnitexManual_FR_utf8.pdf" "$UNITEX_BUILD_RELEASE_APP_MANUAL_DIR/fr/ManuelUnitex.pdf"

      # UnitexManual_EN_utf8.pdfto releases/man/Unitex-GramLab-3.1beta-usermanual-en.pdf
      log_info "Copying" "UnitexManual_EN_utf8.pdf to $UNITEX_BUILD_RELEASES_MAN_DIR/$UNITEX_PACKAGE_MAN_PREFIX-en.pdf"
      cp "$UNITEX_BUILD_REPOSITORY_USERMANUAL_LOCAL_PATH/UnitexManual_EN_utf8.pdf" "$UNITEX_BUILD_RELEASES_MAN_DIR/$UNITEX_PACKAGE_MAN_PREFIX-en.pdf"
      
      # UnitexManual_FR_utf8.pdf to releases/man/Unitex-GramLab-3.1beta-usermanual-fr.pdf
      log_info "Copying" "UnitexManual_FR_utf8.pdf to $UNITEX_BUILD_RELEASES_MAN_DIR/$UNITEX_PACKAGE_MAN_PREFIX-fr.pdf"
      cp "$UNITEX_BUILD_REPOSITORY_USERMANUAL_LOCAL_PATH/UnitexManual_FR_utf8.pdf" "$UNITEX_BUILD_RELEASES_MAN_DIR/$UNITEX_PACKAGE_MAN_PREFIX-fr.pdf"     

      log_info "Dist prepared" "Documentation distribution is now prepared"
    fi
  else
    log_notice "Dist prepared" "Documentation distribution is already prepared, nevertheless, a full deployment will be forced by user request!"
  fi
  pop_directory
  pop_build_stage
}  # stage_unitex_doc_dist

# =============================================================================
# 
# =============================================================================
function stage_unitex_vinber_backend() {
  push_stage "VinberBackend"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  if [ $UNITEX_BUILD_SKIP_STAGE_VINBER_BACKEND -ne 0 ]; then
    log_info "Stage skipped" "This stage will be ignored as requested by the $UNITEX_BUILD_BUNDLE_NAME-bundle configuration"
    pop_directory   # "$UNITEX_BUILD_SOURCE_DIR"
    pop_build_stage  
    return 1
  fi   

  # 1. Saving vinber source code last date changed
  echo "$SCRIPT_TIMESTAMP" > "$UNITEX_BUILD_TIMESTAMP_DIR/$UNITEX_BUILD_VINBER_CODENAME.current" 

  # 2. Check if the vinber source code has changed
  check_for_updates UNITEX_BUILD_VINBER_BACKEND_UPDATE "$UNITEX_BUILD_VINBER_CODENAME" \
                    $UNITEX_BUILD_VINBER_BACKEND_FORCE_UPDATE

  # 3. If the vinber source has changed we force the update of all components
  UNITEX_BUILD_VINBER_BACKEND_HAS_ERRORS=0
  if [ $UNITEX_BUILD_VINBER_BACKEND_UPDATE -ne 0 ]; then
    log_info "Force update" "Vinber Backend script has changed! all components will be updated"
    # TODO(martinec) check script using shellcheck
    # shell check -s bash "$SCRIPT_FILE" || { UNITEX_BUILD_VINBER_BACKEND_HAS_ERRORS=1 }
    UNITEX_BUILD_FORCE_UPDATE=1
  fi

  # 4. Thrown an error if we detected an issue in the vinber source
  if [ $UNITEX_BUILD_VINBER_BACKEND_HAS_ERRORS -ne 0 ]; then
    die_with_critical_error "Unrecoverable error" "Vinber sources have issues"
  fi
                    
  pop_directory
  pop_build_stage
}  # stage_unitex_vinber_backend   
   
# =============================================================================
# 
# =============================================================================
# stage_unitex_doc
function stage_unitex_doc() {
  push_stage "Docs"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  if [ $UNITEX_BUILD_SKIP_STAGE_DOCS -ne 0 ]; then
    log_info "Stage skipped" "This stage will be ignored as requested by the $UNITEX_BUILD_BUNDLE_NAME-bundle configuration"
    pop_directory   # "$UNITEX_BUILD_SOURCE_DIR"
    pop_build_stage  
    return 1
  fi   

  # 1. Documentation checkout
  stage_unitex_doc_checkout

  # 2. Documentation check for updates
  check_for_updates UNITEX_BUILD_DOCS_UPDATE "$UNITEX_BUILD_REPOSITORY_USERMANUAL_NAME" \
                    $UNITEX_BUILD_DOCS_FORCE_UPDATE

  # 3. Documentation make
  stage_unitex_doc_make

  # 4. Documentation dist
  stage_unitex_doc_dist
  
  pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"
  pop_build_stage  
}  # function stage_unitex_doc ()

# =============================================================================
# 
# =============================================================================
function stage_unitex_packaging_windows_checkout () {
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  git_clone_pull   "" \
                   "git://github.com/UnitexGramLab/unitex-packaging-windows.git" \
                   "$UNITEX_BUILD_REPOSITORY_PACK_WIN_NAME"
               
  git_info    PACKAGING_GIT_CLONE_DETAILS           \
              "$UNITEX_BUILD_REPOSITORY_PACK_WIN_NAME"
              
  # Saving GIT last date changed
  echo "${PACKAGING_GIT_CLONE_DETAILS[2]}" > "$UNITEX_BUILD_TIMESTAMP_DIR/$UNITEX_BUILD_REPOSITORY_PACK_NAME.windows.current"

  pop_directory            
}  # stage_unitex_packaging_windows_checkout ()

# =============================================================================
# 
# =============================================================================
function stage_unitex_packaging_windows_dist() {
  push_stage "PackWin"
  push_directory "$UNITEX_BUILD_RELEASES_DIR"

  UNITEX_BUILD_PACK_DEPLOYMENT=$(( ! UNITEX_BUILD_PACK_HAS_ERRORS &&  ( UNITEX_BUILD_PACK_FORCE_DEPLOYMENT  || UNITEX_BUILD_FORCE_DEPLOYMENT) ))
  if [ $UNITEX_BUILD_PACK_DEPLOYMENT -eq 0 ]; then
    if [ $UNITEX_BUILD_PACK_UPDATE     -ne 0 -a \
         $UNITEX_BUILD_PACK_HAS_ERRORS -eq 0 ]; then
      UNITEX_BUILD_PACK_DEPLOYMENT=1
      log_info "Preparing dist"   "Windows setup distribution is being prepared..."

      # Win32 distribution package checksum
      calculate_checksum "$UNITEX_BUILD_RELEASES_SETUP_WIN32_DIR/$UNITEX_PACKAGE_WIN32_PREFIX.exe" "$UNITEX_BUILD_RELEASES_SETUP_WIN32_DIR"

      # WIN64 distribution package checksum
      calculate_checksum "$UNITEX_BUILD_RELEASES_SETUP_WIN64_DIR/$UNITEX_PACKAGE_WIN64_PREFIX.exe" "$UNITEX_BUILD_RELEASES_SETUP_WIN64_DIR"

      log_info "Dist prepared"    "Windows setup distribution is now prepared"
    fi
  else
    log_notice "Dist prepared" "Windows setup distribution is already prepared, nevertheless, a full deployment will be forced by user request!"
  fi
  
  pop_directory
  pop_build_stage
}  # stage_unitex_doc_dist

# =============================================================================
# 
# =============================================================================
# stage_unitex_packaging_windows
function stage_unitex_packaging_windows() {
  push_stage "PackWin"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  # 1. Packaging checkout
  stage_unitex_packaging_windows_checkout

  # 2. Packaging check for updates
  check_for_updates UNITEX_BUILD_PACK_UPDATE "$UNITEX_BUILD_REPOSITORY_PACK_NAME.windows"  \
                    "$UNITEX_BUILD_PACK_FORCE_UPDATE"             \
                    "$UNITEX_BUILD_DOCS_UPDATE"                   \
                    "$UNITEX_BUILD_LING_UPDATE"                   \
                    "$UNITEX_BUILD_CLASSIC_IDE_UPDATE"            \
                    "$UNITEX_BUILD_GRAMLAB_IDE_UPDATE"            \
                    "$UNITEX_BUILD_CORE_UPDATE"


  count_issues_until_now UNITEX_BUILD_ISSUES_BEFORE_PACKAGING_WINDOWS_MAKE
   
  # 3. Windows packaging make
  # shellcheck disable=SC2086
  if [  $UNITEX_BUILD_ISSUES_BEFORE_PACKAGING_WINDOWS_MAKE -eq 0 ]; then
    stage_unitex_packaging_make_installer_win 32
    stage_unitex_packaging_make_installer_win 64
  else
    log_warn "Compilation skipped" "Some issues prevent to compile the Windows setup installer"
  fi

  # 4. Distribute windows setup
  stage_unitex_packaging_windows_dist

  pop_directory
  pop_build_stage      
}

# =============================================================================
# 
# =============================================================================
function stage_unitex_packaging_source_dist() {
  push_stage "PackSrc"
  push_directory "$UNITEX_BUILD_RELEASES_DIR"

  UNITEX_BUILD_PACK_DEPLOYMENT=$(( ! UNITEX_BUILD_PACK_HAS_ERRORS &&  ( UNITEX_BUILD_PACK_FORCE_DEPLOYMENT  || UNITEX_BUILD_FORCE_DEPLOYMENT) ))
  if [ $UNITEX_BUILD_PACK_DEPLOYMENT -eq 0 ]; then
    if [ $UNITEX_BUILD_PACK_UPDATE     -ne 0 -a \
         $UNITEX_BUILD_PACK_HAS_ERRORS -eq 0 ]; then
      UNITEX_BUILD_PACK_DEPLOYMENT=1
      log_info "Preparing dist"   "Source distribution is being prepared..."
      log_info "Dist prepared"    "Source distribution is now prepared"
    fi
  else
    log_notice "Dist prepared" "Source distribution is already prepared, nevertheless, a full deployment will be forced by user request!"
  fi
  
  pop_directory
  pop_build_stage
}  # stage_unitex_packaging_source_dist

# =============================================================================
# 
# =============================================================================
function stage_unitex_pack_make_source_distribution() {
  push_stage "PackSrc"
  push_directory "$UNITEX_BUILD_DIST_BASEDIR"


  UNITEX_BUILD_PACK_HAS_ERRORS=0
  if [ $UNITEX_BUILD_PACK_UPDATE -ne 0 ]; then
  
    log_info "Packing distribution" "Packing source distribution"
    
    create_zip "$UNITEX_BUILD_DIST_BASEDIR" "$UNITEX_BUILD_RELEASES_SOURCE_DIR" \
               "$UNITEX_PACKAGE_SRCDIST_PREFIX.zip" "$UNITEX_PACKAGE_FULL_NAME" "-x *.svn*" || {
        UNITEX_BUILD_PACK_HAS_ERRORS=1
    }

    create_zip "$UNITEX_BUILD_RELEASE_DIR" "$UNITEX_BUILD_RELEASES_SOURCE_DIR" \
               "$UNITEX_PACKAGE_SRC_PREFIX.zip" "Src" "-x *.svn*" || {
        UNITEX_BUILD_PACK_HAS_ERRORS=1
    }

    create_zip "$UNITEX_BUILD_RELEASE_DIR" "$UNITEX_BUILD_RELEASES_SOURCE_DIR" \
               "$UNITEX_PACKAGE_APP_PREFIX.zip" "App" "-x *.svn*" || {
        UNITEX_BUILD_PACK_HAS_ERRORS=1
    }
     
      
    if [ $UNITEX_BUILD_PACK_HAS_ERRORS -ne 0 ]; then
      log_error "Packing failed" "Source distribution packing process fail!"
      # Force update until success
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_PACK_FORCE_UPDATE=./UNITEX_BUILD_PACK_FORCE_UPDATE=2/'  \
                                  "$UNITEX_BUILD_CONFIG_FILENAME"
    else
      log_info "Packing finished" "Source distribution packing process completed successfully"
      # Release update lock
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_PACK_FORCE_UPDATE=2/UNITEX_BUILD_PACK_FORCE_UPDATE=0/' \
                                  "$UNITEX_BUILD_CONFIG_FILENAME" 
    fi
  fi  #  if [ $UNITEX_BUILD_PACK_UPDATE -ne 0 ]; then  
    
  pop_directory  # "$UNITEX_BUILD_DIST_BASEDIR"
  pop_build_stage 
}

# =============================================================================
# 
# =============================================================================
# stage_unitex_packaging_source
function stage_unitex_packaging_source() {
  push_stage "PackSrc"
  push_directory "$UNITEX_BUILD_DIST_BASEDIR"

  local packaging_source_timestamp
  if [ -e "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_SRCDIST_PREFIX.zip" ]; then
    packaging_source_timestamp=$(stat -c %y "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_SRCDIST_PREFIX.zip")
  fi

  # 1. Save source distribution package last date changed
  echo "$packaging_source_timestamp" > "$UNITEX_BUILD_TIMESTAMP_DIR/$UNITEX_BUILD_REPOSITORY_PACK_NAME$UNITEX_BUILD_PACKAGE_SOURCE_DISTRIBUTION_SUFFIX.current" 

  # 2. Check for source distribution package updates
  check_for_updates UNITEX_BUILD_PACK_UPDATE "$UNITEX_BUILD_REPOSITORY_PACK_NAME$UNITEX_BUILD_PACKAGE_SOURCE_DISTRIBUTION_SUFFIX"  \
                    "$UNITEX_BUILD_DOCS_UPDATE"                   \
                    "$UNITEX_BUILD_LING_UPDATE"                   \
                    "$UNITEX_BUILD_CLASSIC_IDE_UPDATE"            \
                    "$UNITEX_BUILD_GRAMLAB_IDE_UPDATE"            \
                    "$UNITEX_BUILD_CORE_UPDATE"


  count_issues_until_now UNITEX_BUILD_ISSUES_BEFORE_PACKAGING_SOURCE_DISTRIBUTION
   
  # 3. Windows packaging make
  # shellcheck disable=SC2086
  if [  $UNITEX_BUILD_ISSUES_BEFORE_PACKAGING_SOURCE_DISTRIBUTION -eq 0 ]; then
    stage_unitex_pack_make_source_distribution
  else
    log_warn "Packing skipped" "Some issues prevent to pack the source distribution"
  fi

  # 4. source distribution
  stage_unitex_packaging_source_dist

  pop_directory
  pop_build_stage
}  # stage_unitex_packaging_source

# # =============================================================================
# # 
# # =============================================================================
# # stage_unitex_packaging_linux_x86_64
# function stage_unitex_packaging_linux_x86_64() {
#   push_stage "PackLinux64"
#   push_directory "$UNITEX_BUILD_DIST_BASEDIR"

#   local packaging_linux_x86_64_timestamp
#   if [ -e "$UNITEX_BUILD_RELEASES_LINUX_X86_64_DIR/$UNITEX_PACKAGE_LINUX_X86_64_PREFIX.run" ]; then
#     packaging_linux_x86_64_timestamp=$(stat -c %y "$UNITEX_BUILD_RELEASES_LINUX_X86_64_DIR/$UNITEX_PACKAGE_LINUX_X86_64_PREFIX.run")
#   fi

#   # 1. Save linux_x86_64 distribution package last date changed
#   echo "$packaging_linux_x86_64_timestamp" > "$UNITEX_BUILD_TIMESTAMP_DIR/$UNITEX_BUILD_REPOSITORY_PACK_NAME$UNITEX_BUILD_PACKAGE_LINUX_X86_64_SUFFIX.current" 

#   # 2. Check for linux_x86_64 distribution package updates
#   check_for_updates UNITEX_BUILD_PACK_UPDATE "$UNITEX_BUILD_REPOSITORY_PACK_NAME$UNITEX_BUILD_PACKAGE_LINUX_X86_64_SUFFIX"  \
#                     "$UNITEX_BUILD_DOCS_UPDATE"                   \
#                     "$UNITEX_BUILD_LING_UPDATE"                   \
#                     "$UNITEX_BUILD_CLASSIC_IDE_UPDATE"            \
#                     "$UNITEX_BUILD_GRAMLAB_IDE_UPDATE"            \
#                     "$UNITEX_BUILD_CORE_UPDATE"


#   count_issues_until_now UNITEX_BUILD_ISSUES_BEFORE_PACKAGING_LINUX_X86_64
   
#   # 3. Windows packaging make
#   # shellcheck disable=SC2086
#   if [  $UNITEX_BUILD_ISSUES_BEFORE_PACKAGING_LINUX_X86_64 -eq 0 ]; then
#     stage_unitex_packaging_make_installer_linux_x86_64
#   else
#     log_warn "Packing skipped" "Some issues prevent to pack the linux-x86_64 distribution"
#   fi

#   # 4. linux_x86_64 distribution
#   stage_unitex_packaging_unix_dist

#   pop_directory
#   pop_build_stage
# }  # stage_unitex_packaging_linux_x86_64

# =============================================================================
# 
# =============================================================================
function stage_unitex_packaging_unix() {
  push_stage "PackUnix"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  # 1. Packaging checkout
  stage_unitex_packaging_unix_checkout

  # 2. Packaging check for updates
  check_for_updates UNITEX_BUILD_PACK_UPDATE "$UNITEX_BUILD_REPOSITORY_PACK_NAME.unix"  \
                    "$UNITEX_BUILD_PACK_FORCE_UPDATE"             \
                    "$UNITEX_BUILD_DOCS_UPDATE"                   \
                    "$UNITEX_BUILD_LING_UPDATE"                   \
                    "$UNITEX_BUILD_CLASSIC_IDE_UPDATE"            \
                    "$UNITEX_BUILD_GRAMLAB_IDE_UPDATE"            \
                    "$UNITEX_BUILD_CORE_UPDATE"

  count_issues_until_now UNITEX_BUILD_ISSUES_BEFORE_PACKAGING_UNIX_MAKE
   
  # 3. Unix packaging make
  # shellcheck disable=SC2086
  if [  $UNITEX_BUILD_ISSUES_BEFORE_PACKAGING_UNIX_MAKE -eq 0 ]; then
    stage_unitex_packaging_configure_installer_unix
    stage_unitex_packaging_make_installer_linux_i686
    stage_unitex_packaging_make_installer_linux_x86_64
  else
    log_warn "Compilation skipped" "Some issues prevent to compile the Unix setup installers"
  fi

  # 4. Distribute unix setup
  stage_unitex_packaging_unix_dist

  pop_directory
  pop_build_stage
}

# =============================================================================
# 
# =============================================================================
function stage_unitex_packaging_unix_checkout () {
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  git_clone_pull   "" \
                   "git://github.com/UnitexGramLab/unitex-packaging-unix.git" \
                   "$UNITEX_BUILD_REPOSITORY_PACK_UNIX_NAME"
               
  git_info    PACKAGING_GIT_CLONE_DETAILS           \
              "$UNITEX_BUILD_REPOSITORY_PACK_UNIX_NAME"
              
  # Saving GIT last date changed
  echo "${PACKAGING_GIT_CLONE_DETAILS[2]}" > "$UNITEX_BUILD_TIMESTAMP_DIR/$UNITEX_BUILD_REPOSITORY_PACK_NAME.unix.current"

  pop_directory            
}  # stage_unitex_packaging_unix_checkout ()

# =============================================================================
# 
# =============================================================================
function stage_unitex_packaging_make_installer_linux_i686() {
  push_stage "PackLinux32"
  push_directory "$UNITEX_BUILD_DIST_BASEDIR"

  UNITEX_BUILD_PACK_HAS_ERRORS=0
  if [ $UNITEX_BUILD_PACK_UPDATE -ne 0 ]; then
  
    log_info "Packing distribution" "Packing Linux Intel (i686) distribution"

    # Remove previous .run file
    rm -rf "$UNITEX_BUILD_RELEASES_LINUX_I686_DIR/$UNITEX_PACKAGE_LINUX_I686_PREFIX.run"
    
    # Use makeself to build the package
    exec_logged_command "makeself.linux_i686" "makeself.sh"                                         \
      --license "$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_PACK_UNIX_NAME/data/LICENSE.txt" \
      --target  "\"\\\$HOME/$UNITEX_PACKAGE_FULL_NAME\""                                            \
      "$UNITEX_PACKAGE_FULL_NAME"                                                                   \
      "$UNITEX_BUILD_RELEASES_LINUX_I686_DIR/$UNITEX_PACKAGE_LINUX_I686_PREFIX.run"                 \
      "\"$UNITEX_BUILD_FULL_RELEASE Linux Intel (i686)\""                                          \
      "./App/install/setup" || {
      UNITEX_BUILD_PACK_HAS_ERRORS=1
    }
    
    if [ $UNITEX_BUILD_PACK_HAS_ERRORS -ne 0 ]; then
      log_error "Packing failed" "Linux Intel (i686) distribution packing process fail!"
      # Force update until success
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_PACK_FORCE_UPDATE=./UNITEX_BUILD_PACK_FORCE_UPDATE=2/'  \
                                  "$UNITEX_BUILD_CONFIG_FILENAME"
    else
      log_info "Packing finished" "Linux Intel (i686) distribution packing process completed successfully"
      # Release update lock
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_PACK_FORCE_UPDATE=2/UNITEX_BUILD_PACK_FORCE_UPDATE=0/' \
                                  "$UNITEX_BUILD_CONFIG_FILENAME" 
    fi
  fi  #  if [ $UNITEX_BUILD_PACK_UPDATE -ne 0 ]; then  
    
  pop_directory  # "$UNITEX_BUILD_DIST_BASEDIR"
  pop_build_stage 
}

# =============================================================================
# 
# =============================================================================
function stage_unitex_packaging_make_installer_linux_x86_64() {
  push_stage "PackLinux64"
  push_directory "$UNITEX_BUILD_DIST_BASEDIR"

  UNITEX_BUILD_PACK_HAS_ERRORS=0
  if [ $UNITEX_BUILD_PACK_UPDATE -ne 0 ]; then
  
    log_info "Packing distribution" "Packing Linux Intel 64-bit (x86_64) distribution"

    # Remove previous .run file
    rm -rf "$UNITEX_BUILD_RELEASES_LINUX_X86_64_DIR/$UNITEX_PACKAGE_LINUX_X86_64_PREFIX.run"
    
    # Use makeself to build the package
    exec_logged_command "makeself.linux_x86_64" "makeself.sh"                                       \
      --license "$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_PACK_UNIX_NAME/data/LICENSE.txt" \
      --target  "\"\\\$HOME/$UNITEX_PACKAGE_FULL_NAME\""                                            \
      "$UNITEX_PACKAGE_FULL_NAME"                                                                   \
      "$UNITEX_BUILD_RELEASES_LINUX_X86_64_DIR/$UNITEX_PACKAGE_LINUX_X86_64_PREFIX.run"             \
      "\"$UNITEX_BUILD_FULL_RELEASE Linux Intel 64-bit (x86_64)\""                                        \
      "./App/install/setup" || {
         UNITEX_BUILD_PACK_HAS_ERRORS=1
    }
    
    if [ $UNITEX_BUILD_PACK_HAS_ERRORS -ne 0 ]; then
      log_error "Packing failed" "Linux Intel 64-bit (x86_64) distribution packing process fail!"
      # Force update until success
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_PACK_FORCE_UPDATE=./UNITEX_BUILD_PACK_FORCE_UPDATE=2/'  \
                                  "$UNITEX_BUILD_CONFIG_FILENAME"
    else
      log_info "Packing finished" "Linux Intel 64-bit (x86_64) distribution packing process completed successfully"
      # Release update lock
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_PACK_FORCE_UPDATE=2/UNITEX_BUILD_PACK_FORCE_UPDATE=0/' \
                                  "$UNITEX_BUILD_CONFIG_FILENAME" 
    fi
  fi  #  if [ $UNITEX_BUILD_PACK_UPDATE -ne 0 ]; then  
    
  pop_directory  # "$UNITEX_BUILD_DIST_BASEDIR"
  pop_build_stage 
}


# =============================================================================
# 
# =============================================================================
function stage_unitex_packaging_configure_installer_unix() {
  push_stage "PackUnix"
  push_directory "$UNITEX_BUILD_DIST_BASEDIR"

  UNITEX_BUILD_PACK_HAS_ERRORS=0
  if [ $UNITEX_BUILD_PACK_UPDATE -ne 0 ]; then
  
    log_info "Configuring installer" "Configuring Unix distributions"

    # Copy all unitex-packaging-unix/resources to the $UNITEX_BUILD_RELEASE_DIR
    if [ -d "$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_PACK_UNIX_NAME/resources" ]; then
      push_directory "$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_PACK_UNIX_NAME/resources"
      cp -r ./* "$UNITEX_BUILD_RELEASE_DIR" || {
         UNITEX_BUILD_PACK_HAS_ERRORS=1
      }
      pop_directory
    fi

    # Create LICENSE.txt
    if [ -e "$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_PACK_UNIX_NAME/data/LICENSE.md.in" ];then
       log_info "Creating License" "Creating a License file for the installer"
       UNITEX_VER_FULL="$UNITEX_VER_FULL"                                                          \
       UNITEX_BUILD_DATE=$(date '+%B %d, %Y')                                                      \
       UNITEX_DESCRIPTION="$UNITEX_DESCRIPTION"                                                    \
       UNITEX_HOMEPAGE_URL="$UNITEX_HOMEPAGE_URL"                                                  \
       UNITEX_RELEASES_URL="$UNITEX_RELEASES_URL"                                                  \
       UNITEX_RELEASES_LATEST_BETA_WIN32_URL="$UNITEX_RELEASES_LATEST_BETA_WIN32_URL"              \
       UNITEX_RELEASES_LATEST_BETA_SOURCE_URL="$UNITEX_RELEASES_LATEST_BETA_SOURCE_URL"            \
       UNITEX_DOCS_URL="$UNITEX_DOCS_URL"                                                          \
       UNITEX_FORUM_URL="$UNITEX_FORUM_URL"                                                        \
       UNITEX_BUG_URL="$UNITEX_BUG_URL"                                                            \
       UNITEX_GOVERNANCE_URL="$UNITEX_GOVERNANCE_URL"                                              \
       UNITEX_COPYRIGHT_HOLDER="$UNITEX_COPYRIGHT_HOLDER"                                          \
       UNITEX_CURRENT_YEAR=$(date '+%Y')                                                           \
       "$SCRIPT_BASEDIR/mo" "$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_PACK_UNIX_NAME/data/LICENSE.md.in" |\
        fold -s -w72                                                                               \
        > "$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_PACK_UNIX_NAME/data/LICENSE.txt"  || {
         UNITEX_BUILD_PACK_HAS_ERRORS=1
       }
    fi
    
    if [ $UNITEX_BUILD_PACK_HAS_ERRORS -ne 0 ]; then
      log_error "Configuration failed" "Unix distributions configuration process failed!"
      # Force update until success
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_PACK_FORCE_UPDATE=./UNITEX_BUILD_PACK_FORCE_UPDATE=2/'  \
                                  "$UNITEX_BUILD_CONFIG_FILENAME"
    else
      log_info "Configuration finished" "Unix distribution configuration process completed successfully"
      # Release update lock
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_PACK_FORCE_UPDATE=2/UNITEX_BUILD_PACK_FORCE_UPDATE=0/' \
                                  "$UNITEX_BUILD_CONFIG_FILENAME" 
    fi
  fi  #  if [ $UNITEX_BUILD_PACK_UPDATE -ne 0 ]; then  
    
  pop_directory  # "$UNITEX_BUILD_DIST_BASEDIR"
  pop_build_stage 
}

# =============================================================================
# 
# =============================================================================
function stage_unitex_packaging_unix_dist() {
  push_stage "PackUnix"
  push_directory "$UNITEX_BUILD_RELEASES_DIR"

  UNITEX_BUILD_PACK_DEPLOYMENT=$(( ! UNITEX_BUILD_PACK_HAS_ERRORS &&  ( UNITEX_BUILD_PACK_FORCE_DEPLOYMENT  || UNITEX_BUILD_FORCE_DEPLOYMENT) ))
  if [ $UNITEX_BUILD_PACK_DEPLOYMENT -eq 0 ]; then
    if [ $UNITEX_BUILD_PACK_UPDATE     -ne 0 -a \
         $UNITEX_BUILD_PACK_HAS_ERRORS -eq 0 ]; then
      UNITEX_BUILD_PACK_DEPLOYMENT=1
      log_info "Preparing dist"   "Linux Intel 64-bit (x86_64) distribution is being prepared..."

      # Linux Intel (i686) distribution package checksum
      calculate_checksum "$UNITEX_BUILD_RELEASES_LINUX_I686_DIR/$UNITEX_PACKAGE_LINUX_I686_PREFIX.run"     "$UNITEX_BUILD_RELEASES_LINUX_I686_DIR"

      # Linux Intel 64-bit (x86_64) distribution package checksum
      calculate_checksum "$UNITEX_BUILD_RELEASES_LINUX_X86_64_DIR/$UNITEX_PACKAGE_LINUX_X86_64_PREFIX.run" "$UNITEX_BUILD_RELEASES_LINUX_X86_64_DIR"

      log_info "Dist prepared"    "Unix distribution is now prepared"     
    fi
  else
    log_notice "Dist prepared" "Unix distribution is already prepared, nevertheless, a full deployment will be forced by user request!"
  fi
  
  pop_directory
  pop_build_stage
}  # stage_unitex_packaging_unix_dist

# =============================================================================
# 
# =============================================================================
function calculate_checksum() {
  if [ $# -ne 2  ]; then
    die_with_critical_error "Vinber calculate_checksum fails" \
     "Function called with the wrong number of parameters"
  fi
  
   local input_file="$1"
   local output_directory="$2"
 
   local -r input_directory=$(dirname "$input_file")
   local -r input_name=$(basename "$input_file")

   push_directory "$input_directory"

   if [ -e "$input_file" ]; then
     # Calculate the SHA256 hash of the input file      
     log_info "Computing SHA256" "Computing the SHA256 of ${input_file// /%20}"
     local -r file_checksum=$(sha256sum "$input_name"                                |\
                                  sed -e "s:$input_directory/::"                     |\
                                  tee "$output_directory/$input_name.sha256"         |\
                                  sed "s:\s\+.*$::")
     log_info "SHA256 Computed"  "SHA256 hash ($file_checksum) saved to $output_directory/$input_name.sha256"
   else
     log_warn "File not found" "File $input_file doesn't exist"
   fi

   pop_directory  #  "$input_directory"
}

# =============================================================================
# 
# =============================================================================
# stage_unitex_packing
function stage_unitex_packing() {
  push_stage "Pack"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  if [ $UNITEX_BUILD_SKIP_STAGE_PACK -ne 0 ]; then
    log_info "Stage skipped" "This stage will be ignored as requested by the $UNITEX_BUILD_BUNDLE_NAME-bundle configuration"
    pop_directory   # "$UNITEX_BUILD_SOURCE_DIR"
    pop_build_stage  
    return 1
  fi

  count_issues_until_now UNITEX_BUILD_ISSUES_BEFORE_PACKAGING

  # shellcheck disable=SC2086
  if [ $UNITEX_BUILD_ISSUES_BEFORE_PACKAGING -ne 0 ]; then
    log_warn "Stage skipped" "Some issues prevent to continue the packaging process"
    pop_directory   # "$UNITEX_BUILD_SOURCE_DIR"
    pop_build_stage  
    return 1   
  fi    

  # DO NOT CHANGE PACKAGING CREATION ORDER

  # 1. Unix
  stage_unitex_packaging_unix

  # 2. OS X
  # stage_unitex-packaging_osx

  # 3. Windows
  stage_unitex_packaging_windows

  # 4. Sources
  stage_unitex_packaging_source

  pop_directory   # "$UNITEX_BUILD_SOURCE_DIR"
  pop_build_stage  
}

# =============================================================================
# 
# =============================================================================
function stage_unitex_lingua_checkout () {
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  svn_checkout "--trust-server-cert --non-interactive --username anonsvn --password anonsvn" \
               "https://svnigm.univ-mlv.fr/svn/unitex/$UNITEX_BUILD_REPOSITORY_LING_NAME"    \
               "$UNITEX_BUILD_REPOSITORY_LING_NAME"
               
  svn_info    LINGUA_SVN_CHECKOUT_DETAILS              \
              "$UNITEX_BUILD_REPOSITORY_LING_NAME"                             

  pop_directory            
}  # stage_unitex_lingua_checkout ()

# =============================================================================
# 
# =============================================================================
function stage_unitex_lingua_check_for_updates() {
  push_directory "$UNITEX_BUILD_REPOSITORY_LING_LOCAL_PATH"

  UNITEX_BUILD_LING_UPDATE=$((0 || UNITEX_BUILD_LING_FORCE_UPDATE || UNITEX_BUILD_FORCE_UPDATE))
 
  for lang in *
    do
    push_stage "Ling-${ISO639_3_LANGUAGES["$lang"]}"
    log_info "Looking for updates" "Looking for $lang updates..."
    #lang=$(echo -n $lang | sed -e 's| |\\ |g')
    svn_info  THIS_LANG_SVN_CHECKOUT_DETAILS        \
              "../$UNITEX_BUILD_REPOSITORY_LING_NAME/$lang"

    # Last changed date          
    echo "${THIS_LANG_SVN_CHECKOUT_DETAILS[2]}" > "$UNITEX_BUILD_TIMESTAMP_DIR/$lang.current"

    # check for this language updates
    check_for_updates UNITEX_BUILD_THIS_LANG_UPDATE "$lang"
    
    if [ "$UNITEX_BUILD_THIS_LANG_UPDATE" -ne 0 ]; then
      UNITEX_BUILD_LING_UPDATE=1
      
      # create the zip file for the current language
      rm -f "${UNITEX_BUILD_RELEASES_LING_DIR:?}/$lang.zip"
      log_info "Creating file"  "$UNITEX_BUILD_RELEASES_LING_DIR/$lang.zip"
      exec_logged_command "zipcmd.create.$lang" "$UNITEX_BUILD_TOOL_ZIP" -r "\"$UNITEX_BUILD_RELEASES_LING_DIR/$lang.zip\"" "\"$lang\"" -x ./*.svn*

      if [ -e "$UNITEX_BUILD_RELEASES_LING_DIR/$lang.zip" ]; then
        # calculate the checksum for the current lang zip file
        calculate_checksum "$UNITEX_BUILD_RELEASES_LING_DIR/$lang.zip" "$UNITEX_BUILD_RELEASES_LING_DIR"

        # replace the existing language directory, if any, by this new one
        rm -rf   "${UNITEX_BUILD_RELEASE_DIR:?}/$lang"
        log_info "Extracting"  "$UNITEX_BUILD_RELEASES_LING_DIR/$lang.zip into the $UNITEX_BUILD_RELEASE_DIR folder"
        exec_logged_command "zipcmd.extract.$lang" "unzip" "\"$UNITEX_BUILD_RELEASES_LING_DIR/$lang.zip\"" -d "$UNITEX_BUILD_RELEASE_DIR"        
      else
        log_warn "File not found" "File $lang.zip doesn't exist"
      fi

      # we update the log file
      log_info "Updating"  "$UNITEX_BUILD_RELEASES_CHANGES_DIR/$lang.txt"
      # shellcheck disable=SC2086
      svn log --trust-server-cert --non-interactive --username anonsvn --password anonsvn $UNITEX_BUILD_SVN_LOG_LIMIT_PARAMETER "$lang" > "$UNITEX_BUILD_RELEASE_DIR/$lang/log_svn_$lang.txt"
      cp "$UNITEX_BUILD_RELEASE_DIR/$lang/log_svn_$lang.txt" "$UNITEX_BUILD_RELEASES_CHANGES_DIR/$lang.txt" 
    fi

    pop_build_stage
  done
  pop_directory
}  # stage_unitex_lingua_make


# =============================================================================
# 
# =============================================================================
function stage_unitex_lingua_dist() {
  push_stage "LingDist"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  UNITEX_BUILD_LING_DEPLOYMENT=$(( ! UNITEX_BUILD_LING_HAS_ERRORS && ( UNITEX_BUILD_LING_FORCE_DEPLOYMENT  || UNITEX_BUILD_FORCE_DEPLOYMENT) ))
  if [ $UNITEX_BUILD_LING_DEPLOYMENT -eq 0 ]; then
    if [ $UNITEX_BUILD_LING_UPDATE     -ne 0 -a \
         $UNITEX_BUILD_LING_HAS_ERRORS -eq 0 ]; then
      UNITEX_BUILD_LING_DEPLOYMENT=1   
      log_info "Preparing dist" "Lingua distribution is being prepared..."
      log_info "Dist prepared"  "Lingua distribution is now prepared"
    fi
  else
    log_notice "Dist prepared" "Lingua distribution is already prepared, nevertheless, a full deployment will be forced by user request!"
  fi

  pop_directory
  pop_build_stage
}  # stage_unitex_lingua_dist

# =============================================================================
# stage_unitex_lingua
# =============================================================================
function stage_unitex_lingua() {
  push_stage "Ling"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  if [ $UNITEX_BUILD_SKIP_STAGE_LING -ne 0 ]; then
    log_info "Stage skipped" "This stage will be ignored as requested by the $UNITEX_BUILD_BUNDLE_NAME-bundle configuration"
    pop_directory   # "$UNITEX_BUILD_SOURCE_DIR"
    pop_build_stage  
    return 1
  fi   

  # 1. Lingua checkout
  stage_unitex_lingua_checkout

  # 2. Lingua check for updates
  stage_unitex_lingua_check_for_updates

  # 3.
  stage_unitex_lingua_dist

  pop_directory
  pop_build_stage
}  # stage_unitex_lingua()

# =============================================================================
# 
# =============================================================================
function stage_unitex_classic_ide_checkout () {
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  svn_checkout "--trust-server-cert --non-interactive --username anonsvn --password anonsvn" \
               "https://svnigm.univ-mlv.fr/svn/unitex/Unitex-Java"    \
               "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_NAME"
               
  svn_info    CLASSIC_IDE_SVN_CHECKOUT_DETAILS       \
              "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_NAME"
              
  # Saving SVN last date changed
  echo "${CLASSIC_IDE_SVN_CHECKOUT_DETAILS[2]}" > "$UNITEX_BUILD_TIMESTAMP_DIR/Java.current"

  pop_directory            
}  # stage_unitex_classic_ide_checkout()

# =============================================================================
# 
# =============================================================================
function stage_unitex_classic_ide_make() {
  push_directory "$UNITEX_BUILD_SOURCE_DIR"
    
  UNITEX_BUILD_CLASSIC_IDE_HAS_ERRORS=0
  if [ $UNITEX_BUILD_CLASSIC_IDE_UPDATE -ne 0 ]; then
    # we update the log file
    log_info "Updating"  "$UNITEX_BUILD_RELEASES_CHANGES_DIR/Java.txt"
    # shellcheck disable=SC2086
    svn log --trust-server-cert --non-interactive --username anonsvn --password anonsvn $UNITEX_BUILD_SVN_LOG_LIMIT_PARAMETER "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_NAME" > "$UNITEX_BUILD_RELEASE_DIR/Src/log_svn_Java.txt"
    cp "$UNITEX_BUILD_RELEASE_DIR/Src/log_svn_Java.txt" "$UNITEX_BUILD_RELEASES_CHANGES_DIR/Java.txt" 
    
    push_directory "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_LOCAL_PATH"
    rm -rf classes
    log_info "Compiling"  "Classic IDE sources"

    cp -r resources classes
    # we compile the sources
    # first, we compile normally
    exec_logged_command "javac.Unitex.java" "$UNITEX_BUILD_TOOL_JAVAC" -sourcepath src \
                     -classpath lib/xercesImpl.jar:lib/xmlParserAPIs.jar \
                     src/fr/umlv/unitex/Unitex.java \
                     src/fr/loria/xsilfide/multialign/MultiAlign.java \
                     -d classes -encoding UTF8
                     
    export UNITEX_BUILD_CLASSIC_IDE_JAVAC_SOURCE_HAS_ERRORS=$?
    # then, we look for .java files that may not have been compiled, because not used from
    # Unitex.java or MultiAlign.java
    while IFS= read -r -d '' file
    do
       export nom
       nom=$(echo -n "$file" | sed -e "s/.java$/.class/"| sed -e "s/^src/classes/")
       [ -f "$nom" ];
       if [ $? -eq 1 ]; then
        exec_logged_command "javac.$(basename "$file")" "$UNITEX_BUILD_TOOL_JAVAC" -sourcepath src \
                         -classpath lib/xercesImpl.jar:lib/xmlParserAPIs.jar \
                         "\"$file\"" \
                        -d classes -encoding UTF8
        if [ $? -ne 0 ]; then
          UNITEX_BUILD_CLASSIC_IDE_JAVAC_SOURCE_HAS_ERRORS=1
        fi
      fi
    done <  <(find src -name "*.java" -type f -print0)

    if [ $UNITEX_BUILD_CLASSIC_IDE_JAVAC_SOURCE_HAS_ERRORS -ne 0 ]; then
      UNITEX_BUILD_CLASSIC_IDE_HAS_ERRORS=1

      # Force update until the successful compilation of the code is assured
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CLASSIC_IDE_FORCE_UPDATE=./UNITEX_BUILD_CLASSIC_IDE_FORCE_UPDATE=2/'  \
                                 "$UNITEX_BUILD_CONFIG_FILENAME"

      log_error "Compilation failed" "Unitex Classical IDE sources do not compile"
    else
      # Release update lock
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CLASSIC_IDE_FORCE_UPDATE=2/UNITEX_BUILD_CLASSIC_IDE_FORCE_UPDATE=0/' \
                                 "$UNITEX_BUILD_CONFIG_FILENAME"
      log_info "Compilation finished" "Compilation completed successfully"      
    fi

    pop_directory  # "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_LOCAL_PATH"
  fi
  
  pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"
}  # stage_unitex_classic_ide_make()

# =============================================================================
# 
# =============================================================================
function stage_unitex_classic_ide_dist() {
  push_stage "ClassicDist"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  UNITEX_BUILD_CLASSIC_IDE_DEPLOYMENT=$(( ! UNITEX_BUILD_CLASSIC_IDE_HAS_ERRORS && ( UNITEX_BUILD_CLASSIC_IDE_FORCE_DEPLOYMENT  ||  UNITEX_BUILD_FORCE_DEPLOYMENT) ))
  if [ $UNITEX_BUILD_CLASSIC_IDE_DEPLOYMENT -eq 0 ]; then
    if [ $UNITEX_BUILD_CLASSIC_IDE_UPDATE     -ne 0 -a \
         $UNITEX_BUILD_CLASSIC_IDE_HAS_ERRORS -eq 0 ]; then
      UNITEX_BUILD_CLASSIC_IDE_DEPLOYMENT=1

      log_info "Preparing dist" "Classic IDE distribution is being prepared..."

      # FIXME(martinec) This is "classic_ide.revision.date"
      date "+%B %d, %Y" > "$UNITEX_BUILD_RELEASE_APP_DIR/revision.date"
      
      # we create the jar file
      log_info "Creating JARs" "Classic IDE sources"
      
      log_info "Creating JAR"  "Unitex.jar"
      rm -f "$UNITEX_BUILD_RELEASE_APP_DIR/Unitex.jar"
      exec_logged_command "jarcmd.Unitex" "$UNITEX_BUILD_TOOL_JAR" cvfm "$UNITEX_BUILD_RELEASE_APP_DIR/Unitex.jar" \
                       "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_NAME/classes/fr/umlv/unitex/Manifest.mf" \
                       -C "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_NAME/classes/" .

      # Sign Unitex.jar
      if [ -n "${UNITEX_BUILD_TOOL_JARSIGNER+1}" ]; then
        log_info "Signing" "Unitex.jar"                                                               
        exec_logged_command "signjar.sh.Unitex.jar" "signjar.sh" "$UNITEX_BUILD_RELEASE_APP_DIR/Unitex.jar" || {   \
          die_with_critical_error "Sign failed" "Error signing Unitex.jar"
        }
      fi   # [ -n "${UNITEX_BUILD_TOOL_JARSIGNER+1}" ]                       

      log_info "Creating JAR"  "XAlign.jar"
      rm -f "$UNITEX_BUILD_RELEASE_APP_DIR/XAlign.jar"
      exec_logged_command "jarcmd.XAlign" "$UNITEX_BUILD_TOOL_JAR" cvfm "$UNITEX_BUILD_RELEASE_APP_DIR/XAlign.jar" "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_NAME/classes/fr/loria/Manifest.mf" -C "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_NAME/classes/" .
      
      # we copy the icons
      log_info "Copying" "Icons resources"
      cp "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_NAME"/resources/*.ico "$UNITEX_BUILD_RELEASE_APP_DIR/"
      #we copy the library jars
      log_info "Copying" "Jar libraries"
      cp "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_NAME"/lib/*.jar "$UNITEX_BUILD_RELEASE_APP_DIR/"

      # Finally, we update the zip containing the source files
      log_info "Creating file"  "Java.zip"
      rm -f "$UNITEX_BUILD_RELEASE_DIR/Src/Java.zip" 
      push_directory "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_LOCAL_PATH"
      # shellcheck disable=SC2035
      exec_logged_command  "zipcmd.create.Java" "$UNITEX_BUILD_TOOL_ZIP" -r "$UNITEX_BUILD_RELEASE_DIR/Src/Java.zip" "src" -x *.svn*

      # DEPRECATED from Vinber v1.4.0
      # cp "$UNITEX_BUILD_RELEASE_DIR/Src/Java.zip" "$UNITEX_BUILD_RELEASES_SOURCE_DIR/"
      pop_directory  # "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_LOCAL_PATH"
      
      log_info "Dist prepared" "Classic IDE distribution is now prepared"
    fi
  else
    log_notice "Dist prepared" "Classic IDE  distribution is already prepared, nevertheless, a full deployment will be forced by user request!"
  fi
  
  
  pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"
  pop_build_stage
}  # stage_unitex_classic_ide_dist

# =============================================================================
# 
# =============================================================================
# stage_unitex_classic_ide
function stage_unitex_classic_ide() {
  push_stage "ClassicIDE"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  if [ $UNITEX_BUILD_SKIP_STAGE_CLASSIC_IDE -ne 0 ]; then
    log_info "Stage skipped" "This stage will be ignored as requested by the $UNITEX_BUILD_BUNDLE_NAME-bundle configuration"
    pop_directory   # "$UNITEX_BUILD_SOURCE_DIR"
    pop_build_stage  
    return 1
  fi 

  # 1. Classical IDE checkout
  stage_unitex_classic_ide_checkout

  # 2. Classical IDE check for updates
  check_for_updates  UNITEX_BUILD_CLASSIC_IDE_UPDATE "Java" \
                    $UNITEX_BUILD_CLASSIC_IDE_FORCE_UPDATE  

  # 3. Classical IDE make
  stage_unitex_classic_ide_make

  # 4. Classical IDE prepare dist
  stage_unitex_classic_ide_dist

  pop_directory
  pop_build_stage
}  # stage_unitex_classic_ide()


# =============================================================================
# 
# =============================================================================
function stage_unitex_gramlab_ide_checkout () {
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  svn_checkout "--trust-server-cert --non-interactive --username anonsvn --password anonsvn" \
               "https://svnigm.univ-mlv.fr/svn/unitex/GramLab"                               \
               "$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_NAME"
               
  svn_info    GRAMLAB_IDE_SVN_CHECKOUT_DETAILS       \
              "$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_NAME"
              
  # Saving SVN last date changed
  echo "${GRAMLAB_IDE_SVN_CHECKOUT_DETAILS[2]}" > "$UNITEX_BUILD_TIMESTAMP_DIR/$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_NAME.current"

  pop_directory
}  # stage_unitex_gramlab_ide_checkout()

# =============================================================================
# 
# =============================================================================
function stage_unitex_gramlab_ide_make () {
  push_directory "$UNITEX_BUILD_SOURCE_DIR"
  
  UNITEX_BUILD_GRAMLAB_IDE_HAS_ERRORS=0 
  if [ $UNITEX_BUILD_GRAMLAB_IDE_UPDATE     -ne 0 -a \
       $UNITEX_BUILD_CLASSIC_IDE_HAS_ERRORS -eq 0 ]; then
    
    # Gramlab depends of Unitex.jar
    if [ -e "$UNITEX_BUILD_RELEASE_APP_DIR/Unitex.jar" ]; then
      # we update the log file
      log_info "Updating"  "$UNITEX_BUILD_RELEASES_CHANGES_DIR/Gramlab.txt"
      svn log --trust-server-cert --non-interactive --username anonsvn --password anonsvn "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_NAME" > "$UNITEX_BUILD_RELEASE_DIR/Src/log_svn_Gramlab.txt"
      # keep the forked gramlab-ideling repository log
      cat "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_NAME/gramlab-ideling_r1-r1139_history.txt" >> "$UNITEX_BUILD_RELEASE_DIR/Src/log_svn_Gramlab.txt"
      cp "$UNITEX_BUILD_RELEASE_DIR/Src/log_svn_Gramlab.txt" "$UNITEX_BUILD_RELEASES_CHANGES_DIR/Gramlab.txt" 
      
      push_directory "$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_LOCAL_PATH"
      rm -rf classes
      log_info "Compiling" "GramLab IDE sources"
      
      cp -r src/main/resources/ classes
      # we compile the sources
      exec_logged_command "javac.Gramlab.jar" "$UNITEX_BUILD_TOOL_JAVAC" \
                       -sourcepath src/main/java \
                       -classpath "$UNITEX_BUILD_RELEASE_APP_DIR/Unitex.jar" \
                       src/main/java/fr/gramlab/Main.java \
                       -d classes -encoding UTF8 || {
                       UNITEX_BUILD_GRAMLAB_IDE_HAS_ERRORS=1
                     }

      if [ $UNITEX_BUILD_GRAMLAB_IDE_HAS_ERRORS -ne 0 ]; then
        # Force update until the successful compilation of the code is assured
        $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CLASSIC_IDE_FORCE_UPDATE=./UNITEX_BUILD_CLASSIC_IDE_FORCE_UPDATE=2/'  \
                                   "$UNITEX_BUILD_CONFIG_FILENAME"
        $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_GRAMLAB_IDE_FORCE_UPDATE=./UNITEX_BUILD_GRAMLAB_IDE_FORCE_UPDATE=2/'  \
                                   "$UNITEX_BUILD_CONFIG_FILENAME"
        log_error "Compilation failed" "Unitex GramLab IDE sources do not compile"
      else
        # Release update lock
        $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CLASSIC_IDE_FORCE_UPDATE=2/UNITEX_BUILD_CLASSIC_IDE_FORCE_UPDATE=0/' \
                                   "$UNITEX_BUILD_CONFIG_FILENAME"      
        $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_GRAMLAB_IDE_FORCE_UPDATE=2/UNITEX_BUILD_GRAMLAB_IDE_FORCE_UPDATE=0/' \
                                   "$UNITEX_BUILD_CONFIG_FILENAME"
        log_info "Compilation finished" "Compilation completed successfully"      
      fi
    else
        log_error "Compilation failed" "Unitex.jar not found! GramLab IDE will not compile"
    fi    

    pop_directory  # "$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_LOCAL_PATH"
  fi  

  pop_directory # "$UNITEX_BUILD_SOURCE_DIR"
}  # stage_unitex_gramlab_ide_make()

# =============================================================================
# 
# =============================================================================
function stage_unitex_gramlab_ide_dist() {
  push_stage "GramLabDist"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  UNITEX_BUILD_GRAMLAB_IDE_DEPLOYMENT=$(( ! UNITEX_BUILD_CLASSIC_IDE_HAS_ERRORS && ! UNITEX_BUILD_GRAMLAB_IDE_HAS_ERRORS && ( UNITEX_BUILD_GRAMLAB_IDE_FORCE_DEPLOYMENT  ||  UNITEX_BUILD_FORCE_DEPLOYMENT ) ))
  if [ $UNITEX_BUILD_GRAMLAB_IDE_DEPLOYMENT -eq 0 ]; then
    if [ $UNITEX_BUILD_GRAMLAB_IDE_UPDATE     -ne 0 -a \
         $UNITEX_BUILD_CLASSIC_IDE_HAS_ERRORS -eq 0 -a \
         $UNITEX_BUILD_GRAMLAB_IDE_HAS_ERRORS -eq 0 ]; then
      UNITEX_BUILD_GRAMLAB_IDE_DEPLOYMENT=1   
      log_info "Preparing dist" "GramLab IDE distribution is being prepared..."

      date "+%B %d, %Y" > "$UNITEX_BUILD_RELEASE_APP_DIR/gramlab_revision.date"

      log_info "Creating JAR"  "Gramlab.jar"
      rm -f "$UNITEX_BUILD_RELEASE_APP_DIR/Gramlab.jar"
      exec_logged_command "jarcmd.Gramlab" "$UNITEX_BUILD_TOOL_JAR" cvfm "$UNITEX_BUILD_RELEASE_APP_DIR/Gramlab.jar" \
                       "$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_NAME/classes/fr/gramlab/Manifest.mf" \
                       -C "$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_NAME/classes/" .
      
      # Sign Gramlab.jar
      if [ -n "${UNITEX_BUILD_TOOL_JARSIGNER+1}" ]; then
        log_info "Signing" "Gramlab.jar"                                                               
        exec_logged_command "signjar.sh.Gramlab.jar" "signjar.sh" "$UNITEX_BUILD_RELEASE_APP_DIR/Gramlab.jar" || {   \
          die_with_critical_error "Sign failed" "Error signing Gramlab.jar"
        }
      fi   # [ -n "${UNITEX_BUILD_TOOL_JARSIGNER+1}" ]   

      log_info "Copying" "Gramlab pom files"
      cp  "$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_NAME"/maven/pom.xml "$UNITEX_BUILD_RELEASE_APP_DIR/pom.xml"
      mkdir -p "$UNITEX_BUILD_RELEASE_APP_DIR/assembly/src/main/resources/assemblies"
      cp "$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_NAME"/maven/assembly/pom.xml "$UNITEX_BUILD_RELEASE_APP_DIR/assembly/" 
      cp "$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_NAME"/maven/assembly/src/main/resources/assemblies/create-base-package.xml "$UNITEX_BUILD_RELEASE_APP_DIR/assembly/src/main/resources/assemblies/" 
      
      log_info "Dist prepared"  "GramLab IDE distribution is now prepared"
    fi
  else
    log_notice "Dist prepared" "GramLab IDE distribution is already prepared,  nevertheless, a full deployment will be forced by user request!"
  fi

  pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"
  pop_build_stage
}  # stage_unitex_classic_ide_dist    

# =============================================================================
# 
# =============================================================================
# stage_unitex_gramlab_ide
function stage_unitex_gramlab_ide() {
  push_stage "GramLabIDE"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  if [ $UNITEX_BUILD_SKIP_STAGE_GRAMLAB_IDE -ne 0 ]; then
    log_info "Stage skipped" "This stage will be ignored as requested by the $UNITEX_BUILD_BUNDLE_NAME-bundle configuration"
    pop_directory   # "$UNITEX_BUILD_SOURCE_DIR"
    pop_build_stage  
    return 1
  fi   

  # 1. GramLab IDE checkout
  stage_unitex_gramlab_ide_checkout

  # 2. GramLab IDE check for updates
  check_for_updates UNITEX_BUILD_GRAMLAB_IDE_UPDATE "$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_NAME" \
                    $UNITEX_BUILD_GRAMLAB_IDE_FORCE_UPDATE    \
                    $UNITEX_BUILD_CLASSIC_IDE_UPDATE

  if [  $UNITEX_BUILD_CLASSIC_IDE_HAS_ERRORS -eq 0 ]; then
    # 3. GramLab IDE make
    stage_unitex_gramlab_ide_make
  else
    log_warn "Compilation skipped" "Unitex Classical IDE sources do not compile hence GramLab IDE will not be compiled!"
  fi  

  # 4. GramLab IDE prepare dist
  stage_unitex_gramlab_ide_dist

  pop_directory
  pop_build_stage
}  # stage_unitex_gramlab_ide()


# =============================================================================
# 
# =============================================================================
function stage_unitex_core_logs_checkout() {
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  svn_checkout "--trust-server-cert --non-interactive --username anonsvn --password anonsvn" \
               "https://svnigm.univ-mlv.fr/svn/unitex/logs"           \
               "$UNITEX_BUILD_REPOSITORY_LOGS_NAME"
               
  svn_info    LOGS_SVN_CHECKOUT_DETAILS \
              "$UNITEX_BUILD_REPOSITORY_LOGS_NAME"
              
  # Saving SVN last date changed
  echo "${LOGS_SVN_CHECKOUT_DETAILS[2]}" > "$UNITEX_BUILD_TIMESTAMP_DIR/$UNITEX_BUILD_REPOSITORY_LOGS_NAME.current"

  pop_directory            
}  # stage_unitex_core_logs_checkout()

# =============================================================================
# 
# =============================================================================
function stage_unitex_core_logs() {
  push_stage "CoreTest"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  if [ $UNITEX_BUILD_SKIP_STAGE_LOGS -ne 0 ]; then
    log_info "Stage skipped" "This stage will be ignored as requested by the $UNITEX_BUILD_BUNDLE_NAME-bundle configuration"
    pop_directory   # "$UNITEX_BUILD_SOURCE_DIR"
    pop_build_stage  
    return 1
  fi
  
  # 1. Logs checkout
  stage_unitex_core_logs_checkout

  # 2. Logs check for updates
  check_for_updates UNITEX_BUILD_LOGS_UPDATE "$UNITEX_BUILD_REPOSITORY_LOGS_NAME" \
                    $UNITEX_BUILD_LOGS_FORCE_UPDATE

  # 3.                  

  pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"
  pop_build_stage 
}  # function stage_unitex_core_logs()


# =============================================================================
# 
# =============================================================================
function stage_unitex_core_update_source_revision_header() {
  push_stage "Core"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"
  
  CORE_SOURCE_LAST_REVISION=$1
  CORE_SOURCE_REVISION_HEADER="$UNITEX_BUILD_REPOSITORY_CORE_NAME/Unitex_revision.h"

  log_info     "Updating header" "Updating file $CORE_SOURCE_REVISION_HEADER to Rev. $CORE_SOURCE_LAST_REVISION"

  (echo "/*
         * Unitex
         *
         * Copyright (C) 2001-$(date '+%Y') Université Paris-Est Marne-la-Vallée <unitex@univ-mlv.fr>
         *
         * This library is free software; you can redistribute it and/or
         * modify it under the terms of the GNU Lesser General Public
         * License as published by the Free Software Foundation; either
         * version 2.1 of the License, or (at your option) any later version.
         *
         * This library is distributed in the hope that it will be useful,
         * but WITHOUT ANY WARRANTY; without even the implied warranty of
         * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the GNU
         * Lesser General Public License for more details.
         *
         * You should have received a copy of the GNU Lesser General Public
         * License along with this library; if not, write to the Free Software
         * Foundation, Inc., 59 Temple Place, Suite 330, Boston, MA  02111-1307  USA.
         *
         */
        /**
         * @file      Unitex_revision.h
         * @brief     Defines the current Unitex Core revision as the default revision
         *            
         * @author    $UNITEX_BUILD_VINBER_CODENAME Process
         * 
         * @note      This file was overwritten by $UNITEX_BUILD_VINBER_CODENAME. $UNITEX_BUILD_VINBER_CODENAME is the
         *            $UNITEX_BUILD_VINBER_DESCRIPTION
         *            $UNITEX_BUILD_VINBER_REPOSITORY_URL
         *          
         * @date      $(date '+%B %d, %Y')
         * 
         */
        /* ************************************************************************** */ 
        #ifndef UnitexRevisionH                                             // NOLINT
        #define UnitexRevisionH                                             // NOLINT
        /* ************************************************************************** */
        #define UNITEX_REVISION       $CORE_SOURCE_LAST_REVISION
        #define UNITEXREVISION        $CORE_SOURCE_LAST_REVISION
        #define UNITEX_REVISION_TEXT \"$CORE_SOURCE_LAST_REVISION\"
        /* ************************************************************************** */
        #endif  // UnitexRevisionH                                          // NOLINT
        "
        )                   \
        | sed -e 's:^\s*::g ; s|^\*| *|g' \
  > "$CORE_SOURCE_REVISION_HEADER"

  pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"
  pop_build_stage 
}  # stage_unitex_core_update_source_revision_header

# =============================================================================
# 
# =============================================================================
function stage_unitex_core_make() {
  push_stage "Core"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  UNITEX_BUILD_CORE_HAS_ERRORS=0
  if [ $UNITEX_BUILD_CORE_UPDATE -ne 0 ]; then
    # Saving SVN last revision changed
    stage_unitex_core_update_source_revision_header "${CORE_SVN_CHECKOUT_DETAILS[0]}"

    # we update the log file
    log_info "Updating"  "$UNITEX_BUILD_RELEASE_DIR/Src/log_svn_C++.txt"
    # shellcheck disable=SC2086
    svn log --trust-server-cert --non-interactive --username anonsvn --password anonsvn $UNITEX_BUILD_SVN_LOG_LIMIT_PARAMETER "$UNITEX_BUILD_REPOSITORY_CORE_NAME" > "$UNITEX_BUILD_RELEASE_DIR/Src/log_svn_C++.txt"
    cp "$UNITEX_BUILD_RELEASE_DIR/Src/log_svn_C++.txt" "$UNITEX_BUILD_RELEASES_CHANGES_DIR/C++.txt" 
    
    #then, we check if the C++ sources could be compiled

    # MinGW32
    UNITEX_BUILD_CORE_WIN32_DIR="$UNITEX_BUILD_TEMPORAL_WORKSPACE/$UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME/$UNITEX_BUILD_RELEASES_WIN32_HOME_NAME" 
    UNITEX_BUILD_CORE_WIN32_SOURCES_DIR="$UNITEX_BUILD_CORE_WIN32_DIR/$UNITEX_BUILD_REPOSITORY_CORE_NAME"
    stage_unitex_core_make_win32

    # MinGW64    
    UNITEX_BUILD_CORE_WIN64_DIR="$UNITEX_BUILD_TEMPORAL_WORKSPACE/$UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME/$UNITEX_BUILD_RELEASES_WIN64_HOME_NAME" 
    UNITEX_BUILD_CORE_WIN64_SOURCES_DIR="$UNITEX_BUILD_CORE_WIN64_DIR/$UNITEX_BUILD_REPOSITORY_CORE_NAME"
    stage_unitex_core_make_win64

    # OS X
    UNITEX_BUILD_CORE_OSX_DIR="$UNITEX_BUILD_TEMPORAL_WORKSPACE/$UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME/$UNITEX_BUILD_RELEASES_OSX_HOME_NAME"
    UNITEX_BUILD_CORE_OSX_SOURCES_DIR="$UNITEX_BUILD_CORE_OSX_DIR/$UNITEX_BUILD_REPOSITORY_CORE_NAME"
    stage_unitex_core_make_osx

    # Linux Intel (i686)
    UNITEX_BUILD_CORE_LINUX_I686_DIR="$UNITEX_BUILD_TEMPORAL_WORKSPACE/$UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME/$UNITEX_BUILD_RELEASES_LINUX_I686_HOME_NAME"
    UNITEX_BUILD_CORE_LINUX_I686_SOURCES_DIR="$UNITEX_BUILD_CORE_LINUX_I686_DIR/$UNITEX_BUILD_REPOSITORY_CORE_NAME"
    stage_unitex_core_make_linux_i686    

    # Linux Intel 64-bit (x86_64) debug
    UNITEX_BUILD_CORE_LINUX_X86_64_DEBUG_DIR="$UNITEX_BUILD_TEMPORAL_WORKSPACE/$UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME/$UNITEX_BUILD_RELEASES_LINUX_X86_64_HOME_NAME-debug"
    UNITEX_BUILD_CORE_LINUX_X86_64_DEBUG_SOURCES_DIR="$UNITEX_BUILD_CORE_LINUX_X86_64_DEBUG_DIR/$UNITEX_BUILD_REPOSITORY_CORE_NAME"
    stage_unitex_core_make_linux_x86_64_debug

    # Linux Intel 64-bit (x86_64)
    UNITEX_BUILD_CORE_LINUX_X86_64_DIR="$UNITEX_BUILD_TEMPORAL_WORKSPACE/$UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME/$UNITEX_BUILD_RELEASES_LINUX_X86_64_HOME_NAME"
    UNITEX_BUILD_CORE_LINUX_X86_64_SOURCES_DIR="$UNITEX_BUILD_CORE_LINUX_X86_64_DIR/$UNITEX_BUILD_REPOSITORY_CORE_NAME"
    stage_unitex_core_make_linux_x86_64
  fi

  pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"
  pop_build_stage 
}  # stage_unitex_core_check_for_updates

# =============================================================================
# Win32
# =============================================================================
function stage_unitex_core_make_win32() {
  push_stage "Core"
  # create a build environment for this platform
  if [ ! -d "${UNITEX_BUILD_CORE_WIN32_DIR:?}" ]
  then    
    # try to create the directory
    mkdir -p "${UNITEX_BUILD_CORE_WIN32_DIR:?}" || {
      die_with_critical_error "Aborting" "Failed to create a directory in ${UNITEX_BUILD_CORE_WIN32_DIR:?}"
    }

    push_directory "$UNITEX_BUILD_SOURCE_DIR"

    # try to copy source files
    cp    -r "${UNITEX_BUILD_REPOSITORY_CORE_NAME:?}" "${UNITEX_BUILD_CORE_WIN32_DIR:?}" || {
     die_with_critical_error "Compilation failed" "There was a problem copying $UNITEX_BUILD_REPOSITORY_CORE_NAME to $UNITEX_BUILD_CORE_WIN32_DIR" 
    }
    
    pop_directory  # "$UNITEX_BUILD_SOURCE_DIR" 
  fi  # [ ! -d "${UNITEX_BUILD_CORE_WIN32_DIR:?}" ]

  push_directory "$UNITEX_BUILD_CORE_WIN32_SOURCES_DIR/build"
  
  if [ $UNITEX_BUILD_CORE_UPDATE     -ne 0 -a \
       $UNITEX_BUILD_CORE_HAS_ERRORS -eq 0 ]; then
    # ensure that we remove all binary objects
    log_notice "Cleaning" "Win32 Unitex Core sources will be cleaned up";
    exec_logged_command "make.mingw32.clean"  "$UNITEX_BUILD_TOOL_MAKE" COMMANDPREFIXDEFINED=yes COMMANDPREFIX=$UNITEX_BUILD_MINGW32_COMMAND_PREFIX ADDITIONAL_CFLAG+="'-DUNITEX_PREVENT_USING_WINRT_API -static -static-libgcc -static-libstdc++'" SYSTEM=mingw32 clean

    log_notice "Compiling" "Win32 Unitex Core Tool Logger";
    local unitex_core_make_fail=0
    exec_logged_command "make.mingw32.unitextoolloggeronly" "$UNITEX_BUILD_TOOL_MAKE" COMMANDPREFIXDEFINED=yes COMMANDPREFIX=$UNITEX_BUILD_MINGW32_COMMAND_PREFIX ADDITIONAL_CFLAG+="'-DUNITEX_PREVENT_USING_WINRT_API -static -static-libgcc -static-libstdc++'" SYSTEM=mingw32 \
                     UNITEXTOOLLOGGERONLY=yes || {
                       unitex_core_make_fail=1
                     }
                     
    if [ $unitex_core_make_fail -ne 0 ]; then
      UNITEX_BUILD_CORE_HAS_ERRORS=1
      # Force update until the successful compilation of the code is assured
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CORE_FORCE_UPDATE=./UNITEX_BUILD_CORE_FORCE_UPDATE=2/'  \
                                 "$UNITEX_BUILD_CONFIG_FILENAME"
      log_error "Compilation failed" "Win32 Unitex Core source do not compile"
    else
      # Release update lock
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CORE_FORCE_UPDATE=2/UNITEX_BUILD_CORE_FORCE_UPDATE=0/' \
                                 "$UNITEX_BUILD_CONFIG_FILENAME"
      log_info "Compilation finished" "Compilation completed successfully"
    fi
  fi

  pop_directory  # "$UNITEX_BUILD_CORE_WIN32_SOURCES_DIR/build"
  pop_build_stage
}

# =============================================================================
# Win64
# =============================================================================
function stage_unitex_core_make_win64() {
  push_stage "Core"
  # create a build environment for this platform
  if [ ! -d "${UNITEX_BUILD_CORE_WIN64_DIR:?}" ]
  then    
    # try to create the directory
    mkdir -p "${UNITEX_BUILD_CORE_WIN64_DIR:?}" || {
      die_with_critical_error "Aborting" "Failed to create a directory in ${UNITEX_BUILD_CORE_WIN64_DIR:?}"
    }

    push_directory "$UNITEX_BUILD_SOURCE_DIR"

    # try to copy source files
    cp    -r "${UNITEX_BUILD_REPOSITORY_CORE_NAME:?}" "${UNITEX_BUILD_CORE_WIN64_DIR:?}" || {
     die_with_critical_error "Compilation failed" "There was a problem copying $UNITEX_BUILD_REPOSITORY_CORE_NAME to $UNITEX_BUILD_CORE_WIN64_DIR" 
    }
    
    pop_directory  # "$UNITEX_BUILD_SOURCE_DIR" 
  fi  # [ ! -d "${UNITEX_BUILD_CORE_WIN64_DIR:?}" ]

  push_directory "$UNITEX_BUILD_CORE_WIN64_SOURCES_DIR/build"
  
  if [ $UNITEX_BUILD_CORE_UPDATE     -ne 0 -a \
       $UNITEX_BUILD_CORE_HAS_ERRORS -eq 0 ]; then
    # ensure that we remove all binary objects
    log_notice "Cleaning" "Win64 Unitex Core sources will be cleaned up";
    exec_logged_command "make.mingw32.clean"  "$UNITEX_BUILD_TOOL_MAKE" 64BITS=yes COMMANDPREFIXDEFINED=yes COMMANDPREFIX=$UNITEX_BUILD_MINGW64_COMMAND_PREFIX ADDITIONAL_CFLAG+="'-DUNITEX_PREVENT_USING_WINRT_API -m64 -static -static-libgcc -static-libstdc++'" SYSTEM=mingw32 clean

    log_notice "Compiling" "Win64 Unitex Core Tool Logger";
    local unitex_core_make_fail=0
    exec_logged_command "make.mingw32.unitextoolloggeronly" "$UNITEX_BUILD_TOOL_MAKE" 64BITS=yes COMMANDPREFIXDEFINED=yes COMMANDPREFIX=$UNITEX_BUILD_MINGW64_COMMAND_PREFIX ADDITIONAL_CFLAG+="'-DUNITEX_PREVENT_USING_WINRT_API -m64 -static -static-libgcc -static-libstdc++'" SYSTEM=mingw32 \
                     UNITEXTOOLLOGGERONLY=yes || {
                       unitex_core_make_fail=1
                     }
                     
    if [ $unitex_core_make_fail -ne 0 ]; then
      UNITEX_BUILD_CORE_HAS_ERRORS=1
      # Force update until the successful compilation of the code is assured
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CORE_FORCE_UPDATE=./UNITEX_BUILD_CORE_FORCE_UPDATE=2/'  \
                                 "$UNITEX_BUILD_CONFIG_FILENAME"
      log_error "Compilation failed" "Win64 Unitex Core Tool Logger do not compile"
    else
      # Release update lock
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CORE_FORCE_UPDATE=2/UNITEX_BUILD_CORE_FORCE_UPDATE=0/' \
                                 "$UNITEX_BUILD_CONFIG_FILENAME"
      log_info "Compilation finished" "Compilation completed successfully"
    fi
  fi

  pop_directory  # "$UNITEX_BUILD_CORE_WIN64_SOURCES_DIR/build"
  pop_build_stage
}  

# =============================================================================
# OS X
# =============================================================================
function stage_unitex_core_make_osx() {
  push_stage "Core"
  
  # create a build environment for this platform
  if [ ! -d "${UNITEX_BUILD_CORE_OSX_DIR:?}" ]
  then
    # try to create the directory
    mkdir -p "${UNITEX_BUILD_CORE_OSX_DIR:?}" || {
      die_with_critical_error "Aborting" "Failed to create a directory in ${UNITEX_BUILD_CORE_OSX_DIR:?}"
    }

    push_directory "$UNITEX_BUILD_SOURCE_DIR"

    # try to copy source files
    cp    -r "${UNITEX_BUILD_REPOSITORY_CORE_NAME:?}" "${UNITEX_BUILD_CORE_OSX_DIR:?}" || {
     die_with_critical_error "Compilation failed" "There was a problem copying $UNITEX_BUILD_REPOSITORY_CORE_NAME to $UNITEX_BUILD_CORE_OSX_DIR" 
    }
    
    pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"
  fi  # [ ! -d "${UNITEX_BUILD_CORE_OSX_DIR:?}" ]

  push_directory "$UNITEX_BUILD_CORE_OSX_SOURCES_DIR/build"
  
  if [ $UNITEX_BUILD_CORE_UPDATE     -ne 0 -a \
       $UNITEX_BUILD_CORE_HAS_ERRORS -eq 0 ]; then
    # ensure that we remove all binary objects
    log_notice "Cleaning" "OS X Unitex Core sources will be cleaned up";
    exec_logged_command "make.osxcross.clean" "$UNITEX_BUILD_TOOL_MAKE" SYSTEM=osxcross clean

    log_notice "Compiling" "OS X Unitex Core Tool Logger";
    local unitex_core_make_fail=0
    exec_logged_command "make.osxcross.debug.unitextoolloggeronly" "$UNITEX_BUILD_TOOL_MAKE" SYSTEM=osxcross \
                   UNITEXTOOLLOGGERONLY=yes || {
                     unitex_core_make_fail=1
                   }

    if [ $unitex_core_make_fail -ne 0 ]; then
      UNITEX_BUILD_CORE_HAS_ERRORS=1
      # Force update until the successful compilation of the code is assured
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CORE_FORCE_UPDATE=./UNITEX_BUILD_CORE_FORCE_UPDATE=2/'  \
                                 "$UNITEX_BUILD_CONFIG_FILENAME"
      log_error "Compilation failed" "OS X Unitex Core sources do not compile"
    else
      # Release update lock
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CORE_FORCE_UPDATE=2/UNITEX_BUILD_CORE_FORCE_UPDATE=0/' \
                                 "$UNITEX_BUILD_CONFIG_FILENAME"    
      log_info "Compilation finished" "Compilation completed successfully"
    fi    
  fi

  pop_directory  # "$UNITEX_BUILD_CORE_OSX_SOURCES_DIR/build"
  pop_build_stage
}

# =============================================================================
# Linux Intel (i686)
# =============================================================================
function stage_unitex_core_make_linux_i686() {
  push_stage "Core"
  
  # create a build environment for this platform
  if [ ! -d "${UNITEX_BUILD_CORE_LINUX_I686_DIR:?}" ]
  then
    # try to create the directory
    mkdir -p "${UNITEX_BUILD_CORE_LINUX_I686_DIR:?}" || {
      die_with_critical_error "Aborting" "Failed to create a directory in ${UNITEX_BUILD_CORE_LINUX_I686_DIR:?}"
    }

    push_directory "$UNITEX_BUILD_SOURCE_DIR"

    # try to copy source files
    cp    -r "${UNITEX_BUILD_REPOSITORY_CORE_NAME:?}" "${UNITEX_BUILD_CORE_LINUX_I686_DIR:?}" || {
     die_with_critical_error "Compilation failed" "There was a problem copying $UNITEX_BUILD_REPOSITORY_CORE_NAME to $UNITEX_BUILD_CORE_LINUX_I686_DIR" 
    }

    pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"
  fi  # [ ! -d "${UNITEX_BUILD_CORE_LINUX_I686_DIR:?}" ]

  push_directory "$UNITEX_BUILD_CORE_LINUX_I686_SOURCES_DIR/build"
  
  if [ $UNITEX_BUILD_CORE_UPDATE     -ne 0 -a \
       $UNITEX_BUILD_CORE_HAS_ERRORS -eq 0 ]; then
    # ensure that we remove all binary objects
    log_notice "Cleaning" "Linux Intel (i686) Unitex Core sources will be cleaned up";
    exec_logged_command "make.linux.clean" "$UNITEX_BUILD_TOOL_MAKE" TRE_DIRECT_COMPILE=yes ADDITIONAL_CFLAG+="'-m32 -static -static-libgcc -static-libstdc++'"  64BITS=no TRE_CONFIGURE_OPTION="--host=i686-pc-linux-gnu"  clean

    log_notice "Compiling" "Linux Intel (i686) Unitex Core Tool Logger";
    local unitex_core_make_fail=0
    exec_logged_command "make.linux.debug.unitextoolloggeronly" "$UNITEX_BUILD_TOOL_MAKE"  TRE_DIRECT_COMPILE=yes ADDITIONAL_CFLAG+="'-m32 -static -static-libgcc -static-libstdc++'"  64BITS=no TRE_CONFIGURE_OPTION="--host=i686-pc-linux-gnu" \
                   UNITEXTOOLLOGGERONLY=yes || {
                     unitex_core_make_fail=1
                   }

    if [ $unitex_core_make_fail -ne 0 ]; then
      UNITEX_BUILD_CORE_HAS_ERRORS=1
      # Force update until the successful compilation of the code is assured
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CORE_FORCE_UPDATE=./UNITEX_BUILD_CORE_FORCE_UPDATE=2/'  \
                                 "$UNITEX_BUILD_CONFIG_FILENAME"
      log_error "Compilation failed" "Linux Intel (i686) Unitex Core sources do not compile"
    else
      # Release update lock
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CORE_FORCE_UPDATE=2/UNITEX_BUILD_CORE_FORCE_UPDATE=0/' \
                                 "$UNITEX_BUILD_CONFIG_FILENAME"    
      log_info "Compilation finished" "Compilation completed successfully"
    fi    
  fi

  pop_directory  # "$UNITEX_BUILD_CORE_LINUX_I686_SOURCES_DIR/build"
  pop_build_stage
}

# =============================================================================
# Linux Intel 64-bit (x86_64) debug
# =============================================================================
function stage_unitex_core_make_linux_x86_64_debug() {
  push_stage "Core"
  
  # create a build environment for this platform
  if [ ! -d "${UNITEX_BUILD_CORE_LINUX_X86_64_DEBUG_DIR:?}" ]
  then
    # try to create the directory
    mkdir -p "${UNITEX_BUILD_CORE_LINUX_X86_64_DEBUG_DIR:?}" || {
      die_with_critical_error "Aborting" "Failed to create a directory in ${UNITEX_BUILD_CORE_LINUX_X86_64_DEBUG_DIR:?}"
    }

    push_directory "$UNITEX_BUILD_SOURCE_DIR"

    # try to copy source files
    cp    -r "${UNITEX_BUILD_REPOSITORY_CORE_NAME:?}" "${UNITEX_BUILD_CORE_LINUX_X86_64_DEBUG_DIR:?}" || {
     die_with_critical_error "Compilation failed" "There was a problem copying $UNITEX_BUILD_REPOSITORY_CORE_NAME to $UNITEX_BUILD_CORE_LINUX_X86_64_DEBUG_DIR" 
    }

    pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"
  fi  # [ ! -d "${UNITEX_BUILD_CORE_LINUX_X86_64_DEBUG_DIR:?}" ]

  push_directory "$UNITEX_BUILD_CORE_LINUX_X86_64_DEBUG_SOURCES_DIR/build"
  
  if [ $UNITEX_BUILD_CORE_UPDATE     -ne 0 -a \
       $UNITEX_BUILD_CORE_HAS_ERRORS -eq 0 ]; then
    # ensure that we remove all binary objects
    log_notice "Cleaning" "Linux Intel 64-bit (x86_64) (with debug info) Unitex Core sources will be cleaned up";
    exec_logged_command "make.linux.clean"    "$UNITEX_BUILD_TOOL_MAKE" SYSTEM=linux-like 64BITS=yes clean

    log_notice "Compiling" "Linux Intel 64-bit (x86_64) (with debug info) Unitex Core Tool Logger";
    local unitex_core_make_fail=0
    exec_logged_command "make.linux.debug.unitextoolloggeronly" "$UNITEX_BUILD_TOOL_MAKE" SYSTEM=linux-like 64BITS=yes DEBUG=yes \
                   UNITEXTOOLLOGGERONLY=yes || {
                     unitex_core_make_fail=1
                   }

    if [ $unitex_core_make_fail -ne 0 ]; then
      UNITEX_BUILD_CORE_HAS_ERRORS=1
      # Force update until the successful compilation of the code is assured
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CORE_FORCE_UPDATE=./UNITEX_BUILD_CORE_FORCE_UPDATE=2/'  \
                                 "$UNITEX_BUILD_CONFIG_FILENAME"
      log_error "Compilation failed" "Linux Intel 64-bit (x86_64) (with debug info) Unitex Core sources do not compile"
    else
      # Release update lock
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CORE_FORCE_UPDATE=2/UNITEX_BUILD_CORE_FORCE_UPDATE=0/' \
                                 "$UNITEX_BUILD_CONFIG_FILENAME"    
      log_info "Compilation finished" "Compilation completed successfully"
    fi    
  fi

  pop_directory  # "$UNITEX_BUILD_CORE_LINUX_X86_64_DEBUG_SOURCES_DIR/build"
  pop_build_stage
}

# =============================================================================
# Linux Intel 64-bit (x86_64)
# =============================================================================
function stage_unitex_core_make_linux_x86_64() {
  push_stage "Core"
  
  # create a build environment for this platform
  if [ ! -d "${UNITEX_BUILD_CORE_LINUX_X86_64_DIR:?}" ]
  then
    # try to create the directory
    mkdir -p "${UNITEX_BUILD_CORE_LINUX_X86_64_DIR:?}" || {
      die_with_critical_error "Aborting" "Failed to create a directory in ${UNITEX_BUILD_CORE_LINUX_X86_64_DIR:?}"
    }

    push_directory "$UNITEX_BUILD_SOURCE_DIR"

    # try to copy source files
    cp    -r "${UNITEX_BUILD_REPOSITORY_CORE_NAME:?}" "${UNITEX_BUILD_CORE_LINUX_X86_64_DIR:?}" || {
     die_with_critical_error "Compilation failed" "There was a problem copying $UNITEX_BUILD_REPOSITORY_CORE_NAME to $UNITEX_BUILD_CORE_LINUX_X86_64_DIR" 
    }

    pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"
  fi  # [ ! -d "${UNITEX_BUILD_CORE_LINUX_X86_64_DIR:?}" ]

  push_directory "$UNITEX_BUILD_CORE_LINUX_X86_64_SOURCES_DIR/build"
  
  if [ $UNITEX_BUILD_CORE_UPDATE     -ne 0 -a \
       $UNITEX_BUILD_CORE_HAS_ERRORS -eq 0 ]; then
    # ensure that we remove all binary objects
    log_notice "Cleaning" "Linux Intel 64-bit (x86_64) Unitex Core sources will be cleaned up";
    exec_logged_command "make.linux.clean" "$UNITEX_BUILD_TOOL_MAKE" SYSTEM=linux-like 64BITS=yes ADDITIONAL_CFLAG+="'-static -static-libgcc -static-libstdc++'" clean

    log_notice "Compiling" "Linux Intel 64-bit (x86_64) Unitex Core Tool Logger";
    local unitex_core_make_fail=0
    exec_logged_command "make.linux.debug.unitextoolloggeronly" "$UNITEX_BUILD_TOOL_MAKE" SYSTEM=linux-like 64BITS=yes ADDITIONAL_CFLAG+="'-static -static-libgcc -static-libstdc++'" \
                   UNITEXTOOLLOGGERONLY=yes || {
                     unitex_core_make_fail=1
                   }

    if [ $unitex_core_make_fail -ne 0 ]; then
      UNITEX_BUILD_CORE_HAS_ERRORS=1
      # Force update until the successful compilation of the code is assured
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CORE_FORCE_UPDATE=./UNITEX_BUILD_CORE_FORCE_UPDATE=2/'  \
                                 "$UNITEX_BUILD_CONFIG_FILENAME"
      log_error "Compilation failed" "Linux Intel 64-bit (x86_64) Unitex Core sources do not compile"
    else
      # Release update lock
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_CORE_FORCE_UPDATE=2/UNITEX_BUILD_CORE_FORCE_UPDATE=0/' \
                                 "$UNITEX_BUILD_CONFIG_FILENAME"    
      log_info "Compilation finished" "Compilation completed successfully"
    fi    
  fi

  pop_directory  # "$UNITEX_BUILD_CORE_LINUX_X86_64_SOURCES_DIR/build"
  pop_build_stage
}

# =============================================================================
#  options, url, path
#  0 : last_revision,
#  1 : last_committer
#  2 : last_date
#  3 : last_commit_message
#  4 : last_committer_email
# =============================================================================
function svn_info() {
  if [ $# -ne 2  ]; then
    die_with_critical_error "SVN info fails" \
     "Internal SVN info function called with the wrong number of parameters"
  fi
    
  local return_array=${1:?Return array name required}
  local svn_checkout_path=$2

  log_info "Getting info about"  "$(echo -n "$svn_checkout_path" | sed -e 's|^\(../\)*||g')"

  # SVN Last Commit Rev
  local -r svn_info_last_revision=$(svn info --trust-server-cert --non-interactive --username anonsvn --password anonsvn "$svn_checkout_path"  |\
                                 grep "Last Changed Rev"        |\
                                 cut "--delimiter= " --fields=4)
  log_debug "Last Changed Rev" "$svn_info_last_revision"

  # SVN Last Commit Hash
  local svn_info_last_commit="$svn_info_last_revision"
  log_info "Last Changed Commit" "$svn_info_last_commit"

  # SVN Last Commit Author
  # sed anonymize mail addresses (foo-at-bar.com => foo-at-b**.com)
  local svn_info_last_committer
  svn_info_last_committer=$(svn info --trust-server-cert --non-interactive --username anonsvn --password anonsvn "$svn_checkout_path"   |\
                            grep "Last Changed Author"      |\
                            cut "--delimiter= " --fields=4-)

  # author email
  local svn_info_last_author_email=""
  
  # author name
  local svn_info_last_author_name=""

  # Only if we have the last committer information
  if [ ! -z "$svn_info_last_committer" ]; then
    # If svn_info_last_committer doesn't contain already an email address
    if [[ "$svn_info_last_committer" != *"@"* ]]; then
       # Any character different from [a-zA-Z0-9_] will be replaced by _ to produce a valid
       # shell variable
       local -r normalized_committer_name=$(echo "$svn_info_last_committer" | tr '[:upper:]' '[:lower:]' | sed -e 's|[^a-zA-Z0-9_]|_|g')
       # We use an indirect reference @see http://tldp.org/LDP/abs/html/ivr.html
       # All available VINBER_COMMIT_AUTHOR_* are loaded from the vinber.commit.authors
       # thought the load_authors_conf subroutine
       # shellcheck disable=SC2116
       # shellcheck disable=SC2001
       # shellcheck disable=SC2086  
       svn_info_last_author_email="$(eval "echo \$$(echo VINBER_COMMIT_AUTHOR_${normalized_committer_name})")"
       svn_info_last_author_name="$svn_info_last_committer"
       if [ ! -z "$svn_info_last_author_email" ]; then 
          svn_info_last_committer=$(echo "$svn_info_last_author_name <$svn_info_last_author_email>" |\
          sed -e :a -e 's/@\([^* .][^* .]\)\(\**\)[^* .]\([^*]*\.[^* .]*\)$/@\1\2*\3/;ta')
       fi
    # Last committer string contains already an email address   
    else
      # This is my two parts sed to extract the first email address occurrence in a string
      # shellcheck disable=SC2116
      # shellcheck disable=SC2001 
      svn_info_last_author_email=$(echo "$(echo "$svn_info_last_committer" |\
        sed -e 's|^\([^@]*\)@\([^@ ]*\).*|\1@\2|g ; s|^\([^@]*\)@\([^@ ]*\)|\1|g ; s|\([^ ]*\)$|#\1@|g ; s|^[^#]*#[^a-zA-Z]*||g')$(echo "$svn_info_last_committer" |\
        sed -e 's|^\([^@]*\)@\([^@ ]*\).*|\1@\2|g ; s|^\([^@]*\)@\([^@ ]*\)|\2|g ; s|[^a-zA-Z]*$||g')")
      # shellcheck disable=SC2001
      svn_info_last_author_name=$(echo "$svn_info_last_committer" | sed -e "s|^\(.*\)$svn_info_last_author_email.*|\1| ; s|\s*[^a-zA-Z]$||g") 
      # shellcheck disable=SC2001
      svn_info_last_committer=$(echo "$svn_info_last_committer" |\
          sed -e :a -e 's/@\([^* .][^* .]\)\(\**\)[^* .]\([^*]*\.[^* .]*\)$/@\1\2*\3/;ta')
    fi   
  fi

  log_info "Last Changed Author" "$svn_info_last_committer"  

  # SVN Last Commit Date
  # TODO(martinec) return the date with a full time zone designator 4-5 by 4-6
  local -r svn_info_last_date=$(svn info --trust-server-cert --non-interactive --username anonsvn --password anonsvn "$svn_checkout_path"      | \
                                grep "Last Changed Date"           | \
                                cut "--delimiter= " --fields=4-5)
  log_info "Last Changed Date" "$svn_info_last_date"

  # SVN Last Commit Message (1 line max)
  local svn_info_last_commit_message
  svn_info_last_commit_message=$(svn log  --trust-server-cert --non-interactive --username anonsvn --password anonsvn \
                                 -q -v --xml --with-all-revprops -r committed "$svn_checkout_path" | \
                                 grep "^<msg>" | \
                                 sed -e 's|^<msg>||g ; s|<\/msg>$||g' | \
                                 head -n1) 
  # svn_info_last_commit_message
  if [ -z "$svn_info_last_commit_message" ]; then
    svn_info_last_commit_message="$UNITEX_BUILD_NOT_DEFINED"
  fi
  log_info "Last Changed Message" "$svn_info_last_commit_message"

  local -r svn_info_url=$(svn info  --trust-server-cert --non-interactive --username anonsvn --password anonsvn \
                          --xml "$svn_checkout_path" |\
                          grep "^<url" |\
                          sed -e 's|<url>||g ;  s|<\/url>||g')
  log_debug "Repository URL"      "$svn_info_url"

  # Revision, Author and Date are mandatory
  if [ -z "$svn_info_last_revision"  -o \
       -z "$svn_info_last_committer" -o \
       -z "$svn_info_last_date" ]; then
    die_with_critical_error "SVN info fails" \
     "Internal SVN info function fails"
  fi

  # UNITEX_BUILD_LAST_ACTION_AUTHOR_NAME
  local UNITEX_BUILD_LAST_ACTION_AUTHOR_NAME="$UNITEX_BUILD_NOT_DEFINED"
  if [ ! -z "$svn_info_last_author_name" ]; then
    UNITEX_BUILD_LAST_ACTION_AUTHOR_NAME="$svn_info_last_author_name"
  else
    UNITEX_BUILD_LAST_ACTION_AUTHOR_NAME="$svn_info_last_committer" 
  fi

  # UNITEX_BUILD_LAST_ACTION_AUTHOR_EMAIL
  local UNITEX_BUILD_LAST_ACTION_AUTHOR_EMAIL="$UNITEX_BUILD_NOT_DEFINED"
  if [[ "$svn_info_last_author_email" == *"@"* ]]; then
    UNITEX_BUILD_LAST_ACTION_AUTHOR_EMAIL="$svn_info_last_author_email"
  fi

  UNITEX_BUILD_LAST_ACTION_REPOSITORY=$(echo -n "$svn_checkout_path" | sed -e 's|^\(../\)*||g')
  local UNITEX_BUILD_LAST_ACTION_REVISION="$svn_info_last_revision"
  local UNITEX_BUILD_LAST_ACTION_AUTHOR="$svn_info_last_committer"
  local UNITEX_BUILD_LAST_ACTION_DATE="$svn_info_last_date"
  local UNITEX_BUILD_LAST_ACTION_MESSAGE="$svn_info_last_commit_message"
  local UNITEX_BUILD_LAST_ACTION_REPOSITORY_URL="$svn_info_url"
  local UNITEX_BUILD_LAST_ACTION_REPOSITORY_TYPE="svn"
  local UNITEX_BUILD_LAST_ACTION_COMMIT="$svn_info_last_commit"

  VINBER_BUILD_REPOSITORIES[$UNITEX_BUILD_LAST_ACTION_REPOSITORY]=$(echo -ne\
             "$UNITEX_BUILD_LAST_ACTION_REPOSITORY\n"              \
             "$UNITEX_BUILD_LAST_ACTION_REVISION\n"                \
             "$UNITEX_BUILD_LAST_ACTION_AUTHOR\n"                  \
             "$UNITEX_BUILD_LAST_ACTION_DATE\n"                    \
             "$UNITEX_BUILD_LAST_ACTION_MESSAGE\n"                 \
             "$UNITEX_BUILD_LAST_ACTION_AUTHOR_EMAIL\n"            \
             "$UNITEX_BUILD_LAST_ACTION_AUTHOR_NAME\n"             \
             "$UNITEX_BUILD_LAST_ACTION_REPOSITORY_URL\n"          \
             "$UNITEX_BUILD_LAST_ACTION_REPOSITORY_TYPE\n"         \
             "$UNITEX_BUILD_LAST_ACTION_COMMIT\n"                  \
  | sed -e 's:^\s*:: ; s|^\(../\)*||g' )

  # shellcheck disable=SC2034
  local return_value=( "$UNITEX_BUILD_LAST_ACTION_REVISION"     \
                       "$UNITEX_BUILD_LAST_ACTION_AUTHOR"       \
                       "$UNITEX_BUILD_LAST_ACTION_DATE"         \
                       "$UNITEX_BUILD_LAST_ACTION_MESSAGE"      \
                       "$UNITEX_BUILD_LAST_ACTION_AUTHOR_EMAIL")
                       
  eval "$return_array=( \"\${return_value[@]}\" )"  
}

# =============================================================================
#  options, url, path
#  0 : last_revision,
#  1 : last_committer
#  2 : last_date
#  3 : last_commit_message
#  4 : last_committer_email
# =============================================================================
function git_info() {
  if [ $# -ne 2  ]; then
    die_with_critical_error "Git info fails" \
     "Internal Git info function called with the wrong number of parameters"
  fi
    
  local return_array=${1:?Return array name required}
  local git_repository_path=$2

  push_directory "$git_repository_path"

  log_info "Getting info about"  "$git_repository_path"

  # Git Last Commit Rev
  # A discussion about this in 
  # http://stackoverflow.com/questions/4120001/what-is-the-git-equivalent-for-revision-number
  # http://stackoverflow.com/a/11660153/2042871
  local -r git_info_last_revision=$(git rev-list --count --first-parent HEAD)
  log_debug "Last Changed Rev"   "$git_info_last_revision"

  # Git Last Commit Hash
  local -r git_info_last_commit=$(git --no-pager show -s --format="%h")
  log_info "Last Changed Commit" "$git_info_last_commit"

  # Git Last Commit Author Name
  local git_info_last_author_name
  git_info_last_author_name=$(git --no-pager show -s --format="%cN")

  # Temporal workaround if git_info_last_author_name is unknown
  local -r normalized_committer_name=$(echo "$git_info_last_author_name" | tr '[:upper:]' '[:lower:]' | sed -e 's|[^a-zA-Z0-9_]|_|g')
  # We use an indirect reference @see http://tldp.org/LDP/abs/html/ivr.html
  # All available VINBER_COMMIT_AUTHOR_* are loaded from the vinber.commit.authors
  # thought the load_authors_conf subroutine
  # shellcheck disable=SC2116
  # shellcheck disable=SC2086  
  local -r normalized_committer_email="$(eval "echo \$$(echo VINBER_COMMIT_AUTHOR_${normalized_committer_name})")"

  # if this author is unknown
  if [ -z "$normalized_committer_email" ]; then
    # All available VINBER_COMMIT_AUTHOR_ALIAS_* are loaded from the vinber.commit.authors
    # thought the load_authors_conf subroutine
    # shellcheck disable=SC2116
    # shellcheck disable=SC2086
    local -r normalized_committer_username="$(eval "echo \$$(echo VINBER_COMMIT_AUTHOR_ALIAS_${normalized_committer_name})")"
    # if we found an alias username 
    if [ ! -z "$normalized_committer_username" ]; then 
      git_info_last_author_name="$normalized_committer_username"
    fi  
  fi
 
  # Git Last Commit Author
  # sed anonymize mail addresses (foo-at-bar.com => foo-at-b**.com)
  local -r git_info_last_author=$(git --no-pager show -s --format="$git_info_last_author_name <%aE>" |\
   sed -e :a -e 's/@\([^* .][^* .]\)\(\**\)[^* .]\([^*]*\.[^* .]*\)$/@\1\2*\3/;ta')

  log_info "Last Changed Author" "$git_info_last_author"  

  # Git Last Commit Author Email
  local -r git_info_last_author_email=$(git --no-pager show -s --format="%aE")
     
  # Git Last Commit Date
  local git_info_last_date
  git_info_last_date=$(git --no-pager show -s --format="%cD")
  git_info_last_date=$(date -d "$git_info_last_date" +"%Y-%m-%d %H:%M:%S")
  
  log_info "Last Changed Date" "$git_info_last_date"

  # Git Last Commit Message (1 line max)
  # Format placeholders information is available here
  # @see https://www.kernel.org/pub/software/scm/git/docs/git-show.html
  # %s: first line ("subject"), %B: raw body (unwrapped subject and body)
  local git_info_last_commit_message
  git_info_last_commit_message=$(git --no-pager show -s --format="%s")

  # git_info_last_commit_message
  if [ -z "$git_info_last_commit_message" ]; then
    git_info_last_commit_message="$UNITEX_BUILD_NOT_DEFINED"
  fi
  log_info "Last Changed Message" "$git_info_last_commit_message"

  local -r git_info_url=$(git ls-remote --get-url origin|\
                       sed -e 's|^git|https|')
  log_debug "Repository URL"      "$git_info_url"
  
  # Revision, Author and Date are mandatory  
  if [ -z "$git_info_last_revision" -o \
       -z "$git_info_last_author"   -o \
       -z "$git_info_last_date" ]; then
    die_with_critical_error "Git info fails" \
     "Internal Git info function fails"
  fi     

  pop_directory

  # UNITEX_BUILD_LAST_ACTION_AUTHOR_NAME
  local UNITEX_BUILD_LAST_ACTION_AUTHOR_NAME="$UNITEX_BUILD_NOT_DEFINED"
  if [ ! -z  "$git_info_last_author_name" ]; then
    UNITEX_BUILD_LAST_ACTION_AUTHOR_NAME="$git_info_last_author_name"
  else
    UNITEX_BUILD_LAST_ACTION_AUTHOR_NAME="$git_info_last_author"     
  fi

  # UNITEX_BUILD_LAST_ACTION_AUTHOR_EMAIL
  local UNITEX_BUILD_LAST_ACTION_AUTHOR_EMAIL="$UNITEX_BUILD_NOT_DEFINED"
  if [[ "$git_info_last_author_email" == *"@"* ]]; then
    UNITEX_BUILD_LAST_ACTION_AUTHOR_EMAIL="$git_info_last_author_email"
  fi 

  UNITEX_BUILD_LAST_ACTION_REPOSITORY=$(echo -n "$git_repository_path" | sed -e 's|^\(../\)*||g')
  local UNITEX_BUILD_LAST_ACTION_REVISION="$git_info_last_revision"
  local UNITEX_BUILD_LAST_ACTION_AUTHOR="$git_info_last_author"
  local UNITEX_BUILD_LAST_ACTION_DATE="$git_info_last_date"
  local UNITEX_BUILD_LAST_ACTION_MESSAGE="$git_info_last_commit_message"
  local UNITEX_BUILD_LAST_ACTION_REPOSITORY_URL="$git_info_url"
  local UNITEX_BUILD_LAST_ACTION_REPOSITORY_TYPE="git"
  local UNITEX_BUILD_LAST_ACTION_COMMIT="$git_info_last_commit"

  VINBER_BUILD_REPOSITORIES[$UNITEX_BUILD_LAST_ACTION_REPOSITORY]=$(echo -ne\
             "$UNITEX_BUILD_LAST_ACTION_REPOSITORY\n"              \
             "$UNITEX_BUILD_LAST_ACTION_REVISION\n"                \
             "$UNITEX_BUILD_LAST_ACTION_AUTHOR\n"                  \
             "$UNITEX_BUILD_LAST_ACTION_DATE\n"                    \
             "$UNITEX_BUILD_LAST_ACTION_MESSAGE\n"                 \
             "$UNITEX_BUILD_LAST_ACTION_AUTHOR_EMAIL\n"            \
             "$UNITEX_BUILD_LAST_ACTION_AUTHOR_NAME\n"             \
             "$UNITEX_BUILD_LAST_ACTION_REPOSITORY_URL\n"          \
             "$UNITEX_BUILD_LAST_ACTION_REPOSITORY_TYPE\n"         \
             "$UNITEX_BUILD_LAST_ACTION_COMMIT\n"                  \
  | sed -e 's:^\s*:: ; s|^\(../\)*||g' )

  # shellcheck disable=SC2034
  local return_value=( "$UNITEX_BUILD_LAST_ACTION_REVISION"     \
                       "$UNITEX_BUILD_LAST_ACTION_AUTHOR"       \
                       "$UNITEX_BUILD_LAST_ACTION_DATE"         \
                       "$UNITEX_BUILD_LAST_ACTION_MESSAGE"      \
                       "$UNITEX_BUILD_LAST_ACTION_AUTHOR_EMAIL")
                       
  eval "$return_array=( \"\${return_value[@]}\" )"  
}

# =============================================================================
function svn_checkout() {
  if [ $# -ne 3  ]; then
    die_with_critical_error "SVN checkout fails" \
     "Internal SVN Checkout function called with the wrong number of parameters"
  fi
  
  local svn_checkout_options=$1
  local svn_checkout_url=$2
  local svn_checkout_path=$3
  
  # Checking out
  log_info  "Repository" "$svn_checkout_url"
  exec_logged_command "svn.checkout" "$UNITEX_BUILD_TOOL_SVN" checkout \
            "$svn_checkout_options" "$svn_checkout_url" "$svn_checkout_path"
}

# =============================================================================
# Git pull or clone
# =============================================================================
function git_clone_pull() {
  if [ $# -ne 3  ]; then
    die_with_critical_error "Git clone or pull fails" \
     "Internal Git clone or pull function called with the wrong number of parameters: $#"
  fi
  
  local git_clone_pull_options=$1
  local git_clone_pull_url=$2
  local git_clone_pull_path=$3
  local is_git_repository=0

  # Determine if directory is already under git control
  # this is from @source http://stackoverflow.com/a/2044677/2042871
  if [ -d "$git_clone_pull_path" ]; then
     push_directory "$git_clone_pull_path"
     if [ -d ".git" ]; then
      is_git_repository=1
     fi
     # git rev-parse 2> /dev/null > /dev/null || {
     #  is_git_repository=0
     # }
     pop_directory  
  fi

  # try to pull or clone the project
  if [ $is_git_repository -ne 0 ]; then
    push_directory "$git_clone_pull_path"
    # Pulling out
    log_info  "Repository" "$git_clone_pull_url"
    exec_logged_command "git.pull" "$UNITEX_BUILD_TOOL_GIT" pull \
              "$git_clone_pull_options"
    pop_directory
  else
    # Cloning out
    log_info  "Repository" "$git_clone_pull_url"
    exec_logged_command "git.clone" "$UNITEX_BUILD_TOOL_GIT" clone --depth=50 \
              "$git_clone_pull_options" "$git_clone_pull_url" "$git_clone_pull_path"
  fi
}

# =============================================================================
# @source http://unix.stackexchange.com/questions/44040/a-standard-tool-to-\
# convert-a-byte-count-into-human-kib-mib-etc-like-du-ls1
# =============================================================================
function file_size_human_readable() {
 local file_name=${1:?Filename required}
 local -r file_size=$(stat --printf="%s" "$file_name" | awk 'function human(x) {
                       s=" B   KiB MiB GiB TiB EiB PiB YiB ZiB"
                       while (x>=1024 && length(s)>1) 
                             {x/=1024; s=substr(s,5)}
                       s=substr(s,1,4)
                       xf=(s==" B  ")?"%5d   ":"%8.1f"
                       return sprintf( xf"%s\n", x, s)
                    }
                    {gsub(/^[0-9]+/, human($1)); print}')
  echo "$file_size"                  
}

# =============================================================================
# deploy_artifact "source" "destination"
# =============================================================================
function deploy_artifact () {
 local deploy_source=${1:?Source required}
 local deploy_destination=${2:?Destination required}

 local -r deploy_source_filename=$(basename "$deploy_source")
 #local deploy_source_extension="${deploy_source##*.}"
 local -r deploy_source_filename_no_extension=$(basename "${deploy_source%%.*}")

 UNITEX_BUILD_DEPLOYMENT_HAS_ERRORS=0

 if [ ! -e "$deploy_source" ]; then
  log_error "Source not found" "File or directory $deploy_source_filename not found!"
  UNITEX_BUILD_DEPLOYMENT_HAS_ERRORS=1
 fi

 if [ $UNITEX_BUILD_DEPLOYMENT_HAS_ERRORS -eq 0 ]; then
  if [ $UNITEX_BUILD_TEST_ONLY_DEPLOYMENT -ne 0 ]; then
    log_info "Deployment test" "The deployment will be only tested"
  fi  
  # In first instance, only test the deployment (with --dry-run)
  log_info "Testing deployment" \
  "Testing the deployment of $deploy_source_filename"
  exec_logged_command  "test.$deploy_source_filename_no_extension" \
                       "$UNITEX_BUILD_TOOL_RSYNC"     \
                           --verbose                  \
                           --dry-run                  \
                           --links                    \
                           --update                   \
                           --recursive                \
                           --itemize-changes          \
                           --times                    \
                           --exclude "\".*/\""        \
                           --exclude "\"*.bak\""      \
                           --exclude "\"*~\""         \
                           "\"$deploy_source\""       \
                           "\"$deploy_destination\""  || {
                             UNITEX_BUILD_DEPLOYMENT_HAS_ERRORS=1 
                           }


  if [ $UNITEX_BUILD_DEPLOYMENT_HAS_ERRORS -ne 0 ]; then
   log_error "Deployment failed" \
   "Error encountered when trying to test the deployment of $deploy_source_filename"
  else
     if [ $UNITEX_BUILD_TEST_ONLY_DEPLOYMENT -eq 0 ]; then
      log_info "Deploying..." \
      "Deploying $deploy_source_filename into $deploy_destination/$deploy_source_filename"     
      # Perform the deployment
      exec_logged_command "$deploy_source_filename_no_extension" \
                          "$UNITEX_BUILD_TOOL_RSYNC"  \
                               --verbose              \
                               --links                \
                               --update               \
                               --recursive            \
                               --itemize-changes      \
                               --times                \
                               --exclude "\".*/\""    \
                               --exclude "\"*.bak\""  \
                               --exclude "\"*~\""     \
                               "$deploy_source"       \
                               "$deploy_destination"  || {
                                 UNITEX_BUILD_DEPLOYMENT_HAS_ERRORS=1 
                               }
        if [ $UNITEX_BUILD_DEPLOYMENT_HAS_ERRORS -ne 0 ]; then
           log_error "Deployment failed" \
           "Error encountered when trying to deploy $deploy_source_filename"
        fi                               
     fi
  fi
 fi       
}  # deploy_artifact()


# =============================================================================
# This is my sed hack to anonymize mail addresses, e.g.
# anonymize_mail_addresses "foo-at-bar.com" => foo-at-b**.com
# =============================================================================
function anonymize_mail_addresses() {
  if [ $# -gt 0  ]; then
    local text_with_mail_addresses="$*"
    local -r anonymize_mail_addresses_text=$(echo -n "$text_with_mail_addresses" |\
    sed -e :a -e 's/@\([^* .][^* .]\)\(\**\)[^* .]\([^*]*\.[^* .]*\)$/@\1\2*\3/;ta')
    echo "$anonymize_mail_addresses_text"  
 fi
}

# =============================================================================
# 
# =============================================================================
function stage_unitex_core_checkout() {
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  svn_checkout "--trust-server-cert --non-interactive --username anonsvn --password anonsvn"   \
                 "https://svnigm.univ-mlv.fr/svn/unitex/Unitex-C++"     \
                 "$UNITEX_BUILD_REPOSITORY_CORE_NAME"
               
  svn_info    CORE_SVN_CHECKOUT_DETAILS                  \
              "$UNITEX_BUILD_REPOSITORY_CORE_NAME"
              
  # Saving SVN last date changed
  echo "${CORE_SVN_CHECKOUT_DETAILS[2]}" > "$UNITEX_BUILD_TIMESTAMP_DIR/C++.current"

  pop_directory            
}  # stage_unitex_core_checkout()

# =============================================================================
# 
# =============================================================================
function stage_unitex_core() {
  push_stage "Core"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  if [ $UNITEX_BUILD_SKIP_STAGE_CORE -ne 0 ]; then
    log_info "Stage skipped" "This stage will be ignored as requested by the $UNITEX_BUILD_BUNDLE_NAME-bundle configuration"
    pop_directory   # "$UNITEX_BUILD_SOURCE_DIR"
    pop_build_stage  
    return 1
  fi   

  # unitex core regression tests
  stage_unitex_core_logs

  # Clean previous Core sources if previous issues
  if [ "$UNITEX_BUILD_HAS_PREVIOUS_ISSUES" -ge 1 ]; then
    log_info "Cleaning" "Removing previous Core Components source directory"
    rm -rf "$UNITEX_BUILD_REPOSITORY_CORE_NAME"
  fi

  # 1. Core checkout
  stage_unitex_core_checkout
  
  # 2. Core check for updates
  check_for_updates UNITEX_BUILD_CORE_UPDATE "C++"  \
                    $UNITEX_BUILD_CORE_FORCE_UPDATE \
                    $UNITEX_BUILD_LOGS_UPDATE

  # 3. Core make
  stage_unitex_core_make

  # unitex regression tests replay
  stage_unitex_core_logs_run

  # unitex dist
  stage_unitex_core_dist

  pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"
  pop_build_stage 
}  # function stage_unitex_core()

# =============================================================================
# 
# =============================================================================
function stage_unitex_core_logs_run() {
  push_stage "CoreTestRun"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  UNITEX_BUILD_LOGS_HAS_ERRORS=0
  if [ $UNITEX_BUILD_SKIP_ULP_TESTS  -ne 1 -a \
       $UNITEX_BUILD_CORE_UPDATE     -ne 0 -a \
       $UNITEX_BUILD_CORE_HAS_ERRORS -eq 0 ]; then
    # if the sources compile, now, we try to replay all logs

    rm -f "$UNITEX_BUILD_REPOSITORY_LOGS_LOCAL_PATH/UnitexToolLogger"

    UNITEX_BUILD_HAS_UNITEXTOOLLOGGER=1
    command -v "$UNITEX_BUILD_CORE_LINUX_X86_64_DEBUG_SOURCES_DIR/bin/UnitexToolLogger" > /dev/null ||\
    {
      log_error "Aborting" "UnitexToolLogger linux-x86_64-debug is required but it's not compiled yet"
      UNITEX_BUILD_HAS_UNITEXTOOLLOGGER=0
    }


    if [ $UNITEX_BUILD_HAS_UNITEXTOOLLOGGER -ne 0 ]; then
      # copy UnitexToolLogger
      cp "$UNITEX_BUILD_CORE_LINUX_X86_64_DEBUG_SOURCES_DIR/bin/UnitexToolLogger" "$UNITEX_BUILD_REPOSITORY_LOGS_LOCAL_PATH/UnitexToolLogger"

      UNITEXTOOLLOGGER_EXECUTION_SUMMARY_FULLNAME="$UNITEX_BUILD_LOG_WORKSPACE/$UNITEX_BUILD_CURRENT_STAGE.UnitexToolLogger.execution_summary.$UNITEX_BUILD_LOG_FILE_EXT"
      UNITEXTOOLLOGGER_EXECUTION_SUMMARY_FILENAME=$(basename "$UNITEXTOOLLOGGER_EXECUTION_SUMMARY_FULLNAME")
      UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME="$UNITEX_BUILD_LOG_WORKSPACE/$UNITEX_BUILD_CURRENT_STAGE.UnitexToolLogger.error_summary.$UNITEX_BUILD_LOG_FILE_EXT"
      UNITEXTOOLLOGGER_ERROR_SUMMARY_FILENAME=$(basename "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME")
        
      push_directory "$UNITEX_BUILD_REPOSITORY_LOGS_LOCAL_PATH"

      # Only ULP tests
      log_info "Running logs" "Preparing to replay all ULPs files"
      for i in ./*.ulp
      do
        log_debug "Running" "$i"
        RUNLOG_EXECUTION_FAIL=0
        exec_logged_command "UnitexToolLogger.ulpfile"                                  \
                            "$UNITEX_BUILD_REPOSITORY_LOGS_LOCAL_PATH/UnitexToolLogger" \
                            RunLog "\"$i\""                                             \
                            -s "$UNITEXTOOLLOGGER_EXECUTION_SUMMARY_FULLNAME"           \
                            -e "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once"          \
                            --cleanlog || {
                              RUNLOG_EXECUTION_FAIL=1
                            }
        # save return code
        RUNLOG_EXIT_STATUS=$?
        if [ $RUNLOG_EXECUTION_FAIL -ne 0 ]; then
          # RunLog warning return code is equal to 79
          if [  $RUNLOG_EXIT_STATUS -eq 79 ]; then
            log_warn  "[TEST WARN]" "RunLog detected a warning while replaying $i"
          else
            log_error "[TEST FAIL]" "RunLog detected a regression while replaying $i"
            UNITEX_BUILD_LOGS_HAS_ERRORS=1
          fi
        else
          log_notice  "[TEST PASS]"  "RunLog does not detect any regression while replaying $i"
        fi
        
        if [ -f "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once" ]; then
          UNITEX_BUILD_LOGS_HAS_ERRORS=1
          cat   "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once" >> "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME"
          rm -f "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once"
        fi
      done  # for i in ./*.ulp    

      # Valgrind + ULP tests
      if [ $UNITEX_BUILD_LOGS_HAS_ERRORS         -eq 0 -a \
           $UNITEX_BUILD_SKIP_ULP_VALGRIND_TESTS -eq 0 ]; then
        log_info "Running valgrind" "Preparing to replay all ULPs files using Valgrind"
        for i in ./*.ulp
        do
          log_debug "Running valgrind" "$i"
          VALGRIND_LOG_NAME=$(basename "$i" | sed -e 's/[^A-Za-z0-9_-]/_/g')
          VALGRIND_LOG_FULLNAME="$UNITEX_BUILD_LOG_WORKSPACE/$UNITEX_BUILD_CURRENT_STAGE.valgrind.$VALGRIND_LOG_NAME.$UNITEX_BUILD_LOG_FILE_EXT"
          VALGRIND_EXECUTION_FAIL=0
          exec_logged_command "UnitexToolLogger.$VALGRIND_LOG_NAME"                       \
                              "$UNITEX_BUILD_TOOL_VALGRIND"                               \
                              --tool=memcheck                                             \
                              --error-exitcode=66                                         \
                              --leak-check=full                                           \
                              --vex-iropt-level=1                                         \
                              --show-reachable=yes                                        \
                              --track-origins=yes                                         \
                              --log-fd=6                                                  \
                              "$UNITEX_BUILD_REPOSITORY_LOGS_LOCAL_PATH/UnitexToolLogger" \
                              RunLog "\"$i\""                                             \
                              -s "$UNITEXTOOLLOGGER_EXECUTION_SUMMARY_FULLNAME"           \
                              -e "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once"          \
                              --cleanlog 6> "$VALGRIND_LOG_FULLNAME" || {
                                VALGRIND_EXECUTION_FAIL=1
                              }

          if [ $VALGRIND_EXECUTION_FAIL -ne 0 ]; then
            log_error "[TEST FAIL]" "Valgrind detected an error, check $VALGRIND_LOG_NAME for more details"
            UNITEX_BUILD_LOGS_HAS_ERRORS=1
          else
            log_notice  "[TEST PASS]"  "Valgrind does not detect any memory leaks replaying $i"
            rm -f "$VALGRIND_LOG_FULLNAME"
          fi
          
          if [ -f "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once" ]; then
            log_warn  "[TEST FAIL]" "RunLog under Valgrind detected a regression while replaying $i"
            UNITEX_BUILD_LOGS_HAS_ERRORS=1
            cat   "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once" >> "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME"
            rm -f "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME.once"
          else
            log_notice  "[TEST PASS]"  "RunLog under Valgrind does not detect any regression while replaying $i"
          fi
        done  # for i in ./*.ulp
      fi  # $UNITEX_BUILD_SKIP_ULP_VALGRIND_TESTS -eq 0  

      if [ $UNITEX_BUILD_LOGS_HAS_ERRORS -ne 0 ]; then
        # Force update until the successful compilation of the code is assured
        $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_LOGS_FORCE_UPDATE=./UNITEX_BUILD_LOGS_FORCE_UPDATE=2/'  \
                                    "$UNITEX_BUILD_CONFIG_FILENAME"
      else
        # Release update lock                                 
        $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_LOGS_FORCE_UPDATE=2/UNITEX_BUILD_LOGS_FORCE_UPDATE=0/' \
                                     "$UNITEX_BUILD_CONFIG_FILENAME" 
      fi

      if [ -e "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME" -a \
           -s "$UNITEXTOOLLOGGER_ERROR_SUMMARY_FULLNAME" ]; then
        log_warn "Regression detected" \
                 "Some regression tests did not complete successfully, see $UNITEXTOOLLOGGER_ERROR_SUMMARY_FILENAME for more details"
      else
        log_info "No regression" \
                 "All logs were successfully replayed, see $UNITEXTOOLLOGGER_EXECUTION_SUMMARY_FILENAME for more details"
      fi

      pop_directory  # "$UNITEX_BUILD_REPOSITORY_LOGS_LOCAL_PATH"
    fi
  else
    if   [ $UNITEX_BUILD_SKIP_ULP_TESTS  -eq 1 ]; then
      log_info   "Skipping logs" \
                 "CoreTest ULPs files wont be played!, as requested by the $UNITEX_BUILD_BUNDLE_NAME-bundle configuration";
    elif [ $UNITEX_BUILD_CORE_HAS_ERRORS -eq 0 ]; then
      log_info   "Skipping logs" \
                 "CoreTest ULPs files wont be played!, no changes detected in Core files";  
    elif [ $UNITEX_BUILD_CORE_HAS_ERRORS -eq 1 ]; then
      log_notice "Skipping logs" \
                 "CoreTest ULPs files wont be played!, some Core sources have errors";
    else
      log_warn   "Skipping logs" \
                 "CoreTest ULPs files wont be played! for an unknown reason";
    fi  
  fi

  pop_directory   # "$UNITEX_BUILD_SOURCE_DIR"
  pop_build_stage  
}  # function stage_unitex_core_logs_run()

# =============================================================================
# 
# =============================================================================
function stage_unitex_core_dist() {
  push_stage "CoreDist"
  push_directory "$UNITEX_BUILD_SOURCE_DIR"

  UNITEX_BUILD_CORE_DEPLOYMENT=$(( ! UNITEX_BUILD_CORE_HAS_ERRORS && ! UNITEX_BUILD_LOGS_HAS_ERRORS &&  ( UNITEX_BUILD_CORE_FORCE_DEPLOYMENT  || UNITEX_BUILD_FORCE_DEPLOYMENT ) ))
  if [ $UNITEX_BUILD_CORE_DEPLOYMENT  -eq 0 ]; then
   if [ $UNITEX_BUILD_CORE_UPDATE     -ne 0 -a \
        $UNITEX_BUILD_CORE_HAS_ERRORS -eq 0 -a \
        $UNITEX_BUILD_LOGS_HAS_ERRORS -eq 0 ]; then
      # shellcheck disable=SC2034 
      UNITEX_BUILD_LOGS_DEPLOYMENT=$(( UNITEX_BUILD_LOGS_UPDATE && ! UNITEX_BUILD_LOGS_HAS_ERRORS ))
      UNITEX_BUILD_CORE_DEPLOYMENT=1

      log_info "Preparing dist" "Core distribution is being prepared..."
      
      if [ -d "$UNITEX_BUILD_RELEASE_APP_DIR"                    -a \
           -d "$UNITEX_BUILD_CORE_WIN32_SOURCES_DIR/bin"         -a \
           -d "$UNITEX_BUILD_CORE_WIN64_SOURCES_DIR/bin"         -a \
           -d "$UNITEX_BUILD_CORE_OSX_SOURCES_DIR/bin"           -a \
           -d "$UNITEX_BUILD_CORE_LINUX_I686_SOURCES_DIR/bin"    -a \
           -d "$UNITEX_BUILD_CORE_LINUX_X86_64_SOURCES_DIR/bin" ]; then
        # Put revision.date
        date "+%B %d, %Y" > "$UNITEX_BUILD_RELEASE_APP_DIR/revision.date"

        # Clean previous binaries    
        rm -rf "${UNITEX_BUILD_RELEASE_APP_DIR:?}"/*.exe
        rm -rf "${UNITEX_BUILD_RELEASE_APP_DIR:?}"/UnitexToolLogger
        rm -rf "${UNITEX_BUILD_RELEASE_APP_DIR:?}"/"${UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME:?}"

        # Create a /platform directory
        mkdir "${UNITEX_BUILD_RELEASE_APP_DIR:?}"/"${UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME:?}"

        # Copy the Win32 executables into the /platform/win32 directory
        if [ -d "$UNITEX_BUILD_CORE_WIN32_SOURCES_DIR/bin" ]; then
         mkdir "${UNITEX_BUILD_RELEASE_APP_DIR:?}/${UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME:?}/${UNITEX_BUILD_RELEASES_WIN32_HOME_NAME:?}"
         log_info "Copying" "Win32 binaries"
         cp "$UNITEX_BUILD_CORE_WIN32_SOURCES_DIR/bin"/* "$UNITEX_BUILD_RELEASE_APP_DIR/$UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME/$UNITEX_BUILD_RELEASES_WIN32_HOME_NAME"    
        fi

        # Sign Win32 executables
        if [ -n "${UNITEX_BUILD_TOOL_SIGNCODE+1}" ]; then
          push_directory "$UNITEX_BUILD_RELEASE_APP_DIR/$UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME/$UNITEX_BUILD_RELEASES_WIN32_HOME_NAME"
          for executable in ./*.exe; do
            log_info "Signing" "$executable"
            exec_logged_command "signcode.sh.win.exe" "signcode.sh" "$executable" || { \
              die_with_critical_error "Sign failed" "Error signing $executable"
            }            
          done  # for executable
          pop_directory
        fi   # [ -n "${UNITEX_BUILD_TOOL_SIGNCODE+1}" ]  
        
        # Copy the Win64 executables into the /platform/win64 directory
        if [ -d "$UNITEX_BUILD_CORE_WIN64_SOURCES_DIR/bin" ]; then
         mkdir "${UNITEX_BUILD_RELEASE_APP_DIR:?}/${UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME:?}/${UNITEX_BUILD_RELEASES_WIN64_HOME_NAME:?}"
         log_info "Copying" "Win64 binaries"
         cp "$UNITEX_BUILD_CORE_WIN64_SOURCES_DIR/bin"/* "$UNITEX_BUILD_RELEASE_APP_DIR/$UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME/$UNITEX_BUILD_RELEASES_WIN64_HOME_NAME"
        fi

        # Sign Win64 executables
        if [ -n "${UNITEX_BUILD_TOOL_SIGNCODE+1}" ]; then
          push_directory "$UNITEX_BUILD_RELEASE_APP_DIR/$UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME/$UNITEX_BUILD_RELEASES_WIN64_HOME_NAME"
          for executable in ./*.exe; do
            log_info "Signing" "$executable"
            exec_logged_command "signcode.sh.win.exe" "signcode.sh" "$executable" || { \
              die_with_critical_error "Sign failed" "Error signing $executable"
            }            
          done  # for executable
          pop_directory
        fi   # [ -n "${UNITEX_BUILD_TOOL_SIGNCODE+1}" ]          

        # Backward compatibility
        cp "$UNITEX_BUILD_RELEASE_APP_DIR/$UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME/$UNITEX_BUILD_RELEASES_WIN32_HOME_NAME"/* "$UNITEX_BUILD_RELEASE_APP_DIR"

        # Copy the OS X binaries into the /platform/osx directory
        if [ -d "$UNITEX_BUILD_CORE_OSX_SOURCES_DIR/bin" ]; then
         mkdir "${UNITEX_BUILD_RELEASE_APP_DIR:?}/${UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME:?}/${UNITEX_BUILD_RELEASES_OSX_HOME_NAME:?}"
         log_info "Copying" "OS X binaries"
         cp "$UNITEX_BUILD_CORE_OSX_SOURCES_DIR/bin"/* "$UNITEX_BUILD_RELEASE_APP_DIR/$UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME/$UNITEX_BUILD_RELEASES_OSX_HOME_NAME"
        fi
        
        # Copy the Linux 32-bit (i686) binaries into the /platform/linux-i686 directory
        if [ -d "$UNITEX_BUILD_CORE_LINUX_I686_SOURCES_DIR/bin" ]; then
         mkdir "${UNITEX_BUILD_RELEASE_APP_DIR:?}/${UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME:?}/${UNITEX_BUILD_RELEASES_LINUX_I686_HOME_NAME:?}"
         log_info "Copying" "Linux 32-bit (i686) binaries"
         cp "$UNITEX_BUILD_CORE_LINUX_I686_SOURCES_DIR/bin"/* "$UNITEX_BUILD_RELEASE_APP_DIR/$UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME/$UNITEX_BUILD_RELEASES_LINUX_I686_HOME_NAME"
        fi
        
        # Copy the Linux 64-bit (x86_64) binaries into the /platform/linux-x86_64 directory
        if [ -d "$UNITEX_BUILD_CORE_LINUX_X86_64_SOURCES_DIR/bin" ]; then
         mkdir "${UNITEX_BUILD_RELEASE_APP_DIR:?}/${UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME:?}/${UNITEX_BUILD_RELEASES_LINUX_X86_64_HOME_NAME:?}"
         log_info "Copying" "Linux 64-bit (x86_64) binaries"
         cp "$UNITEX_BUILD_CORE_LINUX_X86_64_SOURCES_DIR/bin"/* "$UNITEX_BUILD_RELEASE_APP_DIR/$UNITEX_BUILD_RELEASES_PLATFORM_HOME_NAME/$UNITEX_BUILD_RELEASES_LINUX_X86_64_HOME_NAME"
        fi
        
        ## Copy the OS X binaries into the App directory
        #log_info "Copying" "OS X binaries"
        #push_directory "$UNITEX_BUILD_CORE_OSX_SOURCES_DIR/bin"
        #for file in *; do  
         #if [[ $file =~ \. ]]; then
            #cp "$file" "$UNITEX_BUILD_RELEASE_APP_DIR/${file%.*}$UNITEX_BUILD_PACKAGE_OSX_SUFFIX.${file##*.}"
         #else
            #cp "$file" "$UNITEX_BUILD_RELEASE_APP_DIR/$file$UNITEX_BUILD_PACKAGE_OSX_SUFFIX"
         #fi   
        #done
        #pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"

        # Copy the Linux 64-bit (x86_64) binaries into the App directory
        #log_info "Copying" "Linux 64-bit (x86_64) binaries"
        #push_directory "$UNITEX_BUILD_CORE_LINUX_X86_64_SOURCES_DIR/bin"
        #for file in *; do  
         #if [[ $file =~ \. ]]; then
            #cp "$file" "$UNITEX_BUILD_RELEASE_APP_DIR/${file%.*}$UNITEX_BUILD_PACKAGE_LINUX_X86_64_SUFFIX.${file##*.}"
         #else
            #cp "$file" "$UNITEX_BUILD_RELEASE_APP_DIR/$file$UNITEX_BUILD_PACKAGE_LINUX_X86_64_SUFFIX"
         #fi   
        #done
        #pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"        

      else  # [ -d  "$UNITEX_BUILD_RELEASE_APP_DIR" -a ... ];
        die_with_critical_error "Core dist error" "Failed to create Core distribution, some platform binaries are missing" 
      fi  # [ -d  "$UNITEX_BUILD_RELEASE_APP_DIR" -a ... ];
      
      # then, we copy the sources into the Src/C++ directory
      log_info "Copying" "Core components sources"
      rm -rf "${UNITEX_BUILD_RELEASE_SRC_CORE_DIR:?}"
      mkdir "$UNITEX_BUILD_RELEASE_SRC_CORE_DIR"
      cp "$UNITEX_BUILD_REPOSITORY_CORE_NAME"/*.cpp "$UNITEX_BUILD_REPOSITORY_CORE_NAME"/*.h "$UNITEX_BUILD_RELEASE_SRC_CORE_DIR/"
      mkdir "$UNITEX_BUILD_RELEASE_SRC_CORE_DIR/bin"
      cp -r "$UNITEX_BUILD_REPOSITORY_CORE_NAME"/build/          "$UNITEX_BUILD_RELEASE_SRC_CORE_DIR/"
      rm -f "$UNITEX_BUILD_RELEASE_SRC_CORE_DIR"/build/*.o
      cp -r "$UNITEX_BUILD_REPOSITORY_CORE_NAME"/logger          "$UNITEX_BUILD_RELEASE_SRC_CORE_DIR/"
      cp -r "$UNITEX_BUILD_REPOSITORY_CORE_NAME"/vendor          "$UNITEX_BUILD_RELEASE_SRC_CORE_DIR/"
      cp -r "$UNITEX_BUILD_REPOSITORY_CORE_NAME"/UnitexLibAndJni "$UNITEX_BUILD_RELEASE_SRC_CORE_DIR/"
      cp -r "$UNITEX_BUILD_REPOSITORY_CORE_NAME"/include_tre     "$UNITEX_BUILD_RELEASE_SRC_CORE_DIR/"
      cp -r "$UNITEX_BUILD_REPOSITORY_CORE_NAME"/win32vs2008     "$UNITEX_BUILD_RELEASE_SRC_CORE_DIR/"
      cp    "$UNITEX_BUILD_REPOSITORY_CORE_NAME"/Licenses/*.txt  "$UNITEX_BUILD_RELEASE_APP_DIR/"
      # finally, we create the README.txt
      stage_unitex_core_create_readme "$UNITEX_BUILD_RELEASE_DIR" "README.txt"
      
      log_info "Dist prepared" "Core distribution is now prepared"
    fi
  else
    log_notice "Dist prepared" "Core distribution is already prepared, nevertheless, a full deployment will be forced by user request!"
  fi
  
  pop_directory  # "$UNITEX_BUILD_SOURCE_DIR"
  pop_build_stage
}

# =============================================================================
# 
# =============================================================================
function stage_unitex_deployment_check() {
  UNITEX_BUILD_READY_FOR_DEPLOYMENT=0

  UNITEX_BUILD_GLOBAL_DEPLOYMENT=$(( 0 || UNITEX_BUILD_DOCS_DEPLOYMENT ||  UNITEX_BUILD_PACK_DEPLOYMENT ||  UNITEX_BUILD_LING_DEPLOYMENT ||  UNITEX_BUILD_CLASSIC_IDE_DEPLOYMENT || UNITEX_BUILD_GRAMLAB_IDE_DEPLOYMENT ||  UNITEX_BUILD_CORE_DEPLOYMENT ))
  log_debug "Deployment" "UNITEX_BUILD_DOCS_DEPLOYMENT=$UNITEX_BUILD_DOCS_DEPLOYMENT"  
  log_debug "Deployment" "UNITEX_BUILD_PACK_DEPLOYMENT=$UNITEX_BUILD_PACK_DEPLOYMENT"  
  log_debug "Deployment" "UNITEX_BUILD_LING_DEPLOYMENT=$UNITEX_BUILD_LING_DEPLOYMENT"  
  log_debug "Deployment" "UNITEX_BUILD_CLASSIC_IDE_DEPLOYMENT=$UNITEX_BUILD_CLASSIC_IDE_DEPLOYMENT" 
  log_debug "Deployment" "UNITEX_BUILD_GRAMLAB_IDE_DEPLOYMENT=$UNITEX_BUILD_GRAMLAB_IDE_DEPLOYMENT"  
  log_debug "Deployment" "UNITEX_BUILD_CORE_DEPLOYMENT=$UNITEX_BUILD_CORE_DEPLOYMENT"

  #UNITEX_BUILD_PROGRAMS_DEPLOYMENT=$(( 0 || UNITEX_BUILD_CLASSIC_IDE_DEPLOYMENT || UNITEX_BUILD_GRAMLAB_IDE_DEPLOYMENT || UNITEX_BUILD_CORE_DEPLOYMENT ))

  count_issues_until_now UNITEX_BUILD_ISSUES_BEFORE_DEPLOYMENT

  # shellcheck disable=SC2086
  if [ $UNITEX_BUILD_ISSUES_BEFORE_DEPLOYMENT -ne 0 ]; then
    UNITEX_BUILD_READY_FOR_DEPLOYMENT=0
    log_notice "Build issues" "There are some build issues which prevent the deployment of $UNITEX_PRETTYAPPNAME"
  elif [ $UNITEX_BUILD_GLOBAL_DEPLOYMENT -eq 0 ]; then
    UNITEX_BUILD_READY_FOR_DEPLOYMENT=0
    log_info "Up-do-date" "All components are already up-to-date. Nothing to Do!"
  else
    UNITEX_BUILD_READY_FOR_DEPLOYMENT=1
    if [ $UNITEX_BUILD_SKIP_DEPLOYMENT -ne 1 ]; then
      log_info "Preparing deployment" "$UNITEX_BUILD_FULL_RELEASE deployment is being prepared..."
    fi  
  fi
}
# =============================================================================
# 
# =============================================================================
function stage_unitex_core_create_readme() {
  push_directory "$SCRIPT_BASEDIR"
  README_PATH=$1
  README_FILENAME=$2
  README_FILE="$README_PATH/$README_FILENAME"

  if [ -e  "$UNITEX_BUILD_REPOSITORY_CORE_LOCAL_PATH/README.md.in" ]; then
    log_info "Creating Readme" "Creating a Readme file in $README_FILE"
    UNITEX_VER_FULL="$UNITEX_VER_FULL"                                               \
    UNITEX_VERSION="$UNITEX_VERSION"                                                 \
    UNITEX_BUILD_DATE=$(date '+%B %d, %Y')                                           \
    UNITEX_DESCRIPTION="$UNITEX_DESCRIPTION"                                         \
    UNITEX_HOMEPAGE_URL="$UNITEX_HOMEPAGE_URL"                                       \
    UNITEX_RELEASES_URL="$UNITEX_RELEASES_URL"                                       \
    UNITEX_RELEASES_LATEST_BETA_WIN32_URL="$UNITEX_RELEASES_LATEST_BETA_WIN32_URL"   \
    UNITEX_RELEASES_LATEST_BETA_SOURCE_URL="$UNITEX_RELEASES_LATEST_BETA_SOURCE_URL" \
    UNITEX_DOCS_URL="$UNITEX_DOCS_URL"                                               \
    UNITEX_FORUM_URL="$UNITEX_FORUM_URL"                                             \
    UNITEX_BUG_URL="$UNITEX_BUG_URL"                                                 \
    UNITEX_GOVERNANCE_URL="$UNITEX_GOVERNANCE_URL"                                   \
    UNITEX_COPYRIGHT_HOLDER="$UNITEX_COPYRIGHT_HOLDER"                               \
    UNITEX_CURRENT_YEAR=$(date '+%Y')                                                \
    "$SCRIPT_BASEDIR/mo" "$UNITEX_BUILD_REPOSITORY_CORE_LOCAL_PATH/README.md.in"    |\
     fold -s -w72                                                                    \
     > "$README_FILE"
  else 
    log_warn "File not found" "File $UNITEX_BUILD_REPOSITORY_CORE_LOCAL_PATH/README.md.in doesn't exist"
  fi   
  
  pop_directory  # "$SCRIPT_BASEDIR"
}

# =============================================================================
# 1. Working directory
# 2. Output path
# 3. Output filename
# 4. Target
# 5. Zip command extra arguments
# =============================================================================
function create_zip() {
  push_directory "$1"
  ZIP_PATH="$2"
  ZIP_FILENAME="$3"
  ZIP_TARGET="$4"
  ZIP_ARGS="$5"
  
  ZIP_FILE="$ZIP_PATH/$ZIP_FILENAME"
  
  rm -f "$ZIP_FILE"
  log_info "Creating zip" "Creating a zip package in $ZIP_FILE"
  exec_logged_command "zipcmd.create" "$UNITEX_BUILD_TOOL_ZIP" -r \
                      "$ZIP_FILE" "$ZIP_TARGET" "$ZIP_ARGS"

  # Calculate the checksum of the zip file
  calculate_checksum "$ZIP_FILE" "$ZIP_PATH"

  pop_directory  # "$1"            
}

# =============================================================================
# 
# =============================================================================
function stage_unitex_packaging_make_installer_win() {
  if [ $# -ne 1  ]; then
    die_with_critical_error "make_installer_win fails" \
     "Make Windows installer function called with the wrong number of parameters"
  fi

  local window_installer_bits="$1"
  if [ "$window_installer_bits" -ne 32 -a  "$window_installer_bits" -ne 64 ]; then
    die_with_critical_error "make_installer_win fails" \
     "Make Windows installer function expected '32' or '64' as input parameter"
  fi
    
  push_stage "PackWin"
  push_directory "$UNITEX_BUILD_BUNDLE_BASEDIR"

  # Setup the NSIS arch 64 parameter
  local nsis_arch_64_parameter=""
  if [ "$window_installer_bits" -eq 64 ]; then
    nsis_arch_64_parameter="-DVER_ARCH_64"
  fi

  UNITEX_BUILD_PACK_HAS_ERRORS=0
  if [ $UNITEX_BUILD_PACK_UPDATE -ne 0 ]; then
  
    log_info "Compiling installer" "Compiling Windows installer"
    
    # If NSISDIR isn't defined try to export UNITEX_BUILD_NSISDIR
    if [ ! -n "${NSISDIR+1}" -a -d "$UNITEX_BUILD_NSISDIR" ]; then
      export NSISDIR="$UNITEX_BUILD_NSISDIR"
    fi

    # Setup the NSIS verbosity level
    local nsis_verbose_all_parameter=""
    if [ $UNITEX_BUILD_VERBOSITY -eq 0 ]; then
      nsis_verbose_all_parameter="-V4"
    fi

    # Setup installer sign paramater
    local nsis_sign_file_parameter=""
    if [ -n "${UNITEX_BUILD_TOOL_SIGNCODE+1}" ]; then
      nsis_sign_file_parameter="-DFINALIZE_SIGN_FILE"
    fi
    
    #                               -DFORCE_JRE_UPDATE_INSTALLER_LINK \ 
    exec_logged_command "nsis.win.installer" "$UNITEX_BUILD_TOOL_MAKENSIS"               \
      $nsis_verbose_all_parameter -DINPUT_BASEDIR="$UNITEX_BUILD_BUNDLE_BASEDIR"         \
                                  -DINPUT_UNITEXDIR="$UNITEX_BUILD_RELEASE_DIR"          \
                                  -DINPUT_TIMESTAMPDIR="$UNITEX_BUILD_TIMESTAMP_DIR"     \
      $nsis_sign_file_parameter   -DVER_MAJOR="$UNITEX_VER_MAJOR"                        \
                                  -DVER_MINOR="$UNITEX_VER_MINOR"                        \
                                  -DVER_REVISION="$UNITEX_VER_REVISION"                  \
                                  -DVER_SUFFIX="$UNITEX_VER_SUFFIX"                      \
      $nsis_arch_64_parameter     -DOUTPUT_RELEASES_DIR="$UNITEX_BUILD_RELEASES_BASEDIR" \
                                  "$UNITEX_BUILD_REPOSITORY_PACK_LOCAL_PATH/windows/unitex.nsi" || {
        UNITEX_BUILD_PACK_HAS_ERRORS=1
      }
      
    if [ $UNITEX_BUILD_PACK_HAS_ERRORS -ne 0 ]; then
      log_error "Compilation failed" "Windows setup script does not compile!"
      # Force update until the successful compilation of the code is assured
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_PACK_FORCE_UPDATE=./UNITEX_BUILD_PACK_FORCE_UPDATE=2/'  \
                                  "$UNITEX_BUILD_CONFIG_FILENAME"
    else
      log_info "Compilation finished" "Compilation completed successfully"
      # Release update lock
      $UNITEX_BUILD_TOOL_SED -i 's/UNITEX_BUILD_PACK_FORCE_UPDATE=2/UNITEX_BUILD_PACK_FORCE_UPDATE=0/' \
                                  "$UNITEX_BUILD_CONFIG_FILENAME" 
    fi
  fi  #  if [ $UNITEX_BUILD_PACK_UPDATE -ne 0 ]; then
    
  pop_directory  # "$UNITEX_BUILD_BUNDLE_BASEDIR"
  pop_build_stage 
}

# =============================================================================
# 
# =============================================================================
function stage_unitex_deployment_generate_beta_downloads_webpage() {
  push_directory "$UNITEX_BUILD_BUNDLE_BASEDIR"
  log_info "Recreating webpage" "Recreating beta webpage $UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
  #TODO(martinec) check $UNITEX_PACKAGE_SRCDIST_PREFIX.zip
  #------------------------Begin here document------------------------#
  # The minus in "<<-__END__" suppresses leading tabs in the body of the
  # document  
cat > "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" << __END__
<h1>Download area for the $UNITEX_BUILD_FULL_RELEASE</h1>
<script type="text/javascript" language="JavaScript">
<!--
function writeCookie(name, val) {
  var argv=writeCookie.arguments;
  var argc=writeCookie.arguments.length;
  var expires=(argc > 2) ? argv[2] : null;
  var path=(argc > 3) ? argv[3] : null;
  var domain=(argc > 4) ? argv[4] : null;
  var secure=(argc > 5) ? argv[5] : false;
  document.cookie=name+"="+escape(val)+
    ((expires==null) ? "" : ("; expires="+expires.toGMTString()))+
    ((path==null) ? "" : ("; path="+path))+
    ((domain==null) ? "" : ("; domain="+domain))+
    ((secure==true) ? "; secure" : "");
}

function getCookieVal(offset) {
  var endstr=document.cookie.indexOf (";", offset);
  if (endstr==-1) endstr=document.cookie.length;
  return unescape(document.cookie.substring(offset, endstr));
}

function readCookie(name) {
  var arg=name+"=";
  var alen=arg.length;
  var clen=document.cookie.length;
  var i=0;
  while (i<clen) {
    var j=i+alen;
    if (document.cookie.substring(i, j)==arg) return getCookieVal(j);
    i=document.cookie.indexOf(" ",i)+1;
    if (i==0) break;
  }
  return null;
}

function cookiesEnabled() {
writeCookie("Unitex_download3","test");
tmp=readCookie("Unitex_download3");
if (tmp==null) return false;
return true;
}

function needToUpdate(name,val) {
if (cookiesEnabled()==false) return;
tmp=readCookie(name);
if (tmp==null || tmp!=val) {
  document.write("<br/><font size=1 color=\"#FF0000\">UPDATE AVAILABLE</font><br/>");
}
}

function saveCookie(name,val) {
date=new Date;
date.setYear(date.getFullYear()+1);
writeCookie(name,val,date);
}

function updateAllCookies() {
saveCookie("$UNITEX_PACKAGE_SRCDIST_PREFIX",
__END__
# shellcheck disable=SC2945
echo -n \" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_SRCDIST_PREFIX.zip")"\" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
);
saveCookie("App",
__END__
# shellcheck disable=SC2945
echo -n \" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_APP_PREFIX.zip")"\" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
);
saveCookie("Src",
__END__
# shellcheck disable=SC2945
echo -n \" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_SRC_PREFIX.zip")"\" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
);
__END__
cd "$UNITEX_BUILD_REPOSITORY_LING_LOCAL_PATH"
for LANG in *
  do
  echo "saveCookie(\"$LANG\",\"$(date -r "$UNITEX_BUILD_RELEASES_LING_DIR/$LANG.zip")\");" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
done
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
}
//-->
</script>
<p><a href="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_VINBER_HOME_NAME/#bundle=$UNITEX_BUILD_BUNDLE_NAME&amp;q=$UNITEX_BUILD_LOG_NAME"><img alt="${UNITEX_BUILD_BUNDLE_NAME^} Release" src="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_VINBER_HOME_NAME/badge/$UNITEX_BUILD_BUNDLE_NAME/$UNITEX_BUILD_LOG_NAME.svg?subject=product.name&amp;status=product.version.string" style="max-width:100%;"></a> <a href="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_VINBER_HOME_NAME/#bundle=$UNITEX_BUILD_BUNDLE_NAME&amp;q=$UNITEX_BUILD_LOG_NAME"><img alt="${UNITEX_BUILD_BUNDLE_NAME^} Status" src="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_VINBER_HOME_NAME/badge/$UNITEX_BUILD_BUNDLE_NAME/$UNITEX_BUILD_LOG_NAME.svg?status=build.status" style="max-width:100%;"></a></p>
<p>
In order to coordinate the cooperative development, $UNITEX_PRETTYAPPNAME programs
and resources are now maintained on a Version Control System. This page is automatically regenerated,
at regular intervals using the latest changes, by <a href="$UNITEX_BUILD_VINBER_REPOSITORY_URL">$UNITEX_BUILD_VINBER_CODENAME</a>,
the $UNITEX_BUILD_VINBER_DESCRIPTION. You can download below the latest $UNITEX_BUILD_BUNDLE_NAME builds.
</p>

<p>
<script type="text/javascript" language="JavaScript">
<!--
if (cookiesEnabled()==true) {
  document.write("<font size=1 color=\"#FF0000\">UPDATE AVAILABLE</font>: this indicates that the package has been updated ");
  document.write("since the last time you downloaded it or you downloaded the whole package. You must authorize cookies ");
  document.write("to enable this feature.");
} else {
  document.write("<font size=1 color=\"#FF0000\">UPDATE INFO</font>: cookies are currently deactivated in your browser. ");
  document.write("If you allow them, this page will display warnings close to the parts of Unitex (programs and linguistic ");
  document.write("resources) that have changed since your last download.");
}
//-->
</script>
</p>
<br/>
<p>Having problems? Old beta download page still <a href="http://www-igm.univ-mlv.fr/~unitex/index.php?page=3&html=beta.html">available here</a>. An alternative releases page is <a href="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_RELEASES_HOME_NAME">available here</a>!</p>
__END__

# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__

<hr>
<a href="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_BUILD_RELEASES_LATESTDIR_NAME/$UNITEX_BUILD_RELEASES_WIN32_HOME_NAME/$UNITEX_PACKAGE_WIN32_PREFIX.exe" onClick="updateAllCookies()"><font size=3><b>$UNITEX_BUILD_RELEASE Windows Setup Installer</b></font></a> (last update: 
__END__
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_SETUP_WIN32_DIR/$UNITEX_PACKAGE_WIN32_PREFIX.exe")" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
, size=
__END__
# shellcheck disable=SC2945
file_size_human_readable "$UNITEX_BUILD_RELEASES_SETUP_WIN32_DIR/$UNITEX_PACKAGE_WIN32_PREFIX.exe" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
)

<script type="text/javascript" language="JavaScript">
<!--
needToUpdate("$UNITEX_PACKAGE_SRCDIST_PREFIX",
__END__
# shellcheck disable=SC2945
echo -n \" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_SRCDIST_PREFIX.zip")"\" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
);
//-->
</script>

<p>
A common way to install Unitex/GramLab on Windows systems is via this setup installer. If you prefer a manual install, download the source distribution. See the README.txt for more details. 
</p>


<hr>
<a href="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_BUILD_RELEASES_LATESTDIR_NAME/$UNITEX_BUILD_RELEASES_SOURCE_HOME_NAME/$UNITEX_PACKAGE_SRCDIST_PREFIX.zip" onClick="updateAllCookies()"><font size=3><b>$UNITEX_BUILD_RELEASE Source Distribution Package</b></font></a> (last update: 
__END__
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_SRCDIST_PREFIX.zip")" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
, size=
__END__
# shellcheck disable=SC2945
file_size_human_readable "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_SRCDIST_PREFIX.zip" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
)

<script type="text/javascript" language="JavaScript">
<!--
needToUpdate("$UNITEX_PACKAGE_SRCDIST_PREFIX",
__END__
# shellcheck disable=SC2945
echo -n \" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_SRCDIST_PREFIX.zip")"\" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
);
//-->
</script>

<p>
This is the whole package that contains all the sources, all the
linguistic resources for the languages listed below and the Windows 
(32-bit, 64-bit), GNU/Linux (i686, x86_64) and OS X (10.7+) executables.
See the README.txt for more details.
</p>

<hr>
<a href="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_BUILD_RELEASES_LATESTDIR_NAME/$UNITEX_BUILD_RELEASES_SOURCE_HOME_NAME/$UNITEX_PACKAGE_APP_PREFIX.zip" onClick="saveCookie('App',
__END__
# shellcheck disable=SC2945
echo -n \' >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_APP_PREFIX.zip")"\' >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
)"><font size=3><b>App</b></font></a> (last update:
__END__
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_APP_PREFIX.zip")" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
, size=
__END__
# shellcheck disable=SC2945
file_size_human_readable "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_APP_PREFIX.zip" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
)

<script type="text/javascript" language="JavaScript">
<!--
needToUpdate("App",
__END__
# shellcheck disable=SC2945
echo -n \" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_APP_PREFIX.zip")"\" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
);
//-->
</script>
This package contains both Classic and GramLab IDEs together with the Windows (32-bit, 64-bit), GNU/Linux (i686, x86_64) and OS X (10.7+) executables.
<br/>
<br/>


<a href="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_BUILD_RELEASES_LATESTDIR_NAME/$UNITEX_BUILD_RELEASES_SOURCE_HOME_NAME/$UNITEX_PACKAGE_SRC_PREFIX.zip" onClick="saveCookie('Src',
__END__
# shellcheck disable=SC2945
echo -n \' >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_SRC_PREFIX.zip")"\' >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
)"><font size=3><b>Src</b></font></a> (last update:
__END__
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_SRC_PREFIX.zip")" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
, size=
__END__
# shellcheck disable=SC2945
file_size_human_readable "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_SRC_PREFIX.zip" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
)

<script type="text/javascript" language="JavaScript">
<!--
needToUpdate("Src",
__END__
# shellcheck disable=SC2945
echo -n \" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_SOURCE_DIR/$UNITEX_PACKAGE_SRC_PREFIX.zip")"\" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
);
//-->
</script>

This package contains all Core and IDE components sources. You need
them to build the executables for platforms other than Windows (32-bit, 64-bit), 
GNU/Linux (i686, x86_64) and OS X (10.7+).
<br/>
<br/>
Please consult the latest changes to see if the current versions are safe to use:

<br/>
<br/>

<a href="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_BUILD_RELEASES_LATESTDIR_NAME/$UNITEX_BUILD_RELEASES_CHANGES_HOME_NAME/C++.txt">Changes on Core sources</a>

<br/>

<a href="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_BUILD_RELEASES_LATESTDIR_NAME/$UNITEX_BUILD_RELEASES_CHANGES_HOME_NAME/Java.txt">Changes on Classic IDE sources</a>
<br/>

<a href="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_BUILD_RELEASES_LATESTDIR_NAME/$UNITEX_BUILD_RELEASES_CHANGES_HOME_NAME/Gramlab.txt">Changes on GramLab IDE sources</a>
__END__
cd "$UNITEX_BUILD_REPOSITORY_LING_LOCAL_PATH"
for LANG in *
  do cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
    <HR>
    <a href="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_BUILD_RELEASES_LATESTDIR_NAME/$UNITEX_BUILD_RELEASES_LING_HOME_NAME/$LANG.zip" onClick="saveCookie('$LANG',
__END__
# shellcheck disable=SC2945
echo -n \' >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_LING_DIR/$LANG.zip")"\' >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
)"><font size=3><b>$LANG</b></font></a> (last update:
__END__
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_LING_DIR/$LANG.zip")" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
, size=
__END__
# shellcheck disable=SC2945
file_size_human_readable "$UNITEX_BUILD_RELEASES_LING_DIR/$LANG.zip" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
)

<script type="text/javascript" language="JavaScript">
<!--
needToUpdate("$LANG",
__END__
# shellcheck disable=SC2945
echo -n \" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
echo -n "$(date -r "$UNITEX_BUILD_RELEASES_LING_DIR/$LANG.zip")"\" >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"
# shellcheck disable=SC2945
cat >> "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE" <<__END__
);
//-->
</script>

<br/>
<br/>

<a href="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_BUILD_RELEASES_LATESTDIR_NAME/$UNITEX_BUILD_RELEASES_CHANGES_HOME_NAME/$LANG.txt">Changes on resources for $LANG</a>
__END__
done
  #-------------------------End here document------------------------#
  pop_directory  # "$UNITEX_BUILD_BUNDLE_BASEDIR"  
}

# =============================================================================
# 
# =============================================================================
function stage_unitex_deployment() {
  push_stage "Deploy"
  push_directory "$UNITEX_BUILD_BUNDLE_BASEDIR"

  # 1 Check if we could do a deployment
  stage_unitex_deployment_check

  if [ $UNITEX_BUILD_READY_FOR_DEPLOYMENT -eq 1 -a $UNITEX_BUILD_SKIP_DEPLOYMENT -eq 1 ]; then
    log_info "Deployment skipped" "The deployment wont be made as requested by the $UNITEX_BUILD_BUNDLE_NAME-bundle configuration"
  elif [ $UNITEX_BUILD_READY_FOR_DEPLOYMENT -eq 1 ]; then
    # 2 Update the latest symbolic link
    # Update the /releases/latest-$VER_SUFFIX symbolic link
    push_directory "$UNITEX_BUILD_RELEASES_BASEDIR"
    rm  -f   "$UNITEX_BUILD_RELEASES_LATESTDIR"
    ln -sf   "$UNITEX_VERSION" "$UNITEX_BUILD_RELEASES_LATESTDIR_NAME"
    log_info "Latest release" "Directory $UNITEX_BUILD_RELEASES_LATESTDIR is now symbolically mapped to $UNITEX_BUILD_RELEASES_VERSION_BASEDIR"
    pop_directory  # "$UNITEX_BUILD_RELEASES_BASEDIR"

    # UNITEX_BUILD_GLOBAL_DEPLOYMENT=$(( 0 || UNITEX_BUILD_DOCS_DEPLOYMENT ||  UNITEX_BUILD_PACK_DEPLOYMENT ||  UNITEX_BUILD_LING_DEPLOYMENT ||  UNITEX_BUILD_CLASSIC_IDE_DEPLOYMENT || UNITEX_BUILD_GRAMLAB_IDE_DEPLOYMENT ||  UNITEX_BUILD_CORE_DEPLOYMENT ))

    # if [ $UNITEX_BUILD_PROGRAMS_DEPLOYMENT -ne 0 ]; then
    #  deploy_artifact "$UNITEX_BUILD_RELEASES_SOURCE_DIR"      "$UNITEX_BUILD_DEPLOYMENT_DESTINATION/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_VERSION"
    # fi  # [ $UNITEX_BUILD_PROGRAMS_DEPLOYMENT -ne 0 ]
    
    # 5
    if [ $UNITEX_BUILD_PACK_DEPLOYMENT -ne 0 ]; then
      deploy_artifact "$UNITEX_BUILD_RELEASES_SETUP_WIN32_DIR"  "$UNITEX_BUILD_DEPLOYMENT_DESTINATION/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_VERSION"
      deploy_artifact "$UNITEX_BUILD_RELEASES_SETUP_WIN64_DIR"  "$UNITEX_BUILD_DEPLOYMENT_DESTINATION/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_VERSION"
      deploy_artifact "$UNITEX_BUILD_RELEASES_OSX_DIR"          "$UNITEX_BUILD_DEPLOYMENT_DESTINATION/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_VERSION"
      deploy_artifact "$UNITEX_BUILD_RELEASES_LINUX_I686_DIR"   "$UNITEX_BUILD_DEPLOYMENT_DESTINATION/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_VERSION"
      deploy_artifact "$UNITEX_BUILD_RELEASES_LINUX_X86_64_DIR" "$UNITEX_BUILD_DEPLOYMENT_DESTINATION/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_VERSION"
      deploy_artifact "$UNITEX_BUILD_RELEASES_SOURCE_DIR"       "$UNITEX_BUILD_DEPLOYMENT_DESTINATION/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_VERSION"
    fi

    # 6
    deploy_artifact "$UNITEX_BUILD_RELEASES_MAN_DIR"         "$UNITEX_BUILD_DEPLOYMENT_DESTINATION/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_VERSION" 
    deploy_artifact "$UNITEX_BUILD_RELEASES_LING_DIR"        "$UNITEX_BUILD_DEPLOYMENT_DESTINATION/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_VERSION"
    deploy_artifact "$UNITEX_BUILD_RELEASES_CHANGES_DIR"     "$UNITEX_BUILD_DEPLOYMENT_DESTINATION/$UNITEX_BUILD_RELEASES_HOME_NAME/$UNITEX_VERSION"

    stage_unitex_deployment_generate_beta_downloads_webpage
    deploy_artifact "$UNITEX_BUILD_DOWNLOAD_WEB_PAGE"        "$UNITEX_BUILD_DEPLOYMENT_DESTINATION"

    deploy_artifact "$UNITEX_BUILD_RELEASES_LATESTDIR"       "$UNITEX_BUILD_DEPLOYMENT_DESTINATION/$UNITEX_BUILD_RELEASES_HOME_NAME"
  fi  # [ $UNITEX_BUILD_READY_FOR_DEPLOYMENT -eq 1 ]
  
  pop_directory  # "$UNITEX_BUILD_BUNDLE_BASEDIR"
  pop_build_stage
}

# =============================================================================
# 
# =============================================================================
function print_release_information() {
  log_info "Name"             "$UNITEX_PRETTYAPPNAME"
  log_info "Release"          "$UNITEX_BUILD_RELEASE"
  log_info "Full Release"     "$UNITEX_BUILD_FULL_RELEASE"
  log_info "License"          "$UNITEX_LICENSE"
  log_info "Description"      "$UNITEX_DESCRIPTION"
  log_info "Company"          "$UNITEX_COPYRIGHT_HOLDER"
  log_info "Version Major"    "$UNITEX_VER_MAJOR"
  log_info "Version Minor"    "$UNITEX_VER_MINOR"
  log_info "Version Suffix"   "$UNITEX_VER_SUFFIX"
  log_info "Version Type"     "$UNITEX_VER_TYPE"
  log_info "Version Revision" "$UNITEX_VER_REVISION"
  log_info "Version String"   "$UNITEX_VER_STRING"
  log_info "Version Full"     "$UNITEX_VER_FULL"
}  # print_release_information()

# =============================================================================
# main function
# attention ! don't use 'exit' alternative use
# die_with_critical_error "action message" "description message"
# =============================================================================
# 
# =============================================================================
main() {
  push_directory "$UNITEX_BUILD_BUNDLE_BASEDIR"

  # Vinber script itself
  stage_unitex_vinber_backend

  # unitex documentantion
  stage_unitex_doc

  # unitex linguistic resources
  stage_unitex_lingua

  # unitex classic visual ide
  stage_unitex_classic_ide

  # unitex GramLab ide
  stage_unitex_gramlab_ide

  # unitex core components
  stage_unitex_core

  # unitex packaging
  stage_unitex_packing

  # unitex deployment
  stage_unitex_deployment

  ## yaml 2 xml
  ## Docs updated by Vinber
  ## -src.tar.bz2

}  # main()

# Function to create a temporal directory
# Create a temporary directory in $2 (or /tmp) prefixed by
# vinber_ concatenate to a random sequence.
# Function returns the name of temporal directory that comes
# from being created.
# There are two ways to call this function :
# 1. create_temporal_directory output_variable
# 2. output_variable=$(create_temporal_directory)
function create_temporal_directory() {
  local  __output_variable=$1
  local  __tmpdir="/tmp"
      
  # setup __tmpdir_argument
  if [ $# -ge 2 ]; then
     if [ -d "$2" ]; then
        local  __tmpdir="$2"
     else   
        log_warn "Directory not found" "The $2 directory doesn't exist"
    fi
  fi
  
  local  my_temporal_directory
  my_temporal_directory=$(mktemp -d --tmpdir="$__tmpdir"       \
       "$UNITEX_BUILD_VINBER_CODENAME_LOWERCASE"_XXXXXXXXXXXX) || {
        die_with_critical_error "Build error" "Failed to create a temporal directory in $my_temporal_directory";
  }

  # normalize path
  my_temporal_directory="$(readlink -f "$my_temporal_directory")"    

  log_debug "Temporal directory" "$my_temporal_directory created!"    
      
  if [[ "$__output_variable" ]]; then
      # shellcheck disable=SC2140
      eval "$__output_variable"="'$my_temporal_directory'"
  else
      echo "$my_temporal_directory"
  fi
}  # create_temporal_directory

function notify_elapsed_time() {
  TIMESTAMP_FINISH_A=$(date +'%F %T %z')
  END_SECONDS=$(date +%s)
  DIFF_SECONDS=$(( END_SECONDS - START_SECONDS ))
  TOTAL_ELAPSED_TIME=$(echo -n $DIFF_SECONDS | awk '{print strftime("%H:%M:%S", $1,1)}')

  # notify that the work was done
  log_info "Overall elapsed time" "$TOTAL_ELAPSED_TIME"
}

# 
function notify_fail_log_level_count() {
  for i in "${!UNITEX_BUILD_LOG_LEVEL_COUNTER[@]}"; do
    # shellcheck disable=SC2086   
    if [ $UNITEX_BUILD_VERBOSITY -eq 0 -a $i -le 7 ]; then
      log_debug "${UNITEX_BUILD_LOG_LEVEL_NAME[$i]} messages" \
                "${UNITEX_BUILD_LOG_LEVEL_COUNTER[$i]}"
    elif [ $i -ge 3  -a $i -le 7 ]; then
      if [ ${UNITEX_BUILD_LOG_LEVEL_COUNTER[$i]} -ge 1 ]; then 
        log_info "${UNITEX_BUILD_LOG_LEVEL_NAME[$i]} messages" \
                 "${UNITEX_BUILD_LOG_LEVEL_COUNTER[$i]}"
      fi
    fi  
  done
}

#
function notify_issue_message_numbers() {
  if [ $UNITEX_BUILD_LOG_FIRST_ISSUE_NUMBER -ge 1 ]; then  
    log_info "First issue" "First issue at message No. $UNITEX_BUILD_LOG_FIRST_ISSUE_NUMBER"
    if [ $UNITEX_BUILD_LOG_FIRST_ISSUE_NUMBER -ne $UNITEX_BUILD_LOG_LAST_ISSUE_NUMBER ]; then
      log_info "Last issue" "Last issue at message No. $UNITEX_BUILD_LOG_LAST_ISSUE_NUMBER"
    fi  
  fi  
}


function notify_fail_command_execution_count() {
  if [ $UNITEX_BUILD_COMMAND_EXECUTION_ERROR_COUNT -ge 1 ]; then
    log_info  "Command execution" \
    "$UNITEX_BUILD_COMMAND_EXECUTION_ERROR_COUNT/$UNITEX_BUILD_COMMAND_EXECUTION_COUNT fails"
  fi
}

# exit with critical error
function die_with_critical_error() {
  # push_stage "$UNITEX_BUILDER_NAME"

  # send message to logger
  log_critical "$@"

  # do a clean exit
  clean_exit
}  # die_with_critical_error

function clean_exit() {
  # reset traps
  # shellcheck disable=SC2046
  trap - $(printf "%s "  "${SCRIPT_SIGNAL_LIST[@]}")
  
  # notify that the process is finished
  notify_finish

  # remove intermediate files and directories
  remove_intermediate_files

  # restore streams
  pop_streams

  # exit
  exit $UNITEX_BUILD_FINISH_WITH_ERROR_COUNT  
}

# test if configuration variables are non zero length
# prevent script fails with unassigned variables
function check_script_variables() {
  # UNITEX_VER_MAJOR
  if [ -z "${UNITEX_VER_MAJOR}" ]; then
    die_with_critical_error "Aborting" "UNITEX_VER_MAJOR is unset or set to the empty string"
  fi
  
  # UNITEX_VER_MINOR
  if [ -z "${UNITEX_VER_MINOR}" ]; then
    die_with_critical_error "Aborting" "UNITEX_VER_MINOR is unset or set to the empty string"
  fi

  # UNITEX_BUILD_VERBOSITY
  if [ -z "${UNITEX_BUILD_VERBOSITY}" ]; then
    die_with_critical_error "Aborting" "UNITEX_BUILD_VERBOSITY is unset or set to the empty string"
  fi

  
  # UNITEX_BUILD_*
  local vars_list=()
  vars_list=( $(set -o posix ; set      |\
                grep "UNITEX_BUILD_"    |\
                cut -d= -f1) )
  local script_var                        
  for script_var in "${vars_list[@]}"
  do
    log_debug "Variable checking" "Variable \$${script_var} is set to '$(anonymize_mail_addresses "${!script_var}")'" 
    if [ -z "${!script_var}" ]; then
      die_with_critical_error "Aborting" "\$${script_var} variable is unset or set to the empty string"
    fi
  done
}

function check_build_tools() {
  # Create a tool command array list composed by all variables having the prefix
  # UNITEX_BUILD_TOOL
  local tool_list=()
  tool_list=( $(set -o posix ; set        |\
                grep "UNITEX_BUILD_TOOL_" |\
                cut -d= -f2) )
  local script_tool                        
  for script_tool in "${tool_list[@]}"
  do
    log_debug "Command checking" "Checking for command $(basename "${script_tool}")" 
    command -v "${script_tool}" > /dev/null ||\
    {
      die_with_critical_error "Command not found" "${script_tool} is required but it's not installed" #.this
    }
  done
}

function setup_path_environment() {
  # The build base directory
  # e.g /home/vinber/build/Unitex-GramLab
  UNITEX_BUILD_BASEDIR="$SCRIPT_BASEDIR/$UNITEX_BUILD_VINBER_BUILD_HOME_NAME/$UNITEX_PACKAGE_NAME"
  
  # The bundle base directory
  # e.g /home/vinber/build/Unitex-GramLab/nightly
  UNITEX_BUILD_BUNDLE_BASEDIR="$UNITEX_BUILD_BASEDIR/$UNITEX_BUILD_BUNDLE_NAME"

  # The bundle source base directory
  # e.g /home/vinber/build/Unitex-GramLab/nightly/src
  UNITEX_BUILD_BUNDLE_SOURCE_BASEDIR="$UNITEX_BUILD_BUNDLE_BASEDIR/$UNITEX_BUILD_SOURCE_HOME"

  # The bundle distribution directory
  # e.g /home/vinber/build/Unitex-GramLab/nightly/dist
  UNITEX_BUILD_DIST_BASEDIR="$UNITEX_BUILD_BUNDLE_BASEDIR/$UNITEX_BUILD_DIST_HOME"

  # The bundle timestamp base directory
  # e.g /home/vinber/build/Unitex-GramLab/nightly/timestamp
  UNITEX_BUILD_TIMESTAMP_BASEDIR="$UNITEX_BUILD_BUNDLE_BASEDIR/$UNITEX_BUILD_TIMESTAMP_HOME"

  # The bundle packages base directory
  # e.g /home/vinber/build/Unitex-GramLab/nightly/releases
  UNITEX_BUILD_RELEASES_BASEDIR="$UNITEX_BUILD_BUNDLE_BASEDIR/$UNITEX_BUILD_RELEASES_HOME_NAME"  

  # Default build log name
  UNITEX_BUILD_LOG_NAME="$TIMESTAMP_START_S"

  # e.g vinber/bundle (only name not a path)
  UNITEX_BUILD_LOGS_HOME_NAME="$UNITEX_BUILD_VINBER_HOME_NAME/$UNITEX_BUILD_VINBER_BUNDLE_HOME_NAME"

  # e.g nightly/build (only name not a path)
  UNITEX_BUILD_VINBER_LOGS_HOME_NAME="$UNITEX_BUILD_BUNDLE_NAME/$UNITEX_BUILD_VINBER_BUILD_HOME_NAME"

  # e.g /home/vinber/bundle/ (a path)
  UNITEX_BUILD_LOGS_HOME_PATH="$SCRIPT_BASEDIR/$UNITEX_BUILD_LOGS_HOME_NAME"

  # e.g /home/vinber/bundle/nightly/build (path where log files are located)
  UNITEX_BUILD_LOGGER_PATH="$UNITEX_BUILD_LOGS_HOME_PATH/$UNITEX_BUILD_VINBER_LOGS_HOME_NAME"

  # e.g http://unitex.univ-mlv.fr/vinber/bundle/nightly/build
  UNITEX_BUILD_LOGGER_WEB_HOME="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_LOGS_HOME_NAME/$UNITEX_BUILD_VINBER_LOGS_HOME_NAME"

  # e.g /home/vinber/bundle/$UNITEX_BUILD_LOG_NAME.log
  UNITEX_BUILD_LOG_FILE="$UNITEX_BUILD_LOGGER_PATH/$UNITEX_BUILD_LOG_NAME.$UNITEX_BUILD_LOG_FILE_EXT"
  
  # e.g /home/vinber/bundle/nightly/build/latest.log
  UNITEX_BUILD_LOG_LATEST_SYMBOLIC_LINK="$UNITEX_BUILD_LOGGER_PATH/$UNITEX_BUILD_LATEST_NAME.$UNITEX_BUILD_LOG_FILE_EXT"

  # e.g /home/vinber/bundle/nightly/build/$UNITEX_BUILD_LOG_NAME.json
  UNITEX_BUILD_LOG_JSON="$UNITEX_BUILD_LOGGER_PATH/$UNITEX_BUILD_LOG_NAME.$UNITEX_BUILD_LOG_JSON_EXT"
  
  # e.g /home/vinber/bundle/nightly/build/latest.json
  UNITEX_BUILD_LOG_JSON_LATEST_SYMBOLIC_LINK="$UNITEX_BUILD_LOGGER_PATH/$UNITEX_BUILD_LATEST_NAME.$UNITEX_BUILD_LOG_JSON_EXT"

  # /home/vinber/bundle/nightly/builds.json
  UNITEX_BUILD_LOG_BUILDS_JSON="$UNITEX_BUILD_LOGS_HOME_PATH/$UNITEX_BUILD_BUNDLE_NAME/$UNITEX_BUILD_VINBER_BUILDS_LOG_NAME.$UNITEX_BUILD_LOG_JSON_EXT"

  # log build extension setting to empty
  # e.g. /home/vinber/bundle/nightly/build/$UNITEX_BUILD_LOG_NAME
  UNITEX_BUILD_LOG_WORKSPACE="$UNITEX_BUILD_LOGGER_PATH/$UNITEX_BUILD_LOG_NAME"

  # e.g. /home/vinber/bundle/nightly/build/latest
  UNITEX_BUILD_LOG_WORKSPACE_LATEST_SYMBOLIC_LINK="$UNITEX_BUILD_LOGGER_PATH/$UNITEX_BUILD_LATEST_NAME"

  # e.g http://unitex.univ-mlv.fr/v6/#bundle=nightly&q=2015-04-08-01-16-59
  UNITEX_BUILD_LOG_FRONTEND_URL="$UNITEX_WEBSITE_URL/$UNITEX_BUILD_VINBER_HOME_NAME/#bundle=$UNITEX_BUILD_BUNDLE_NAME&q=$UNITEX_BUILD_LOG_NAME"
}

# =============================================================================
function setup_user_environment() {
  # this is from @source http://stackoverflow.com/a/11052171/2042871  
  if logname &> /dev/null ; then 
   UNITEX_BUILD_CURRENT_USER=$(logname)
  else 
   UNITEX_BUILD_CURRENT_USER=$( id | cut -d "(" -f 2 | cut -d ")" -f1 )
  fi

  UNITEX_BUILD_WEB_GROUP="web"
  
  # test if user is member of the web group
  UNITEX_BUILD_CHANGE_RIGHTS=1
  if [ ! -z "$UNITEX_BUILD_CURRENT_USER" ]; then
   id -n -G "$UNITEX_BUILD_CURRENT_USER" | grep -q "$UNITEX_BUILD_WEB_GROUP" || {
     UNITEX_BUILD_CHANGE_RIGHTS=0
   }
  fi
}

# =============================================================================
# Prepare the unitex log environment
# this function perform some checks to configure the unitex build log environment
function setup_log_environment() {
  # test if logs home (vinber/bundle) exists, create if not
  if [ ! -d "$UNITEX_BUILD_LOGS_HOME_PATH" ]
  then
    # try to create a logger directory
    mkdir -p "$UNITEX_BUILD_LOGS_HOME_PATH" || {
      die_with_critical_error "Aborting" "Failed to create a Log Home in $UNITEX_BUILD_LOGS_HOME_PATH"
    }

    # change the rights of the logger directory
    if [ "$UNITEX_BUILD_CHANGE_RIGHTS" -eq 1 ]; then
        chown -f "$UNITEX_BUILD_CURRENT_USER:$UNITEX_BUILD_WEB_GROUP" \
                 "$UNITEX_BUILD_LOGS_HOME_PATH"
    fi  

    # change the permissions of the logs home directory (drwxrwsr-x)
    chmod 2775 "$UNITEX_BUILD_LOGS_HOME_PATH"           
  fi  # [ ! -e $UNITEX_BUILD_LOGS_HOME_PATH ]

  # test if logger path exists, create if not
  if [ ! -d "$UNITEX_BUILD_LOGGER_PATH" ]
  then
    # try to create a logger directory
    mkdir -p "$UNITEX_BUILD_LOGGER_PATH" || {
      die_with_critical_error "Aborting" "Failed to create a Logger directory in $UNITEX_BUILD_LOGGER_PATH"
    }

    # change the rights of the logger directory
    if [ "$UNITEX_BUILD_CHANGE_RIGHTS" -eq 1 ]; then
        chown -f "$UNITEX_BUILD_CURRENT_USER:$UNITEX_BUILD_WEB_GROUP" \
                 "$UNITEX_BUILD_LOGGER_PATH"
    fi   

    # change the permissions of logger path (drwxrwsr-x)
    chmod 2775 "$UNITEX_BUILD_LOGGER_PATH"             
  fi  # [ ! -e $UNITEX_BUILD_LOGGER_PATH ]

  # test if builds.json file exists
  if [ ! -e "$UNITEX_BUILD_LOG_BUILDS_JSON" ]
  then
    #  try to create the file
    touch "$UNITEX_BUILD_LOG_BUILDS_JSON" || {
      die_with_critical_error "Aborting" "Failed to create builds file 'UNITEX_BUILD_LOG_BUILDS_JSON'";
    }

    # change the rights of the file
    if [ "$UNITEX_BUILD_CHANGE_RIGHTS" -eq 1 ]; then
        chown -f "$UNITEX_BUILD_CURRENT_USER:$UNITEX_BUILD_WEB_GROUP" \
                 "$UNITEX_BUILD_LOG_BUILDS_JSON"
    fi

    # change the permissions of the master log file (rw-r--r--)
    chmod 644 "$UNITEX_BUILD_LOG_BUILDS_JSON"
  fi  # [ ! -e $UNITEX_BUILD_LOG_BUILDS_JSON ]  
  
  # test if the master log file exists
  if [ ! -e "$UNITEX_BUILD_LOG_FILE" ]
  then
    #  try to create the log file
    touch "$UNITEX_BUILD_LOG_FILE" || {
      die_with_critical_error "Aborting" "Failed to create a log file 'UNITEX_BUILD_LOG_FILE'";
    }

    # change the rights of the master log file
    if [ "$UNITEX_BUILD_CHANGE_RIGHTS" -eq 1 ]; then
        chown -f "$UNITEX_BUILD_CURRENT_USER:$UNITEX_BUILD_WEB_GROUP" \
                 "$UNITEX_BUILD_LOG_FILE"
    fi

    # change the permissions of the master log file (rw-r--r--)
    chmod 644 "$UNITEX_BUILD_LOG_FILE"
  fi  # [ ! -e $UNITEX_BUILD_LOG_FILE ]

  # if log is empty, write the header
  if [ ! -s "$UNITEX_BUILD_LOG_FILE" ]
  then
    {
    echo -e "$UNITEX_PRETTYAPPNAME $UNITEX_BUILD_VINBER_CODENAME Log $TIMESTAMP_START_C\n"    \
            "Markers:\n"                                                    \
            "(%%) debug, (II) information, (!!) notice,   (WW) warning,\n"  \
            "(EE) error, (CC) critical,    (^^) alert,    (@@) panic"
    } > "$UNITEX_BUILD_LOG_FILE"
  fi

  # test if the jsonize master log file exists
  if [ ! -e "$UNITEX_BUILD_LOG_JSON" ]
  then
    #  try to create the log file
    touch "$UNITEX_BUILD_LOG_JSON" || {
      die_with_critical_error "Aborting" "Failed to create a jsonize log file 'UNITEX_BUILD_LOG_JSON'";
    }

    # change the rights of the jsonize master log file
    if [ "$UNITEX_BUILD_CHANGE_RIGHTS" -eq 1 ]; then
        chown -f "$UNITEX_BUILD_CURRENT_USER:$UNITEX_BUILD_WEB_GROUP" \
                 "$UNITEX_BUILD_LOG_JSON"
    fi

    # change the permissions of the jsonize master log file (rw-r--r--)
    chmod 644 "$UNITEX_BUILD_LOG_JSON"
  fi  # [ ! -e $UNITEX_BUILD_LOG_JSON ]

  # if json log is empty, write the header
  if [ ! -s "$UNITEX_BUILD_LOG_JSON" ]
  then
    {
    echo -e "{\n" \
            "    \"$UNITEX_BUILD_LOG_JSON_VINBER_DATA_KEY\": ["
    } > "$UNITEX_BUILD_LOG_JSON"
  fi  

  # test if logger workspace path exists, create if not
  if [ ! -d "$UNITEX_BUILD_LOG_WORKSPACE" ]
  then
    # try to create a logger workspace directory
    mkdir -p "$UNITEX_BUILD_LOG_WORKSPACE" || {
      die_with_critical_error   "Aborting" "Failed to create a Logger workspace directory in" \
                                "$UNITEX_BUILD_LOG_WORKSPACE";
    }

    # change the rights of the logger workspace directory
    if [ "$UNITEX_BUILD_CHANGE_RIGHTS" -eq 1 ]; then
      chown -f "$UNITEX_BUILD_CURRENT_USER:$UNITEX_BUILD_WEB_GROUP" \
               "$UNITEX_BUILD_LOG_WORKSPACE"
    fi           
  fi  # [ ! -e $UNITEX_BUILD_LOG_WORKSPACE ]
}

# =============================================================================
function check_previous_issues() {
  log_info  "Previous build"    "$UNITEX_BUILD_PREVIOUS_NAME"
  log_info  "Previous status"   "$UNITEX_BUILD_PREVIOUS_STATUS"

  # Test if the previous build failed
  UNITEX_BUILD_HAS_PREVIOUS_ISSUES=$([ x"$UNITEX_BUILD_PREVIOUS_STATUS" ==  x"$UNITEX_BUILD_STATUS_FAILED" ] &&\
                                       echo -ne "1" || echo -ne "0")  

  # Test if the build has previous issues
  UNITEX_BUILD_HAS_PREVIOUS_ISSUES=$(( UNITEX_BUILD_HAS_PREVIOUS_ISSUES || UNITEX_BUILD_DOCS_FORCE_UPDATE        > 1                            || UNITEX_BUILD_PACK_FORCE_UPDATE        > 1                            || UNITEX_BUILD_LING_FORCE_UPDATE        > 1                            || UNITEX_BUILD_CLASSIC_IDE_FORCE_UPDATE > 1                            || UNITEX_BUILD_GRAMLAB_IDE_FORCE_UPDATE > 1                            || UNITEX_BUILD_LOGS_FORCE_UPDATE        > 1                            || UNITEX_BUILD_CORE_FORCE_UPDATE        > 1 ))

  # If there are not previous issues UNITEX_BUILD_NOTIFY_ON_FIXED will be set to 0
  UNITEX_BUILD_NOTIFY_ON_FIXED=$(( UNITEX_BUILD_NOTIFY_ON_FIXED && UNITEX_BUILD_HAS_PREVIOUS_ISSUES ))

  # We need to notify about a failed build
  if [ "$UNITEX_BUILD_NOTIFY_ON_FIXED" -ge 1 ]; then
      log_notice "Previous issues"   "The previous build had issues, on success recipients will be notified"     
  fi
}

# =============================================================================
# setup_script_traps
# =============================================================================
function setup_script_traps() {
  # Create an array list composed by all variables having the prefix
  # UNITEX_BUILD_SIGNAL_
  SCRIPT_SIGNAL_LIST=$(set -o posix ; set       |\
                    grep "UNITEX_BUILD_SIGNAL_" |\
                    cut -d= -f2)
  SCRIPT_SIGNAL_LIST=( $SCRIPT_SIGNAL_LIST )
  local script_signal                        
  for script_signal in "${SCRIPT_SIGNAL_LIST[@]}"
  do
    # shellcheck disable=SC2064
    trap "die_with_critical_error \"Caught signal\" \"A $script_signal signal was received at line \$LINENO\"" $script_signal
  done
}

# =============================================================================
function print_config_environment() {
  log_info  "Building started"    "$TIMESTAMP_START_A"
  log_info  "Bundle name"         "$UNITEX_BUILD_BUNDLE_NAME"
  log_info  "Build name"          "$UNITEX_BUILD_LOG_NAME"
  log_debug "Verbosity level"     "$UNITEX_BUILD_VERBOSITY"
  log_debug "Log directory"       "$UNITEX_BUILD_LOGGER_PATH"
  log_debug "Raw Log file"        "$UNITEX_BUILD_LOG_FILE"
  #log_debug "Raw Log file link"   "$UNITEX_BUILD_LOG_LATEST_SYMBOLIC_LINK"
  log_debug "Log workspace"       "$UNITEX_BUILD_LOG_WORKSPACE"
  #log_debug "Log workspace link"  "$UNITEX_BUILD_LOG_WORKSPACE_LATEST_SYMBOLIC_LINK"

  # Notifications for extra recipients
  if [ ! -z "$UNITEX_BUILD_EXTRA_RECIPIENTS" ]; then
    log_debug "Extra recipients"   "$(anonymize_mail_addresses "$UNITEX_BUILD_EXTRA_RECIPIENTS")"
  fi 
}

# =============================================================================
function load_deps_conf() {
  push_directory "$SCRIPT_BASEDIR"
  # if the deps file doesn't exist
  if [ ! -e "$UNITEX_BUILD_DEPS_FILENAME" ]; then
      die_with_critical_error "File not found" \
       "Dependencies file $UNITEX_BUILD_DEPS_FILENAME not found"    
  fi

  # only read deps file if isn't world writable
  if [[ $(stat --format %a "$(readlink -f "$UNITEX_BUILD_DEPS_FILENAME")") == 600 ]]; then
       . "$UNITEX_BUILD_DEPS_FILENAME"
  else
       die_with_critical_error "Wrong permissions" \
       "Wrong permissions on dependencies file $UNITEX_BUILD_DEPS_FILENAME, should not be world writable (600)!"
  fi
  
  pop_directory
}

# =============================================================================
function load_authors_conf() {
  push_directory "$SCRIPT_BASEDIR"
  # if the authors configuration exists
  if [ -e "$UNITEX_BUILD_AUTHORS_FILENAME" ]; then
    # only read authors file if isn't world writable
    if [[ $(stat --format %a "$(readlink -f "$UNITEX_BUILD_DEPS_FILENAME")") == 600 ]]; then
         . "$UNITEX_BUILD_AUTHORS_FILENAME"
    else
         die_with_critical_error "Wrong permissions" \
         "Wrong permissions on authors file $UNITEX_BUILD_AUTHORS_FILENAME, should not be world writable (600)!"
    fi
  fi
  
  pop_directory
}

# =============================================================================
function load_previous_build_status() {
  # /home/vinber/bundle/nightly/build/latest => latest
  UNITEX_BUILD_PREVIOUS_NAME=$(basename "$(readlink -m "$UNITEX_BUILD_LOG_WORKSPACE_LATEST_SYMBOLIC_LINK")")
  
  # /home/vinber/bundle/nightly/build/latest-failed => latest-failed
  UNITEX_BUILD_PREVIOUS_FAILED_NAME=$(basename "$(readlink -m "$UNITEX_BUILD_LOG_WORKSPACE_LATEST_SYMBOLIC_LINK-$UNITEX_BUILD_STATUS_FAILED")")
  
  # /home/vinber/bundle/nightly/build/latest-failed => latest-passed
  UNITEX_BUILD_PREVIOUS_PASSED_NAME=$(basename "$(readlink -m "$UNITEX_BUILD_LOG_WORKSPACE_LATEST_SYMBOLIC_LINK-$UNITEX_BUILD_STATUS_PASSED")")

  # set-up the previous status
  if [ x"$UNITEX_BUILD_PREVIOUS_NAME" == x"$UNITEX_BUILD_PREVIOUS_FAILED_NAME" ]; then
      UNITEX_BUILD_PREVIOUS_STATUS="$UNITEX_BUILD_STATUS_FAILED"
  elif [ x"$UNITEX_BUILD_PREVIOUS_NAME" == x"$UNITEX_BUILD_PREVIOUS_PASSED_NAME" ]; then
      UNITEX_BUILD_PREVIOUS_STATUS="$UNITEX_BUILD_STATUS_PASSED"
  else
      if [ ! -e "$UNITEX_BUILD_PREVIOUS_FAILED_NAME" -o \
          ! -e "$UNITEX_BUILD_PREVIOUS_PASSED_NAME" ]; then
         UNITEX_BUILD_PREVIOUS_STATUS="$UNITEX_BUILD_STATUS_INACC"
      else
         UNITEX_BUILD_PREVIOUS_STATUS="$UNITEX_BUILD_STATUS_ERROR"
      fi
  fi
}

# =============================================================================
#
# =============================================================================
function setup_release_information() {
  # setup the version suffix    
  if [ -z "${UNITEX_VER_SUFFIX}" ]
  then
    UNITEX_VERSION="$UNITEX_VER_MAJOR.$UNITEX_VER_MINOR"
    UNITEX_VER_TYPE="stable"
    UNITEX_BUILD_RELEASES_LATESTDIR_NAME="$UNITEX_BUILD_LATEST_NAME"
  else
    UNITEX_VERSION="$UNITEX_VER_MAJOR.$UNITEX_VER_MINOR$UNITEX_VER_SUFFIX"
    UNITEX_VER_TYPE="unstable"
    UNITEX_BUILD_RELEASES_LATESTDIR_NAME="$UNITEX_BUILD_LATEST_NAME-$UNITEX_VER_SUFFIX"
  fi

  # setup the version release
  # e.g Unitex/GramLab 3.1beta
  UNITEX_BUILD_RELEASE="$UNITEX_PRETTYAPPNAME $UNITEX_VERSION"

  # setup the package name prefix
  # e.g. Unitex-GramLab-3.1beta
  # shellcheck disable=SC2034
  UNITEX_PACKAGE_FULL_NAME="$UNITEX_PACKAGE_NAME-$UNITEX_VERSION"

  # setup the source package name prefix
  # e.g. Unitex-GramLab-3.1beta-source
  UNITEX_PACKAGE_SRC_PREFIX="$UNITEX_PACKAGE_FULL_NAME$UNITEX_BUILD_PACKAGE_SOURCE_SUFFIX"

  # setup the application package name prefix
  # e.g. Unitex-GramLab-3.1beta-application
  UNITEX_PACKAGE_APP_PREFIX="$UNITEX_PACKAGE_FULL_NAME$UNITEX_BUILD_PACKAGE_APP_SUFFIX"  

  # setup the source distribution package name prefix
  # e.g. Unitex-GramLab-3.1beta-source-distribution
  UNITEX_PACKAGE_SRCDIST_PREFIX="$UNITEX_PACKAGE_FULL_NAME$UNITEX_BUILD_PACKAGE_SOURCE_DISTRIBUTION_SUFFIX"

  # setup the win32 package name prefix
  # e.g. Unitex-GramLab-3.1beta_win32-setup
  UNITEX_PACKAGE_WIN32_PREFIX="$UNITEX_PACKAGE_FULL_NAME$UNITEX_BUILD_PACKAGE_SETUP_WIN32_TAG$UNITEX_BUILD_PACKAGE_SETUP_SUFFIX"

  # setup the win64 package name prefix
  # e.g. Unitex-GramLab-3.1beta_win64-setup
  UNITEX_PACKAGE_WIN64_PREFIX="$UNITEX_PACKAGE_FULL_NAME$UNITEX_BUILD_PACKAGE_SETUP_WIN64_TAG$UNITEX_BUILD_PACKAGE_SETUP_SUFFIX"
  
  # setup the OS X package name prefix
  # e.g. Unitex-GramLab-3.1beta-osx
  UNITEX_PACKAGE_OSX_PREFIX="$UNITEX_PACKAGE_FULL_NAME$UNITEX_BUILD_PACKAGE_OSX_SUFFIX"
  UNITEX_PACKAGE_OSX_PREFIX="$UNITEX_PACKAGE_OSX_PREFIX"      # FIXME(martinec) temporal assignation to avoid SC2034 warning

  # setup the Linux i686 package name prefix
  # e.g. Unitex-GramLab-3.1beta-linux-i686
  UNITEX_PACKAGE_LINUX_I686_PREFIX="$UNITEX_PACKAGE_FULL_NAME$UNITEX_BUILD_PACKAGE_LINUX_I686_SUFFIX"

  # setup the Linux x86_64 package name prefix
  # e.g. Unitex-GramLab-3.1beta-linux-x86_64
  UNITEX_PACKAGE_LINUX_X86_64_PREFIX="$UNITEX_PACKAGE_FULL_NAME$UNITEX_BUILD_PACKAGE_LINUX_X86_64_SUFFIX"

  # setup the man package name prefix
  # e.g. Unitex-GramLab-3.1beta-usermanual
  UNITEX_PACKAGE_MAN_PREFIX="$UNITEX_PACKAGE_FULL_NAME$UNITEX_BUILD_PACKAGE_MAN_SUFFIX"

  # preliminary test before version setup of the version revision
  svn info --trust-server-cert --non-interactive --username anonsvn --password anonsvn https://svnigm.univ-mlv.fr/svn/unitex > /dev/null || {
    UNITEX_BUILD_FULL_RELEASE="$UNITEX_BUILD_RELEASE"
    die_with_critical_error "SVN error" "Unable to access https://svnigm.univ-mlv.fr/svn/unitex"
  }
  
  # setup the version revision
  # e.g 3816
  UNITEX_VER_REVISION=$(svn info --trust-server-cert --non-interactive --username anonsvn --password anonsvn https://svnigm.univ-mlv.fr/svn/unitex | grep "^Revision" | cut "--delimiter= " --fields=2)

  # setup the version string
  # e.g 3.1.3816
  UNITEX_VER_STRING="$UNITEX_VER_MAJOR.$UNITEX_VER_MINOR.$UNITEX_VER_REVISION"
  if [ ! -z "${UNITEX_VER_SUFFIX}" ]; then
    # e.g 3.1.3816-beta
    UNITEX_VER_STRING="$UNITEX_VER_STRING-$UNITEX_VER_SUFFIX"
  fi  
  
  # setup the full version string
  # e.g. 3.1beta Rev. 3816
  UNITEX_VER_FULL="$UNITEX_VERSION Rev. $UNITEX_VER_REVISION"
  
  # setup the application release string
  # e.g. Unitex/Gramlab 3.1beta Rev. 3816
  UNITEX_BUILD_FULL_RELEASE="$UNITEX_PRETTYAPPNAME $UNITEX_VER_FULL"

  # The bundle releases version base directory
  # e.g /home/vinber/build/Unitex-GramLab/nightly/releases/3.1beta
  UNITEX_BUILD_RELEASES_VERSION_BASEDIR="$UNITEX_BUILD_RELEASES_BASEDIR/$UNITEX_VERSION"  

  # setup the bundle latest release directory
  # e.g /home/vinber/build/Unitex-GramLab/nightly/releases/latest-beta
  UNITEX_BUILD_RELEASES_LATESTDIR="$UNITEX_BUILD_RELEASES_BASEDIR/$UNITEX_BUILD_RELEASES_LATESTDIR_NAME"
}  # setup_release_information

# =============================================================================
# Prepare the unitex build environment
# this function perform several actions to configure the unitex build environment
function setup_build_environment() {

  # test if build home (e.g vinber/build/nightly) exists, create if not
  if [ ! -d "$UNITEX_BUILD_BUNDLE_BASEDIR" ]
  then
    # try to create a bundle workspace directory
    mkdir -p "$UNITEX_BUILD_BUNDLE_BASEDIR" || {
      die_with_critical_error "Aborting" "Failed to create a Bundle Workspace in $UNITEX_BUILD_BUNDLE_BASEDIR"
    }

    # change the rights of the bundle workspace directory
    if [ "$UNITEX_BUILD_CHANGE_RIGHTS" -eq 1 ]; then
        chown -f "$UNITEX_BUILD_CURRENT_USER:$UNITEX_BUILD_WEB_GROUP" \
                 "$UNITEX_BUILD_BUNDLE_BASEDIR"
    fi  

    # change the permissions of the bundle workspace directory (drwxrwsr-x)
    chmod 2775 "$UNITEX_BUILD_BUNDLE_BASEDIR"           
  fi  # [ ! -e $UNITEX_BUILD_BUNDLE_BASEDIR ]
  log_debug "Unitex bundle workspace" "$UNITEX_BUILD_BUNDLE_BASEDIR"

  # test if build home (e.g vinber/build/nightly/src) exists, create if not
  if [ ! -d "$UNITEX_BUILD_BUNDLE_SOURCE_BASEDIR" ]
  then
    # try to create the build directory
    mkdir -p "$UNITEX_BUILD_BUNDLE_SOURCE_BASEDIR" || {
      die_with_critical_error "Aborting" "Failed to create a Build Home in $UNITEX_BUILD_BUNDLE_SOURCE_BASEDIR"
    }

    # change the rights of the logger directory
    if [ "$UNITEX_BUILD_CHANGE_RIGHTS" -eq 1 ]; then
        chown -f "$UNITEX_BUILD_CURRENT_USER:$UNITEX_BUILD_WEB_GROUP" \
                 "$UNITEX_BUILD_BUNDLE_SOURCE_BASEDIR"
    fi  

    # change the permissions of the build home directory (drwxrwsr-x)
    chmod 2775 "$UNITEX_BUILD_BUNDLE_SOURCE_BASEDIR"           
  fi  # [ ! -e $UNITEX_BUILD_BUNDLE_SOURCE_BASEDIR ]
  log_debug "Bundle source base directory" "$UNITEX_BUILD_BUNDLE_SOURCE_BASEDIR"

  # test if build dist (e.g vinber/build/nightly/dist) exists, create if not
  if [ ! -d "$UNITEX_BUILD_DIST_BASEDIR" ]
  then
    # try to create the build directory
    mkdir -p "$UNITEX_BUILD_DIST_BASEDIR" || {
      die_with_critical_error "Aborting" "Failed to create a Build Dist in $UNITEX_BUILD_DIST_BASEDIR"
    }

    # change the rights of the logger directory
    if [ "$UNITEX_BUILD_CHANGE_RIGHTS" -eq 1 ]; then
        chown -f "$UNITEX_BUILD_CURRENT_USER:$UNITEX_BUILD_WEB_GROUP" \
                 "$UNITEX_BUILD_DIST_BASEDIR"
    fi  

    # change the permissions of the build dist directory (drwxrwsr-x)
    chmod 2775 "$UNITEX_BUILD_DIST_BASEDIR"           
  fi  # [ ! -e $UNITEX_BUILD_DIST_BASEDIR ]
  log_debug "Unitex dist directory" "$UNITEX_BUILD_DIST_BASEDIR"

  # test if build timestamp (e.g vinber/build/nightly/timestamp) exists, create if not
  if [ ! -d "$UNITEX_BUILD_TIMESTAMP_BASEDIR" ]
  then
    # try to create the timestamp directory
    mkdir -p "$UNITEX_BUILD_TIMESTAMP_BASEDIR" || {
      die_with_critical_error "Aborting" "Failed to create a Build Timestamp in $UNITEX_BUILD_TIMESTAMP_BASEDIR"
    }

    # change the rights of the timestamp directory
    if [ "$UNITEX_BUILD_CHANGE_RIGHTS" -eq 1 ]; then
        chown -f "$UNITEX_BUILD_CURRENT_USER:$UNITEX_BUILD_WEB_GROUP" \
                 "$UNITEX_BUILD_TIMESTAMP_BASEDIR"
    fi  

    # change the permissions of the build timestamp directory (drwxrwsr-x)
    chmod 2775 "$UNITEX_BUILD_TIMESTAMP_BASEDIR"           
  fi  # [ ! -e $UNITEX_BUILD_TIMESTAMP_BASEDIR ]
  log_debug "Timestamp base directory" "$UNITEX_BUILD_TIMESTAMP_BASEDIR"
  
  # test if build releases (e.g vinber/build/nightly/releases) exists, create if not
  if [ ! -d "$UNITEX_BUILD_RELEASES_BASEDIR" ]
  then
    # try to create the releases directory
    mkdir -p "$UNITEX_BUILD_RELEASES_BASEDIR" || {
      die_with_critical_error "Aborting" "Failed to create a Build Releases in $UNITEX_BUILD_RELEASES_BASEDIR"
    }

    # change the rights of the releases directory
    if [ "$UNITEX_BUILD_CHANGE_RIGHTS" -eq 1 ]; then
        chown -f "$UNITEX_BUILD_CURRENT_USER:$UNITEX_BUILD_WEB_GROUP" \
                 "$UNITEX_BUILD_RELEASES_BASEDIR"
    fi  

    # change the permissions of the releases directory (drwxrwsr-x)
    chmod 2775 "$UNITEX_BUILD_RELEASES_BASEDIR"           
  fi  # [ ! -e $UNITEX_BUILD_RELEASES_BASEDIR ]
  log_debug "Releases base directory" "$UNITEX_BUILD_RELEASES_BASEDIR"

  # test if version releases (e.g vinber/build/nightly/releases/3.1beta) exists, create if not
  if [ ! -d "$UNITEX_BUILD_RELEASES_VERSION_BASEDIR" ]
  then
    # try to create the version releases directory
    mkdir -p "$UNITEX_BUILD_RELEASES_VERSION_BASEDIR" || {
      die_with_critical_error "Aborting" "Failed to create a Version Build Releases in $UNITEX_BUILD_RELEASES_VERSION_BASEDIR"
    }

    # change the rights of the version releases directory
    if [ "$UNITEX_BUILD_CHANGE_RIGHTS" -eq 1 ]; then
        chown -f "$UNITEX_BUILD_CURRENT_USER:$UNITEX_BUILD_WEB_GROUP" \
                 "$UNITEX_BUILD_RELEASES_VERSION_BASEDIR"
    fi  

    # change the permissions of the version releases directory (drwxrwsr-x)
    chmod 2775 "$UNITEX_BUILD_RELEASES_VERSION_BASEDIR"           
  fi  # [ ! -e $UNITEX_BUILD_RELEASES_VERSION_BASEDIR ]
  log_debug "Releases version directory" "$UNITEX_BUILD_RELEASES_VERSION_BASEDIR"

  UNITEX_BUILD_SOURCE_DIR="$UNITEX_BUILD_BUNDLE_SOURCE_BASEDIR/$UNITEX_VERSION"
  if [ ! -d "$UNITEX_BUILD_SOURCE_DIR" ]; then
    mkdir "$UNITEX_BUILD_SOURCE_DIR"
  fi
  log_debug "Build source directory" "$UNITEX_BUILD_SOURCE_DIR"

  create_temporal_directory UNITEX_BUILD_TEMPORAL_WORKSPACE "$UNITEX_BUILD_SOURCE_DIR"
  if [ ! -d "$UNITEX_BUILD_TEMPORAL_WORKSPACE" ]; then
    die_with_critical_error "Unrecoverable error" "Error creating temporal workspace directory"
  fi
  log_debug "Temporal workspace" "$UNITEX_BUILD_TEMPORAL_WORKSPACE"

  UNITEX_BUILD_REPOSITORY_CORE_NAME="Unitex-C++"
  UNITEX_BUILD_REPOSITORY_CORE_LOCAL_PATH="$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_CORE_NAME"
  if [ ! -d "$UNITEX_BUILD_REPOSITORY_CORE_LOCAL_PATH" ]; then
    mkdir "$UNITEX_BUILD_REPOSITORY_CORE_LOCAL_PATH"
  fi
  log_debug "COREDIR dir" "$UNITEX_BUILD_REPOSITORY_CORE_LOCAL_PATH"

  UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_NAME="Unitex-Java"
  UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_LOCAL_PATH="$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_NAME"
  if [ ! -d "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_LOCAL_PATH" ]; then
    mkdir "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_LOCAL_PATH"
  fi
  log_debug "CLASSICIDEDIR dir" "$UNITEX_BUILD_REPOSITORY_CLASSIC_IDE_LOCAL_PATH"

  UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_NAME="GramLab"
  UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_LOCAL_PATH="$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_NAME"
  if [ ! -d "$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_LOCAL_PATH" ]; then
    mkdir "$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_LOCAL_PATH"
  fi
  log_debug "GRAMLABIDEDIR dir" "$UNITEX_BUILD_REPOSITORY_GRAMLAB_IDE_LOCAL_PATH"     

  UNITEX_BUILD_REPOSITORY_USERMANUAL_NAME="UnitexManual"
  UNITEX_BUILD_REPOSITORY_USERMANUAL_LOCAL_PATH="$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_USERMANUAL_NAME"
  if [ ! -d "$UNITEX_BUILD_REPOSITORY_USERMANUAL_LOCAL_PATH" ]; then
    mkdir "$UNITEX_BUILD_REPOSITORY_USERMANUAL_LOCAL_PATH"
  fi
  log_debug "Manual dir" "$UNITEX_BUILD_REPOSITORY_USERMANUAL_LOCAL_PATH"

  UNITEX_BUILD_REPOSITORY_LING_NAME="ling"
  UNITEX_BUILD_REPOSITORY_LING_LOCAL_PATH="$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_LING_NAME"
  if [ ! -d "$UNITEX_BUILD_REPOSITORY_LING_LOCAL_PATH" ]; then
    mkdir "$UNITEX_BUILD_REPOSITORY_LING_LOCAL_PATH"
  fi
  log_debug "Ling. res dir" "$UNITEX_BUILD_REPOSITORY_LING_LOCAL_PATH"

  UNITEX_BUILD_REPOSITORY_PACK_NAME="packaging"
  UNITEX_BUILD_REPOSITORY_PACK_LOCAL_PATH="$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_PACK_NAME"
  if [ ! -d "$UNITEX_BUILD_REPOSITORY_PACK_LOCAL_PATH" ]; then
    mkdir "$UNITEX_BUILD_REPOSITORY_PACK_LOCAL_PATH"
  fi
  log_debug "Packaging dir" "$UNITEX_BUILD_REPOSITORY_PACK_LOCAL_PATH"

  UNITEX_BUILD_REPOSITORY_PACK_WIN_NAME="packaging/windows"
  UNITEX_BUILD_REPOSITORY_PACK_WIN_LOCAL_PATH="$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_PACK_WIN_NAME"
  if [ ! -d "$UNITEX_BUILD_REPOSITORY_PACK_WIN_LOCAL_PATH" ]; then
    mkdir "$UNITEX_BUILD_REPOSITORY_PACK_WIN_LOCAL_PATH"
  fi
  log_debug "Packaging win dir" "$UNITEX_BUILD_REPOSITORY_PACK_WIN_LOCAL_PATH"

  UNITEX_BUILD_REPOSITORY_PACK_UNIX_NAME="packaging/unix"
  UNITEX_BUILD_REPOSITORY_PACK_UNIX_LOCAL_PATH="$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_PACK_UNIX_NAME"
  if [ ! -d "$UNITEX_BUILD_REPOSITORY_PACK_UNIX_LOCAL_PATH" ]; then
    mkdir "$UNITEX_BUILD_REPOSITORY_PACK_UNIX_LOCAL_PATH"
  fi
  log_debug "Packaging unix dir" "$UNITEX_BUILD_REPOSITORY_PACK_UNIX_LOCAL_PATH"  

  UNITEX_BUILD_REPOSITORY_LOGS_NAME="logs"
  UNITEX_BUILD_REPOSITORY_LOGS_LOCAL_PATH="$UNITEX_BUILD_SOURCE_DIR/$UNITEX_BUILD_REPOSITORY_LOGS_NAME"
  if [ ! -d "$UNITEX_BUILD_REPOSITORY_LOGS_LOCAL_PATH" ]; then
    mkdir "$UNITEX_BUILD_REPOSITORY_LOGS_LOCAL_PATH"
  fi
  log_debug "ULP dir" "$UNITEX_BUILD_REPOSITORY_LOGS_LOCAL_PATH" 

  UNITEX_BUILD_TIMESTAMP_DIR="$UNITEX_BUILD_TIMESTAMP_BASEDIR/$UNITEX_VERSION"
  if [ ! -d "$UNITEX_BUILD_TIMESTAMP_DIR" ]; then
    mkdir "$UNITEX_BUILD_TIMESTAMP_DIR"
  fi
  log_debug "Timestamp dir" "$UNITEX_BUILD_TIMESTAMP_DIR"

  # e.g. /home/vinber/build/Unitex-GramLab/nightly/releases/3.1beta
  UNITEX_BUILD_RELEASES_DIR="$UNITEX_BUILD_RELEASES_BASEDIR/$UNITEX_VERSION"
  if [ ! -d "$UNITEX_BUILD_RELEASES_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASES_DIR"
  fi
  log_debug "Packages dir" "$UNITEX_BUILD_RELEASES_DIR"

  # e.g. /home/vinber/build/Unitex-GramLab/nightly/releases/3.1beta/source
  UNITEX_BUILD_RELEASES_SOURCE_DIR="$UNITEX_BUILD_RELEASES_DIR/$UNITEX_BUILD_RELEASES_SOURCE_HOME_NAME"
  if [ ! -d "$UNITEX_BUILD_RELEASES_SOURCE_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASES_SOURCE_DIR"
  fi
  log_debug "Packages source dir" "$UNITEX_BUILD_RELEASES_SOURCE_DIR"

  # e.g. /home/vinber/build/Unitex-GramLab/nightly/releases/3.1beta/win32
  UNITEX_BUILD_RELEASES_SETUP_WIN32_DIR="$UNITEX_BUILD_RELEASES_DIR/$UNITEX_BUILD_RELEASES_WIN32_HOME_NAME"
  if [ ! -d "$UNITEX_BUILD_RELEASES_SETUP_WIN32_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASES_SETUP_WIN32_DIR"
  fi
  log_debug "Packages win32 dir" "$UNITEX_BUILD_RELEASES_SETUP_WIN32_DIR"

  # e.g. /home/vinber/build/Unitex-GramLab/nightly/releases/3.1beta/win64
  UNITEX_BUILD_RELEASES_SETUP_WIN64_DIR="$UNITEX_BUILD_RELEASES_DIR/$UNITEX_BUILD_RELEASES_WIN64_HOME_NAME"
  if [ ! -d "$UNITEX_BUILD_RELEASES_SETUP_WIN64_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASES_SETUP_WIN64_DIR"
  fi
  log_debug "Packages win64 dir" "$UNITEX_BUILD_RELEASES_SETUP_WIN64_DIR"

  # e.g. /home/vinber/build/Unitex-GramLab/nightly/releases/3.1beta/osx
  UNITEX_BUILD_RELEASES_OSX_DIR="$UNITEX_BUILD_RELEASES_DIR/$UNITEX_BUILD_RELEASES_OSX_HOME_NAME"
  if [ ! -d "$UNITEX_BUILD_RELEASES_OSX_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASES_OSX_DIR"
  fi
  log_debug "Packages osx dir" "$UNITEX_BUILD_RELEASES_OSX_DIR"

  # e.g. /home/vinber/build/Unitex-GramLab/nightly/releases/3.1beta/linux-i686
  UNITEX_BUILD_RELEASES_LINUX_I686_DIR="$UNITEX_BUILD_RELEASES_DIR/$UNITEX_BUILD_RELEASES_LINUX_I686_HOME_NAME"
  if [ ! -d "$UNITEX_BUILD_RELEASES_LINUX_I686_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASES_LINUX_I686_DIR"
  fi
  log_debug "Packages linux-i686 dir" "$UNITEX_BUILD_RELEASES_LINUX_I686_DIR"

  # e.g. /home/vinber/build/Unitex-GramLab/nightly/releases/3.1beta/linux-x86_64
  UNITEX_BUILD_RELEASES_LINUX_X86_64_DIR="$UNITEX_BUILD_RELEASES_DIR/$UNITEX_BUILD_RELEASES_LINUX_X86_64_HOME_NAME"
  if [ ! -d "$UNITEX_BUILD_RELEASES_LINUX_X86_64_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASES_LINUX_X86_64_DIR"
  fi
  log_debug "Packages Linux x86_64 dir" "$UNITEX_BUILD_RELEASES_LINUX_X86_64_DIR"

  # e.g. /home/vinber/build/Unitex-GramLab/nightly/dist/Unitex-GramLab-3.1beta
  UNITEX_BUILD_RELEASE_DIR="$UNITEX_BUILD_DIST_BASEDIR/$UNITEX_PACKAGE_FULL_NAME"
  # rm -rf "${UNITEX_BUILD_RELEASE_DIR:?}"
  # mkdir "$UNITEX_BUILD_RELEASE_DIR"
  if [ ! -d "$UNITEX_BUILD_RELEASE_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASE_DIR"
  fi
  log_debug "Unitex dir" "$UNITEX_BUILD_RELEASE_DIR" 

  UNITEX_BUILD_RELEASE_APP_DIR="$UNITEX_BUILD_RELEASE_DIR/App"
  if [ ! -d "$UNITEX_BUILD_RELEASE_APP_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASE_APP_DIR"
  fi
  log_debug "Unitex App dir" "$UNITEX_BUILD_RELEASE_APP_DIR"

  UNITEX_BUILD_RELEASE_APP_MANUAL_DIR="$UNITEX_BUILD_RELEASE_APP_DIR/manual"
  if [ ! -d "$UNITEX_BUILD_RELEASE_APP_MANUAL_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASE_APP_MANUAL_DIR"
  fi
  log_debug "Unitex Manual dir" "$UNITEX_BUILD_RELEASE_APP_MANUAL_DIR" 

  UNITEX_BUILD_RELEASE_SRC_DIR="$UNITEX_BUILD_RELEASE_DIR/Src"
  if [ ! -d "$UNITEX_BUILD_RELEASE_SRC_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASE_SRC_DIR"
  fi
  log_debug "Unitex Src dir" "$UNITEX_BUILD_RELEASE_SRC_DIR" 

  UNITEX_BUILD_RELEASE_SRC_CORE_DIR="$UNITEX_BUILD_RELEASE_SRC_DIR/C++"
  if [ ! -d "$UNITEX_BUILD_RELEASE_SRC_CORE_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASE_SRC_CORE_DIR"
  fi
  log_debug "Unitex Core Src dir" "$UNITEX_BUILD_RELEASE_SRC_CORE_DIR"

  UNITEX_BUILD_RELEASE_USERS_DIR="$UNITEX_BUILD_RELEASE_DIR/Users"
  if [ ! -d "$UNITEX_BUILD_RELEASE_USERS_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASE_USERS_DIR"
  fi
  log_debug "Unitex User dir" "$UNITEX_BUILD_RELEASE_USERS_DIR"

  UNITEX_BUILD_DOWNLOAD_WEB_PAGE="$UNITEX_BUILD_RELEASES_DIR/$UNITEX_BUILD_RELEASES_LATESTDIR_NAME.html"

  # e.g. /home/vinber/build/Unitex-GramLab/nightly/releases/3.1beta/lingua
  UNITEX_BUILD_RELEASES_LING_DIR="$UNITEX_BUILD_RELEASES_DIR/$UNITEX_BUILD_RELEASES_LING_HOME_NAME"
  if [ ! -d "$UNITEX_BUILD_RELEASES_LING_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASES_LING_DIR"
  fi
  log_debug "Unitex Ling Packages dir" "$UNITEX_BUILD_RELEASES_LING_DIR"

 # e.g. /home/vinber/build/Unitex-GramLab/nightly/releases/3.1beta/changes
  UNITEX_BUILD_RELEASES_CHANGES_DIR="$UNITEX_BUILD_RELEASES_DIR/$UNITEX_BUILD_RELEASES_CHANGES_HOME_NAME"
  if [ ! -d "$UNITEX_BUILD_RELEASES_CHANGES_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASES_CHANGES_DIR"
  fi
  log_debug "Unitex Log dir" "$UNITEX_BUILD_RELEASES_CHANGES_DIR"

  # e.g. /home/vinber/build/Unitex-GramLab/nightly/releases/3.1beta/man
  UNITEX_BUILD_RELEASES_MAN_DIR="$UNITEX_BUILD_RELEASES_DIR/$UNITEX_BUILD_RELEASES_MAN_HOME_NAME"
  if [ ! -d "$UNITEX_BUILD_RELEASES_MAN_DIR" ]; then
    mkdir "$UNITEX_BUILD_RELEASES_MAN_DIR"
  fi
  log_debug "Unitex Man dir" "$UNITEX_BUILD_RELEASES_MAN_DIR"

  # UNITEX_BUILD_SVN_LOG_LIMIT parameter
  if [[ $UNITEX_BUILD_SVN_LOG_LIMIT -ne -1 ]]; then
    UNITEX_BUILD_SVN_LOG_LIMIT_PARAMETER="--limit $UNITEX_BUILD_SVN_LOG_LIMIT"
    log_debug "SVN log limit" "SVN log output limit was set to $UNITEX_BUILD_SVN_LOG_LIMIT"
  else
    UNITEX_BUILD_SVN_LOG_LIMIT_PARAMETER=""
  fi
}

# temporally save std output/error
function push_streams() {
  # Save standard output(1->3) and standard error(2->4)
  exec 3>&1 4>&2
}  # function push_streams()

# Restore original outputs and close unused descriptors
function pop_streams() {
  # Restore original stdout/stderr
  exec 1>&3 2>&4
  # Close the unused descriptors
  exec 3>&- 4>&-
}

function redirect_std() {
  redirect_to_filename="$1"
  # Redirect standard output to a log file
  redirect_stdout "$redirect_to_filename"

  # Redirect standart error to the same log file
  exec 2>&1

  # Silent when NO_LOG_DEBUG is passed
  if [ $# -eq 1 ]; then
    log_debug "Streaming into" "$UNITEX_BUILD_CURRENT_STDOUT"
  fi
}

# Never call logger functions or die_with_critical_error from here
function redirect_stdout() {
  REDIRECT_TO_PARTIALNAME="$UNITEX_BUILD_LOG_WORKSPACE/$1"

  if [ "$UNITEX_BUILD_CURRENT_STDOUT" != \
       "$REDIRECT_TO_PARTIALNAME.$UNITEX_BUILD_LOG_FILE_EXT" ];then
    if [ -e "$REDIRECT_TO_PARTIALNAME.$UNITEX_BUILD_LOG_FILE_EXT" -a \
         -s "$REDIRECT_TO_PARTIALNAME.$UNITEX_BUILD_LOG_FILE_EXT" ] ; then
        FILENAME_SUFFIX_COUNTER=1
        while [[ -e $REDIRECT_TO_PARTIALNAME.$FILENAME_SUFFIX_COUNTER.$UNITEX_BUILD_LOG_FILE_EXT ]] ; do
            let FILENAME_SUFFIX_COUNTER++
        done
        REDIRECT_TO_PARTIALNAME=$REDIRECT_TO_PARTIALNAME.$FILENAME_SUFFIX_COUNTER
    fi

    # shellcheck disable=SC2034
    UNITEX_BUILD_PREVIOUS_STDOUT="$UNITEX_BUILD_CURRENT_STDOUT"
    UNITEX_BUILD_CURRENT_STDOUT="$REDIRECT_TO_PARTIALNAME.$UNITEX_BUILD_LOG_FILE_EXT"
    # Redirect standard output to a log file
    exec 1> "$UNITEX_BUILD_CURRENT_STDOUT"
  fi
}

function count_issues_until_now() {
  local __issues_variable=${1:?Output variable name required}
  local issues_count=$UNITEX_BUILD_COMMAND_EXECUTION_ERROR_COUNT

  # check if script is complete with no errors
  # 3=Message Error and 7=Message Panic
  for i in "${!UNITEX_BUILD_LOG_LEVEL_COUNTER[@]}"; do
    # shellcheck disable=SC2086  
    if [ $i -ge 3 -a $i -le 7 ]; then
      # shellcheck disable=SC2086
      if [ ${UNITEX_BUILD_LOG_LEVEL_COUNTER[$i]} -ge 1 ]; then
        issues_count=$(( issues_count + UNITEX_BUILD_LOG_LEVEL_COUNTER[i] ))
      fi
    fi  
  done

  # shellcheck disable=SC2140
  eval "$__issues_variable"="'$issues_count'"
}  # count_issues_until_now

# ATTENTION: avoid to send log messages from here
# ATTENTION: never die_with_critical_error from here !
function notify_recipients() {
  # test if the master log file exists and if isn't empty
  if [ "$UNITEX_BUILD_SEND_LOG_FILE_ATTACHMENT" -ne 0 -a \
       -e "$UNITEX_BUILD_LOG_FILE" -a \
       -s "$UNITEX_BUILD_LOG_FILE" ] ; then
    UNITEX_BUILD_LOG_FILE_ATTACHMENT="-a $UNITEX_BUILD_LOG_FILE"
  fi

  # test if logger workspace path exists
  if [ "$UNITEX_BUILD_SEND_ZIPPED_LOG_WORKSPACE_ATTACHMENT" -ne 0 -a \
        -d "$UNITEX_BUILD_LOG_WORKSPACE" ]; then
    push_directory "$UNITEX_BUILD_LOG_WORKSPACE"
    
    # Create a zipped log workspace copy
    UNITEX_BUILD_ZIPPED_LOG_WORKSPACE=$UNITEX_BUILD_TEMPORAL_WORKSPACE/$UNITEX_BUILD_LOG_NAME.zip
    $UNITEX_BUILD_TOOL_ZIP -qjr "$UNITEX_BUILD_ZIPPED_LOG_WORKSPACE" "$UNITEX_BUILD_LOG_WORKSPACE" -x ".*" > /dev/null
    if [ $? -eq 0 ]; then
      UNITEX_BUILD_ZIPPED_LOG_WORKSPACE_ATTACHMENT="-a $UNITEX_BUILD_ZIPPED_LOG_WORKSPACE"
    fi
    
    pop_directory
  fi


  # UNITEX_BUILD_LOG_ATTACHMENT_INFO
  local UNITEX_BUILD_LOG_ATTACHMENT_INFO=""
  if [ "$UNITEX_BUILD_SEND_LOG_FILE_ATTACHMENT" -ne 0 -o \
       "$UNITEX_BUILD_SEND_ZIPPED_LOG_WORKSPACE_ATTACHMENT" -ne 0 ]; then
      UNITEX_BUILD_LOG_ATTACHMENT_INFO=$(echo -e " For your convenience, I also included "
       "all those files in plain-text format as attachment.\n \n")
  fi    

  export EMAIL="$UNITEX_BUILD_VINBER_DESCRIPTION <nobody@univ-mlv.fr>"
  export REPLYTO="noreply@univ-mlv.fr"

  # UNITEX_BUILD_FIRST_ISSUE
  UNITEX_BUILD_FIRST_ISSUE=""
  if [ $UNITEX_BUILD_LOG_FIRST_ISSUE_NUMBER -ge 1 ]; then
    UNITEX_BUILD_LOG_FRONTEND_URL="$UNITEX_BUILD_LOG_FRONTEND_URL&line=$UNITEX_BUILD_LOG_FIRST_ISSUE_NUMBER&action=show"
    UNITEX_BUILD_FIRST_ISSUE=$(echo -e "The first problem I noticed was:\n \n" \
             "$UNITEX_BUILD_LOG_FIRST_ISSUE_MESSAGE: $UNITEX_BUILD_LOG_FIRST_ISSUE_DESCRIPTION\n")
    UNITEX_BUILD_RESULT_EMOJI="✖"  # ⚠
    UNITEX_BUILD_RESULT_GITTER_LEVEL="-d level=error"
  else
    UNITEX_BUILD_LOG_FRONTEND_URL="$UNITEX_BUILD_LOG_FRONTEND_URL"
    UNITEX_BUILD_RESULT_EMOJI="✔"  # ✅
    UNITEX_BUILD_RESULT_GITTER_LEVEL="-d level=info"
  fi

  # UNITEX_BUILD_FIRST_ISSUE_INFO
  local UNITEX_BUILD_INFO_MARKDOWN=""

  # UNITEX_BUILD_FIRST_ISSUE_INFO
  local UNITEX_BUILD_FIRST_ISSUE_INFO=""
  # only if repository is different from not-defined
  if [[ "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" != "$UNITEX_BUILD_NOT_DEFINED" ]]; then
    local -r first_issue_info_repository="$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_REPOSITORY_URL)"
    UNITEX_BUILD_FIRST_ISSUE_INFO=$(echo -e "\n"                                                              \
             "Repository: $(get_repository_url "$first_issue_info_repository")\n" \
             "Commit: $(get_commit_url "$first_issue_info_repository" "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_COMMIT)")\n"   \
             "Message: \"$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_MESSAGE)\"\n"     \
             "Author: $(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_AUTHOR)\n"           \
             "Date: $(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_DATE)\n \n")
   UNITEX_BUILD_INFO_MARKDOWN=$(echo -e "**Release**:    $UNITEX_BUILD_FULL_RELEASE\n"                 \
             "**Bundle**:     $UNITEX_BUILD_BUNDLE_NAME\n"                                                         \
             "**Build**:      [$UNITEX_BUILD_LOG_NAME]($UNITEX_BUILD_LOG_FRONTEND_URL)\n"                       \
             "**Status**:     $UNITEX_BUILD_RESULT_EMOJI $UNITEX_BUILD_STATUS_FAILED\n"                                                       \
             "**Error**:      $UNITEX_BUILD_LOG_FIRST_ISSUE_MESSAGE: $UNITEX_BUILD_LOG_FIRST_ISSUE_DESCRIPTION\n"  \
             "**Duration**:   $TOTAL_ELAPSED_TIME\n"                                                               \
             "**Repository**: [$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_REPOSITORY)]($(get_repository_url "$first_issue_info_repository"))\n" \
             "**Commit**:     [$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_COMMIT)]($(get_commit_url "$first_issue_info_repository" "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_COMMIT)"))\n"   \
             "**Message**:    *$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_MESSAGE)*\n"        \
             "**Author**:     @$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_AUTHOR)\n"         \
             "**Date**:       $(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_DATE)\n \n")
  fi
  
  # UNITEX_BUILD_LATEST_CHANGED_INFO
  local UNITEX_BUILD_LATEST_CHANGED_INFO=""
  if [[ "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" != "$UNITEX_BUILD_NOT_DEFINED" ]]; then
    local -r latest_changed_info_repository="$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_REPOSITORY_URL)"
    UNITEX_BUILD_LATEST_CHANGED_INFO=$(echo -e "The latest change was:\n \n"                                 \
             "Repository: $(get_repository_url "$latest_changed_info_repository")\n" \
             "Commit: $(get_commit_url "$latest_changed_info_repository" "$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_COMMIT)")\n"  \
             "Message: \"$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_MESSAGE)\"\n"     \
             "Author: $(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_AUTHOR)\n"           \
             "Date: $(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_DATE)\n \n")
   UNITEX_BUILD_INFO_MARKDOWN=$(echo -e "**Release**:    $UNITEX_BUILD_FULL_RELEASE\n"            \
             "**Bundle**:     $UNITEX_BUILD_BUNDLE_NAME\n"                                                       \
             "**Build**:      [$UNITEX_BUILD_LOG_NAME]($UNITEX_BUILD_LOG_FRONTEND_URL)\n"                     \
             "**Status**:     $UNITEX_BUILD_RESULT_EMOJI $UNITEX_BUILD_STATUS_PASSED\n"                                                     \
             "**Duration**:   $TOTAL_ELAPSED_TIME\n"                                                             \
             "**Repository**: [$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_REPOSITORY)]($(get_repository_url "$latest_changed_info_repository"))\n" \
             "**Commit**:     [$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_COMMIT)]($(get_commit_url "$latest_changed_info_repository" "$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_COMMIT)"))\n"  \
             "**Message**:    *$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_MESSAGE)*\n"     \
             "**Author**:     @$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_AUTHOR)\n"       \
             "**Date**:       $(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_DATE)\n \n")
  fi 

  # Push Gitter notification
  if [ "$UNITEX_BUILD_SERVICE_GITTER_NOTIFICATIONS" -ge 1 -a -n "${UNITEX_BUILD_SERVICE_GITTER_WEBHOOK_TOKEN+1}" ]; then
    $UNITEX_BUILD_TOOL_CURL -s "$UNITEX_BUILD_RESULT_GITTER_LEVEL" --data-urlencode "message=$UNITEX_BUILD_INFO_MARKDOWN" "$UNITEX_BUILD_SERVICE_GITTER_WEBHOOK_URL/$UNITEX_BUILD_SERVICE_GITTER_WEBHOOK_TOKEN" &> /dev/null
  fi
 
  if [ $UNITEX_BUILD_FINISH_WITH_ERROR_COUNT -ge 1 -a $UNITEX_BUILD_NOTIFY_ON_FAILURE -ge 1 ]; then
  
  # shellcheck disable=SC2086
  (echo "Dear developer,

         On $TIMESTAMP_START_C, I started to build the $UNITEX_BUILD_FULL_RELEASE distribution, but there are some issues which cannot be addressed without human intervention. $UNITEX_BUILD_FIRST_ISSUE
         $UNITEX_BUILD_FIRST_ISSUE_INFO
         For more details, please check out the full $UNITEX_BUILD_BUNDLE_NAME build-log:
         $UNITEX_BUILD_LOG_FRONTEND_URL
         $UNITEX_BUILD_LOG_ATTACHMENT_INFO
         
         Sincerely,

         --
         $UNITEX_BUILD_VINBER_CODENAME, the $UNITEX_BUILD_VINBER_DESCRIPTION
         $UNITEX_BUILD_VINBER_REPOSITORY_URL
         
         This is an automated notification - Please do not reply to this message
         "
         ) \
       | sed -e 's:^\s*::' | \
         $UNITEX_BUILD_TOOL_MUTT $UNITEX_BUILD_LOG_FILE_ATTACHMENT $UNITEX_BUILD_ZIPPED_LOG_WORKSPACE_ATTACHMENT \
            -s "$UNITEX_BUILD_RESULT_EMOJI [$UNITEX_BUILD_VINBER_CODENAME_LOWERCASE-$UNITEX_BUILD_BUNDLE_NAME] $UNITEX_BUILD_FULL_RELEASE build issues" \
            $EMAIL_CC -- $EMAIL_TO
  elif [ "$UNITEX_BUILD_FINISH_WITH_ERROR_COUNT" -eq 0 -a \( "$UNITEX_BUILD_NOTIFY_ON_FIXED" -ge 1 -o  "$UNITEX_BUILD_NOTIFY_ON_SUCESS" -ge 1 \) ]; then
     local subject_type="created"
     if [ "$UNITEX_BUILD_NOTIFY_ON_FIXED" -ge 1 ]; then
       subject_type="fixed"
     fi

    # shellcheck disable=SC2086
    (echo "Dear developer,

         Great news! The $UNITEX_BUILD_FULL_RELEASE $UNITEX_BUILD_BUNDLE_NAME build was successfully $subject_type! $UNITEX_BUILD_LATEST_CHANGED_INFO
         For more details, please check out the full $UNITEX_BUILD_BUNDLE_NAME build-log:
         $UNITEX_BUILD_LOG_FRONTEND_URL
         $UNITEX_BUILD_LOG_ATTACHMENT_INFO
         
         Sincerely,

         --
         $UNITEX_BUILD_VINBER_CODENAME, the $UNITEX_BUILD_VINBER_DESCRIPTION
         $UNITEX_BUILD_VINBER_REPOSITORY_URL
         
         This is an automated notification - Please do not reply to this message
         "
         ) \
       | sed -e 's:^\s*::' | \
         $UNITEX_BUILD_TOOL_MUTT $UNITEX_BUILD_LOG_FILE_ATTACHMENT $UNITEX_BUILD_ZIPPED_LOG_WORKSPACE_ATTACHMENT \
            -s "$UNITEX_BUILD_RESULT_EMOJI [$UNITEX_BUILD_VINBER_CODENAME_LOWERCASE-$UNITEX_BUILD_BUNDLE_NAME] $UNITEX_BUILD_FULL_RELEASE build $subject_type" \
            $EMAIL_CC -- $EMAIL_TO      
  fi
}

# =============================================================================
# notify_setup
# =============================================================================
function notify_recipients_setup() {
  local LOCAL_EMAIL_TO=""
  local LOCAL_EMAIL_CC="" 

  local -r UNITEX_BUILD_LAST_FAILED_AUTHOR_EMAIL="$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_AUTHOR_EMAIL)";

  # test if we need to notify the last committer
  if [ $UNITEX_BUILD_NOTIFY_LAST_COMMITTER -eq 1 ]; then
     if [[ "$UNITEX_BUILD_LAST_FAILED_AUTHOR_EMAIL" == *"@"* ]]; then
        if [ -z "$LOCAL_EMAIL_TO" ] ; then
          LOCAL_EMAIL_TO="$UNITEX_BUILD_LAST_FAILED_AUTHOR_EMAIL"
        else
          LOCAL_EMAIL_TO="$LOCAL_EMAIL_TO,$UNITEX_BUILD_LAST_FAILED_AUTHOR_EMAIL"   
        fi
     fi          
  fi  

  # test if we need to notify the extra recipients
  if [ $UNITEX_BUILD_NOTIFY_EXTRA_RECIPIENTS -eq 1 ]; then
     if [[ "$UNITEX_BUILD_EXTRA_RECIPIENTS" == *"@"* ]]; then
        if [ -z "$LOCAL_EMAIL_TO" ] ; then
          LOCAL_EMAIL_TO="$UNITEX_BUILD_EXTRA_RECIPIENTS"
        else
          LOCAL_EMAIL_TO="$LOCAL_EMAIL_TO,$UNITEX_BUILD_EXTRA_RECIPIENTS"   
        fi    
     fi          
  fi

  # test if we need to notify the devel list
  if [ $UNITEX_BUILD_NOTIFY_DEVEL_LIST -eq 1 ]; then
     if [[   "$UNITEX_BUILD_EXTRA_RECIPIENTS"          != *"$UNITEX_BUILD_DEVEL_LIST"* \
          && "$UNITEX_BUILD_LAST_FAILED_AUTHOR_EMAIL"  != *"$UNITEX_BUILD_DEVEL_LIST"* \
          && "$UNITEX_BUILD_DEVEL_LIST"                == *"@"* ]]; then
        if [ -z "$LOCAL_EMAIL_TO" ] ; then
          LOCAL_EMAIL_TO="$UNITEX_BUILD_DEVEL_LIST"
        else
          LOCAL_EMAIL_CC="-c $UNITEX_BUILD_DEVEL_LIST"
        fi
     fi          
  fi

  # In the worst case send a message to Vinber's maintainer
  if [ -z "$LOCAL_EMAIL_TO" -a -z "$LOCAL_EMAIL_CC" ]; then
    if [ $UNITEX_BUILD_NOTIFY_MAINTAINER -eq 1 ]; then
        LOCAL_EMAIL_TO="$UNITEX_BUILD_VINBER_MAINTAINER_EMAIL"
        LOCAL_EMAIL_CC=""
    fi  
  fi

  log_debug "Recipients" "UNITEX_BUILD_DEVEL_LIST=$(anonymize_mail_addresses "$UNITEX_BUILD_DEVEL_LIST")"
  log_debug "Recipients" "UNITEX_BUILD_NOTIFY_DEVEL_LIST=$UNITEX_BUILD_NOTIFY_DEVEL_LIST"
  log_debug "Recipients" "UNITEX_BUILD_LAST_FAILED_AUTHOR_EMAIL=$(anonymize_mail_addresses "$UNITEX_BUILD_LAST_FAILED_AUTHOR_EMAIL")"
  log_debug "Recipients" "UNITEX_BUILD_NOTIFY_LAST_COMMITTER=$UNITEX_BUILD_NOTIFY_LAST_COMMITTER"
  log_debug "Recipients" "UNITEX_BUILD_EXTRA_RECIPIENTS=$(anonymize_mail_addresses "$UNITEX_BUILD_EXTRA_RECIPIENTS")"
  log_debug "Recipients" "UNITEX_BUILD_NOTIFY_EXTRA_RECIPIENTS=$UNITEX_BUILD_NOTIFY_EXTRA_RECIPIENTS"
  log_debug "Recipients" "UNITEX_BUILD_VINBER_MAINTAINER_EMAIL=$(anonymize_mail_addresses "$UNITEX_BUILD_VINBER_MAINTAINER_EMAIL")"
  log_debug "Recipients" "EMAIL_TO=$(anonymize_mail_addresses "$LOCAL_EMAIL_TO")"
  log_debug "Recipients" "EMAIL_CC=$(anonymize_mail_addresses "$LOCAL_EMAIL_CC")"

  export EMAIL_TO="$LOCAL_EMAIL_TO"
  export EMAIL_CC="$LOCAL_EMAIL_CC"
}

# =============================================================================
# get vinber build repository info
# get_vinber_repository_info "$repository_key" index
# where index is a integer between 1 and $VINBER_BUILD_REPOSITORIES_ARRAY_SIZE (7)
#   1 ($VINBER_BUILD_REPOSITORY)
#   2 ($VINBER_BUILD_REVISION)
#   3 ($VINBER_BUILD_AUTHOR)
#   4 ($VINBER_BUILD_DATE)
#   5 ($VINBER_BUILD_MESSAGE)
#   6 ($VINBER_BUILD_AUTHOR_EMAIL)
#   7 ($VINBER_BUILD_AUTHOR_NAME)
#   8 ($VINBER_BUILD_REPOSITORY_URL)
#   9 ($VINBER_BUILD_REPOSITORY_TYPE)
# =============================================================================
function get_vinber_repository_info() {
  if [ $# -ne 2  ]; then
    die_with_critical_error "Vinber repository info fails" \
     "Internal repository info function called with the wrong number of parameters"
  fi

  local repository_key="$1"
  local array_index=$2

  if [ "$array_index" -le 0 -o "$array_index" -gt "$VINBER_BUILD_REPOSITORIES_ARRAY_SIZE" ]; then
    die_with_critical_error "Vinber repository info fails" \
     "Internal repository info function index parameter out of bounds [1-$VINBER_BUILD_REPOSITORIES_ARRAY_SIZE]"
  fi

  # test if repository key exists
  if [ ! "${VINBER_BUILD_REPOSITORIES[$repository_key]+exists}" ]; then
    repository_key="$UNITEX_BUILD_NOT_DEFINED"
  fi

  # shellcheck disable=SC2005
  echo "$(echo -n "${VINBER_BUILD_REPOSITORIES[$repository_key]}" | sed -n "$array_index"p)"
}

# =============================================================================
# get_repository_url
# =============================================================================
function get_repository_url() {
  if [ $# -ne 1  ]; then
    die_with_critical_error "Vinber get_repository_url fails" \
     "Function called with the wrong number of parameters"
  fi
  local url="$1"
  local repository="$1"

  if    [[ "$url" =~ univ-mlv.fr ]];     then
   repository="http://gforgeigm.univ-mlv.fr/scm/viewvc.php/$(echo -n "$url" | sed -e 's|^https:\/\/svnigm\.univ-mlv\.fr\/svn\/unitex\/||g')/?root=unitex"
  elif  [[ "$url" =~ github.com ]];      then
   repository=$(echo -n "$url" | sed -e 's|^git|https|g ; s|\.git||g')
  elif  [[ "$url" =~ googlecode.com ]];  then
   repository="https://code.google.com/p/${url%%.*}"
  fi

  # if(url) {
  #   switch(Handlebars.helpers.getURLDomain(url)) {
  #     case 'univ-mlv.fr':
  #       return 'http://gforgeigm.univ-mlv.fr/scm/viewvc.php/' +  url.replace(/^https:\/\/svnigm\.univ-mlv\.fr\/svn\/unitex\//mg,"") +  '/?root=unitex';
  #       break;
  #     case 'github.com':
  #       return  url.replace(/^git/mg, "https");
  #       break;
  #     case 'googlecode.com':
  #       return 'https://code.google.com/p/' + Handlebars.helpers.getURLSubdomain(url);
  #       break;
  #     default:
  #       return url;
  #       break;         
  #   }
  # }  
  # return '#';

  echo "$repository"
}

# =============================================================================
# get_commit_url
# =============================================================================
function get_commit_url() {
  if [ $# -ne 2  ]; then
    die_with_critical_error "Vinber get_commit_url fails" \
     "Function called with the wrong number of parameters"
  fi

  local url="$1"
  local commit_hash="$2"
  local commit_url="$1"

  # // https://example.net/user
  if    [[ "$url" =~ univ-mlv.fr ]];     then
   commit_url="http://gforgeigm.univ-mlv.fr/scm/viewvc.php?view=rev&root=unitex&revision=$commit_hash"
  elif  [[ "$url" =~ github.com ]];      then
   commit_url="$(echo -n "$url" | sed -e 's|^git|https|g ; s|\.git||g')/commit/$commit_hash"
  elif  [[ "$url" =~ googlecode.com ]];  then
   commit_url="https://code.google.com/p/${url%%.*}/source/detail?r=$commit_hash"
  fi


  # if(url) {
  #   switch(Handlebars.helpers.getURLDomain(url)) {
  #     case 'univ-mlv.fr':
  #       return 'http://gforgeigm.univ-mlv.fr/scm/viewvc.php?view=rev&root=unitex&revision=' + hash;
  #       break;
  #     case 'github.com':
  #       return  url.replace(/^git/mg, "https").replace(/\.git$/mg,"") + '/commit/' + hash;
  #       break;
  #     case 'googlecode.com':
  #       return 'https://code.google.com/p/' + Handlebars.helpers.getURLSubdomain(url) + '/source/detail?r=' + hash;
  #       break;
  #     default:
  #       return url;
  #       break;    
  #   }    
  # }
  # return '#';

  echo "$commit_url"
}

# =============================================================================
# get_user_url
# =============================================================================
function get_user_url() {
  if [ $# -ne 2  ]; then
    die_with_critical_error "Vinber get_user_url fails" \
     "Function called with the wrong number of parameters"
  fi
  local url="$1"
  local user_name="$2"
  local user_url="$user_name"

  # // "john.doe <email@example.com>" => "john.doe"
  if [[ "$user_name" =~ \< ]]; then
    user_name=${user_name%%<*}
    user_name=$(echo -n "$user_name" | sed -e 's/^ *//;s/ *$//')
  fi

  if    [[ "$url" =~ univ-mlv.fr ]];     then
   user_url="http://gforgeigm.univ-mlv.fr/users/$user_name"
  elif  [[ "$url" =~ github.com ]];      then
   user_url="https://github.com/$user_name";
  elif  [[ "$url" =~ googlecode.com ]];  then
   user_url="https://code.google.com/p/${url%%.*}/people/detail?u=$user_name"
  fi


  # if(url) {
  #   // "john.doe <email@example.com>" => "john.doe"
  #   if(user.indexOf('<') != -1) {
  #     user = user.substring(0,user.indexOf('<'));
  #   }

  #   // https://example.net/user    
  #   switch(Handlebars.helpers.getURLDomain(url)) {
  #     case 'univ-mlv.fr':
  #       return 'http://gforgeigm.univ-mlv.fr/users/' + user;
  #       break;
  #     case 'github.com':
  #       return 'https://github.com/'   + user;
  #       break;
  #     case 'googlecode.com':
  #       return 'https://code.google.com/p/' + Handlebars.helpers.getURLSubdomain(url) + '/people/detail?u=' + user;
  #       break;        
  #     default:
  #       return 'https://gravatar.com/' + user;
  #       break;    
  #   }
  # }
  # return '#';

  echo "$user_url"  
}

# =============================================================================
# notify_latest_changed_repository
# ATTENTION: never die_with_critical_error from here ! 
# =============================================================================
function notify_latest_changed_repository() {
  # Find the latest changed repository for this build
  local latest_date=0         # 1970-01-01 00:00:00 UTC
  local repository_date=0     # 1970-01-01 00:00:00 UTC
  # loop repositories
  for repository in "${!VINBER_BUILD_REPOSITORIES[@]}"; do
    repository_date=$(date --date="$(get_vinber_repository_info "$repository" $VINBER_BUILD_DATE)" +%s)
    if [ "$repository_date" -gt "$latest_date" ]; then
      latest_date="$repository_date"
      UNITEX_BUILD_LATEST_CHANGED_REPOSITORY="$repository"
    fi
  done

  if [[ "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" != "$UNITEX_BUILD_NOT_DEFINED" ]]; then
    log_info "Latest Repository" "$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_REPOSITORY_URL)"
    log_info "Latest Commit"     "$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_COMMIT)"
    log_info "Latest Author"     "$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_AUTHOR)"
    log_info "Latest Date"       "$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_DATE)"
    log_info "Latest Message"    "$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_MESSAGE)"  
  fi  
}

# =============================================================================
# notify finished activity
# ATTENTION: never die_with_critical_error from here ! 
# =============================================================================
function notify_finish() {
  push_stage "$UNITEX_BUILDER_NAME"

  # #size: ${#VINBER_BUILD_REPOSITORIES[@]}
  # log_info "used repositories" "${#VINBER_BUILD_REPOSITORIES[@]}"
  # for repository in "${!VINBER_BUILD_REPOSITORIES[@]}"; do
  #   log_info "a" "$(get_vinber_repository_info "$repository" $VINBER_BUILD_REPOSITORY)"
  #   log_info "b" "$(get_vinber_repository_info "$repository" $VINBER_BUILD_REVISION)"
  #   log_info "c" "$(get_vinber_repository_info "$repository" $VINBER_BUILD_AUTHOR)"
  #   log_info "d" "$(get_vinber_repository_info "$repository" $VINBER_BUILD_DATE)"
  #   log_info "e" "$(get_vinber_repository_info "$repository" $VINBER_BUILD_MESSAGE)"
  # done

  # setup notify senders recipients 
  notify_recipients_setup

  # notify about the latest changed repository
  notify_latest_changed_repository

  # notify about the first and last issues encountered
  notify_issue_message_numbers

  # notify number of messages for each log level >= warning
  notify_fail_log_level_count

  # notify number of fail executions
  notify_fail_command_execution_count

  # notify elapsed time
  notify_elapsed_time

  # count errors until now
  count_issues_until_now UNITEX_BUILD_FINISH_WITH_ERROR_COUNT

  # Remove files (e.g *$UNITEX_BUILD_UNTRACED.log) with zero size from the logger workspace
  # test first if logger workspace path exists
  if [ -d "$UNITEX_BUILD_LOG_WORKSPACE" ]; then
    push_directory "$UNITEX_BUILD_LOG_WORKSPACE"
    {
      find "$UNITEX_BUILD_LOG_WORKSPACE" -size 0 | \
           while read f; do rm -f "$f" ; done
    } & wait
    pop_directory
  fi

  # final message
  if [ $UNITEX_BUILD_FINISH_WITH_ERROR_COUNT -eq 0 ]; then
    if [ "$UNITEX_BUILD_NOTIFY_ON_SUCESS" -ge 1 -o "$UNITEX_BUILD_NOTIFY_ON_FIXED" -ge 1 ]; then
      log_notice "Notification " "Sending a notification message to $(anonymize_mail_addresses "$EMAIL_TO")"
    fi
    log_notice "Happy ending"   "$TIMESTAMP_FINISH_A"
  else
    log_notice "Sending alert" "Sending an alert message to $(anonymize_mail_addresses "$EMAIL_TO")"
    log_notice "Unhappy ending" "$TIMESTAMP_FINISH_A"
  fi



  # create the json version of the log file
  jsonize_master_log_file

  # create a latest-failed or latest-success symbolic link
  create_latest_symbolic_links

  # alert recipients
  notify_recipients
}

# =============================================================================
#  ATTENTION: avoid to send log messages from here
# =============================================================================
function create_latest_symbolic_links() {
  local -r build_status=$([ $UNITEX_BUILD_FINISH_WITH_ERROR_COUNT -gt 0 ] && echo -ne "$UNITEX_BUILD_STATUS_FAILED" || echo -ne "$UNITEX_BUILD_STATUS_PASSED")  
  local UNITEX_BUILD_LOG_LATEST_STATUS_SYMBOLIC_LINK="$UNITEX_BUILD_LOG_WORKSPACE_LATEST_SYMBOLIC_LINK-$build_status.$UNITEX_BUILD_LOG_FILE_EXT"
  local UNITEX_BUILD_LOG_JSON_LATEST_STATUS_SYMBOLIC_LINK="$UNITEX_BUILD_LOG_WORKSPACE_LATEST_SYMBOLIC_LINK-$build_status.$UNITEX_BUILD_LOG_JSON_EXT"
  local UNITEX_BUILD_LOG_WORKSPACE_LATEST_STATUS_SYMBOLIC_LINK="$UNITEX_BUILD_LOG_WORKSPACE_LATEST_SYMBOLIC_LINK-$build_status"

  # Create latest.log symbolic link
  rm  -f "$UNITEX_BUILD_LOG_LATEST_SYMBOLIC_LINK"
  ln -sf "$UNITEX_BUILD_LOG_FILE" "$UNITEX_BUILD_LOG_LATEST_SYMBOLIC_LINK"

  # Create latest.json symbolic link
  rm  -f "$UNITEX_BUILD_LOG_JSON_LATEST_SYMBOLIC_LINK"
  ln -sf "$UNITEX_BUILD_LOG_JSON" "$UNITEX_BUILD_LOG_JSON_LATEST_SYMBOLIC_LINK"

  # Create /latest directory symbolic link
  rm  -f "$UNITEX_BUILD_LOG_WORKSPACE_LATEST_SYMBOLIC_LINK"
  ln -sf "$UNITEX_BUILD_LOG_WORKSPACE" "$UNITEX_BUILD_LOG_WORKSPACE_LATEST_SYMBOLIC_LINK"

  # Create latest-status.log symbolic link
  rm  -f "$UNITEX_BUILD_LOG_LATEST_STATUS_SYMBOLIC_LINK"
  ln -sf "$UNITEX_BUILD_LOG_FILE" "$UNITEX_BUILD_LOG_LATEST_STATUS_SYMBOLIC_LINK"

  # Create latest-status.json symbolic link
  rm  -f "$UNITEX_BUILD_LOG_JSON_LATEST_STATUS_SYMBOLIC_LINK"
  ln -sf "$UNITEX_BUILD_LOG_JSON" "$UNITEX_BUILD_LOG_JSON_LATEST_STATUS_SYMBOLIC_LINK"
  
  # Create /latest-status directory symbolic link
  rm  -f "$UNITEX_BUILD_LOG_WORKSPACE_LATEST_STATUS_SYMBOLIC_LINK"
  ln -sf "$UNITEX_BUILD_LOG_WORKSPACE" "$UNITEX_BUILD_LOG_WORKSPACE_LATEST_STATUS_SYMBOLIC_LINK"

}  # create_latest_symbolic_links

# =============================================================================
#  ATTENTION: avoid to send log messages from here
# =============================================================================
function jsonize_master_log_file() {
  # delete last line : "}," in log.json
  sed  -i '$ d' "$UNITEX_BUILD_LOG_JSON"
  # put back again without the semicolon
  (echo -e "        }\n"        \
           "    ],"
  ) >> "$UNITEX_BUILD_LOG_JSON"


  local build_status="$UNITEX_BUILD_STATUS_PASSED"
  local issues_information=""
  local first_issue_repository=""
  local latest_issue_repository=""
  local latest_issue_information=""
  local latest_changed_repository=""
  local changes_information=""

  if [[ "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" != "$UNITEX_BUILD_NOT_DEFINED" ]]; then
   latest_changed_repository=$(echo -e ""                                                                                                       \
   "           \"repository\": {\n"                                                                                                             \
   "              \"name\":                \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_REPOSITORY)")\",\n"   \
   "              \"url\":                 \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_REPOSITORY_URL)")\",\n"   \
   "              \"type\":                \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_REPOSITORY_TYPE)")\",\n"   \
   "              \"commit\":              \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_COMMIT)")\",\n"  \
   "              \"author\":              \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_AUTHOR_NAME)")\",\n"   \
   "              \"date\":                \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_DATE)")\",\n"   \
   "              \"message\":             \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_MESSAGE)")\"\n"    \
   "            }\n"                                                                                                                            \
   | sed '/^\s*$/d')
 
   changes_information=$(echo -e ""        \
   "       \"changes\": {\n"               \
   "          \"latest\": {\n"             \
   "$latest_changed_repository\n"          \
   "           }\n"                        \
   "        },\n"                          \
   | sed '/^\s*$/d')
  fi 

  if [ $UNITEX_BUILD_FINISH_WITH_ERROR_COUNT -gt 0 ]; then
    build_status="$UNITEX_BUILD_STATUS_FAILED"

    if [[ "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" != "$UNITEX_BUILD_NOT_DEFINED" ]]; then
      first_issue_repository=$(echo -e ""                                                                                                            \
     "             \"repository\": {\n"                                                                                                              \
     "                \"name\":                \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_REPOSITORY)")\",\n"   \
     "                \"url\":                 \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_REPOSITORY_URL)")\",\n"   \
     "                \"type\":                \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_REPOSITORY_TYPE)")\",\n"   \
     "                \"commit\":              \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_COMMIT)")\",\n"  \
     "                \"author\":              \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_AUTHOR_NAME)")\",\n"   \
     "                \"date\":                \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_DATE)")\",\n"   \
     "                \"message\":             \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_MESSAGE)")\"\n"    \
     "              },\n"                                                                                                                            \
     | sed '/^\s*$/d')
    fi

    if [[ "$UNITEX_BUILD_LOG_LATEST_ISSUE_REPOSITORY" != "$UNITEX_BUILD_NOT_DEFINED" ]]; then
      latest_issue_repository=$(echo -e ""                                                                                                           \
     "           \"repository\": {\n"                                                                                                                \
     "              \"name\":                \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_LATEST_ISSUE_REPOSITORY" $VINBER_BUILD_REPOSITORY)")\",\n"    \
     "              \"url\":                 \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_LATEST_ISSUE_REPOSITORY" $VINBER_BUILD_REPOSITORY_URL)")\",\n"    \
     "              \"type\":                \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_LATEST_ISSUE_REPOSITORY" $VINBER_BUILD_REPOSITORY_TYPE)")\",\n"    \
     "              \"commit\":              \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_LATEST_ISSUE_REPOSITORY" $VINBER_BUILD_COMMIT)")\",\n"   \
     "              \"author\":              \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_LATEST_ISSUE_REPOSITORY" $VINBER_BUILD_AUTHOR_NAME)")\",\n"    \
     "              \"date\":                \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_LATEST_ISSUE_REPOSITORY" $VINBER_BUILD_DATE)")\",\n"    \
     "              \"message\":             \"$(json_escape "$(get_vinber_repository_info "$UNITEX_BUILD_LOG_LATEST_ISSUE_REPOSITORY" $VINBER_BUILD_MESSAGE)")\"\n"     \
     "            },\n"                                                                                                                              \
     | sed '/^\s*$/d')
    fi

    if [ x"$UNITEX_BUILD_LOG_FIRST_ISSUE_NUMBER" != x"$UNITEX_BUILD_LOG_LAST_ISSUE_NUMBER" ]; then
      latest_issue_information=$(echo -e ""                                                                         \
     "         },\n"                                                                                                \
     "          \"latest\": {\n"                                                                                    \
     "$latest_issue_repository\n"                                                                                   \
     "            \"number\":                \"$(json_escape "$UNITEX_BUILD_LOG_LAST_ISSUE_NUMBER")\",\n"           \
     "            \"type\":                  \"$(json_escape "$UNITEX_BUILD_LOG_LAST_ISSUE_TYPE")\",\n"             \
     "            \"message\":               \"$(json_escape "$UNITEX_BUILD_LOG_LAST_ISSUE_MESSAGE")\",\n"          \
     "            \"description\":           \"$(json_escape "$UNITEX_BUILD_LOG_LAST_ISSUE_DESCRIPTION")\"\n"       \
     | sed '/^\s*$/d')    
    fi

    issues_information=$(echo -e ""                                                                                \
   "       \"issues\": {\n"                                                                                        \
   "         \"first\": {\n"                                                                                       \
   "$first_issue_repository\n"                                                                                     \
   "           \"number\":                \"$(json_escape "$UNITEX_BUILD_LOG_FIRST_ISSUE_NUMBER")\",\n"            \
   "           \"type\":                  \"$(json_escape "$UNITEX_BUILD_LOG_FIRST_ISSUE_TYPE")\",\n"              \
   "           \"message\":               \"$(json_escape "$UNITEX_BUILD_LOG_FIRST_ISSUE_MESSAGE")\",\n"           \
   "           \"description\":           \"$(json_escape "$UNITEX_BUILD_LOG_FIRST_ISSUE_DESCRIPTION")\"\n"        \
   "$latest_issue_information\n"                                                                                   \
   "         }\n"                                                                                                  \
   "       },\n"                                                                                                   \
   | sed '/^\s*$/d')
  fi  

  local -r build_information=$(echo -e ""                                                                                \
   "   \"$UNITEX_BUILD_LOG_JSON_VINBER_BUILD_KEY\": {\n"                                                              \
   "      \"builder\": {\n"                                                                                           \
   "        \"name\":                      \"$(json_escape "$UNITEX_BUILD_VINBER_CODENAME")\",\n"                     \
   "        \"version\":                   \"$(json_escape "$UNITEX_BUILD_VINBER_VERSION")\"\n"                       \
   "      },\n"                                                                                                       \
   "      \"product\": {\n"                                                                                           \
   "        \"name\":                      \"$(json_escape "$UNITEX_PRETTYAPPNAME")\",\n"                             \
   "        \"license\":                   \"$(json_escape "$UNITEX_LICENSE")\",\n"                                   \
   "        \"version\": {\n"                                                                                         \
   "          \"string\":                  \"$(json_escape "$UNITEX_VER_STRING")\",\n"                                \
   "          \"full\":                    \"$(json_escape "$UNITEX_VER_FULL")\"\n"                                   \
   "        }\n"                                                                                                      \
   "      },\n"                                                                                                       \
   "      \"bundle\": {\n"                                                                                            \
   "        \"name\":                      \"$(json_escape "$UNITEX_BUILD_BUNDLE_NAME")\"\n"                          \
   "      },\n"                                                                                                       \
   "      \"build\": {\n"                                                                                             \
   "        \"name\":                      \"$(json_escape "$UNITEX_BUILD_LOG_NAME")\",\n"                            \
   "        \"started\":                   \"$(json_escape "$TIMESTAMP_START_A")\",\n"                                \
   "        \"status\":                    \"$(json_escape "$build_status")\",\n"                                     \
   "$issues_information\n"                                                                                            \
   "$changes_information\n"                                                                                           \
   "        \"finished\":                  \"$(json_escape "$TIMESTAMP_FINISH_A")\",\n"                               \
   "        \"duration\":                  \"$(json_escape "$TOTAL_ELAPSED_TIME")\"\n"                                \
   "      }\n"                                                                                                        \
   "   }\n"                                                                                                           \
   | sed '/^\s*$/d')

  (echo -e "$build_information\n"   \
           "}"
  ) >> "$UNITEX_BUILD_LOG_JSON"

  # =============================================================================
  # UNITEX_BUILD_LOG_BUILDS_JSON (builds.json) file
  # =============================================================================

  # Default values
  local build_message_number=1
  local build_message="unknown"
  local build_message_type="unknown"
  local build_description="unknown"
  local build_stage="$UNITEX_BUILD_CURRENT_STAGE"
  local repository_name=""
  local repository_url=""
  local repository_commit=""
  local repository_message=""
  local repository_type=""
  
  # if no errors
  if [ $UNITEX_BUILD_FINISH_WITH_ERROR_COUNT -eq 0 ]; then
    if [[ "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" != "$UNITEX_BUILD_NOT_DEFINED" ]]; then
       repository_name="$(get_vinber_repository_info    "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_REPOSITORY)"
       repository_url="$(get_vinber_repository_info     "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_REPOSITORY_URL)"
       repository_commit="$(get_vinber_repository_info  "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_COMMIT)"
       repository_message="$(get_vinber_repository_info "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_MESSAGE)"
       repository_type="$(get_vinber_repository_info    "$UNITEX_BUILD_LATEST_CHANGED_REPOSITORY" $VINBER_BUILD_REPOSITORY_TYPE)"
       build_stage="$repository_name"
       build_message="$repository_commit"
       build_message_type="commit"
       build_description="$repository_message"
    fi
  else
  # if errors    
    build_message_number="$UNITEX_BUILD_LOG_FIRST_ISSUE_NUMBER"  
    build_message="$UNITEX_BUILD_LOG_FIRST_ISSUE_MESSAGE"
    build_message_type="issue"
    build_description="$UNITEX_BUILD_LOG_FIRST_ISSUE_DESCRIPTION"
    if [[ "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" != "$UNITEX_BUILD_NOT_DEFINED" ]]; then
         repository_name="$(get_vinber_repository_info     "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_REPOSITORY)"
         repository_url="$(get_vinber_repository_info      "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_REPOSITORY_URL)"
         repository_commit="$(get_vinber_repository_info   "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_COMMIT)"
         repository_message="$(get_vinber_repository_info  "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_MESSAGE)"
         repository_type="$(get_vinber_repository_info     "$UNITEX_BUILD_LOG_FIRST_ISSUE_REPOSITORY" $VINBER_BUILD_REPOSITORY_TYPE)"
         build_stage="$repository_name"
    fi
  fi

  local build_stage_url="#bundle=$UNITEX_BUILD_BUNDLE_NAME&q=$UNITEX_BUILD_LOG_NAME&line=$build_message_number"

  if [ ! -z "$repository_url" ]; then
      build_stage_url="$repository_url"
  fi    

  # 1. Setup column number
  local column_number="1"
  if [ -s "$UNITEX_BUILD_LOG_BUILDS_JSON" ]; then
   local -r next_number=$(sed -e '$!d ; s/.*number":\s*"\([^,]\+\)".*/\1+1/g' "$UNITEX_BUILD_LOG_BUILDS_JSON")
   column_number=$(echo -ne "$next_number\n" | bc)
  fi

  # 2. Setup column level
  local column_level="data-json={ \"bundle_name\" : \"$UNITEX_BUILD_BUNDLE_NAME\", \"build_name\" : \"$UNITEX_BUILD_LOG_NAME\", \"build_status\": \"$build_status\",  \"build_message_number\" : \"$build_message_number\" }"

  # 3.  Setup column stage
  local column_stage="data-json={ \"repository_name\" : \"$build_stage\", \"repository_url\" : \"$build_stage_url\",  \"repository_type\" : \"$repository_type\" }"

  # 4 Setup column message
  local column_message="data-json={ \"build_message\" : \"$build_message\", \"build_message_type\" : \"$build_message_type\", \"build_message_url\" : \"$build_stage_url\"  }"

  # 5 Setup column description
  local column_description="$build_description"

  # Comma helper
  local -r build_comma=$([ -s "$UNITEX_BUILD_LOG_BUILDS_JSON" ] && echo -ne ",\n \n" || echo -ne " ")

  # Write builds.json
  (echo -ne "$build_comma{"                                        \
      "\"number\":      \"$(json_escape "$column_number")\", "      \
      "\"level\":       \"$(json_escape "$column_level")\", "       \
      "\"stage\":       \"$(json_escape "$column_stage")\", "       \
      "\"message\":     \"$(json_escape "$column_message")\", "     \
      "\"description\": \"$(json_escape "$column_description")\" "  \
      "}"
  ) >> "$UNITEX_BUILD_LOG_BUILDS_JSON"
}

# =============================================================================
# remove intermediate files
# Never log a message from here
# =============================================================================
function remove_intermediate_files() {
  rm -rf "${UNITEX_BUILD_TEMPORAL_WORKSPACE:?}"
  #true;
}

# =============================================================================
# Push directory with logging check
# =============================================================================
function push_directory() {
 if [ -d "$1" ]; then
  pushd "$1" > /dev/null
 else
  log_warn "Directory not found" "The $1 directory doesn't exist"
 fi
}  # push_directory()

# =============================================================================
# Pop directory without error message
# =============================================================================
function pop_directory() {
 popd > /dev/null
} # pop_directory

# =============================================================================
# print usage options
function usage() {
    echo "Usage:"
    echo "  $SCRIPT_NAME [OPTIONS] [CONFIGURATION_FILE]"
    echo "Options:"
    echo "  -v|--verbosity=N  : manually set the verbosity level 0...7"
    exit 1
}  # usage()

# =============================================================================
# process command line
# ATTENTION NEVER USE LOG FUNCTIONS FROM HERE !
function process_command_line() {
  # parse command line
  while getopts "h?v:" opt; do
      case "$opt" in
      h|\?)
          usage
          ;;
      v)  UNITEX_BUILD_VERBOSITY=$OPTARG
          if ! [[ $UNITEX_BUILD_VERBOSITY =~ $UNITEX_BUILD_VERBOSITY_LEVELS ]] ; then
           echo "./$SCRIPT_NAME: bad verbosity level"
           usage
          fi
          ;;
      esac
  done

  shift $((OPTIND-1))

  [ "$1" = "--" ] && shift

  # the last argument would be the name of configuration file or nothing
  if [ $# -gt 1 ]
  then
     echo "./$SCRIPT_NAME: too many arguments"
     usage
  fi  

  # if exists, the last argument would be the name of configuration file
  if [ $# -eq 1 ]
  then
     UNITEX_BUILD_CONFIG_FILENAME="${*: -1:1}"
  fi

  # VINBER_CONFIG_FILENAME environment variable could overwrite UNITEX_BUILD_CONFIG_FILENAME
  if [ -n "${VINBER_CONFIG_FILENAME+1}" ]; then
     # use the environment config
     UNITEX_BUILD_CONFIG_FILENAME="$VINBER_CONFIG_FILENAME"
  fi

  # UNITEX_BUILD_CONFIG_FILENAME
  UNITEX_BUILD_CONFIG_FILENAME="$(readlink -f "$UNITEX_BUILD_CONFIG_FILENAME")"

  # if the config file doesn't exist
  if [ ! -e "$UNITEX_BUILD_CONFIG_FILENAME" ]; then
    # try to create a new one duplicating the configuration template (vinber.conf.in)
    if [ -e "$UNITEX_BUILD_CONFIG_TEMPLATE_FILENAME" ]; then
      # copy but not overwrite vinber.conf
      if [ ! -e "vinber.conf" ]; then
       cp "$UNITEX_BUILD_CONFIG_TEMPLATE_FILENAME" "vinber.conf" > /dev/null
      fi 
    fi
    echo "./$SCRIPT_NAME: $UNITEX_BUILD_CONFIG_FILENAME file not found"
    echo "try e.g.: ./$SCRIPT_NAME vinber.conf"
    exit 1
  fi

  # only read config file if isn't world writable
  if [[ $(stat --format %a "$UNITEX_BUILD_CONFIG_FILENAME") == 600 ]]; then
       . "$UNITEX_BUILD_CONFIG_FILENAME"
  else
    echo "./$SCRIPT_NAME: wrong permissions"
    echo "Configuration file $UNITEX_BUILD_CONFIG_FILENAME, should not be world writable!"
    exit 1
  fi
}  # function process_command_line()
# =============================================================================

# =============================================================================
# check bash version
# ATTENTION NEVER USE LOG FUNCTIONS FROM HERE !
function check_bash_version() {
  local -r bash_version_string="${BASH_VERSION%%[^0-9.]*}"
  local -r bash_version_major="${BASH_VERSINFO[0]}"
  local -r bash_version_minor="${BASH_VERSINFO[1]}"
  local -r bash_version_patch="${BASH_VERSINFO[2]}"

  #          $bash_version_major * (major <= +INF)
  # 100000 + $bash_version_minor * (minor <= 99)
  # 1000   + $bash_version_patch   (patch <= 999)
  local -r bash_version_number=$(echo "$bash_version_major  * 100000 \
                                     + $bash_version_minor  * 1000 + \
                                       $bash_version_patch" | bc)

  # check bash version
  if [ "$bash_version_number" -lt "$UNITEX_BUILD_MINIMAL_BASH_VERSION_NUMBER" ]; then
    echo "Bad Bash version: Required($UNITEX_BUILD_MINIMAL_BASH_VERSION_STRING) - Using($bash_version_string)"
    exit 1
  fi
}  

# =============================================================================
# 0. process_command_line, arguments are in $@
process_command_line "$@"

# =============================================================================
# 0. check_bash_version
check_bash_version

# =============================================================================
# 0. setup_user_environment
setup_user_environment

# =============================================================================
# 1. push streams
push_streams

# =============================================================================
# 4. Load dependencies configuration
load_deps_conf

# =============================================================================
# 4. Load svn authors configuration
load_authors_conf

# =============================================================================
# 4. setup the path environment
setup_path_environment

# =============================================================================
# load previous build status (always before setup_log_environment())
load_previous_build_status

# =============================================================================
# 2. setup the log environment
setup_log_environment

# =============================================================================
# 3. Push main stage
push_stage "$UNITEX_BUILDER_NAME"

# =============================================================================
# 4. Install Interrupt (INT), Terminate (TERM) traps
setup_script_traps
  
# =============================================================================
# 5. Setup config environment
print_config_environment

# =============================================================================
# 3. check for previous issues
check_previous_issues

# =============================================================================
# 3. setup unitex version strings
setup_release_information

# =============================================================================
# 6. script variables sanity check
check_script_variables

# =============================================================================
# 7. tools sanity check
check_build_tools

# =============================================================================
# 8. setup the build environment (always before setup_release_information)
setup_build_environment

# =============================================================================
# 8. print_release_information
print_release_information

# =============================================================================
# 9. call main function
main

# =============================================================================
# 10. clean exit
clean_exit
