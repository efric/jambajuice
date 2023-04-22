{-# OPTIONS_GHC -w #-}
{-# LANGUAGE DeriveFoldable #-}
module Parser
  ( parseMiniML
  ) where

import Data.ByteString.Lazy.Char8 (ByteString)
import Data.Maybe (fromJust)
import Data.Monoid (First (..))

import qualified Lexer as L
import qualified Data.Array as Happy_Data_Array
import qualified Data.Bits as Bits
import Control.Applicative(Applicative(..))
import Control.Monad (ap)

-- parser produced by Happy Version 1.20.1.1

data HappyAbsSyn t14 t15 t16 t17 t18 t19 t20
	= HappyTerminal (L.RangedToken)
	| HappyErrorToken Prelude.Int
	| HappyAbsSyn4 (Name L.Range)
	| HappyAbsSyn5 (Type L.Range)
	| HappyAbsSyn7 (Argument L.Range)
	| HappyAbsSyn8 (Dec L.Range)
	| HappyAbsSyn9 ([Dec L.Range])
	| HappyAbsSyn10 (Exp L.Range)
	| HappyAbsSyn14 t14
	| HappyAbsSyn15 t15
	| HappyAbsSyn16 t16
	| HappyAbsSyn17 t17
	| HappyAbsSyn18 t18
	| HappyAbsSyn19 t19
	| HappyAbsSyn20 t20

happyExpList :: Happy_Data_Array.Array Prelude.Int Prelude.Int
happyExpList = Happy_Data_Array.listArray (0,397) ([0,0,0,0,16,0,0,0,0,0,0,0,0,0,0,0,128,0,0,0,0,0,16,0,0,0,0,0,0,8192,0,16,256,0,0,0,0,0,0,0,16,0,0,0,0,0,0,1,0,16,1280,0,0,0,0,0,16384,0,16,1792,0,16,1280,0,8944,1280,0,0,8192,0,0,512,0,0,0,0,256,0,0,61440,255,0,112,1280,0,0,0,0,0,0,0,0,0,0,0,0,0,8944,1280,0,8944,1280,0,62192,2047,0,0,0,0,0,18432,0,0,16896,0,0,0,0,16,1280,0,0,16384,0,0,0,0,0,0,0,0,2048,0,0,4096,0,61440,767,0,0,512,0,8944,1792,0,0,512,0,0,512,0,0,512,0,0,512,0,0,512,0,0,512,0,0,512,0,0,512,0,0,512,0,0,512,0,0,0,0,49152,0,0,62464,255,0,0,0,0,8944,1280,0,8944,1280,0,8944,1280,0,8944,1280,0,8944,1280,0,8944,1280,0,8944,1280,0,8944,1280,0,8944,1280,0,8944,1280,0,8944,1280,0,8944,1280,0,8944,1280,0,0,0,0,61440,255,0,61440,127,0,61440,63,0,61440,0,0,61440,0,0,61440,0,0,61440,0,0,61440,0,0,61440,0,0,0,0,0,0,0,0,49152,0,0,49152,0,0,8944,1280,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,8944,1280,0,0,0,0,61440,255,0,63488,255,0,8944,1280,0,61440,255,0
	])

{-# NOINLINE happyExpListPerState #-}
happyExpListPerState st =
    token_strs_expected
  where token_strs = ["error","%dummy","%start_parseMiniML","name","type","typeAnnotation","argument","dec","decs","exp","expapp","expcond","atom","many__argument__","many__dec__","optional__typeAnnotation__","sepBy__exp__','__","many_rev__argument__","many_rev__dec__","sepBy_rev__exp__','__","identifier","string","integer","let","in","if","then","else","'+'","'-'","'*'","'/'","'='","'<>'","'<'","'<='","'>'","'>='","'&'","'|'","'('","')'","'['","']'","','","':'","'->'","%eof"]
        bit_start = st Prelude.* 48
        bit_end = (st Prelude.+ 1) Prelude.* 48
        read_bit = readArrayBit happyExpList
        bits = Prelude.map read_bit [bit_start..bit_end Prelude.- 1]
        bits_indexed = Prelude.zip bits [0..47]
        token_strs_expected = Prelude.concatMap f bits_indexed
        f (Prelude.False, _) = []
        f (Prelude.True, nr) = [token_strs Prelude.!! nr]

action_0 (9) = happyGoto action_3
action_0 (15) = happyGoto action_4
action_0 (19) = happyGoto action_5
action_0 _ = happyReduce_57

action_1 (21) = happyShift action_2
action_1 _ = happyFail (happyExpListPerState 1)

action_2 _ = happyReduce_1

action_3 (48) = happyAccept
action_3 _ = happyFail (happyExpListPerState 3)

action_4 _ = happyReduce_11

action_5 (24) = happyShift action_7
action_5 (8) = happyGoto action_6
action_5 _ = happyReduce_51

action_6 _ = happyReduce_58

action_7 (21) = happyShift action_2
action_7 (4) = happyGoto action_8
action_7 _ = happyFail (happyExpListPerState 7)

action_8 (14) = happyGoto action_9
action_8 (18) = happyGoto action_10
action_8 _ = happyReduce_55

action_9 (46) = happyShift action_16
action_9 (6) = happyGoto action_14
action_9 (16) = happyGoto action_15
action_9 _ = happyReduce_52

action_10 (21) = happyShift action_2
action_10 (41) = happyShift action_13
action_10 (4) = happyGoto action_11
action_10 (7) = happyGoto action_12
action_10 _ = happyReduce_50

action_11 _ = happyReduce_9

action_12 _ = happyReduce_56

action_13 (21) = happyShift action_2
action_13 (4) = happyGoto action_22
action_13 _ = happyFail (happyExpListPerState 13)

action_14 _ = happyReduce_53

action_15 (33) = happyShift action_21
action_15 _ = happyFail (happyExpListPerState 15)

action_16 (21) = happyShift action_2
action_16 (41) = happyShift action_19
action_16 (43) = happyShift action_20
action_16 (4) = happyGoto action_17
action_16 (5) = happyGoto action_18
action_16 _ = happyFail (happyExpListPerState 16)

action_17 _ = happyReduce_2

action_18 (47) = happyShift action_39
action_18 _ = happyReduce_7

action_19 (21) = happyShift action_2
action_19 (41) = happyShift action_19
action_19 (42) = happyShift action_38
action_19 (43) = happyShift action_20
action_19 (4) = happyGoto action_17
action_19 (5) = happyGoto action_37
action_19 _ = happyFail (happyExpListPerState 19)

action_20 (21) = happyShift action_2
action_20 (41) = happyShift action_19
action_20 (43) = happyShift action_20
action_20 (4) = happyGoto action_17
action_20 (5) = happyGoto action_36
action_20 _ = happyFail (happyExpListPerState 20)

action_21 (21) = happyShift action_2
action_21 (22) = happyShift action_30
action_21 (23) = happyShift action_31
action_21 (24) = happyShift action_7
action_21 (26) = happyShift action_32
action_21 (30) = happyShift action_33
action_21 (41) = happyShift action_34
action_21 (43) = happyShift action_35
action_21 (4) = happyGoto action_24
action_21 (8) = happyGoto action_25
action_21 (10) = happyGoto action_26
action_21 (11) = happyGoto action_27
action_21 (12) = happyGoto action_28
action_21 (13) = happyGoto action_29
action_21 _ = happyFail (happyExpListPerState 21)

action_22 (46) = happyShift action_16
action_22 (6) = happyGoto action_14
action_22 (16) = happyGoto action_23
action_22 _ = happyReduce_52

action_23 (42) = happyShift action_75
action_23 _ = happyFail (happyExpListPerState 23)

action_24 _ = happyReduce_33

action_25 (25) = happyShift action_74
action_25 _ = happyFail (happyExpListPerState 25)

action_26 (29) = happyShift action_62
action_26 (30) = happyShift action_63
action_26 (31) = happyShift action_64
action_26 (32) = happyShift action_65
action_26 (33) = happyShift action_66
action_26 (34) = happyShift action_67
action_26 (35) = happyShift action_68
action_26 (36) = happyShift action_69
action_26 (37) = happyShift action_70
action_26 (38) = happyShift action_71
action_26 (39) = happyShift action_72
action_26 (40) = happyShift action_73
action_26 _ = happyReduce_10

action_27 (21) = happyShift action_2
action_27 (22) = happyShift action_30
action_27 (23) = happyShift action_31
action_27 (41) = happyShift action_34
action_27 (43) = happyShift action_35
action_27 (4) = happyGoto action_24
action_27 (13) = happyGoto action_61
action_27 _ = happyReduce_12

action_28 _ = happyReduce_13

action_29 _ = happyReduce_29

action_30 _ = happyReduce_34

action_31 _ = happyReduce_32

action_32 (21) = happyShift action_2
action_32 (22) = happyShift action_30
action_32 (23) = happyShift action_31
action_32 (24) = happyShift action_7
action_32 (26) = happyShift action_32
action_32 (30) = happyShift action_33
action_32 (41) = happyShift action_34
action_32 (43) = happyShift action_35
action_32 (4) = happyGoto action_24
action_32 (8) = happyGoto action_25
action_32 (10) = happyGoto action_60
action_32 (11) = happyGoto action_27
action_32 (12) = happyGoto action_28
action_32 (13) = happyGoto action_29
action_32 _ = happyFail (happyExpListPerState 32)

action_33 (21) = happyShift action_2
action_33 (22) = happyShift action_30
action_33 (23) = happyShift action_31
action_33 (24) = happyShift action_7
action_33 (26) = happyShift action_32
action_33 (30) = happyShift action_33
action_33 (41) = happyShift action_34
action_33 (43) = happyShift action_35
action_33 (4) = happyGoto action_24
action_33 (8) = happyGoto action_25
action_33 (10) = happyGoto action_59
action_33 (11) = happyGoto action_27
action_33 (12) = happyGoto action_28
action_33 (13) = happyGoto action_29
action_33 _ = happyFail (happyExpListPerState 33)

action_34 (21) = happyShift action_2
action_34 (22) = happyShift action_30
action_34 (23) = happyShift action_31
action_34 (24) = happyShift action_7
action_34 (26) = happyShift action_32
action_34 (29) = happyShift action_46
action_34 (30) = happyShift action_47
action_34 (31) = happyShift action_48
action_34 (32) = happyShift action_49
action_34 (33) = happyShift action_50
action_34 (34) = happyShift action_51
action_34 (35) = happyShift action_52
action_34 (36) = happyShift action_53
action_34 (37) = happyShift action_54
action_34 (38) = happyShift action_55
action_34 (39) = happyShift action_56
action_34 (40) = happyShift action_57
action_34 (41) = happyShift action_34
action_34 (42) = happyShift action_58
action_34 (43) = happyShift action_35
action_34 (4) = happyGoto action_24
action_34 (8) = happyGoto action_25
action_34 (10) = happyGoto action_45
action_34 (11) = happyGoto action_27
action_34 (12) = happyGoto action_28
action_34 (13) = happyGoto action_29
action_34 _ = happyFail (happyExpListPerState 34)

action_35 (17) = happyGoto action_43
action_35 (20) = happyGoto action_44
action_35 _ = happyReduce_59

action_36 (44) = happyShift action_42
action_36 (47) = happyShift action_39
action_36 _ = happyFail (happyExpListPerState 36)

action_37 (42) = happyShift action_41
action_37 (47) = happyShift action_39
action_37 _ = happyFail (happyExpListPerState 37)

action_38 _ = happyReduce_3

action_39 (21) = happyShift action_2
action_39 (41) = happyShift action_19
action_39 (43) = happyShift action_20
action_39 (4) = happyGoto action_17
action_39 (5) = happyGoto action_40
action_39 _ = happyFail (happyExpListPerState 39)

action_40 (47) = happyShift action_39
action_40 _ = happyReduce_6

action_41 _ = happyReduce_4

action_42 _ = happyReduce_5

action_43 (44) = happyShift action_104
action_43 _ = happyFail (happyExpListPerState 43)

action_44 (45) = happyShift action_103
action_44 _ = happyReduce_54

action_45 (29) = happyShift action_62
action_45 (30) = happyShift action_63
action_45 (31) = happyShift action_64
action_45 (32) = happyShift action_65
action_45 (33) = happyShift action_66
action_45 (34) = happyShift action_67
action_45 (35) = happyShift action_68
action_45 (36) = happyShift action_69
action_45 (37) = happyShift action_70
action_45 (38) = happyShift action_71
action_45 (39) = happyShift action_72
action_45 (40) = happyShift action_73
action_45 (42) = happyShift action_102
action_45 _ = happyFail (happyExpListPerState 45)

action_46 (42) = happyShift action_101
action_46 _ = happyFail (happyExpListPerState 46)

action_47 (21) = happyShift action_2
action_47 (22) = happyShift action_30
action_47 (23) = happyShift action_31
action_47 (24) = happyShift action_7
action_47 (26) = happyShift action_32
action_47 (30) = happyShift action_33
action_47 (41) = happyShift action_34
action_47 (42) = happyShift action_100
action_47 (43) = happyShift action_35
action_47 (4) = happyGoto action_24
action_47 (8) = happyGoto action_25
action_47 (10) = happyGoto action_59
action_47 (11) = happyGoto action_27
action_47 (12) = happyGoto action_28
action_47 (13) = happyGoto action_29
action_47 _ = happyFail (happyExpListPerState 47)

action_48 (42) = happyShift action_99
action_48 _ = happyFail (happyExpListPerState 48)

action_49 (42) = happyShift action_98
action_49 _ = happyFail (happyExpListPerState 49)

action_50 (42) = happyShift action_97
action_50 _ = happyFail (happyExpListPerState 50)

action_51 (42) = happyShift action_96
action_51 _ = happyFail (happyExpListPerState 51)

action_52 (42) = happyShift action_95
action_52 _ = happyFail (happyExpListPerState 52)

action_53 (42) = happyShift action_94
action_53 _ = happyFail (happyExpListPerState 53)

action_54 (42) = happyShift action_93
action_54 _ = happyFail (happyExpListPerState 54)

action_55 (42) = happyShift action_92
action_55 _ = happyFail (happyExpListPerState 55)

action_56 (42) = happyShift action_91
action_56 _ = happyFail (happyExpListPerState 56)

action_57 (42) = happyShift action_90
action_57 _ = happyFail (happyExpListPerState 57)

action_58 _ = happyReduce_35

action_59 (31) = happyShift action_64
action_59 (32) = happyShift action_65
action_59 _ = happyReduce_14

action_60 (27) = happyShift action_89
action_60 (29) = happyShift action_62
action_60 (30) = happyShift action_63
action_60 (31) = happyShift action_64
action_60 (32) = happyShift action_65
action_60 (33) = happyShift action_66
action_60 (34) = happyShift action_67
action_60 (35) = happyShift action_68
action_60 (36) = happyShift action_69
action_60 (37) = happyShift action_70
action_60 (38) = happyShift action_71
action_60 (39) = happyShift action_72
action_60 (40) = happyShift action_73
action_60 _ = happyFail (happyExpListPerState 60)

action_61 _ = happyReduce_28

action_62 (21) = happyShift action_2
action_62 (22) = happyShift action_30
action_62 (23) = happyShift action_31
action_62 (24) = happyShift action_7
action_62 (26) = happyShift action_32
action_62 (30) = happyShift action_33
action_62 (41) = happyShift action_34
action_62 (43) = happyShift action_35
action_62 (4) = happyGoto action_24
action_62 (8) = happyGoto action_25
action_62 (10) = happyGoto action_88
action_62 (11) = happyGoto action_27
action_62 (12) = happyGoto action_28
action_62 (13) = happyGoto action_29
action_62 _ = happyFail (happyExpListPerState 62)

action_63 (21) = happyShift action_2
action_63 (22) = happyShift action_30
action_63 (23) = happyShift action_31
action_63 (24) = happyShift action_7
action_63 (26) = happyShift action_32
action_63 (30) = happyShift action_33
action_63 (41) = happyShift action_34
action_63 (43) = happyShift action_35
action_63 (4) = happyGoto action_24
action_63 (8) = happyGoto action_25
action_63 (10) = happyGoto action_87
action_63 (11) = happyGoto action_27
action_63 (12) = happyGoto action_28
action_63 (13) = happyGoto action_29
action_63 _ = happyFail (happyExpListPerState 63)

action_64 (21) = happyShift action_2
action_64 (22) = happyShift action_30
action_64 (23) = happyShift action_31
action_64 (24) = happyShift action_7
action_64 (26) = happyShift action_32
action_64 (30) = happyShift action_33
action_64 (41) = happyShift action_34
action_64 (43) = happyShift action_35
action_64 (4) = happyGoto action_24
action_64 (8) = happyGoto action_25
action_64 (10) = happyGoto action_86
action_64 (11) = happyGoto action_27
action_64 (12) = happyGoto action_28
action_64 (13) = happyGoto action_29
action_64 _ = happyFail (happyExpListPerState 64)

action_65 (21) = happyShift action_2
action_65 (22) = happyShift action_30
action_65 (23) = happyShift action_31
action_65 (24) = happyShift action_7
action_65 (26) = happyShift action_32
action_65 (30) = happyShift action_33
action_65 (41) = happyShift action_34
action_65 (43) = happyShift action_35
action_65 (4) = happyGoto action_24
action_65 (8) = happyGoto action_25
action_65 (10) = happyGoto action_85
action_65 (11) = happyGoto action_27
action_65 (12) = happyGoto action_28
action_65 (13) = happyGoto action_29
action_65 _ = happyFail (happyExpListPerState 65)

action_66 (21) = happyShift action_2
action_66 (22) = happyShift action_30
action_66 (23) = happyShift action_31
action_66 (24) = happyShift action_7
action_66 (26) = happyShift action_32
action_66 (30) = happyShift action_33
action_66 (41) = happyShift action_34
action_66 (43) = happyShift action_35
action_66 (4) = happyGoto action_24
action_66 (8) = happyGoto action_25
action_66 (10) = happyGoto action_84
action_66 (11) = happyGoto action_27
action_66 (12) = happyGoto action_28
action_66 (13) = happyGoto action_29
action_66 _ = happyFail (happyExpListPerState 66)

action_67 (21) = happyShift action_2
action_67 (22) = happyShift action_30
action_67 (23) = happyShift action_31
action_67 (24) = happyShift action_7
action_67 (26) = happyShift action_32
action_67 (30) = happyShift action_33
action_67 (41) = happyShift action_34
action_67 (43) = happyShift action_35
action_67 (4) = happyGoto action_24
action_67 (8) = happyGoto action_25
action_67 (10) = happyGoto action_83
action_67 (11) = happyGoto action_27
action_67 (12) = happyGoto action_28
action_67 (13) = happyGoto action_29
action_67 _ = happyFail (happyExpListPerState 67)

action_68 (21) = happyShift action_2
action_68 (22) = happyShift action_30
action_68 (23) = happyShift action_31
action_68 (24) = happyShift action_7
action_68 (26) = happyShift action_32
action_68 (30) = happyShift action_33
action_68 (41) = happyShift action_34
action_68 (43) = happyShift action_35
action_68 (4) = happyGoto action_24
action_68 (8) = happyGoto action_25
action_68 (10) = happyGoto action_82
action_68 (11) = happyGoto action_27
action_68 (12) = happyGoto action_28
action_68 (13) = happyGoto action_29
action_68 _ = happyFail (happyExpListPerState 68)

action_69 (21) = happyShift action_2
action_69 (22) = happyShift action_30
action_69 (23) = happyShift action_31
action_69 (24) = happyShift action_7
action_69 (26) = happyShift action_32
action_69 (30) = happyShift action_33
action_69 (41) = happyShift action_34
action_69 (43) = happyShift action_35
action_69 (4) = happyGoto action_24
action_69 (8) = happyGoto action_25
action_69 (10) = happyGoto action_81
action_69 (11) = happyGoto action_27
action_69 (12) = happyGoto action_28
action_69 (13) = happyGoto action_29
action_69 _ = happyFail (happyExpListPerState 69)

action_70 (21) = happyShift action_2
action_70 (22) = happyShift action_30
action_70 (23) = happyShift action_31
action_70 (24) = happyShift action_7
action_70 (26) = happyShift action_32
action_70 (30) = happyShift action_33
action_70 (41) = happyShift action_34
action_70 (43) = happyShift action_35
action_70 (4) = happyGoto action_24
action_70 (8) = happyGoto action_25
action_70 (10) = happyGoto action_80
action_70 (11) = happyGoto action_27
action_70 (12) = happyGoto action_28
action_70 (13) = happyGoto action_29
action_70 _ = happyFail (happyExpListPerState 70)

action_71 (21) = happyShift action_2
action_71 (22) = happyShift action_30
action_71 (23) = happyShift action_31
action_71 (24) = happyShift action_7
action_71 (26) = happyShift action_32
action_71 (30) = happyShift action_33
action_71 (41) = happyShift action_34
action_71 (43) = happyShift action_35
action_71 (4) = happyGoto action_24
action_71 (8) = happyGoto action_25
action_71 (10) = happyGoto action_79
action_71 (11) = happyGoto action_27
action_71 (12) = happyGoto action_28
action_71 (13) = happyGoto action_29
action_71 _ = happyFail (happyExpListPerState 71)

action_72 (21) = happyShift action_2
action_72 (22) = happyShift action_30
action_72 (23) = happyShift action_31
action_72 (24) = happyShift action_7
action_72 (26) = happyShift action_32
action_72 (30) = happyShift action_33
action_72 (41) = happyShift action_34
action_72 (43) = happyShift action_35
action_72 (4) = happyGoto action_24
action_72 (8) = happyGoto action_25
action_72 (10) = happyGoto action_78
action_72 (11) = happyGoto action_27
action_72 (12) = happyGoto action_28
action_72 (13) = happyGoto action_29
action_72 _ = happyFail (happyExpListPerState 72)

action_73 (21) = happyShift action_2
action_73 (22) = happyShift action_30
action_73 (23) = happyShift action_31
action_73 (24) = happyShift action_7
action_73 (26) = happyShift action_32
action_73 (30) = happyShift action_33
action_73 (41) = happyShift action_34
action_73 (43) = happyShift action_35
action_73 (4) = happyGoto action_24
action_73 (8) = happyGoto action_25
action_73 (10) = happyGoto action_77
action_73 (11) = happyGoto action_27
action_73 (12) = happyGoto action_28
action_73 (13) = happyGoto action_29
action_73 _ = happyFail (happyExpListPerState 73)

action_74 (21) = happyShift action_2
action_74 (22) = happyShift action_30
action_74 (23) = happyShift action_31
action_74 (24) = happyShift action_7
action_74 (26) = happyShift action_32
action_74 (30) = happyShift action_33
action_74 (41) = happyShift action_34
action_74 (43) = happyShift action_35
action_74 (4) = happyGoto action_24
action_74 (8) = happyGoto action_25
action_74 (10) = happyGoto action_76
action_74 (11) = happyGoto action_27
action_74 (12) = happyGoto action_28
action_74 (13) = happyGoto action_29
action_74 _ = happyFail (happyExpListPerState 74)

action_75 _ = happyReduce_8

action_76 (29) = happyShift action_62
action_76 (30) = happyShift action_63
action_76 (31) = happyShift action_64
action_76 (32) = happyShift action_65
action_76 (33) = happyShift action_66
action_76 (34) = happyShift action_67
action_76 (35) = happyShift action_68
action_76 (36) = happyShift action_69
action_76 (37) = happyShift action_70
action_76 (38) = happyShift action_71
action_76 (39) = happyShift action_72
action_76 (40) = happyShift action_73
action_76 _ = happyReduce_27

action_77 (29) = happyShift action_62
action_77 (30) = happyShift action_63
action_77 (31) = happyShift action_64
action_77 (32) = happyShift action_65
action_77 (33) = happyShift action_66
action_77 (34) = happyShift action_67
action_77 (35) = happyShift action_68
action_77 (36) = happyShift action_69
action_77 (37) = happyShift action_70
action_77 (38) = happyShift action_71
action_77 (39) = happyShift action_72
action_77 _ = happyReduce_26

action_78 (29) = happyShift action_62
action_78 (30) = happyShift action_63
action_78 (31) = happyShift action_64
action_78 (32) = happyShift action_65
action_78 (33) = happyShift action_66
action_78 (34) = happyShift action_67
action_78 (35) = happyShift action_68
action_78 (36) = happyShift action_69
action_78 (37) = happyShift action_70
action_78 (38) = happyShift action_71
action_78 _ = happyReduce_25

action_79 (29) = happyShift action_62
action_79 (30) = happyShift action_63
action_79 (31) = happyShift action_64
action_79 (32) = happyShift action_65
action_79 (33) = happyFail []
action_79 (34) = happyFail []
action_79 (35) = happyFail []
action_79 (36) = happyFail []
action_79 (37) = happyFail []
action_79 (38) = happyFail []
action_79 _ = happyReduce_24

action_80 (29) = happyShift action_62
action_80 (30) = happyShift action_63
action_80 (31) = happyShift action_64
action_80 (32) = happyShift action_65
action_80 (33) = happyFail []
action_80 (34) = happyFail []
action_80 (35) = happyFail []
action_80 (36) = happyFail []
action_80 (37) = happyFail []
action_80 (38) = happyFail []
action_80 _ = happyReduce_23

action_81 (29) = happyShift action_62
action_81 (30) = happyShift action_63
action_81 (31) = happyShift action_64
action_81 (32) = happyShift action_65
action_81 (33) = happyFail []
action_81 (34) = happyFail []
action_81 (35) = happyFail []
action_81 (36) = happyFail []
action_81 (37) = happyFail []
action_81 (38) = happyFail []
action_81 _ = happyReduce_22

action_82 (29) = happyShift action_62
action_82 (30) = happyShift action_63
action_82 (31) = happyShift action_64
action_82 (32) = happyShift action_65
action_82 (33) = happyFail []
action_82 (34) = happyFail []
action_82 (35) = happyFail []
action_82 (36) = happyFail []
action_82 (37) = happyFail []
action_82 (38) = happyFail []
action_82 _ = happyReduce_21

action_83 (29) = happyShift action_62
action_83 (30) = happyShift action_63
action_83 (31) = happyShift action_64
action_83 (32) = happyShift action_65
action_83 (33) = happyFail []
action_83 (34) = happyFail []
action_83 (35) = happyFail []
action_83 (36) = happyFail []
action_83 (37) = happyFail []
action_83 (38) = happyFail []
action_83 _ = happyReduce_20

action_84 (29) = happyShift action_62
action_84 (30) = happyShift action_63
action_84 (31) = happyShift action_64
action_84 (32) = happyShift action_65
action_84 (33) = happyFail []
action_84 (34) = happyFail []
action_84 (35) = happyFail []
action_84 (36) = happyFail []
action_84 (37) = happyFail []
action_84 (38) = happyFail []
action_84 _ = happyReduce_19

action_85 _ = happyReduce_18

action_86 _ = happyReduce_17

action_87 (31) = happyShift action_64
action_87 (32) = happyShift action_65
action_87 _ = happyReduce_16

action_88 (31) = happyShift action_64
action_88 (32) = happyShift action_65
action_88 _ = happyReduce_15

action_89 (21) = happyShift action_2
action_89 (22) = happyShift action_30
action_89 (23) = happyShift action_31
action_89 (24) = happyShift action_7
action_89 (26) = happyShift action_32
action_89 (30) = happyShift action_33
action_89 (41) = happyShift action_34
action_89 (43) = happyShift action_35
action_89 (4) = happyGoto action_24
action_89 (8) = happyGoto action_25
action_89 (10) = happyGoto action_106
action_89 (11) = happyGoto action_27
action_89 (12) = happyGoto action_28
action_89 (13) = happyGoto action_29
action_89 _ = happyFail (happyExpListPerState 89)

action_90 _ = happyReduce_49

action_91 _ = happyReduce_48

action_92 _ = happyReduce_47

action_93 _ = happyReduce_46

action_94 _ = happyReduce_45

action_95 _ = happyReduce_44

action_96 _ = happyReduce_43

action_97 _ = happyReduce_42

action_98 _ = happyReduce_41

action_99 _ = happyReduce_40

action_100 _ = happyReduce_39

action_101 _ = happyReduce_38

action_102 _ = happyReduce_37

action_103 (21) = happyShift action_2
action_103 (22) = happyShift action_30
action_103 (23) = happyShift action_31
action_103 (24) = happyShift action_7
action_103 (26) = happyShift action_32
action_103 (30) = happyShift action_33
action_103 (41) = happyShift action_34
action_103 (43) = happyShift action_35
action_103 (4) = happyGoto action_24
action_103 (8) = happyGoto action_25
action_103 (10) = happyGoto action_105
action_103 (11) = happyGoto action_27
action_103 (12) = happyGoto action_28
action_103 (13) = happyGoto action_29
action_103 _ = happyFail (happyExpListPerState 103)

action_104 _ = happyReduce_36

action_105 (29) = happyShift action_62
action_105 (30) = happyShift action_63
action_105 (31) = happyShift action_64
action_105 (32) = happyShift action_65
action_105 (33) = happyShift action_66
action_105 (34) = happyShift action_67
action_105 (35) = happyShift action_68
action_105 (36) = happyShift action_69
action_105 (37) = happyShift action_70
action_105 (38) = happyShift action_71
action_105 (39) = happyShift action_72
action_105 (40) = happyShift action_73
action_105 _ = happyReduce_60

action_106 (24) = happyReduce_30
action_106 (25) = happyReduce_30
action_106 (27) = happyReduce_30
action_106 (28) = happyShift action_107
action_106 (29) = happyShift action_62
action_106 (30) = happyShift action_63
action_106 (31) = happyShift action_64
action_106 (32) = happyShift action_65
action_106 (33) = happyShift action_66
action_106 (34) = happyShift action_67
action_106 (35) = happyShift action_68
action_106 (36) = happyShift action_69
action_106 (37) = happyShift action_70
action_106 (38) = happyShift action_71
action_106 (39) = happyShift action_72
action_106 (40) = happyShift action_73
action_106 (42) = happyReduce_30
action_106 (44) = happyReduce_30
action_106 (45) = happyReduce_30
action_106 (48) = happyReduce_30
action_106 _ = happyReduce_30

action_107 (21) = happyShift action_2
action_107 (22) = happyShift action_30
action_107 (23) = happyShift action_31
action_107 (24) = happyShift action_7
action_107 (26) = happyShift action_32
action_107 (30) = happyShift action_33
action_107 (41) = happyShift action_34
action_107 (43) = happyShift action_35
action_107 (4) = happyGoto action_24
action_107 (8) = happyGoto action_25
action_107 (10) = happyGoto action_108
action_107 (11) = happyGoto action_27
action_107 (12) = happyGoto action_28
action_107 (13) = happyGoto action_29
action_107 _ = happyFail (happyExpListPerState 107)

action_108 (29) = happyShift action_62
action_108 (30) = happyShift action_63
action_108 (31) = happyShift action_64
action_108 (32) = happyShift action_65
action_108 (33) = happyShift action_66
action_108 (34) = happyShift action_67
action_108 (35) = happyShift action_68
action_108 (36) = happyShift action_69
action_108 (37) = happyShift action_70
action_108 (38) = happyShift action_71
action_108 (39) = happyShift action_72
action_108 (40) = happyShift action_73
action_108 _ = happyReduce_31

happyReduce_1 = happySpecReduce_1  4 happyReduction_1
happyReduction_1 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn4
		 (unTok happy_var_1 (\range (L.Identifier name) -> Name range name)
	)
happyReduction_1 _  = notHappyAtAll 

happyReduce_2 = happySpecReduce_1  5 happyReduction_2
happyReduction_2 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn5
		 (TVar (info happy_var_1) happy_var_1
	)
happyReduction_2 _  = notHappyAtAll 

happyReduce_3 = happySpecReduce_2  5 happyReduction_3
happyReduction_3 (HappyTerminal happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn5
		 (TUnit (L.rtRange happy_var_1 <-> L.rtRange happy_var_2)
	)
happyReduction_3 _ _  = notHappyAtAll 

happyReduce_4 = happySpecReduce_3  5 happyReduction_4
happyReduction_4 (HappyTerminal happy_var_3)
	(HappyAbsSyn5  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn5
		 (TPar (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) happy_var_2
	)
happyReduction_4 _ _ _  = notHappyAtAll 

happyReduce_5 = happySpecReduce_3  5 happyReduction_5
happyReduction_5 (HappyTerminal happy_var_3)
	(HappyAbsSyn5  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn5
		 (TList (L.rtRange happy_var_1 <-> L.rtRange happy_var_3) happy_var_2
	)
happyReduction_5 _ _ _  = notHappyAtAll 

happyReduce_6 = happySpecReduce_3  5 happyReduction_6
happyReduction_6 (HappyAbsSyn5  happy_var_3)
	_
	(HappyAbsSyn5  happy_var_1)
	 =  HappyAbsSyn5
		 (TArrow (info happy_var_1 <-> info happy_var_3) happy_var_1 happy_var_3
	)
happyReduction_6 _ _ _  = notHappyAtAll 

happyReduce_7 = happySpecReduce_2  6 happyReduction_7
happyReduction_7 (HappyAbsSyn5  happy_var_2)
	_
	 =  HappyAbsSyn5
		 (happy_var_2
	)
happyReduction_7 _ _  = notHappyAtAll 

happyReduce_8 = happyReduce 4 7 happyReduction_8
happyReduction_8 ((HappyTerminal happy_var_4) `HappyStk`
	(HappyAbsSyn16  happy_var_3) `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn7
		 (Argument (L.rtRange happy_var_1 <-> L.rtRange happy_var_4) happy_var_2 happy_var_3
	) `HappyStk` happyRest

happyReduce_9 = happySpecReduce_1  7 happyReduction_9
happyReduction_9 (HappyAbsSyn4  happy_var_1)
	 =  HappyAbsSyn7
		 (Argument (info happy_var_1) happy_var_1 Nothing
	)
happyReduction_9 _  = notHappyAtAll 

happyReduce_10 = happyReduce 6 8 happyReduction_10
happyReduction_10 ((HappyAbsSyn10  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn16  happy_var_4) `HappyStk`
	(HappyAbsSyn14  happy_var_3) `HappyStk`
	(HappyAbsSyn4  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn8
		 (Dec (L.rtRange happy_var_1 <-> info happy_var_6) happy_var_2 happy_var_3 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_11 = happySpecReduce_1  9 happyReduction_11
happyReduction_11 (HappyAbsSyn15  happy_var_1)
	 =  HappyAbsSyn9
		 (happy_var_1
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

happyReduce_14 = happySpecReduce_2  10 happyReduction_14
happyReduction_14 (HappyAbsSyn10  happy_var_2)
	(HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (ENeg (L.rtRange happy_var_1 <-> info happy_var_2) happy_var_2
	)
happyReduction_14 _ _  = notHappyAtAll 

happyReduce_15 = happySpecReduce_3  10 happyReduction_15
happyReduction_15 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Plus (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_15 _ _ _  = notHappyAtAll 

happyReduce_16 = happySpecReduce_3  10 happyReduction_16
happyReduction_16 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Minus (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_16 _ _ _  = notHappyAtAll 

happyReduce_17 = happySpecReduce_3  10 happyReduction_17
happyReduction_17 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Times (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_17 _ _ _  = notHappyAtAll 

happyReduce_18 = happySpecReduce_3  10 happyReduction_18
happyReduction_18 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Divide (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_18 _ _ _  = notHappyAtAll 

happyReduce_19 = happySpecReduce_3  10 happyReduction_19
happyReduction_19 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Eq (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_19 _ _ _  = notHappyAtAll 

happyReduce_20 = happySpecReduce_3  10 happyReduction_20
happyReduction_20 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Neq (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_20 _ _ _  = notHappyAtAll 

happyReduce_21 = happySpecReduce_3  10 happyReduction_21
happyReduction_21 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Lt (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_21 _ _ _  = notHappyAtAll 

happyReduce_22 = happySpecReduce_3  10 happyReduction_22
happyReduction_22 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Le (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_22 _ _ _  = notHappyAtAll 

happyReduce_23 = happySpecReduce_3  10 happyReduction_23
happyReduction_23 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Gt (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_23 _ _ _  = notHappyAtAll 

happyReduce_24 = happySpecReduce_3  10 happyReduction_24
happyReduction_24 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Ge (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_24 _ _ _  = notHappyAtAll 

happyReduce_25 = happySpecReduce_3  10 happyReduction_25
happyReduction_25 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (And (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_25 _ _ _  = notHappyAtAll 

happyReduce_26 = happySpecReduce_3  10 happyReduction_26
happyReduction_26 (HappyAbsSyn10  happy_var_3)
	(HappyTerminal happy_var_2)
	(HappyAbsSyn10  happy_var_1)
	 =  HappyAbsSyn10
		 (EBinOp (info happy_var_1 <-> info happy_var_3) happy_var_1 (Or (L.rtRange happy_var_2)) happy_var_3
	)
happyReduction_26 _ _ _  = notHappyAtAll 

happyReduce_27 = happySpecReduce_3  10 happyReduction_27
happyReduction_27 (HappyAbsSyn10  happy_var_3)
	_
	(HappyAbsSyn8  happy_var_1)
	 =  HappyAbsSyn10
		 (ELetIn (info happy_var_1 <-> info happy_var_3) happy_var_1 happy_var_3
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

happyReduce_30 = happyReduce 4 12 happyReduction_30
happyReduction_30 ((HappyAbsSyn10  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (EIfThen (L.rtRange happy_var_1 <-> info happy_var_4) happy_var_2 happy_var_4
	) `HappyStk` happyRest

happyReduce_31 = happyReduce 6 12 happyReduction_31
happyReduction_31 ((HappyAbsSyn10  happy_var_6) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_4) `HappyStk`
	_ `HappyStk`
	(HappyAbsSyn10  happy_var_2) `HappyStk`
	(HappyTerminal happy_var_1) `HappyStk`
	happyRest)
	 = HappyAbsSyn10
		 (EIfThenElse (L.rtRange happy_var_1 <-> info happy_var_6) happy_var_2 happy_var_4 happy_var_6
	) `HappyStk` happyRest

happyReduce_32 = happySpecReduce_1  13 happyReduction_32
happyReduction_32 (HappyTerminal happy_var_1)
	 =  HappyAbsSyn10
		 (unTok happy_var_1 (\range (L.Integer int) -> EInt range int)
	)
happyReduction_32 _  = notHappyAtAll 

happyReduce_33 = happySpecReduce_1  13 happyReduction_33
happyReduction_33 (HappyAbsSyn4  happy_var_1)
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
happyReduction_53 (HappyAbsSyn5  happy_var_1)
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
happyReduction_56 (HappyAbsSyn7  happy_var_2)
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
happyReduction_58 (HappyAbsSyn8  happy_var_2)
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
	L.RangedToken L.EOF _ -> action 48 48 tk (HappyState action) sts stk;
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
	L.RangedToken L.LBrack _ -> cont 43;
	L.RangedToken L.RBrack _ -> cont 44;
	L.RangedToken L.Comma _ -> cont 45;
	L.RangedToken L.Colon _ -> cont 46;
	L.RangedToken L.Arrow _ -> cont 47;
	_ -> happyError' (tk, [])
	})

happyError_ explist 48 tk = happyError' (tk, explist)
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
parseMiniML = happySomeParser where
 happySomeParser = happyThen (happyParse action_0) (\x -> case x of {HappyAbsSyn9 z -> happyReturn z; _other -> notHappyAtAll })

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

-- | Unsafely extracts the the metainformation field of a node.
info :: Foldable f => f a -> a
info = fromJust . getFirst . foldMap pure

-- | Performs the union of two ranges by creating a new range starting at the
-- start position of the first range, and stopping at the stop position of the
-- second range.
-- Invariant: The LHS range starts before the RHS range.
(<->) :: L.Range -> L.Range -> L.Range
L.Range a1 _ <-> L.Range _ b2 = L.Range a1 b2

-- * AST

data Name a
  = Name a ByteString
  deriving (Foldable, Show)

data Type a
  = TVar a (Name a)
  | TPar a (Type a)
  | TUnit a
  | TList a (Type a)
  | TArrow a (Type a) (Type a)
  deriving (Foldable, Show)

data Argument a
  = Argument a (Name a) (Maybe (Type a))
  deriving (Foldable, Show)

data Dec a
  = Dec a (Name a) [Argument a] (Maybe (Type a)) (Exp a)
  deriving (Foldable, Show)

data Operator a
  = Plus a
  | Minus a
  | Times a
  | Divide a
  | Eq a
  | Neq a
  | Lt a
  | Le a
  | Gt a
  | Ge a
  | And a
  | Or a
  deriving (Foldable, Show)

data Exp a
  = EInt a Integer
  | EVar a (Name a)
  | EString a ByteString
  | EUnit a
  | EList a [Exp a]
  | EPar a (Exp a)
  | EApp a (Exp a) (Exp a)
  | EIfThen a (Exp a) (Exp a)
  | EIfThenElse a (Exp a) (Exp a) (Exp a)
  | ENeg a (Exp a)
  | EBinOp a (Exp a) (Operator a) (Exp a)
  | EOp a (Operator a)
  | ELetIn a (Dec a) (Exp a)
  deriving (Foldable, Show)
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
