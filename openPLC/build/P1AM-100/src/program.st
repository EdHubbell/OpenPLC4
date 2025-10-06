FUNCTION_BLOCK fbPulsePump
  VAR_INPUT
    IN_1 : BOOL;
    IN_2 : BOOL;
    IN_3 : BOOL;
    PLC_INIT : BOOL;
  END_VAR
  VAR_OUTPUT
    PUMP_PULSE : BOOL;
  END_VAR


  VAR
  (*Some timers with limited scope *)
      TON0 : TON;
      TOF0 : TOF;
  END_VAR



  (*If all three signals from the dicing saw are true, turn on the pump *)
  IF (IN_1 AND IN_2 AND IN_3) THEN

    TON0(IN := NOT(PUMP_PULSE) AND PLC_INIT, PT := T#100ms);  

    TOF0(IN := TON0.Q, PT := T#300ms);

    PUMP_PULSE := TOF0.Q;    

  ELSE

    PUMP_PULSE := FALSE;

  END_IF;




END_FUNCTION_BLOCK

PROGRAM main
  VAR
    kjh : P1AM_INIT;
    tee : P1AM_INIT;
    dvxc : P1_16N;
  END_VAR
  VAR
    P_PULSE_1 AT %QX1.0 : BOOL := 0;
    P_PULSE_2 AT %QX1.1 : BOOL := 0;
    P_PULSE_3 AT %QX1.2 : BOOL := 0;
    P_PULSE_4 AT %QX1.3 : BOOL := 0;
    P_PULSE_5 AT %QX1.4 : BOOL := 0;
    P_PULSE_6 AT %QX1.5 : BOOL := 0;
    P_PULSE_7 AT %QX1.6 : BOOL := 0;
    P_PULSE_8 AT %QX1.7 : BOOL := 0;
    SIM1SW1 AT %IX1.0 : BOOL := 0;
    SIM1SW2 AT %IX1.1 : BOOL := 0;
    SIM1SW3 AT %IX1.2 : BOOL := 0;
    SIM1SW4 AT %IX1.3 : BOOL := 0;
    SIM1SW5 AT %IX1.4 : BOOL := 0;
    SIM1SW6 AT %IX1.5 : BOOL := 0;
    SIM1SW7 AT %IX1.6 : BOOL := 0;
    SIM1SW8 AT %IX1.7 : BOOL := 0;
    INPUT_16_1_01 AT %IX2.0 : BOOL := 0;
    INPUT_16_1_2 AT %IX2.1 : BOOL := 0;
    INPUT_16_1_3 AT %IX2.2 : BOOL := 0;
    INPUT_16_1_4 AT %IX2.3 : BOOL := 0;
    INPUT_16_1_5 AT %IX2.4 : BOOL := 0;
    INPUT_16_1_6 AT %IX2.5 : BOOL := 0;
    INPUT_16_1_7 AT %IX2.6 : BOOL := 0;
    INPUT_16_1_8 AT %IX2.7 : BOOL := 0;
    INPUT_16_1_9 AT %IX3.0 : BOOL := 0;
    INPUT_16_1_10 AT %IX3.1 : BOOL := 0;
    INPUT_16_1_11 AT %IX3.2 : BOOL := 0;
    INPUT_16_1_12 AT %IX3.3 : BOOL := 0;
    INPUT_16_1_13 AT %IX3.4 : BOOL := 0;
    INPUT_16_1_14 AT %IX3.5 : BOOL := 0;
    INPUT_16_1_15 AT %IX3.6 : BOOL := 0;
    INPUT_16_1_16 AT %IX3.7 : BOOL := 0;
  END_VAR

  (*
  Things we've learned:
  You can create variables in text or above. The add feature above is nice, because it'll do Excel like copying and increment the last #.
  We've never gotten the mapping to MODBUS to work from the text UI, so put them in the GUI above. 

  Keep in mind that Modbus addresses top out at x.7 and roll over. Like, base 8 or something. Fun. https://autonomylogic.com/docs/2-5-modbus-addressing/

  %QX0.0 here = Coil status address 0 +0 in Radzio Modbus Master Simulator = PLC Address 00001 in C-more
  %QX1.0 here = Coil status address 0 +8 in Radzio Modbus Master Simulator = PLC Address 00009 in C-more


  %IX0.0 here = Input status address 0 +0 in Radzio Modbus Master Simulator = PLC Address 10001 in C-more

  untested
  %QW0.0 here (analog read/write) = Holding registers = 30001?
  %IW0.0 here (analog read) = Input registers = 40001?

  The first 4 input registers are cycling in Radzio. Likely due to some hard coded values for the hardware. 
  From https://autonomylogic.com/docs/2-4-physical-addressing/ 

  There are some hard-coded MODBUS addresses for the hardware. For the current hardware:
  Productivity Open P1AM-100

  Digital In	31, 0, 1, 2, 3, 4	%IX0.0 – %IX0.5

  Digital Out	32, 6, 7, 11, 12, 13, 14	%QX0.0 – %QX0.6

  Analog In	A1, A2, A5, A6	%IW0 – %IW3

  Analog Out	A0	%QW0 – %QW0
  Might be good to avoid those. So we moved everything from %?X0.# to %?X1.# 


  Also not sure why the P1AM LED is cycling along with P_PULSE_1.

  *)

  VAR
      INIT_SUCCESS : BOOL;
      P1AM_INIT0 : P1AM_INIT;
      P1_08TD2_1 : P1_08T;
      P1_16ND3_1: P1_16N; 
      P108SIM_1 : P1_08N;
      
      _TMP_GT21_OUT : BOOL;
      fbPulsePump1: fbPulsePump; 
      fbPulsePump2: fbPulsePump; 
  END_VAR

  P1AM_INIT0(EN := TRUE, INIT := TRUE);
  _TMP_GT21_OUT := GT(P1AM_INIT0.SUCCESS, 0);
  INIT_SUCCESS := _TMP_GT21_OUT;


  P1_08TD2_1(
    SLOT := 1, 
    O1 := P_PULSE_1,
    O2 := P_PULSE_2,
    O3 := P_PULSE_3,
    O4 := P_PULSE_4,
    O5 := P_PULSE_5,
    O6 := P_PULSE_6,
    O7 := P_PULSE_7,
    O8 := P_PULSE_8);
    
  (* This enables the first input module, which is enough to listen to 4 saws (and run 4 pumps). *)
  (* We can run 8 pumps using this frame and hardware, but we'll have to buy an additional input module. *)

  (* And then the slot number are going to get all wonky. But maybe we get rid of the simulator card and we'll be good. *)


  P1_16ND3_1(

     SLOT := 2,

     I1 => INPUT_16_1_01,

     I2 => INPUT_16_1_02,

     I3 => INPUT_16_1_03,

     I4 => INPUT_16_1_04,

     I5 => INPUT_16_1_05,

     I6 => INPUT_16_1_06,

     I7 => INPUT_16_1_07,

     I8 => INPUT_16_1_08,

     I9 => INPUT_16_1_09,

     I10 => INPUT_16_1_10,

     I11 => INPUT_16_1_11,

     I12 => INPUT_16_1_12,

     I13 => INPUT_16_1_13,

     I14 => INPUT_16_1_14,

     I15 => INPUT_16_1_15,

     I16 => INPUT_16_1_16);
    

  (* This enables the SIM module so we can activate the pumps easily from the desktop. *)
  P108SIM_1(
    SLOT := 3,
    I1 => SIM1SW1,
    I2 => SIM1SW2,
    I3 => SIM1SW3,
    I4 => SIM1SW4, 
    I5 => SIM1SW5,
    I6 => SIM1SW6,
    I7 => SIM1SW7,
    I8 => SIM1SW8);



  (* Use a function block to run each pump*)
  fbPulsePump1(IN_1 := SIM1SW1 OR INPUT_16_1_01, IN_2 := SIM1SW2 OR INPUT_16_1_02, IN_3 := SIM1SW3 OR INPUT_16_1_03, PLC_INIT := INIT_SUCCESS);
  P_PULSE_1 := fbPulsePump1.PUMP_PULSE;


  fbPulsePump2(IN_1 := SIM1SW5 OR INPUT_16_1_05, IN_2 := SIM1SW6 OR INPUT_16_1_06, IN_3 := SIM1SW7 OR INPUT_16_1_07, PLC_INIT := INIT_SUCCESS);
  P_PULSE_2 := fbPulsePump2.PUMP_PULSE;
END_PROGRAM


CONFIGURATION Config0

  RESOURCE Res0 ON PLC
    TASK task0(INTERVAL := T#20ms,PRIORITY := 1);
    PROGRAM instance0 WITH task0 : main;
  END_RESOURCE
END_CONFIGURATION
