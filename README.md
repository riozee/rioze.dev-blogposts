# Rioze.dev Blog Posts Repository

This repository contains markdown files used as content for [rioze.dev/blog](https://rioze.dev/blog)

## Repository Structure

- `/posts/`: Contains all blog post markdown files
- `/index.json`: Aggregated metadata from all blog posts
- Script: A bash script that extracts metadata from posts and generates the index.json file

## How It Works

### Blog Posts

All blog posts are stored as markdown files in the `posts/` directory. Each post must include frontmatter metadata at the beginning of the file, for example:

```markdown
---
title: "My Blog Post Title"
date: "2023-06-15"
tags: ["javascript", "react", "tutorial"]
description: "A short description of the blog post"
---

Content of the blog post goes here...
```

### Metadata Aggregation

The repository includes a bash script that:

1. Scans all markdown files in the `posts/` directory
2. Extracts the frontmatter metadata
3. Compiles this metadata into `index.json` at the root level
4. This index.json file is then used by the blog website to render the post listing

## Contributing

This is a personal project, but contributions are welcome:

- Found an issue? Feel free to open an issue on GitHub
- Want to make a correction? Pull requests are welcome

## License

Rioze (c) all rights reserved.
