module vending_machine_tb;
  reg clk;
  reg reset;
  reg coin_inserted;
  reg [1:0] coin_value;
  reg ticket_selected;
  reg [1:0] ticket_destination;
  wire ticket_dispensed;
  wire [1:0] change_value;
  wire change_returned;
  wire [3:0] station_coverage;

  // Instantiate the vending machine module
  vending_machine dut (
    .clk(clk),
    .reset(reset),
    .coin_inserted(coin_inserted),
    .coin_value(coin_value),
    .ticket_selected(ticket_selected),
    .ticket_destination(ticket_destination),
    .ticket_dispensed(ticket_dispensed),
    .change_value(change_value),
    .change_returned(change_returned),
    .station_coverage(station_coverage)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end

  // Test initialization
  initial begin
    clk = 0;
    reset = 1;
    coin_inserted = 0;
    coin_value = 0;
    ticket_selected = 0;
    ticket_destination = 0;

    // Reset initialization
    #10 reset = 0;

    // Insert 100 JPY coin
    #20 coin_inserted = 1;
    coin_value = 2'b10;

    // Select ticket for destination 2
    #10 ticket_selected = 1;
    ticket_destination = 2'b10;

    // Wait for ticket to be dispensed
    #30;

    // Insert 50 JPY coin
    #20 coin_inserted = 1;
    coin_value = 2'b01;

    // Select ticket for destination 1
    #10 ticket_selected = 1;
    ticket_destination = 2'b01;

    // Wait for ticket to be dispensed
    #30;

    // Insert 100 JPY coin
    #20 coin_inserted = 1;
    coin_value = 2'b10;

    // Select ticket for destination 3
    #10 ticket_selected = 1;
    ticket_destination = 2'b11;

    // Wait for ticket to be dispensed
    #30;

    // Insert 50 JPY coin
    #20 coin_inserted = 1;
    coin_value = 2'b01;

    // Select ticket for destination 0
    #10 ticket_selected = 1;
    ticket_destination = 2'b00;

    // Wait for ticket to be dispensed
    #30;

    // Insert invalid coin (10 JPY)
    #20 coin_inserted = 1;
    coin_value = 2'b00;

    // Select ticket for non-existing destination (10)
    #10 ticket_selected = 1;
    ticket_destination = 2'b10;

    // Wait for ticket to be dispensed
    #30;

    // Insert exact change for the most expensive ticket (450 JPY)
    #20 coin_inserted = 1;
    coin_value = 2'b10;
    #10 coin_inserted = 1;
    coin_value = 2'b10;
    #10 coin_inserted = 1;
    coin_value = 2'b10;
    #10 coin_inserted = 1;
    coin_value = 2'b10;

    // Select the most expensive ticket (destination 3)
    #10 ticket_selected = 1;
    ticket_destination = 2'b11;

    // Wait for ticket to be dispensed
    #30;

    // Insert more than enough money for the ticket (550 JPY)
    #20 coin_inserted = 1;
    coin_value = 2'b10;
    #10 coin_inserted = 1;
    coin_value = 2'b10;
    #10 coin_inserted = 1;
    coin_value = 2'b10;
    #10 coin_inserted = 1;
    coin_value = 2'b10;
    #10 coin_inserted = 1;
    coin_value = 2'b10;

    // Select a cheaper ticket (destination 1)
    #10 ticket_selected = 1;
    ticket_destination = 2'b01;

    // Wait for ticket to be dispensed
    #30;

    // End simulation
    $finish;
  end
endmodule
