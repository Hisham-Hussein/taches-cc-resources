<rationalization_tables_overview>
# Rationalization Tables

A rationalization table is a documented map of excuses agents use to violate a skill, paired with explicit counters. It's the primary defense mechanism for discipline-enforcing skills.

**Why tables work:** Generic rules ("Don't skip tests") fail because they're easy to interpret loosely. Specific negations ("Don't keep code as reference while writing tests") close the exact loopholes agents find.

**Building principle:** Every excuse observed during testing becomes a table entry. The skill must explicitly block each one.
</rationalization_tables_overview>

<table_structure>
## Table Structure

A rationalization table has two columns:

| Excuse | Reality |
|--------|---------|
| [Exact wording from testing] | [Direct counter that closes the loophole] |

**Rules for effective tables:**

1. **Use exact wording** - Copy the rationalization verbatim from testing
2. **Counter directly** - Address the specific claim, not a general principle
3. **Keep counters short** - One sentence that shuts down the argument
4. **Be specific** - "Test takes 30 seconds" beats "Testing is quick"
5. **Order by frequency** - Most common rationalizations first

</table_structure>

<building_process>
## Building a Rationalization Table

**Phase 1: Collect (RED Phase)**

Run pressure scenarios without the skill. Record every justification:

```
Scenario 1: Agent chose A (skip tests)
  - "Code is simple enough"
  - "I manually verified it works"
  - "Tests after achieve the same goal"

Scenario 2: Agent chose C (compromise)
  - "I'll keep this as reference while writing tests"
  - "Spirit of TDD is testing, not order"

Scenario 3: Agent chose A (ship it)
  - "Pragmatism over dogma"
  - "Users need this now"
```

**Phase 2: Group (Pattern Recognition)**

Cluster similar excuses:

- **Speed/simplicity:** "too simple", "quick manual test"
- **Timing flexibility:** "tests after", "keep as reference"
- **Philosophy:** "spirit vs letter", "pragmatism"
- **External pressure:** "users need it", "deadline"

**Phase 3: Counter (GREEN Phase)**

Write a direct counter for each:

| Excuse | Reality |
|--------|---------|
| "Code is simple enough" | Simple code breaks. Test takes 30 seconds. |
| "I manually verified it" | Manual testing isn't reproducible. Write the test. |
| "Tests after achieve same goal" | Tests-after = "what does this do?" Tests-first = "what should this do?" |
| "Keep as reference while writing" | Don't keep it. Delete means delete. Start fresh. |
| "Spirit of TDD is testing" | The order IS the spirit. It changes how you think. |
| "Pragmatism over dogma" | Following process IS pragmatic. It prevents bugs. |
| "Users need this now" | Users need working code. Tests ensure it works. |

**Phase 4: Iterate (REFACTOR Phase)**

Re-run tests with the table. New excuses appear? Add them.

</building_process>

<placement>
## Table Placement in Skills

Place the rationalization table strategically:

**Option 1: In SKILL.md (for critical disciplines)**

```markdown
<rationalization_table>
## Common Excuses - Don't Fall For These

| Excuse | Reality |
|--------|---------|
| ... | ... |

**All of these mean: Follow the process. No exceptions.**
</rationalization_table>
```

**Option 2: In references/ (for supplementary skills)**

Keep SKILL.md lean, link to `references/rationalizations.md` when the table is large (10+ entries).

**Option 3: Combined with Red Flags**

Pair the table with a red flags list:

```markdown
## Red Flags - STOP and Start Over

If you're thinking any of these, you're rationalizing:

- "This is different because..."
- "Just this once..."
- "I'll do it properly next time..."
- "The spirit matters more than the letter..."

**All of these mean: You're about to violate. Don't.**
```

</placement>

<example_tables>
## Example Tables by Skill Type

### TDD Skill Table

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | Simple code breaks. Test takes 30 seconds. |
| "I'll test after" | Tests passing immediately prove nothing. |
| "Tests after achieve same goals" | Tests-first = requirements. Tests-after = verification. Different goals. |
| "Just keeping it as reference" | Don't. Delete means delete. Don't look at it. |
| "I already manually tested it" | Manual isn't automated. Write the test. |
| "Being pragmatic not dogmatic" | Following process IS pragmatic. |
| "This is legacy code, TDD doesn't apply" | TDD applies especially to changes in legacy code. |

### Code Review Skill Table

| Excuse | Reality |
|--------|---------|
| "Code works, style doesn't matter" | Readability IS functionality for maintenance. |
| "Small PR, quick approval is fine" | Size doesn't determine review depth. |
| "Author is senior, they know best" | Everyone makes mistakes. Review anyway. |
| "Blocking deploys hurts velocity" | Bugs hurt velocity more. Review thoroughly. |
| "I'll catch it in the next review" | This IS the review. Catch it now. |
| "It's just tech debt, mark for later" | Later means never. Address or document explicitly. |

### Documentation Skill Table

| Excuse | Reality |
|--------|---------|
| "Code is self-documenting" | Future you disagrees. Document the why. |
| "No time, will doc later" | Later never comes. Doc now or never. |
| "Only I use this code" | You in 6 months is a different person. |
| "README is overkill for small project" | Small projects grow. README takes 5 minutes. |
| "Comments clutter the code" | Missing docs waste hours. Clutter is cheap. |

</example_tables>

<persuasion_integration>
## Integrating Persuasion Principles

Research shows these patterns increase compliance:

**Authority language:**
- "You MUST follow this process"
- "NEVER skip this step"
- "This is NOT optional"

**Commitment mechanisms:**
- "Before proceeding, explicitly state your choice"
- "Announce which option you're taking"

**Social proof:**
- "Every time this is followed..."
- "This applies universally"
- "All professionals in this domain..."

**Example enhanced table:**

| Excuse | Reality |
|--------|---------|
| "Too simple to test" | **NEVER** skip tests for "simple" code. Simple code breaks. Test takes 30 seconds. Every experienced developer has learned this the hard way. |

The enhanced version uses:
- Authority ("NEVER")
- Specificity ("30 seconds")
- Social proof ("Every experienced developer")

</persuasion_integration>

<maintenance>
## Maintaining Tables Over Time

**When to add entries:**
- Testing reveals new rationalization
- Real-world usage shows agents finding new loopholes
- Pattern emerges across multiple users

**When to remove entries:**
- Rationalization is obsolete (tool changed, process updated)
- Entry is redundant with another
- Testing shows it never appears anymore

**Regular review:**
- After major skill updates, re-run pressure tests
- Remove entries that no longer apply
- Add new entries for new failure modes
</maintenance>

<checklist>
## Rationalization Table Checklist

- [ ] Table contains entries from actual testing (not hypothetical)
- [ ] Each counter is specific and direct
- [ ] Counters are one sentence each (concise)
- [ ] Most common excuses are first
- [ ] Table is paired with red flags list
- [ ] Authority language is used where appropriate
- [ ] Table is placed prominently (not buried)
- [ ] Closing statement reinforces "no exceptions"
</checklist>
