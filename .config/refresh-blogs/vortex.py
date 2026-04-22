#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["beautifulsoup4", "feedgen", "requests"]
# ///
"""Scrape https://vortex.dev/blog and produce an RSS feed."""

import sys
from datetime import datetime

import requests
from bs4 import BeautifulSoup
from feedgen.feed import FeedGenerator

URL = "https://vortex.dev/blog"


def main(output: str) -> None:
    resp = requests.get(URL, timeout=30)
    resp.raise_for_status()
    soup = BeautifulSoup(resp.text, "html.parser")

    fg = FeedGenerator()
    fg.title("Vortex Blog")
    fg.link(href=URL)
    fg.description("Vortex Blog")

    seen = set()
    for link in soup.select('a[href*="/blog/"]'):
        href = link.get("href", "")
        if href.rstrip("/") == "/blog" or href.rstrip("/") == URL.rstrip("/"):
            continue

        title_el = link.select_one("h2")
        if not title_el:
            continue

        title = title_el.get_text(strip=True)
        if not title:
            continue

        full_url = href if href.startswith("http") else f"https://vortex.dev{href}"
        if full_url in seen:
            continue
        seen.add(full_url)

        # look for date
        time_el = link.select_one("time")
        date_str = time_el.get("datetime", "") if time_el else ""

        # look for description
        desc_el = link.select_one("p")
        description = desc_el.get_text(strip=True) if desc_el else ""

        fe = fg.add_entry()
        fe.title(title)
        fe.link(href=full_url)
        fe.id(full_url)
        if date_str:
            fe.pubDate(datetime.fromisoformat(date_str.replace("Z", "+00:00")))
        if description:
            fe.description(description)

    fg.rss_file(output)
    print(f"wrote {output}")


if __name__ == "__main__":
    main(sys.argv[1])
