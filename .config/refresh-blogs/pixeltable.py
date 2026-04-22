#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["beautifulsoup4", "feedgen", "lxml", "requests"]
# ///
"""Build an RSS feed for https://www.pixeltable.com/blog using the sitemap.

The blog is fully client-rendered, so we pull post URLs and dates from the
sitemap and fetch each post page for its og:title.  Only the most recent
posts are included to avoid excessive requests.
"""

import sys
from datetime import datetime

import requests
from bs4 import BeautifulSoup
from feedgen.feed import FeedGenerator

SITEMAP_URL = "https://www.pixeltable.com/sitemap.xml"
BLOG_URL = "https://www.pixeltable.com/blog"
MAX_POSTS = 20
TITLE_SUFFIX = " - Pixeltable Blog"


def main(output: str) -> None:
    resp = requests.get(SITEMAP_URL, timeout=30)
    resp.raise_for_status()
    soup = BeautifulSoup(resp.text, "xml")

    # collect blog post URLs with dates, sorted newest first
    posts = []
    for url_el in soup.find_all("url"):
        loc = url_el.find("loc").text
        if "/blog/" not in loc or loc.rstrip("/") == "https://pixeltable.com/blog":
            continue
        lastmod = url_el.find("lastmod")
        date_str = lastmod.text if lastmod else ""
        posts.append((loc, date_str))

    posts.sort(key=lambda p: p[1], reverse=True)
    posts = posts[:MAX_POSTS]

    fg = FeedGenerator()
    fg.title("Pixeltable Blog")
    fg.link(href=BLOG_URL)
    fg.description("Pixeltable Blog")

    for url, date_str in posts:
        # fetch the post page for its title
        title = None
        try:
            r = requests.get(url, timeout=30)
            r.raise_for_status()
            page = BeautifulSoup(r.text, "html.parser")
            og = page.select_one('meta[property="og:title"]')
            if og:
                title = og["content"]
                if title.endswith(TITLE_SUFFIX):
                    title = title[: -len(TITLE_SUFFIX)]
        except Exception:
            pass

        if not title:
            # fallback: humanise the slug
            title = url.rstrip("/").rsplit("/", 1)[-1].replace("-", " ").title()

        fe = fg.add_entry()
        fe.title(title)
        fe.link(href=url)
        fe.id(url)
        if date_str:
            fe.pubDate(datetime.fromisoformat(date_str.replace("Z", "+00:00")))

    fg.rss_file(output)
    print(f"wrote {output}")


if __name__ == "__main__":
    main(sys.argv[1])
