#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["beautifulsoup4", "feedgen", "requests"]
# ///
"""Scrape https://materialize.com/blog/ and produce an RSS feed."""

import re
import sys
from datetime import datetime, timezone

import requests
from bs4 import BeautifulSoup
from feedgen.feed import FeedGenerator

URL = "https://materialize.com/blog/"
# dates appear inline in link text as MM.DD.YYYY
INLINE_DATE_RE = re.compile(r"(\d{2})\.(\d{2})\.(\d{4})")


def main(output: str) -> None:
    resp = requests.get(URL, timeout=30)
    resp.raise_for_status()
    soup = BeautifulSoup(resp.text, "html.parser")

    fg = FeedGenerator()
    fg.title("Materialize Blog")
    fg.link(href=URL)
    fg.description("Materialize Blog")

    seen = set()
    for link in soup.select('a[href*="/blog/"]'):
        href = link.get("href", "")
        if href.rstrip("/") == "/blog" or href.rstrip("/") == URL.rstrip("/"):
            continue

        raw_text = link.get_text(strip=True)

        # extract inline date (MM.DD.YYYY) and strip it + "Blog" prefix from title
        pub_date = None
        title = raw_text
        m = INLINE_DATE_RE.search(raw_text)
        if m:
            month, day, year = int(m.group(1)), int(m.group(2)), int(m.group(3))
            pub_date = datetime(year, month, day, tzinfo=timezone.utc)
            # strip the date and "Blog" label to get the clean title
            title = raw_text[m.end():]
            if title.startswith("Blog"):
                title = title[4:]
            title = title.strip()

        if not title or len(title) < 10:
            continue

        full_url = href if href.startswith("http") else f"https://materialize.com{href}"
        if full_url in seen:
            continue
        seen.add(full_url)

        fe = fg.add_entry()
        fe.title(title)
        fe.link(href=full_url)
        fe.id(full_url)
        if pub_date:
            fe.pubDate(pub_date)

    fg.rss_file(output)
    print(f"wrote {output}")


if __name__ == "__main__":
    main(sys.argv[1])
