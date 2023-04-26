{-# OPTIONS_GHC -w #-}
module Parser
  ( parseJamba,
    parseJambaProgram
  ) where

import Data.ByteString.Lazy.Char8 (ByteString)
import Data.Maybe (fromJust)
import Data.Monoid (First (..))

import qualified Lexer as L
import AST
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.1.1

data HappyAbsSyn t14 t15 t16 t17 t18 t19 t20
	= HappyTerminal (L.RangedToken)
	| HappyErrorToken Prelude.Int
	| HappyAbsSyn4 (Type L.Range)
	| HappyAbsSyn6 (Argument L.Range)
	| HappyAbsSyn7 (Dec L.Range)
	| HappyAbsSyn8 ([Dec L.Range])
	| HappyAbsSyn9 (Name L.Range)
	| HappyAbsSyn10 (Exp L.Range)
	| HappyAbsSyn14 t14
	| HappyAbsSyn15 t15
	| HappyAbsSyn16 t16
	| HappyAbsSyn17 t17
	| HappyAbsSyn18 t18
	| HappyAbsSyn19 t19
	| HappyAbsSyn20 t20

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,378) ([0,0,0,0,64,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,0,2,256,4096,0,0,0,0,0,0,0,16384,0,0,0,0,0,0,16384,0,0,16,4352,0,0,0,4,256,12288,1,1024,16384,4,0,0,4,0,0,512,0,0,32,0,2236,1088,0,0,8192,1,0,2048,4,0,0,0,1024,16384,4,0,0,256,0,0,0,0,0,0,0,0,0,0,61440,2303,0,448,17408,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1,0,0,2236,1088,0,8944,4352,0,52160,20479,0,0,0,0,0,0,0,0,0,32,0,0,256,0,65280,47,0,0,128,0,8944,4864,0,0,2048,0,0,8192,0,0,32768,0,0,0,2,0,0,8,0,0,32,0,0,128,0,0,512,0,0,2048,0,0,8192,0,0,0,0,0,192,0,0,65472,19,0,16,0,0,0,0,0,8944,4352,0,35776,17408,0,12032,4098,1,48128,16392,4,61440,34,17,49152,139,68,0,559,272,0,2236,1088,0,8944,4352,0,35776,17408,0,12032,4098,1,48128,16392,4,0,0,0,0,65472,1,0,65280,3,0,15360,0,0,61440,0,0,49152,3,0,0,15,0,0,60,0,0,240,0,0,0,0,0,0,0,0,12288,0,0,49152,0,0,0,4096,0,12032,4098,1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8944,4352,0,0,0,0,0,4095,0,0,16380,2,61440,34,17,0,65472,35,0,128,0,0,0,256,0,0,0,0,35776,17408,0,0,36863,0,0,0,0,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseJamba","type","typeAnnotation","argument","dec","decs","name","exp","expapp","expcond","atom","many__argument__","many__dec__","optional__typeAnnotation__","sepBy__exp__','__","many_rev__argument__","many_rev__dec__","sepBy_rev__exp__','__","identifier","string","integer","let","in","if","then","else","'+'","'-'","'*'","'/'","'='","'!='","'<'","'<='","'>'","'>='","'&'","'|'","'('","')'","'{'","'}'","'['","']'","','","':'","'->'","%eof"]
        bit_start = st Prelude.* 50
        bit_end = (st Prelude.+ 1) Prelude.* 50
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..49]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (8) = happyGoto action_4
action_0 (15) = happyGoto action_5
action_0 (19) = happyGoto action_6
action_0 _ = happyReduce_57

action_1 (21) = happyShift action_3
action_1 (9) = happyGoto action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 _ = happyReduce_11

action_4 (50) = happyAccept
action_4 _ = happyFail (happyExpListPerState 4)

action_5 _ = happyReduce_10

action_6 (21) = happyShift action_3
action_6 (7) = happyGoto action_7
action_6 (9) = happyGoto action_8
action_6 _ = happyReduce_51

action_7 _ = happyReduce_58

action_8 (14) = happyGoto action_9
action_8 (18) = happyGoto action_10
action_8 _ = happyReduce_55

action_9 (48) = happyShift action_16
action_9 (5) = happyGoto action_14
action_9 (16) = happyGoto action_15
action_9 _ = happyReduce_52

action_10 (21) = happyShift action_3
action_10 (41) = happyShift action_13
action_10 (6) = happyGoto action_11
action_10 (9) = happyGoto action_12
action_10 _ = happyReduce_50

action_11 _ = happyReduce_56

action_12 _ = happyReduce_8

action_13 (21) = happyShift action_3
action_13 (9) = happyGoto action_21
action_13 _ = happyFail (happyExpListPerState 13)

action_14 _ = happyReduce_53

action_15 (33) = happyShift action_20
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (21) = happyShift action_3
action_16 (41) = happyShift action_18
action_16 (45) = happyShift action_19
action_16 (4) = happyGoto action_17
action_16 (9) = happyGoto action_2
action_16 _ = happyFail (happyExpListPerState 16)

action_17 (49) = happyShift action_27
action_17 _ = happyReduce_6

action_18 (21) = happyShift action_3
action_18 (41) = happyShift action_18
action_18 (42) = happyShift action_26
action_18 (45) = happyShift action_19
action_18 (4) = happyGoto action_25
action_18 (9) = happyGoto action_2
action_18 _ = happyFail (happyExpListPerState 18)

action_19 (21) = happyShift action_3
action_19 (41) = happyShift action_18
action_19 (45) = happyShift action_19
action_19 (4) = happyGoto action_24
action_19 (9) = happyGoto action_2
action_19 _ = happyFail (happyExpListPerState 19)

action_20 (43) = happyShift action_23
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (48) = happyShift action_16
action_21 (5) = happyGoto action_14
action_21 (16) = happyGoto action_22
action_21 _ = happyReduce_52

action_22 (42) = happyShift action_43
action_22 _ = happyFail (happyExpListPerState 22)

action_23 (21) = happyShift action_3
action_23 (22) = happyShift action_36
action_23 (23) = happyShift action_37
action_23 (24) = happyShift action_38
action_23 (26) = happyShift action_39
action_23 (30) = happyShift action_40
action_23 (41) = happyShift action_41
action_23 (45) = happyShift action_42
action_23 (9) = happyGoto action_31
action_23 (10) = happyGoto action_32
action_23 (11) = happyGoto action_33
action_23 (12) = happyGoto action_34
action_23 (13) = happyGoto action_35
action_23 _ = happyFail (happyExpListPerState 23)

action_24 (46) = happyShift action_30
action_24 (49) = happyShift action_27
action_24 _ = happyFail (happyExpListPerState 24)

action_25 (42) = happyShift action_29
action_25 (49) = happyShift action_27
action_25 _ = happyFail (happyExpListPerState 25)

action_26 _ = happyReduce_2

action_27 (21) = happyShift action_3
action_27 (41) = happyShift action_18
action_27 (45) = happyShift action_19
action_27 (4) = happyGoto action_28
action_27 (9) = happyGoto action_2
action_27 _ = happyFail (happyExpListPerState 27)

action_28 (49) = happyShift action_27
action_28 _ = happyReduce_5

action_29 _ = happyReduce_3

action_30 _ = happyReduce_4

action_31 _ = happyReduce_33

action_32 (29) = happyShift action_64
action_32 (30) = happyShift action_65
action_32 (31) = happyShift action_66
action_32 (32) = happyShift action_67
action_32 (33) = happyShift action_68
action_32 (34) = happyShift action_69
action_32 (35) = happyShift action_70
action_32 (36) = happyShift action_71
action_32 (37) = happyShift action_72
action_32 (38) = happyShift action_73
action_32 (39) = happyShift action_74
action_32 (40) = happyShift action_75
action_32 (44) = happyShift action_76
action_32 _ = happyFail (happyExpListPerState 32)

action_33 (21) = happyShift action_3
action_33 (22) = happyShift action_36
action_33 (23) = happyShift action_37
action_33 (41) = happyShift action_41
action_33 (45) = happyShift action_42
action_33 (9) = happyGoto action_31
action_33 (13) = happyGoto action_63
action_33 _ = happyReduce_12

action_34 _ = happyReduce_13

action_35 _ = happyReduce_29

action_36 _ = happyReduce_34

action_37 _ = happyReduce_32

action_38 (21) = happyShift action_3
action_38 (7) = happyGoto action_62
action_38 (9) = happyGoto action_8
action_38 _ = happyFail (happyExpListPerState 38)

action_39 (21) = happyShift action_3
action_39 (22) = happyShift action_36
action_39 (23) = happyShift action_37
action_39 (24) = happyShift action_38
action_39 (26) = happyShift action_39
action_39 (30) = happyShift action_40
action_39 (41) = happyShift action_41
action_39 (45) = happyShift action_42
action_39 (9) = happyGoto action_31
action_39 (10) = happyGoto action_61
action_39 (11) = happyGoto action_33
action_39 (12) = happyGoto action_34
action_39 (13) = happyGoto action_35
action_39 _ = happyFail (happyExpListPerState 39)

action_40 (21) = happyShift action_3
action_40 (22) = happyShift action_36
action_40 (23) = happyShift action_37
action_40 (24) = happyShift action_38
action_40 (26) = happyShift action_39
action_40 (30) = happyShift action_40
action_40 (41) = happyShift action_41
action_40 (45) = happyShift action_42
action_40 (9) = happyGoto action_31
action_40 (10) = happyGoto action_60
action_40 (11) = happyGoto action_33
action_40 (12) = happyGoto action_34
action_40 (13) = happyGoto action_35
action_40 _ = happyFail (happyExpListPerState 40)

action_41 (21) = happyShift action_3
action_41 (22) = happyShift action_36
action_41 (23) = happyShift action_37
action_41 (24) = happyShift action_38
action_41 (26) = happyShift action_39
action_41 (29) = happyShift action_47
action_41 (30) = happyShift action_48
action_41 (31) = happyShift action_49
action_41 (32) = happyShift action_50
action_41 (33) = happyShift action_51
action_41 (34) = happyShift action_52
action_41 (35) = happyShift action_53
action_41 (36) = happyShift action_54
action_41 (37) = happyShift action_55
action_41 (38) = happyShift action_56
action_41 (39) = happyShift action_57
action_41 (40) = happyShift action_58
action_41 (41) = happyShift action_41
action_41 (42) = happyShift action_59
action_41 (45) = happyShift action_42
action_41 (9) = happyGoto action_31
action_41 (10) = happyGoto action_46
action_41 (11) = happyGoto action_33
action_41 (12) = happyGoto action_34
action_41 (13) = happyGoto action_35
action_41 _ = happyFail (happyExpListPerState 41)

action_42 (17) = happyGoto action_44
action_42 (20) = happyGoto action_45
action_42 _ = happyReduce_59

action_43 _ = happyReduce_7

action_44 (46) = happyShift action_105
action_44 _ = happyFail (happyExpListPerState 44)

action_45 (47) = happyShift action_104
action_45 _ = happyReduce_54

action_46 (29) = happyShift action_64
action_46 (30) = happyShift action_65
action_46 (31) = happyShift action_66
action_46 (32) = happyShift action_67
action_46 (33) = happyShift action_68
action_46 (34) = happyShift action_69
action_46 (35) = happyShift action_70
action_46 (36) = happyShift action_71
action_46 (37) = happyShift action_72
action_46 (38) = happyShift action_73
action_46 (39) = happyShift action_74
action_46 (40) = happyShift action_75
action_46 (42) = happyShift action_103
action_46 _ = happyFail (happyExpListPerState 46)

action_47 (42) = happyShift action_102
action_47 _ = happyFail (happyExpListPerState 47)

action_48 (21) = happyShift action_3
action_48 (22) = happyShift action_36
action_48 (23) = happyShift action_37
action_48 (24) = happyShift action_38
action_48 (26) = happyShift action_39
action_48 (30) = happyShift action_40
action_48 (41) = happyShift action_41
action_48 (42) = happyShift action_101
action_48 (45) = happyShift action_42
action_48 (9) = happyGoto action_31
action_48 (10) = happyGoto action_60
action_48 (11) = happyGoto action_33
action_48 (12) = happyGoto action_34
action_48 (13) = happyGoto action_35
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (42) = happyShift action_100
action_49 _ = happyFail (happyExpListPerState 49)

action_50 (42) = happyShift action_99
action_50 _ = happyFail (happyExpListPerState 50)

action_51 (42) = happyShift action_98
action_51 _ = happyFail (happyExpListPerState 51)

action_52 (42) = happyShift action_97
action_52 _ = happyFail (happyExpListPerState 52)

action_53 (42) = happyShift action_96
action_53 _ = happyFail (happyExpListPerState 53)

action_54 (42) = happyShift action_95
action_54 _ = happyFail (happyExpListPerState 54)

action_55 (42) = happyShift action_94
action_55 _ = happyFail (happyExpListPerState 55)

action_56 (42) = happyShift action_93
action_56 _ = happyFail (happyExpListPerState 56)

action_57 (42) = happyShift action_92
action_57 _ = happyFail (happyExpListPerState 57)

action_58 (42) = happyShift action_91
action_58 _ = happyFail (happyExpListPerState 58)

action_59 _ = happyReduce_35

action_60 (31) = happyShift action_66
action_60 (32) = happyShift action_67
action_60 _ = happyReduce_15

action_61 (29) = happyShift action_64
action_61 (30) = happyShift action_65
action_61 (31) = happyShift action_66
action_61 (32) = happyShift action_67
action_61 (33) = happyShift action_68
action_61 (34) = happyShift action_69
action_61 (35) = happyShift action_70
action_61 (36) = happyShift action_71
action_61 (37) = happyShift action_72
action_61 (38) = happyShift action_73
action_61 (39) = happyShift action_74
action_61 (40) = happyShift action_75
action_61 (43) = happyShift action_90
action_61 _ = happyFail (happyExpListPerState 61)

action_62 (25) = happyShift action_89
action_62 _ = happyFail (happyExpListPerState 62)

action_63 _ = happyReduce_28

action_64 (21) = happyShift action_3
action_64 (22) = happyShift action_36
action_64 (23) = happyShift action_37
action_64 (24) = happyShift action_38
action_64 (26) = happyShift action_39
action_64 (30) = happyShift action_40
action_64 (41) = happyShift action_41
action_64 (45) = happyShift action_42
action_64 (9) = happyGoto action_31
action_64 (10) = happyGoto action_88
action_64 (11) = happyGoto action_33
action_64 (12) = happyGoto action_34
action_64 (13) = happyGoto action_35
action_64 _ = happyFail (happyExpListPerState 64)

action_65 (21) = happyShift action_3
action_65 (22) = happyShift action_36
action_65 (23) = happyShift action_37
action_65 (24) = happyShift action_38
action_65 (26) = happyShift action_39
action_65 (30) = happyShift action_40
action_65 (41) = happyShift action_41
action_65 (45) = happyShift action_42
action_65 (9) = happyGoto action_31
action_65 (10) = happyGoto action_87
action_65 (11) = happyGoto action_33
action_65 (12) = happyGoto action_34
action_65 (13) = happyGoto action_35
action_65 _ = happyFail (happyExpListPerState 65)

action_66 (21) = happyShift action_3
action_66 (22) = happyShift action_36
action_66 (23) = happyShift action_37
action_66 (24) = happyShift action_38
action_66 (26) = happyShift action_39
action_66 (30) = happyShift action_40
action_66 (41) = happyShift action_41
action_66 (45) = happyShift action_42
action_66 (9) = happyGoto action_31
action_66 (10) = happyGoto action_86
action_66 (11) = happyGoto action_33
action_66 (12) = happyGoto action_34
action_66 (13) = happyGoto action_35
action_66 _ = happyFail (happyExpListPerState 66)

action_67 (21) = happyShift action_3
action_67 (22) = happyShift action_36
action_67 (23) = happyShift action_37
action_67 (24) = happyShift action_38
action_67 (26) = happyShift action_39
action_67 (30) = happyShift action_40
action_67 (41) = happyShift action_41
action_67 (45) = happyShift action_42
action_67 (9) = happyGoto action_31
action_67 (10) = happyGoto action_85
action_67 (11) = happyGoto action_33
action_67 (12) = happyGoto action_34
action_67 (13) = happyGoto action_35
action_67 _ = happyFail (happyExpListPerState 67)

action_68 (21) = happyShift action_3
action_68 (22) = happyShift action_36
action_68 (23) = happyShift action_37
action_68 (24) = happyShift action_38
action_68 (26) = happyShift action_39
action_68 (30) = happyShift action_40
action_68 (41) = happyShift action_41
action_68 (45) = happyShift action_42
action_68 (9) = happyGoto action_31
action_68 (10) = happyGoto action_84
action_68 (11) = happyGoto action_33
action_68 (12) = happyGoto action_34
action_68 (13) = happyGoto action_35
action_68 _ = happyFail (happyExpListPerState 68)

action_69 (21) = happyShift action_3
action_69 (22) = happyShift action_36
action_69 (23) = happyShift action_37
action_69 (24) = happyShift action_38
action_69 (26) = happyShift action_39
action_69 (30) = happyShift action_40
action_69 (41) = happyShift action_41
action_69 (45) = happyShift action_42
action_69 (9) = happyGoto action_31
action_69 (10) = happyGoto action_83
action_69 (11) = happyGoto action_33
action_69 (12) = happyGoto action_34
action_69 (13) = happyGoto action_35
action_69 _ = happyFail (happyExpListPerState 69)

action_70 (21) = happyShift action_3
action_70 (22) = happyShift action_36
action_70 (23) = happyShift action_37
action_70 (24) = happyShift action_38
action_70 (26) = happyShift action_39
action_70 (30) = happyShift action_40
action_70 (41) = happyShift action_41
action_70 (45) = happyShift action_42
action_70 (9) = happyGoto action_31
action_70 (10) = happyGoto action_82
action_70 (11) = happyGoto action_33
action_70 (12) = happyGoto action_34
action_70 (13) = happyGoto action_35
action_70 _ = happyFail (happyExpListPerState 70)

action_71 (21) = happyShift action_3
action_71 (22) = happyShift action_36
action_71 (23) = happyShift action_37
action_71 (24) = happyShift action_38
action_71 (26) = happyShift action_39
action_71 (30) = happyShift action_40
action_71 (41) = happyShift action_41
action_71 (45) = happyShift action_42
action_71 (9) = happyGoto action_31
action_71 (10) = happyGoto action_81
action_71 (11) = happyGoto action_33
action_71 (12) = happyGoto action_34
action_71 (13) = happyGoto action_35
action_71 _ = happyFail (happyExpListPerState 71)

action_72 (21) = happyShift action_3
action_72 (22) = happyShift action_36
action_72 (23) = happyShift action_37
action_72 (24) = happyShift action_38
action_72 (26) = happyShift action_39
action_72 (30) = happyShift action_40
action_72 (41) = happyShift action_41
action_72 (45) = happyShift action_42
action_72 (9) = happyGoto action_31
action_72 (10) = happyGoto action_80
action_72 (11) = happyGoto action_33
action_72 (12) = happyGoto action_34
action_72 (13) = happyGoto action_35
action_72 _ = happyFail (happyExpListPerState 72)

action_73 (21) = happyShift action_3
action_73 (22) = happyShift action_36
action_73 (23) = happyShift action_37
action_73 (24) = happyShift action_38
action_73 (26) = happyShift action_39
action_73 (30) = happyShift action_40
action_73 (41) = happyShift action_41
action_73 (45) = happyShift action_42
action_73 (9) = happyGoto action_31
action_73 (10) = happyGoto action_79
action_73 (11) = happyGoto action_33
action_73 (12) = happyGoto action_34
action_73 (13) = happyGoto action_35
action_73 _ = happyFail (happyExpListPerState 73)

action_74 (21) = happyShift action_3
action_74 (22) = happyShift action_36
action_74 (23) = happyShift action_37
action_74 (24) = happyShift action_38
action_74 (26) = happyShift action_39
action_74 (30) = happyShift action_40
action_74 (41) = happyShift action_41
action_74 (45) = happyShift action_42
action_74 (9) = happyGoto action_31
action_74 (10) = happyGoto action_78
action_74 (11) = happyGoto action_33
action_74 (12) = happyGoto action_34
action_74 (13) = happyGoto action_35
action_74 _ = happyFail (happyExpListPerState 74)

action_75 (21) = happyShift action_3
action_75 (22) = happyShift action_36
action_75 (23) = happyShift action_37
action_75 (24) = happyShift action_38
action_75 (26) = happyShift action_39
action_75 (30) = happyShift action_40
action_75 (41) = happyShift action_41
action_75 (45) = happyShift action_42
action_75 (9) = happyGoto action_31
action_75 (10) = happyGoto action_77
action_75 (11) = happyGoto action_33
action_75 (12) = happyGoto action_34
action_75 (13) = happyGoto action_35
action_75 _ = happyFail (happyExpListPerState 75)

action_76 _ = happyReduce_9

action_77 (29) = happyShift action_64
action_77 (30) = happyShift action_65
action_77 (31) = happyShift action_66
action_77 (32) = happyShift action_67
action_77 (33) = happyShift action_68
action_77 (34) = happyShift action_69
action_77 (35) = happyShift action_70
action_77 (36) = happyShift action_71
action_77 (37) = happyShift action_72
action_77 (38) = happyShift action_73
action_77 (39) = happyShift action_74
action_77 _ = happyReduce_27

action_78 (29) = happyShift action_64
action_78 (30) = happyShift action_65
action_78 (31) = happyShift action_66
action_78 (32) = happyShift action_67
action_78 (33) = happyShift action_68
action_78 (34) = happyShift action_69
action_78 (35) = happyShift action_70
action_78 (36) = happyShift action_71
action_78 (37) = happyShift action_72
action_78 (38) = happyShift action_73
action_78 _ = happyReduce_26

action_79 (29) = happyShift action_64
action_79 (30) = happyShift action_65
action_79 (31) = happyShift action_66
action_79 (32) = happyShift action_67
action_79 (33) = happyFail []
action_79 (34) = happyFail []
action_79 (35) = happyFail []
action_79 (36) = happyFail []
action_79 (37) = happyFail []
action_79 (38) = happyFail []
action_79 _ = happyReduce_25

action_80 (29) = happyShift action_64
action_80 (30) = happyShift action_65
action_80 (31) = happyShift action_66
action_80 (32) = happyShift action_67
action_80 (33) = happyFail []
action_80 (34) = happyFail []
action_80 (35) = happyFail []
action_80 (36) = happyFail []
action_80 (37) = happyFail []
action_80 (38) = happyFail []
action_80 _ = happyReduce_24

action_81 (29) = happyShift action_64
action_81 (30) = happyShift action_65
action_81 (31) = happyShift action_66
action_81 (32) = happyShift action_67
action_81 (33) = happyFail []
action_81 (34) = happyFail []
action_81 (35) = happyFail []
action_81 (36) = happyFail []
action_81 (37) = happyFail []
action_81 (38) = happyFail []
action_81 _ = happyReduce_23

action_82 (29) = happyShift action_64
action_82 (30) = happyShift action_65
action_82 (31) = happyShift action_66
action_82 (32) = happyShift action_67
action_82 (33) = happyFail []
action_82 (34) = happyFail []
action_82 (35) = happyFail []
action_82 (36) = happyFail []
action_82 (37) = happyFail []
action_82 (38) = happyFail []
action_82 _ = happyReduce_22

action_83 (29) = happyShift action_64
action_83 (30) = happyShift action_65
action_83 (31) = happyShift action_66
action_83 (32) = happyShift action_67
action_83 (33) = happyFail []
action_83 (34) = happyFail []
action_83 (35) = happyFail []
action_83 (36) = happyFail []
action_83 (37) = happyFail []
action_83 (38) = happyFail []
action_83 _ = happyReduce_21

action_84 (29) = happyShift action_64
action_84 (30) = happyShift action_65
action_84 (31) = happyShift action_66
action_84 (32) = happyShift action_67
action_84 (33) = happyFail []
action_84 (34) = happyFail []
action_84 (35) = happyFail []
action_84 (36) = happyFail []
action_84 (37) = happyFail []
action_84 (38) = happyFail []
action_84 _ = happyReduce_20

action_85 _ = happyReduce_19

action_86 _ = happyReduce_18

action_87 (31) = happyShift action_66
action_87 (32) = happyShift action_67
action_87 _ = happyReduce_17

action_88 (31) = happyShift action_66
action_88 (32) = happyShift action_67
action_88 _ = happyReduce_16

action_89 (43) = happyShift action_108
action_89 _ = happyFail (happyExpListPerState 89)

action_90 (21) = happyShift action_3
action_90 (22) = happyShift action_36
action_90 (23) = happyShift action_37
action_90 (24) = happyShift action_38
action_90 (26) = happyShift action_39
action_90 (30) = happyShift action_40
action_90 (41) = happyShift action_41
action_90 (45) = happyShift action_42
action_90 (9) = happyGoto action_31
action_90 (10) = happyGoto action_107
action_90 (11) = happyGoto action_33
action_90 (12) = happyGoto action_34
action_90 (13) = happyGoto action_35
action_90 _ = happyFail (happyExpListPerState 90)

action_91 _ = happyReduce_49

action_92 _ = happyReduce_48

action_93 _ = happyReduce_47

action_94 _ = happyReduce_46

action_95 _ = happyReduce_45

action_96 _ = happyReduce_44

action_97 _ = happyReduce_43

action_98 _ = happyReduce_42

action_99 _ = happyReduce_41

action_100 _ = happyReduce_40

action_101 _ = happyReduce_39

action_102 _ = happyReduce_38

action_103 _ = happyReduce_37

action_104 (21) = happyShift action_3
action_104 (22) = happyShift action_36
action_104 (23) = happyShift action_37
action_104 (24) = happyShift action_38
action_104 (26) = happyShift action_39
action_104 (30) = happyShift action_40
action_104 (41) = happyShift action_41
action_104 (45) = happyShift action_42
action_104 (9) = happyGoto action_31
action_104 (10) = happyGoto action_106
action_104 (11) = happyGoto action_33
action_104 (12) = happyGoto action_34
action_104 (13) = happyGoto action_35
action_104 _ = happyFail (happyExpListPerState 104)

action_105 _ = happyReduce_36

action_106 (29) = happyShift action_64
action_106 (30) = happyShift action_65
action_106 (31) = happyShift action_66
action_106 (32) = happyShift action_67
action_106 (33) = happyShift action_68
action_106 (34) = happyShift action_69
action_106 (35) = happyShift action_70
action_106 (36) = happyShift action_71
action_106 (37) = happyShift action_72
action_106 (38) = happyShift action_73
action_106 (39) = happyShift action_74
action_106 (40) = happyShift action_75
action_106 _ = happyReduce_60

action_107 (29) = happyShift action_64
action_107 (30) = happyShift action_65
action_107 (31) = happyShift action_66
action_107 (32) = happyShift action_67
action_107 (33) = happyShift action_68
action_107 (34) = happyShift action_69
action_107 (35) = happyShift action_70
action_107 (36) = happyShift action_71
action_107 (37) = happyShift action_72
action_107 (38) = happyShift action_73
action_107 (39) = happyShift action_74
action_107 (40) = happyShift action_75
action_107 (44) = happyShift action_110
action_107 _ = happyFail (happyExpListPerState 107)

action_108 (21) = happyShift action_3
action_108 (22) = happyShift action_36
action_108 (23) = happyShift action_37
action_108 (24) = happyShift action_38
action_108 (26) = happyShift action_39
action_108 (30) = happyShift action_40
action_108 (41) = happyShift action_41
action_108 (45) = happyShift action_42
action_108 (9) = happyGoto action_31
action_108 (10) = happyGoto action_109
action_108 (11) = happyGoto action_33
action_108 (12) = happyGoto action_34
action_108 (13) = happyGoto action_35
action_108 _ = happyFail (happyExpListPerState 108)

action_109 (29) = happyShift action_64
action_109 (30) = happyShift action_65
action_109 (31) = happyShift action_66
action_109 (32) = happyShift action_67
action_109 (33) = happyShift action_68
action_109 (34) = happyShift action_69
action_109 (35) = happyShift action_70
action_109 (36) = happyShift action_71
action_109 (37) = happyShift action_72
action_109 (38) = happyShift action_73
action_109 (39) = happyShift action_74
action_109 (40) = happyShift action_75
action_109 (44) = happyShift action_112
action_109 _ = happyFail (happyExpListPerState 109)

action_110 (28) = happyShift action_111
action_110 (29) = happyReduce_30
action_110 (30) = happyReduce_30
action_110 (31) = happyReduce_30
action_110 (32) = happyReduce_30
action_110 (33) = happyReduce_30
action_110 (34) = happyReduce_30
action_110 (35) = happyReduce_30
action_110 (36) = happyReduce_30
action_110 (37) = happyReduce_30
action_110 (38) = happyReduce_30
action_110 (39) = happyReduce_30
action_110 (40) = happyReduce_30
action_110 (42) = happyReduce_30
action_110 (43) = happyReduce_30
action_110 (44) = happyReduce_30
action_110 (46) = happyReduce_30
action_110 (47) = happyReduce_30
action_110 _ = happyReduce_30

action_111 (43) = happyShift action_113
action_111 _ = happyFail (happyExpListPerState 111)

action_112 _ = happyReduce_14

action_113 (21) = happyShift action_3
action_113 (22) = happyShift action_36
action_113 (23) = happyShift action_37
action_113 (24) = happyShift action_38
action_113 (26) = happyShift action_39
action_113 (30) = happyShift action_40
action_113 (41) = happyShift action_41
action_113 (45) = happyShift action_42
action_113 (9) = happyGoto action_31
action_113 (10) = happyGoto action_114
action_113 (11) = happyGoto action_33
action_113 (12) = happyGoto action_34
action_113 (13) = happyGoto action_35
action_113 _ = happyFail (happyExpListPerState 113)

action_114 (29) = happyShift action_64
action_114 (30) = happyShift action_65
action_114 (31) = happyShift action_66
action_114 (32) = happyShift action_67
action_114 (33) = happyShift action_68
action_114 (34) = happyShift action_69
action_114 (35) = happyShift action_70
action_114 (36) = happyShift action_71
action_114 (37) = happyShift action_72
action_114 (38) = happyShift action_73
action_114 (39) = happyShift action_74
action_114 (40) = happyShift action_75
action_114 (44) = happyShift action_115
action_114 _ = happyFail (happyExpListPerState 114)

action_115 _ = happyReduce_31

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn4
		 (TVar (info happy_var_1) happy_var_1
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_2  4 happyReduction_2
happyReduction_2 (HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn4
		 (TUnit (L.rtRange happy_var_1 <-> L.rtRange happy_var_2)
	)
happyReduction_2 _ _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_3  4 happyReduction_3
happyReduction_3 (HappyTerminal happy_var_3)
	(HappyAbsSyn4  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn4
		 (TPar (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) happy_var_2
	)
happyReduction_3 _ _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_3  4 happyReduction_4
happyReduction_4 (HappyTerminal happy_var_3)
	(HappyAbsSyn4  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn4
		 (TList (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) happy_var_2
	)
happyReduction_4 _ _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_3  4 happyReduction_5
happyReduction_5 (HappyAbsSyn4  happy_var_3)
	_
	(HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn4
		 (TArrow (info happy_var_1 <-> info happy_var_3) happy_var_1 happy_var_3
	)
happyReduction_5 _ _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_2  5 happyReduction_6
happyReduction_6 (HappyAbsSyn4  happy_var_2)
	_
	 =  HappyAbsSyn4
		 (happy_var_2
	)
happyReduction_6 _ _  = notHappyAtAll 

happyReduce_7 = happyReduce 4 6 happyReduction_7
happyReduction_7 ((HappyTerminal happy_var_4) `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	(HappyAbsSyn9  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn6
		 (Argument (L.rtRange happy_var_1 <-> L.rtRange happy_var_4) happy_var_2 happy_var_3
	) `HappyStk` happyRest

happyReduce_8 = happySpecReduce_1  6 happyReduction_8
happyReduction_8 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn6
		 (Argument (info happy_var_1) happy_var_1 Nothing
	)
happyReduction_8 _  = notHappyAtAll 

happyReduce_9 = happyReduce 7 7 happyReduction_9
happyReduction_9 ((HappyTerminal happy_var_7) `HappyStk`
	(HappyAbsSyn10  happy_var_6) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	(HappyAbsSyn14  happy_var_2) `HappyStk`
	(HappyAbsSyn9  happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (Dec (info happy_var_1 <-> L.rtRange happy_var_7) happy_var_1 happy_var_2 happy_var_3 happy_var_6
	) `HappyStk` happyRest

happyReduce_10 = happySpecReduce_1  8 happyReduction_10
happyReduction_10 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn8
		 (happy_var_1
	)
happyReduction_10 _  = notHappyAtAll 

happyReduce_11 = happySpecReduce_1  9 happyReduction_11
happyReduction_11 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn9
		 (unTok happy_var_1 (\range (L.Identifier name) -> Name range name)
	)
happyReduction_11 _  = notHappyAtAll 

happyReduce_12 = happySpecReduce_1  10 happyReduction_12
happyReduction_12 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_1
	)
happyReduction_12 _  = notHappyAtAll 

happyReduce_13 = happySpecReduce_1  10 happyReduction_13
happyReduction_13 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_1
	)
happyReduction_13 _  = notHappyAtAll 

happyReduce_14 = happyReduce 6 10 happyReduction_14
happyReduction_14 ((HappyTerminal happy_var_6) `HappyStk`
	(HappyAbsSyn10  happy_var_5) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn7  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (ELetIn (L.rtRange happy_var_1 <-> L.rtRange happy_var_6) happy_var_2 happy_var_5
	) `HappyStk` happyRest

happyReduce_15 = happySpecReduce_2  10 happyReduction_15
happyReduction_15 (HappyAbsSyn10  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (ENeg (L.rtRange happy_var_1 <-> info happy_var_2) happy_var_2
	)
happyReduction_15 _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_3  10 happyReduction_16
happyReduction_16 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Plus (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_16 _ _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_3  10 happyReduction_17
happyReduction_17 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Minus (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_17 _ _ _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  10 happyReduction_18
happyReduction_18 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Times (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  10 happyReduction_19
happyReduction_19 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Divide (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_3  10 happyReduction_20
happyReduction_20 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Eq (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_3  10 happyReduction_21
happyReduction_21 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Neq (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  10 happyReduction_22
happyReduction_22 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Lt (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_3  10 happyReduction_23
happyReduction_23 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Le (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_23 _ _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_3  10 happyReduction_24
happyReduction_24 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Gt (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_24 _ _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_3  10 happyReduction_25
happyReduction_25 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Ge (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_25 _ _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_3  10 happyReduction_26
happyReduction_26 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (And (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_3  10 happyReduction_27
happyReduction_27 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Or (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_27 _ _ _  = notHappyAtAll 

happyReduce_28 = happySpecReduce_2  11 happyReduction_28
happyReduction_28 (HappyAbsSyn10  happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EApp (info happy_var_1 <-> info happy_var_2) happy_var_1 happy_var_2
	)
happyReduction_28 _ _  = notHappyAtAll 

happyReduce_29 = happySpecReduce_1  11 happyReduction_29
happyReduction_29 (HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (happy_var_1
	)
happyReduction_29 _  = notHappyAtAll 

happyReduce_30 = happyReduce 5 12 happyReduction_30
happyReduction_30 ((HappyTerminal happy_var_5) `HappyStk`
	(HappyAbsSyn10  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (EIfThen (L.rtRange happy_var_1 <-> L.rtRange happy_var_5) happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_31 = happyReduce 9 12 happyReduction_31
happyReduction_31 ((HappyTerminal happy_var_9) `HappyStk`
	(HappyAbsSyn10  happy_var_8) `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (EIfThenElse (L.rtRange happy_var_1 <-> L.rtRange happy_var_9) happy_var_2 happy_var_4 happy_var_8
	) `HappyStk` happyRest

happyReduce_32 = happySpecReduce_1  13 happyReduction_32
happyReduction_32 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (unTok happy_var_1 (\range (L.Integer int) -> EInt range int)
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  13 happyReduction_33
happyReduction_33 (HappyAbsSyn9  happy_var_1)
	 =  HappyAbsSyn10
		 (EVar (info happy_var_1) happy_var_1
	)
happyReduction_33 _  = notHappyAtAll 

happyReduce_34 = happySpecReduce_1  13 happyReduction_34
happyReduction_34 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (unTok happy_var_1 (\range (L.String string) -> EString range string)
	)
happyReduction_34 _  = notHappyAtAll 

happyReduce_35 = happySpecReduce_2  13 happyReduction_35
happyReduction_35 (HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EUnit (L.rtRange happy_var_1 <-> L.rtRange happy_var_2)
	)
happyReduction_35 _ _  = notHappyAtAll 

happyReduce_36 = happySpecReduce_3  13 happyReduction_36
happyReduction_36 (HappyTerminal happy_var_3)
	(HappyAbsSyn17  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EList (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) happy_var_2
	)
happyReduction_36 _ _ _  = notHappyAtAll 

happyReduce_37 = happySpecReduce_3  13 happyReduction_37
happyReduction_37 (HappyTerminal happy_var_3)
	(HappyAbsSyn10  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EPar (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) happy_var_2
	)
happyReduction_37 _ _ _  = notHappyAtAll 

happyReduce_38 = happySpecReduce_3  13 happyReduction_38
happyReduction_38 (HappyTerminal happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EOp (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) (Plus (L.rtRange happy_var_2))
	)
happyReduction_38 _ _ _  = notHappyAtAll 

happyReduce_39 = happySpecReduce_3  13 happyReduction_39
happyReduction_39 (HappyTerminal happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EOp (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) (Minus (L.rtRange happy_var_2))
	)
happyReduction_39 _ _ _  = notHappyAtAll 

happyReduce_40 = happySpecReduce_3  13 happyReduction_40
happyReduction_40 (HappyTerminal happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EOp (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) (Times (L.rtRange happy_var_2))
	)
happyReduction_40 _ _ _  = notHappyAtAll 

happyReduce_41 = happySpecReduce_3  13 happyReduction_41
happyReduction_41 (HappyTerminal happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EOp (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) (Divide (L.rtRange happy_var_2))
	)
happyReduction_41 _ _ _  = notHappyAtAll 

happyReduce_42 = happySpecReduce_3  13 happyReduction_42
happyReduction_42 (HappyTerminal happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EOp (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) (Eq (L.rtRange happy_var_2))
	)
happyReduction_42 _ _ _  = notHappyAtAll 

happyReduce_43 = happySpecReduce_3  13 happyReduction_43
happyReduction_43 (HappyTerminal happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EOp (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) (Neq (L.rtRange happy_var_2))
	)
happyReduction_43 _ _ _  = notHappyAtAll 

happyReduce_44 = happySpecReduce_3  13 happyReduction_44
happyReduction_44 (HappyTerminal happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EOp (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) (Lt (L.rtRange happy_var_2))
	)
happyReduction_44 _ _ _  = notHappyAtAll 

happyReduce_45 = happySpecReduce_3  13 happyReduction_45
happyReduction_45 (HappyTerminal happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EOp (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) (Le (L.rtRange happy_var_2))
	)
happyReduction_45 _ _ _  = notHappyAtAll 

happyReduce_46 = happySpecReduce_3  13 happyReduction_46
happyReduction_46 (HappyTerminal happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EOp (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) (Gt (L.rtRange happy_var_2))
	)
happyReduction_46 _ _ _  = notHappyAtAll 

happyReduce_47 = happySpecReduce_3  13 happyReduction_47
happyReduction_47 (HappyTerminal happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EOp (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) (Ge (L.rtRange happy_var_2))
	)
happyReduction_47 _ _ _  = notHappyAtAll 

happyReduce_48 = happySpecReduce_3  13 happyReduction_48
happyReduction_48 (HappyTerminal happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EOp (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) (And (L.rtRange happy_var_2))
	)
happyReduction_48 _ _ _  = notHappyAtAll 

happyReduce_49 = happySpecReduce_3  13 happyReduction_49
happyReduction_49 (HappyTerminal happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (EOp (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) (Or (L.rtRange happy_var_2))
	)
happyReduction_49 _ _ _  = notHappyAtAll 

happyReduce_50 = happySpecReduce_1  14 happyReduction_50
happyReduction_50 (HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn14
		 (reverse happy_var_1
	)
happyReduction_50 _  = notHappyAtAll 

happyReduce_51 = happySpecReduce_1  15 happyReduction_51
happyReduction_51 (HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn15
		 (reverse happy_var_1
	)
happyReduction_51 _  = notHappyAtAll 

happyReduce_52 = happySpecReduce_0  16 happyReduction_52
happyReduction_52  =  HappyAbsSyn16
		 (Nothing
	)

happyReduce_53 = happySpecReduce_1  16 happyReduction_53
happyReduction_53 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn16
		 (Just happy_var_1
	)
happyReduction_53 _  = notHappyAtAll 

happyReduce_54 = happySpecReduce_1  17 happyReduction_54
happyReduction_54 (HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn17
		 (reverse happy_var_1
	)
happyReduction_54 _  = notHappyAtAll 

happyReduce_55 = happySpecReduce_0  18 happyReduction_55
happyReduction_55  =  HappyAbsSyn18
		 ([]
	)

happyReduce_56 = happySpecReduce_2  18 happyReduction_56
happyReduction_56 (HappyAbsSyn6  happy_var_2)
	(HappyAbsSyn18  happy_var_1)
	 =  HappyAbsSyn18
		 (happy_var_2 : happy_var_1
	)
happyReduction_56 _ _  = notHappyAtAll 

happyReduce_57 = happySpecReduce_0  19 happyReduction_57
happyReduction_57  =  HappyAbsSyn19
		 ([]
	)

happyReduce_58 = happySpecReduce_2  19 happyReduction_58
happyReduction_58 (HappyAbsSyn7  happy_var_2)
	(HappyAbsSyn19  happy_var_1)
	 =  HappyAbsSyn19
		 (happy_var_2 : happy_var_1
	)
happyReduction_58 _ _  = notHappyAtAll 

happyReduce_59 = happySpecReduce_0  20 happyReduction_59
happyReduction_59  =  HappyAbsSyn20
		 ([]
	)

happyReduce_60 = happySpecReduce_3  20 happyReduction_60
happyReduction_60 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn20  happy_var_1)
	 =  HappyAbsSyn20
		 (happy_var_3 : happy_var_1
	)
happyReduction_60 _ _ _  = notHappyAtAll 

happyNewToken action sts stk
	= lexer(\tk -> 
	let cont i = action i i tk (HappyState action) sts stk in
	case tk of {
	L.RangedToken L.EOF _ -> action 50 50 tk (HappyState action) sts stk;
	L.RangedToken (L.Identifier _) _ -> cont 21;
	L.RangedToken (L.String _) _ -> cont 22;
	L.RangedToken (L.Integer _) _ -> cont 23;
	L.RangedToken L.Let _ -> cont 24;
	L.RangedToken L.In _ -> cont 25;
	L.RangedToken L.If _ -> cont 26;
	L.RangedToken L.Then _ -> cont 27;
	L.RangedToken L.Else _ -> cont 28;
	L.RangedToken L.Plus _ -> cont 29;
	L.RangedToken L.Minus _ -> cont 30;
	L.RangedToken L.Times _ -> cont 31;
	L.RangedToken L.Divide _ -> cont 32;
	L.RangedToken L.Eq _ -> cont 33;
	L.RangedToken L.Neq _ -> cont 34;
	L.RangedToken L.Lt _ -> cont 35;
	L.RangedToken L.Le _ -> cont 36;
	L.RangedToken L.Gt _ -> cont 37;
	L.RangedToken L.Ge _ -> cont 38;
	L.RangedToken L.And _ -> cont 39;
	L.RangedToken L.Or _ -> cont 40;
	L.RangedToken L.LPar _ -> cont 41;
	L.RangedToken L.RPar _ -> cont 42;
	L.RangedToken L.LBrace _ -> cont 43;
	L.RangedToken L.RBrace _ -> cont 44;
	L.RangedToken L.LBrack _ -> cont 45;
	L.RangedToken L.RBrack _ -> cont 46;
	L.RangedToken L.Comma _ -> cont 47;
	L.RangedToken L.Colon _ -> cont 48;
	L.RangedToken L.Arrow _ -> cont 49;
	_ -> happyError' (tk, [])
	})

happyError_ explist 50 tk = happyError' (tk, explist)
happyError_ explist _ tk = happyError' (tk, explist)

happyThen :: () => L.Alex a -> (a -> L.Alex b) -> L.Alex b
happyThen = (>>=)
happyReturn :: () => a -> L.Alex a
happyReturn = (pure)
happyThen1 :: () => L.Alex a -> (a -> L.Alex b) -> L.Alex b
happyThen1 = happyThen
happyReturn1 :: () => a -> L.Alex a
happyReturn1 = happyReturn
happyError' :: () => ((L.RangedToken), [Prelude.String]) -> L.Alex a
happyError' tk = (\(tokens, _) -> parseError tokens) tk
parseJamba = happySomeParser where
 happySomeParser = happyThen (happyParse action_0) (\x -> case x of {HappyAbsSyn8 z -> happyReturn z; _other -> notHappyAtAll })

happySeq = happyDontSeq


parseError :: L.RangedToken -> L.Alex a
parseError _ = do
  (L.AlexPn _ line column, _, _, _) <- L.alexGetInput
  L.alexError $ "Parse error at line " <> show line <> ", column " <> show column

lexer :: (L.RangedToken -> L.Alex a) -> L.Alex a
lexer = (=<< L.alexMonadScan)

-- | Build a simple node by extracting its token type and range.
unTok :: L.RangedToken -> (L.Range -> L.Token -> a) -> a
unTok (L.RangedToken tok range) ctor = ctor range tok

-- | Unsafely extracts the the metainformation field of a node. basically always gonna be a range
info :: Foldable f => f a -> a
info = fromJust . getFirst . foldMap pure

-- | Performs the union of two ranges by creating a new range starting at the
-- start position of the first range, and stopping at the stop position of the
-- second range.
-- Invariant: The LHS range starts before the RHS range.
(<->) :: L.Range -> L.Range -> L.Range
L.Range a1 _ <-> L.Range _ b2 = L.Range a1 b2

-- | Parse a 'ByteString' and yield a list of 'Dec'.
parseJambaProgram :: ByteString -> Either String [Dec L.Range]
parseJambaProgram = flip L.runAlex parseJamba
{-# LINE 1 "templates/GenericTemplate.hs" #-}
-- $Id: GenericTemplate.hs,v 1.26 2005/01/14 14:47:22 simonmar Exp $










































data Happy_IntList = HappyCons Prelude.Int Happy_IntList








































infixr 9 `HappyStk`
data HappyStk a = HappyStk a (HappyStk a)

-----------------------------------------------------------------------------
-- starting the parse

happyParse start_state = happyNewToken start_state notHappyAtAll notHappyAtAll

-----------------------------------------------------------------------------
-- Accepting the parse

-- If the current token is ERROR_TOK, it means we've just accepted a partial
-- parse (a %partial parser).  We must ignore the saved token on the top of
-- the stack in this case.
happyAccept (1) tk st sts (_ `HappyStk` ans `HappyStk` _) =
        happyReturn1 ans
happyAccept j tk st sts (HappyStk ans _) = 
         (happyReturn1 ans)

-----------------------------------------------------------------------------
-- Arrays only: do the next action









































indexShortOffAddr arr off = arr Happy_Data_Array.! off


{-# INLINE happyLt #-}
happyLt x y = (x Prelude.< y)






readArrayBit arr bit =
    Bits.testBit (indexShortOffAddr arr (bit `Prelude.div` 16)) (bit `Prelude.mod` 16)






-----------------------------------------------------------------------------
-- HappyState data type (not arrays)



newtype HappyState b c = HappyState
        (Prelude.Int ->                    -- token number
         Prelude.Int ->                    -- token number (yes, again)
         b ->                           -- token semantic value
         HappyState b c ->              -- current state
         [HappyState b c] ->            -- state stack
         c)



-----------------------------------------------------------------------------
-- Shifting a token

happyShift new_state (1) tk st sts stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--     trace "shifting the error token" $
     new_state i i tk (HappyState (new_state)) ((st):(sts)) (stk)

happyShift new_state i tk st sts stk =
     happyNewToken new_state ((st):(sts)) ((HappyTerminal (tk))`HappyStk`stk)

-- happyReduce is specialised for the common cases.

happySpecReduce_0 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_0 nt fn j tk st@((HappyState (action))) sts stk
     = action nt j tk st ((st):(sts)) (fn `HappyStk` stk)

happySpecReduce_1 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_1 nt fn j tk _ sts@(((st@(HappyState (action))):(_))) (v1`HappyStk`stk')
     = let r = fn v1 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_2 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_2 nt fn j tk _ ((_):(sts@(((st@(HappyState (action))):(_))))) (v1`HappyStk`v2`HappyStk`stk')
     = let r = fn v1 v2 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happySpecReduce_3 i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happySpecReduce_3 nt fn j tk _ ((_):(((_):(sts@(((st@(HappyState (action))):(_))))))) (v1`HappyStk`v2`HappyStk`v3`HappyStk`stk')
     = let r = fn v1 v2 v3 in
       happySeq r (action nt j tk st sts (r `HappyStk` stk'))

happyReduce k i fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyReduce k nt fn j tk st sts stk
     = case happyDrop (k Prelude.- ((1) :: Prelude.Int)) sts of
         sts1@(((st1@(HappyState (action))):(_))) ->
                let r = fn stk in  -- it doesn't hurt to always seq here...
                happyDoSeq r (action nt j tk st1 sts1 r)

happyMonadReduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonadReduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
          let drop_stk = happyDropStk k stk in
          happyThen1 (fn stk tk) (\r -> action nt j tk st1 sts1 (r `HappyStk` drop_stk))

happyMonad2Reduce k nt fn (1) tk st sts stk
     = happyFail [] (1) tk st sts stk
happyMonad2Reduce k nt fn j tk st sts stk =
      case happyDrop k ((st):(sts)) of
        sts1@(((st1@(HappyState (action))):(_))) ->
         let drop_stk = happyDropStk k stk





             _ = nt :: Prelude.Int
             new_state = action

          in
          happyThen1 (fn stk tk) (\r -> happyNewToken new_state sts1 (r `HappyStk` drop_stk))

happyDrop (0) l = l
happyDrop n ((_):(t)) = happyDrop (n Prelude.- ((1) :: Prelude.Int)) t

happyDropStk (0) l = l
happyDropStk n (x `HappyStk` xs) = happyDropStk (n Prelude.- ((1)::Prelude.Int)) xs

-----------------------------------------------------------------------------
-- Moving to a new state after a reduction









happyGoto action j tk st = action j j tk (HappyState action)


-----------------------------------------------------------------------------
-- Error recovery (ERROR_TOK is the error token)

-- parse error if we are in recovery and we fail again
happyFail explist (1) tk old_st _ stk@(x `HappyStk` _) =
     let i = (case x of { HappyErrorToken (i) -> i }) in
--      trace "failing" $ 
        happyError_ explist i tk

{-  We don't need state discarding for our restricted implementation of
    "error".  In fact, it can cause some bogus parses, so I've disabled it
    for now --SDM

-- discard a state
happyFail  ERROR_TOK tk old_st CONS(HAPPYSTATE(action),sts) 
                                                (saved_tok `HappyStk` _ `HappyStk` stk) =
--      trace ("discarding state, depth " ++ show (length stk))  $
        DO_ACTION(action,ERROR_TOK,tk,sts,(saved_tok`HappyStk`stk))
-}

-- Enter error recovery: generate an error token,
--                       save the old token and carry on.
happyFail explist i tk (HappyState (action)) sts stk =
--      trace "entering error recovery" $
        action (1) (1) tk (HappyState (action)) sts ((HappyErrorToken (i)) `HappyStk` stk)

-- Internal happy errors:

notHappyAtAll :: a
notHappyAtAll = Prelude.error "Internal Happy error\n"

-----------------------------------------------------------------------------
-- Hack to get the typechecker to accept our action functions







-----------------------------------------------------------------------------
-- Seq-ing.  If the --strict flag is given, then Happy emits 
--      happySeq = happyDoSeq
-- otherwise it emits
--      happySeq = happyDontSeq

happyDoSeq, happyDontSeq :: a -> b -> b
happyDoSeq   a b = a `Prelude.seq` b
happyDontSeq a b = b

-----------------------------------------------------------------------------
-- Don't inline any functions from the template.  GHC has a nasty habit
-- of deciding to inline happyGoto everywhere, which increases the size of
-- the generated parser quite a bit.









{-# NOINLINE happyShift #-}
{-# NOINLINE happySpecReduce_0 #-}
{-# NOINLINE happySpecReduce_1 #-}
{-# NOINLINE happySpecReduce_2 #-}
{-# NOINLINE happySpecReduce_3 #-}
{-# NOINLINE happyReduce #-}
{-# NOINLINE happyMonadReduce #-}
{-# NOINLINE happyGoto #-}
{-# NOINLINE happyFail #-}

-- end of Happy Template.
