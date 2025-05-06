# Rioze.dev Repository

This repository contains site contents for [rioze.dev](https://rioze.dev)

## Repository Structure

- `/posts/`: Contains all blog posts organized in folders by slug
  - Each post folder contains multiple language versions (e.g., `en.md`, `id.md`)
- `/i18n/`: Contains translation files for UI elements
- `/index.json`: Aggregated metadata from all blog posts
- Script: A bash script that extracts metadata from posts and generates the index.json file

## How It Works

### Blog Posts

Blog posts are organized in folders within the `posts/` directory. Each post has its own folder named after the post slug, and contains multiple language versions of the same post.

For example, a post with slug "my-blog-post" would have the following structure:

```
/posts/my-blog-post/
  ├── en.md
  ├── id.md
  └── fr.md
```

Each post file must include frontmatter metadata at the beginning:

```markdown
---
title: "My Blog Post Title"
date: "2023-06-15"
tags: ["javascript", "react", "tutorial"]
description: "A short description of the blog post"
---

Content of the blog post goes here...
```

### Translations

The `/i18n/` directory contains JSON files for translating UI elements on the site. Each language has its own file named with the appropriate language code (e.g., `en.json`, `es.json`, `fr.json`).

### Metadata Aggregation

The repository includes a bash script that:

1. Scans all post folders in the `posts/` directory
2. For each post, collects metadata from all language versions
3. Compiles this metadata into `index.json` at the root level
4. This index.json file is then used by the blog website to render the post listing with multilingual support

## Contributing

This is a personal project, but contributions are welcome:

- Found an issue? Feel free to open an issue on GitHub
- Want to make a correction? Pull requests are welcome

## License

Rioze (c) all rights reserved.
