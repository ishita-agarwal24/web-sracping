import scrapy
import boto3
import json

class ExampleSpider(scrapy.Spider):
    name = "example"
    start_urls = ["https://example.com"]  # Change this to your target website

    def parse(self, response):
        data = {"title": response.xpath("//title/text()").get()}  # Example: Scraping page title
        s3 = boto3.client("s3")
        s3.put_object(Bucket="your-s3-bucket", Key="scraped_data.json", Body=json.dumps(data))
