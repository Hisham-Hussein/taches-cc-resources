<cso_overview>
# Claude Search Optimization (CSO)

CSO ensures your skill is discoverable by future Claude instances. The `description` field in YAML frontmatter is the PRIMARY mechanism Claude uses to decide whether to load a skill for a given task.

**The discovery flow:**
1. User makes request
2. Claude scans all skill descriptions
3. Claude decides which skills to load based on description match
4. Loaded skills influence behavior

**If description fails:** Claude never loads the skill, no matter how good the content is.
</cso_overview>

<description_trap>
## The Description Trap (Critical)

**DISCOVERED FAILURE MODE:** When a description summarizes the skill's WORKFLOW, Claude may follow the description instead of reading the full skill body.

**Real-world example that failed:**

```yaml
# BROKEN: Claude did ONE code review instead of TWO
description: Use when executing plans - dispatches subagent per task with code review between tasks
```

The skill's flowchart clearly showed TWO reviews (spec compliance + code quality). But Claude saw "code review between tasks" in the description and stopped after the first review. Claude took the shortcut.

**Fixed version:**

```yaml
# WORKS: Claude reads the flowchart and finds both reviews
description: Use when executing implementation plans with independent tasks in the current session
```

**The rule:** Description = WHEN to use. Never HOW it works.

</description_trap>

<description_format>
## Description Format

**Structure:**
```yaml
description: [Triggering conditions] [Context/scope]. [Optional: what it provides]
```

**Key principles:**

1. **Start with "Use when..." or "This skill should be used when..."**
2. **Include specific trigger phrases** - exact words users might say
3. **Third person** - descriptions are injected into system prompts
4. **No workflow summary** - triggers only, not process
5. **Max 1024 characters** - but shorter is better

**Good examples:**

```yaml
# Technology-agnostic trigger
description: Use when tests have race conditions, timing dependencies, or pass/fail inconsistently

# Specific trigger phrases
description: This skill should be used when the user asks to "create a hook", "add a PreToolUse hook", "validate tool use", or mentions hook events

# Context + capability
description: Use when building LLM applications including agents, RAG systems, or tool integrations. Provides pattern selection and architecture guidance.
```

**Bad examples:**

```yaml
# Summarizes workflow (TRAP!)
description: Use for TDD - write test first, watch it fail, write minimal code, refactor

# Too vague
description: Helps with testing

# First person (wrong voice)
description: I can help you with async tests when they're flaky

# Technology-specific when skill is general
description: Use when tests use setTimeout and are flaky
```

</description_format>

<trigger_phrases>
## Trigger Phrase Patterns

Include phrases users actually say:

**Action triggers:**
- "create a X", "build a Y", "add a Z"
- "set up", "configure", "initialize"
- "fix the", "debug the", "troubleshoot"

**Problem triggers:**
- "X isn't working", "getting error Y"
- "flaky", "inconsistent", "slow"
- "how do I", "what's the best way to"

**Domain triggers:**
- Technology names: "React", "Python", "n8n"
- Concepts: "authentication", "caching", "deployment"
- File types: ".docx", "PDF", "spreadsheet"

**Example with multiple triggers:**

```yaml
description: This skill should be used when the user asks to "create a skill", "build a new skill", "write a skill", "improve skill description", or needs guidance on skill structure, YAML frontmatter, or progressive disclosure patterns.
```

</trigger_phrases>

<keyword_coverage>
## Keyword Coverage

Include words Claude would search for:

**Error messages:**
- "Hook timed out"
- "ENOTEMPTY"
- "race condition"
- "connection refused"

**Symptoms:**
- "flaky", "hanging", "zombie"
- "slow", "timeout", "memory leak"
- "inconsistent", "random failures"

**Synonyms:**
- timeout/hang/freeze
- cleanup/teardown/afterEach
- setup/initialize/configure

**Tools and libraries:**
- Actual command names
- Library names
- File extensions

**Place keywords throughout SKILL.md**, not just description. Claude searches the full content once loaded.

</keyword_coverage>

<naming_conventions>
## Skill Naming for Discovery

**Use verb-first, active naming:**

| Good | Bad |
|------|-----|
| `creating-skills` | `skill-creation` |
| `condition-based-waiting` | `async-test-helpers` |
| `debugging-with-logs` | `log-debugging` |
| `flatten-with-flags` | `data-structure-refactoring` |

**Gerunds (-ing) work well for processes:**
- `creating-`, `building-`, `testing-`
- `managing-`, `deploying-`, `configuring-`

**Name by core insight or action:**
- `root-cause-tracing` > `debugging-techniques`
- `defense-in-depth` > `security-patterns`

</naming_conventions>

<token_efficiency>
## Token Efficiency

Skills compete for context window space. Every token counts.

**Target word counts:**

| Skill Type | Target |
|------------|--------|
| getting-started workflows | <150 words |
| Frequently-loaded skills | <200 words total |
| Standard skills | <500 words body |
| Complex skills with references | SKILL.md <500, refs unlimited |

**Techniques:**

**Move details to tool help:**
```markdown
# BAD: Document all flags
The search command supports --text, --both, --after DATE...

# GOOD: Reference --help
search-conversations supports multiple modes. Run --help for details.
```

**Use cross-references:**
```markdown
# BAD: Repeat workflow details
When searching, dispatch subagent with template...
[20 lines repeated]

# GOOD: Reference other skill
Always use subagents. REQUIRED: See subagent-dispatch skill.
```

**Compress examples:**
```markdown
# BAD: Verbose (42 words)
Partner: "How did we handle authentication errors in React Router before?"
You: I'll search past conversations for React Router authentication patterns.
[Dispatch subagent with search query: "React Router authentication error handling 401"]

# GOOD: Minimal (20 words)
Partner: "How did we handle auth errors?"
You: Searching...
[Dispatch subagent → synthesis]
```

**Verification:**
```bash
wc -w SKILL.md
# getting-started: aim for <150
# frequently-loaded: aim for <200
```

</token_efficiency>

<progressive_disclosure>
## Progressive Disclosure for CSO

Keep SKILL.md lean, detailed content in references/:

**SKILL.md (always loaded):**
- Core concepts
- Quick reference
- Pointers to detailed docs

**references/ (loaded on demand):**
- Detailed patterns
- Comprehensive examples
- Edge cases
- API documentation

**Example structure:**

```
skill-name/
├── SKILL.md (500 words - core workflow)
└── references/
    ├── patterns.md (2000 words - detailed patterns)
    ├── examples.md (1500 words - code examples)
    └── troubleshooting.md (1000 words - edge cases)
```

Claude loads SKILL.md first, then references/ only when needed.

</progressive_disclosure>

<cso_checklist>
## CSO Checklist

**Description:**
- [ ] Starts with "Use when..." or "This skill should be used when..."
- [ ] Written in third person
- [ ] Contains specific trigger phrases (3+)
- [ ] Does NOT summarize workflow
- [ ] Under 1024 characters
- [ ] No angle brackets (< or >)

**Keywords:**
- [ ] Error messages that might trigger this skill
- [ ] Symptom words (flaky, slow, broken)
- [ ] Technology/tool names if applicable
- [ ] Synonyms for key concepts

**Naming:**
- [ ] Verb-first or gerund form
- [ ] Describes action or core insight
- [ ] Lowercase with hyphens
- [ ] Under 64 characters

**Token efficiency:**
- [ ] SKILL.md under 500 lines
- [ ] Detailed content in references/
- [ ] Examples are minimal, not verbose
- [ ] Cross-references instead of repetition

</cso_checklist>

<testing_discovery>
## Testing Skill Discovery

After writing a skill, verify it triggers correctly:

**Test 1: Direct trigger**
Say exactly what's in the trigger phrases. Does skill load?

**Test 2: Synonym trigger**
Say something similar but not exact. Does skill still load?

**Test 3: Negative trigger**
Say something unrelated. Skill should NOT load.

**Test 4: Competitive trigger**
Say something that could match multiple skills. Correct skill loads?

**If discovery fails:**
- Check description has specific trigger phrases
- Add more synonyms
- Make trigger conditions more explicit
- Check for conflicts with other skills
</testing_discovery>
