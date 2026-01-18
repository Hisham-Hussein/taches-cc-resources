#!/bin/bash
# validate-skill.sh - Validate a skill's structure and content
#
# Usage: ./validate-skill.sh <skill-directory>
# Example: ./validate-skill.sh ~/.claude/skills/my-skill

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Validate arguments
if [ -z "$1" ]; then
    echo -e "${RED}Error: Skill directory required${NC}"
    echo "Usage: $0 <skill-directory>"
    exit 1
fi

SKILL_DIR="$1"
SKILL_MD="$SKILL_DIR/SKILL.md"
ERRORS=0
WARNINGS=0

echo -e "${BLUE}Validating skill: $SKILL_DIR${NC}"
echo ""

# Check SKILL.md exists
if [ ! -f "$SKILL_MD" ]; then
    echo -e "${RED}[ERROR] SKILL.md not found${NC}"
    exit 1
fi

echo -e "${GREEN}[OK] SKILL.md found${NC}"

# Extract frontmatter (only the first block between --- markers)
# Get line number of second --- to avoid capturing YAML examples in body
FIRST_DASH=$(grep -n '^---$' "$SKILL_MD" | head -1 | cut -d: -f1)
SECOND_DASH=$(grep -n '^---$' "$SKILL_MD" | head -2 | tail -1 | cut -d: -f1)

if [ "$FIRST_DASH" != "1" ] || [ -z "$SECOND_DASH" ] || [ "$FIRST_DASH" = "$SECOND_DASH" ]; then
    FRONTMATTER=""
else
    FRONTMATTER=$(sed -n "2,$((SECOND_DASH-1))p" "$SKILL_MD")
fi

if [ -z "$FRONTMATTER" ]; then
    echo -e "${RED}[ERROR] No YAML frontmatter found (must be between --- markers)${NC}"
    ERRORS=$((ERRORS + 1))
else
    echo -e "${GREEN}[OK] YAML frontmatter present${NC}"

    # Check required fields
    NAME=$(echo "$FRONTMATTER" | grep -E "^name:" | sed 's/name:[[:space:]]*//')
    DESCRIPTION=$(echo "$FRONTMATTER" | grep -E "^description:" | sed 's/description:[[:space:]]*//')

    if [ -z "$NAME" ]; then
        echo -e "${RED}[ERROR] Missing 'name' field in frontmatter${NC}"
        ERRORS=$((ERRORS + 1))
    else
        echo -e "${GREEN}[OK] name: $NAME${NC}"

        # Validate name format
        if ! echo "$NAME" | grep -qE '^[a-z][a-z0-9-]*[a-z0-9]$'; then
            echo -e "${RED}[ERROR] Name must be lowercase with hyphens (e.g., my-skill-name)${NC}"
            ERRORS=$((ERRORS + 1))
        fi

        # Check name length
        if [ ${#NAME} -gt 64 ]; then
            echo -e "${RED}[ERROR] Name too long (max 64 characters)${NC}"
            ERRORS=$((ERRORS + 1))
        fi

        # Check name matches directory
        DIR_NAME=$(basename "$SKILL_DIR")
        if [ "$NAME" != "$DIR_NAME" ]; then
            echo -e "${YELLOW}[WARNING] Skill name '$NAME' doesn't match directory '$DIR_NAME'${NC}"
            WARNINGS=$((WARNINGS + 1))
        fi
    fi

    if [ -z "$DESCRIPTION" ]; then
        echo -e "${RED}[ERROR] Missing 'description' field in frontmatter${NC}"
        ERRORS=$((ERRORS + 1))
    else
        DESC_LENGTH=${#DESCRIPTION}
        echo -e "${GREEN}[OK] description present ($DESC_LENGTH chars)${NC}"

        # Check description length
        if [ $DESC_LENGTH -gt 1024 ]; then
            echo -e "${RED}[ERROR] Description too long (max 1024 characters, got $DESC_LENGTH)${NC}"
            ERRORS=$((ERRORS + 1))
        fi

        # Check for angle brackets
        if echo "$DESCRIPTION" | grep -q '[<>]'; then
            echo -e "${RED}[ERROR] Description contains angle brackets (< or >)${NC}"
            ERRORS=$((ERRORS + 1))
        fi

        # CSO check: description should not summarize workflow
        if echo "$DESCRIPTION" | grep -qiE "(step|then|first|next|after|before|process|workflow|procedure)"; then
            echo -e "${YELLOW}[WARNING] Description may contain workflow summary (CSO trap)${NC}"
            echo "          Description should only contain WHEN to use, not HOW it works"
            WARNINGS=$((WARNINGS + 1))
        fi

        # Check for trigger phrases
        if ! echo "$DESCRIPTION" | grep -qiE "(use when|should be used|trigger|ask to|asks to|mentions)"; then
            echo -e "${YELLOW}[WARNING] Description may lack trigger phrases${NC}"
            echo "          Consider adding: 'Use when...' or 'should be used when...'"
            WARNINGS=$((WARNINGS + 1))
        fi
    fi
fi

# Check body content
BODY=$(sed '1,/^---$/d' "$SKILL_MD" | sed '1,/^---$/d')
BODY_LINES=$(echo "$BODY" | wc -l)
BODY_WORDS=$(echo "$BODY" | wc -w)

echo ""
echo -e "${BLUE}Body analysis:${NC}"
echo "  Lines: $BODY_LINES"
echo "  Words: $BODY_WORDS"

if [ $BODY_LINES -gt 500 ]; then
    echo -e "${YELLOW}[WARNING] SKILL.md body exceeds 500 lines ($BODY_LINES lines)${NC}"
    echo "          Consider moving detailed content to references/"
    WARNINGS=$((WARNINGS + 1))
fi

# Check for markdown headings in body (should use XML tags instead)
if echo "$BODY" | grep -qE "^#+[[:space:]]"; then
    # Count markdown headings
    MD_HEADINGS=$(echo "$BODY" | grep -cE "^#+[[:space:]]" || true)
    if [ "$MD_HEADINGS" -gt 5 ]; then
        echo -e "${YELLOW}[WARNING] Body contains $MD_HEADINGS markdown headings${NC}"
        echo "          Consider using XML tags for structure: <section>, <process>, etc."
        WARNINGS=$((WARNINGS + 1))
    fi
fi

# Check for required XML tags
echo ""
echo -e "${BLUE}XML structure check:${NC}"

for tag in objective quick_start success_criteria; do
    if echo "$BODY" | grep -q "<$tag>"; then
        echo -e "${GREEN}[OK] <$tag> tag found${NC}"
    else
        echo -e "${YELLOW}[WARNING] Missing <$tag> tag${NC}"
        WARNINGS=$((WARNINGS + 1))
    fi
done

# Check referenced files exist
echo ""
echo -e "${BLUE}Reference file check:${NC}"

# Find referenced files in body
REFS=$(echo "$BODY" | grep -oE 'references/[a-zA-Z0-9_-]+\.md' | sort -u || true)
WORKFLOWS=$(echo "$BODY" | grep -oE 'workflows/[a-zA-Z0-9_-]+\.md' | sort -u || true)

for ref in $REFS; do
    if [ -f "$SKILL_DIR/$ref" ]; then
        echo -e "${GREEN}[OK] $ref exists${NC}"
    else
        echo -e "${RED}[ERROR] Referenced file not found: $ref${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done

for wf in $WORKFLOWS; do
    if [ -f "$SKILL_DIR/$wf" ]; then
        echo -e "${GREEN}[OK] $wf exists${NC}"
    else
        echo -e "${RED}[ERROR] Referenced workflow not found: $wf${NC}"
        ERRORS=$((ERRORS + 1))
    fi
done

# Summary
echo ""
echo "========================================="
if [ $ERRORS -eq 0 ] && [ $WARNINGS -eq 0 ]; then
    echo -e "${GREEN}VALID: No errors or warnings${NC}"
    exit 0
elif [ $ERRORS -eq 0 ]; then
    echo -e "${YELLOW}VALID with $WARNINGS warning(s)${NC}"
    exit 0
else
    echo -e "${RED}INVALID: $ERRORS error(s), $WARNINGS warning(s)${NC}"
    exit 1
fi
