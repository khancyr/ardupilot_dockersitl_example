#!/bin/bash
set -x
set -e
set -m

echo "Starting ArduPilot instance"

if [ "${MCAST2}" -eq 1 ]; then
    SITL_MCAST="--uart2 mcast:"
    SERIAL2_OPTIONS="SERIAL2_OPTIONS 1024"
fi

if [ -z "${INSTANCE}" ]; then
    I_INSTANCE="-I0"
    INSTANCE=0
else
    I_INSTANCE="-I$(echo $INSTANCE | sed -e 's/-I//')"
fi
if [ "${INSTANCE}" -eq 0 ];then
    TRI="quad"
fi

if [ -z "${SYSID}" ]; then
    SYSID=1
fi

if [ -z "${SITL_PARAMETER_LIST}" ]; then
    SITL_PARAMETER_LIST="/ardupilot/copter.parm"
fi

if [ -z "${SITL_LAT}" ]; then
    SITL_LAT="-35.363261"
fi

if [ -z "${SITL_LON}" ]; then
    SITL_LON="149.165230"
fi

if [ -z "${SITL_ALT}" ]; then
    SITL_ALT="584"
fi

if [ -z "${SITL_HEADING}" ]; then
    SITL_HEADING="353"
fi

SITL_LOCATION="$SITL_LAT,$SITL_LON,$SITL_ALT,$SITL_HEADING"

IDENTITY_FILE=identity${I_INSTANCE}.parm
MASTER_FILE=master_param_fcu${I_INSTANCE}.param
# RANGEFINDER CONFIG
printf "RNGFND1_TYPE 8\nRNGFND1_SCALING 1\nRNGFND1_MIN_CM 5\nRNGFND1_MAX_CM 10000\nSERIAL4_PROTOCOL 9\nSERIAL4_BAUD 115\n" > "$IDENTITY_FILE"

printf "SYSID_THISMAV %s\n%s\n" ${SYSID} "${SERIAL2_OPTIONS}" >> "$IDENTITY_FILE"
echo "INSTANCE:"
echo "$I_INSTANCE"

echo "${IDENTITY_FILE}:"
cat "$IDENTITY_FILE"


#\nSIM_BATT_VOLTAGE,52 # BROKEN!!!
printf "\nSIM_BATT_VOLTAGE,16.4\nBATT_VOLT_PIN,13\nBATT_CURR_PIN,12\n" >> "$MASTER_FILE"
SUREFLITE_PARAMS="$MASTER_FILE"

args="-S $I_INSTANCE --home ${SITL_LOCATION} --model ${TRI} --speedup 1 --uartE=sim:lightwareserial --disable-fgview --defaults ${SITL_PARAMETER_LIST},${IDENTITY_FILE},${SUREFLITE_PARAMS} ${SITL_MCAST}"

echo "args:"
echo "$args"

export MAVLINK20=1
# Start ArduPilot simulator
/ardupilot/arducopter ${args}

