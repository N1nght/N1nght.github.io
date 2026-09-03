# Homepage changelog

## 2026-09-03

### GitHub Pages build compatibility

- Added `_data/publications.yml` as a fallback for GitHub Pages safe builds, which do not load custom Jekyll plugins.
- Normal Jekyll builds continue to refresh publication data directly from `My-paper.bib` through `_plugins/bibtex_publications.rb`.

### Profile and navigation

- Updated the homepage introduction in `_pages/about.md` to present Jianing Cao as a PhD student in the School of Transportation at Southeast University.
- Added News, Publications, and Working Papers navigation entries.
- Working Papers is currently hidden from the main navigation; its page remains available at `/working-papers/`.

### News module

- Added the `_news/` collection as the source folder for news items.
- Added `/news/` for the five most recent items and `/news/archive/` for the complete archive.
- News is sorted by date in descending order.
- Added a date/content table to the homepage and News pages.
- News tables use normal body text sizing, fixed 20%/80% date-content columns, and preserve inline emphasis such as italics.

### Publications

- Replaced the template's sample publication entries with Jianing Cao's current bibliography.
- Publications and Working Papers are rendered as numbered reference lists sorted by year.
- DOI links are labeled `Read Online`.
- Removed journal-ranking and other note text from displayed references.
- The homepage Selected Publication section shows the two published papers for which Jianing Cao is first author.

### BibTeX-driven updates

- `My-paper.bib` is now the single source of publication data.
- Added `_plugins/bibtex_publications.rb`, which parses the BibTeX file during every Jekyll build and supplies data to all publication views.
- Add `keywords = {working}` to a BibTeX entry to place it on the Working Papers page; entries without that keyword are treated as published articles.
- `My-paper.bib` is excluded from the generated website and is kept for local maintenance.

### Cleanup

- Removed the original Academic Pages sample publication files.
- Excluded the source CV DOCX from the generated website.
