import requests
import json

def run_query(auth_key, query):
    """
    Make API request to migrate database with SQL scripts
    
    Args:
        auth_key (str): Authentication token
        sql_scripts (list): List of dictionaries containing SQL scripts
    
    Returns:
        dict: Response from the API
    """
    # API endpoint
    url = "https://2dr3wn94t1.execute-api.us-east-2.amazonaws.com/test_v1/query"
    
    # Request headers
    headers = {
        "Content-Type": "application/json",
        "authToken": auth_key
    }
    
    # Request body
    payload = {
        "query": query
    }
    
    try:
        # Make POST request
        response = requests.post(url, headers=headers, json=payload)
        
        # Raise an exception for bad status codes
        response.raise_for_status()
        
        # Return response json
        return response.json()
        
    except requests.exceptions.RequestException as e:
        print(f"Error making request: {e}")
        return None

# Example usage
if __name__ == "__main__":
    # Your authentication key
   #AUTH_KEY = "your_auth_key_here"
    AUTH_KEY = input("Input AUTH KEY: ") #"8dfb22af-d700-4b58-bf10-593934d356df"
    query = input("Input query: ") #"SELECT * FROM users1"
    
    # Make the request
    result = run_query(AUTH_KEY, query)
    
    # Print the result
    if result:
        print("Migration successful!")
        print(json.dumps(result, indent=2))