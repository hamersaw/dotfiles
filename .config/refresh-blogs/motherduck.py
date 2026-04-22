#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["beautifulsoup4", "feedgen", "requests"]
# ///
"""Scrape https://motherduck.com/blog/ and produce an RSS feed."""

import re
import sys
from datetime import datetime, timezone

import requests
from bs4 import BeautifulSoup
from feedgen.feed import FeedGenerator

URL = "https://motherduck.com/blog/"
DATE_RE = re.compile(r"(\d{4}/\d{2}/\d{2})")


def main(output: str) -> None:
    resp = requests.get(URL, timeout=30)
    resp.raise_for_status()
    soup = BeautifulSoup(resp.text, "html.parser")

    fg = FeedGenerator()
    fg.title("MotherDuck Blog")
    fg.link(href=URL)
    fg.description("MotherDuck Blog")

    seen = set()
    for link in soup.select('a[href*="/blog/"]'):
        href = link.get("href", "")
        if href.rstrip("/") == "/blog" or href.rstrip("/") == URL.rstrip("/"):
            continue

        h2 = link.select_one("h2")
        if not h2:
            continue

        title = h2.get_text(strip=True)
        if not title:
            continue

        full_url = href if href.startswith("http") else f"https://motherduck.com{href}"
        if full_url in seen:
            continue
        seen.add(full_url)

        # date is inline in the link text as YYYY/MM/DD
        pub_date = None
        m = DATE_RE.search(link.get_text())
        if m:
            pub_date = datetime.strptime(m.group(1), "%Y/%m/%d").replace(
                tzinfo=timezone.utc
            )

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
