`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 2017/08/12 09:42:24
// Design Name: 
// Module Name: ahb_bus_if
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////

`include "defines.vh"
module ahb_bus_if(
	input wire clk,
	input wire rst,

	//from ctrl
	input wire[5:0] stall_i,
	input wire flush_i,

	//CPU side
	input wire cpu_ce_i,
	input wire[`RegBus] cpu_data_i,
	input wire[`RegBus] cpu_addr_i,
	input wire cpu_we_i,
	input wire[3:0] cpu_sel_i,
	output reg[`RegBus] cpu_data_o,
	//ahb bus side
	input wire addr_ok,
	input wire data_ok,
	input wire[`RegBus] dout,
	output reg[`RegBus] addr,
	output reg[`RegBus] din,
	output reg wr,
	output reg[3:0] ben,

	output reg stallreq
    );

	reg[1:0] state;
	reg[`RegBus] rd_buf;

	always @(posedge clk) begin
		if(rst == `RstEnable) begin
			 state <= `AHB_IDLE;
			 addr <= `ZeroWord;
			 din <= `ZeroWord;
			 wr <= `WriteDisable;
			 ben <= 4'b0000;
			 rd_buf <= `ZeroWord;
		end else begin
			 case (state)
			 	`AHB_IDLE:begin
			 		if((cpu_ce_i == 1'b1) && (flush_i == `False_v) && (addr_ok == 1'b1)) begin
			 			/* code */
				 		state <= `AHB_BUSY;
						case (cpu_addr_i[31:28])
							4'hb:begin 
								addr <= {4'h1,cpu_addr_i[27:0]};
							end
							4'h8:begin 
								addr <= {4'h0,cpu_addr_i[27:0]};
							end
							default : begin 
								addr <= cpu_addr_i;
							end
						endcase
						din <= cpu_data_i;
						wr <= cpu_we_i;
						ben <= cpu_sel_i;
						rd_buf <= `ZeroWord;
				 	end
			 	end
				`AHB_BUSY:begin 
					if(data_ok == 1'b1) begin
						/* code */
						state <= `AHB_IDLE;
						addr <= `ZeroWord;
						din <= `ZeroWord;
						wr <= `WriteDisable;
						ben <= 4'b0000;
						if(cpu_we_i == `WriteDisable) begin
							/* code */
							rd_buf <= dout;
						end
						if(stall_i != 6'b000000) begin
							/* code */
							state <= `AHB_WAIT_FOR_STALL;
						end
					end else if(flush_i == `True_v) begin
						/* code */
						state <= `AHB_IDLE;
						addr <= `ZeroWord;
						din <= `ZeroWord;
						wr <= `WriteDisable;
						ben <= 4'b0000;
						rd_buf <= `ZeroWord;
					end else begin 
						addr <= `ZeroWord;
						din <= `ZeroWord;
						wr <= `WriteDisable;
						ben <= 4'b0000;
					end
				end
				`AHB_WAIT_FOR_STALL:begin 
					if(stall_i == 6'b000000) begin
						/* code */
						state <= `AHB_IDLE;
					end
				end
			 	default : /* default */;
			 endcase
		end
	end

	always @(*) begin
		if(rst == `RstEnable) begin
			/* code */
			stallreq <= `NoStop;
			cpu_data_o <= `ZeroWord;
		end else begin 
			stallreq <= `NoStop;
			case (state)
				`AHB_IDLE:begin 
					if((cpu_ce_i == 1'b1) && (flush_i == `False_v) && (addr_ok == 1'b1)) begin
						/* code */
						stallreq <= `Stop;
						cpu_data_o <= `ZeroWord;
					end
				end
				`AHB_BUSY:begin 
					if(data_ok == 1'b1) begin
						/* code */
						stallreq <= `NoStop;
						if(wr == `WriteDisable) begin
							/* code */ 
							cpu_data_o <= dout;
						end else begin 
							cpu_data_o <= `ZeroWord;
						end
					end else begin 
						stallreq <= `Stop;
						cpu_data_o <= `ZeroWord;
					end
				end
				`AHB_WAIT_FOR_STALL:begin 
					stallreq <= `NoStop;
					cpu_data_o <= rd_buf;
				end
				default : /* default */;
			endcase
		end
	
	end
endmodule
