#include "POUS.h"
#include "Config0.h"

void FBPULSEPUMP_init__(FBPULSEPUMP *data__, BOOL retain) {
  __INIT_VAR(data__->EN,__BOOL_LITERAL(TRUE),retain)
  __INIT_VAR(data__->ENO,__BOOL_LITERAL(TRUE),retain)
  __INIT_VAR(data__->IN_1,__BOOL_LITERAL(FALSE),retain)
  __INIT_VAR(data__->IN_2,__BOOL_LITERAL(FALSE),retain)
  __INIT_VAR(data__->IN_3,__BOOL_LITERAL(FALSE),retain)
  __INIT_VAR(data__->PLC_INIT,__BOOL_LITERAL(FALSE),retain)
  __INIT_VAR(data__->PUMP_PULSE,__BOOL_LITERAL(FALSE),retain)
  TON_init__(&data__->TON0,retain);
  TOF_init__(&data__->TOF0,retain);
}

// Code part
void FBPULSEPUMP_body__(FBPULSEPUMP *data__) {
  // Control execution
  if (!__GET_VAR(data__->EN)) {
    __SET_VAR(data__->,ENO,,__BOOL_LITERAL(FALSE));
    return;
  }
  else {
    __SET_VAR(data__->,ENO,,__BOOL_LITERAL(TRUE));
  }
  // Initialise TEMP variables

  if (((__GET_VAR(data__->IN_1,) && __GET_VAR(data__->IN_2,)) && __GET_VAR(data__->IN_3,))) {
    __SET_VAR(data__->TON0.,IN,,(!(__GET_VAR(data__->PUMP_PULSE,)) && __GET_VAR(data__->PLC_INIT,)));
    __SET_VAR(data__->TON0.,PT,,__time_to_timespec(1, 100, 0, 0, 0, 0));
    TON_body__(&data__->TON0);
    __SET_VAR(data__->TOF0.,IN,,__GET_VAR(data__->TON0.Q,));
    __SET_VAR(data__->TOF0.,PT,,__time_to_timespec(1, 300, 0, 0, 0, 0));
    TOF_body__(&data__->TOF0);
    __SET_VAR(data__->,PUMP_PULSE,,__GET_VAR(data__->TOF0.Q,));
  } else {
    __SET_VAR(data__->,PUMP_PULSE,,__BOOL_LITERAL(FALSE));
  };

  goto __end;

__end:
  return;
} // FBPULSEPUMP_body__() 





void MAIN_init__(MAIN *data__, BOOL retain) {
  __INIT_LOCATED(BOOL,__QX1_0,data__->P_PULSE_1,retain)
  __INIT_LOCATED_VALUE(data__->P_PULSE_1,0)
  __INIT_LOCATED(BOOL,__QX1_1,data__->P_PULSE_2,retain)
  __INIT_LOCATED_VALUE(data__->P_PULSE_2,0)
  __INIT_LOCATED(BOOL,__QX1_2,data__->P_PULSE_3,retain)
  __INIT_LOCATED_VALUE(data__->P_PULSE_3,0)
  __INIT_LOCATED(BOOL,__QX1_3,data__->P_PULSE_4,retain)
  __INIT_LOCATED_VALUE(data__->P_PULSE_4,0)
  __INIT_LOCATED(BOOL,__QX1_4,data__->P_PULSE_5,retain)
  __INIT_LOCATED_VALUE(data__->P_PULSE_5,0)
  __INIT_LOCATED(BOOL,__QX1_5,data__->P_PULSE_6,retain)
  __INIT_LOCATED_VALUE(data__->P_PULSE_6,0)
  __INIT_LOCATED(BOOL,__QX1_6,data__->P_PULSE_7,retain)
  __INIT_LOCATED_VALUE(data__->P_PULSE_7,0)
  __INIT_LOCATED(BOOL,__QX1_7,data__->P_PULSE_8,retain)
  __INIT_LOCATED_VALUE(data__->P_PULSE_8,0)
  __INIT_LOCATED(BOOL,__IX1_0,data__->SIM1SW1,retain)
  __INIT_LOCATED_VALUE(data__->SIM1SW1,0)
  __INIT_LOCATED(BOOL,__IX1_1,data__->SIM1SW2,retain)
  __INIT_LOCATED_VALUE(data__->SIM1SW2,0)
  __INIT_LOCATED(BOOL,__IX1_2,data__->SIM1SW3,retain)
  __INIT_LOCATED_VALUE(data__->SIM1SW3,0)
  __INIT_LOCATED(BOOL,__IX1_3,data__->SIM1SW4,retain)
  __INIT_LOCATED_VALUE(data__->SIM1SW4,0)
  __INIT_LOCATED(BOOL,__IX1_4,data__->SIM1SW5,retain)
  __INIT_LOCATED_VALUE(data__->SIM1SW5,0)
  __INIT_LOCATED(BOOL,__IX1_5,data__->SIM1SW6,retain)
  __INIT_LOCATED_VALUE(data__->SIM1SW6,0)
  __INIT_LOCATED(BOOL,__IX1_6,data__->SIM1SW7,retain)
  __INIT_LOCATED_VALUE(data__->SIM1SW7,0)
  __INIT_LOCATED(BOOL,__IX1_7,data__->SIM1SW8,retain)
  __INIT_LOCATED_VALUE(data__->SIM1SW8,0)
  __INIT_LOCATED(BOOL,__IX2_0,data__->INPUT_16_1_01,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_01,0)
  __INIT_LOCATED(BOOL,__IX2_1,data__->INPUT_16_1_02,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_02,0)
  __INIT_LOCATED(BOOL,__IX2_2,data__->INPUT_16_1_03,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_03,0)
  __INIT_LOCATED(BOOL,__IX2_3,data__->INPUT_16_1_04,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_04,0)
  __INIT_LOCATED(BOOL,__IX2_4,data__->INPUT_16_1_05,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_05,0)
  __INIT_LOCATED(BOOL,__IX2_5,data__->INPUT_16_1_06,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_06,0)
  __INIT_LOCATED(BOOL,__IX2_6,data__->INPUT_16_1_07,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_07,0)
  __INIT_LOCATED(BOOL,__IX2_7,data__->INPUT_16_1_08,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_08,0)
  __INIT_LOCATED(BOOL,__IX3_0,data__->INPUT_16_1_09,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_09,0)
  __INIT_LOCATED(BOOL,__IX3_1,data__->INPUT_16_1_10,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_10,0)
  __INIT_LOCATED(BOOL,__IX3_2,data__->INPUT_16_1_11,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_11,0)
  __INIT_LOCATED(BOOL,__IX3_3,data__->INPUT_16_1_12,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_12,0)
  __INIT_LOCATED(BOOL,__IX3_4,data__->INPUT_16_1_13,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_13,0)
  __INIT_LOCATED(BOOL,__IX3_5,data__->INPUT_16_1_14,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_14,0)
  __INIT_LOCATED(BOOL,__IX3_6,data__->INPUT_16_1_15,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_15,0)
  __INIT_LOCATED(BOOL,__IX3_7,data__->INPUT_16_1_16,retain)
  __INIT_LOCATED_VALUE(data__->INPUT_16_1_16,0)
  __INIT_VAR(data__->INIT_SUCCESS,__BOOL_LITERAL(FALSE),retain)
  P1AM_INIT_init__(&data__->P1AM_INIT0,retain);
  P1_08T_init__(&data__->P1_08TD2_1,retain);
  P1_16N_init__(&data__->P1_16ND3_1,retain);
  P1_08N_init__(&data__->P108SIM_1,retain);
  __INIT_VAR(data__->_TMP_GT21_OUT,__BOOL_LITERAL(FALSE),retain)
  FBPULSEPUMP_init__(&data__->FBPULSEPUMP1,retain);
  FBPULSEPUMP_init__(&data__->FBPULSEPUMP2,retain);
}

// Code part
void MAIN_body__(MAIN *data__) {
  // Initialise TEMP variables

  __SET_VAR(data__->P1AM_INIT0.,EN,,__BOOL_LITERAL(TRUE));
  __SET_VAR(data__->P1AM_INIT0.,INIT,,__BOOL_LITERAL(TRUE));
  P1AM_INIT_body__(&data__->P1AM_INIT0);
  __SET_VAR(data__->,_TMP_GT21_OUT,,GT__BOOL__SINT(
    (BOOL)__BOOL_LITERAL(TRUE),
    NULL,
    (UINT)2,
    (SINT)__GET_VAR(data__->P1AM_INIT0.SUCCESS,),
    (SINT)0));
  __SET_VAR(data__->,INIT_SUCCESS,,__GET_VAR(data__->_TMP_GT21_OUT,));
  __SET_VAR(data__->P1_08TD2_1.,SLOT,,1);
  __SET_VAR(data__->P1_08TD2_1.,O1,,__GET_LOCATED(data__->P_PULSE_1,));
  __SET_VAR(data__->P1_08TD2_1.,O2,,__GET_LOCATED(data__->P_PULSE_2,));
  __SET_VAR(data__->P1_08TD2_1.,O3,,__GET_LOCATED(data__->P_PULSE_3,));
  __SET_VAR(data__->P1_08TD2_1.,O4,,__GET_LOCATED(data__->P_PULSE_4,));
  __SET_VAR(data__->P1_08TD2_1.,O5,,__GET_LOCATED(data__->P_PULSE_5,));
  __SET_VAR(data__->P1_08TD2_1.,O6,,__GET_LOCATED(data__->P_PULSE_6,));
  __SET_VAR(data__->P1_08TD2_1.,O7,,__GET_LOCATED(data__->P_PULSE_7,));
  __SET_VAR(data__->P1_08TD2_1.,O8,,__GET_LOCATED(data__->P_PULSE_8,));
  P1_08T_body__(&data__->P1_08TD2_1);
  __SET_VAR(data__->P1_16ND3_1.,SLOT,,2);
  P1_16N_body__(&data__->P1_16ND3_1);
  __SET_LOCATED(data__->,INPUT_16_1_01,,__GET_VAR(data__->P1_16ND3_1.I1));
  __SET_LOCATED(data__->,INPUT_16_1_02,,__GET_VAR(data__->P1_16ND3_1.I2));
  __SET_LOCATED(data__->,INPUT_16_1_03,,__GET_VAR(data__->P1_16ND3_1.I3));
  __SET_LOCATED(data__->,INPUT_16_1_04,,__GET_VAR(data__->P1_16ND3_1.I4));
  __SET_LOCATED(data__->,INPUT_16_1_05,,__GET_VAR(data__->P1_16ND3_1.I5));
  __SET_LOCATED(data__->,INPUT_16_1_06,,__GET_VAR(data__->P1_16ND3_1.I6));
  __SET_LOCATED(data__->,INPUT_16_1_07,,__GET_VAR(data__->P1_16ND3_1.I7));
  __SET_LOCATED(data__->,INPUT_16_1_08,,__GET_VAR(data__->P1_16ND3_1.I8));
  __SET_LOCATED(data__->,INPUT_16_1_09,,__GET_VAR(data__->P1_16ND3_1.I9));
  __SET_LOCATED(data__->,INPUT_16_1_10,,__GET_VAR(data__->P1_16ND3_1.I10));
  __SET_LOCATED(data__->,INPUT_16_1_11,,__GET_VAR(data__->P1_16ND3_1.I11));
  __SET_LOCATED(data__->,INPUT_16_1_12,,__GET_VAR(data__->P1_16ND3_1.I12));
  __SET_LOCATED(data__->,INPUT_16_1_13,,__GET_VAR(data__->P1_16ND3_1.I13));
  __SET_LOCATED(data__->,INPUT_16_1_14,,__GET_VAR(data__->P1_16ND3_1.I14));
  __SET_LOCATED(data__->,INPUT_16_1_15,,__GET_VAR(data__->P1_16ND3_1.I15));
  __SET_LOCATED(data__->,INPUT_16_1_16,,__GET_VAR(data__->P1_16ND3_1.I16));
  __SET_VAR(data__->P108SIM_1.,SLOT,,3);
  P1_08N_body__(&data__->P108SIM_1);
  __SET_LOCATED(data__->,SIM1SW1,,__GET_VAR(data__->P108SIM_1.I1));
  __SET_LOCATED(data__->,SIM1SW2,,__GET_VAR(data__->P108SIM_1.I2));
  __SET_LOCATED(data__->,SIM1SW3,,__GET_VAR(data__->P108SIM_1.I3));
  __SET_LOCATED(data__->,SIM1SW4,,__GET_VAR(data__->P108SIM_1.I4));
  __SET_LOCATED(data__->,SIM1SW5,,__GET_VAR(data__->P108SIM_1.I5));
  __SET_LOCATED(data__->,SIM1SW6,,__GET_VAR(data__->P108SIM_1.I6));
  __SET_LOCATED(data__->,SIM1SW7,,__GET_VAR(data__->P108SIM_1.I7));
  __SET_LOCATED(data__->,SIM1SW8,,__GET_VAR(data__->P108SIM_1.I8));
  __SET_VAR(data__->FBPULSEPUMP1.,IN_1,,(__GET_LOCATED(data__->SIM1SW1,) || __GET_LOCATED(data__->INPUT_16_1_01,)));
  __SET_VAR(data__->FBPULSEPUMP1.,IN_2,,(__GET_LOCATED(data__->SIM1SW2,) || __GET_LOCATED(data__->INPUT_16_1_02,)));
  __SET_VAR(data__->FBPULSEPUMP1.,IN_3,,(__GET_LOCATED(data__->SIM1SW3,) || __GET_LOCATED(data__->INPUT_16_1_03,)));
  __SET_VAR(data__->FBPULSEPUMP1.,PLC_INIT,,__GET_VAR(data__->INIT_SUCCESS,));
  FBPULSEPUMP_body__(&data__->FBPULSEPUMP1);
  __SET_LOCATED(data__->,P_PULSE_1,,__GET_VAR(data__->FBPULSEPUMP1.PUMP_PULSE,));
  __SET_VAR(data__->FBPULSEPUMP2.,IN_1,,(__GET_LOCATED(data__->SIM1SW5,) || __GET_LOCATED(data__->INPUT_16_1_05,)));
  __SET_VAR(data__->FBPULSEPUMP2.,IN_2,,(__GET_LOCATED(data__->SIM1SW6,) || __GET_LOCATED(data__->INPUT_16_1_06,)));
  __SET_VAR(data__->FBPULSEPUMP2.,IN_3,,(__GET_LOCATED(data__->SIM1SW7,) || __GET_LOCATED(data__->INPUT_16_1_07,)));
  __SET_VAR(data__->FBPULSEPUMP2.,PLC_INIT,,__GET_VAR(data__->INIT_SUCCESS,));
  FBPULSEPUMP_body__(&data__->FBPULSEPUMP2);
  __SET_LOCATED(data__->,P_PULSE_2,,__GET_VAR(data__->FBPULSEPUMP2.PUMP_PULSE,));

  goto __end;

__end:
  return;
} // MAIN_body__() 





