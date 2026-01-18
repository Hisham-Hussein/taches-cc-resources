<meta_prompt_distinction>

## Templates vs Meta-Prompts

**Templates** (in `templates/`): Output structures Claude copies and fills

- Plans, specs, configs, reports
- User sees the filled template

**Meta-Prompts** (in `prompts/`): Prompts that agents fill in for OTHER agents

- Context handoffs, fork summaries
- Another Claude session receives the filled prompt

</meta_prompt_distinction>

<meta_prompt_check>

## Check: Does This Skill Need Agent-to-Agent Communication?

If the skill will:

- Spawn subagents via Task tool
- Run parallel operations with context handoff
- Chain multiple agent sessions (research → plan → implement)

Then:

→ Reference the `/create-meta-prompts` skill for prompt templates
→ The `prompts/` directory should contain meta-prompt templates, not just user-facing prompts

### Key Distinction

- `prompts/` with **user prompts** = templates the skill USER fills in
- `prompts/` with **meta-prompts** = templates that AGENTS fill in for other agents

### When to Use Meta-Prompts

| Scenario | Use Meta-Prompts? |
|----------|-------------------|
| Single Claude session | No |
| Task tool spawning subagents | Yes |
| Sequential Claude sessions | Yes |
| Parallel agent execution | Yes |
| User-facing templates only | No |

### Example: Fork Summary Meta-Prompt

When forking a conversation to a new agent, create a context handoff:

```markdown
<fork_summary>
## Context for New Agent

**Original Task**: {{task_description}}

**Work Completed**:
{{completed_work_summary}}

**Current State**:
{{current_state}}

**Your Task**:
{{specific_task_for_new_agent}}

**Constraints**:
{{any_constraints_or_requirements}}
</fork_summary>
```

See `/taches-cc-resources:create-meta-prompts` for full meta-prompt patterns including:

- Claude-to-Claude communication pipelines
- Structured handoffs with XML metadata
- Research → Plan → Implement chains
- Sequential/parallel execution patterns

</meta_prompt_check>
