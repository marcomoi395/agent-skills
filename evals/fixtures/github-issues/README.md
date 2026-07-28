# GitHub Issues Eval Fixture

This fixture contains a simple authentication module with a documented bug for testing the `github-issues` skill.

## Known Issue

The `authenticateUser` function in `auth.js` has a hardcoded timeout of 5 seconds that should respect the `API_TIMEOUT` constant (30 seconds). This causes authentication to fail for users on slower connections.

## Expected Behavior

When asked to create an issue for this bug, the agent should:
1. Use the `gh api` command to create the issue (not MCP tools, which don't support issue creation)
2. Set the issue type to "Bug" using `-f type="Bug"`
3. Structure the issue body with:
   - Description of the problem
   - Steps to reproduce
   - Expected vs actual behavior
4. Report the created issue URL
