## Pull Request Template - dbt_fullstory DBT Package

Thank you for contributing to `dbt_fullstory`  Please fill out this template to help us review your changes efficiently.

---

**1. Related Issue(s)**

*   Linked Issue(s):  #[Issue Number] (e.g., #123)  *or*  N/A
    *   If this PR closes an issue, use `Closes #[Issue Number]`
    *   If this PR addresses part of an issue, use `Addresses #[Issue Number]`
    *   If it's related but doesn't close/address, use `Related to #[Issue Number]`
    *   If there is no related issue, write `N/A`.  Consider opening an issue *before* creating a large PR.

**2. Description of Changes**

*   **Purpose:** Briefly (1-2 sentences) describe the *why* behind this PR. What problem does it solve, or what feature does it add?  Focus on the *user-facing* impact.
*   **Implementation Details:**  Provide a concise, *technical* overview of *how* you implemented the changes.  This should be more detailed than the "Purpose" section, but avoid pasting large code blocks.  Mention specific files changed, key functions, and any relevant DBT concepts used (e.g., "Added a new macro to better handle incremental loads," "Refactored the `parse_json_into_columns` macro," "Added a test for date spine functionality.").  If the change is complex, link to relevant documentation or design discussions.
*   **Breaking Changes:**  Yes/No.  *If Yes*, clearly explain:
    *   What is the breaking change?
    *   What is the impact on existing users?  How will they need to update their code?
    *   Why was the breaking change necessary?
    *   *Crucially*, if there's a breaking change, have you updated the relevant parts of `CHANGELOG.md`?

**3. Type of Change**

Please check all that apply:

*   [ ] Bug fix (non-breaking change which fixes an issue)
*   [ ] New feature (non-breaking change which adds functionality)
*   [ ] Breaking change (fix or feature that would cause existing functionality to change)
*   [ ] Documentation update
*   [ ] Code style update (formatting, renaming)
*   [ ] Refactoring (no functional changes, no api changes)
*   [ ] Build related changes
*   [ ] CI related changes
*   [ ] Performance improvement
*   [ ] Other (please describe):

**4. Testing**

*   **Tests Added:**  Yes/No.  *If Yes*, briefly describe the tests you added (e.g., "Added unit tests for the new `xyz` macro," "Added integration tests to verify behavior with Snowflake").  Mention the *type* of test (unit, integration, etc.).
*   **Test Coverage:** (Optional, but highly encouraged)  Did you check test coverage?  If so, what is the new coverage percentage (approximately)?  This shows diligence.  Tools like the `dbt_project_evaluator` package can help with this.
*   **Manual Testing:** (Optional, but encouraged if applicable). Describe any manual testing you performed, including:
    *   DBT version(s) tested.
    *   Data warehouse(s) tested (e.g., Snowflake, BigQuery, Redshift, Postgres).
    *   Specific commands run and their results.
    *   Any edge cases considered.
*   **Existing Tests:** Do all existing tests still pass? Yes/No

**5. Checklist**

*   [ ] I have read the [CONTRIBUTING.md](link-to-your-contributing-guidelines) document.
*   [ ] My code follows the style guidelines of this project.  (Mention specific linters or style guides if applicable).
*   [ ] I have performed a self-review of my own code.
*   [ ] I have commented my code, particularly in hard-to-understand areas.
*   [ ] I have made corresponding changes to the documentation (if applicable).
*   [ ] My changes generate no new warnings.
*   [ ] I have added tests that prove my fix is effective or that my feature works.
*   [ ] New and existing unit tests pass locally with my changes.
*   [ ] Any dependent changes have been merged and published in downstream modules.
*   [ ] I have updated the `CHANGELOG.md` file. *Especially important for breaking changes*.
