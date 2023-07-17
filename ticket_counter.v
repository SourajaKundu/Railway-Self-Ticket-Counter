module vending_machine (
  input wire clk,
  input wire reset,
  input wire coin_inserted,
  input wire [1:0] coin_value,
  input wire ticket_selected,
  input wire [1:0] ticket_destination,
  output wire ticket_dispensed,
  output wire [1:0] change_value,
  output wire change_returned,
  output wire [3:0] station_coverage
);
  // State definition
  typedef enum logic [3:0] {
    IDLE,
    COIN_INSERTED,
    TICKET_SELECTED,
    CHANGE_RETURNED,
    TICKET_DISPENSED
  } state_t;

  // Internal signals
  reg [3:0] current_state;
  reg [3:0] next_state;
  reg [1:0] selected_destination;
  reg [1:0] selected_price;
  reg [1:0] inserted_coins;
  reg [1:0] change;
  reg ticket_dispensed;
  reg change_returned;
  reg [3:0] coverage;

  // Price lookup table
  reg [7:0] price_table [0:3] = '{8'd150, 8'd200, 8'd300, 8'd450};

  // State machine
  always @(posedge clk) begin
    if (reset) begin
      current_state <= IDLE;
      next_state <= IDLE;
      selected_destination <= 0;
      selected_price <= 0;
      inserted_coins <= 0;
      change <= 0;
      ticket_dispensed <= 0;
      change_returned <= 0;
      coverage <= 0;
    end else begin
      current_state <= next_state;
      case (current_state)
        IDLE:
          if (coin_inserted) begin
            next_state <= COIN_INSERTED;
            inserted_coins <= coin_value;
            selected_price <= 0;
            selected_destination <= 0;
            coverage <= 0;
          end else if (ticket_selected) begin
            next_state <= TICKET_SELECTED;
            selected_destination <= ticket_destination;
            selected_price <= price_table[selected_destination];
            inserted_coins <= 0;
            coverage <= 0;
          end
        COIN_INSERTED:
          if (coin_inserted) begin
            next_state <= COIN_INSERTED;
            inserted_coins <= inserted_coins + coin_value;
          end else if (ticket_selected) begin
            next_state <= TICKET_SELECTED;
            selected_destination <= ticket_destination;
            selected_price <= price_table[selected_destination];
            inserted_coins <= 0;
            coverage <= 0;
          end else if (inserted_coins >= selected_price) begin
            next_state <= TICKET_DISPENSED;
            change <= inserted_coins - selected_price;
            coverage <= 0;
          end else begin
            next_state <= CHANGE_RETURNED;
            change <= inserted_coins;
            coverage <= get_coverage(inserted_coins);
          end
        TICKET_SELECTED:
          if (coin_inserted) begin
            next_state <= COIN_INSERTED;
            inserted_coins <= coin_value;
            selected_price <= 0;
            selected_destination <= 0;
            coverage <= 0;
          end else if (ticket_selected) begin
            next_state <= TICKET_SELECTED;
            selected_destination <= ticket_destination;
            selected_price <= price_table[selected_destination];
            inserted_coins <= 0;
            coverage <= 0;
          end else if (inserted_coins >= selected_price) begin
            next_state <= TICKET_DISPENSED;
            change <= inserted_coins - selected_price;
            coverage <= 0;
          end else begin
            next_state <= CHANGE_RETURNED;
            change <= inserted_coins;
            coverage <= get_coverage(inserted_coins);
          end
        CHANGE_RETURNED:
          next_state <= IDLE;
        TICKET_DISPENSED:
          if (coin_inserted || ticket_selected) begin
            next_state <= IDLE;
            ticket_dispensed <= 0;
            change_returned <= 0;
            inserted_coins <= 0;
            change <= 0;
            selected_price <= 0;
            selected_destination <= 0;
            coverage <= 0;
          end
      endcase
    end
  end

  // Output logic
  always @(current_state) begin
    case (current_state)
      IDLE:
        ticket_dispensed <= 0;
        change_returned <= 0;
        change_value <= 0;
      COIN_INSERTED:
        ticket_dispensed <= 0;
        change_returned <= 0;
        change_value <= 0;
      TICKET_SELECTED:
        ticket_dispensed <= 0;
        change_returned <= 0;
        change_value <= 0;
      CHANGE_RETURNED:
        ticket_dispensed <= 0;
        change_returned <= 1;
        change_value <= change;
      TICKET_DISPENSED:
        ticket_dispensed <= 1;
        change_returned <= 0;
        change_value <= 0;
    endcase
  end

  // Output coverage logic
  always @(inserted_coins) begin
    coverage <= get_coverage(inserted_coins);
  end

  // Function to determine station coverage
  function [3:0] get_coverage;
    input [1:0] coins;
    begin
      case (coins)
        2'b00: return 4'b1111; // All stations can be covered
        2'b01: return 4'b1110; // Stations 0, 1, 2 can be covered
        2'b10: return 4'b1100; // Stations 0, 1 can be covered
        2'b11: return 4'b1000; // Station 0 can be covered
        default: return 4'b0000; // No stations can be covered
      endcase
    end
  endfunction

endmodule
