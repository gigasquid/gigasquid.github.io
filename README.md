# Squid's Blog

A personal blog built with [Hugo](https://gohugo.io/) and the [PaperMod](https://github.com/adityatelange/hugo-PaperMod) theme, deployed to GitHub Pages at [gigasquidsoftware.com](https://gigasquidsoftware.com).

## Prerequisites

Install Hugo (extended edition):

```bash
brew install hugo
```

## Local Development

Start the dev server with live reload:

```bash
hugo server -D
```

The site will be available at http://localhost:1313. Changes to content and templates are reflected immediately.

## Creating a New Post

```bash
hugo new content posts/YYYY-MM-DD-your-post-title.markdown
```

For example:

```bash
hugo new content posts/2026-04-18-my-new-post.markdown
```

This creates a file in `content/posts/` with default frontmatter. Edit the frontmatter as needed:

```yaml
---
title: "My New Post"
date: 2026-04-18T10:00:00
draft: false
categories:
- Clojure
---

Your content here.
```

Set `draft: true` to preview locally without publishing. Draft posts are visible with `hugo server -D` but excluded from production builds.

### Embedding Images

Local images go in `static/images/`. Reference them in posts:

```markdown
![Alt text](/images/my-image.png)
```

For images with captions or alignment:

```
{{< figure src="/images/my-image.png" title="Caption" class="left" >}}
```

### Embedding YouTube Videos

```
{{< youtube VIDEO_ID >}}
```

### Embedding GitHub Gists

```
{{< gist USERNAME GIST_ID >}}
```

### Code Blocks

Use fenced code blocks with a language identifier:

````
```clojure
(defn hello [name]
  (println "Hello," name))
```
````

## Building the Site

Generate the production site into `public/`:

```bash
hugo
```

To build with minification:

```bash
hugo --minify
```

## Deployment

The site is deployed by building locally and pushing the output to the `master` branch, which GitHub Pages serves.

```bash
./deploy.sh
```

This script:
1. Builds the site with `hugo --minify`
2. Copies the output to the `_deploy/` directory (which tracks the `master` branch)
3. Commits and pushes to `master`

Blog source files live on the `source` branch. The `master` branch contains only the built site.

### GitHub Pages Setup

In your repository settings, set the Pages source to **Deploy from a branch** with branch set to `master`. The `static/CNAME` file maps the site to the custom domain `gigasquidsoftware.com`.

## Project Structure

```
content/
  posts/          # Blog posts
  about/          # About page
  books/          # Books page
  speaking/       # Speaking page
  archives.md     # Archives page
static/
  images/         # Images and other static files
  CNAME           # Custom domain config
  favicon.png
layouts/
  _default/
    list.html     # Custom home page (shows latest post in full)
themes/
  PaperMod/       # Theme (git submodule)
hugo.toml         # Site configuration
```

## Configuration

Site settings are in `hugo.toml`. Key options:

- `paginate`: Number of posts per page on the index (default: 10)
- `[permalinks]`: URL structure (`/blog/:year/:month/:day/:title/`)
- `[[menu.main]]`: Navigation menu items
- `[markup.highlight]`: Code syntax highlighting style
- `[services.disqus]`: Disqus comments configuration
