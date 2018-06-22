# brashlib.d files

Include files for brashlib.  Anything in `/usr/local/lib/brashlib.d/` with a `.sh` extension will be included

## brashlib.d/dispatch.sh

This is an argument dispatcher.  It handles short and long options, and commands.  To use it, create parse functions in your script which will be called by dispatch.sh.

Parse functions are called in the format:

`${namespace}_${type}_${expected_string}`

A common argument namespace would be `Argv`.  Typically there is only one namespace needed, but more than one can be used if necessary for complex parsing schemes, with one namespace passing to the next as necessary.

Let's say for example on the command `myscript.sh run` I want my script to do All The Things(tm).   So having of course created a function called DoAllTheThings, I would then create a function to parse the command `run` like so:

```
Argv_command_run () {
  DoAllTheThings ;
}

Dispatch Argv "$@"
```

### dispatch.sh function call types:

There are four types of dispatch parse functions:

1. options

  - Options are expected follow one or two dashes, depending on whether short or long format.  The actual parse function for the option won't have any dashes -- for example, `Argv_option_force` would be used where `--force` is the expected command line option.

  - A short option has one dash and uses a space for any value that is set:  `-f /etc/conf/foo`   The optional value will be fed into the call script as $1 in the shifted namespace.

  - Long options use two dashes and use an = for setting values:  `--file=/etc/conf/foo`

  - If a value is expected to be set, it should be processed in the parse function and then shifted again.

  - Each option should end with `Dispatch Argv "$@"` again to continue processing options.

  - Both types are called in the same manner.  Thus using either one or two dashes with any option will always work, though Unix tradition generally assumes `-s single_letter` and `--word=full_word`.


2. commands

  - Commands have no preceding dashes.  The user may parse and shift subsequent arguments via standard shell methods.

3. `call`

  - `${namespace}_call_` is the catchall for when the parser runs out of pre-specified commands and options.
  It's the rough equivalent to * in a bash case statement.

  - `${namespace}_call_` will return the namespace as the first argument, so you need to shift before parsing
  any remaining arguments.

4. empty

  - The "empty" call which means no options (or no more options), called as function name `Argv_`.  This is the equivalent of (( $# == 0 )).


### dispatch.sh examples:


Example 1, from a puppet rake environment testing script:

```
Argv_call_           () { Usage; }
Argv_option_r        () { report=''; Dispatch Argv "$@"; }
Argv_command_prod    () { env="production";  host="$1" ; }
Argv_command_test    () { rakecheck=1     ;  host="$1" ; }
Argv_command_vagrant () { vagrant=1       ;  host="$1" ; }
Argv_command_noop    () {
  noop="--noop"
  rakecheck=1
  host="$1"
}

Dispatch Argv "$@"

## ... script continues
```

Example 2, from `sendfast`:

```
Argv_ ()                { Usage; }

Argv_call_ ()           { shift; Main "$@"; }

Argv_option_sorted ()   {
  sorted=1
  Dispatch Argv "$@"
}
Argv_option_depth ()    {
  (( $1 )) || Emergency "Must provide integer depth "
  depth="$1"
  shift
  Dispatch Argv "$@"
}
Argv_option_dotfiles () {
  dotfiles=1
  ls_cmd="$lsa_cmd"
  Dispatch Argv "$@"
}
Argv_option_sshuser ()  {
  [[ -n "$longval" ]] || Emergency "Must provide ssh username"
  ssh_cmd="$ssh_cmd -l $1"
  shift
  Dispatch Argv "$@"
}
Argv_option_sshkey ()   {
  [[ -n "$longval" ]] || Emergency "Must provide ssh private key file"
  ssh_cmd="$ssh_cmd -i $1"
  shift
  Dispatch Argv "$@"
}
Argv_option_threads ()  {
  (( $1 )) || Emergency "Must provide integer threads"
  threads="$longval"
  Dispatch Argv "$@"
}

Dispatch Argv "$@"

### end of script -- all Argv possibilities either continue parsing or call a function
exit $error
```

