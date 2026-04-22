#!/usr/bin/env -S uv run --script
# /// script
# requires-python = ">=3.11"
# dependencies = ["beautifulsoup4", "feedgen", "requests"]
# ///
"""Scrape https://www.tigerdata.com/blog and produce an RSS feed."""

import re
import sys
from datetime import datetime, timezone

import requests
from bs4 import BeautifulSoup
from feedgen.feed import FeedGenerator

DATE_RE = re.compile(r"(Jan|Feb|Mar|Apr|May|Jun|Jul|Aug|Sep|Oct|Nov|Dec)\w*\s+\d{1,2},?\s+\d{4}")

URL = "https://www.tigerdata.com/blog"


def main(output: str) -> None:
    resp = requests.get(URL, timeout=30)
    resp.raise_for_status()
    soup = BeautifulSoup(resp.text, "html.parser")

    fg = FeedGenerator()
    fg.title("TigerData Blog")
    fg.link(href=URL)
    fg.description("TigerData Blog")

    # iterate from date elements and walk up to find the enclosing card
    seen = set()
    for date_p in soup.find_all("p", class_="text-black-400", string=DATE_RE):
        m = DATE_RE.search(date_p.get_text())
        if not m:
            continue
        pub_date = datetime.strptime(m.group(), "%b %d, %Y").replace(
            tzinfo=timezone.utc
        )

        # walk up to find a container with exactly one blog post link
        container = date_p
        for _ in range(5):
            container = container.parent
            if container is None:
                break
            links = [
                a
                for a in container.find_all("a", href=re.compile(r"/blog/"))
                if "/blog/tag/" not in a.get("href", "")
                and "/blog/author/" not in a.get("href", "")
                and a.get("href", "").rstrip("/") not in ("/blog", URL.rstrip("/"))
            ]
            if len(links) == 1:
                link = links[0]
                title = link.get_text(strip=True)
                if not title or len(title) < 5:
                    break
                href = link.get("href", "")
                full_url = (
                    href
                    if href.startswith("http")
                    else f"https://www.tigerdata.com{href}"
                )
                if full_url in seen:
                    break
                seen.add(full_url)

                fe = fg.add_entry()
                fe.title(title)
                fe.link(href=full_url)
                fe.id(full_url)
                fe.pubDate(pub_date)
                break

    fg.rss_file(output)
    print(f"wrote {output}")


if __name__ == "__main__":
    main(sys.argv[1])
