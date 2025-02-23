`timescale 1ns / 1ps

module ALUController (
    //Inputs
    input logic [1:0] ALUOp,  // 2-bit opcode field from the Controller--00: LW/SW/AUIPC; 01:Branch; 10: Rtype/Itype; 11:JAL/LUI
    input logic [6:0] Funct7,  // bits 25 to 31 of the instruction
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction

    //Output
    output logic [3:0] Operation  // operation selection for ALU
);

/*
11	SLTI	((ALUOp == 2'b10) && (Funct3 == 3'b010) && (Funct7 == 7'b0000000)) essa já ta implementada com slt
12	ADDI	((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7'b0000000)) essa já ta implementada com o add
13	SLLI	((ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000)) já implemntei
14	SRLI	((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) implementada
15	SRAI	((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) IMPLEMENTADA
3	BNE	((ALUOp == 2'b01) && (Funct3 == 3'b001)) feito
4	BLT	((ALUOp == 2'b01) && (Funct3 == 3'b100)) feita 
5	BGE	((ALUOp == 2'b01) && (Funct3 == 3'b101)) feito
*/

	always_comb
		begin
		     if(ALUOp == 2'b00)begin // mapeando as instruções de load/store e jalr para a operação de ADD
			Operation = 4'b0010;
		     end else if(ALUOp == 2'b01)begin
			case(Funct3)
			3'b000: 
				Operation = 4'b1001; //BEQ
			3'b001: 
				Operation = 4'b1010; //BNE
			3'b100:
				Operation = 4'b1011; //BLT

			/*COLOCANDO O BLTU E BGEU SO PARA TESTAR A SIMULAÇÃO*/
                        3'b110: Operation = 4'b1011; //BLTU
			3'b111: Operation = 4'b1100; //BGEU 

			3'b101:
				Operation = 4'b1100; //BGE
			default:
				Operation = 4'b0000;
			endcase
		     end else if(ALUOp == 2'b10)begin
			case(Funct3)
			3'b000: begin //ADD - ADDI - SUB
				if(Funct7 == 7'b0100000)begin // SUB
				   Operation = 4'b0100; 
				end
				else Operation = 4'b0010; // ADD - ADDI
			end
			3'b110: //OR
				Operation = 4'b0001;
			3'b100: //XOR
				Operation = 4'b0011;
			3'b010: //SLT - SLTI
				Operation = 4'b0101;

                        3'b011: Operation = 4'b0101; //testando sltu e sltiu pq tem em uma das simulações

			3'b001: // SLLI - SLL(funciona tambem)
				Operation = 4'b0110;
			3'b101:begin
				if(Funct7 == 7'b0000000) begin //SRLI
				   Operation = 4'b0111;
				end
				else if(Funct7 == 7'b0100000) begin //SRAI
				    Operation = 4'b1000;
				end
		        end
			3'b111:
				Operation = 4'b0000; // AND
			default:
				Operation = 4'b0000; 
			endcase
		     end else if(ALUOp == 2'b11) begin // JAL
			Operation = 4'b1101;
                     end
		end

/*
  assign Operation[0] = ((ALUOp == 2'b10) && (Funct3 == 3'b110)) ||  // R\I-or 
      ((ALUOp == 2'b10) && (Funct3 == 3'b100)) || // XOR
      ((ALUOp == 2'b10) && (Funct3 == 3'b010)); || // R\I-<  SLT
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||  // SLRI
      (ALUOp == 2'b01) ||  // BEQ
      ((ALUOp == 2'b01) && (Funct3 == 3'b100)) // BLT

  assign Operation[1] = (ALUOp == 2'b00) ||  // LW\SW feito
      ((ALUOp == 2'b10) && (Funct3 == 3'b000)) ||  // R\I-add feito
      ((ALUOp == 2'b10) && (Funct3 == 3'b100)) || // XOR
      ((ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000)) // SLLI
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||  // SLRI
      ((ALUOp == 2'b01) && (Funct3 == 3'b001)) || // BNE
      ((ALUOp == 2'b01) && (Funct3 == 3'b100)) // BLT

  assign Operation[2] = ((ALUOp == 2'b10) && (Funct3 == 3'b000) && (Funct7 == 7b'0100000))|| // SUB
      ((ALUOp == 2'b10) && (Funct3 == 3'b010));  // R\I-< slt
      ((ALUOp == 2'b10) && (Funct3 == 3'b001) && (Funct7 == 7'b0000000)) || // SLLI
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0000000)) ||  // SLRI
      ((ALUOp == 2'b01) && (Funct3 == 3'b101)) // BGE

  assign Operation[3] = (ALUOp == 2'b01) ||  // BEQ
      ((ALUOp == 2'b10) && (Funct3 == 3'b101) && (Funct7 == 7'b0100000)) || // SRAI
      ((ALUOp == 2'b01) && (Funct3 == 3'b001)) || // BNE
      ((ALUOp == 2'b01) && (Funct3 == 3'b100)) || // BLT
      ((ALUOp == 2'b01) && (Funct3 == 3'b101)) //BGE
*/

endmodule
