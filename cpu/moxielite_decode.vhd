-- Implementation of moxielite
LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;
USE work.moxielite_package.ALL;
 
ENTITY moxielite_decode IS
	PORT
	(
		Instruction : in std_logic_vector(15 downto 0);		
		ExecuteState : out state_type;
		Condition : out condition_type;
		AddrMode : out addrmode_type;
		AluOp : out aluop_type;
		InstructionForm : out instruction_form_type;
		PtrSize : out std_logic_vector(2 downto 0)
	);
END moxielite_decode;
 
ARCHITECTURE behavior OF moxielite_decode IS 
BEGIN

	decode_instruction : process(Instruction)
	begin

		-- Defaults;
		ExecuteState <= state_execute_bad;
		AddrMode <= addrmode_narg;
		Condition <= condition_eq;
		AluOp <= aluop_none;
		InstructionForm <= form_1;
		PtrSize <= "XXX";
		
		if Instruction(15)='0' then

			-- Form 1
			InstructionForm <= form_1;
			Condition <= condition_eq;
			case "0" & Instruction(14 downto 8) is
				when x"00" => 
					-- bad
					AddrMode <= addrmode_narg; 		
					ExecuteState <= state_execute_bad;

				when x"01" => 
					-- ldi.l
					AddrMode <= addrmode_a_imm;   	
					ExecuteState <= state_execute_alu; 		
					AluOp <= aluop_mov;

				when x"02" => 
					-- mov
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_mov;

				when x"03" => 
					-- jsra
					AddrMode <= addrmode_imm;    		
					ExecuteState <= state_execute_jsr;

				when x"04" => 
					-- ret
					AddrMode <= addrmode_narg; 		
					ExecuteState <= state_execute_ret;

				when x"05" => 
					-- add.l
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_add;

				when x"06" => 
					-- push
					AddrMode <= addrmode_a_lit4;   		
					AluOp <= aluop_sub;
					ExecuteState <= state_execute_push;

				when x"07" => 
					-- pop
					AddrMode <= addrmode_a_lit4;   		
					AluOp <= aluop_add;
					ExecuteState <= state_execute_pop;

				when x"08" => 
					-- lda.l
					AddrMode <= addrmode_a_immptr;  	
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_mov;  
					PtrSize <= "100";

				when x"09" => 
					-- sta_l;
					AddrMode <= addrmode_immptr_a;  	
					ExecuteState <= state_execute_store;  						 
					PtrSize <= "100"; 

				when x"0a" => 
					-- ld.l;
					AddrMode <= addrmode_a_bptr;  	
					ExecuteState <= state_execute_alu; 		
					AluOp <= aluop_mov;  
					PtrSize <= "100"; 

				when x"0b" => 
					-- st.l
					AddrMode <= addrmode_aptr_b;  	
					ExecuteState <= state_execute_store;						 
					PtrSize <= "100";

				when x"0c" => 
					-- ldo.l
					AddrMode <= addrmode_a_bptro; 	
					ExecuteState <= state_execute_alu;      
					AluOp <= aluop_mov;  
					PtrSize <= "100"; 

				when x"0d" => 
					-- sto.l
					AddrMode <= addrmode_aptro_b; 	
					ExecuteState <= state_execute_store;						 
					PtrSize <= "100";

				when x"0e" => 
					-- sub.l
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_cmp;		
					AluOp <= aluop_sub;

				when x"0f" => 
					-- nop
					AddrMode <= addrmode_narg; 		
					ExecuteState <= state_execute_nop;

				when x"19" => 
					-- jsr
					AddrMode <= addrmode_ab;    		
					ExecuteState <= state_execute_jsr;

				when x"1a" => 
					-- jmp
					AddrMode <= addrmode_imm;    		
					ExecuteState <= state_execute_jmp;

				when x"1b" => 
					-- ldi.b
					AddrMode <= addrmode_a_imm;   	
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_mov;

				when x"1c" => 
					-- ld.b
					AddrMode <= addrmode_a_bptr; 		
					ExecuteState <= state_execute_alu;      
					AluOp <= aluop_mov; 
					PtrSize <= "001";

				when x"1d" => 
					-- lda.b
					AddrMode <= addrmode_a_immptr;    
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_mov; 
					PtrSize <= "001";

				when x"1e" => 
					-- st.b
					AddrMode <= addrmode_aptr_b;      
					ExecuteState <= state_execute_store;                        
					PtrSize <= "001";

				when x"1f" => 
					-- sta.b
					AddrMode <= addrmode_immptr_a;    
					ExecuteState <= state_execute_store;	                    
					PtrSize <= "001";

				when x"20" => 
					-- ldi.s
					AddrMode <= addrmode_a_imm;   	
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_mov;

				when x"21" => 
					-- ld.s
					AddrMode <= addrmode_a_bptr;      
					ExecuteState <= state_execute_alu;      
					AluOp <= aluop_mov; 
					PtrSize <= "010"; 

				when x"22" => 
					-- lda.s
					AddrMode <= addrmode_a_immptr;    
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_mov; 
					PtrSize <= "010"; 

				when x"23" => 
					-- st.s
					AddrMode <= addrmode_aptr_b;      
					ExecuteState <= state_execute_store;                        
					PtrSize <= "010"; 

				when x"24" => 
				 	-- sta.s
					AddrMode <= addrmode_immptr_a;    
					ExecuteState <= state_execute_store; 	                    
					PtrSize <= "010";

				when x"25" => 
					-- jmp
					AddrMode <= addrmode_ab;    		
					ExecuteState <= state_execute_jmp;

				when x"26" => 
					-- and
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_and;

				when x"27" => 
					-- lshr
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_shr;

				when x"28" => 
					-- ashl
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_shl;

				when x"29" => 
					-- sub.l
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_sub;

				when x"2a" => 
					-- neg
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_neg;

				when x"2b" => 
					-- or
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_or;

				when x"2c" => 
					-- not
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_not;

				when x"2d" => 
					-- ashr
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_sar;

				when x"2e" =>
					-- xor
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_xor;

				when x"2f" => 
					-- mul
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu2;		
					AluOp <= aluop_mul;

				when x"30" => 
					-- swi
					AddrMode <= addrmode_imm;    		
					ExecuteState <= state_execute_swi;

				when x"31" => 
					-- div.l
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu2;		
					AluOp <= aluop_div;

				when x"32" => 
					-- udiv.l
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu2;		
					AluOp <= aluop_udiv;

				when x"33" => 
					-- mod.l
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu2;		
					AluOp <= aluop_mod;

				when x"34" => 
					-- umod.l
					AddrMode <= addrmode_ab;   		
					ExecuteState <= state_execute_alu2;		
					AluOp <= aluop_umod;

				when x"35" => 
					-- brk
					AddrMode <= addrmode_narg; 		
					ExecuteState <= state_execute_brk;

				when x"36" => 
					-- ldo.b
					AddrMode <= addrmode_a_bptro;     
					ExecuteState <= state_execute_alu;		
					AluOp <= aluop_mov; 
					PtrSize <= "001";

				when x"37" => 	
					-- sto.b
					AddrMode <= addrmode_aptro_b; 	
					ExecuteState <= state_execute_store;                       
					PtrSize <= "001";

				when x"38" => 
					-- ldo.s
					AddrMode <= addrmode_a_bptro; 	
					ExecuteState <= state_execute_alu;      
					AluOp <= aluop_mov; 
					PtrSize <= "010";

				when x"39" => 
					-- sto.s
					AddrMode <= addrmode_aptro_b; 	
					ExecuteState <= state_execute_store;                        
					PtrSize <= "010"; -- sto_s;

				when others => 	
					AddrMode <= addrmode_narg;		
					ExecuteState <= state_execute_bad;

			end case;		

		elsif Instruction(15 downto 14)="10" then

			-- Form 2
			InstructionForm <= form_2;
			AddrMode <= addrmode_a8v;
			case Instruction(13 downto 12) is

				when "00" => 
					-- inc
					ExecuteState <= state_execute_alu; 
					AluOp <= aluop_add;

				when "01" => 
					-- dec
					ExecuteState <= state_execute_alu; 
					AluOp <= aluop_sub;

				when "10" => 
					ExecuteState <= state_execute_gsr;

				when "11" => 
					ExecuteState <= state_execute_ssr;

				when others => 
					AddrMode <= addrmode_narg; 
					ExecuteState <= state_execute_bad;

			end case;

		else

			-- Form 3
			InstructionForm <= form_3;
			AddrMode <= addrmode_pcrel;
			case Instruction(13 downto 10) is

				when x"0" => 
					-- beq
					ExecuteState <= state_execute_bcc; 
					condition <= condition_eq;

				when x"1" => 
					-- bne
					ExecuteState <= state_execute_bcc; 
					condition <= condition_ne;

				when x"2" => 
					-- blt
					ExecuteState <= state_execute_bcc; 
					condition <= condition_lt;

				when x"3" => 
					-- bgt
					ExecuteState <= state_execute_bcc; 
					condition <= condition_gt;

				when x"4" => 
					-- bltu
					ExecuteState <= state_execute_bcc; 
					condition <= condition_ltu;

				when x"5" => 
					-- bgtu
					ExecuteState <= state_execute_bcc; 
					condition <= condition_gtu;

				when x"6" => 
					-- bge
					ExecuteState <= state_execute_bcc; 
					condition <= condition_ge;

				when x"7" => 
					-- ble
					ExecuteState <= state_execute_bcc; 
					condition <= condition_le;

				when x"8" => 
					-- bgeu
					ExecuteState <= state_execute_bcc; 
					condition <= condition_geu;

				when x"9" => 
					-- bleu
					ExecuteState <= state_execute_bcc; 
					condition <= condition_leu;

				when others => 
					ExecuteState <= state_execute_bad;

			end case;


		end if;

	end process decode_instruction;

END;
