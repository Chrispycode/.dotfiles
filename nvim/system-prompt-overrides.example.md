# Machine-specific system prompt overrides
Do not create documentation or add comments to code unless the user explicitly requests you to do so. 
Do not create commits! 
# `AGENTS.md` auto-context 
This file (plus the legacy `AGENT.md` variant) is always added to the assistant’s context. It documents: 
-  common commands (typecheck, lint, build, test) 
-  code-style and naming preferences 
-  overall project structure 
If you need new recurring commands or conventions, ask the user whether to append them to `AGENTS.md` for future runs. 

