---
name: {{SKILL_NAME}}
description: Expert guidance for {{domain}}. Use when {{trigger phrase 1}}, {{trigger phrase 2}}, or {{trigger phrase 3}}.
---

<!-- CSO REMINDER: Description says WHEN to use, never HOW it works.
     ❌ BAD: "Routes to workflows, validates outputs, aggregates results"
     ✅ GOOD: "Use when working with X or when user mentions Y"
-->

<essential_principles>
{{Principles that ALWAYS apply, regardless of which workflow runs}}

1. **{{First principle}}**
   {{Explanation - keep concise}}

2. **{{Second principle}}**
   {{Explanation - keep concise}}

3. **{{Third principle}}**
   {{Explanation - keep concise}}
</essential_principles>

<intake>
What would you like to do?

1. {{First option}}
2. {{Second option}}
3. {{Third option}}

**Wait for response before proceeding.**
</intake>

<routing>
| Response | Workflow |
|----------|----------|
| 1, "{{keywords}}" | `workflows/{{first-workflow}}.md` |
| 2, "{{keywords}}" | `workflows/{{second-workflow}}.md` |
| 3, "{{keywords}}" | `workflows/{{third-workflow}}.md` |

**After reading the workflow, follow it exactly.**
</routing>

<quick_reference>
{{Brief reference information always useful to have visible - keep under 150 words}}
</quick_reference>

<reference_index>
All in `references/`:

- {{reference-1.md}} - {{purpose}}
- {{reference-2.md}} - {{purpose}}
</reference_index>

<workflows_index>
All in `workflows/`:

| Workflow | Purpose |
|----------|---------|
| {{first-workflow}}.md | {{purpose}} |
| {{second-workflow}}.md | {{purpose}} |
| {{third-workflow}}.md | {{purpose}} |
</workflows_index>

<!-- TESTING SECTION: Include if this is a discipline-enforcing skill
     (imposes constraints, requires specific order, blocks shortcuts)

<testing_notes>
## TDD Validation Status

**Baseline failures documented:** {{YES/NO}}
**Rationalization table:** See `references/rationalizations.md`

Pressure scenarios tested:
- [ ] Time pressure + sunk cost
- [ ] Authority suggestion + exhaustion
- [ ] Economic pressure + pragmatism appeal
</testing_notes>
-->

<success_criteria>
A well-executed {{skill name}}:

- {{First criterion - must be verifiable}}
- {{Second criterion - must be verifiable}}
- {{Third criterion - must be verifiable}}
</success_criteria>
