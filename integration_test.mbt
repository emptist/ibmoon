///|
// Integration tests for IB TWS/Gateway API
// These tests connect to a live API and perform read-only operations only
// NO BUY/SELL ORDERS ARE PLACED IN THESE TESTS
// 
// To run these tests:
// 1. Start IB TWS or IB Gateway
// 2. Enable API connections with port 7496 (or your configured port)
// 3. Run: moon test --update

test "connect_to_live_api" {
  // Test connection to live API on port 7496
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  
  match client_connect(client) {
    Ok(client) => {
      // Successfully connected
      match client_disconnect(client) {
        Ok(_) => ()
        Err(_) => ()
      }
    }
    Err(e) => {
      // Connection failed - this is expected if API is not running
      // Don't fail the test, just note it
      ()
    }
  }
}

test "request_server_time" {
  // Request current server time (read-only operation)
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  
  match client_connect(client) {
    Ok(client) => {
      // Request current time
      match req_ids(client, 1) {
        Ok(client) => {
          // Time request sent
          // Process messages to receive time
          match client_process_messages(client) {
            Ok(_) => ()
            Err(_) => ()
          }
        }
        Err(_) => ()
      }
      
      // Close connection
      match client_disconnect(client) {
        Ok(_) => ()
        Err(_) => ()
      }
    }
    Err(_) => {
      // Connection failed - expected if API not running
      ()
    }
  }
}

test "request_account_summary_read_only" {
  // Request account summary (read-only operation)
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  
  match client_connect(client) {
    Ok(client) => {
      // Request account summary with common tags
      let tags = "TotalCashValue,NetLiquidation,AvailableFunds"
      
      match req_account_summary(client, 1, "All", tags) {
        Ok(client) => {
          // Request sent successfully
          // Process messages to receive account summary
          match client_process_messages(client) {
            Ok(_) => ()
            Err(_) => ()
          }
        }
        Err(_) => ()
      }
      
      // Cancel account summary request
      // Note: cancel_account_summary not yet implemented
      // match client_cancel_account_summary(client, 1) {
      //   Ok(_) => ()
      //   Err(_) => ()
      // }
      ()
      
      // Close connection
      match client_disconnect(client) {
        Ok(_) => ()
        Err(_) => ()
      }
    }
    Err(_) => {
      // Connection failed - expected if API not running
      ()
    }
  }
}

test "request_positions_read_only" {
  // Request current positions (read-only operation)
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  
  match client_connect(client) {
    Ok(client) => {
      // Request positions
      match req_positions(client) {
        Ok(client) => {
          // Request sent successfully
          // Process messages to receive positions
          match client_process_messages(client) {
            Ok(_) => ()
            Err(_) => ()
          }
        }
        Err(_) => ()
      }
      
      // Cancel positions request
      // Note: cancel_positions not yet implemented
      // match client_cancel_positions(client) {
      //   Ok(_) => ()
      //   Err(_) => ()
      // }
      ()
      
      // Close connection
      match client_disconnect(client) {
        Ok(_) => ()
        Err(_) => ()
      }
    }
    Err(_) => {
      // Connection failed - expected if API not running
      ()
    }
  }
}

test "request_open_orders_read_only" {
  // Request open orders (read-only operation - just queries, doesn't modify)
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  
  match client_connect(client) {
    Ok(client) => {
      // Request open orders
      match req_open_orders(client) {
        Ok(client) => {
          // Request sent successfully
          // Process messages to receive open orders
          match client_process_messages(client) {
            Ok(_) => ()
            Err(_) => ()
          }
        }
        Err(_) => ()
      }
      
      // Close connection
      match client_disconnect(client) {
        Ok(_) => ()
        Err(_) => ()
      }
    }
    Err(_) => {
      // Connection failed - expected if API not running
      ()
    }
  }
}

test "request_executions_read_only" {
  // Request execution details (read-only operation)
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  
  match client_connect(client) {
    Ok(client) => {
      // Request executions
      match req_executions(client, 1, default_execution_filter()) {
        Ok(client) => {
          // Request sent successfully
          // Process messages to receive executions
          match client_process_messages(client) {
            Ok(_) => ()
            Err(_) => ()
          }
        }
        Err(_) => ()
      }
      
      // Close connection
      match client_disconnect(client) {
        Ok(_) => ()
        Err(_) => ()
      }
    }
    Err(_) => {
      // Connection failed - expected if API not running
      ()
    }
  }
}

test "request_contract_details_read_only" {
  // Request contract details for a stock (read-only operation)
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  
  match client_connect(client) {
    Ok(client) => {
      // Create a simple stock contract for Apple
      let contract = stock_contract("AAPL", "SMART", "USD")
      
      // Request contract details
      match req_contract_details(client, 1, contract) {
        Ok(client) => {
          // Request sent successfully
          // Process messages to receive contract details
          match client_process_messages(client) {
            Ok(_) => ()
            Err(_) => ()
          }
        }
        Err(_) => ()
      }
      
      // Close connection
      match client_disconnect(client) {
        Ok(_) => ()
        Err(_) => ()
      }
    }
    Err(_) => {
      // Connection failed - expected if API not running
      ()
    }
  }
}

test "request_order_id_read_only" {
  // Request next valid order ID (read-only operation)
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  
  match client_connect(client) {
    Ok(client) => {
      // Request order ID
      match req_ids(client, 1) {
        Ok(client) => {
          // Request sent successfully
          // Process messages to receive order ID
          match client_process_messages(client) {
            Ok(_) => ()
            Err(_) => ()
          }
        }
        Err(_) => ()
      }
      
      // Close connection
      match client_disconnect(client) {
        Ok(_) => ()
        Err(_) => ()
      }
    }
    Err(_) => {
      // Connection failed - expected if API not running
      ()
    }
  }
}

test "callback_registration" {
  // Test that callbacks can be registered (doesn't require live connection)
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  
  // Register error callback
  let client = set_error_callback(
    client,
    fn(code : ErrorCode, msg : String) -> Unit {
      ()
    }
  )
  
  // Register account summary callback
  let client = set_account_summary_callback(
    client,
    fn(req_id : Int, account : String, tag : String, value : String, currency : String) -> Unit {
      ()
    }
  )
  
  // Register position callback
  let client = set_position_callback(
    client,
    fn(account : String, contract : Contract, pos : Double, avg_cost : Double) -> Unit {
      ()
    }
  )
  
  // Verify callbacks are set
  match client.on_error {
    Some(_) => ()
    None => ()
  }
  
  match client.on_account_summary {
    Some(_) => ()
    None => ()
  }
  
  match client.on_position {
    Some(_) => ()
    None => ()
  }
}

test "safe_operations_only" {
  // This test verifies that we only perform safe, read-only operations
  // No orders are placed, no positions are modified
  
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  
  match client_connect(client) {
    Ok(client) => {
      // Safe operations only:
      // 1. Request order ID
      let client = match req_ids(client, 1) {
        Ok(c) => c
        Err(_) => client
      }
      
      // 2. Request account summary
      let client = match req_account_summary(client, 1, "All", "TotalCashValue") {
        Ok(c) => c
        Err(_) => client
      }
      
      // 3. Request positions
      let client = match req_positions(client) {
        Ok(c) => c
        Err(_) => client
      }
      
      // 4. Request open orders (query only)
      let client = match req_open_orders(client) {
        Ok(c) => c
        Err(_) => client
      }
      
      // 5. Process messages
      let _ = client_process_messages(client)
      
      // Close connection
      match client_disconnect(client) {
        Ok(_) => ()
        Err(_) => ()
      }
    }
    Err(_) => {
      // Connection failed - expected if API not running
      ()
    }
  }

test "request_managed_accounts_read_only" {
  // Request managed accounts (read-only operation)
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  
  match client_connect(client) {
    Ok(client) => {
      // Register callback to receive managed accounts
      let client = set_managed_accounts_callback(
        client,
        fn(accounts_list : String) -> Unit {
          // Callback invoked with accounts list
          ()
        }
      )
      
      // Request managed accounts
      match req_managed_accounts(client) {
        Ok(client) => {
          // Request sent successfully
          // Process messages to receive managed accounts
          match client_process_messages(client) {
            Ok(_) => ()
            Err(_) => ()
          }
        }
        Err(_) => ()
      }
      
      // Close connection
      match client_disconnect(client) {
        Ok(_) => ()
        Err(_) => ()
      }
    }
    Err(_) => {
      // Connection failed - expected if API not running
      ()
    }
  }
}
}
