import os
import time
import requests
import pandas as pd
from dotenv import load_dotenv

# Load GitHub token
load_dotenv()

GITHUB_TOKEN = os.getenv("GITHUB_TOKEN")
if not GITHUB_TOKEN:
    raise RuntimeError("GitHub token not found. Add it to your .env file as GITHUB_TOKEN=...")

headers = {
    "Authorization": f"token {GITHUB_TOKEN}",
    "Accept": "application/vnd.github+json"
}

# Configuration
REPOSITORIES_PER_LANGUAGE = 200
PER_PAGE = 100
PAGES_PER_QUERY = 3
OUTPUT_FILE = "../data/github_3000_repositories.csv"

languages = [
    "Python", "JavaScript", "TypeScript", "Java", "C++",
    "C", "Go", "Rust", "PHP", "C#",
    "Swift", "Kotlin", "Ruby", "Dart", "Scala"
]

star_ranges = [
    "50000..*",
    "10000..49999",
    "5000..9999",
    "1000..4999",
    "500..999",
    "100..499"
]

repositories = []
seen = set()

def make_request(url):
    while True:
        response = requests.get(url, headers=headers)

        if response.status_code == 403:
            reset = response.headers.get("X-RateLimit-Reset")
            if reset:
                wait = max(int(reset) - int(time.time()) + 2, 2)
                print(f"Rate limit reached. Waiting {wait} seconds...")
                time.sleep(wait)
                continue

        if response.status_code != 200:
            print(f"Request failed ({response.status_code})")
            print(response.text)
            return None

        return response.json()

def fetch_repositories():

    for language in languages:

        language_count = 0

        print(f"\nSearching repositories for {language}...")

        finished_language = False

        for stars in star_ranges:

            if finished_language:
                break

            print(f"  Star Range: {stars}")

            for page in range(1, PAGES_PER_QUERY + 1):

                query = f"language:{language} stars:{stars}"

                params = {
                    "q": query,
                    "sort": "stars",
                    "order": "desc",
                    "per_page": PER_PAGE,
                    "page": page
                }

                try:

                    response = requests.get(
                        "https://api.github.com/search/repositories",
                        headers=headers,
                        params=params
                    )

                    if response.status_code != 200:
                        print(f"Request failed ({response.status_code})")
                        print(response.text)
                        time.sleep(3)
                        continue

                    data = response.json()

                    if "items" not in data:
                        continue

                    if len(data["items"]) == 0:
                        break

                    for repo in data["items"]:

                        full_name = repo["full_name"]

                        if full_name in seen:
                            continue

                        seen.add(full_name)

                        repositories.append({
                            "Name": repo["name"],
                            "Language": repo["language"],
                            "Stars": repo["stargazers_count"],
                            "Forks": repo["forks_count"],
                            "Owner": repo["owner"]["login"],
                            "Created At": repo["created_at"]
                        })

                        language_count += 1

                        print(
                            f"\r{language}: {language_count}/{REPOSITORIES_PER_LANGUAGE} | Total: {len(repositories)}",
                            end=""
                        )

                        if language_count >= REPOSITORIES_PER_LANGUAGE:
                            finished_language = True
                            break

                    time.sleep(1)

                except Exception as e:
                    print(f"\nError: {e}")
                    time.sleep(3)

        print(f"\nFinished {language}")

def save_csv():
    os.makedirs(os.path.dirname(OUTPUT_FILE), exist_ok=True)
    df = pd.DataFrame(repositories)
    df.to_csv(OUTPUT_FILE, index=False)

    print("\n\nDone!")
    print(f"Total repositories collected : {len(df)}")
    print(f"CSV saved to           : {OUTPUT_FILE}")

def main():
    start = time.time()

    print("=" * 60)
    print("GitHub ETL Pipeline")
    print("=" * 60)

    fetch_repositories()
    save_csv()

    end = time.time()
    print(f"Execution time: {round(end-start,2)} seconds")

if __name__ == "__main__":
    main()
