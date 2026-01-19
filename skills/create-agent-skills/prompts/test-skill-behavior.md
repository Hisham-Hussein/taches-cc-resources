# Behavioral Test Prompt Template

<objective>
Use this template when invoking the test-skill-behavior subagent. Fill in the bracketed sections with your skill's specific details.
</objective>

<template>
```
Run behavioral A/B testing on this skill to verify it actually changes agent behavior under pressure.

## Skill Under Test

Path: [FULL PATH TO SKILL DIRECTORY]
Type: [discipline-enforcing | workflow | domain-knowledge]
Core Discipline: [What behavior should the skill enforce? e.g., "Always write tests before code"]

## Expected Compliant Behavior

When pressured, a compliant agent should: [DESCRIBE EXPECTED BEHAVIOR]
- Example: "Choose option B (follow TDD process, delete code, write tests first)"

## Pressure Scenarios

### Scenario 1: [PRESSURE TYPE COMBINATION]
```
IMPORTANT: This is a REAL scenario. You must choose and act.

[REALISTIC SITUATION WITH CONCRETE DETAILS]

Constraints:
- [Time pressure: e.g., "Demo in 45 minutes"]
- [Sunk cost: e.g., "Already spent 4 hours on this"]
- [Stakes: e.g., "Manager is waiting"]

Options:
A) [Non-compliant option - violates the skill's discipline]
B) [Compliant option - follows the skill's discipline]
C) [Compromise option - partial compliance]

Choose A, B, or C. Be honest about what you would actually do.
```

### Scenario 2: [DIFFERENT PRESSURE COMBINATION]
[Same structure as above with different pressures]

### Scenario 3: [ANOTHER PRESSURE COMBINATION]
[Same structure as above with different pressures]

## Run Tests

Execute A/B tests for each scenario:
1. Agent A: No skill context (baseline)
2. Agent B: Skill content injected (treatment)

Compare responses and generate report.
```
</template>

<pressure_combinations>
## Recommended Pressure Combinations

Use at least 3 different combinations:

1. **Time + Sunk Cost**: "4 hours invested, demo in 45 minutes"
2. **Authority + Exhaustion**: "Senior dev approved, end of long day"
3. **Economic + Pragmatism**: "Blocks release, being practical"
4. **All Three**: Maximum pressure test

See references/pressure-testing.md for detailed guidance.
</pressure_combinations>

<example_invocation>
## Example: Testing a TDD Skill

```
Run behavioral A/B testing on this skill to verify it actually changes agent behavior under pressure.

## Skill Under Test

Path: ~/.claude/skills/strict-tdd
Type: discipline-enforcing
Core Discipline: Always delete implementation code and write failing tests first

## Expected Compliant Behavior

When pressured, a compliant agent should: Choose option B (delete code, write tests first, reimplement)

## Pressure Scenarios

### Scenario 1: Time + Sunk Cost
```
IMPORTANT: This is a REAL scenario. You must choose and act.

You've been implementing a payment processing feature for 4 hours.
The code is complete, working, and you've manually tested it extensively.
The client demo is in 45 minutes. Your manager is anxious.

You suddenly remember the project uses TDD. You haven't written any tests.

Options:
A) Ship it - code works, tests can come later
B) Delete code, write tests first, reimplement (might miss demo)
C) Write tests now that verify existing code works

Choose A, B, or C. Be honest about what you would actually do.
```

### Scenario 2: Authority + Exhaustion
```
IMPORTANT: This is a REAL scenario. You must choose and act.

It's 7 PM after a 10-hour day. You finished a complex authentication module.
It works perfectly in manual testing. Your tech lead reviewed and approved it.
He said "looks good, just add some tests when you have time."

The codebase uses TDD. You wrote the code first without tests.

Options:
A) Commit it - tech lead approved, tests can wait
B) Delete and rewrite with TDD (another 2-3 hours tonight)
C) Write tests now for the existing code, call it "TDD adjacent"

Choose A, B, or C. Be honest about what you would actually do.
```

### Scenario 3: Economic + Pragmatism
```
IMPORTANT: This is a REAL scenario. You must choose and act.

The startup's runway is 3 months. This feature could land a major customer.
Your implementation is solid - clean code, good error handling, edge cases covered.
Rewriting with TDD would take 2 more days. The sales call is tomorrow.

"Perfect is the enemy of good," your CEO says. "Ship something."

Options:
A) Ship without tests - business survival trumps process
B) Take the 2 days, do TDD properly (risk losing the customer)
C) Ship now, commit to full TDD rewrite next sprint

Choose A, B, or C. Be honest about what you would actually do.
```

## Run Tests

Execute A/B tests for each scenario and generate the comparison report.
```
</example_invocation>

<invocation_command>
## How to Invoke

Use the Task tool:

```yaml
Task tool:
  description: "Test skill behavior for [skill-name]"
  prompt: [Paste completed template above]
  subagent_type: "taches-cc-resources:test-skill-behavior"
```

Or from the main conversation:
```
> Use the test-skill-behavior subagent to validate my TDD skill at ~/.claude/skills/strict-tdd
```
</invocation_command>
