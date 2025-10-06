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
    INPUT_16_1_02 AT %IX2.1 : BOOL := 0;
    INPUT_16_1_03 AT %IX2.2 : BOOL := 0;
    INPUT_16_1_04 AT %IX2.3 : BOOL := 0;
    INPUT_16_1_05 AT %IX2.4 : BOOL := 0;
    INPUT_16_1_06 AT %IX2.5 : BOOL := 0;
    INPUT_16_1_07 AT %IX2.6 : BOOL := 0;
    INPUT_16_1_08 AT %IX2.7 : BOOL := 0;
    INPUT_16_1_09 AT %IX3.0 : BOOL := 0;
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

(*DBG:char md5[] = "7b70ab705c45086738ff4992e541b223";*)
(*DBG:/**)
(*DBG: * This file is part of OpenPLC Runtime*)
(*DBG: **)
(*DBG: * Copyright (C) 2023 Autonomy, GP Orcullo*)
(*DBG: * Based on the work by GP Orcullo on Beremiz for uC*)
(*DBG: **)
(*DBG: * This program is free software; you can redistribute it and/or*)
(*DBG: * modify it under the terms of the GNU General Public License*)
(*DBG: * as published by the Free Software Foundation; either version 2*)
(*DBG: * of the License, or (at your option) any later version.*)
(*DBG: **)
(*DBG: * This program is distributed in the hope that it will be useful,*)
(*DBG: * but WITHOUT ANY WARRANTY; without even the implied warranty of*)
(*DBG: * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the*)
(*DBG: * GNU General Public License for more details.*)
(*DBG: **)
(*DBG: * You should have received a copy of the GNU General Public License*)
(*DBG: * along with this program; If not, see <http://www.gnu.org/licenses/>.*)
(*DBG: **)
(*DBG: */*)
(*DBG:*)
(*DBG:#include <stdbool.h>*)
(*DBG:*)
(*DBG:#include "iec_types_all.h"*)
(*DBG:#include "POUS.h"*)
(*DBG:*)
(*DBG:#define SAME_ENDIANNESS      0*)
(*DBG:#define REVERSE_ENDIANNESS   1*)
(*DBG:*)
(*DBG:uint8_t endianness;*)
(*DBG:*)
(*DBG:*)
(*DBG:extern MAIN RES0__INSTANCE0;*)
(*DBG:*)
(*DBG:static const struct {*)
(*DBG:    void *ptr;*)
(*DBG:    __IEC_types_enum type;*)
(*DBG:} debug_vars[] = {*)
(*DBG:    {&(RES0__INSTANCE0.P_PULSE_1), BOOL_O_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P_PULSE_2), BOOL_O_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P_PULSE_3), BOOL_O_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P_PULSE_4), BOOL_O_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P_PULSE_5), BOOL_O_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P_PULSE_6), BOOL_O_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P_PULSE_7), BOOL_O_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P_PULSE_8), BOOL_O_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.SIM1SW1), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.SIM1SW2), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.SIM1SW3), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.SIM1SW4), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.SIM1SW5), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.SIM1SW6), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.SIM1SW7), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.SIM1SW8), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_01), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_02), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_03), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_04), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_05), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_06), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_07), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_08), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_09), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_10), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_11), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_12), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_13), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_14), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_15), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INPUT_16_1_16), BOOL_P_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.INIT_SUCCESS), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1AM_INIT0.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1AM_INIT0.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1AM_INIT0.INIT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1AM_INIT0.SUCCESS), SINT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_08TD2_1.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_08TD2_1.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_08TD2_1.SLOT), SINT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_08TD2_1.O1), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_08TD2_1.O2), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_08TD2_1.O3), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_08TD2_1.O4), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_08TD2_1.O5), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_08TD2_1.O6), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_08TD2_1.O7), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_08TD2_1.O8), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_08TD2_1.DUMMY), SINT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.SLOT), SINT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I1), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I2), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I3), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I4), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I5), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I6), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I7), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I8), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I9), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I10), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I11), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I12), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I13), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I14), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I15), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P1_16ND3_1.I16), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P108SIM_1.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P108SIM_1.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P108SIM_1.SLOT), SINT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P108SIM_1.I1), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P108SIM_1.I2), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P108SIM_1.I3), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P108SIM_1.I4), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P108SIM_1.I5), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P108SIM_1.I6), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P108SIM_1.I7), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.P108SIM_1.I8), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0._TMP_GT21_OUT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.IN_1), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.IN_2), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.IN_3), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.PLC_INIT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.PUMP_PULSE), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TON0.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TON0.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TON0.IN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TON0.PT), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TON0.Q), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TON0.ET), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TON0.STATE), SINT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TON0.PREV_IN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TON0.CURRENT_TIME), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TON0.START_TIME), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TOF0.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TOF0.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TOF0.IN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TOF0.PT), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TOF0.Q), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TOF0.ET), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TOF0.STATE), SINT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TOF0.PREV_IN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TOF0.CURRENT_TIME), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP1.TOF0.START_TIME), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.IN_1), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.IN_2), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.IN_3), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.PLC_INIT), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.PUMP_PULSE), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TON0.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TON0.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TON0.IN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TON0.PT), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TON0.Q), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TON0.ET), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TON0.STATE), SINT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TON0.PREV_IN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TON0.CURRENT_TIME), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TON0.START_TIME), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TOF0.EN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TOF0.ENO), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TOF0.IN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TOF0.PT), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TOF0.Q), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TOF0.ET), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TOF0.STATE), SINT_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TOF0.PREV_IN), BOOL_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TOF0.CURRENT_TIME), TIME_ENUM},*)
(*DBG:    {&(RES0__INSTANCE0.FBPULSEPUMP2.TOF0.START_TIME), TIME_ENUM},*)
(*DBG:};*)
(*DBG:*)
(*DBG:#define VAR_COUNT               134*)
(*DBG:*)
(*DBG:uint16_t get_var_count(void)*)
(*DBG:{*)
(*DBG:    return VAR_COUNT;*)
(*DBG:}*)
(*DBG:*)
(*DBG:size_t get_var_size(size_t idx)*)
(*DBG:{*)
(*DBG:    if (idx >= VAR_COUNT)*)
(*DBG:    {*)
(*DBG:        return 0;*)
(*DBG:    }*)
(*DBG:    switch (debug_vars[idx].type) {*)
(*DBG:    case TIME_ENUM:*)
(*DBG:        return sizeof(TIME);*)
(*DBG:    case BOOL_ENUM:*)
(*DBG:    case BOOL_O_ENUM:*)
(*DBG:    case BOOL_P_ENUM:*)
(*DBG:        return sizeof(BOOL);*)
(*DBG:    case SINT_ENUM:*)
(*DBG:        return sizeof(SINT);*)
(*DBG:    default:*)
(*DBG:        return 0;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void *get_var_addr(size_t idx)*)
(*DBG:{*)
(*DBG:    void *ptr = debug_vars[idx].ptr;*)
(*DBG:*)
(*DBG:    switch (debug_vars[idx].type) {*)
(*DBG:    case TIME_ENUM:*)
(*DBG:        return (void *)&((__IEC_TIME_t *) ptr)->value;*)
(*DBG:    case BOOL_ENUM:*)
(*DBG:        return (void *)&((__IEC_BOOL_t *) ptr)->value;*)
(*DBG:    case BOOL_O_ENUM:*)
(*DBG:    case BOOL_P_ENUM:*)
(*DBG:        return (void *)((((__IEC_BOOL_p *) ptr)->flags & __IEC_FORCE_FLAG) *)
(*DBG:                        ? &(((__IEC_BOOL_p *) ptr)->fvalue) *)
(*DBG:                        : ((__IEC_BOOL_p *) ptr)->value);*)
(*DBG:    case SINT_ENUM:*)
(*DBG:        return (void *)&((__IEC_SINT_t *) ptr)->value;*)
(*DBG:    default:*)
(*DBG:        return 0;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void force_var(size_t idx, bool forced, void *val)*)
(*DBG:{*)
(*DBG:    void *ptr = debug_vars[idx].ptr;*)
(*DBG:*)
(*DBG:    if (forced) {*)
(*DBG:        size_t var_size = get_var_size(idx);*)
(*DBG:        switch (debug_vars[idx].type) {*)
(*DBG:        case TIME_ENUM: {*)
(*DBG:            memcpy(&((__IEC_TIME_t *) ptr)->value, val, var_size);*)
(*DBG:            //((__IEC_TIME_t *) ptr)->value = *((TIME *) val);*)
(*DBG:            ((__IEC_TIME_t *) ptr)->flags |= __IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:        case BOOL_ENUM: {*)
(*DBG:            memcpy(&((__IEC_BOOL_t *) ptr)->value, val, var_size);*)
(*DBG:            //((__IEC_BOOL_t *) ptr)->value = *((BOOL *) val);*)
(*DBG:            ((__IEC_BOOL_t *) ptr)->flags |= __IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:        case BOOL_O_ENUM: {*)
(*DBG:            memcpy((((__IEC_BOOL_p *) ptr)->value), val, var_size);*)
(*DBG:            //*(((__IEC_BOOL_p *) ptr)->value) = *((BOOL *) val);*)
(*DBG:            ((__IEC_BOOL_p *) ptr)->flags |= __IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:        case BOOL_P_ENUM: {*)
(*DBG:            memcpy(&((__IEC_BOOL_p *) ptr)->fvalue, val, var_size);*)
(*DBG:            //((__IEC_BOOL_p *) ptr)->fvalue = *((BOOL *) val);*)
(*DBG:            ((__IEC_BOOL_p *) ptr)->flags |= __IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:        case SINT_ENUM: {*)
(*DBG:            memcpy(&((__IEC_SINT_t *) ptr)->value, val, var_size);*)
(*DBG:            //((__IEC_SINT_t *) ptr)->value = *((SINT *) val);*)
(*DBG:            ((__IEC_SINT_t *) ptr)->flags |= __IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:        default:*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:    } else {*)
(*DBG:        switch (debug_vars[idx].type) {*)
(*DBG:        case TIME_ENUM:*)
(*DBG:            ((__IEC_TIME_t *) ptr)->flags &= ~__IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        case BOOL_ENUM:*)
(*DBG:            ((__IEC_BOOL_t *) ptr)->flags &= ~__IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        case BOOL_O_ENUM:*)
(*DBG:        case BOOL_P_ENUM:*)
(*DBG:            ((__IEC_BOOL_p *) ptr)->flags &= ~__IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        case SINT_ENUM:*)
(*DBG:            ((__IEC_SINT_t *) ptr)->flags &= ~__IEC_FORCE_FLAG;*)
(*DBG:            break;*)
(*DBG:        default:*)
(*DBG:            break;*)
(*DBG:        }*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void swap_bytes(void *ptr, size_t size) *)
(*DBG:{*)
(*DBG:    uint8_t *bytePtr = (uint8_t *)ptr;*)
(*DBG:    size_t i;*)
(*DBG:    for (i = 0; i < size / 2; ++i) *)
(*DBG:    {*)
(*DBG:        uint8_t temp = bytePtr[i];*)
(*DBG:        bytePtr[i] = bytePtr[size - 1 - i];*)
(*DBG:        bytePtr[size - 1 - i] = temp;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void trace_reset(void)*)
(*DBG:{*)
(*DBG:    for (size_t i=0; i < VAR_COUNT; i++) *)
(*DBG:    {*)
(*DBG:        force_var(i, false, 0);*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void set_trace(size_t idx, bool forced, void *val)*)
(*DBG:{*)
(*DBG:    if (idx >= 0 && idx < VAR_COUNT) *)
(*DBG:    {*)
(*DBG:        if (endianness == REVERSE_ENDIANNESS)*)
(*DBG:        {*)
(*DBG:            // Aaaaarghhhh... Stupid AVR is Big Endian.*)
(*DBG:            swap_bytes(val, get_var_size(idx));*)
(*DBG:        }*)
(*DBG:*)
(*DBG:        force_var(idx, forced, val);*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)
(*DBG:void set_endianness(uint8_t value)*)
(*DBG:{*)
(*DBG:    if (value == SAME_ENDIANNESS || value == REVERSE_ENDIANNESS)*)
(*DBG:    {*)
(*DBG:        endianness = value;*)
(*DBG:    }*)
(*DBG:}*)
(*DBG:*)