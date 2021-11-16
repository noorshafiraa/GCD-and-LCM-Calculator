library IEEE; 
use IEEE.std_logic_1164.all; 
use IEEE.std_logic_arith.all; 
use IEEE.std_logic_unsigned.all; 

entity fsm is 
	port( rst, clk, proses, switch, start				: in std_logic;
			FPB_AB, FPB_CD, FPB_ABCD			: in std_logic_vector(0 downto 0);
			compare						: in std_logic_vector( 1 downto 0 ); 
			enable, Sel_X, Sel_Y, Sel_A, Sel_B, Sel_C, Sel_D, Sel_AB, Sel_CD : out std_logic;
			Load_A, Load_B, Load_C, Load_D, Load_FPB_AB, Load_FPB_CD, En_X, En_Y : out std_logic
		); 
end fsm;

architecture fsm_arc of fsm is 
	
	-- state fsm yang digunakan
	type Langkah is ( Ready, Idle, Load_ABCDXY, Banding, Kurang_AB, Kurang_BA, Kurang_CD, Kurang_DC, 
							Kurang_FPB_AB_CD, Kurang_FPB_CD_AB, 
							Tambah_XX, Tambah_YY, Output_FPB, Output_KPK ); 
	signal nState, cState: Langkah; 
	
begin 

	-- proses pertama untuk perpindahan cstate ke nstate pada perubahan clock jika tidak reset
	process( rst, clk ) 
	begin
	 
		if( rst = '1' ) then
			cState <= Ready;
		elsif( clk'event and clk = '1' ) then 
			cState <= nState;
		end if; 
	
	end process; 

	-- proses kedua berisi Langkah state (FSM Utama)
	process( proses, compare, cState, start, switch, FPB_AB, FPB_CD, FPB_ABCD ) 
	begin 
	
		case cState is 
		-- Langkah mengecek mulai tidaknya penghitungan
		when Ready =>
			if( proses = '0' ) then 
				nState <= Ready; 
			else 
				nState <= Idle; 
			end if; 
			
		-- Langkah menreset kontrol register
		when Idle => 
			enable <= '0'; 
			if ( switch = '0' ) then  -- input untuk FPB
				Sel_A <= '0'; 
				Sel_B <= '0'; 
				Sel_C <= '0'; 
				Sel_D <= '0'; 
				Sel_AB <= '0'; 
				Sel_CD <= '0';
				Load_A <= '0'; 
				Load_B <= '0';
				Load_C <= '0';
				Load_B <= '0';
				Load_FPB_AB <= '0';
				Load_FPB_CD <= '0';
				if ( start = '0' ) then
					nState <= Load_ABCDXY;
				else
					nState <= Idle;
				end if;
			else
				En_X <= '0';
				En_Y <= '0';
				if ( start = '0' ) then
					nState <= Load_ABCDXY;
				else
					nState <= Idle;
				end if;
			end if;
			
		-- Langkah memasukan input ke register (Load ke register)
		when Load_ABCDXY => 
			enable <= '0';
			if ( switch = '0' ) then  -- input untuk FPB
				Sel_A <= '0'; 
				Sel_B <= '0'; 
				Sel_C <= '0'; 
				Sel_D <= '0'; 
				Sel_AB <= '0'; 
				Sel_CD <= '0'; 
				Load_A <= '1'; 
				Load_B <= '1';
				Load_C <= '1';
				Load_D <= '1';
				Load_FPB_AB <= '1';
				Load_FPB_CD <= '1';
				nState <= Banding;
			else  -- input untuk KPK
				Sel_X <= '0'; 
				Sel_Y <= '0'; 
				En_X <= '1';
				En_Y <= '1';
				nState <= Banding; 
			end if;
		
		-- Langkah memilih Langkah sesuai hasil komparasi dan menstop load
		when Banding => 
			if ( switch = '0' ) then 
				Load_A <= '0'; 
				Load_B <= '0';
				Load_C <= '0';
				Load_D <= '0';
				Load_FPB_AB <= '0';
				Load_FPB_CD <= '0';
				if( FPB_AB = "0" and FPB_CD = "0" and FPB_ABCD = "0" ) then 
					if( compare = "10" ) then 	-- B < A
						nState <= Kurang_AB; 
					elsif( compare = "01" ) then -- B > A
						nState <= Kurang_BA; 
					end if;
				elsif( FPB_AB = "1" and FPB_CD = "0" and FPB_ABCD = "0" ) then 
					if( compare = "10" ) then -- D < C
						nState <= Kurang_CD; 
					elsif( compare = "01" ) then -- D > C
						nState <= Kurang_DC;
					end if;	
				elsif( FPB_AB = "1" and FPB_CD = "1" and FPB_ABCD = "0" ) then 
					if( compare = "10" ) then -- CD < AB
						nState <= Kurang_FPB_AB_CD;
					elsif( compare = "01" ) then -- CD > AB
						nState <= Kurang_FPB_CD_AB; 
					end if;	
				elsif( FPB_AB = "1" and FPB_CD = "1" and FPB_ABCD = "1" ) then 
					if ( compare = "11" ) then -- CD = AB
						nState <= Output_FPB;
					end if;
				end if;
			else -- switch = "1"
				En_X <= '0';
				En_Y <= '0';
				if( compare = "10" ) then 	-- Y < X 
					nState <= Tambah_YY; 
				elsif( compare = "01" ) then -- Y > X
					nState <= Tambah_XX; 
				elsif( compare = "11" ) then -- Y = X
					nState <= Output_FPB;
				end if;
			end if; 
			
		-- Langkah yang mengubah register A menjadi A - B jika B < A
		when Kurang_AB => 
			enable <= '0'; 
			Sel_A <= '1'; 
			Sel_B <= '0'; 
			Load_A <= '1'; 
			Load_B <= '0'; 
			nState <= Banding; 

		-- Langkah yang mengubah B menjadi B-A
		when Kurang_BA => 
			enable <= '0'; 
			Sel_A <= '0'; 
			Sel_B <= '1'; 
			Load_A <= '0'; 
			Load_B <= '1'; 
			nState <= Banding;

			-- Langkah yang mengubah C menjadi C-D
		when Kurang_CD => 
			enable <= '0'; 
			Sel_C <= '1'; 
			Sel_D <= '0'; 
			Load_C <= '1'; 
			Load_D <= '0'; 
			nState <= Banding;

			-- Langkah yang mengubah D menjadi D-C
		when Kurang_DC => 
			enable <= '0'; 
			Sel_C <= '0'; 
			Sel_D <= '1'; 
			Load_C <= '0'; 
			Load_D <= '1'; 
			nState <= Banding;

			-- Langkah yang mengubah AB menjadi AB-CD
		when Kurang_FPB_AB_CD => 
			enable <= '0'; 
			Sel_AB <= '1'; 
			Sel_CD <= '0'; 
			Load_FPB_AB <= '1'; 
			Load_FPB_CD <= '0'; 
			nState <= Banding;

			-- Langkah yang mengubah CD menjadi CD-AV
		when Kurang_FPB_CD_AB => 
			enable <= '0'; 
			Sel_AB <= '0'; 
			Sel_CD <= '1'; 
			Load_FPB_AB <= '0'; 
			Load_FPB_CD <= '1'; 
			nState <= Banding;
			
			-- Langkah yang menambah X dengan X awal 
		when Tambah_XX =>
			enable <= '0';
			Sel_X <= '1';
			Sel_Y <= '0';
			En_X <= '1';
			En_Y <= '0';
			nState <= Banding;

			-- Langkah yang menambah Y dengan Y awal
		when Tambah_YY =>
			enable <= '0';
			Sel_X <= '0';
			Sel_Y <= '1';
			En_X <= '0';
			En_Y <= '1';
			nState <= Banding;
		
		-- Langkah mengeluarkan output FPB
		when Output_FPB => 
			enable <= '1'; 
			Sel_CD <= '1'; 
			Load_FPB_CD <= '1'; 
			nState <= Idle; 
		
		-- Langkah mengeluarkan output KPK
		when output_KPK =>
			enable <= '1';
			Sel_Y <= '1';
			En_Y <= '1';
			nState <= Idle;
		
		-- Langkah terakhir jika lainnya, kembali ke kondisi reset
		when others => 
			nState <= Idle;
 
		end case; 
	
	end process; 

end fsm_arc;
		