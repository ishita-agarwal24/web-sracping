import requests
import boto3
import csv
from bs4 import BeautifulSoup

# AWS S3 Configuration
BUCKET_NAME = "ishita-agarwal"
s3 = boto3.client("s3")

# Scrape example.com
response = requests.get("https://example.com")
soup = BeautifulSoup(response.text, "html.parser")

# Extract headings
data = []
for heading in soup.find_all("h2"):
    data.append([heading.text.strip()])

# Save to CSV
file_name = "/tmp/scraped_data.csv"
with open(file_name, "w", newline="") as f:
    writer = csv.writer(f)
    writer.writerow(["Headings"])
    writer.writerows(data)

# Upload CSV to S3
s3.upload_file(file_name, BUCKET_NAME, "scraped_data.csv")

print("✅ Data scraped and uploaded to S3")
