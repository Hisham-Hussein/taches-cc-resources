<variables_pattern>

## Variables Section

Add a variables section to control skill behavior without editing content:

```markdown
<variables>
enable_feature_a: true
enable_feature_b: false
default_model: sonnet
fast_model: haiku
heavy_model: opus
</variables>
```

### Routing with Variables

```markdown
<routing>
If user requests feature A AND enable_feature_a is true:
  → Read workflows/feature-a.md
</routing>
```

### Use Cases

- **Feature flags** for experimental features
- **Model selection** per use case
- **Environment-specific behavior** (dev vs prod)
- **User preference toggles**

### Example: Multi-Environment Skill

```markdown
<variables>
target_environment: production
enable_dry_run: true
verbose_logging: false
</variables>

<routing>
If target_environment is "production" AND enable_dry_run is true:
  → Load workflows/production-dry-run.md

If target_environment is "production" AND enable_dry_run is false:
  → Load workflows/production-live.md

If target_environment is "staging":
  → Load workflows/staging.md
</routing>
```

### Best Practices

1. **Default to safe values**: `enable_destructive: false`
2. **Use descriptive names**: `enable_auto_commit` not `flag1`
3. **Document each variable**: What it controls and valid values
4. **Keep variables minimal**: Only add what you actually need to toggle

</variables_pattern>
