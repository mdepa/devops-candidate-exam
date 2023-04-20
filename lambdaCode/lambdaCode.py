import requests
import json

def lambda_handler(event, context):
  api_url = "https://ij92qpvpma.execute-api.eu-west-1.amazonaws.com/candidate-email_serverless_lambda_stage/data"
  payload = {
        "subnet_id": "TBD",
        "name": "Mauro de Pascale",
        "email": "mauro.de_pascale@siemens.com"
      }
  headers =  {'X-Siemens-Auth': 'test'}
  response = requests.post(api_url, json=payload, headers=headers)
  print(json.dumps(response.json(), indent=4))
  print(response.status_code)
  return { 
    json.dumps(response.json(), indent=4)
  }