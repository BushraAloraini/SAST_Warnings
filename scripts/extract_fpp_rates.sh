#!/bin/bash
#
#  This script is to extract TFP, FFP1, and FFP2 rates from
#  "FFP_warnings" file that includes traced line of code
#  and save the output into "FP_rates" file
#  
# 
#


WDIR=$(pwd)
declare -a arrayname=("RATS" "Flawfinder" "cppcheck" "clang" "PVS-Studio" "Parasoft")
tracing_list="FFP_warnings.csv"

output="FP_rates"
IVR="Input Validation and Representation"
API="API Abuse"
SF="Security Features"
CQ="Code Quality" 
TS="Time and State"
Err="Errors"
ENC="Encapsulation"
ENV="Environment"


for i in "${tool[@]}"
do
    tool=${arrayname[$i]}
    echo "" >> $output
    echo "Tool=  $tool " >> $output
    echo "">> $output
    echo " class, TFP, FFP1, FFP2, FFP3, total, OR"  >> $output


    IVR_TFP=$(awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "TFP") {print $0}'| cut -d',' -f16- | grep -c "$IVR" )
    IVR_FFP1=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP1") {print $0}' | cut -d',' -f16- | grep -c "$IVR" )
    IVR_FFP2=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP2") {print $0}' | cut -d',' -f16- | grep -c "$IVR" )
    IVR_FFP3=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP3") {print $0}' | cut -d',' -f16- | grep -c "$IVR" )
    IVR_total=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | cut -d',' -f16- | grep -c "$IVR" )
    echo "IVR, $IVR_TFP, $IVR_FFP1, $IVR_FFP2, $IVR_FFP3, $IVR_total, "  >> $output

    API_TFP=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "TFP") {print $0}' | cut -d',' -f16- | grep -c "$API" )
    API_FFP1=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP1") {print $0}' | cut -d',' -f16- | grep -c "$API" )
    API_FFP2=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP2") {print $0}' | cut -d',' -f16- | grep -c "$API" )
    API_FFP3=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP3") {print $0}' | cut -d',' -f16- | grep -c "$API" )
    API_total=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | cut -d',' -f16- | grep -c "$API" )
    echo "API, $API_TFP, $API_FFP1 , $API_FFP2, $API_FFP3, $API_total, " >> $output

    SF_TFP=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "TFP") {print $0}' | cut -d',' -f16- | grep -c "$SF" )
    SF_FFP1=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP1") {print $0}' | cut -d',' -f16- | grep -c "$SF" )
    SF_FFP2=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP2") {print $0}' | cut -d',' -f16- | grep -c "$SF" )
    SF_FFP3=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP3") {print $0}' | cut -d',' -f16- | grep -c "$SF" )
    SF_total=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | cut -d',' -f16- | grep -c "$SF" )
    echo "SF, $SF_TFP, $SF_FFP1 , $SF_FFP2, $SF_FFP3, $SF_total, " >> $output

    CQ_TFP=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "TFP") {print $0}' | cut -d',' -f16- | grep -c "$CQ")
    CQ_FFP1=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP1") {print $0}' | cut -d',' -f16- | grep -c "$CQ")
    CQ_FFP2=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP2") {print $0}' | cut -d',' -f16- | grep -c "$CQ")
    CQ_FFP3=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP3") {print $0}' | cut -d',' -f16- | grep -c "$CQ")
    CQ_total=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | cut -d',' -f16- | grep -c "$CQ")
    echo "CQ, $CQ_TFP, $CQ_FFP1 , $CQ_FFP2, $CQ_FFP3, $CQ_total, " >> $output

    TS_TFP=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "TFP") {print $0}' | cut -d',' -f16- | grep -c "$TS" )
    TS_FFP1=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP1") {print $0}' | cut -d',' -f16- | grep -c "$TS" )
    TS_FFP2=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP2") {print $0}' | cut -d',' -f16- | grep -c "$TS" )
    TS_FFP3=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP3") {print $0}' | cut -d',' -f16- | grep -c "$TS" )
    TS_total=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | cut -d',' -f16- | grep -c "$TS" )
    echo "TS, $TS_TFP, $TS_FFP1 , $TS_FFP2, $TS_FFP3, $TS_total, " >> $output

    ERR_TFP=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "TFP") {print $0}' | cut -d',' -f16- | grep -c "$ERR" )
    ERR_FFP1=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP1") {print $0}' | cut -d',' -f16- | grep -c "$ERR" )
    ERR_FFP2=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP2") {print $0}' | cut -d',' -f16- | grep -c "$ERR" )
    ERR_FFP3=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP3") {print $0}' | cut -d',' -f16- | grep -c "$ERR" )
    ERR_total=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | cut -d',' -f16- | grep -c "$ERR" )
    echo "ERR, $ERR_TFP, $ERR_FFP1 , $ERR_FFP2, $ERR_FFP3, $ERR_total, " >> $output

    ENC_TFP=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "TFP") {print $0}' | cut -d',' -f16- | grep -c "$ENC" )
    ENC_FFP1=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP1") {print $0}' | cut -d',' -f16- | grep -c "$ENC" )
    ENC_FFP2=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP2") {print $0}' | cut -d',' -f16- | grep -c "$ENC" )
    ENC_FFP3=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP3") {print $0}' | cut -d',' -f16- | grep -c "$ENC" )
    ENC_total=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | cut -d',' -f16- | grep -c "$ENC" )
    echo "ENC, $ENC_TFP , $ENC_FFP1 , $ENC_FFP2, $ENC_FFP3, $ENC_total, " >> $output

    ENV_TFP=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "TFP") {print $0}' | cut -d',' -f16- | grep -c "$ENV" )
    ENV_FFP1=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP1") {print $0}' | cut -d',' -f16- | grep -c "$ENV" )
    ENV_FFP2=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP2") {print $0}' | cut -d',' -f16- | grep -c "$ENV" )
    ENV_FFP3=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | awk -F"," '($15 ~ "FFP3") {print $0}' | cut -d',' -f16- | grep -c "$ENV" )
    ENV_total=$(  awk -F"," -v var="$tool" '($4 ~ var) {print $0}' $tracing_list | cut -d',' -f16- | grep -c "$ENV" )
    echo "ENV, $ENV_TFP, $ENV_FFP1 , $ENV_FFP2, $ENV_FFP3, $ENV_total, " >> $output
 
done
