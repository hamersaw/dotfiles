#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["beautifulsoup4", "feedgen", "requests"]
# ///
"""Scrape https://risingwave.com/blog/ and produce an RSS feed."""

import sys
from datetime import datetime

import requests
from bs4 import BeautifulSoup
from feedgen.feed import FeedGenerator

URL = "https://risingwave.com/blog/"


def fetch_post_date(url: str) -> datetime | None:
    """Fetch a single post page and extract its <time datetime> value."""
    try:
        resp = requests.get(url, timeout=30)
        resp.raise_for_status()
        soup = BeautifulSoup(resp.text, "html.parser")
        time_el = soup.select_one("time[datetime]")
        if time_el:
            return datetime.fromisoformat(
                time_el["datetime"].replace("Z", "+00:00")
            )
    except Exception:
        pass
    return None


def main(output: str) -> None:
    resp = requests.get(URL, timeout=30)
    resp.raise_for_status()
    soup = BeautifulSoup(resp.text, "html.parser")

    fg = FeedGenerator()
    fg.title("RisingWave Blog")
    fg.link(href=URL)
    fg.description("RisingWave Blog")

    seen = set()
    for link in soup.select('a[href*="/blog/"]'):
        href = link.get("href", "")
        if href.rstrip("/") == "/blog" or href.rstrip("/") == URL.rstrip("/"):
            continue

        # titles are bare text inside the anchor (no child heading tags)
        title = link.get_text(strip=True)
        if not title or len(title) < 10 or len(title) > 200:
            continue

        full_url = href if href.startswith("http") else f"https://risingwave.com{href}"
        if full_url in seen:
            continue
        seen.add(full_url)

        pub_date = fetch_post_date(full_url)

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
