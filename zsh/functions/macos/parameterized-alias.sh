function pal() {
  case "$1" in
    -h|--help)
      cat <<'EOF'
pal - define a parameterized alias (a one-off command template as a named function)

Usage:
  pal <name> '<command template>'   Define <name> to run the template when called.
                                     $1 $2 ... in the template refer to the args
                                     given to <name> at call time, NOT to pal's
                                     own args — so the template must be
                                     single-quoted (see Gotcha below).
  pal -l                            List currently defined pal commands.
  pal -d <name>                     Delete a previously defined pal command.
  pal -h | --help                   Show this help.

Example:
  pal t 'ls -lha $1'
  t ~/.zshrc

Gotcha:
  Always single-quote the template. Without quotes, YOUR shell expands
  $1/$2 and splits on | > etc. before pal ever sees them, e.g.:
    pal t ls -lha $1 | sed ...      # broken: $1 expands now, pipe runs now
    pal t 'ls -lha $1 | sed ...'    # correct: deferred until `t` is called
EOF
      return
      ;;
    -l)
      print -l ${(k)_pal_defined} 2>/dev/null
      return
      ;;
    -d)
      unfunction "$2" 2>/dev/null
      unset "_pal_defined[$2]" 2>/dev/null
      return
      ;;
  esac

  local name=$1; shift
  eval "function $name() { $* ; }"
  typeset -gA _pal_defined
  _pal_defined[$name]=1
}