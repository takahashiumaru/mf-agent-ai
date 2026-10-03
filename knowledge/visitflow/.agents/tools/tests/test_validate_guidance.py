import importlib.util
import tempfile
import unittest
from unittest.mock import patch
import subprocess
from pathlib import Path

spec = importlib.util.spec_from_file_location('guidance', Path(__file__).parents[1] / 'validate_guidance.py')
guidance = importlib.util.module_from_spec(spec)
spec.loader.exec_module(guidance)


class GuidanceChecks(unittest.TestCase):
    def setUp(self):
        self.temp = tempfile.TemporaryDirectory()
        self.addCleanup(self.temp.cleanup)
        self.root = Path(self.temp.name)
        self.repo = self.root / 'service'
        (self.repo / '.agent').mkdir(parents=True)
        (self.repo / 'AGENTS.md').write_text('# Guide\n')
        (self.repo / '.agent/INDEX.md').write_text('# Index\n')
        (self.repo / 'Makefile').write_text('test:\n\tgo test ./...\n')

    def check(self):
        return guidance.check_repo(self.repo, self.root)

    def test_missing_link_and_anchor_are_reported(self):
        (self.repo / 'AGENTS.md').write_text('[missing](absent.md) [bad](.agent/INDEX.md#absent)')
        self.assertEqual(len(self.check().errors), 2)

    def test_external_links_not_fetched_and_fences_ignored(self):
        (self.repo / 'AGENTS.md').write_text('[web](https://example.invalid)\n```md\n[x](absent.md)\n```\n')
        self.assertEqual(self.check().errors, [])

    def test_command_table_checks_actual_make_target(self):
        (self.repo / '.agent/TESTING.md').write_text('| `make test` | yes |\n| `make missing` | no |\n')
        self.assertTrue(any('missing' in e for e in self.check().errors))

    def test_skills_require_frontmatter(self):
        skill = self.repo / '.agent/skills/demo/SKILL.md'
        skill.parent.mkdir(parents=True)
        skill.write_text('# Missing metadata\n')
        self.assertTrue(any('frontmatter' in e for e in self.check().errors))

    def test_link_outside_workspace_is_not_read(self):
        (self.repo / 'AGENTS.md').write_text('[outside](../../outside.md)')
        self.assertTrue(any('outside workspace' in e for e in self.check().errors))

    def test_missing_explicit_source_reference(self):
        (self.repo / '.agent/INDEX.md').write_text('Inspect `service/missing.go`.')
        self.assertTrue(any('service/missing.go' in e for e in self.check().errors))

    def test_word_budget_is_advisory(self):
        (self.repo / 'AGENTS.md').write_text('word ' * 2200)
        result = self.check()
        self.assertFalse(result.errors)
        self.assertTrue(result.warnings)

    def test_invalid_revision_never_reaches_git_diff(self):
        with patch.object(guidance.subprocess, 'run', return_value=subprocess.CompletedProcess([], 1, '', '')) as run:
            with self.assertRaises(ValueError):
                guidance.drift(self.repo, '--output=/tmp/unwanted')
            self.assertEqual(run.call_count, 1)
            self.assertEqual(run.call_args.args[0][:4], ['git', 'rev-parse', '--verify', '--end-of-options'])

    def test_routing_and_auth_changes_suggest_contract_review(self):
        for filename in ('configuration.json', 'main.go', 'auth/auth.go'):
            with self.subTest(filename=filename):
                outputs = [subprocess.CompletedProcess([], 0, filename + '\n', ''),
                           subprocess.CompletedProcess([], 0, '', '')]
                with patch.object(guidance.subprocess, 'run', side_effect=outputs):
                    review = guidance.drift(self.repo, None)
                self.assertIn('API.md', review)
                self.assertIn('FLOW_MAP.md', review)


if __name__ == '__main__':
    unittest.main()
