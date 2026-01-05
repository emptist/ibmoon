# Managed Accounts Example

This example demonstrates how to retrieve all account IDs associated with your current login session using the Interactive Brokers API.

## Overview

The managed accounts feature allows you to:
- Retrieve all account IDs linked to your login session
- Useful for multi-account setups and institutional accounts
- Returns a comma-separated string of account IDs

## Example Code

```moonbit
// Import the ibmoon library
use "ibmoon"

fn main() {
  // Create API instance
  let api = new_ib_api("127.0.0.1", 7496, 1)
  
  // Connect to IB TWS or Gateway
  match api_connect(api) {
    Ok(connected_api) => {
      println("Connected to IB TWS/Gateway")
      
      // Register callback to receive managed accounts
      let api = on_managed_accounts(
        connected_api,
        fn(accounts_list : String) -> Unit {
          println("Managed Accounts: " + accounts_list)
          
          // Parse the comma-separated account list
          let accounts = split_string(accounts_list, ",")
          println("Number of accounts: " + to_string(length(accounts)))
          
          // Process each account
          let mut index = 0
          while index < length(accounts) {
            let account = unsafe_get_index(accounts, index)
            println("  Account ID: " + account)
            index = index + 1
          }
        }
      )
      
      // Request managed accounts
      match get_managed_accounts(api) {
        Ok(_) => {
          println("Managed accounts requested successfully")
          
          // Process messages to receive the response
          match api_process_messages(api) {
            Ok(_) => println("Messages processed")
            Err(e) => println("Error processing messages: " + to_string(e))
          }
        }
        Err(e) => println("Failed to request managed accounts: " + to_string(e))
      }
      
      // Disconnect
      match api_disconnect(api) {
        Ok(_) => println("Disconnected")
        Err(e) => println("Error disconnecting: " + to_string(e))
      }
    }
    Err(e) => {
      println("Failed to connect: " + to_string(e))
    }
  }
}
```

## Understanding the Response

The managed accounts callback receives a comma-separated string containing all account IDs:

```
Managed Accounts: U1234567,U7654321,U9876543
Number of accounts: 3
  Account ID: U1234567
  Account ID: U7654321
  Account ID: U9876543
```

## Account IDs vs Client IDs

It's important to understand the difference:

- **Account IDs**: Identifiers for your actual trading accounts (e.g., U1234567)
  - Used for account-specific operations
  - Provided by Interactive Brokers
  - Remain constant for your account
  
- **Client IDs**: Identifiers for API connections (e.g., 1, 2, 3)
  - Used to distinguish different API connections
  - Assigned by you when connecting
  - Can be different each time you connect

The `get_managed_accounts()` function returns **Account IDs**, not client IDs.

## Use Cases

### 1. Multi-Account Trading
```moonbit
let api = on_managed_accounts(
  api,
  fn(accounts_list : String) -> Unit {
    let accounts = split_string(accounts_list, ",")
    // Iterate through accounts and perform operations on each
    let mut index = 0
    while index < length(accounts) {
      let account = unsafe_get_index(accounts, index)
      // Request positions for this account
      let _ = get_positions(api)
      index = index + 1
    }
  }
)
```

### 2. Account Filtering
```moonbit
let target_account = "U1234567"

let api = on_managed_accounts(
  api,
  fn(accounts_list : String) -> Unit {
    let accounts = split_string(accounts_list, ",")
    
    // Check if target account is in the list
    let mut index = 0
    let mut found = false
    while index < length(accounts) {
      let account = unsafe_get_index(accounts, index)
      if account == target_account {
        found = true
      }
      index = index + 1
    }
    
    if found {
      println("Target account is available")
    } else {
      println("Target account not found")
    }
  }
)
```

### 3. Account Summary for All Accounts
```moonbit
let api = on_managed_accounts(
  api,
  fn(accounts_list : String) -> Unit {
    let accounts = split_string(accounts_list, ",")
    
    // Request account summary for each account
    let tags = "TotalCashValue,NetLiquidation,AvailableFunds"
    let mut index = 0
    while index < length(accounts) {
      let account = unsafe_get_index(accounts, index)
      println("Requesting summary for account: " + account)
      let _ = get_account_summary(api, tags)
      index = index + 1
    }
  }
)
```

## Error Handling

```moonbit
match get_managed_accounts(api) {
  Ok(_) => {
    println("Request sent successfully")
    // Process messages to receive response
  }
  Err(e) => {
    match e {
      ClientError(msg) => println("Client error: " + msg)
      InvalidState(msg) => println("Invalid state: " + msg)
      _ => println("Unknown error")
    }
  }
}
```

## Important Notes

1. **Read-Only Operation**: `get_managed_accounts()` is a safe read-only operation that doesn't modify your account state.

2. **Connection Required**: You must be connected to IB TWS or Gateway before requesting managed accounts.

3. **Single Request**: Unlike some other API functions, you typically only need to request managed accounts once per session.

4. **Callback Registration**: Always register the callback before calling `get_managed_accounts()`.

5. **Message Processing**: Remember to call `api_process_messages()` after requesting managed accounts to receive and process the response.

## See Also

- [Account Summary Example](ACCOUNT_SUMMARY_EXAMPLE.md) - Learn how to get account financial data
- [API Documentation](../README.md) - Complete API reference
- [Connection Guide](CONNECTION_GUIDE.md) - How to connect to IB TWS/Gateway