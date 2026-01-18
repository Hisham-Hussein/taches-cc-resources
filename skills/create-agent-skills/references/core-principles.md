<overview>
Core principles guide skill authoring decisions. These principles ensure skills are efficient, effective, and maintainable across different models and use cases.
</overview>

<core_four>

## The Core Four

Skills configure four primitives: **Context** (references), **Model** (which LLM), **Prompt** (instructions), **Tools** (scripts/MCP).

Master these four, master agentic engineering.

</core_four>

<xml_structure_principle>
<description>
Skills use pure XML structure for consistent parsing, efficient token usage, and improved Claude performance.
</description>

<why_xml>
<consistency>
XML enforces consistent structure across all skills. All skills use the same tag names for the same purposes:
- `<objective>` always defines what the skill does
- `<quick_start>` always provides immediate guidance
- `<success_criteria>` always defines completion

This consistency makes skills predictable and easier to maintain.
</consistency>

<parseability>
XML provides unambiguous boundaries. Claude can reliably identify sections, understand purpose, skip irrelevant content, and parse programmatically. Markdown headings require inference.
</parseability>

<token_efficiency>
XML tags are more efficient than markdown headings:

**Markdown headings**:
```markdown
## Quick start
## Workflow
## Advanced features
## Success criteria
```
Total: ~20 tokens, no semantic meaning to Claude

**XML tags**:
```xml
<quick_start>
<workflow>
<advanced_features>
<success_criteria>
```
Total: ~15 tokens, semantic meaning built-in

Savings compound across all skills in the ecosystem.
</token_efficiency>

<claude_performance>
Claude performs better with pure XML: unambiguous boundaries reduce parsing errors, semantic tags convey intent directly, nested tags create hierarchies, consistent structure reduces cognitive load, and progressive disclosure works reliably.
</claude_performance>
</why_xml>

<critical_rule>
**Remove ALL markdown headings (#, ##, ###) from skill body content.** Replace with semantic XML tags. Keep markdown formatting WITHIN content (bold, italic, lists, code blocks, links).
</critical_rule>

<required_tags>
Every skill MUST have:
- `<objective>` - What the skill does and why it matters
- `<quick_start>` - Immediate, actionable guidance
- `<success_criteria>` or `<when_successful>` - How to know it worked

See [use-xml-tags.md](use-xml-tags.md) for conditional tags and intelligence rules.
</required_tags>
</xml_structure_principle>

<conciseness_principle>
<description>
The context window is shared. Your skill shares it with the system prompt, conversation history, other skills' metadata, and the actual request.
</description>

<guidance>
Only add context Claude doesn't already have. Challenge each piece of information:
- "Does Claude really need this explanation?"
- "Can I assume Claude knows this?"
- "Does this paragraph justify its token cost?"

Assume Claude is smart. Don't explain obvious concepts.
</guidance>

<concise_example>
**Concise** (~50 tokens):
```xml
<quick_start>
Extract PDF text with pdfplumber:

```python
import pdfplumber

with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```
</quick_start>
```

**Verbose** (~150 tokens):
```xml
<quick_start>
PDF files are a common file format used for documents. To extract text from them, we'll use a Python library called pdfplumber. First, you'll need to import the library, then open the PDF file using the open method, and finally extract the text from each page. Here's how to do it:

```python
import pdfplumber

with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

This code opens the PDF and extracts text from the first page.
</quick_start>
```

The concise version assumes Claude knows what PDFs are, understands Python imports, and can read code. All those assumptions are correct.
</concise_example>

<when_to_elaborate>
Add explanation when:
- Concept is domain-specific (not general programming knowledge)
- Pattern is non-obvious or counterintuitive
- Context affects behavior in subtle ways
- Trade-offs require judgment

Don't add explanation for:
- Common programming concepts (loops, functions, imports)
- Standard library usage (reading files, making HTTP requests)
- Well-known tools (git, npm, pip)
- Obvious next steps
</when_to_elaborate>
</conciseness_principle>

<degrees_of_freedom_principle>
<description>
Match the level of specificity to the task's fragility and variability. Give Claude more freedom for creative tasks, less freedom for fragile operations.
</description>

<high_freedom>
<when>
- Multiple approaches are valid
- Decisions depend on context
- Heuristics guide the approach
- Creative solutions welcome
</when>

<example>
```xml
<objective>
Review code for quality, bugs, and maintainability.
</objective>

<workflow>
1. Analyze the code structure and organization
2. Check for potential bugs or edge cases
3. Suggest improvements for readability and maintainability
4. Verify adherence to project conventions
</workflow>

<success_criteria>
- All major issues identified
- Suggestions are actionable and specific
- Review balances praise and criticism
</success_criteria>
```

Claude has freedom to adapt the review based on what the code needs.
</example>
</high_freedom>

<medium_freedom>
<when>
- A preferred pattern exists
- Some variation is acceptable
- Configuration affects behavior
- Template can be adapted
</when>

<example>
```xml
<objective>
Generate reports with customizable format and sections.
</objective>

<report_template>
Use this template and customize as needed:

```python
def generate_report(data, format="markdown", include_charts=True):
    # Process data
    # Generate output in specified format
    # Optionally include visualizations
```
</report_template>

<success_criteria>
- Report includes all required sections
- Format matches user preference
- Data accurately represented
</success_criteria>
```

Claude can customize the template based on requirements.
</example>
</medium_freedom>

<low_freedom>
<when>
- Operations are fragile and error-prone
- Consistency is critical
- A specific sequence must be followed
- Deviation causes failures
</when>

<example>
```xml
<objective>
Run database migration with exact sequence to prevent data loss.
</objective>

<workflow>
Run exactly this script:

```bash
python scripts/migrate.py --verify --backup
```

**Do not modify the command or add additional flags.**
</workflow>

<success_criteria>
- Migration completes without errors
- Backup created before migration
- Verification confirms data integrity
</success_criteria>
```

Claude must follow the exact command with no variation.
</example>
</low_freedom>

<matching_specificity>
The key is matching specificity to fragility:

- **Fragile operations** (database migrations, payment processing, security): Low freedom, exact instructions
- **Standard operations** (API calls, file processing, data transformation): Medium freedom, preferred pattern with flexibility
- **Creative operations** (code review, content generation, analysis): High freedom, heuristics and principles

Mismatched specificity causes problems:
- Too much freedom on fragile tasks → errors and failures
- Too little freedom on creative tasks → rigid, suboptimal outputs
</matching_specificity>
</degrees_of_freedom_principle>

<model_testing_principle>
<description>
Skills act as additions to models, so effectiveness depends on the underlying model. What works for Opus might need more detail for Haiku.
</description>

<testing_across_models>
| Model | Needs | Ask |
|-------|-------|-----|
| **Haiku** | Explicit instructions, complete examples, step-by-step workflows | Does it provide enough guidance? |
| **Sonnet** | Balanced detail, XML structure, progressive disclosure | Is it clear and efficient? |
| **Opus** | Concise instructions, principles over procedures, high freedom | Does it avoid over-explaining? |
</testing_across_models>

<balancing_across_models>
**Good balance** (works across all models):
```xml
<quick_start>
Use pdfplumber for text extraction:

```python
import pdfplumber
with pdfplumber.open("file.pdf") as pdf:
    text = pdf.pages[0].extract_text()
```

For scanned PDFs requiring OCR, use pdf2image with pytesseract instead.
</quick_start>
```
</balancing_across_models>

<iterative_improvement>
1. Start with medium detail level
2. Test with target models
3. Observe where models struggle or succeed
4. Adjust based on actual performance
5. Re-test and iterate

Don't optimize for one model. Find the balance that works across your target models.
</iterative_improvement>
</model_testing_principle>

<progressive_disclosure_principle>
<description>
SKILL.md serves as an overview. Reference files contain details. Claude loads reference files only when needed.
</description>

<token_efficiency>
Progressive disclosure keeps token usage proportional to task complexity:

- Simple task: Load SKILL.md only (~500 tokens)
- Medium task: Load SKILL.md + one reference (~1000 tokens)
- Complex task: Load SKILL.md + multiple references (~2000 tokens)

Without progressive disclosure, every task loads all content regardless of need.
</token_efficiency>

<implementation>
- Keep SKILL.md under 500 lines
- Split detailed content into reference files
- Keep references one level deep from SKILL.md
- Link to references from relevant sections
- Use descriptive reference file names

See [skill-structure.md](skill-structure.md) for progressive disclosure patterns.
</implementation>
</progressive_disclosure_principle>

<validation_principle>
<description>
Validation scripts are force multipliers. They catch errors that Claude might miss and provide actionable feedback.
</description>

<characteristics>
Good validation scripts:
- Provide verbose, specific error messages
- Show available valid options when something is invalid
- Pinpoint exact location of problems
- Suggest actionable fixes
- Are deterministic and reliable

See [workflows-and-validation.md](workflows-and-validation.md) for validation patterns.
</characteristics>
</validation_principle>

<principle_summary>
<xml_structure>
Use pure XML structure for consistency, parseability, and Claude performance. Required tags: objective, quick_start, success_criteria.
</xml_structure>

<conciseness>
Only add context Claude doesn't have. Assume Claude is smart. Challenge every piece of content.
</conciseness>

<degrees_of_freedom>
Match specificity to fragility. High freedom for creative tasks, low freedom for fragile operations, medium for standard work.
</degrees_of_freedom>

<model_testing>
Test with all target models. Balance detail level to work across Haiku, Sonnet, and Opus.
</model_testing>

<progressive_disclosure>
Keep SKILL.md concise. Split details into reference files. Load reference files only when needed.
</progressive_disclosure>

<validation>
Make validation scripts verbose and specific. Catch errors early with actionable feedback.
</validation>
</principle_summary>
