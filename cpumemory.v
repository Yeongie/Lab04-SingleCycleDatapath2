//=========================================================================
// Name & Email must be EXACTLY as in Gradescope roster!
// Name: 
// Email: 
// 
// Assignment name: 
// Lab section: 
// TA: 
// 
// I hereby certify that I have not received assistance on this assignment,
// or used code, from ANY outside source other than the instruction team
// (apart from what was provided in the starter file).
//
//=========================================================================

//=========================================================================
//
// DO NOT CHANGE ANYTHING BELOW THIS COMMENT. IT IS PROVIDED TO MAKE SURE 
// YOUR LAB IS SUCCESSFULL. 
//
//=========================================================================

`timescale 1ns / 1ps

`define NULL 0
`define MAX_REG 256

module cpumemory #(parameter WORD_SIZE=32,FILENAME="init.coe") (
    input wire clk,
    input wire rst,
    input wire[7:0] instr_addr,
    output wire[WORD_SIZE-1:0] instr_val,
    input wire data_write_en,   
    input [7:0] data_addr,    
    input wire[WORD_SIZE-1:0] data_val_in ,    
    output wire[WORD_SIZE-1:0] data_val_out  
);

// ------------------------------------------
// Init memory 
// ------------------------------------------
	
reg [WORD_SIZE-1:0] buff [`MAX_REG-1:0];

initial begin 
	$readmemb(FILENAME, buff,0,255);
end 

// ------------------------------------------
// Read and Write block 
// ------------------------------------------ 

assign instr_val = buff[instr_addr];
assign data_val_out = buff[data_addr];
	
always @(posedge clk) begin 
	if (data_write_en) begin 
	    buff[data_addr] = data_val_in;
	end
end 
endmodule
