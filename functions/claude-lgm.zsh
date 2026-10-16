# claude-lgm: run Claude Code against lgm's local model for this one session; the default stays as set by work-split.
#
# Same environment work-split --personal lgm writes (Ollama's Anthropic port
# through the tbot tunnel on 127.0.0.1:11434, a bearer token, the 64k cap that
# matches num_ctx), but only for this process, so the subscription remains the
# default for every other session. Extra arguments pass through to claude.
claude-lgm() {
  ANTHROPIC_BASE_URL=http://127.0.0.1:11434 \
  ANTHROPIC_AUTH_TOKEN=ollama \
  ANTHROPIC_API_KEY= \
  CLAUDE_CODE_MAX_CONTEXT_TOKENS=65536 \
    command claude --model "${LGM_MODEL:-qwen3.5-sysad}" "$@"
}
