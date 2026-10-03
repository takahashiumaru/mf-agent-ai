#!/usr/bin/env python3
"""Read-only checks for active VisitFlow agent guidance (standard library only)."""
import argparse
import json
import re
import subprocess
from pathlib import Path
from urllib.parse import unquote, urlsplit

REPOS = ('visit-flow-go', 'visit-flow-api-gateway', 'visit-flow-payroll',
         'visit-flow-presence', 'visit-flow-survey-location-go')
HISTORICAL = {'CHANGELOG.md', 'DATABASE_SCHEMA.md'}


class Result:
    def __init__(self):
        self.errors = []
        self.warnings = []
        self.files = 0
        self.links = 0
        self.startup_words = 0


def prose(text):
    # Fenced examples are not active navigation or executable command declarations.
    return re.sub(r'^\s*(`{3,}|~{3,})[^\n]*\n.*?^\s*\1\s*$', '', text,
                  flags=re.M | re.S)


def anchors(text):
    found, counts = set(), {}
    for heading in re.findall(r'^#{1,6}\s+(.+?)\s*#*$', prose(text), re.M):
        slug = re.sub(r'[^\w\- ]', '', heading.lower()).replace(' ', '-')
        n = counts.get(slug, 0)
        counts[slug] = n + 1
        found.add(slug if not n else f'{slug}-{n}')
    return found


def check_repo(repo, workspace):
    repo, workspace = repo.resolve(), workspace.resolve()
    result = Result()
    required = [repo / 'AGENTS.md', repo / '.agent/INDEX.md']
    for path in required:
        if not path.is_file():
            result.errors.append(f'missing entry point: {path.name}')
        else:
            result.startup_words += len(path.read_text().split())
    if result.startup_words > 2000:
        result.warnings.append('AGENTS + INDEX exceed 2000 words; review duplication, retain safety rules')
    paths = set(required + [repo / 'CLAUDE.md'])
    paths.update((repo / '.agent').rglob('*.md'))
    makefile = repo / 'Makefile'
    targets = set(re.findall(r'^([\w-]+)\s*:', makefile.read_text(), re.M)) if makefile.exists() else set()

    def resolve(source, reference, base):
        path = (base / unquote(reference)).resolve()
        if not path.is_relative_to(workspace):
            result.errors.append(f'{source.relative_to(repo)}: reference outside workspace: {reference}')
            return None
        if not path.exists():
            result.errors.append(f'{source.relative_to(repo)}: missing reference: {reference}')
            return None
        return path

    for source in sorted(paths):
        if not source.is_file() or source.name in HISTORICAL:
            continue
        text = source.read_text()
        body = prose(text)
        result.files += 1
        if source.name == 'SKILL.md':
            front = re.match(r'\A---\n(.*?)\n---(?:\n|$)', text, re.S)
            if not front or not all(re.search(rf'^{key}:\s*\S', front.group(1), re.M)
                                    for key in ('name', 'description')):
                result.errors.append(f'{source.relative_to(repo)}: missing skill frontmatter name/description')
        for target in re.findall(r'\[[^\]]*\]\(([^\s)]+)\)', body):
            parsed = urlsplit(target.strip('<>'))
            if parsed.scheme or parsed.netloc:
                continue
            result.links += 1
            dest = resolve(source, parsed.path, source.parent) if parsed.path else source
            if dest and parsed.fragment and dest.suffix == '.md':
                if unquote(parsed.fragment) not in anchors(dest.read_text()):
                    result.errors.append(f'{source.relative_to(repo)}: missing anchor: {target}')
        for ref in re.findall(r'`([^`\n]+)`', body):
            bare = ref.split('#')[0]
            if any(c in bare for c in '*<> '):
                continue
            if re.match(r'^(?:route|controller|service|repository|test|helper|app|model)/.+\.go$', bare):
                resolve(source, bare, repo)
            elif bare.startswith('../') and bare.endswith(('.md', '.go')):
                resolve(source, bare, source.parent)
        if source.name == 'TESTING.md':
            for line in body.splitlines():
                if line.lstrip().startswith('|'):
                    for target in re.findall(r'`make ([\w-]+)`', line):
                        if target not in targets:
                            result.errors.append(f'.agent/TESTING.md: Makefile target missing: {target}')
    return result


def drift(repo, since):
    """Advisory filenames only. Does not imply a document is stale or reviewed."""
    if since:
        resolved = subprocess.run(['git', 'rev-parse', '--verify', '--end-of-options', since + '^{commit}'],
                                  cwd=repo, capture_output=True, text=True)
        if resolved.returncode or not re.fullmatch(r'[0-9a-f]{40,64}', resolved.stdout.strip()):
            raise ValueError('invalid commit revision for --since')
        since = resolved.stdout.strip()
    commands = [['git', 'diff', '--name-only', '--diff-filter=ACDMRT', since, '--']] if since else [
        ['git', 'diff', 'HEAD', '--name-only', '--diff-filter=ACDMRT', '--'],
        ['git', 'ls-files', '--others', '--exclude-standard']]
    paths = set()
    for command in commands:
        completed = subprocess.run(command, cwd=repo, capture_output=True, text=True)
        if completed.returncode:
            raise ValueError('unable to read git changes; verify repository/ref')
        paths.update(completed.stdout.splitlines())
    review = set()
    for path in paths:
        if path.startswith(('route/', 'controller/', 'model/web/', 'auth/')) or path in ('configuration.json', 'main.go', 'app/router.go'):
            review.update(('API.md', 'FLOW_MAP.md'))
        if path.startswith(('service/', 'repository/', 'model/domain/')):
            review.update(('PREFERRED_PATTERNS.md', 'FLOW_MAP.md'))
        if path.startswith(('test/', 'auth/')) or path.endswith('_test.go'):
            review.add('TESTING.md')
        if path in ('Makefile', 'go.mod', '.gitlab-ci.yml'):
            review.add('TESTING.md')
    return sorted(review)


def main():
    parser = argparse.ArgumentParser(description=__doc__)
    parser.add_argument('--repo', action='append', choices=REPOS, help='repeat for selected repos; default all five')
    parser.add_argument('--json', action='store_true', help='full machine-readable findings')
    parser.add_argument('--drift', action='store_true', help='suggest docs to review for git changes; advisory only')
    parser.add_argument('--since', help='with --drift: compare a revision to working tree')
    args = parser.parse_args()
    if args.since and not args.drift:
        parser.error('--since requires --drift')
    workspace = Path(__file__).resolve().parents[2]
    rows = {}
    for name in args.repo or REPOS:
        repo = workspace / name
        result = check_repo(repo, workspace)
        row = vars(result).copy()
        if args.drift:
            try:
                row['review_candidates'] = drift(repo, args.since)
            except ValueError as error:
                result.errors.append(str(error))
        rows[name] = row
    if args.json:
        print(json.dumps(rows, indent=2))
    else:
        for name, row in rows.items():
            print(f"{name}: {len(row['errors'])} errors, {len(row['warnings'])} warnings; "
                  f"{row['files']} docs, {row['links']} links, {row['startup_words']} startup words")
            for item in (row['errors'] + row['warnings'])[:12]:
                print('  ' + item)
            if len(row['errors']) + len(row['warnings']) > 12:
                print('  More findings: use --json')
            if row.get('review_candidates'):
                print('  Review candidates (not proof of drift): ' + ', '.join(row['review_candidates']))
    return int(any(row['errors'] for row in rows.values()))


if __name__ == '__main__':
    raise SystemExit(main())
