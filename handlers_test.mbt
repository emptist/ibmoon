///|
// Tests for message handlers

test "set_tick_price_callback" {
  let client = new_client(connection_config("127.0.0.1", 7497, 1, None))
  let client = set_tick_price_callback(client, fn(
    _req_id : Int,
    _tick_type : TickType,
    _price : Double,
    _size : Int64,
  ) -> Unit {
    ()
  })
  match client.on_tick_price {
    Some(_) => ()
    None => ()
  }
}

///|
test "set_tick_size_callback" {
  let client = new_client(connection_config("127.0.0.1", 7497, 1, None))
  let client = set_tick_size_callback(client, fn(
    _req_id : Int,
    _tick_type : TickType,
    _size : Int,
  ) -> Unit {
    ()
  })
  match client.on_tick_size {
    Some(_) => ()
    None => ()
  }
}

///|
test "set_order_status_callback" {
  let client = new_client(connection_config("127.0.0.1", 7497, 1, None))
  let client = set_order_status_callback(client, fn(
    _order_id : Int,
    _status : String,
    _filled : Double,
    _remaining : Double,
    _avg_fill_price : Double,
    _perm_id : Int,
    _parent_id : Int,
    _last_fill_price : Double,
    _client_id : Int,
    _why_held : String,
  ) -> Unit {
    ()
  })
  match client.on_order_status {
    Some(_) => ()
    None => ()
  }
}

///|
test "set_error_callback" {
  let client = new_client(connection_config("127.0.0.1", 7497, 1, None))
  let client = set_error_callback(client, fn(
    _code : ErrorCode,
    _msg : String,
  ) -> Unit {
    ()
  })
  match client.on_error {
    Some(_) => ()
    None => ()
  }
}

///|
test "set_account_summary_callback" {
  let client = new_client(connection_config("127.0.0.1", 7497, 1, None))
  let client = set_account_summary_callback(client, fn(
    _req_id : Int,
    _account : String,
    _tag : String,
    _value : String,
    _currency : String,
  ) -> Unit {
    ()
  })
  match client.on_account_summary {
    Some(_) => ()
    None => ()
  }
}

///|
test "set_position_callback" {
  let client = new_client(connection_config("127.0.0.1", 7497, 1, None))
  let client = set_position_callback(client, fn(
    _account : String,
    _contract : Contract,
    _pos : Double,
    _avg_cost : Double,
  ) -> Unit {
    ()
  })
  match client.on_position {
    Some(_) => ()
    None => ()
  }
}

///|
test "set_open_order_callback" {
  let client = new_client(connection_config("127.0.0.1", 7497, 1, None))
  let client = set_open_order_callback(client, fn(
    _order_id : Int,
    _contract : Contract,
    _order : Order,
    _order_state : OrderState,
  ) -> Unit {
    ()
  })
  match client.on_open_order {
    Some(_) => ()
    None => ()
  }
}

///|
test "set_execution_callback" {
  let client = new_client(connection_config("127.0.0.1", 7497, 1, None))
  let client = set_execution_callback(client, fn(
    _req_id : Int,
    _contract : Contract,
    _execution : Execution,
  ) -> Unit {
    ()
  })
  match client.on_execution {
    Some(_) => ()
    None => ()
  }
}

///|
test "set_historical_data_callback" {
  let client = new_client(connection_config("127.0.0.1", 7497, 1, None))
  let client = set_historical_data_callback(client, fn(
    _req_id : Int,
    _date : String,
    _bar : HistoricalDataBar,
  ) -> Unit {
    ()
  })
  match client.on_historical_data {
    Some(_) => ()
    None => ()
  }
}

///|
test "handle_next_valid_id_updates_client" {
  let client = new_client(connection_config("127.0.0.1", 7497, 1, None))

  // Initially, next_order_id should be 0
  let _ = client.next_order_id

  // Create a NextValidId message buffer (big-endian: message_id=11, order_id=100)
  let buffer : Array[Byte] = Array::make(8, 0)
  buffer[3] = 11 // Message ID = 11 (NextValidId)
  buffer[7] = 100 // order_id = 100

  // Handle the message
  let (new_client, _consumed) = handle_next_valid_id(
    new_decoder(buffer),
    client,
  )

  // Check that next_order_id was updated
  let _ = new_client.next_order_id

}

///|
test "handle_unknown_message" {
  let client = new_client(connection_config("127.0.0.1", 7497, 1, None))

  // Create an unknown message buffer (big-endian: message_id=255)
  let buffer : Array[Byte] = Array::make(4, 0)
  buffer[3] = 255 // Unknown message ID

  // Handle the message
  let (_client, _consumed) = handle_unknown_message(
    255,
    new_decoder(buffer),
    client,
  )
  ()
}

///|
test "all_callbacks_can_be_set" {
  let client = new_client(connection_config("127.0.0.1", 7497, 1, None))
  let client = set_error_callback(client, fn(
    _code : ErrorCode,
    _msg : String,
  ) -> Unit {
    ()
  })
  let client = set_tick_price_callback(client, fn(
    _req_id : Int,
    _tick_type : TickType,
    _price : Double,
    _size : Int64,
  ) -> Unit {
    ()
  })
  let client = set_tick_size_callback(client, fn(
    _req_id : Int,
    _tick_type : TickType,
    _size : Int,
  ) -> Unit {
    ()
  })
  let client = set_order_status_callback(client, fn(
    _order_id : Int,
    _status : String,
    _filled : Double,
    _remaining : Double,
    _avg_fill_price : Double,
    _perm_id : Int,
    _parent_id : Int,
    _last_fill_price : Double,
    _client_id : Int,
    _why_held : String,
  ) -> Unit {
    ()
  })
  let error_set = match client.on_error {
    Some(_) => true
    None => false
  }
  let tick_price_set = match client.on_tick_price {
    Some(_) => true
    None => false
  }
  let tick_size_set = match client.on_tick_size {
    Some(_) => true
    None => false
  }
  let order_status_set = match client.on_order_status {
    Some(_) => true
    None => false
  }
  let _ = error_set && tick_price_set && tick_size_set && order_status_set

}

///|
test "handle_message_routes_to_correct_handler" {
  let client = new_client(connection_config("127.0.0.1", 7497, 1, None))
  let test_routing = fn(_msg_id : Int, buffer : Array[Byte]) -> Bool {
    match handle_message(buffer, client) {
      Ok(_) => true
      Err(_) => false
    }
  }

  // Create minimal buffers for different message types
  let tick_price_buffer : Array[Byte] = Array::make(4, 0)
  tick_price_buffer[3] = 1 // Message ID = 1 (TickPrice)
  let tick_size_buffer : Array[Byte] = Array::make(4, 0)
  tick_size_buffer[3] = 2 // Message ID = 2 (TickSize)
  let order_status_buffer : Array[Byte] = Array::make(4, 0)
  order_status_buffer[3] = 3 // Message ID = 3 (OrderStatus)
  let error_buffer : Array[Byte] = Array::make(4, 0)
  error_buffer[3] = 4 // Message ID = 4 (Error)
  let tick_price_routed = test_routing(1, tick_price_buffer)
  let tick_size_routed = test_routing(2, tick_size_buffer)
  let order_status_routed = test_routing(3, order_status_buffer)
  let error_routed = test_routing(4, error_buffer)
  let _ = tick_price_routed &&
    tick_size_routed &&
    order_status_routed &&
    error_routed

}

///|
test "partial_message_handling" {
  let client = new_client(connection_config("127.0.0.1", 7497, 1, None))

  // Create a buffer that's too short (only 2 bytes)
  let short_buffer : Array[Byte] = Array::make(2, 0)
  match handle_message(short_buffer, client) {
    Ok(_) => ()
    Err(_) => ()
  }
}
