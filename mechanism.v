`timescale 1ns / 1ps

module mechanism(

input clk,
input reset,
input left, right,
input video_on,
input [9:0] x,
input [9:0] y,
output reg [11:0] rgb

);  

parameter X_MAX = 639;
parameter Y_MAX = 479;
    
wire refresh_tick;
assign refresh_tick = ((y == 481) && (x == 0)) ? 1 : 0;   

parameter lvl_t = 70;
parameter lvl_b = 80;
parameter lvl_4l= 520;
parameter lvl_4r= 530;
parameter lvl_3l= 540;
parameter lvl_3r= 550;
parameter lvl_2l= 560;
parameter lvl_2r= 570;
parameter lvl_1l= 580;
parameter lvl_1r= 590;

parameter Lane_1t = 107;
parameter Lane_1b = 119;
parameter Lane_2t= 122;
parameter Lane_2b = 134;
parameter Lane_3t= 137;
parameter Lane_3b = 149;

parameter breakL_1 = 98;
parameter breakR_1 = 170;
parameter breakL_2 = 175;
parameter breakR_2 = 247;
parameter breakL_3 = 252;
parameter breakR_3 = 324;
parameter breakL_4 = 329;
parameter breakR_4 = 401;
parameter breakL_5 = 406;
parameter breakR_5 = 478;
parameter breakL_6 = 483;
parameter breakR_6 = 532;


parameter X_WALL_L1 = 90;    
parameter X_WALL_L2 = 95;   
parameter X_WALL_R1 = 535;    
parameter X_WALL_R2 = 540;

parameter Y_WALL_L1 = 100;  
parameter Y_WALL_L2 = 105;
parameter Y_PAD_T = 450;
parameter Y_PAD_B = 454; 

wire [9:0] X_PAD_r, X_PAD_l;
parameter PAD_LEN = 80;

reg [9:0] x_pad_reg, x_pad_next;
parameter PAD_VEL = 3;    

parameter BALL_SIZE = 8;
wire [9:0] x_ball_l, x_ball_r;
wire [9:0] y_ball_t, y_ball_b;
reg  [9:0] y_ball_reg, x_ball_reg;
wire [9:0] y_ball_next, x_ball_next;
reg  [9:0] x_delta_reg, x_delta_next;
reg  [9:0] y_delta_reg, y_delta_next;

reg [17:0] flag_check;
reg [3:0] level_check;
reg [3:0] a;
wire flag_reset_0, flag_reset_1, flag_reset_2, flag_reset_3, flag_reset_4, flag_reset_5, flag_reset_6, flag_reset_7, flag_reset_8, flag_reset_9, flag_reset_10, flag_reset_11, flag_reset_12, flag_reset_13, flag_reset_14, flag_reset_15, flag_reset_16, flag_reset_17;


assign flag_reset_0 = (y_ball_t < Lane_3b) && ( Lane_3b < y_ball_b) && (x_ball_r < breakR_1) && ( breakL_1< x_ball_l )   && (flag_check[0]);
assign flag_reset_1 = (y_ball_t <  Lane_3b) && ( Lane_3b < y_ball_b) && (breakL_2 < x_ball_l) && (  x_ball_r < breakR_2  ) && (flag_check[1]);
assign flag_reset_2 = (y_ball_t <  Lane_3b)&& ( Lane_3b < y_ball_b) && (breakL_3 < x_ball_l) && (  x_ball_r < breakR_3  ) && (flag_check[2]);
assign flag_reset_3 = (y_ball_t < Lane_3b) && ( Lane_3b < y_ball_b) && (x_ball_r < breakR_4) && ( breakL_4< x_ball_l )   && (flag_check[3]);
assign flag_reset_4 = (y_ball_t <  Lane_3b) && ( Lane_3b < y_ball_b) && (breakL_5 < x_ball_l) && (  x_ball_r < breakR_5 ) && (flag_check[4]);
assign flag_reset_5 = (y_ball_t <  Lane_3b)&& ( Lane_3b < y_ball_b) && (breakL_6 < x_ball_l) && (  x_ball_r < breakR_6  ) && (flag_check[5]);

assign flag_reset_6 = (y_ball_t <  Lane_2b) && ( Lane_2b < y_ball_b) && (x_ball_r < breakR_1) && ( breakL_1< x_ball_l )   && (flag_check[6]);
assign flag_reset_7 = (y_ball_t <  Lane_2b) && ( Lane_2b < y_ball_b) && (breakL_2 < x_ball_l) && (  x_ball_r < breakR_2  ) && (flag_check[7]);
assign flag_reset_8 = (y_ball_t <  Lane_2b)&& ( Lane_2b < y_ball_b) && (breakL_3 < x_ball_l) && (  x_ball_r < breakR_3  ) && (flag_check[8]);
assign flag_reset_9 = (y_ball_t <  Lane_2b) && ( Lane_2b < y_ball_b) && (x_ball_r < breakR_4) && ( breakL_4< x_ball_l )   && (flag_check[9]);
assign flag_reset_10 = (y_ball_t < Lane_2b) && ( Lane_2b < y_ball_b) && (breakL_5 < x_ball_l) && (  x_ball_r < breakR_5 ) && (flag_check[10]);
assign flag_reset_11 = (y_ball_t < Lane_2b)&& ( Lane_2b < y_ball_b) && (breakL_6 < x_ball_l) && (  x_ball_r < breakR_6  ) && (flag_check[11]);

assign flag_reset_12 = (y_ball_t <  Lane_1b) && ( Lane_1b < y_ball_b) && (x_ball_r < breakR_1) && ( breakL_1< x_ball_l )   && (flag_check[12]);
assign flag_reset_13 = (y_ball_t <  Lane_1b) && ( Lane_1b < y_ball_b) && (breakL_2 < x_ball_l) && (  x_ball_r < breakR_2  ) && (flag_check[13]);
assign flag_reset_14 = (y_ball_t <  Lane_1b)&& ( Lane_1b < y_ball_b) && (breakL_3 < x_ball_l) && (  x_ball_r < breakR_3  ) && (flag_check[14]);
assign flag_reset_15 = (y_ball_t <  Lane_1b) && ( Lane_1b < y_ball_b) && (x_ball_r < breakR_4) && ( breakL_4< x_ball_l )   && (flag_check[15]);
assign flag_reset_16 = (y_ball_t < Lane_1b) && ( Lane_1b < y_ball_b) && (breakL_5 < x_ball_l) && (  x_ball_r < breakR_5 ) && (flag_check[16]);
assign flag_reset_17 = (y_ball_t < Lane_1b)&& ( Lane_1b < y_ball_b) && (breakL_6 < x_ball_l) && (  x_ball_r < breakR_6  ) && (flag_check[17]);

wire level_0,level_1,level_2,level_3;
wire level;
assign level_0 = (lvl_4l <= x) && (x <= lvl_4r) && (y >= lvl_t) && (y <= lvl_b);
assign level_1 = (lvl_3l <= x) && (x <= lvl_3r) && (y >= lvl_t) && (y <= lvl_b);
assign level_2 = (lvl_2l <= x) && (x <= lvl_2r) && (y >= lvl_t) && (y <= lvl_b);
assign level_3 = (lvl_1l <= x) && (x <= lvl_1r) && (y >= lvl_t) && (y <= lvl_b);
assign level = ((Y_MAX - 2) <= y_ball_b ) && (X_WALL_L2 <= x_ball_l)&& (x_ball_r < X_WALL_R1 );

parameter B1 = 1;
parameter B0 = -1;    


wire [2:0] rom_addr, rom_col;  
reg [7:0] rom_data;             
wire rom_bit;  
    
always @(posedge clk or posedge reset)
   if(reset) begin
       x_pad_reg <= 95;
       x_ball_reg <= X_MAX;
       y_ball_reg <= Y_MAX/2;
       x_delta_reg <= 10'h001;
       y_delta_reg <= 10'h001;
       flag_check <= 18'h3FFFF;
       level_check <= 4'b0000;
       a<= 4'b0001;
end  
else begin
    x_pad_reg <= x_pad_next;
    x_ball_reg <= x_ball_next;
    y_ball_reg <= y_ball_next;
    x_delta_reg <= x_delta_next;
    y_delta_reg <= y_delta_next;
//    if(level) begin
//       a <=  a << 1;
//      level_check <= level_check + a; end
      
    if (flag_reset_0) 
    flag_check[0] <= 0;
    if (flag_reset_1) 
    flag_check[1] <= 0;
    if (flag_reset_2) 
    flag_check[2] <= 0; 
    if (flag_reset_3) 
      flag_check[3] <= 0;
      if (flag_reset_4) 
    flag_check[4] <= 0;
      if (flag_reset_5) 
       flag_check[5] <= 0;
     if (flag_reset_6) 
    flag_check[6] <= 0;
    if (flag_reset_7) 
      flag_check[10] <= 0;
    if (flag_reset_8) 
    flag_check[8] <= 0; 
    if (flag_reset_9) 
    flag_check[9] <= 0;
      if (flag_reset_10) 
     flag_check[10] <= 0;
      if (flag_reset_11) 
    flag_check[11] <= 0;
     if (flag_reset_12) 
    flag_check[12] <= 0;
    if (flag_reset_13) 
     flag_check <= 18'h3DFFF;
    if (flag_reset_14) 
    flag_check[14] <= 0; 
    if (flag_reset_15) 
       flag_check[15] <= 0;
      if (flag_reset_16) 
   flag_check <= 18'h1FFFF;
      if (flag_reset_17) 
    flag_check[17] <= 0;

    
end   

always @(*)
   case(rom_addr)
            3'b000 :    rom_data = 8'b00111100; 
            3'b001 :    rom_data = 8'b01111110; 
            3'b010 :    rom_data = 8'b11111111; 
            3'b011 :    rom_data = 8'b11111111; 
            3'b100 :    rom_data = 8'b11111111; 
            3'b101 :    rom_data = 8'b11111111; 
            3'b110 :    rom_data = 8'b01111110; 
            3'b111 :    rom_data = 8'b00111100; 
endcase
       
       
 
wire wall_on, pad_on, sq_ball_on, ball_on, 
     break0, break1, break2, break3, break4, break5, 
     break6, break7, break8, break9, break10, break11, 
     break12, break13, break14, break15, break16, break17;

 wire [11:0] wall_rgb, pad_rgb, ball_rgb, bg_rgb, break_rgb, bg_red;

// reg [1:0] delay_counter;
assign break0  = ((breakL_1 <= x) && (x <= breakR_1) && (y <= Lane_3b) && (Lane_3t <= y));
assign break1  = ((breakL_2 <= x) && (x <= breakR_2) && (y <= Lane_3b) && (Lane_3t <= y));
assign break2  = ((breakL_3 <= x) && (x <= breakR_3) && (y <= Lane_3b) && (Lane_3t <= y));
assign break3  = ((breakL_4 <= x) && (x <= breakR_4) && (y <= Lane_3b) && (Lane_3t <= y));
assign break4  = ((breakL_5 <= x) && (x <= breakR_5) && (y <= Lane_3b) && (Lane_3t <= y));
assign break5  = ((breakL_6 <= x) && (x <= breakR_6) && (y <= Lane_3b) && (Lane_3t <= y));

assign break6  = ((breakL_1 <= x) && (x <= breakR_1) && (y <= Lane_2b) && (Lane_2t <= y));
assign break7  = ((breakL_2 <= x) && (x <= breakR_2) && (y <= Lane_2b) && (Lane_2t <= y));
assign break8  = ((breakL_3 <= x) && (x <= breakR_3) && (y <= Lane_2b) && (Lane_2t <= y));
assign break9  = ((breakL_4 <= x) && (x <= breakR_4) && (y <= Lane_2b) && (Lane_2t <= y));
assign break10 = ((breakL_5 <= x) && (x <= breakR_5) && (y <= Lane_2b) && (Lane_2t <= y));
assign break11 = ((breakL_6 <= x) && (x <= breakR_6) && (y <= Lane_2b) && (Lane_2t <= y));

assign break12 = ((breakL_1 <= x) && (x <= breakR_1) && (y <= Lane_1b) && (Lane_1t <= y));
assign break13 = ((breakL_2 <= x) && (x <= breakR_2) && (y <= Lane_1b) && (Lane_1t <= y));
assign break14 = ((breakL_3 <= x) && (x <= breakR_3) && (y <= Lane_1b) && (Lane_1t <= y));
assign break15 = ((breakL_4 <= x) && (x <= breakR_4) && (y <= Lane_1b) && (Lane_1t <= y));
assign break16 = ((breakL_5 <= x) && (x <= breakR_5) && (y <= Lane_1b) && (Lane_1t <= y));
assign break17 = ((breakL_6 <= x) && (x <= breakR_6) && (y <= Lane_1b) && (Lane_1t <= y));





assign wall_on = (((X_WALL_L1 <= x) && (x <= X_WALL_L2) && (Y_WALL_L1 <= y)) || (( X_WALL_R1 <=x)&&( x<= X_WALL_R2 ) && (Y_WALL_L1 <= y)) || ((y <= Y_WALL_L2) && ( Y_WALL_L1 <= y ) && (X_WALL_L1 <= x) &&(x <= X_WALL_R2))) ? 1 : 0;
assign wall_rgb = 12'hAAF;      
assign pad_rgb = 12'hFFF;  
assign break_rgb = 12'hFFF;     
assign ball_rgb = 12'h0F0;      
assign bg_rgb = 12'h111; 
assign bg_red = 12'hF00;    
assign bg_red2 = 12'hFF0;    
    
assign X_PAD_l = x_pad_reg;
assign X_PAD_r = X_PAD_l + PAD_LEN -1;
assign pad_on = ( Y_PAD_T <=y ) && (y <= Y_PAD_B ) && ( x<= X_PAD_r ) && ( X_PAD_l <= x) ;   
    
    
 always @* 
 begin   
  x_pad_next = x_pad_reg;
  if(refresh_tick)
    
    if( right &&  (~left) &&  (X_PAD_r <= X_WALL_R1 ))  
     x_pad_next = x_pad_reg + PAD_VEL;
     else if( left &&  (~right)  && (X_WALL_L2 <= X_PAD_l ))
      x_pad_next = x_pad_reg - PAD_VEL;
   end
   
   
  assign x_ball_l = x_ball_reg;
  assign y_ball_t = y_ball_reg;
  assign x_ball_r = x_ball_l + BALL_SIZE - 1;
  assign y_ball_b = y_ball_t + BALL_SIZE - 1; 
  
 
 
   assign sq_ball_on = (x_ball_l <= x) && (x <= x_ball_r) && (y_ball_t <= y) && (y <= y_ball_b);
 
   assign rom_addr = y[2:0] - y_ball_t[2:0];   
   assign rom_col = x[2:0] - x_ball_l[2:0];   
   assign rom_bit = rom_data[rom_col];      
   assign ball_on = sq_ball_on & rom_bit; 
   assign x_ball_next =  reset ? (X_MAX / 2) :(refresh_tick) ? x_ball_reg + x_delta_reg : x_ball_reg;
   assign y_ball_next =  reset ? (Y_MAX / 2): (refresh_tick) ? y_ball_reg + y_delta_reg : y_ball_reg;   
   
    
    
  always @* begin
        x_delta_next = x_delta_reg;
        y_delta_next = y_delta_reg;
        
        if(y_ball_t <= Y_WALL_L2)                                            
            y_delta_next = B1;  
        
        else if( x_ball_l < X_WALL_L2)                         
             x_delta_next = B1; 
                             
            
        else if(  X_WALL_R2 < x_ball_r)                         
             x_delta_next = B0; 
             
             
             
        else if( ((Y_MAX - 2) <= y_ball_b ) && (X_WALL_L2 <= x_ball_l)&& (x_ball_r < X_WALL_R1 )  )    
        begin                   
//            y_ball_reg <= 10'd185 ;
//            x_ball_reg <= 10'd300;  
             y_delta_next = B0;
//             a <=  a << 1;
//             level_check <= level_check + a ;
            
             
        end
        
        else if ( ( X_PAD_l <= x_ball_r) && ( x_ball_l <= X_PAD_r ) && ( Y_PAD_T <= y_ball_b))
              y_delta_next = B0;
              
              
else if(flag_reset_0)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_1)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_2)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_3)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_4)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_5)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_6)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_7)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_8)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_9)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_10)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_11)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_12)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_13)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_14)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_15)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_16)   
begin
    y_delta_next = B1;
end 

else if(flag_reset_17)   
begin
    y_delta_next = B1;
end 
 
               
    end                    
    
    
       
    
    
   always @*
        if(~video_on)
            rgb = 12'h000;     
        else
        
         if(wall_on)
           rgb = wall_rgb;    
            else if(pad_on)
                rgb = pad_rgb;     
            else if(ball_on)
                rgb = ball_rgb;   
         else if( break0 && flag_check[0])  
            rgb = break_rgb;
         else if( break1 && flag_check[1])  
              rgb = break_rgb;
            else if( break2 && flag_check[2])  
            rgb = break_rgb;
                else if( break3 && flag_check[3])  
                             rgb = break_rgb;
                    else if( break4 && flag_check[4])  
                            rgb = break_rgb;
                  else if( break5 && flag_check[5])  
                               rgb = break_rgb;
                       else if( break6 && flag_check[6])  
                             rgb = break_rgb;
                      else if( break7 && flag_check[7])  
                          rgb =break_rgb;
                     else if( break8 && flag_check[8])  
                             rgb = break_rgb;
                       else if( break9 && flag_check[9])  
                           rgb = break_rgb;
                  else if( break10 && flag_check[10])  
                          rgb = break_rgb;
                   else if( break11 && flag_check[11])  
                             rgb = break_rgb;
                   else if( break12 && flag_check[12])  
                   rgb = break_rgb;
               else if( break13 && flag_check[13])  
                      rgb = bg_red;
            else if( break14 && flag_check[14])  
                   rgb = break_rgb;
            else if( break15 && flag_check[15])  
                 rgb = break_rgb;
         else if( break16 && flag_check[16])  
               rgb = bg_red;
          else if( break17 && flag_check[17])  
             rgb = break_rgb;
             
          else if (level_0 && ~(level_check[0]))
           rgb = bg_red;
             else if (level_1 && ~(level_check[1]))
           rgb = bg_red;
             else if (level_2 && ~(level_check[2]))
           rgb = bg_red;
             else if (level_3 && ~(level_check[3]))
           rgb = bg_red;
            else
                rgb = bg_rgb; 
   
   
      
endmodule
