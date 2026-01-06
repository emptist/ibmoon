///|
// Examples: Demonstrate IB API usage
// These tests show how to use the ibmoon library for common operations
//
// To run these tests:
// 1. Start IB TWS or IB Gateway
// 2. Enable API connections with port 7496 (or your configured port)
// 3. Run: moon test --target wasm-gc

///|
test "example_managed_accounts" {
  // Example: Retrieve all account IDs associated with your login session
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  match client_connect(client) {
    Ok(client) => {
      println("Connected to IB TWS/Gateway")

      // Register callback to receive managed accounts
      let client = set_managed_accounts_callback(client, fn(
        accounts_list : String,
      ) -> Unit {
        println("")
        println("=" + "=".repeat(60))
        println("MANAGED ACCOUNTS")
        println("=" + "=".repeat(60))
        println("")
        println("Account List: " + accounts_list)
        println("")
        println("Account Details:")
        println("  The accounts are comma-separated in the list above")
        println("  Each account ID can be used for account-specific operations")
        println("")
        println("=" + "=".repeat(60))
        println("")
      })

      // Request managed accounts
      match req_managed_accounts(client) {
        Ok(client) => {
          println("Managed accounts requested successfully")
          match client_process_messages(client) {
            Ok(_) => ()
            Err(_) => ()
          }
        }
        Err(_) => ()
      }
      match client_disconnect(client) {
        Ok(_) => ()
        Err(_) => ()
      }
    }
    Err(_) => ()
  }
}

///|
test "example_account_summary" {
  // Example: Retrieve account financial summary
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  match client_connect(client) {
    Ok(client) => {
      println("Connected to IB TWS/Gateway")

      // Register callback to receive account summary data
      let client = set_account_summary_callback(client, fn(
        _req_id : Int,
        account : String,
        tag : String,
        value : String,
        currency : String,
      ) -> Unit {
        println("Account: " + account)
        println("  Tag: " + tag)
        println("  Value: " + value)
        println("  Currency: " + currency)
        println("")
      })

      // Request account summary with common financial metrics
      let tags = "TotalCashValue,NetLiquidation,AvailableFunds,GrossPositionValue,ExcessLiquidity"
      match req_account_summary(client, 1, "All", tags) {
        Ok(client) => {
          println("Account summary requested successfully")
          match client_process_messages(client) {
            Ok(_) => ()
            Err(_) => ()
          }
        }
        Err(_) => ()
      }
      match client_disconnect(client) {
        Ok(_) => ()
        Err(_) => ()
      }
    }
    Err(_) => ()
  }
}

///|
test "example_positions" {
  // Example: Retrieve current positions
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  match client_connect(client) {
    Ok(client) => {
      println("Connected to IB TWS/Gateway")

      // Register callback to receive position data
      let client = set_position_callback(client, fn(
        account : String,
        contract : Contract,
        pos : Double,
        avg_cost : Double,
      ) -> Unit {
        println("Account: " + account)
        println("  Symbol: " + contract.symbol)
        println("  Position: " + Double::to_string(pos))
        println("  Average Cost: " + Double::to_string(avg_cost))
        println("")
      })

      // Request positions
      match req_positions(client) {
        Ok(client) => {
          println("Positions requested successfully")
          match client_process_messages(client) {
            Ok(_) => ()
            Err(_) => ()
          }
        }
        Err(_) => ()
      }
      match client_disconnect(client) {
        Ok(_) => ()
        Err(_) => ()
      }
    }
    Err(_) => ()
  }
}

///|
test "example_connection" {
  // Example: Basic connection and disconnection
  let config = connection_config("127.0.0.1", 7496, 1, None)
  let client = new_client(config)
  match client_connect(client) {
    Ok(client) => {
      println("Connected to IB TWS/Gateway")

      // Register error callback
      let client = set_error_callback(client, fn(
        _code : ErrorCode,
        msg : String,
      ) -> Unit {
        println("Error: " + msg)
      })

      // Request next valid order ID
      match req_ids(client, 1) {
        Ok(client) => {
          println("Order ID requested")
          match client_process_messages(client) {
            Ok(_) => ()
            Err(_) => ()
          }
        }
        Err(_) => ()
      }
      match client_disconnect(client) {
        Ok(_) => ()
        Err(_) => ()
      }
    }
    Err(_) => ()
  }
}
