---
description: Heal skill documentation by applying corrections discovered during execution with approval workflow
argument-hint: [optional: specific issue to fix]
allowed-tools: [Read, Edit, Bash(ls:*), Bash(git:*)]
---

<objective>
Update a skill's SKILL.md and related files based on corrections discovered during execution.

Analyze the conversation to detect which skill is running, reflect on what went wrong, propose specific fixes, get user approval, then apply changes with optional commit.
</objective>

<context>
Skill locations to check:
- Personal: !`ls -1 ~/.claude/skills/*/SKILL.md 2>/dev/null | head -3`
- Project: !`ls -1 ./.claude/skills/*/SKILL.md 2>/dev/null | head -3`
- Plugins: !`ls -d ~/.claude/plugins/cache/*/skills/*/SKILL.md 2>/dev/null | head -3`
</context>

<quick_start>
<workflow>
1. **Detect skill** from conversation context (invocation messages, recent SKILL.md references)
2. **Reflect** on what went wrong and how you discovered the fix
3. **Present** proposed changes with before/after diffs
4. **Get approval** before making any edits
5. **Apply** changes and optionally commit
</workflow>
</quick_start>

<common_scenarios>

| Scenario                 | Typical Fix                                  |
| ------------------------ | -------------------------------------------- |
| API endpoint changed     | Update URL in examples and references        |
| Parameter renamed        | Find/replace across SKILL.md and references/ |
| New required field       | Add to examples, update validation notes     |
| Outdated library syntax  | Update code examples to current API          |
| Missing edge case        | Add handling instructions and examples       |
| Wrong tool referenced    | Correct tool name, verify it exists          |

</common_scenarios>

<process>
<step_1 name="detect_skill">
Identify the skill from conversation context:

1. Look for skill invocation messages (e.g., "Invoking skill: [name]")
2. Check which SKILL.md was recently read in this conversation
3. Search common locations:
   - Personal: `~/.claude/skills/[name]/SKILL.md`
   - Project: `./.claude/skills/[name]/SKILL.md`
   - Plugins: `~/.claude/plugins/cache/*/skills/[name]/SKILL.md`

Set: `SKILL_NAME=[skill-name]` and `SKILL_PATH=[full path to SKILL.md]`

**Read-only check:** If skill is in plugins cache, warn user that edits require copying to personal/project location first.

If unclear, ask the user which skill to heal.
</step_1>

<step_2 name="reflection_and_analysis">
Focus on $ARGUMENTS if provided, otherwise analyze broader context.

Determine:
- **What was wrong**: Quote specific sections from SKILL.md that are incorrect
- **Discovery method**: Context7, error messages, trial and error, documentation lookup
- **Root cause**: Outdated API, incorrect parameters, wrong endpoint, missing context
- **Scope of impact**: Single section or multiple? Related files affected?
- **Proposed fix**: Which files, which sections, before/after for each
</step_2>

<step_3 name="scan_affected_files">
```bash
ls -la $SKILL_DIR/
ls -la $SKILL_DIR/references/ 2>/dev/null
ls -la $SKILL_DIR/scripts/ 2>/dev/null
```
</step_3>

<step_4 name="present_proposed_changes">
Present changes in this format:

```
**Skill being healed:** [skill-name]
**Issue discovered:** [1-2 sentence summary]
**Root cause:** [brief explanation]

**Files to be modified:**
- [ ] SKILL.md
- [ ] references/[file].md
- [ ] scripts/[file].py

**Proposed changes:**

### Change 1: SKILL.md - [Section name]
**Location:** Line [X] in SKILL.md

**Current (incorrect):**
```
[exact text from current file]
```

**Corrected:**
```
[new text]
```

**Reason:** [why this fixes the issue]

[repeat for each change across all files]

**Impact assessment:**
- Affects: [authentication/API endpoints/parameters/examples/etc.]

**Verification:**
These changes will prevent: [specific error that prompted this]
```
</step_4>

<step_5 name="request_approval">
```
Should I apply these changes?

1. Yes, apply and commit all changes
2. Apply but don't commit (let me review first)
3. Revise the changes (I'll provide feedback)
4. Cancel (don't make changes)

Choose (1-4):
```

**Wait for user response. Do not proceed without approval.**
</step_5>

<step_6 name="apply_changes">
Only after approval (option 1 or 2):

1. Use Edit tool for each correction across all files
2. Read back modified sections to verify
3. If option 1, commit with structured message showing what was healed
4. Confirm completion with file list

**If skill is read-only (plugin-based):**

1. Ask user where to copy skill: personal (`~/.claude/skills/`) or project (`./.claude/skills/`)
2. Copy skill directory to chosen location
3. Apply edits to the copy
4. Inform user the plugin version remains unchanged
</step_6>

<example_heal>
**Example: Fixing an outdated API endpoint**

User was running a skill that failed with 404 on `api.example.com/v1/data`.
Context7 revealed the endpoint moved to `api.example.com/v2/data`.

```markdown
**Skill being healed:** data-fetcher
**Issue discovered:** API endpoint returns 404 - endpoint moved to v2
**Root cause:** API v1 deprecated, v2 now required

**Proposed changes:**

### Change 1: SKILL.md - API endpoint section
**Location:** Line 45 in SKILL.md

**Current (incorrect):**
endpoint = "https://api.example.com/v1/data"

**Corrected:**
endpoint = "https://api.example.com/v2/data"

**Reason:** v1 endpoint deprecated, v2 is current
```

</example_heal>
</process>

<success_criteria>
- Skill correctly detected from conversation context
- All incorrect sections identified with before/after
- User approved changes before application
- All edits applied across SKILL.md and related files
- Changes verified by reading back
- Commit created if user chose option 1
- Completion confirmed with file list
</success_criteria>

<verification>
Before completing:

- Read back each modified section to confirm changes applied
- Ensure cross-file consistency (SKILL.md examples match references/)
- Verify git commit created if option 1 was selected
- Check no unintended files were modified
</verification>
