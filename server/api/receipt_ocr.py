import requests

API_KEY = 'GKN5SwsFMZrYAHnkzLcKle0zNGxt2mlCvPKjV0g5vyW3gBBXpJWFCZaqmT9oQlpW'
BASE_URL = 'https://api.tabscanner.com/api'
HEADERS = {'apikey': API_KEY}


def get_ocr(token: str):
    """
    Get the OCR result from the TabScanner API based on a token

    Args:
        token (str): The token to get the OCR result for

    Returns:
        dict: The OCR result
    """
    url = f'{BASE_URL}/result/{token}'
    response = requests.get(url, headers=HEADERS)
    return response.json()
