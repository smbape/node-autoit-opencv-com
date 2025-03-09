#!/usr/bin/env bash

# ================================================================
#!/bin/sh
#
# Constants and functions for terminal colors.
# Author: Max Tsepkov <max@yogi.pw>

CLR_ESC="\033["

# All these variables has a function with the same name, but in lower case.
#
CLR_RESET=0             # reset all attributes to their defaults
CLR_RESET_UNDERLINE=24  # underline off
CLR_RESET_REVERSE=27    # reverse off
CLR_DEFAULT=39          # set underscore off, set default foreground color
CLR_DEFAULTB=49         # set default background color

CLR_BOLD=1              # set bold
CLR_BRIGHT=2            # set half-bright (simulated with color on a color display)
CLR_UNDERSCORE=4        # set underscore (simulated with color on a color display)
CLR_REVERSE=7           # set reverse video

CLR_BLACK=30            # set black foreground
CLR_RED=31              # set red foreground
CLR_GREEN=32            # set green foreground
CLR_BROWN=33            # set brown foreground
CLR_BLUE=34             # set blue foreground
CLR_MAGENTA=35          # set magenta foreground
CLR_CYAN=36             # set cyan foreground
CLR_WHITE=37            # set white foreground

CLR_BLACKB=40           # set black background
CLR_REDB=41             # set red background
CLR_GREENB=42           # set green background
CLR_BROWNB=43           # set brown background
CLR_BLUEB=44            # set blue background
CLR_MAGENTAB=45         # set magenta background
CLR_CYANB=46            # set cyan background
CLR_WHITEB=47           # set white background

# General function to wrap string with escape sequence(s).
# Ex: clr_escape foobar $CLR_RED $CLR_BOLD
clr_escape() {
    local result="$1"
    until [ -z "$2" ]; do
        if ! [ $2 -ge 0 -a $2 -le 47 ] 2>/dev/null; then
            echo "clr_escape: argument \"$2\" is out of range" >&2 && return 1
        fi
        result="${CLR_ESC}${2}m${result}${CLR_ESC}${CLR_RESET}m"
        shift || break
    done

    echo -e "$result"
}

clr_reset()           { clr_escape "$1" $CLR_RESET;           }
clr_reset_underline() { clr_escape "$1" $CLR_RESET_UNDERLINE; }
clr_reset_reverse()   { clr_escape "$1" $CLR_RESET_REVERSE;   }
clr_default()         { clr_escape "$1" $CLR_DEFAULT;         }
clr_defaultb()        { clr_escape "$1" $CLR_DEFAULTB;        }
clr_bold()            { clr_escape "$1" $CLR_BOLD;            }
clr_bright()          { clr_escape "$1" $CLR_BRIGHT;          }
clr_underscore()      { clr_escape "$1" $CLR_UNDERSCORE;      }
clr_reverse()         { clr_escape "$1" $CLR_REVERSE;         }
clr_black()           { clr_escape "$1" $CLR_BLANK;           }
clr_red()             { clr_escape "$1" $CLR_RED;             }
clr_green()           { clr_escape "$1" $CLR_GREEN;           }
clr_brown()           { clr_escape "$1" $CLR_BROWN;           }
clr_blue()            { clr_escape "$1" $CLR_BLUE;            }
clr_magenta()         { clr_escape "$1" $CLR_MAGENTA;         }
clr_cyan()            { clr_escape "$1" $CLR_CYAN;            }
clr_white()           { clr_escape "$1" $CLR_WHITE;           }
clr_blackb()          { clr_escape "$1" $CLR_BLACKB;          }
clr_redb()            { clr_escape "$1" $CLR_REDB;            }
clr_greenb()          { clr_escape "$1" $CLR_GREENB;          }
clr_brownb()          { clr_escape "$1" $CLR_BROWNB;          }
clr_blueb()           { clr_escape "$1" $CLR_BLUEB;           }
clr_magentab()        { clr_escape "$1" $CLR_MAGENTAB;        }
clr_cyanb()           { clr_escape "$1" $CLR_CYANB;           }
clr_whiteb()          { clr_escape "$1" $CLR_WHITEB;          }

# Outputs colors table
clr_dump() {
    local T='gYw'

    echo -e "\n                 40m     41m     42m     43m     44m     45m     46m     47m";

    for FGs in '   0m' '   1m' '  30m' '1;30m' '  31m' '1;31m' \
               '  32m' '1;32m' '  33m' '1;33m' '  34m' '1;34m' \
               '  35m' '1;35m' '  36m' '1;36m' '  37m' '1;37m';
    do
        FG=${FGs// /}
        echo -en " $FGs \033[$FG  $T  "
        for BG in 40m 41m 42m 43m 44m 45m 46m 47m; do
            echo -en " \033[$FG\033[$BG  $T  \033[0m";
        done
        echo;
    done

    echo
    clr_bold "    Code     Function           Variable"
    echo \
'    0        clr_reset          $CLR_RESET
    1        clr_bold           $CLR_BOLD
    2        clr_bright         $CLR_BRIGHT
    4        clr_underscore     $CLR_UNDERSCORE
    7        clr_reverse        $CLR_REVERSE

    30       clr_black          $CLR_BLACK
    31       clr_red            $CLR_RED
    32       clr_green          $CLR_GREEN
    33       clr_brown          $CLR_BROWN
    34       clr_blue           $CLR_BLUE
    35       clr_magenta        $CLR_MAGENTA
    36       clr_cyan           $CLR_CYAN
    37       clr_white          $CLR_WHITE

    40       clr_blackb         $CLR_BLACKB
    41       clr_redb           $CLR_REDB
    42       clr_greenb         $CLR_GREENB
    43       clr_brownb         $CLR_BROWNB
    44       clr_blueb          $CLR_BLUEB
    45       clr_magentab       $CLR_MAGENTAB
    46       clr_cyanb          $CLR_CYANB
    47       clr_whiteb         $CLR_WHITEB
'
}

clr_bblack()   { clr_escape "$1" $CLR_BLANK $CLR_BOLD;   }
clr_bred()     { clr_escape "$1" $CLR_RED $CLR_BOLD;     }
clr_bgreen()   { clr_escape "$1" $CLR_GREEN $CLR_BOLD;   }
clr_bbrown()   { clr_escape "$1" $CLR_BROWN $CLR_BOLD;   }
clr_bblue()    { clr_escape "$1" $CLR_BLUE $CLR_BOLD;    }
clr_bmagenta() { clr_escape "$1" $CLR_MAGENTA $CLR_BOLD; }
clr_bcyan()    { clr_escape "$1" $CLR_CYAN $CLR_BOLD;    }
clr_bwhite()   { clr_escape "$1" $CLR_WHITE $CLR_BOLD;   }
# ================================================================

die() {
    clr_bred "ERROR: $1"
    [ $2 ] && exit $2 || exit 1
}

set -o pipefail

NEW_VERSION_DEFAULT="${NEW_VERSION_DEFAULT:-patch}"

function stash_push() {
    git stash push --include-untracked
}

function new_version() {
    local new_version="${1:-${NEW_VERSION:-"${NEW_VERSION_DEFAULT}"}}"
    npm version "$new_version"
}

function new_version_rollback() {
    local msg version

    local continue=1
    local found_version=0
    while [ $continue -eq 1 ]; do
        continue=0

        msg="$(git log -1 --pretty=format:%s)"
        if [ "v$msg" == "$(git tag -l "v$msg")" ];  then
            git tag -d "v$msg" || return $?
            continue=1
        fi

        version="$(node -pe "require('./package').version")"
        if [ "$msg" == "$version" ]; then
            if [ $found_version -eq 0 ]; then
                found_version=1
                NEW_VERSION_DEFAULT="$version"
            fi
            git reset --hard HEAD~1 -- || return $?
            continue=1
        fi
    done
}

function update_new_version() {
    # reset touched files
    git diff --quiet HEAD --

    if git diff-index --quiet HEAD --; then
        return
    fi

    local times_file=out/build/x64-Debug/times.bin
    mkdir -p "$(dirname "$times_file")"

    git add --renormalize . && \
    find $(git diff --diff-filter=d --name-only HEAD --) -mindepth 0 -maxdepth 0 -type f -printf '%A@ %T@ %p\0' > "$times_file" && \
    git stash push && \
    new_version_rollback || return $?

    local new_version="${1:-${NEW_VERSION:-"${NEW_VERSION_DEFAULT}"}}"
    git stash pop && \
    perl -MTime::HiRes=utime -0 -ne 'chomp; my ($atime, $mtime, $file) = split(/ /, $_, 3); utime $atime, $mtime, $file;' < "$times_file" || return $?

    for ifile in $(git diff --diff-filter=d --name-only HEAD --); do
        git add "$ifile" || return $?
    done

    for ifile in $(git diff --diff-filter=D --name-only HEAD --); do
        git rm "$ifile" || return $?
    done

    git commit --amend --no-edit && \
    new_version "${new_version}" && \
    rm -f "$times_file"
}
