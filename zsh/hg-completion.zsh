#compdef hg

# Zsh completion script for mercurial.  Rename this file to _hg and copy
# it into your zsh function path (/usr/share/zsh/site-functions for
# instance)
#
# If you do not want to install it globally, you can copy it somewhere
# else and add that directory to $fpath. This must be done before
# compinit is called. If the file is copied to ~/.zsh.d, your ~/.zshrc
# file could look like this:
#
# fpath=("$HOME/.zsh.d" $fpath)
# autoload -U compinit
# compinit
#
# Copyright (C) 2005, 2006 Steve Borho <steve@borho.org>
# Copyright (C) 2006-10 Brendan Cully <brendan@kublai.com>
#
# Permission is hereby granted, without written agreement and without
# licence or royalty fees, to use, copy, modify, and distribute this
# software and to distribute modified versions of this software for any
# purpose, provided that the above copyright notice and the following
# two paragraphs appear in all copies of this software.
#
# In no event shall the authors be liable to any party for direct,
# indirect, special, incidental, or consequential damages arising out of
# the use of this software and its documentation, even if the authors
# have been advised of the possibility of such damage.
#
# The authors specifically disclaim any warranties, including, but not
# limited to, the implied warranties of merchantability and fitness for
# a particular purpose.  The software provided hereunder is on an "as
# is" basis, and the authors have no obligation to provide maintenance,
# support, updates, enhancements, or modifications.

emulate -LR zsh
setopt extendedglob

local curcontext="$curcontext" state line
typeset -A _hg_cmd_globals

_hg() {
  local cmd _hg_root
  integer i=2
  _hg_cmd_globals=()

  while (( i < $#words ))
  do
    case "$words[$i]" in
      -R|--repository)
        eval _hg_root="$words[$i+1]"
        _hg_cmd_globals+=("$words[$i]" "$_hg_root")
        (( i += 2 ))
        continue
      ;;
      -R*)
        _hg_cmd_globals+="$words[$i]"
        eval _hg_root="${words[$i]#-R}"
       (( i++ ))
       continue
      ;;
      --cwd|--config)
        # pass along arguments to hg completer
        _hg_cmd_globals+=("$words[$i]" "$words[$i+1]")
        (( i += 2 ))
        continue
      ;;
      -*)
        # skip option
        (( i++ ))
        continue
      ;;
    esac
    if [[ -z "$cmd" ]]
    then
      cmd="$words[$i]"
      words[$i]=()
      (( CURRENT-- ))
    fi
    (( i++ ))
  done

  if [[ -z "$cmd" ]]
  then
    _arguments -s -w : $_hg_global_opts \
    ':mercurial command:_hg_commands'
    return
  fi

  # resolve abbreviations and aliases
  if ! (( $+functions[_hg_cmd_${cmd}] ))
  then
    local cmdexp
    (( $#_hg_cmd_list )) || _hg_get_commands

    cmdexp=$_hg_cmd_list[(r)${cmd}*]
    if [[ $cmdexp == $_hg_cmd_list[(R)${cmd}*] ]]
    then
      # might be nice to rewrite the command line with the expansion
      cmd="$cmdexp"
    fi
    if [[ -n $_hg_alias_list[$cmd] ]]
    then
      cmd=$_hg_alias_list[$cmd]
    fi
  fi

  curcontext="${curcontext%:*:*}:hg-${cmd}:"

  zstyle -s ":completion:$curcontext:" cache-policy update_policy

  if [[ -z "$update_policy" ]]
  then
    zstyle ":completion:$curcontext:" cache-policy _hg_cache_policy
  fi

  if (( $+functions[_hg_cmd_${cmd}] ))
  then
    _hg_cmd_${cmd}
  else
    # complete unknown commands normally
    _arguments -s -w : $_hg_global_opts \
      '*:files:_hg_files'
  fi
}

_hg_cache_policy() {
  typeset -a old

  # cache for a minute
  old=( "$1"(mm+10) )
  (( $#old )) && return 0

  return 1
}

_hg_get_commands() {
  typeset -ga _hg_cmd_list
  typeset -gA _hg_alias_list
  local hline cmd cmdalias

  _call_program hg hg debugcomplete -v | while read -A hline
  do
    cmd=$hline[1]
    _hg_cmd_list+=($cmd)

    for cmdalias in $hline[2,-1]
    do
      _hg_cmd_list+=($cmdalias)
      _hg_alias_list+=($cmdalias $cmd)
    done
  done
}

_hg_commands() {
  (( $#_hg_cmd_list )) || _hg_get_commands
  _describe -t commands 'mercurial command' _hg_cmd_list
}

_hg_revrange() {
  compset -P 1 '*:'
  _hg_labels "$@"
}

_hg_labels() {
  labels=("${(f)$(_hg_cmd debugnamecomplete)}")
  (( $#labels )) && _describe -t labels 'labels' labels
}

_hg_bookmarks() {
  typeset -a bookmark bookmarks

  _hg_cmd bookmarks | while read -A bookmark
  do
    if test -z ${bookmark[-1]:#[0-9]*}
    then
      bookmarks+=($bookmark[-2])
    fi
  done
  (( $#bookmarks )) && _describe -t bookmarks 'bookmarks' bookmarks
}

_hg_branches() {
  typeset -a branches
  local branch

  _hg_cmd branches | while read branch
  do
    branches+=(${branch/ #[0-9]#:*})
  done
  (( $#branches )) && _describe -t branches 'branches' branches
}

# likely merge candidates
_hg_mergerevs() {
  typeset -a heads
  local myrev

  heads=(${(f)"$(_hg_cmd heads --template '{rev}:{branch}\\n')"})
  # exclude own revision
  myrev=$(_hg_cmd log -r . --template '{rev}:{branch}\\n')
  heads=(${heads:#$myrev})

  (( $#heads )) && _describe -t heads 'heads' heads

  branches=(${(f)"$(_hg_cmd heads --template '{branch}\\n')"})
  # exclude own revision
  myrev=$(_hg_cmd log -r . --template '{branch}\\n')
  branches=(${branches:#$myrev})

  (( $#branches )) && _describe -t branches 'branches' branches
}

_hg_files() {
  if [[ -n "$_hg_root" ]]
  then
    [[ -d "$_hg_root/.hg" ]] || return
    case "$_hg_root" in
      /*)
        _files -W $_hg_root
      ;;
      *)
        _files -W $PWD/$_hg_root
      ;;
    esac
  else
    _files
  fi
}

_hg_status() {
  [[ -d $PREFIX ]] || PREFIX=$PREFIX:h
  status_files=(${(ps:\0:)"$(_hg_cmd status -0n$1 ./$PREFIX)"})
}

_hg_unknown() {
  typeset -a status_files
  _hg_status u
  _wanted files expl 'unknown files' _multi_parts / status_files
}

_hg_missing() {
  typeset -a status_files
  _hg_status d
  _wanted files expl 'missing files' _multi_parts / status_files
}

_hg_modified() {
  typeset -a status_files
  _hg_status m
  _wanted files expl 'modified files' _multi_parts / status_files
}

_hg_resolve() {
  local rstate rpath

  [[ -d $PREFIX ]] || PREFIX=$PREFIX:h

  _hg_cmd resolve -l ./$PREFIX | while read rstate rpath
  do
    [[ $rstate == 'R' ]] && resolved_files+=($rpath)
    [[ $rstate == 'U' ]] && unresolved_files+=($rpath)
  done
}

_hg_resolved() {
  typeset -a resolved_files unresolved_files
  _hg_resolve
  _wanted files expl 'resolved files' _multi_parts / resolved_files
}

_hg_unresolved() {
  typeset -a resolved_files unresolved_files
  _hg_resolve
  _wanted files expl 'unresolved files' _multi_parts / unresolved_files
}

_hg_config() {
    typeset -a items
    items=(${${(%f)"$(_call_program hg hg showconfig)"}%%\=*})
    (( $#items )) && _describe -t config 'config item' items
}

_hg_addremove() {
  _alternative 'files:unknown files:_hg_unknown' \
    'files:missing files:_hg_missing'
}

_hg_ssh_urls() {
  if [[ -prefix */ ]]
  then
    if zstyle -T ":completion:${curcontext}:files" remote-access
    then
      local host=${PREFIX%%/*}
      typeset -a remdirs
      compset -p $(( $#host + 1 ))
      local rempath=${(M)PREFIX##*/}
      local cacheid="hg:${host}-${rempath//\//_}"
      cacheid=${cacheid%[-_]}
      compset -P '*/'
      if _cache_invalid "$cacheid" || ! _retrieve_cache "$cacheid"
      then
        remdirs=(${${(M)${(f)"$(_call_program files ssh -a -x $host ls -1FL "${(q)rempath}")"}##*/}%/})
        _store_cache "$cacheid" remdirs
      fi
      _describe -t directories 'remote directory' remdirs -S/
    else
      _message 'remote directory'
    fi
  else
    if compset -P '*@'
    then
      _hosts -S/
    else
      _alternative 'hosts:remote host name:_hosts -S/' \
        'users:user:_users -S@'
    fi
  fi
}

_hg_urls() {
  if compset -P bundle://
  then
    _files
  elif compset -P ssh://
  then
    _hg_ssh_urls
  elif [[ -prefix *: ]]
  then
    _urls
  else
    local expl
    compset -S '[^:]*'
    _wanted url-schemas expl 'URL schema' compadd -S '' - \
      http:// https:// ssh:// bundle://
  fi
}

_hg_paths() {
  typeset -a paths pnames
  _hg_cmd paths | while read -A pnames
  do
    paths+=($pnames[1])
  done
  (( $#paths )) && _describe -t path-aliases 'repository alias' paths
}

_hg_remote() {
  _alternative 'path-aliases:repository alias:_hg_paths' \
    'directories:directory:_files -/' \
    'urls:URL:_hg_urls'
}

_hg_clone_dest() {
  _alternative 'directories:directory:_files -/' \
    'urls:URL:_hg_urls'
}

_hg_add_help_topics=(
    config dates diffs environment extensions filesets glossary hgignore hgweb
    merge-tools multirevs obsolescence patterns phases revisions revsets
    subrepos templating urls
)

_hg_help_topics() {
    local topics
    (( $#_hg_cmd_list )) || _hg_get_commands
    topics=($_hg_cmd_list $_hg_add_help_topics)
    _describe -t help_topics 'help topics' topics
}

# Common options
_hg_global_opts=(
    '(--repository -R)'{-R+,--repository}'[repository root directory]:repository:_files -/'
    '--cwd[change working directory]:new working directory:_files -/'
    '(--noninteractive -y)'{-y,--noninteractive}'[do not prompt, assume yes for any required answers]'
    '(--verbose -v)'{-v,--verbose}'[enable additional output]'
    '*--config[set/override config option]:defined config items:_hg_config'
    '(--quiet -q)'{-q,--quiet}'[suppress output]'
    '(--help -h)'{-h,--help}'[display help and exit]'
    '--debug[debug mode]'
    '--debugger[start debugger]'
    '--encoding[set the charset encoding]'
    '--encodingmode[set the charset encoding mode]'
    '--lsprof[print improved command execution profile]'
    '--traceback[print traceback on exception]'
    '--time[time how long the command takes]'
    '--profile[profile]'
    '--version[output version information and exit]'
)

_hg_pat_opts=(
  '*'{-I+,--include}'[include names matching the given patterns]:dir:_files -W $(_hg_cmd root) -/'
  '*'{-X+,--exclude}'[exclude names matching the given patterns]:dir:_files -W $(_hg_cmd root) -/')

_hg_clone_opts=(
  $_hg_remote_opts
  '(--noupdate -U)'{-U,--noupdate}'[do not update the new working directory]'
  '--pull[use pull protocol to copy metadata]'
  '--uncompressed[use uncompressed transfer (fast over LAN)]')

_hg_date_user_opts=(
  '(--currentdate -D)'{-D,--currentdate}'[record the current date as commit date]'
  '(--currentuser -U)'{-U,--currentuser}'[record the current user as committer]'
  '(--date -d)'{-d+,--date}'[record the specified date as commit date]:date:'
  '(--user -u)'{-u+,--user}'[record the specified user as committer]:user:')

_hg_gitlike_opts=(
  '(--git -g)'{-g,--git}'[use git extended diff format]')

_hg_diff_opts=(
  $_hg_gitlike_opts
  '(--text -a)'{-a,--text}'[treat all files as text]'
  '--nodates[omit dates from diff headers]')

_hg_mergetool_opts=(
  '(--tool -t)'{-t+,--tool}'[specify merge tool]:tool:')

_hg_dryrun_opts=(
  '(--dry-run -n)'{-n,--dry-run}'[do not perform actions, just print output]')

_hg_ignore_space_opts=(
  '(--ignore-all-space -w)'{-w,--ignore-all-space}'[ignore white space when comparing lines]'
  '(--ignore-space-change -b)'{-b,--ignore-space-change}'[ignore changes in the amount of white space]'
  '(--ignore-blank-lines -B)'{-B,--ignore-blank-lines}'[ignore changes whose lines are all blank]')

_hg_style_opts=(
  '--style[display using template map file]:'
  '--template[display with template]:')

_hg_log_opts=(
  $_hg_global_opts $_hg_style_opts $_hg_gitlike_opts
  '(--limit -l)'{-l+,--limit}'[limit number of changes displayed]:'
  '(--no-merges -M)'{-M,--no-merges}'[do not show merges]'
  '(--patch -p)'{-p,--patch}'[show patch]'
  '--stat[output diffstat-style summary of changes]'
)

_hg_commit_opts=(
  '(-m --message -l --logfile --edit -e)'{-e,--edit}'[edit commit message]'
  '(-e --edit -l --logfile --message -m)'{-m+,--message}'[use <text> as commit message]:message:'
  '(-e --edit -m --message --logfile -l)'{-l+,--logfile}'[read the commit message from <file>]:log file:_files')

_hg_remote_opts=(
  '(--ssh -e)'{-e+,--ssh}'[specify ssh command to use]:'
  '--remotecmd[specify hg command to run on the remote side]:')

_hg_branch_bmark_opts=(
  '(--bookmark -B)'{-B+,--bookmark}'[specify bookmark(s)]:bookmark:_hg_bookmarks'
  '(--branch -b)'{-b+,--branch}'[specify branch(es)]:branch:_hg_branches'
)

_hg_subrepos_opts=(
  '(--subrepos -S)'{-S,--subrepos}'[recurse into subrepositories]')

_hg_cmd() {
  _call_program hg HGPLAIN=1 hg "$_hg_cmd_globals[@]" "$@" 2> /dev/null
}

_hg_cmd_add() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts $_hg_dryrun_opts $_hg_subrepos_opts \
  '*:unknown files:_hg_unknown'
}

_hg_cmd_addremove() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts $_hg_dryrun_opts \
  '(--similarity -s)'{-s+,--similarity}'[guess renamed files by similarity (0<=s<=100)]:' \
  '*:unknown or missing files:_hg_addremove'
}

_hg_cmd_annotate() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts \
  '(--rev -r)'{-r+,--rev}'[annotate the specified revision]:revision:_hg_labels' \
  '(--follow -f)'{-f,--follow}'[follow file copies and renames]' \
  '(--text -a)'{-a,--text}'[treat all files as text]' \
  '(--user -u)'{-u,--user}'[list the author]' \
  '(--date -d)'{-d,--date}'[list the date]' \
  '(--number -n)'{-n,--number}'[list the revision number (default)]' \
  '(--changeset -c)'{-c,--changeset}'[list the changeset]' \
  '*:files:_hg_files'
}

_hg_cmd_archive() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts $_hg_subrepos_opts \
  '--no-decode[do not pass files through decoders]' \
  '(--prefix -p)'{-p+,--prefix}'[directory prefix for files in archive]:' \
  '(--rev -r)'{-r+,--rev}'[revision to distribute]:revision:_hg_labels' \
  '(--type -t)'{-t+,--type}'[type of distribution to create]:archive type:(files tar tbz2 tgz uzip zip)' \
  '*:destination:_files'
}

_hg_cmd_backout() {
  _arguments -s -w : $_hg_global_opts $_hg_mergetool_opts $_hg_pat_opts \
    '--merge[merge with old dirstate parent after backout]' \
    '(--date -d)'{-d+,--date}'[record datecode as commit date]:date code:' \
    '--parent[parent to choose when backing out merge]' \
    '(--user -u)'{-u+,--user}'[record user as commiter]:user:' \
    '(--rev -r)'{-r+,--rev}'[revision]:revision:_hg_labels' \
    '(--message -m)'{-m+,--message}'[use <text> as commit message]:text:' \
    '(--logfile -l)'{-l+,--logfile}'[read commit message from <file>]:log file:_files'
}

_hg_cmd_bisect() {
  _arguments -s -w : $_hg_global_opts \
  '(-)'{-r,--reset}'[reset bisect state]' \
  '(--extend -e)'{-e,--extend}'[extend the bisect range]' \
  '(--good -g --bad -b --skip -s --reset -r)'{-g,--good}'[mark changeset good]'::revision:_hg_labels \
  '(--good -g --bad -b --skip -s --reset -r)'{-b,--bad}'[mark changeset bad]'::revision:_hg_labels \
  '(--good -g --bad -b --skip -s --reset -r)'{-s,--skip}'[skip testing changeset]' \
  '(--command -c --noupdate -U)'{-c+,--command}'[use command to check changeset state]':commands:_command_names \
  '(--command -c --noupdate -U)'{-U,--noupdate}'[do not update to target]'
}

_hg_cmd_bookmarks() {
  _arguments -s -w : $_hg_global_opts \
  '(--force -f)'{-f,--force}'[force]' \
  '(--inactive -i)'{-i,--inactive}'[mark a bookmark inactive]' \
  '(--rev -r --delete -d --rename -m)'{-r+,--rev}'[revision]:revision:_hg_labels' \
  '(--rev -r --delete -d --rename -m)'{-d,--delete}'[delete a given bookmark]' \
  '(--rev -r --delete -d --rename -m)'{-m+,--rename}'[rename a given bookmark]:bookmark:_hg_bookmarks' \
  ':bookmark:_hg_bookmarks'
}

_hg_cmd_branch() {
  _arguments -s -w : $_hg_global_opts \
  '(--force -f)'{-f,--force}'[set branch name even if it shadows an existing branch]' \
  '(--clean -C)'{-C,--clean}'[reset branch name to parent branch name]'
}

_hg_cmd_branches() {
  _arguments -s -w : $_hg_global_opts \
  '(--active -a)'{-a,--active}'[show only branches that have unmerge heads]' \
  '(--closed -c)'{-c,--closed}'[show normal and closed branches]'
}

_hg_cmd_bundle() {
  _arguments -s -w : $_hg_global_opts $_hg_remote_opts \
  '(--force -f)'{-f,--force}'[run even when remote repository is unrelated]' \
  '(2)*--base[a base changeset to specify instead of a destination]:revision:_hg_labels' \
  '(--branch -b)'{-b+,--branch}'[a specific branch to bundle]' \
  '(--rev -r)'{-r+,--rev}'[changeset(s) to bundle]:' \
  '--all[bundle all changesets in the repository]' \
  ':output file:_files' \
  ':destination repository:_files -/'
}

_hg_cmd_cat() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts \
  '(--output -o)'{-o+,--output}'[print output to file with formatted name]:filespec:' \
  '(--rev -r)'{-r+,--rev}'[revision]:revision:_hg_labels' \
  '--decode[apply any matching decode filter]' \
  '*:file:_hg_files'
}

_hg_cmd_clone() {
  _arguments -s -w : $_hg_global_opts $_hg_clone_opts \
  '(--rev -r)'{-r+,--rev}'[a changeset you would like to have after cloning]:' \
  '(--updaterev -u)'{-u+,--updaterev}'[revision, tag or branch to check out]' \
  '(--branch -b)'{-b+,--branch}'[clone only the specified branch]' \
  ':source repository:_hg_remote' \
  ':destination:_hg_clone_dest'
}

_hg_cmd_commit() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts $_hg_subrepos_opts \
  '(--addremove -A)'{-A,--addremove}'[mark new/missing files as added/removed before committing]' \
  '(--message -m)'{-m+,--message}'[use <text> as commit message]:text:' \
  '(--logfile -l)'{-l+,--logfile}'[read commit message from <file>]:log file:_files' \
  '(--date -d)'{-d+,--date}'[record datecode as commit date]:date code:' \
  '(--user -u)'{-u+,--user}'[record user as commiter]:user:' \
  '--amend[amend the parent of the working dir]' \
  '--close-branch[mark a branch as closed]' \
  '*:file:_hg_files'
}

_hg_cmd_copy() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts $_hg_dryrun_opts \
  '(--after -A)'{-A,--after}'[record a copy that has already occurred]' \
  '(--force -f)'{-f,--force}'[forcibly copy over an existing managed file]' \
  '*:file:_hg_files'
}

_hg_cmd_diff() {
  typeset -A opt_args
  _arguments -s -w : $_hg_global_opts $_hg_diff_opts $_hg_ignore_space_opts \
                     $_hg_pat_opts $_hg_subrepos_opts \
  '*'{-r,--rev}'+[revision]:revision:_hg_revrange' \
  '(--show-function -p)'{-p,--show-function}'[show which function each change is in]' \
  '(--change -c)'{-c,--change}'[change made by revision]' \
  '(--text -a)'{-a,--text}'[treat all files as text]' \
  '--reverse[produce a diff that undoes the changes]' \
  '(--unified -U)'{-U,--unified}'[number of lines of context to show]' \
  '--stat[output diffstat-style summary of changes]' \
  '*:file:->diff_files'

  if [[ $state == 'diff_files' ]]
  then
    if [[ -n $opt_args[-r] ]]
    then
      _hg_files
    else
      _hg_modified
    fi
  fi
}

_hg_cmd_export() {
  _arguments -s -w : $_hg_global_opts $_hg_diff_opts \
  '(--outout -o)'{-o+,--output}'[print output to file with formatted name]:filespec:' \
  '--switch-parent[diff against the second parent]' \
  '(--rev -r)'{-r+,--rev}'[revision]:revision:_hg_labels' \
  '*:revision:_hg_labels'
}

_hg_cmd_forget() {
  _arguments -s -w : $_hg_global_opts \
  '*:file:_hg_files'
}

_hg_cmd_graft() {
  _arguments -s -w : $_hg_global_opts $_hg_dryrun_opts \
                     $_hg_date_user_opts $_hg_mergetool_opts \
  '(--continue -c)'{-c,--continue}'[resume interrupted graft]' \
  '(--edit -e)'{-e,--edit}'[invoke editor on commit messages]' \
  '--log[append graft info to log message]' \
  '*:revision:_hg_labels'
}

_hg_cmd_grep() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts \
  '(--print0 -0)'{-0,--print0}'[end filenames with NUL]' \
  '--all[print all revisions with matches]' \
  '(--follow -f)'{-f,--follow}'[follow changeset or file history]' \
  '(--ignore-case -i)'{-i,--ignore-case}'[ignore case when matching]' \
  '(--files-with-matches -l)'{-l,--files-with-matches}'[print only filenames and revs that match]' \
  '(--line-number -n)'{-n,--line-number}'[print matching line numbers]' \
  '*'{-r+,--rev}'[search in given revision range]:revision:_hg_revrange' \
  '(--user -u)'{-u,--user}'[print user who committed change]' \
  '(--date -d)'{-d,--date}'[print date of a changeset]' \
  '1:search pattern:' \
  '*:files:_hg_files'
}

_hg_cmd_heads() {
  _arguments -s -w : $_hg_global_opts $_hg_style_opts \
  '(--topo -t)'{-t,--topo}'[show topological heads only]' \
  '(--closed -c)'{-c,--closed}'[show normal and closed branch heads]' \
  '(--rev -r)'{-r+,--rev}'[show only heads which are descendants of rev]:revision:_hg_labels'
}

_hg_cmd_help() {
  _arguments -s -w : $_hg_global_opts \
  '(--extension -e)'{-e,--extension}'[show only help for extensions]' \
  '(--command -c)'{-c,--command}'[show only help for commands]' \
  '(--keyword -k)'{-k+,--keyword}'[show topics matching keyword]' \
  '*:mercurial help topic:_hg_help_topics'
}

_hg_cmd_identify() {
  _arguments -s -w : $_hg_global_opts $_hg_remote_opts \
  '(--rev -r)'{-r+,--rev}'[identify the specified rev]:revision:_hg_labels' \
  '(--num -n)'{-n+,--num}'[show local revision number]' \
  '(--id -i)'{-i+,--id}'[show global revision id]' \
  '(--branch -b)'{-b+,--branch}'[show branch]' \
  '(--bookmark -B)'{-B+,--bookmark}'[show bookmarks]' \
  '(--tags -t)'{-t+,--tags}'[show tags]'
}

_hg_cmd_import() {
  _arguments -s -w : $_hg_global_opts $_hg_commit_opts \
  '(--strip -p)'{-p+,--strip}'[directory strip option for patch (default: 1)]:count:' \
  '(--force -f)'{-f,--force}'[skip check for outstanding uncommitted changes]' \
  '--bypass[apply patch without touching the working directory]' \
  '--no-commit[do not commit, just update the working directory]' \
  '--exact[apply patch to the nodes from which it was generated]' \
  '--import-branch[use any branch information in patch (implied by --exact)]' \
  '(--date -d)'{-d+,--date}'[record datecode as commit date]:date code:' \
  '(--user -u)'{-u+,--user}'[record user as commiter]:user:' \
  '(--similarity -s)'{-s+,--similarity}'[guess renamed files by similarity (0<=s<=100)]:' \
  '*:patch:_files'
}

_hg_cmd_incoming() {
  _arguments -s -w : $_hg_log_opts $_hg_branch_bmark_opts $_hg_remote_opts \
                     $_hg_subrepos_opts \
  '(--force -f)'{-f,--force}'[run even when the remote repository is unrelated]' \
  '(--rev -r)'{-r+,--rev}'[a specific revision up to which you would like to pull]:revision:_hg_labels' \
  '(--newest-first -n)'{-n,--newest-first}'[show newest record first]' \
  '--bundle[file to store the bundles into]:bundle file:_files' \
  ':source:_hg_remote'
}

_hg_cmd_init() {
  _arguments -s -w : $_hg_global_opts $_hg_remote_opts \
  ':dir:_files -/'
}

_hg_cmd_locate() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts \
  '(--rev -r)'{-r+,--rev}'[search repository as it stood at revision]:revision:_hg_labels' \
  '(--print0 -0)'{-0,--print0}'[end filenames with NUL, for use with xargs]' \
  '(--fullpath -f)'{-f,--fullpath}'[print complete paths]' \
  '*:search pattern:_hg_files'
}

_hg_cmd_log() {
  _arguments -s -w : $_hg_log_opts $_hg_pat_opts \
  '(--follow --follow-first -f)'{-f,--follow}'[follow changeset or history]' \
  '(-f --follow)--follow-first[only follow the first parent of merge changesets]' \
  '(--copies -C)'{-C,--copies}'[show copied files]' \
  '(--keyword -k)'{-k+,--keyword}'[search for a keyword]:' \
  '*'{-r,--rev}'[show the specified revision or revset]:revision:_hg_revrange' \
  '(--only-merges -m)'{-m,--only-merges}'[show only merges]' \
  '(--prune -P)'{-P+,--prune}'[do not display revision or any of its ancestors]:revision:_hg_labels' \
  '(--graph -G)'{-G+,--graph}'[show the revision DAG]' \
  '(--branch -b)'{-b+,--branch}'[show changesets within the given named branch]:branch:_hg_branches' \
  '(--user -u)'{-u+,--user}'[revisions committed by user]:user:' \
  '(--date -d)'{-d+,--date}'[show revisions matching date spec]:date:' \
  '*:files:_hg_files'
}

_hg_cmd_manifest() {
  _arguments -s -w : $_hg_global_opts \
  '--all[list files from all revisions]' \
  '(--rev -r)'{-r+,--rev}'[revision to display]:revision:_hg_labels' \
  ':revision:_hg_labels'
}

_hg_cmd_merge() {
  _arguments -s -w : $_hg_global_opts $_hg_mergetool_opts \
  '(--force -f)'{-f,--force}'[force a merge with outstanding changes]' \
  '(--rev -r 1)'{-r,--rev}'[revision to merge]:revision:_hg_mergerevs' \
  '(--preview -P)'{-P,--preview}'[review revisions to merge (no merge is performed)]' \
  ':revision:_hg_mergerevs'
}

_hg_cmd_outgoing() {
  _arguments -s -w : $_hg_log_opts $_hg_branch_bmark_opts $_hg_remote_opts \
                     $_hg_subrepos_opts \
  '(--force -f)'{-f,--force}'[run even when the remote repository is unrelated]' \
  '*'{-r,--rev}'[a specific revision you would like to push]:revision:_hg_revrange' \
  '(--newest-first -n)'{-n,--newest-first}'[show newest record first]' \
  ':destination:_hg_remote'
}

_hg_cmd_parents() {
  _arguments -s -w : $_hg_global_opts $_hg_style_opts \
  '(--rev -r)'{-r+,--rev}'[show parents of the specified rev]:revision:_hg_labels' \
  ':last modified file:_hg_files'
}

_hg_cmd_paths() {
  _arguments -s -w : $_hg_global_opts \
  ':path:_hg_paths'
}

_hg_cmd_phase() {
  _arguments -s -w : $_hg_global_opts \
  '(--public -p)'{-p,--public}'[set changeset phase to public]' \
  '(--draft -d)'{-d,--draft}'[set changeset phase to draft]' \
  '(--secret -s)'{-s,--secret}'[set changeset phase to secret]' \
  '(--force -f)'{-f,--force}'[allow to move boundary backward]' \
  '(--rev -r)'{-r+,--rev}'[target revision]:revision:_hg_labels' \
  ':revision:_hg_labels'
}

_hg_cmd_pull() {
  _arguments -s -w : $_hg_global_opts $_hg_branch_bmark_opts $_hg_remote_opts \
  '(--force -f)'{-f,--force}'[run even when the remote repository is unrelated]' \
  '(--update -u)'{-u,--update}'[update to new tip if changesets were pulled]' \
  '(--rev -r)'{-r+,--rev}'[a specific revision up to which you would like to pull]:revision:' \
  ':source:_hg_remote'
}

_hg_cmd_push() {
  _arguments -s -w : $_hg_global_opts $_hg_branch_bmark_opts $_hg_remote_opts \
  '(--force -f)'{-f,--force}'[force push]' \
  '(--rev -r)'{-r+,--rev}'[a specific revision you would like to push]:revision:_hg_labels' \
  '--new-branch[allow pushing a new branch]' \
  ':destination:_hg_remote'
}

_hg_cmd_remove() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts \
  '(--after -A)'{-A,--after}'[record remove that has already occurred]' \
  '(--force -f)'{-f,--force}'[remove file even if modified]' \
  '*:file:_hg_files'
}

_hg_cmd_rename() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts $_hg_dryrun_opts \
  '(--after -A)'{-A,--after}'[record a rename that has already occurred]' \
  '(--force -f)'{-f,--force}'[forcibly copy over an existing managed file]' \
  '*:file:_hg_files'
}

_hg_cmd_resolve() {
  local context state line
  typeset -A opt_args

  _arguments -s -w : $_hg_global_opts $_hg_mergetool_opts $_hg_pat_opts \
  '(--all -a)'{-a,--all}'[select all unresolved files]' \
  '(--no-status -n)'{-n,--no-status}'[hide status prefix]' \
  '(--list -l --mark -m --unmark -u)'{-l,--list}'[list state of files needing merge]:*:merged files:->resolve_files' \
  '(--mark -m --list -l --unmark -u)'{-m,--mark}'[mark files as resolved]:*:unresolved files:_hg_unresolved' \
  '(--unmark -u --list -l --mark -m)'{-u,--unmark}'[unmark files as resolved]:*:resolved files:_hg_resolved' \
  '*:file:_hg_unresolved'

  if [[ $state == 'resolve_files' ]]
  then
    _alternative 'files:resolved files:_hg_resolved' \
      'files:unresolved files:_hg_unresolved'
  fi
}

_hg_cmd_revert() {
  local context state line
  typeset -A opt_args

  _arguments -s -w : $_hg_global_opts $_hg_pat_opts $_hg_dryrun_opts \
  '(--all -a :)'{-a,--all}'[revert all changes when no arguments given]' \
  '(--rev -r)'{-r+,--rev}'[revision to revert to]:revision:_hg_labels' \
  '(--no-backup -C)'{-C,--no-backup}'[do not save backup copies of files]' \
  '(--date -d)'{-d+,--date}'[tipmost revision matching date]:date code:' \
  '*:file:->diff_files'

  if [[ $state == 'diff_files' ]]
  then
    if [[ -n $opt_args[-r] ]]
    then
      _hg_files
    else
      typeset -a status_files
      _hg_status mard
      _wanted files expl 'modified, added, removed or deleted file' _multi_parts / status_files
    fi
  fi
}

_hg_cmd_rollback() {
  _arguments -s -w : $_hg_global_opts $_hg_dryrun_opts \
  '(--force -f)'{-f,--force}'[ignore safety measures]' \
}

_hg_cmd_serve() {
  _arguments -s -w : $_hg_global_opts \
  '(--accesslog -A)'{-A+,--accesslog}'[name of access log file]:log file:_files' \
  '(--errorlog -E)'{-E+,--errorlog}'[name of error log file]:log file:_files' \
  '(--daemon -d)'{-d,--daemon}'[run server in background]' \
  '(--port -p)'{-p+,--port}'[listen port]:listen port:' \
  '(--address -a)'{-a+,--address}'[interface address]:interface address:' \
  '--prefix[prefix path to serve from]:directory:_files' \
  '(--name -n)'{-n+,--name}'[name to show in web pages]:repository name:' \
  '--web-conf[name of the hgweb config file]:webconf_file:_files' \
  '--pid-file[name of file to write process ID to]:pid_file:_files' \
  '--cmdserver[cmdserver mode]:mode:' \
  '(--templates -t)'{-t,--templates}'[web template directory]:template dir:_files -/' \
  '--style[web template style]:style' \
  '--stdio[for remote clients]' \
  '--certificate[certificate file]:cert_file:_files' \
  '(--ipv6 -6)'{-6,--ipv6}'[use IPv6 in addition to IPv4]'
}

_hg_cmd_showconfig() {
  _arguments -s -w : $_hg_global_opts \
  '(--untrusted -u)'{-u+,--untrusted}'[show untrusted configuration options]' \
  ':config item:_hg_config'
}

_hg_cmd_status() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts $_hg_subrepos_opts \
  '(--all -A)'{-A,--all}'[show status of all files]' \
  '(--modified -m)'{-m,--modified}'[show only modified files]' \
  '(--added -a)'{-a,--added}'[show only added files]' \
  '(--removed -r)'{-r,--removed}'[show only removed files]' \
  '(--deleted -d)'{-d,--deleted}'[show only deleted (but tracked) files]' \
  '(--clean -c)'{-c,--clean}'[show only files without changes]' \
  '(--unknown -u)'{-u,--unknown}'[show only unknown files]' \
  '(--ignored -i)'{-i,--ignored}'[show ignored files]' \
  '(--no-status -n)'{-n,--no-status}'[hide status prefix]' \
  '(--copies -C)'{-C,--copies}'[show source of copied files]' \
  '(--print0 -0)'{-0,--print0}'[end filenames with NUL, for use with xargs]' \
  '--rev[show difference from revision]:revision:_hg_labels' \
  '--change[list the changed files of a revision]:revision:_hg_labels' \
  '*:files:_files'
}

_hg_cmd_summary() {
  _arguments -s -w : $_hg_global_opts \
  '--remote[check for push and pull]'
}

_hg_cmd_tag() {
  _arguments -s -w : $_hg_global_opts \
  '(--local -l)'{-l,--local}'[make the tag local]' \
  '(--message -m)'{-m+,--message}'[message for tag commit log entry]:message:' \
  '(--date -d)'{-d+,--date}'[record datecode as commit date]:date code:' \
  '(--user -u)'{-u+,--user}'[record user as commiter]:user:' \
  '(--rev -r)'{-r+,--rev}'[revision to tag]:revision:_hg_labels' \
  '(--force -f)'{-f,--force}'[force tag]' \
  '--remove[remove a tag]' \
  '(--edit -e)'{-e,--edit}'[edit commit message]' \
  ':tag name:'
}

_hg_cmd_tip() {
  _arguments -s -w : $_hg_global_opts $_hg_gitlike_opts $_hg_style_opts \
  '(--patch -p)'{-p,--patch}'[show patch]'
}

_hg_cmd_unbundle() {
  _arguments -s -w : $_hg_global_opts \
  '(--update -u)'{-u,--update}'[update to new tip if changesets were unbundled]' \
  ':files:_files'
}

_hg_cmd_update() {
  _arguments -s -w : $_hg_global_opts \
  '(--clean -C)'{-C,--clean}'[overwrite locally modified files]' \
  '(--rev -r)'{-r+,--rev}'[revision]:revision:_hg_labels' \
  '(--check -c)'{-c,--check}'[update across branches if no uncommitted changes]' \
  '(--date -d)'{-d+,--date}'[tipmost revision matching date]' \
  ':revision:_hg_labels'
}

## extensions ##

# HGK
_hg_cmd_view() {
  _arguments -s -w : $_hg_global_opts \
  '(--limit -l)'{-l+,--limit}'[limit number of changes displayed]:' \
  ':revision range:_hg_labels'
}

# MQ
_hg_qseries() {
  typeset -a patches
  patches=(${(f)"$(_hg_cmd qseries)"})
  (( $#patches )) && _describe -t hg-patches 'patches' patches
}

_hg_qapplied() {
  typeset -a patches
  patches=(${(f)"$(_hg_cmd qapplied)"})
  if (( $#patches ))
  then
    patches+=(qbase qtip)
    _describe -t hg-applied-patches 'applied patches' patches
  fi
}

_hg_qunapplied() {
  typeset -a patches
  patches=(${(f)"$(_hg_cmd qunapplied)"})
  (( $#patches )) && _describe -t hg-unapplied-patches 'unapplied patches' patches
}

# unapplied, including guarded patches
_hg_qdeletable() {
  typeset -a unapplied
  unapplied=(${(f)"$(_hg_cmd qseries)"})
  for p in $(_hg_cmd qapplied)
  do
    unapplied=(${unapplied:#$p})
  done

  (( $#unapplied )) && _describe -t hg-allunapplied-patches 'all unapplied patches' unapplied
}

_hg_qguards() {
  typeset -a guards
  local guard
  compset -P "+|-"
  _hg_cmd qselect -s | while read guard
  do
    guards+=(${guard#(+|-)})
  done
  (( $#guards )) && _describe -t hg-guards 'guards' guards
}

_hg_qseries_opts=(
  '(--summary -s)'{-s,--summary}'[print first line of patch header]')

_hg_cmd_qapplied() {
  _arguments -s -w : $_hg_global_opts $_hg_qseries_opts \
  '(--last -1)'{-1,--last}'[show only the preceding applied patch]' \
  '*:patch:_hg_qapplied'
}

_hg_cmd_qclone() {
  _arguments -s -w : $_hg_global_opts $_hg_remote_opts $_hg_clone_opts \
  '(--patches -p)'{-p+,--patches}'[location of source patch repository]' \
  ':source repository:_hg_remote' \
  ':destination:_hg_clone_dest'
}

_hg_cmd_qdelete() {
  _arguments -s -w : $_hg_global_opts \
  '(--keep -k)'{-k,--keep}'[keep patch file]' \
  '*'{-r+,--rev}'[stop managing a revision]:applied patch:_hg_revrange' \
  '*:unapplied patch:_hg_qdeletable'
}

_hg_cmd_qdiff() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts $_hg_diff_opts \
                     $_hg_ignore_space_opts \
  '*:pattern:_hg_files'
}

_hg_cmd_qfinish() {
  _arguments -s -w : $_hg_global_opts \
  '(--applied -a)'{-a,--applied}'[finish all applied patches]' \
  '*:patch:_hg_qapplied'
}

_hg_cmd_qfold() {
  _arguments -s -w : $_hg_global_opts $_h_commit_opts \
  '(--keep,-k)'{-k,--keep}'[keep folded patch files]' \
  '(--force -f)'{-f,--force}'[overwrite any local changes]' \
  '--no-backup[do not save backup copies of files]' \
  '*:unapplied patch:_hg_qunapplied'
}

_hg_cmd_qgoto() {
  _arguments -s -w : $_hg_global_opts \
  '(--force -f)'{-f,--force}'[overwrite any local changes]' \
  '--keep-changes[tolerate non-conflicting local changes]' \
  ':patch:_hg_qseries'
}

_hg_cmd_qguard() {
  _arguments -s -w : $_hg_global_opts \
  '(--list -l)'{-l,--list}'[list all patches and guards]' \
  '(--none -n)'{-n,--none}'[drop all guards]' \
  ':patch:_hg_qseries' \
  '*:guards:_hg_qguards'
}

_hg_cmd_qheader() {
  _arguments -s -w : $_hg_global_opts \
  ':patch:_hg_qseries'
}

_hg_cmd_qimport() {
  _arguments -s -w : $_hg_global_opts $_hg_gitlike_opts \
  '(--existing -e)'{-e,--existing}'[import file in patch dir]' \
  '(--name -n 2)'{-n+,--name}'[patch file name]:name:' \
  '(--force -f)'{-f,--force}'[overwrite existing files]' \
  '*'{-r+,--rev}'[place existing revisions under mq control]:revision:_hg_revrange' \
  '(--push -P)'{-P,--push}'[qpush after importing]' \
  '*:patch:_files'
}

_hg_cmd_qnew() {
  _arguments -s -w : $_hg_global_opts $_hg_commit_opts $_hg_date_user_opts $_hg_gitlike_opts \
  ':patch:'
}

_hg_cmd_qnext() {
  _arguments -s -w : $_hg_global_opts $_hg_qseries_opts
}

_hg_cmd_qpop() {
  _arguments -s -w : $_hg_global_opts \
  '(--all -a :)'{-a,--all}'[pop all patches]' \
  '(--force -f)'{-f,--force}'[forget any local changes]' \
  '--keep-changes[tolerate non-conflicting local changes]' \
  '--no-backup[do not save backup copies of files]' \
  ':patch:_hg_qapplied'
}

_hg_cmd_qprev() {
  _arguments -s -w : $_hg_global_opts $_hg_qseries_opts
}

_hg_cmd_qpush() {
  _arguments -s -w : $_hg_global_opts \
  '(--all -a :)'{-a,--all}'[apply all patches]' \
  '(--list -l)'{-l,--list}'[list patch name in commit text]' \
  '(--force -f)'{-f,--force}'[apply if the patch has rejects]' \
  '(--exact -e)'{-e,--exact}'[apply the target patch to its recorded parent]' \
  '--move[reorder patch series and apply only the patch]' \
  '--keep-changes[tolerate non-conflicting local changes]' \
  '--no-backup[do not save backup copies of files]' \
  ':patch:_hg_qunapplied'
}

_hg_cmd_qrefresh() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts $_hg_commit_opts $_hg_gitlike_opts \
  '(--short -s)'{-s,--short}'[short refresh]' \
  '*:files:_hg_files'
}

_hg_cmd_qrename() {
  _arguments -s -w : $_hg_global_opts \
  ':patch:_hg_qunapplied' \
  ':destination:'
}

_hg_cmd_qselect() {
  _arguments -s -w : $_hg_global_opts \
  '(--none -n :)'{-n,--none}'[disable all guards]' \
  '(--series -s :)'{-s,--series}'[list all guards in series file]' \
  '--pop[pop to before first guarded applied patch]' \
  '--reapply[pop and reapply patches]' \
  '*:guards:_hg_qguards'
}

_hg_cmd_qseries() {
  _arguments -s -w : $_hg_global_opts $_hg_qseries_opts \
  '(--missing -m)'{-m,--missing}'[print patches not in series]'
}

_hg_cmd_qunapplied() {
  _arguments -s -w : $_hg_global_opts $_hg_qseries_opts \
  '(--first -1)'{-1,--first}'[show only the first patch]'
}

_hg_cmd_qtop() {
  _arguments -s -w : $_hg_global_opts $_hg_qseries_opts
}

_hg_cmd_strip() {
  _arguments -s -w : $_hg_global_opts \
  '(--force -f)'{-f,--force}'[force removal, discard uncommitted changes, no backup]' \
  '(--no-backup -n)'{-n,--no-backup}'[no backups]' \
  '(--keep -k)'{-k,--keep}'[do not modify working copy during strip]' \
  '(--bookmark -B)'{-B+,--bookmark}'[remove revs only reachable from given bookmark]:bookmark:_hg_bookmarks' \
  '(--rev -r)'{-r+,--rev}'[revision]:revision:_hg_labels' \
  ':revision:_hg_labels'
}

# Patchbomb
_hg_cmd_email() {
  _arguments -s -w : $_hg_global_opts $_hg_remote_opts $_hg_gitlike_opts \
  '--plain[omit hg patch header]' \
  '--body[send patches as inline message text (default)]' \
  '(--outgoing -o)'{-o,--outgoing}'[send changes not found in the target repository]' \
  '(--bundle -b)'{-b,--bundle}'[send changes not in target as a binary bundle]' \
  '--bundlename[name of the bundle attachment file (default: bundle)]:' \
  '*'{-r+,--rev}'[search in given revision range]:revision:_hg_revrange' \
  '--force[run even when remote repository is unrelated (with -b/--bundle)]' \
  '*--base[a base changeset to specify instead of a destination (with -b/--bundle)]:revision:_hg_labels' \
  '--intro[send an introduction email for a single patch]' \
  '(--inline -i --attach -a)'{-a,--attach}'[send patches as attachments]' \
  '(--attach -a --inline -i)'{-i,--inline}'[send patches as inline attachments]' \
  '*--bcc[email addresses of blind carbon copy recipients]:email:' \
  '*'{-c+,--cc}'[email addresses of copy recipients]:email:' \
  '(--diffstat -d)'{-d,--diffstat}'[add diffstat output to messages]' \
  '--date[use the given date as the sending date]:date:' \
  '--desc[use the given file as the series description]:files:_files' \
  '(--from -f)'{-f,--from}'[email address of sender]:email:' \
  '(--test -n)'{-n,--test}'[print messages that would be sent]' \
  '(--mbox -m)'{-m,--mbox}'[write messages to mbox file instead of sending them]:file:' \
  '*--reply-to[email addresses replies should be sent to]:email:' \
  '(--subject -s)'{-s,--subject}'[subject of first message (intro or single patch)]:subject:' \
  '--in-reply-to[message identifier to reply to]:msgid:' \
  '*--flag[flags to add in subject prefixes]:flag:' \
  '*'{-t,--to}'[email addresses of recipients]:email:' \
  ':revision:_hg_revrange'
}

# Rebase
_hg_cmd_rebase() {
  _arguments -s -w : $_hg_global_opts $_hg_commit_opts $_hg_mergetool_opts \
  '*'{-r,--rev}'[rebase these revisions]:revision:_hg_revrange' \
  '(--source -s)'{-s+,--source}'[rebase from the specified changeset]:revision:_hg_labels' \
  '(--base -b)'{-b+,--base}'[rebase from the base of the specified changeset]:revision:_hg_labels' \
  '(--dest -d)'{-d+,--dest}'[rebase onto the specified changeset]:revision:_hg_labels' \
  '--collapse[collapse the rebased changeset]' \
  '--keep[keep original changeset]' \
  '--keepbranches[keep original branch name]' \
  '(--continue -c)'{-c,--continue}'[continue an interrupted rebase]' \
  '(--abort -a)'{-a,--abort}'[abort an interrupted rebase]' \
}

# Record
_hg_cmd_record() {
  _arguments -s -w : $_hg_global_opts $_hg_commit_opts $_hg_pat_opts \
                     $_hg_ignore_space_opts $_hg_subrepos_opts \
  '(--addremove -A)'{-A,--addremove}'[mark new/missing files as added/removed before committing]' \
  '--close-branch[mark a branch as closed, hiding it from the branch list]' \
  '--amend[amend the parent of the working dir]' \
  '(--date -d)'{-d+,--date}'[record the specified date as commit date]:date:' \
  '(--user -u)'{-u+,--user}'[record the specified user as committer]:user:'
}

_hg_cmd_qrecord() {
  _arguments -s -w : $_hg_global_opts $_hg_commit_opts $_hg_date_user_opts $_hg_gitlike_opts \
                     $_hg_pat_opts $_hg_ignore_space_opts $_hg_subrepos_opts
}

# Convert
_hg_cmd_convert() {
_arguments -s -w : $_hg_global_opts \
  '(--source-type -s)'{-s,--source-type}'[source repository type]' \
  '(--dest-type -d)'{-d,--dest-type}'[destination repository type]' \
  '(--rev -r)'{-r+,--rev}'[import up to target revision]:revision:' \
  '(--authormap -A)'{-A+,--authormap}'[remap usernames using this file]:file:_files' \
  '--filemap[remap file names using contents of file]:file:_files' \
  '--splicemap[splice synthesized history into place]:file:_files' \
  '--branchmap[change branch names while converting]:file:_files' \
  '--branchsort[try to sort changesets by branches]' \
  '--datesort[try to sort changesets by date]' \
  '--sourcesort[preserve source changesets order]'
}

# Graphlog
_hg_cmd_glog() {
  _hg_cmd_log $@
}

# Purge
_hg_cmd_purge() {
  _arguments -s -w : $_hg_global_opts $_hg_pat_opts $_hg_subrepos_opts \
  '(--abort-on-err -a)'{-a,--abort-on-err}'[abort if an error occurs]' \
  '--all[purge ignored files too]' \
  '(--print -p)'{-p,--print}'[print filenames instead of deleting them]' \
  '(--print0 -0)'{-0,--print0}'[end filenames with NUL, for use with xargs (implies -p/--print)]'
}

_hg "$@"
