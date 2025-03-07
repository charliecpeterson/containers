#!/bin/bash
export JOB=`echo ch2.inp | sed 's/\(.*\)\.[^\.]*/\1/'`
export GMSPATH=/apps/gamess
export SCR=$PWD/${JOB}-scratch
export USERSCR=$SCR
mkdir $SCR
cp ${JOB}.inp ${SCR}/${JOB}.F05
export AUXDATA=$GMSPATH/auxdata
export  EXTBAS=/dev/null
export  NUCBAS=/dev/null
export  POSBAS=/dev/null
export ERICFMT=$AUXDATA/ericfmt.dat
export MCPPATH=$AUXDATA/MCP
export BASPATH=$AUXDATA/BASES
export QUANPOL=$AUXDATA/QUANPOL
export  MAKEFP=$USERSCR/$JOB.efp
export   GAMMA=$USERSCR/$JOB.gamma
export TRAJECT=$USERSCR/$JOB.trj
export RESTART=$USERSCR/$JOB.rst
export   INPUT=$SCR/$JOB.F05
export   PUNCH=$USERSCR/$JOB.dat
export  AOINTS=$SCR/$JOB.F08
export  MOINTS=$SCR/$JOB.F09
export DICTNRY=$SCR/$JOB.F10
export DRTFILE=$SCR/$JOB.F11
export CIVECTR=$SCR/$JOB.F12
export CASINTS=$SCR/$JOB.F13
export  CIINTS=$SCR/$JOB.F14
export  WORK15=$SCR/$JOB.F15
export  WORK16=$SCR/$JOB.F16
export CSFSAVE=$SCR/$JOB.F17
export FOCKDER=$SCR/$JOB.F18
export  WORK19=$SCR/$JOB.F19
export  DASORT=$SCR/$JOB.F20
export DFTINTS=$SCR/$JOB.F21
export DFTGRID=$SCR/$JOB.F22
export  JKFILE=$SCR/$JOB.F23
export  ORDINT=$SCR/$JOB.F24
export  EFPIND=$SCR/$JOB.F25
export PCMDATA=$SCR/$JOB.F26
export PCMINTS=$SCR/$JOB.F27
export SVPWRK1=$SCR/$JOB.F26
export SVPWRK2=$SCR/$JOB.F27
export COSCAV=$SCR/$JOB.F26
export COSDATA=$USERSCR/$JOB.cosmo
export COSPOT=$USERSCR/$JOB.pot
export  MLTPL=$SCR/$JOB.F28
export  MLTPLT=$SCR/$JOB.F29
export  DAFL30=$SCR/$JOB.F30
export  SOINTX=$SCR/$JOB.F31
export  SOINTY=$SCR/$JOB.F32
export  SOINTZ=$SCR/$JOB.F33
export  SORESC=$SCR/$JOB.F34
export GCILIST=$SCR/$JOB.F37
export HESSIAN=$SCR/$JOB.F38
export QMMMTEI=$SCR/$JOB.F39
export SOCCDAT=$SCR/$JOB.F40
export  AABB41=$SCR/$JOB.F41
export  BBAA42=$SCR/$JOB.F42
export  BBBB43=$SCR/$JOB.F43
export  MCQD50=$SCR/$JOB.F50
export  MCQD51=$SCR/$JOB.F51
export  MCQD52=$SCR/$JOB.F52
export  MCQD53=$SCR/$JOB.F53
export  MCQD54=$SCR/$JOB.F54
export  MCQD55=$SCR/$JOB.F55
export  MCQD56=$SCR/$JOB.F56
export  MCQD57=$SCR/$JOB.F57
export  MCQD58=$SCR/$JOB.F58
export  MCQD59=$SCR/$JOB.F59
export  MCQD60=$SCR/$JOB.F60
export  MCQD61=$SCR/$JOB.F61
export  MCQD62=$SCR/$JOB.F62
export  MCQD63=$SCR/$JOB.F63
export  MCQD64=$SCR/$JOB.F64
export NMRINT1=$SCR/$JOB.F61
export NMRINT2=$SCR/$JOB.F62
export NMRINT3=$SCR/$JOB.F63
export NMRINT4=$SCR/$JOB.F64
export NMRINT5=$SCR/$JOB.F65
export NMRINT6=$SCR/$JOB.F66
export DCPHFH2=$SCR/$JOB.F67
export DCPHF21=$SCR/$JOB.F68
export ELNUINT=$SCR/$JOB.F67
export NUNUINT=$SCR/$JOB.F68
export   GVVPT=$SCR/$JOB.F69
export NUMOIN=$SCR/$JOB.F69
export NUMOCAS=$SCR/$JOB.F70
export NUELMO=$SCR/$JOB.F71
export NUELCAS=$SCR/$JOB.F72
export RIVMAT=$SCR/$JOB.F51
export RIT2A=$SCR/$JOB.F52
export RIT3A=$SCR/$JOB.F53
export RIT2B=$SCR/$JOB.F54
export RIT3B=$SCR/$JOB.F55
export GMCREF=$SCR/$JOB.F70
export GMCO2R=$SCR/$JOB.F71
export GMCROC=$SCR/$JOB.F72
export GMCOOC=$SCR/$JOB.F73
export GMCCC0=$SCR/$JOB.F74
export GMCHMA=$SCR/$JOB.F75
export GMCEI1=$SCR/$JOB.F76
export GMCEI2=$SCR/$JOB.F77
export GMCEOB=$SCR/$JOB.F78
export GMCEDT=$SCR/$JOB.F79
export GMCERF=$SCR/$JOB.F80
export GMCHCR=$SCR/$JOB.F81
export GMCGJK=$SCR/$JOB.F82
export GMCGAI=$SCR/$JOB.F83
export GMCGEO=$SCR/$JOB.F84
export GMCTE1=$SCR/$JOB.F85
export GMCTE2=$SCR/$JOB.F86
export GMCHEF=$SCR/$JOB.F87
export GMCMOL=$SCR/$JOB.F88
export GMCMOS=$SCR/$JOB.F89
export GMCWGT=$SCR/$JOB.F90
export GMCRM2=$SCR/$JOB.F91
export GMCRM1=$SCR/$JOB.F92
export GMCR00=$SCR/$JOB.F93
export GMCRP1=$SCR/$JOB.F94
export GMCRP2=$SCR/$JOB.F95
export GMCVEF=$SCR/$JOB.F96
export GMCDIN=$SCR/$JOB.F97
export GMC2SZ=$SCR/$JOB.F98
export GMCCCS=$SCR/$JOB.F99

export  CCREST=$SCR/$JOB.F70
export  CCDIIS=$SCR/$JOB.F71
export  CCINTS=$SCR/$JOB.F72
export CCT1AMP=$SCR/$JOB.F73
export CCT2AMP=$SCR/$JOB.F74
export CCT3AMP=$SCR/$JOB.F75
export    CCVM=$SCR/$JOB.F76
export    CCVE=$SCR/$JOB.F77
export CCQUADS=$SCR/$JOB.F78
export QUADSVO=$SCR/$JOB.F79
export EOMSTAR=$SCR/$JOB.F80
export EOMVEC1=$SCR/$JOB.F81
export EOMVEC2=$SCR/$JOB.F82
export  EOMHC1=$SCR/$JOB.F83
export  EOMHC2=$SCR/$JOB.F84
export EOMHHHH=$SCR/$JOB.F85
export EOMPPPP=$SCR/$JOB.F86
export EOMRAMP=$SCR/$JOB.F87
export EOMRTMP=$SCR/$JOB.F88
export EOMDG12=$SCR/$JOB.F89
export    MMPP=$SCR/$JOB.F90
export   MMHPP=$SCR/$JOB.F91
export MMCIVEC=$SCR/$JOB.F92
export MMCIVC1=$SCR/$JOB.F93
export MMCIITR=$SCR/$JOB.F94
export  EOMVL1=$SCR/$JOB.F95
export  EOMVL2=$SCR/$JOB.F96
export EOMLVEC=$SCR/$JOB.F97
export  EOMHL1=$SCR/$JOB.F98
export  EOMHL2=$SCR/$JOB.F99
export  CCVVVV=$SCR/$JOB.F80

export AMPROCC=$SCR/$JOB.F70
export ITOPNCC=$SCR/$JOB.F71
export FOCKMTX=$SCR/$JOB.F72
export  LAMB23=$SCR/$JOB.F73
export   VHHAA=$SCR/$JOB.F74
export   VHHBB=$SCR/$JOB.F75
export   VHHAB=$SCR/$JOB.F76
export    VMAA=$SCR/$JOB.F77
export    VMBB=$SCR/$JOB.F78
export    VMAB=$SCR/$JOB.F79
export    VMBA=$SCR/$JOB.F80
export  VHPRAA=$SCR/$JOB.F81
export  VHPRBB=$SCR/$JOB.F82
export  VHPRAB=$SCR/$JOB.F83
export  VHPLAA=$SCR/$JOB.F84
export  VHPLBB=$SCR/$JOB.F85
export  VHPLAB=$SCR/$JOB.F86
export  VHPLBA=$SCR/$JOB.F87
export    VEAA=$SCR/$JOB.F88
export    VEBB=$SCR/$JOB.F89
export    VEAB=$SCR/$JOB.F90
export    VEBA=$SCR/$JOB.F91
export   VPPPP=$SCR/$JOB.F92
export INTERM1=$SCR/$JOB.F93
export INTERM2=$SCR/$JOB.F94
export INTERM3=$SCR/$JOB.F95
export ITSPACE=$SCR/$JOB.F96
export INSTART=$SCR/$JOB.F97
export  ITSPC3=$SCR/$JOB.F98

cd $SCR
#gamess.00.x


