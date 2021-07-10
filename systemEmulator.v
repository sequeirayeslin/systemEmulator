module systemEmulator (
    input signed [8:0]imp_resp_sample_0,
    input signed [8:0]imp_resp_sample_1,
    input signed [8:0]imp_resp_sample_2,
    input signed [8:0]imp_resp_sample_3,
    input signed [8:0]imp_resp_sample_4,
    input signed [8:0]imp_resp_sample_5,
    input signed [8:0]imp_resp_sample_6,
    input signed [8:0]imp_resp_sample_7,
    input signed [8:0]imp_resp_sample_8,
    input signed [8:0]imp_resp_sample_9,
    input edit_imp_resp,
    input signed [8:0] signal,
    input clk,
    output reg [20:0] out
);
    
    //an array for holding the systems impulse response
    reg signed [8:0] imp_resp [0:9];
    //an array for storing the last 10 input samples
    reg signed [8:0] signal_shift_reg [0:9];
    //stores intermediate results
    reg signed [17:0] intermediate_array [0:9];
    //also stores intermediate results
    reg signed [20:0] out_temp;

    //for loop counters
    integer i;
    integer j;

    //initialises all elements of signal_shift_reg and intermediate_array to 0s
    initial begin
        for (j=0; j<=9; j=j+1) begin
            signal_shift_reg[j] = 0;
        end
        for (j=0; j<=9; j=j+1) begin
            intermediate_array[j] = 0;
        end
    end

    always @(posedge clk) begin
        
        //reads impulse response fed to the module, if edit_imp_resp is high
        if (edit_imp_resp) begin
            imp_resp[0] = imp_resp_sample_0;
            imp_resp[1] = imp_resp_sample_1;
            imp_resp[2] = imp_resp_sample_2;
            imp_resp[3] = imp_resp_sample_3;
            imp_resp[4] = imp_resp_sample_4;
            imp_resp[5] = imp_resp_sample_5;
            imp_resp[6] = imp_resp_sample_6;
            imp_resp[7] = imp_resp_sample_7;
            imp_resp[8] = imp_resp_sample_8;
            imp_resp[9] = imp_resp_sample_9;
        end

        //shifts input values stored in signal_shift_reg array to the right
        for (i=9; i>=1; i=i-1) begin
            signal_shift_reg[i] = signal_shift_reg[i-1];
        end

        //reads new signal value
        signal_shift_reg[0] = signal;
        
        //intermediate calculations

        //multiplies input samples (signal_shift_reg) and impulse response (imp_resp)
        for (i=0; i<=9; i=i+1) begin
            intermediate_array[i] = signal_shift_reg[i] * imp_resp [i];
        end

        //adds up all values in intermediate_array, sum is accumulated into out_temp
        out_temp = 0;
        for (i=0; i<=9; i=i+1) begin
            out_temp = out_temp + intermediate_array[i];
        end

        //assigns computed value to output "out"
        out = out_temp;

    end

endmodule

module systemEmulator_test_as_lp_filter;

    reg signed [8:0]signal;
    reg signed [8:0]imp_resp[0:9];
    reg edit_imp_resp;
    reg clk=0;
    wire signed [20:0] out;
    systemEmulator sysEmu0(imp_resp[0], imp_resp[1], imp_resp[2], imp_resp[3], imp_resp[4], imp_resp[5], imp_resp[6], imp_resp[7], imp_resp[8], imp_resp[9], edit_imp_resp, signal, clk, out);

    //generates clock
    always #5 clk = ~clk;

    initial begin
        
        edit_imp_resp = 1;
        
        //sampling frequency is assumed to be 50khz
        //all the following values were calculated in matlab

        //setting the module to be a 10kHz cuttoff lowpass filter
        imp_resp[0] = 9'd_128;
        imp_resp[1] = 9'd_83;
        imp_resp[2] = 9'd_0;
        imp_resp[3] = -9'd_32;
        imp_resp[4] = 9'd_0;
        imp_resp[5] = 9'd_26;
        imp_resp[6] = 9'd_0;
        imp_resp[7] = -9'd_32;
        imp_resp[8] = 9'd_0;
        imp_resp[9] = 9'd_83;

        //240Hz sine input
        signal = 9'd_0;
        #10 signal = 9'd_3;
        #10 signal = 9'd_6;
        #10 signal = 9'd_9;
        #10 signal = 9'd_12;
        #10 signal = 9'd_15;
        #10 signal = 9'd_18;
        #10 signal = 9'd_21;
        #10 signal = 9'd_24;
        #10 signal = 9'd_27;
        #10 signal = 9'd_30;
        #10 signal = 9'd_33;
        #10 signal = 9'd_35;
        #10 signal = 9'd_38;
        #10 signal = 9'd_41;
        #10 signal = 9'd_44;
        #10 signal = 9'd_46;
        #10 signal = 9'd_49;
        #10 signal = 9'd_52;
        #10 signal = 9'd_54;
        #10 signal = 9'd_57;
        #10 signal = 9'd_59;
        #10 signal = 9'd_62;
        #10 signal = 9'd_64;
        #10 signal = 9'd_66;
        #10 signal = 9'd_68;
        #10 signal = 9'd_71;
        #10 signal = 9'd_73;
        #10 signal = 9'd_75;
        #10 signal = 9'd_77;
        #10 signal = 9'd_79;
        #10 signal = 9'd_80;
        #10 signal = 9'd_82;
        #10 signal = 9'd_84;
        #10 signal = 9'd_85;
        #10 signal = 9'd_87;
        #10 signal = 9'd_88;
        #10 signal = 9'd_90;
        #10 signal = 9'd_91;
        #10 signal = 9'd_92;
        #10 signal = 9'd_93;
        #10 signal = 9'd_94;
        #10 signal = 9'd_95;
        #10 signal = 9'd_96;
        #10 signal = 9'd_97;
        #10 signal = 9'd_98;
        #10 signal = 9'd_98;
        #10 signal = 9'd_99;
        #10 signal = 9'd_99;
        #10 signal = 9'd_100;
        #10 signal = 9'd_100;
        #10 signal = 9'd_100;
        #10 signal = 9'd_100;
        #10 signal = 9'd_100;
        #10 signal = 9'd_100;
        #10 signal = 9'd_100;
        #10 signal = 9'd_99;
        #10 signal = 9'd_99;
        #10 signal = 9'd_98;
        #10 signal = 9'd_98;
        #10 signal = 9'd_97;
        #10 signal = 9'd_96;
        #10 signal = 9'd_96;
        #10 signal = 9'd_95;
        #10 signal = 9'd_94;
        #10 signal = 9'd_93;
        #10 signal = 9'd_91;
        #10 signal = 9'd_90;
        #10 signal = 9'd_89;
        #10 signal = 9'd_87;
        #10 signal = 9'd_86;
        #10 signal = 9'd_84;
        #10 signal = 9'd_82;
        #10 signal = 9'd_81;
        #10 signal = 9'd_79;
        #10 signal = 9'd_77;
        #10 signal = 9'd_75;
        #10 signal = 9'd_73;
        #10 signal = 9'd_71;
        #10 signal = 9'd_69;
        #10 signal = 9'd_67;
        #10 signal = 9'd_64;
        #10 signal = 9'd_62;
        #10 signal = 9'd_60;
        #10 signal = 9'd_57;
        #10 signal = 9'd_55;
        #10 signal = 9'd_52;
        #10 signal = 9'd_49;
        #10 signal = 9'd_47;
        #10 signal = 9'd_44;
        #10 signal = 9'd_41;
        #10 signal = 9'd_39;
        #10 signal = 9'd_36;
        #10 signal = 9'd_33;
        #10 signal = 9'd_30;
        #10 signal = 9'd_27;
        #10 signal = 9'd_24;
        #10 signal = 9'd_21;
        #10 signal = 9'd_18;
        #10 signal = 9'd_16;
        #10 signal = 9'd_13;
        #10 signal = 9'd_10;
        #10 signal = 9'd_7;
        #10 signal = 9'd_4;
        #10 signal = 9'd_1;
        #10 signal = -9'd_3;
        #10 signal = -9'd_6;
        #10 signal = -9'd_9;
        #10 signal = -9'd_12;
        #10 signal = -9'd_15;
        #10 signal = -9'd_18;
        #10 signal = -9'd_20;
        #10 signal = -9'd_23;
        #10 signal = -9'd_26;
        #10 signal = -9'd_29;
        #10 signal = -9'd_32;
        #10 signal = -9'd_35;
        #10 signal = -9'd_38;
        #10 signal = -9'd_41;
        #10 signal = -9'd_43;
        #10 signal = -9'd_46;
        #10 signal = -9'd_49;
        #10 signal = -9'd_51;
        #10 signal = -9'd_54;
        #10 signal = -9'd_56;
        #10 signal = -9'd_59;
        #10 signal = -9'd_61;
        #10 signal = -9'd_64;
        #10 signal = -9'd_66;
        #10 signal = -9'd_68;
        #10 signal = -9'd_70;
        #10 signal = -9'd_72;
        #10 signal = -9'd_74;
        #10 signal = -9'd_76;
        #10 signal = -9'd_78;
        #10 signal = -9'd_80;
        #10 signal = -9'd_82;
        #10 signal = -9'd_84;
        #10 signal = -9'd_85;
        #10 signal = -9'd_87;
        #10 signal = -9'd_88;
        #10 signal = -9'd_90;
        #10 signal = -9'd_91;
        #10 signal = -9'd_92;
        #10 signal = -9'd_93;
        #10 signal = -9'd_94;
        #10 signal = -9'd_95;
        #10 signal = -9'd_96;
        #10 signal = -9'd_97;
        #10 signal = -9'd_98;
        #10 signal = -9'd_98;
        #10 signal = -9'd_99;
        #10 signal = -9'd_99;
        #10 signal = -9'd_100;
        #10 signal = -9'd_100;
        #10 signal = -9'd_100;
        #10 signal = -9'd_100;
        #10 signal = -9'd_100;
        #10 signal = -9'd_100;
        #10 signal = -9'd_100;
        #10 signal = -9'd_99;
        #10 signal = -9'd_99;
        #10 signal = -9'd_99;
        #10 signal = -9'd_98;
        #10 signal = -9'd_97;
        #10 signal = -9'd_97;
        #10 signal = -9'd_96;
        #10 signal = -9'd_95;
        #10 signal = -9'd_94;
        #10 signal = -9'd_93;
        #10 signal = -9'd_92;
        #10 signal = -9'd_90;
        #10 signal = -9'd_89;
        #10 signal = -9'd_88;
        #10 signal = -9'd_86;
        #10 signal = -9'd_84;
        #10 signal = -9'd_83;
        #10 signal = -9'd_81;
        #10 signal = -9'd_79;
        #10 signal = -9'd_77;
        #10 signal = -9'd_75;
        #10 signal = -9'd_73;
        #10 signal = -9'd_71;
        #10 signal = -9'd_69;
        #10 signal = -9'd_67;
        #10 signal = -9'd_65;
        #10 signal = -9'd_62;
        #10 signal = -9'd_60;
        #10 signal = -9'd_58;
        #10 signal = -9'd_55;
        #10 signal = -9'd_53;
        #10 signal = -9'd_50;
        #10 signal = -9'd_47;
        #10 signal = -9'd_45;
        #10 signal = -9'd_42;
        #10 signal = -9'd_39;
        #10 signal = -9'd_36;
        #10 signal = -9'd_34;
        #10 signal = -9'd_31;
        #10 signal = -9'd_28;
        #10 signal = -9'd_25;
        #10 signal = -9'd_22;
        #10 signal = -9'd_19;
        #10 signal = -9'd_16;
        #10 signal = -9'd_13;
        #10 signal = -9'd_10;
        #10 signal = -9'd_7;
        #10 signal = -9'd_4;
        #10 signal = -9'd_1;
        #10 signal = 9'd_0;

        //1000Hz sine input
        #100 signal = 9'd_0;
        #10 signal = 9'd_13;
        #10 signal = 9'd_25;
        #10 signal = 9'd_37;
        #10 signal = 9'd_48;
        #10 signal = 9'd_59;
        #10 signal = 9'd_68;
        #10 signal = 9'd_77;
        #10 signal = 9'd_84;
        #10 signal = 9'd_90;
        #10 signal = 9'd_95;
        #10 signal = 9'd_98;
        #10 signal = 9'd_100;
        #10 signal = 9'd_100;
        #10 signal = 9'd_98;
        #10 signal = 9'd_95;
        #10 signal = 9'd_90;
        #10 signal = 9'd_84;
        #10 signal = 9'd_77;
        #10 signal = 9'd_68;
        #10 signal = 9'd_59;
        #10 signal = 9'd_48;
        #10 signal = 9'd_37;
        #10 signal = 9'd_25;
        #10 signal = 9'd_13;
        #10 signal = 9'd_0;
        #10 signal = -9'd_13;
        #10 signal = -9'd_25;
        #10 signal = -9'd_37;
        #10 signal = -9'd_48;
        #10 signal = -9'd_59;
        #10 signal = -9'd_68;
        #10 signal = -9'd_77;
        #10 signal = -9'd_84;
        #10 signal = -9'd_90;
        #10 signal = -9'd_95;
        #10 signal = -9'd_98;
        #10 signal = -9'd_100;
        #10 signal = -9'd_100;
        #10 signal = -9'd_98;
        #10 signal = -9'd_95;
        #10 signal = -9'd_90;
        #10 signal = -9'd_84;
        #10 signal = -9'd_77;
        #10 signal = -9'd_68;
        #10 signal = -9'd_59;
        #10 signal = -9'd_48;
        #10 signal = -9'd_37;
        #10 signal = -9'd_25;
        #10 signal = -9'd_13;
        #10 signal = 9'd_0;

        //20000Hz sine input
        #100 signal = 9'd_0;
        #10 signal = 9'd_59;
        #10 signal = -9'd_95;
        #10 signal = 9'd_95;
        #10 signal = -9'd_59;
        #10 signal = 9'd_0;
        #10 signal = 9'd_59;
        #10 signal = -9'd_95;
        #10 signal = 9'd_95;
        #10 signal = -9'd_59;
        #10 signal = 9'd_0;
        #10 signal = 9'd_59;
        #10 signal = -9'd_95;
        #10 signal = 9'd_95;
        #10 signal = -9'd_59;
        #10 signal = 9'd_0;
        #10 signal = 9'd_59;
        #10 signal = -9'd_95;
        #10 signal = 9'd_95;
        #10 signal = -9'd_59;
        #10 signal = 9'd_0;

    end
    
endmodule

module systemEmulator_test_as_delay_cum_amp;

    reg signed [8:0]signal;
    reg signed [8:0]imp_resp[0:9];
    reg edit_imp_resp;
    reg clk=0;
    wire signed [20:0] out;
    systemEmulator sysEmu0(imp_resp[0], imp_resp[1], imp_resp[2], imp_resp[3], imp_resp[4], imp_resp[5], imp_resp[6], imp_resp[7], imp_resp[8], imp_resp[9], edit_imp_resp, signal, clk, out);

    //generates clock
    always #5 clk = ~clk;

    initial begin
        
        edit_imp_resp = 1;
        
        //sampling frequency is assumed to be 50khz
        //all the following values were calculated in matlab

        //setting the module to be a 7 unit delay-cum_amplifier system with a gain of 5
        imp_resp[0] = 9'd_0;
        imp_resp[1] = 9'd_0;
        imp_resp[2] = 9'd_0;
        imp_resp[3] = 9'd_0;
        imp_resp[4] = 9'd_0;
        imp_resp[5] = 9'd_0;
        imp_resp[6] = 9'd_0;
        imp_resp[7] = 9'd_5;
        imp_resp[8] = 9'd_0;
        imp_resp[9] = 9'd_0;

        //1000Hz sine input
        signal = 9'd_0;
        #10 signal = 9'd_13;
        #10 signal = 9'd_25;
        #10 signal = 9'd_37;
        #10 signal = 9'd_48;
        #10 signal = 9'd_59;
        #10 signal = 9'd_68;
        #10 signal = 9'd_77;
        #10 signal = 9'd_84;
        #10 signal = 9'd_90;
        #10 signal = 9'd_95;
        #10 signal = 9'd_98;
        #10 signal = 9'd_100;
        #10 signal = 9'd_100;
        #10 signal = 9'd_98;
        #10 signal = 9'd_95;
        #10 signal = 9'd_90;
        #10 signal = 9'd_84;
        #10 signal = 9'd_77;
        #10 signal = 9'd_68;
        #10 signal = 9'd_59;
        #10 signal = 9'd_48;
        #10 signal = 9'd_37;
        #10 signal = 9'd_25;
        #10 signal = 9'd_13;
        #10 signal = 9'd_0;
        #10 signal = -9'd_13;
        #10 signal = -9'd_25;
        #10 signal = -9'd_37;
        #10 signal = -9'd_48;
        #10 signal = -9'd_59;
        #10 signal = -9'd_68;
        #10 signal = -9'd_77;
        #10 signal = -9'd_84;
        #10 signal = -9'd_90;
        #10 signal = -9'd_95;
        #10 signal = -9'd_98;
        #10 signal = -9'd_100;
        #10 signal = -9'd_100;
        #10 signal = -9'd_98;
        #10 signal = -9'd_95;
        #10 signal = -9'd_90;
        #10 signal = -9'd_84;
        #10 signal = -9'd_77;
        #10 signal = -9'd_68;
        #10 signal = -9'd_59;
        #10 signal = -9'd_48;
        #10 signal = -9'd_37;
        #10 signal = -9'd_25;
        #10 signal = -9'd_13;
        #10 signal = 9'd_0;

    end
    
endmodule

module systemEmulator_test_as_inverter;

    reg signed [8:0]signal;
    reg signed [8:0]imp_resp[0:9];
    reg edit_imp_resp;
    reg clk=0;
    wire signed [20:0] out;
    systemEmulator sysEmu0(imp_resp[0], imp_resp[1], imp_resp[2], imp_resp[3], imp_resp[4], imp_resp[5], imp_resp[6], imp_resp[7], imp_resp[8], imp_resp[9], edit_imp_resp, signal, clk, out);

    //generates clock
    always #5 clk = ~clk;

    initial begin
        
        edit_imp_resp = 1;
        
        //sampling frequency is assumed to be 50khz
        //all the following values were calculated in matlab

        //setting the module to be an inverter
        imp_resp[0] = -9'd_1;
        imp_resp[1] = 9'd_0;
        imp_resp[2] = 9'd_0;
        imp_resp[3] = 9'd_0;
        imp_resp[4] = 9'd_0;
        imp_resp[5] = 9'd_0;
        imp_resp[6] = 9'd_0;
        imp_resp[7] = 9'd_0;
        imp_resp[8] = 9'd_0;
        imp_resp[9] = 9'd_0;

        //1000Hz sine input
        signal = 9'd_0;
        #10 signal = 9'd_13;
        #10 signal = 9'd_25;
        #10 signal = 9'd_37;
        #10 signal = 9'd_48;
        #10 signal = 9'd_59;
        #10 signal = 9'd_68;
        #10 signal = 9'd_77;
        #10 signal = 9'd_84;
        #10 signal = 9'd_90;
        #10 signal = 9'd_95;
        #10 signal = 9'd_98;
        #10 signal = 9'd_100;
        #10 signal = 9'd_100;
        #10 signal = 9'd_98;
        #10 signal = 9'd_95;
        #10 signal = 9'd_90;
        #10 signal = 9'd_84;
        #10 signal = 9'd_77;
        #10 signal = 9'd_68;
        #10 signal = 9'd_59;
        #10 signal = 9'd_48;
        #10 signal = 9'd_37;
        #10 signal = 9'd_25;
        #10 signal = 9'd_13;
        #10 signal = 9'd_0;
        #10 signal = -9'd_13;
        #10 signal = -9'd_25;
        #10 signal = -9'd_37;
        #10 signal = -9'd_48;
        #10 signal = -9'd_59;
        #10 signal = -9'd_68;
        #10 signal = -9'd_77;
        #10 signal = -9'd_84;
        #10 signal = -9'd_90;
        #10 signal = -9'd_95;
        #10 signal = -9'd_98;
        #10 signal = -9'd_100;
        #10 signal = -9'd_100;
        #10 signal = -9'd_98;
        #10 signal = -9'd_95;
        #10 signal = -9'd_90;
        #10 signal = -9'd_84;
        #10 signal = -9'd_77;
        #10 signal = -9'd_68;
        #10 signal = -9'd_59;
        #10 signal = -9'd_48;
        #10 signal = -9'd_37;
        #10 signal = -9'd_25;
        #10 signal = -9'd_13;
        #10 signal = 9'd_0;

    end
    
endmodule