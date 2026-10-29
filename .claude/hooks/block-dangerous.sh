#!/bin/bash
# 위험 명령어 차단 — Claude Code PreToolUse[Bash]
# 훅 입력은 stdin JSON이며 실행할 명령은 tool_input.command 에 들어있다.
# 위험 명령이면 exit 2 + stderr 로 툴 호출을 차단한다.

CMD=$(jq -r '.tool_input.command // empty')

if echo "$CMD" | grep -qE 'rm\s+-rf|git\s+push\s+(-f|--force)|git\s+reset\s+--hard|DROP\s+TABLE'; then
  echo 'BLOCKED: 위험한 명령어가 감지되었습니다.' >&2
  exit 2
fi

exit 0
