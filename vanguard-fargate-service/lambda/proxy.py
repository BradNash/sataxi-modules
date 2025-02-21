import os
import urllib3

http = urllib3.PoolManager()


def lambda_handler(event, context):
    internal_service_uri = os.getenv("INTERNAL_PROXY_URI")

    url = f"{internal_service_uri}/{event['path'][event['resource'].index('{proxy+}'):]}"
    print(f"Sending request to {url} with method: {event['httpMethod']}")
    query_params = event.get("queryStringParameters", None)

    if query_params is not None:
        query_params_str = "?"
        for key, value in query_params.items():
            query_params_str += f"{key}={str(value)},"

        url += query_params_str[:-1]

    request_body = event.get("body", None)
    response = None

    if request_body is not None:
        response = http.request(
            method=event["httpMethod"],
            url=url,
            headers=event["headers"],
            body=request_body
        )
    else:
        response = http.request(
            method=event["httpMethod"],
            url=url,
            headers=event["headers"]
        )

    print(f"Received response with code {response.status}")
    response_headers = {}

    for item in response.headers.items():
        response_headers[item[0]] = item[1]

    return {"statusCode": response.status, "body": response.data, "headers": response_headers}