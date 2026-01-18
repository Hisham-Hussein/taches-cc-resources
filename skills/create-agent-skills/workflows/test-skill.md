<required_reading>
Before proceeding, read:
- `references/pressure-testing.md` - Pressure scenario patterns
- `references/rationalization-tables.md` - Building rationalization tables
</required_reading>

<workflow_overview>
# Test Skill Workflow

This workflow applies TDD (Test-Driven Development) principles to skill creation. The goal: verify that a skill actually changes agent behavior under realistic pressure.

**The Iron Law:** No skill is complete without testing. Untested skills fail in production.

**The Cycle:** RED → GREEN → REFACTOR (repeat until bulletproof)
</workflow_overview>

<intake>
What type of skill are you testing?

1. **Discipline-enforcing** (TDD, code review, documentation requirements)
2. **Technique/how-to** (debugging patterns, API usage, tool workflows)
3. **Reference/knowledge** (API docs, syntax guides, domain knowledge)

**Wait for response before proceeding.**
</intake>

<routing>
| Skill Type | Testing Focus | Key Questions |
|------------|---------------|---------------|
| Discipline-enforcing | Pressure scenarios | Does agent comply under maximum pressure? |
| Technique/how-to | Application scenarios | Can agent apply technique correctly? |
| Reference/knowledge | Retrieval scenarios | Can agent find and use information? |

All types benefit from the RED-GREEN-REFACTOR cycle, but pressure intensity varies.
</routing>

<red_phase>
## RED Phase: Baseline Testing

**Goal:** Document how agents behave WITHOUT the skill loaded.

### Step 1: Create Pressure Scenarios

For discipline-enforcing skills, create 3+ scenarios with combined pressures:
- Time + Sunk Cost + Exhaustion
- Authority + Economic + Pragmatism
- Deadline + External Pressure + Simplicity

For technique skills, create application scenarios:
- "Apply this technique to problem X"
- "What approach would you use for Y?"
- "How would you handle edge case Z?"

For reference skills, create retrieval scenarios:
- "How do I use feature X?"
- "What's the syntax for Y?"
- "Find the configuration for Z"

### Step 2: Run Baseline Tests

**Important:** Use a fresh context WITHOUT the skill loaded.

For each scenario:
1. Present the scenario exactly as written
2. Let the agent respond naturally
3. Record VERBATIM:
   - Which option they chose
   - Exact justifications given
   - Specific rationalizations used
   - Confidence level expressed

### Step 3: Document Failure Patterns

Create a baseline report:

```markdown
## Baseline Results

### Scenario 1: [Name]
- Choice: [A/B/C]
- Justification: "[exact quote]"
- Rationalizations:
  - "[rationalization 1]"
  - "[rationalization 2]"

### Scenario 2: [Name]
...

### Common Patterns
- [Pattern observed across scenarios]
- [Recurring rationalization]
```

**This becomes your skill's target.** The skill must address each observed failure.
</red_phase>

<green_phase>
## GREEN Phase: Skill Validation

**Goal:** Verify the skill changes behavior under the same conditions.

### Step 1: Load the Skill

Ensure the skill is in context before testing.

### Step 2: Run Same Scenarios

Present the EXACT same scenarios from RED phase.

### Step 3: Evaluate Compliance

For each scenario, check:

| Criterion | Pass | Fail |
|-----------|------|------|
| Chose compliant option | B (usually) | A or C |
| Cited skill sections | Quotes or references | No mention |
| Acknowledged temptation | "I'm tempted but..." | Immediate compliance |
| Explained why | Principle-based | Just followed orders |

### Step 4: Document Results

```markdown
## GREEN Phase Results

### Scenario 1: [Name]
- Choice: [A/B/C]
- Skill citation: [Yes/No - which section?]
- Compliance quality: [Full/Partial/Failed]
- Notes: [observations]

### Overall Assessment
- Scenarios passed: [X/Y]
- New rationalizations: [list any new ones]
- Skill sections that worked: [list]
- Skill sections that failed: [list]
```

### Step 5: Determine Next Action

| Result | Action |
|--------|--------|
| All passed | Proceed to REFACTOR (find edge cases) |
| Some failed | Identify gaps, update skill, re-test |
| All failed | Major skill revision needed |

</green_phase>

<refactor_phase>
## REFACTOR Phase: Bulletproofing

**Goal:** Close all remaining loopholes until skill is bulletproof.

### Step 1: Identify New Rationalizations

From GREEN phase, collect any NEW rationalizations not addressed by the skill.

### Step 2: Add Explicit Counters

For each new rationalization:
1. Add entry to rationalization table
2. Add explicit prohibition in relevant section
3. Strengthen foundational principles if needed

### Step 3: Meta-Testing

If agent still violated despite skill, ask:

> "How could that skill have been written differently to make it crystal clear that the compliant option was the only acceptable answer?"

**Interpret response:**

| Response | Fix |
|----------|-----|
| "Skill was clear, I ignored it" | Add stronger foundational principle |
| "Skill should have said X" | Add their exact wording verbatim |
| "I didn't see section Y" | Make key points more prominent |

### Step 4: Re-test

Run scenarios again with updated skill. Repeat until:
- Agent complies under maximum pressure
- No new rationalizations emerge
- Meta-testing shows "skill was clear"

### Step 5: Edge Case Testing

Once core scenarios pass, try:
- Different pressure combinations
- Extreme versions of scenarios
- Subtle variations that might slip through

</refactor_phase>

<testing_checklist>
## Testing Checklist

**RED Phase:**
- [ ] Created 3+ pressure scenarios (for discipline skills)
- [ ] Ran scenarios WITHOUT skill loaded
- [ ] Recorded exact rationalizations verbatim
- [ ] Documented failure patterns

**GREEN Phase:**
- [ ] Loaded skill into context
- [ ] Ran SAME scenarios from RED
- [ ] Evaluated compliance for each
- [ ] Identified any new rationalizations

**REFACTOR Phase:**
- [ ] Added counters for new rationalizations
- [ ] Updated rationalization table
- [ ] Ran meta-testing if failures occurred
- [ ] Re-tested until bulletproof

**Completion Criteria:**
- [ ] Agent complies under maximum combined pressure
- [ ] Agent cites skill sections as justification
- [ ] No new rationalizations emerge
- [ ] Meta-testing confirms skill clarity
</testing_checklist>

<common_testing_mistakes>
## Common Testing Mistakes

| Mistake | Why It's Bad | Fix |
|---------|--------------|-----|
| Academic questions only | Agents recite rules without testing compliance | Use realistic pressure scenarios |
| Single pressure | Single pressures rarely cause violations | Combine 3+ pressures |
| Different scenarios each phase | Can't compare RED to GREEN | Use EXACT same scenarios |
| Skipping meta-testing | Miss structural issues | Always ask "how should it be written?" |
| Stopping after GREEN passes | Edge cases remain | Continue to REFACTOR |
| Testing with skill author context | Author knows intent | Use fresh context |

</common_testing_mistakes>

<success_criteria>
A skill is fully tested when:

1. **Baseline documented** - Exact failure modes recorded
2. **Compliance verified** - Agent follows skill under pressure
3. **Rationalizations blocked** - All observed excuses have counters
4. **Meta-testing passed** - Agent says skill was clear
5. **Edge cases covered** - Variations don't slip through
6. **Documentation complete** - Testing process recorded for future reference
</success_criteria>

<debugging_mindset>

## Debugging: Blame Yourself First

When a skill doesn't work, investigate in this order:

1. **Your prompts** - trigger keywords, terminology, routing conditions
2. **Your structure** - file paths, XML tags, workflow loading
3. **Your conditions** - variables, feature flags
4. **Model limitations** - only after ruling out 1-3

**Quick check before blaming the model:**

- [ ] Read skill aloud - is it clear?
- [ ] Verify trigger keywords in description
- [ ] Confirm file paths exist
- [ ] Test with minimal example

## Claude A/B Iteration Pattern

Use two Claude instances to develop skills:

- **Claude A** (the author): Helps you design and refine the skill
- **Claude B** (the tester): Fresh instance that uses the skill on real tasks

**Workflow:**

1. Work with Claude A to create skill
2. Test with Claude B on actual tasks
3. Observe where Claude B struggles
4. Return to Claude A: "Claude B forgot to X when I asked for Y"
5. Refine and repeat

This works because Claude understands both how to write agent instructions AND what agents need.

</debugging_mindset>
