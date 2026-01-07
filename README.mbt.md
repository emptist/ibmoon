# IB MoonBit Wrapper

A comprehensive MoonBit wrapper for the Interactive Brokers (IB) Trader Workstation (TWS) and IB Gateway API.

## Overview

This library provides a type-safe, idiomatic MoonBit interface for interacting with IB's trading platform. It supports:

- Market data subscriptions
- Order placement and management
- Account information retrieval
- Historical data requests
- Position tracking
- Execution reports
- And much more

## Features

- **Type-safe API**: Full type definitions for contracts, orders, and all IB data structures
- **High-level interface**: Simplified API for common operations
- **Low-level access**: Direct access to protocol encoding/decoding for advanced use cases
- **Callback-based event handling**: Reactive programming model for real-time data
- **Comprehensive test coverage**: Extensive test suite ensuring reliability
- **Multi-target support**: Separate packages for JavaScript, WebAssembly, and C/Native targets

## Installation

**Important**: Due to MoonBit's immature package publishing system, the library packages are available but cannot be properly imported via `moon add` at this time. Please use the code directly from the source projects.

### Option 1: Use Source Code Directly

Clone the appropriate target-specific repository and copy the source files into your project:

- **JavaScript/Node.js**: `git clone https://github.com/emptist/ibmoonjs.git`
- **WebAssembly**: `git clone https://github.com/emptist/ibmoonwa.git`
- **C/Native**: `git clone https://github.com/emptist/ibmoonc.git`

### Option 2: Reference Implementation

Use the main ibmoon project as a reference implementation:
```bash
git clone https://github.com/emptist/ibmoon.git
```

The main ibmoon project contains all the source code and can be used as a template for your own projects.

## Quick Start

### Basic Connection

```moonbit
use ibmoon.*
use api.*

// Create API instance
let api = new_ib_api("127.0.0.1", 7497, 1)

// Connect to TWS (port 7497) or Gateway (port 4001)
match connect(api) {
  Ok(connected_api) => {
    println("Connected successfully!")
    // Use connected_api for operations
  }
  Err(e) => {
    println("Connection failed: " + e)
  }
}
```

### Market Data Subscription

```moonbit
// Create a stock contract
let contract = stock_contract("AAPL", "SMART", "USD")

// Subscribe to market data
match subscribe_market_data(api, contract) {
  Ok(req_id) => {
    println("Subscribed to market data with ID: " + req_id.to_string())
  }
  Err(e) => {
    println("Failed to subscribe: " + e)
  }
}

// Set up callback for price updates
let api = on_tick_price(api, fn(req_id, tick_type, price, timestamp) {
  println("Price update: " + price.to_string())
})
```

### Placing Orders

```moonbit
// Place a market order
match place_market_order(api, contract, Buy, 100.0) {
  Ok(order_id) => {
    println("Order placed with ID: " + order_id.to_string())
  }
  Err(e) => {
    println("Failed to place order: " + e)
  }
}

// Place a limit order
match place_limit_order(api, contract, Buy, 100.0, 150.0) {
  Ok(order_id) => {
    println("Limit order placed with ID: " + order_id.to_string())
  }
  Err(e) => {
    println("Failed to place limit order: " + e)
  }
}

// Place a stop order
match place_stop_order(api, contract, Sell, 100.0, 140.0) {
  Ok(order_id) => {
    println("Stop order placed with ID: " + order_id.to_string())
  }
  Err(e) => {
    println("Failed to place stop order: " + e)
  }
}
```

### Account Information

```moonbit
// Get account summary
match get_account_summary(api, "TotalLiquidation,NetLiquidation,AvailableFunds") {
  Ok(req_id) => {
    println("Requested account summary")
  }
  Err(e) => {
    println("Failed to get account summary: " + e)
  }
}

// Set up callback for account updates
let api = on_account_summary(api, fn(req_id, account, tag, value, currency) {
  println(account + " " + tag + ": " + value + " " + currency)
})

// Get positions
match get_positions(api) {
  Ok(_) => {
    println("Requested positions")
  }
  Err(e) => {
    println("Failed to get positions: " + e)
  }
}

// Set up callback for position updates
let api = on_position(api, fn(account, contract, position, avg_cost) {
  println(account + ": " + contract.symbol + " " + position.to_string())
})
```

### Historical Data

```moonbit
// Request historical data
match get_historical_data(
  api,
  contract,
  "",  // Empty string for current time
  "1 D",  // Duration
  Day1,  // Bar size
  Trades  // What to show
) {
  Ok(req_id) => {
    println("Requested historical data")
  }
  Err(e) => {
    println("Failed to get historical data: " + e)
  }
}

// Set up callback for historical data
let api = on_historical_data(api, fn(req_id, date, bar) => {
  println(date + ": " + bar.close.to_string())
})
```

## API Reference

### Core Types

#### `Contract`
Represents a financial instrument:
- `symbol`: Ticker symbol (e.g., "AAPL")
- `sec_type`: Security type (Stock, Option, Future, Forex, etc.)
- `exchange`: Exchange (e.g., "SMART", "CME", "IDEALPRO")
- `currency`: Currency (e.g., "USD", "EUR")
- And many more optional fields

#### `Order`
Represents an order:
- `order_id`: Unique order identifier
- `action`: Buy, Sell, SSHORT, SSHORTX
- `total_quantity`: Number of shares/contracts
- `order_type`: Market, Limit, Stop, etc.
- `lmt_price`: Limit price (for limit orders)
- `aux_price`: Stop price (for stop orders)
- And many more optional fields

#### `OrderState`
Represents order status:
- `status`: Order status string
- `filled`: Quantity filled
- `remaining`: Quantity remaining
- `avg_fill_price`: Average fill price
- And more

### Helper Functions

#### Contract Creation
- `stock_contract(symbol, exchange, currency)`: Create a stock contract
- `forex_contract(symbol, exchange, currency)`: Create a forex contract
- `option_contract(symbol, last_trade_date, strike, right, exchange, currency)`: Create an option contract
- `futures_contract(symbol, last_trade_date, exchange, currency)`: Create a futures contract

#### Order Placement
- `place_market_order(api, contract, action, quantity)`: Place a market order
- `place_limit_order(api, contract, action, quantity, limit_price)`: Place a limit order
- `place_stop_order(api, contract, action, quantity, stop_price)`: Place a stop order
- `cancel_order(api, order_id)`: Cancel an order

#### Data Requests
- `subscribe_market_data(api, contract)`: Subscribe to market data
- `unsubscribe_market_data(api, req_id)`: Unsubscribe from market data
- `get_historical_data(api, contract, end_date_time, duration_str, bar_size, what_to_show)`: Get historical data
- `get_positions(api)`: Get current positions
- `get_account_summary(api, tags)`: Get account summary
- `get_executions(api)`: Get execution details

### Callbacks

Set up callbacks to handle real-time events:

- `on_tick_price(api, callback)`: Handle price updates
- `on_tick_size(api, callback)`: Handle size updates
- `on_order_status(api, callback)`: Handle order status changes
- `on_open_order(api, callback)`: Handle open order updates
- `on_execution(api, callback)`: Handle execution reports
- `on_account_summary(api, callback)`: Handle account summary updates
- `on_position(api, callback)`: Handle position updates
- `on_historical_data(api, callback)`: Handle historical data
- `on_error(api, callback)`: Handle errors

## Connection Configuration

### TWS Configuration

1. Open TWS
2. Go to File → Global Configuration → API → Settings
3. Check "Enable ActiveX and Socket Clients"
4. Set "Socket Port" (default: 7497)
5. Set "Master API client ID" (default: 0)
6. Uncheck "Read-Only API" if you want to place orders
7. Add your IP address to "Trusted IPs" (or use 127.0.0.1 for local)

### IB Gateway Configuration

1. Start IB Gateway
2. Configure connection settings
3. Set port to 4001 (for paper trading) or 4002 (for live trading)
4. Configure API permissions as needed

## Security Considerations

- Always use paper trading accounts for development and testing
- Never hardcode credentials
- Use appropriate connection timeouts
- Implement proper error handling
- Monitor connection state
- Validate all user inputs

## Error Handling

The API uses MoonBit's `Result` type for error handling:

```moonbit
match some_operation(api) {
  Ok(result) => {
    // Handle success
  }
  Err(error) => {
    // Handle error
    match error {
      ApiError::ClientError(msg) => println("Client error: " + msg)
      ApiError::InvalidState(msg) => println("Invalid state: " + msg)
      ApiError::Timeout => println("Operation timed out")
      ApiError::NotFound => println("Resource not found")
    }
  }
}
```

## Message Processing

To receive real-time updates, you need to process messages in a loop:

```moonbit
while is_connected(api) {
  match process_messages(api) {
    Ok(_) => {
      // Continue processing
    }
    Err(e) => {
      println("Error processing messages: " + e)
      // Handle error, possibly reconnect
    }
  }
  // Small delay to prevent busy-waiting
  // (implementation depends on your runtime)
}
```

## Advanced Usage

### Custom Contract Creation

```moonbit
let contract = default_contract()
let contract = { contract with
  symbol: "AAPL",
  sec_type: Stock,
  exchange: "SMART",
  currency: "USD",
  primary_exchange: "ISLAND"
}
```

### Custom Order Creation

```moonbit
let order = default_order()
let order = { order with
  order_id: 123,
  action: Buy,
  total_quantity: 100.0,
  order_type: Limit,
  lmt_price: 150.0,
  time_in_force: GTC,
  account: "DU1234567"
}
```

## Multi-Project Architecture

To work around MoonBit's FFI limitations, this project has been split into separate target-specific packages:

### Main Project (ibmoon)
- **Repository**: https://github.com/emptist/ibmoon
- **Purpose**: Reference implementation with all source code
- **Status**: ✅ Complete and functional
- **Use**: Copy source files into your own projects

### Target-Specific Packages

#### ibmoonjs (JavaScript/Node.js)
- **Repository**: https://github.com/emptist/ibmoonjs
- **Target**: JavaScript/Node.js
- **FFI**: Node.js net module
- **Status**: ✅ Complete, published to MoonBit registry (v0.2.7)
- **Note**: Package publishing works but imports are currently non-functional due to MoonBit ecosystem limitations

#### ibmoonwa (WebAssembly)
- **Repository**: https://github.com/emptist/ibmoonwa
- **Target**: WebAssembly
- **FFI**: WASI and WebSocket host functions
- **Status**: ✅ Complete, published to MoonBit registry (v0.2.6)
- **Note**: Package publishing works but imports are currently non-functional due to MoonBit ecosystem limitations

#### ibmoonc (C/Native)
- **Repository**: https://github.com/emptist/ibmoonc
- **Target**: C/Native
- **FFI**: POSIX and Winsock sockets
- **Status**: ✅ Complete, published to MoonBit registry (v0.2.6)
- **Note**: Package publishing works but imports are currently non-functional due to MoonBit ecosystem limitations

### Test Projects

#### ibmoon_tests_js
- **Repository**: https://github.com/emptist/ibmoon_tests_js
- **Purpose**: Real-world examples for JavaScript/Node.js target
- **Examples**: Managed accounts, account summary, positions

#### ibmoon_tests_wa
- **Repository**: https://github.com/emptist/ibmoon_tests_wa
- **Purpose**: Real-world examples for WebAssembly target
- **Examples**: Managed accounts, account summary, positions

#### ibmoon_tests_c
- **Repository**: https://github.com/emptist/ibmoon_tests_c
- **Purpose**: Real-world examples for C/Native target
- **Examples**: Managed accounts, account summary, positions

## Current Status

### What's Working ✅
- Complete IB API implementation with all core functionality
- Socket communication layer with FFI support
- Message encoding/decoding for IB protocol
- Connection manager with event handling
- High-level API wrapper with comprehensive functions
- 56 passing integration tests
- Multi-target FFI implementations (JavaScript, WebAssembly, C)
- Comprehensive documentation and examples
- All source code is functional and ready to use

### Known Limitations ⚠️
- **MoonBit Package System**: The package publishing and import mechanism is currently non-functional despite packages being published successfully
- **Package Imports**: Cannot use `moon add` to install packages - must use source code directly
- **Testing**: Test projects cannot import library packages due to MoonBit ecosystem limitations

### Recommendation
Use the source code directly from the main ibmoon project or target-specific repositories. The MoonBit packaging system is not mature enough for complex library distribution at this time.

## Limitations

- MoonBit package publishing and import system is currently non-functional
- Cannot use `moon add` to install packages - must use source code directly
- JavaScript FFI uses simplified synchronous wrapper (async operations require additional work)
- WebAssembly FFI requires WASI-compliant runtime or JavaScript bridge
- Some advanced IB API features may not be fully implemented
- Testing requires running TWS/Gateway with paper trading account
- Real-time message processing needs proper async/runtime support

## FFI Implementations

The library includes complete FFI infrastructure for socket communication across all target platforms:

- **JavaScript**: Node.js `net` module implementation ([target/js/socket_impl.js](target/js/socket_impl.js))
- **WebAssembly**: WASI and WebSocket support ([target/wasm/socket.wat](target/wasm/socket.wat))
- **C**: POSIX and Winsock cross-platform implementation ([target/c/socket_impl.c](target/c/socket_impl.c))

See [docs/FFI_IMPLEMENTATIONS_SUMMARY.md](docs/FFI_IMPLEMENTATIONS_SUMMARY.md) for detailed information about all FFI implementations, their current status, and integration requirements.

## Development

See [docs/DEVELOPMENT_PLAN.md](docs/DEVELOPMENT_PLAN.md) for detailed roadmap, architecture, and implementation phases.

### Running Tests

```bash
moon test
```

### Updating Tests

```bash
moon test --update
```

### Code Formatting

```bash
moon fmt
```

### Type Checking

```bash
moon check
```

### Project Status

**Main ibmoon Project**:
- ✅ Core types and structure implemented
- ✅ Protocol definitions complete
- ✅ Encoding/decoding layer implemented
- ✅ Connection manager with event handling
- ✅ High-level API wrapper
- ✅ Test suite (56/56 tests passing)
- ✅ Message handlers for 100+ IB API message types
- ✅ Integration tests with live IB API (read-only operations)

**Target-Specific Packages**:
- ✅ ibmoonjs: JavaScript FFI integration (Node.js) - Published v0.2.7
- ✅ ibmoonwa: WebAssembly FFI integration (WASI/WebSocket) - Published v0.2.6
- ✅ ibmoonc: C FFI integration (POSIX/Winsock) - Published v0.2.6

**Test Projects**:
- ✅ ibmoon_tests_js: JavaScript/Node.js examples
- ✅ ibmoon_tests_wa: WebAssembly examples
- ✅ ibmoon_tests_c: C/Native examples

**Known Issues**:
- ⚠️ MoonBit package publishing works but imports are non-functional
- ⚠️ Cannot use `moon add` to install packages - must use source code directly

See [docs/DEVELOPMENT_PLAN.md](docs/DEVELOPMENT_PLAN.md) for detailed roadmap and next steps.

## Contributing

Contributions are welcome! Please:

1. Fork the repository
2. Create a feature branch
3. Add tests for new functionality
4. Ensure all tests pass
5. Submit a pull request

## License

Apache-2.0

## Disclaimer

This software is for educational and development purposes only. Trading financial instruments involves substantial risk. Always test thoroughly with paper trading accounts before using with real money. The authors are not responsible for any financial losses incurred through the use of this software.

## Resources

### Documentation
- [IB API Documentation](https://interactivebrokers.github.io/)
- [MoonBit Documentation](https://docs.moonbitlang.com)
- [TWS API Guide](https://www.interactivebrokers.com/en/software/api/apiguide.htm)

### Project Documentation
- [Development Plan](docs/DEVELOPMENT_PLAN.md)
- [FFI Implementations Summary](docs/FFI_IMPLEMENTATIONS_SUMMARY.md)
- [Integration Tests Summary](docs/INTEGRATION_TESTS_SUMMARY.md)
- [Project Completion Summary](docs/PROJECT_COMPLETION_SUMMARY.md)
- [FFI Integration Guide](docs/FFI_INTEGRATION_GUIDE.md)
- [Contributing Guide](CONTRIBUTING.md)

### Repositories
- **Main**: https://github.com/emptist/ibmoon
- **JavaScript**: https://github.com/emptist/ibmoonjs
- **WebAssembly**: https://github.com/emptist/ibmoonwa
- **C/Native**: https://github.com/emptist/ibmoonc
- **Tests (JS)**: https://github.com/emptist/ibmoon_tests_js
- **Tests (WA)**: https://github.com/emptist/ibmoon_tests_wa
- **Tests (C)**: https://github.com/emptist/ibmoon_tests_c

## Support

For issues and questions:
- Open an issue on GitHub
- Check the documentation
- Review the test files for examples