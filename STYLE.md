
## down and dirty bash style guide:

-  #!/usr/bin/env bash is the most portable hash-bang.

-  Two-space indentation except following individual case items (see below).

-  Static variables should be all-caps.  These generally should be either
   environment variables or sourced from config files.

-  Dynamic/local variables are all-lowercase.  These are easily parsed
   especially with modern syntax highlighting.

-  Function names in CamelCase, function declarations should look like:
   ```
   MyFunction () {
        ...
   }
   ```
   This is very useful convention because it clarifies at a glance
   whether you're calling a function or an external command (or shell
   built-in).

-  Use double-parens for numerical tests.  This allows standard
   math symbols ( ==, >, <=, !=) rather than requiring the awkward
   -ne, -gt, etc.   Bash makes the use of a dollar sign on the
   variable name optional in this construct;  however, avoid the '$'
   where possible because it can introduce subtle bugs.  The major
   exception is for shell builtins such as $? and $#, where the
   '$' is required.

   Thus,
   ```
     if (( foo > 2 )); then
     (( $# != 2 )) && Usage
   ```

-  Use double-braces for non-numerical tests:
   ```
   [[ -f "$CONF_FILE" ]] && source "$CONF_FILE"
   ```

-  Speaking of which, "source" is much more readable than "."

-  Prefer double-parens to "let" or other methods for integer arithmetic,
   without any $'s inside the parens:
   ```
     (( foo++ )) ;  (( baz = bar % 2 ))
   ```

-  Prefer
   ```
     (( bar = foo + 1 ))
   ```
   to
   ```
     bar=$(( foo + 1 ))
   ```

-  Double-quote string variables in most situations.  An example of
   the reason for this:

   If you use
   ```
     if [[ $foo == "bar" ]]
   ```
   and $foo is empty/undefined, then bash parses the test:
   ```
     if [[ == "bar" ]]
   ```
   This produces a syntax error and ends script execution.

   Using quotes around "$foo" fixes the problem, as bash will then see
   ```
     if [[ "" == "bar" ]]
   ```
   Which produces FALSE.

-  Use curly braces around string variables if they are part of another
   string with no spaces around both sides;  otherwise no curly braces.
   ```
     FOOCMD="${FOODIR}/${FOOEXE}"

     BARCMD="$FOOCMD"
   ```

-  Use $( ) vice ` ` for command subsitution
   $( ) is nestable and it's much more readable.

-  Use 'gawk' vice 'awk', because it's much more consistent across
   platforms.

-  Error-check every statement, within reason.

-  Don't do this:

   ```
   (Debug "$VAR" && Emergency ... )
   ```

   Here if the Debug call fails, the Emergency will too.  Only use
   && if you only want the next command to run if the last one didn't fail.

-  "then"/"do" on the same line as if/for/while statements:
   ```
   if [[ "$foo" == "bar" ]]; then
     echo "true"
   fi

   while (( 1 )); do    ## 1 is numerical, so use (( ))
     MyDaemonLoop
     sleep 60
   done
   ```

-  Keep lines under 80 characters if conveniently possible, but don't
   go overboard in efforts to do this.

-  Break up very long commands with \, and very long pipe strings
   or &&/|| strings with newlines.  In both cases use one line
   per item regardless of their length once you're breaking them up
   and you're above three items or so.

-  Do not use \ immediately before or after ||, && or |.  It is
   redundant and unnecessary in modern bash, a line break immediately
   after those commands will continue the line just like \.

-  Indent two spaces after breaking the first line with ||, &&, | or \.
   Subsequent breaks even with the second line.

-  Case statement format:
   ```
   case $foo in
     'start')
         do_something         ## indented 4 spaces
         do_something else
       ;;                     ## indent only 2 spaces to close the statement
     'stop')
         undo_something
       ;;
     *)  Usage ;;             ## only do this for short single lines
   esac
   ```

-  Avoid using 'ls' or other commands with similar output in this manner:
   ```
   for item in $(ls "$MY_DIR"); do
     something "$item"
   done
   ```
   Here, 'for' will parse any filename containing spaces as two separate
   items.  It's true most of our filenames should never contain spaces,
   but you can't always control what someone behind you might do.  This is
   just one more example of the need to take extra care of the shell's
   default parsing on spaces, the same reason we usually quote string names.

   If you need to use 'ls' like this, here are two better constructs:
   ```
   ls -1 "$MY_DIR" | xargs -L 1 something

   while read item; do
     something "$item"
   done < <(ls -1 "$MY_DIR")
   ```
