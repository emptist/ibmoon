# Account Summary Example

This example demonstrates how to request account summary data from IB TWS/Gateway and receive it via callbacks.

## Complete Example Code

```moonbit
// Import the ibmoon library
// Note: Adjust import based on your package configuration

fn main {
  // Create API instance
  let api = new_ib_api("127.0.0.1", 7496, 1)
  
  // Connect to IB TWS or Gateway
  match api_connect(api) {
    Ok(api) => {
      println("Connected to IB API")
      
      // Register account summary callback to receive data
      let api = on_account_summary(
        api,
        fn(
          req_id : Int,
          account : String,
          tag : String,
          value : String,
          currency : String,
        ) -> Unit {
          // This callback will be called for each account summary item
          println("Account: " + account)
          println("  Tag: " + tag)
          println("  Value: " + value)
          println("  Currency: " + currency)
          println("---")
        }
      )
      
      // Register error callback to handle any errors
      let api = on_error(
        api,
        fn(code : ErrorCode, msg : String) -> Unit {
          println("Error: " + msg)
        }
      )
      
      // Request account summary with common financial metrics
      // Tags: TotalCashValue, NetLiquidation, AvailableFunds, GrossPositionValue, etc.
      let tags = "TotalCashValue,NetLiquidation,AvailableFunds,GrossPositionValue,ExcessLiquidity,FullAvailableFunds,FullInitMarginReq,FullMaintMarginReq"
      
      match get_account_summary(api, tags) {
        Ok(req_id) => {
          println("Account summary requested (req_id: " + req_id.to_string() + ")")
          
          // Process messages to receive account summary data
          // In a real application, this would be in a loop
          match api_process_messages(api) {
            Ok(_) => println("Messages processed")
            Err(e) => println("Error processing messages")
          }
        }
        Err(e) => {
          println("Failed to request account summary")
        }
      }
      
      // Disconnect
      match api_disconnect(api) {
        Ok(_) => println("Disconnected")
        Err(_) => ()
      }
    }
    Err(e) => {
      println("Failed to connect to IB API")
      println("Make sure TWS or Gateway is running on port 7496")
    }
  }
}
```

## Account Summary Tags

Common account summary tags you can request:

- `TotalCashValue` - Total cash in account
- `NetLiquidation` - Net liquidation value
- `AvailableFunds` - Available funds for trading
- `GrossPositionValue` - Gross position value
- `ExcessLiquidity` - Excess liquidity
- `FullAvailableFunds` - Full available funds
- `FullInitMarginReq` - Full initial margin requirement
- `FullMaintMarginReq` - Full maintenance margin requirement
- `LookAheadNextChange` - Look ahead next change
- `LookAheadNextChangeTime` - Look ahead next change time
- `HighestLiquidity` - Highest liquidity
- `Leverage` - Account leverage
- `BuyingPower` - Buying power

## How It Works

1. **Create API Instance**: Initialize the API with connection parameters
2. **Connect**: Establish connection to IB TWS or Gateway
3. **Register Callbacks**: Set up callbacks to receive account summary data
4. **Request Data**: Call `get_account_summary()` with desired tags
5. **Process Messages**: Call `api_process_messages()` in a loop to receive data
6. **Handle Callbacks**: The `on_account_summary` callback will be invoked for each account summary item

## Sample Output

```
Connected to IB API
Account summary requested (req_id: 1)
Account: U1234567
  Tag: TotalCashValue
  Value: 100000.00
  Currency: USD
---
Account: U1234567
  Tag: NetLiquidation
  Value: 150000.00
  Currency: USD
---
Account: U1234567
  Tag: AvailableFunds
  Value: 75000.00
  Currency: USD
---
Messages processed
Disconnected
```

## Notes

- Account summary data is delivered asynchronously via callbacks
- Multiple accounts may be returned if you have multiple account structures
- The callback will be called once for each tag requested
- Remember to process messages in a loop in a real application
- You can cancel account summary requests with `cancel_account_summary()` (if implemented)