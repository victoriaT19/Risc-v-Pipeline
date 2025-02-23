`timescale 1ns / 1ps

module ALUController (
    //Inputs
    input logic [1:0] ALUOp,  // 2-bit opcode field from the Controller--00: LW/SW/AUIPC; 01:Branch; 10: Rtype/Itype; 11:JAL/LUI
    input logic [6:0] Funct7,  // bits 25 to 31 of the instruction
    input logic [2:0] Funct3,  // bits 12 to 14 of the instruction

    //Output
    output logic [3:0] Operation  // operation selection for ALU
);

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


endmodule
