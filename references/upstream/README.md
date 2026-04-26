# Upstream References

This directory stores snapshots from the two source repositories used to design this dev-kit.

These files are reference material only. They are not installed by `scripts/install.sh` or `scripts/install.ps1`.

## Sources

- `superpowers/`: snapshot from `https://github.com/obra/superpowers.git`
- `ai-devkit/`: snapshot from `https://github.com/codeaholicguy/ai-devkit.git`

Each source directory includes `SOURCE.md` with the synced commit and timestamp.

## Sync

Refresh the snapshots:

```bash
./scripts/sync-upstream-references.sh
```

The sync script requires `git` and `rsync`. It clones each upstream repo into a temp directory and copies only skill, command, workflow, prompt, and plugin-reference files into `references/upstream/`.

## Offline Install Boundary

The main dev-kit installers remain offline. They do not fetch from this directory dynamically, and they do not contact the network.

Reference snapshots are committed so future work can inspect upstream patterns without relying on GitHub availability.
