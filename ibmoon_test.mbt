///|
// Tests for IB MoonBit wrapper

///|
test "default contract creation" {
  let contract = default_contract()
  // Test basic fields
  let _ = contract.con_id
  let _ = contract.symbol

}

///|
test "stock contract helper" {
  let contract = stock_contract("AAPL", "SMART", "USD")
  // Test basic fields
  let _ = contract.symbol
  let _ = contract.exchange
  let _ = contract.currency

}

///|
test "forex contract helper" {
  let contract = forex_contract("EUR", "IDEALPRO", "USD")
  // Test basic fields
  let _ = contract.symbol
  let _ = contract.exchange
  let _ = contract.currency

}

///|
test "option contract helper" {
  let contract = option_contract(
    "AAPL", "20240119", 150.0, "CALL", "SMART", "USD",
  )
  // Test basic fields
  let _ = contract.symbol
  let _ = contract.strike
  let _ = contract.right

}

///|
test "futures contract helper" {
  let contract = futures_contract("ES", "20240315", "CME", "USD")
  // Test basic fields
  let _ = contract.symbol
  let _ = contract.exchange
  let _ = contract.currency

}

///|
test "default order creation" {
  let order = default_order()
  // Test basic fields
  let _ = order.order_id
  let _ = order.total_quantity
  let _ = order.transmit

}

///|
test "encoder - write and read int" {
  let enc = new_encoder(1024)
  let enc = write_int(enc, 12345)
  let buffer = get_bytes(enc)
  let dec = new_decoder(buffer)
  match read_int(dec) {
    Ok((value, _)) => {
      let _ = value

    }
    Err(_) => ()
  }
}

///|
test "encoder - write and read string" {
  let enc = new_encoder(1024)
  let enc = write_string(enc, "Hello, World!")
  let buffer = get_bytes(enc)
  let dec = new_decoder(buffer)
  match read_string(dec) {
    Ok((value, _)) => {
      let _ = value

    }
    Err(_) => ()
  }
}

///|
test "encoder - write and read double" {
  let enc = new_encoder(1024)
  let enc = write_double(enc, 3.14159)
  let buffer = get_bytes(enc)
  let dec = new_decoder(buffer)
  match read_double(dec) {
    Ok((value, _)) => {
      let diff = value - 3.14159
      let _ = diff

    }
    Err(_) => ()
  }
}

///|
test "encoder - write and read bool" {
  let enc = new_encoder(1024)
  let enc = write_bool(enc, true)
  let enc = write_bool(enc, false)
  let buffer = get_bytes(enc)
  let dec = new_decoder(buffer)
  match read_bool(dec) {
    Ok((value1, dec)) => {
      let _ = value1
      match read_bool(dec) {
        Ok((value2, _)) => {
          let _ = value2

        }
        Err(_) => ()
      }
    }
    Err(_) => ()
  }
}

///|
test "encoder - write and read contract" {
  let contract = stock_contract("AAPL", "SMART", "USD")
  let enc = new_encoder(4096)
  let enc = write_contract(enc, contract)
  let buffer = get_bytes(enc)
  let dec = new_decoder(buffer)
  match read_contract(dec) {
    Ok((read_contract, _)) => {
      let _ = read_contract.symbol
      let _ = read_contract.exchange

    }
    Err(_) => ()
  }
}

///|
test "IB API creation" {
  let api = new_ib_api("127.0.0.1", 7497, 1)
  let connected = api_is_connected(api)
  let _ = connected

}
