from fastapi import APIRouter, UploadFile
import requests
import time

API_KEY = 'GKN5SwsFMZrYAHnkzLcKle0zNGxt2mlCvPKjV0g5vyW3gBBXpJWFCZaqmT9oQlpW'
BASE_URL = 'https://api.tabscanner.com/api'
HEADERS = {'apikey': API_KEY}

router = APIRouter(prefix='/ocr')


def image_to_token(file: UploadFile):
    """
    Post an image to the TabScanner API for OCR processing. Returns the token for the OCR result.

    Args:
        file (UploadFile): The image to process

    Returns:
        dict: The token for the OCR result
    """
    try:
        print("START IMAGE TO TOKEN")
        url = f'{BASE_URL}/process'
        fileBytes = file.file.read()
        
        print("READ TO TOKEN")
        files = {'file': (file.filename, fileBytes, file.content_type)}
        response = requests.post(url, headers=HEADERS, files=files)
        print("POSTED TO TOKEN")
        json = response.json()

        if json['status'] == 'failed':
            raise Exception(f'Error processing image: {json["message"]}')

        return json['token']

    except Exception as e:
        return {'Error creating a token for the image': str(e)}
    finally:
        file.file.close()


def token_to_ocr_result(token: str):
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


@router.get('/result/{token}')
def get_receipt_info_from_token(token: str):
    """
    Get the OCR result from the TabScanner API based on a token

    Args:
        token (str): The token to get the OCR result for

    Returns:
        dict: The OCR result
    """
    return token_to_ocr_result(token)


saved_rect = None

@router.post('/process')
async def process_receipt(file: UploadFile):
    """
    Post an image to the TabScanner API for OCR processing. Returns the token for the OCR result.

    Args:
        file (UploadFile): The image to process

    Returns:
        dict: The token for the OCR result
    """
    global saved_rect
    if (saved_rect):
        return saved_rect
    token = image_to_token(file)

    # Since the OCR takes a bit to process the receipt
    WAIT = .5
    time.sleep(WAIT)

    while True:
        res = token_to_ocr_result(token)
        if res['status'] != 'pending':
            saved_rect = res['result']
            return res['result']
        print('Waiting for OCR result...')
        time.sleep(WAIT)
