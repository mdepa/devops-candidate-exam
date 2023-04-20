import requests
import json
import boto3

def lambda_handler(event, context):
  api_url = "https://ij92qpvpma.execute-api.eu-west-1.amazonaws.com/candidate-email_serverless_lambda_stage/data"
  
  client = boto3.client('lambda')
  response = client.get_function_configuration(
  #response = client.get_function(  
    FunctionName='lambda',
  #  Qualifier='1'
  )

  print(response.VpcConfig.VpcId)

  payload = {
        "subnet_id": "TBD",
        "name": "Mauro de Pascale",
        "email": "mauro.de_pascale@siemens.com"
      }
  headers =  {'X-Siemens-Auth': 'test'}
  print('Performing POST command')
  response = requests.post(api_url, json=payload, headers=headers)
  print('done')
  print(json.dumps(response.json(), indent=4))
  print(response.status_code)
  return { 
    json.dumps(response.json(), indent=4)
  }