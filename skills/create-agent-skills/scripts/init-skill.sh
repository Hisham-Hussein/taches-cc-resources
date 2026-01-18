#!/bin/bash
# init-skill.sh - Initialize a new skill with proper structure
#
# Usage: ./init-skill.sh <skill-name> [output-directory]
# Example: ./init-skill.sh my-new-skill ~/.claude/skills/

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
NC='\033[0m' # No Color

# Validate arguments
if [ -z "$1" ]; then
    echo -e "${RED}Error: Skill name required${NC}"
    echo "Usage: $0 <skill-name> [output-directory]"
    echo "Example: $0 my-new-skill ~/.claude/skills/"
    exit 1
fi

SKILL_NAME="$1"
OUTPUT_DIR="${2:-.}"

# Validate skill name format (lowercase, hyphens, numbers only)
if ! echo "$SKILL_NAME" | grep -qE '^[a-z][a-z0-9-]*[a-z0-9]$'; then
    echo -e "${RED}Error: Invalid skill name format${NC}"
    echo "Skill name must:"
    echo "  - Start with a lowercase letter"
    echo "  - Contain only lowercase letters, numbers, and hyphens"
    echo "  - End with a letter or number"
    echo "  - Be at least 2 characters long"
    exit 1
fi

# Check name length
if [ ${#SKILL_NAME} -gt 64 ]; then
    echo -e "${RED}Error: Skill name too long (max 64 characters)${NC}"
    exit 1
fi

# Convert hyphen-case to Title Case for display
SKILL_TITLE=$(echo "$SKILL_NAME" | sed 's/-/ /g' | awk '{for(i=1;i<=NF;i++) $i=toupper(substr($i,1,1)) tolower(substr($i,2))}1')

# Create skill directory
SKILL_PATH="$OUTPUT_DIR/$SKILL_NAME"

if [ -d "$SKILL_PATH" ]; then
    echo -e "${RED}Error: Directory already exists: $SKILL_PATH${NC}"
    exit 1
fi

echo -e "${GREEN}Creating skill: $SKILL_NAME${NC}"
echo "Location: $SKILL_PATH"
echo ""

# Create directory structure
mkdir -p "$SKILL_PATH"
mkdir -p "$SKILL_PATH/references"
mkdir -p "$SKILL_PATH/workflows"

# Create SKILL.md template
cat > "$SKILL_PATH/SKILL.md" << 'SKILLEOF'
---
name: SKILL_NAME_PLACEHOLDER
description: TODO - Describe what this skill does AND when to use it (third person). Include specific trigger phrases. Example: "This skill should be used when the user asks to 'create X', 'build Y', or mentions Z."
---

<objective>
TODO: Clear statement of what this skill accomplishes and why it exists.
</objective>

<quick_start>
TODO: Immediate actionable guidance (1-3 steps to get started).
</quick_start>

<process>
## Step 1: TODO
First action...

## Step 2: TODO
Second action...

## Step 3: TODO
Third action...
</process>

<success_criteria>
- [ ] TODO: First criterion
- [ ] TODO: Second criterion
- [ ] TODO: Third criterion
</success_criteria>

<reference_index>
## References

All in `references/`:

- **`example-reference.md`** - TODO: Description
</reference_index>
SKILLEOF

# Replace placeholder with actual skill name
sed -i "s/SKILL_NAME_PLACEHOLDER/$SKILL_NAME/g" "$SKILL_PATH/SKILL.md"

# Create example reference file
cat > "$SKILL_PATH/references/example-reference.md" << 'REFEOF'
<reference_overview>
# Example Reference

This is an example reference file. References contain domain knowledge that Claude reads on-demand.

Delete this file or replace with your actual reference content.
</reference_overview>

<example_content>
## Sample Content

- Key point 1
- Key point 2
- Key point 3
</example_content>
REFEOF

echo -e "${GREEN}Skill created successfully!${NC}"
echo ""
echo "Structure:"
echo "  $SKILL_PATH/"
echo "  ├── SKILL.md (main skill file - edit this)"
echo "  ├── references/"
echo "  │   └── example-reference.md (sample - replace or delete)"
echo "  └── workflows/ (add workflow files here if needed)"
echo ""
echo -e "${YELLOW}Next steps:${NC}"
echo "1. Edit SKILL.md - fill in the TODO sections"
echo "2. Write a clear description with trigger phrases"
echo "3. Add references/ files for detailed domain knowledge"
echo "4. Add workflows/ files for complex multi-path skills"
echo "5. Run validate-skill.sh to check your skill"
echo "6. Test with a real invocation"
