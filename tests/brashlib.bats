#!/usr/bin/env bats

@test "Check Info, Notice, Warning, Error, Critical, Alert" {
  run tests/examples/logging.sh
  [[ "$status" -eq 3 ]]
  [[ "$output" =~ "info" ]]
  [[ "$output" =~ "notice" ]]
  [[ "$output" =~ "warning" ]]
  [[ "$output" =~ "error" ]]
  [[ "$output" =~ "critical" ]]
  [[ "$output" =~ "alert" ]]
}

@test "Check Emergency" {
  run tests/examples/emergency.sh
  [[ "$status" -eq 255 ]]
  [[ "$output" =~ "emergency" ]]
}

# This does not test that the priority is set correctly
@test "Check SetLogger overrides logging" {
  match=$RANDOM
  run tests/examples/setlogger.sh $match
  [[ "$status" -eq 3 ]]
  [[ "$output" == "" ]]

## Mac logging broke with laptop upgrade, commenting out for now
#  run grep -A7 "setlogger.sh.*$match" /private/var/log/system.log
#  [[ "$status" -eq 0 ]]
#  [[ "$output" =~ "msg2" ]]
#  [[ "$output" =~ "msg3" ]]
#  [[ "$output" =~ "msg4" ]]
#  [[ "$output" =~ "msg5" ]]
#  [[ "$output" =~ "msg6" ]]
#  [[ "$output" =~ "stdout" ]]
#  [[ "$output" =~ "stderr" ]]

#  count=$(echo "$output" | wc -l)
#  [[ "$count" -eq 8 ]]
}
