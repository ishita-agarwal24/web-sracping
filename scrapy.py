import scrapy # type: ignore
import boto3 # type: ignore

class ExampleSpider(scrapy.Spider):
    name = "example"
    start_urls = ["https://example.com"]

    def parse(self, response):
        data = {
            "title": response.css("title::text").get(),
            "url": response.url
        }

        # Upload to S3
        s3 = boto3.client("s3")
        s3.put_object(
            Bucket="practice-web-scrapping",  # Replace with your S3 bucket name
            Key="scraped_data.json",
            Body=str(data)
        )

        self.log(f"Data saved to S3: {data}")
