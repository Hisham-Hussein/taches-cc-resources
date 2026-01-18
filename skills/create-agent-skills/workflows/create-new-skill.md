# Workflow: Create a New Skill

<progressive_loading>
**Load reference files at point of need (not all upfront):**

| Step | File to Read | Why |
|------|--------------|-----|
| Step 3 | recommended-structure.md | Decide simple vs router pattern |
| Step 5 | skill-structure.md, core-principles.md | Write SKILL.md with correct structure |
| Step 5 CSO | cso-guide.md | Write description correctly |
| Step 5-7 | use-xml-tags.md | Write XML content |

**Read each file when you reach that step, not before.**
</progressive_loading>

<evaluation_structure>

## Evaluation Structure

When creating evaluations for your skill, use this format:

```json
{
  "skills": ["skill-name"],
  "query": "representative task request",
  "files": ["test-files/example.txt"],
  "expected_behavior": [
    "specific behavior 1",
    "specific behavior 2",
    "specific behavior 3"
  ]
}
```

</evaluation_structure>

<planning_phase>

## Step 0: Plan Before Building (Required)

Before touching the computer, answer on paper:

1. **Purpose**: What is this skill for? (one sentence)
2. **Problem**: What repetitive task or error does this solve?
3. **Deliverable**: What will exist when done?
   - SKILL.md structure (simple or router?)
   - Which subdirectories? (workflows/, references/, templates/, scripts/)
4. **Success Criteria**: How will you test that it works?
5. **Out of Scope**: What will this skill explicitly NOT do?

**Checkpoint**: Can you draw your skill's file structure on paper? If not, keep planning.

**For complex skills** (multi-phase builds, external API integration, domain expertise needed):
Use `/create-plan` to create a formal brief and roadmap first.
</planning_phase>

<process>
## Step 1: Adaptive Requirements Gathering

**If user provided context** (e.g., "build a skill for X"):
→ Analyze what's stated, what can be inferred, what's unclear
→ Skip to asking about genuine gaps only

**If user just invoked skill without context:**
→ Ask what they want to build

### Using AskUserQuestion

Ask 2-4 domain-specific questions based on actual gaps. Each question should:
- Have specific options with descriptions
- Focus on scope, complexity, outputs, boundaries
- NOT ask things obvious from context

Example questions:
- "What specific operations should this skill handle?" (with options based on domain)
- "Should this also handle [related thing] or stay focused on [core thing]?"
- "What should the user see when successful?"

### Decision Gate

After initial questions, ask:
"Ready to proceed with building, or would you like me to ask more questions?"

Options:
1. **Proceed to building** - I have enough context
2. **Ask more questions** - There are more details to clarify
3. **Let me add details** - I want to provide additional context

## Step 2: Research Trigger (If External API)

**When external service detected**, ask using AskUserQuestion:
"This involves [service name] API. Would you like me to research current endpoints and patterns before building?"

Options:
1. **Yes, research first** - Fetch current documentation for accurate implementation
2. **No, proceed with general patterns** - Use common patterns without specific API research

If research requested:
- Use Context7 MCP to fetch current library documentation
- Or use WebSearch for recent API documentation
- Focus on 2025-2026 sources
- Store findings for use in content generation

## Step 3: Decide Structure

**Read now:** `references/recommended-structure.md`

### 3a. Choose Base Structure

**Simple skill (single workflow, <200 lines):**
→ Single SKILL.md file with all content

**Complex skill (multiple workflows OR domain knowledge):**
→ Router pattern:
```
skill-name/
├── SKILL.md (router + principles)
├── workflows/ (procedures - FOLLOW)
├── references/ (knowledge - READ)
├── templates/ (output structures - COPY + FILL)
└── scripts/ (reusable code - EXECUTE)
```

Factors favoring router pattern:
- Multiple distinct user intents (create vs debug vs ship)
- Shared domain knowledge across workflows
- Essential principles that must not be skipped
- Skill likely to grow over time

### 3b. Component Checklist (Complete Before Proceeding)

**You MUST explicitly decide each item. Add to your TodoWrite if creating the component.**

| Component | Trigger Question | Decision |
|-----------|------------------|----------|
| **templates/** | Does skill produce consistent output structures (plans, specs, reports, documents)? | YES → create templates/ / NO → skip |
| **scripts/** | Does skill run the same code across invocations (deploy, setup, API calls)? | YES → create scripts/ / NO → skip |
| **variables.yaml** | Does skill have toggleable features, environment-specific behavior, or user preferences? | YES → create variables.yaml / NO → skip |
| **prompts/** | Does skill spawn subagents (Task tool) OR hand off context between sessions? | YES → create prompts/ / NO → skip |

**Decision examples:**

- Fork-terminal spawns subagents? → YES → needs prompts/ for handoff
- Skill has `verbose_mode` toggle? → YES → needs variables.yaml
- Skill always outputs a PLAN.md? → YES → needs templates/
- Skill deploys to cloud? → YES → needs scripts/

### 3c. References

See references/recommended-structure.md for directory templates.
See references/variables-pattern.md for variable usage.
See references/meta-prompts.md for agent-to-agent communication.

## Step 4: Create Directory

```bash
mkdir -p ~/.claude/skills/{skill-name}
# If complex:
mkdir -p ~/.claude/skills/{skill-name}/workflows
mkdir -p ~/.claude/skills/{skill-name}/references
# If needed:
mkdir -p ~/.claude/skills/{skill-name}/templates  # for output structures
mkdir -p ~/.claude/skills/{skill-name}/scripts    # for reusable code
```

## Step 5: Write SKILL.md (Progressive Building)

**Read now:** `references/skill-structure.md`, `references/core-principles.md`

Build in stages, testing at each gate before adding complexity:

### Gate 1: POC (Does it activate?)

- [ ] YAML frontmatter (name, description with triggers)
- [ ] One `<objective>` paragraph
- [ ] One `<quick_start>` example
- [ ] Basic `<success_criteria>`

**Test**: Invoke skill. Does it activate on the right triggers? Does quick_start work?

- ✅ Pass → Continue to Gate 2
- ❌ Fail → Fix before adding complexity

### Gate 2: MVP (Does it solve the problem?)

- [ ] Add workflows/ if multiple procedures needed
- [ ] Add references/ if domain knowledge needed
- [ ] Complete Steps 6-10 (structure, validation, slash command)

**Test**: Run through primary use case end-to-end.

- ✅ Pass → Continue to Gate 3 (if discipline skill) or ship
- ❌ Fail → Fix, re-test

### Gate 3: Production (Is it bulletproof?)

- [ ] TDD testing if discipline-enforcing (Step 12)
- [ ] Package if distributing (Step 13)

### Model Compatibility Check

Test with all models you plan to support:

- [ ] **Haiku**: Does it need more guidance? (fastest, needs clearer instructions)
- [ ] **Sonnet**: Is it clear and efficient? (balanced)
- [ ] **Opus**: Are you over-explaining? (powerful reasoning, verbose skills waste tokens)

What works for Opus may need more detail for Haiku. Aim for instructions that work across all target models.

**Why gates matter**: If you build everything before testing, you won't know which part broke. Each gate isolates problems to a specific stage.

### CSO Check for Description (CRITICAL)

**Read now:** `references/cso-guide.md`

**The Description Trap:** If description summarizes workflow, Claude may follow description instead of reading the skill body.

Verify the description field:

- ✅ Starts with "Use when..." or "This skill should be used when..."
- ✅ Contains specific trigger phrases users would say
- ✅ Written in third person
- ✅ Does NOT summarize workflow or process
- ❌ Never include step sequences or process descriptions

**Bad:** "Creates skill with TDD validation, pressure testing, and packaging"
**Good:** "Use when creating, auditing, or testing Claude Code skills"

## Step 6: Write Workflows (if complex)

**Read now:** `references/use-xml-tags.md` (if not already loaded)

For each workflow:
```xml
<required_reading>
Which references to load for this workflow
</required_reading>

<process>
Step-by-step procedure
</process>

<success_criteria>
How to know this workflow is done
</success_criteria>
```

## Step 7: Write References (if needed)

Domain knowledge that:
- Multiple workflows might need
- Doesn't change based on workflow
- Contains patterns, examples, technical details

## Step 8: Validate Structure

Check:
- [ ] YAML frontmatter valid
- [ ] Name matches directory (lowercase-with-hyphens)
- [ ] Description says what it does AND when to use it (third person)
- [ ] No markdown headings (#) in body - use XML tags
- [ ] Required tags present: objective, quick_start, success_criteria
- [ ] All referenced files exist
- [ ] SKILL.md under 500 lines
- [ ] XML tags properly closed

## Step 9: Create Slash Command

```bash
cat > ~/.claude/commands/{skill-name}.md << 'EOF'
---
description: {Brief description}
argument-hint: [{argument hint}]
allowed-tools: Skill({skill-name})
---

Invoke the {skill-name} skill for: $ARGUMENTS
EOF
```

## Step 10: Quick Validation

Run the validation script:
```bash
scripts/validate-skill.sh ~/.claude/skills/{skill-name}
```

Fix any errors before proceeding.

## Step 11: Basic Test

Invoke the skill and observe:
- Does it ask the right intake question?
- Does it load the right workflow?
- Does the workflow load the right references?
- Does output match expectations?

## Step 12: TDD Testing (For Discipline Skills)

**If skill enforces discipline** (TDD, code review, documentation requirements):

Read `references/pressure-testing.md` and `references/rationalization-tables.md`.

### RED Phase - Baseline Test
1. Create 3+ pressure scenarios (time + sunk cost + exhaustion)
2. Run scenarios WITHOUT skill loaded
3. Document exact rationalizations verbatim

### GREEN Phase - Validate Skill
1. Load skill into context
2. Run SAME scenarios
3. Verify agent now complies

### REFACTOR Phase - Bulletproof
1. Find NEW rationalizations from GREEN
2. Add explicit counters to skill
3. Build rationalization table
4. Re-test until bulletproof

**Skip TDD for:** Reference skills, technique guides, domain knowledge skills.

## Step 13: Package (Optional)

If distributing the skill:
```bash
scripts/package-skill.sh ~/.claude/skills/{skill-name} ./dist
```

Creates `{skill-name}.skill` file for distribution.

## Step 14: Self-Verification (REQUIRED)

**You MUST spawn a verification subagent before reporting the skill is complete.**

This step is not optional. Do not rationalize skipping it because you "already validated manually" or "the skill looks good." Manual validation misses things. Spawn the verifier.

### What to Pass to Verifier

Prepare this context summary:

```text
Skill Directory: [full path to skill]
Skill Type: [simple | complex (router pattern)]

Files Created:
- [list all files you created]

Decisions Made:
- templates/: [YES/NO - reason]
- scripts/: [YES/NO - reason]
- variables.yaml: [YES/NO - reason]
- prompts/: [YES/NO - reason]
- Structure: [simple | router]
- CSO description: "[exact description from frontmatter]"

Proposed Structure (from planning):
[paste the structure you showed during planning phase]
```

### Invoke Verifier

Use the Task tool with `subagent_type: "general-purpose"` (needs Read/Glob access):

```yaml
Task tool invocation:
- description: "Verify skill build quality for {skill-name}"
- prompt: [Read prompts/verify-skill-build.md, then provide the context summary above]
- subagent_type: "general-purpose"
```

### Interpret Results

**PASS**: Report verification results to user. Skill is complete.

**FAIL**: Report issues to user with specific findings. Ask if they want to fix now or proceed with flagged issues.

**Important**: You have not completed the skill build until you have spawned the verifier and received results. "I validated it myself" is not a substitute.

### Strict Mode

To enable strict mode, user says "verify strictly" or "block on failures" when requesting the skill build.

In strict mode, FAIL status means:

1. Show issues to user
2. Ask: "Would you like to fix these issues now, or proceed anyway?"
3. If fixing, address each issue then re-run verification
4. Do not mark skill complete until verification passes
</process>

<success_criteria>
Skill is complete when:

- [ ] Requirements gathered with appropriate questions
- [ ] API research done if external service involved
- [ ] Directory structure correct
- [ ] SKILL.md has valid frontmatter
- [ ] Description follows CSO (triggers only, no workflow summary)
- [ ] Essential principles inline (if complex skill)
- [ ] Intake question routes to correct workflow
- [ ] All workflows have required_reading + process + success_criteria
- [ ] References contain reusable domain knowledge
- [ ] Slash command exists and works
- [ ] Validation script passes
- [ ] Tested with real invocation
- [ ] TDD testing done (if discipline-enforcing skill)
- [ ] Self-verification passed (or issues flagged to user)
</success_criteria>
