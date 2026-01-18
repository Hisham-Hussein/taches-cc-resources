#!/bin/bash
# package-skill.sh - Package a skill into a distributable .skill file
#
# Usage: ./package-skill.sh <skill-directory> [output-directory]
# Example: ./package-skill.sh ~/.claude/skills/my-skill ./dist
#
# Creates a .skill file (ZIP format) containing the complete skill

set -e

# Colors for output
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Get script directory for relative paths
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

# Validate arguments
if [ -z "$1" ]; then
    echo -e "${RED}Error: Skill directory required${NC}"
    echo "Usage: $0 <skill-directory> [output-directory]"
    exit 1
fi

SKILL_DIR="$1"
OUTPUT_DIR="${2:-.}"
SKILL_NAME=$(basename "$SKILL_DIR")
SKILL_FILE="$OUTPUT_DIR/$SKILL_NAME.skill"

# Check skill directory exists
if [ ! -d "$SKILL_DIR" ]; then
    echo -e "${RED}Error: Directory not found: $SKILL_DIR${NC}"
    exit 1
fi

# Check SKILL.md exists
if [ ! -f "$SKILL_DIR/SKILL.md" ]; then
    echo -e "${RED}Error: SKILL.md not found in $SKILL_DIR${NC}"
    exit 1
fi

echo -e "${BLUE}Packaging skill: $SKILL_NAME${NC}"
echo ""

# Run validation first
echo -e "${YELLOW}Running validation...${NC}"
if [ -f "$SCRIPT_DIR/validate-skill.sh" ]; then
    if ! "$SCRIPT_DIR/validate-skill.sh" "$SKILL_DIR"; then
        echo ""
        echo -e "${RED}Validation failed. Fix errors before packaging.${NC}"
        exit 1
    fi
else
    echo -e "${YELLOW}Warning: validate-skill.sh not found, skipping validation${NC}"
fi

echo ""
echo -e "${BLUE}Creating package...${NC}"

# Create output directory if needed
mkdir -p "$OUTPUT_DIR"

# Remove existing package if present
if [ -f "$SKILL_FILE" ]; then
    rm "$SKILL_FILE"
fi

# Create ZIP (which becomes .skill)
cd "$(dirname "$SKILL_DIR")"
zip -r "$SKILL_FILE" "$SKILL_NAME" -x "*.DS_Store" -x "*__pycache__*" -x "*.pyc" -x "*.git*"
cd - > /dev/null

# Verify the package
if [ -f "$SKILL_FILE" ]; then
    SIZE=$(du -h "$SKILL_FILE" | cut -f1)
    echo ""
    echo -e "${GREEN}Package created successfully!${NC}"
    echo ""
    echo "Output: $SKILL_FILE"
    echo "Size: $SIZE"
    echo ""
    echo "Contents:"
    unzip -l "$SKILL_FILE" | tail -n +4 | head -n -2
    echo ""
    echo -e "${YELLOW}Distribution:${NC}"
    echo "The .skill file can be shared and installed by users."
    echo "To install: unzip $SKILL_NAME.skill -d ~/.claude/skills/"
else
    echo -e "${RED}Error: Failed to create package${NC}"
    exit 1
fi
