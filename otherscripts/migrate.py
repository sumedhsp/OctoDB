import requests
import json

def migrate_database(auth_key, sql_scripts):
    """
    Make API request to migrate database with SQL scripts
    
    Args:
        auth_key (str): Authentication token
        sql_scripts (list): List of dictionaries containing SQL scripts
    
    Returns:
        dict: Response from the API
    """
    # API endpoint
    url = "https://2dr3wn94t1.execute-api.us-east-2.amazonaws.com/test_v1/migrate/"
    
    # Request headers
    headers = {
        "Content-Type": "application/json",
        "authToken": auth_key
    }
    
    # Request body
    payload = {
        "sql_scripts": sql_scripts
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
    #AUTH_KEY = "8dfb22af-d700-4b58-bf10-593934d356df"
    AUTH_KEY = input("Input AUTH KEY: ")
    # Example SQL scripts
    sql_scripts = [
    {
        "messages": "CREATE TABLE messages (id VARCHAR(200) PRIMARY KEY, channel_id VARCHAR(100) REFERENCES channels(id) ON DELETE CASCADE, user_id VARCHAR(50) REFERENCES users(id) ON DELETE SET NULL, content_value TEXT NOT NULL, is_edited BOOLEAN DEFAULT FALSE, created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, updated_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP);"
    }
]
    # Make the request
    result = migrate_database(AUTH_KEY, sql_scripts)
    
    # Print the result
    if result:
        print("Migration successful!")
        print(json.dumps(result, indent=2))