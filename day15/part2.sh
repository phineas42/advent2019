#!/bin/bash
. ../stdlib.bash

declare -A MAP=(
	["6 -1"]="1" ["1 -17"]="1" ["10 -19"]="1" ["5 -13"]="1" ["10 -2"]="." ["-1 6"]="." ["1 9"]="1" ["12 18"]="." ["15 15"]="1" ["13 0"]="." ["-11 -20"]="." ["-15 -6"]="1" ["-18 11"]="." ["-17 14"]="1" ["4 4"]="." ["1 -16"]="." ["5 -12"]="." ["10 -3"]="." ["-1 7"]="1" ["1 8"]="." ["12 19"]="1" ["15 14"]="1" ["13 1"]="1" ["10 -18"]="." ["-11 -21"]="1" ["-15 -7"]="1" ["-18 10"]="." ["-17 15"]="1" ["4 5"]="1" ["-11 9"]="1" ["1 -15"]="1" ["15 17"]="1" ["5 -11"]="1" ["4 6"]="." ["13 2"]="1" ["-15 -4"]="1" ["-18 13"]="." ["-17 16"]="1" ["-1 4"]="." ["6 -3"]="." ["-11 8"]="1" ["1 -14"]="1" ["10 -1"]="." ["-17 17"]="1" ["4 7"]="." ["15 16"]="." ["13 3"]="1" ["-15 -5"]="1" ["-18 12"]="." ["-1 5"]="1" ["6 -2"]="." ["5 -10"]="1" ["6 -5"]="1" ["-1 2"]="1" ["1 -13"]="1" ["11 -9"]="1" ["10 -6"]="." ["15 11"]="1" ["13 4"]="." ["5 -17"]="1" ["-20 -19"]="." ["-15 -2"]="." ["-18 15"]="1" ["-17 10"]="." ["4 0"]="." ["-1 3"]="1" ["13 5"]="1" ["1 -12"]="1" ["11 -8"]="." ["10 -7"]="1" ["-21 18"]="1" ["15 10"]="." ["19 -20"]="1" ["5 -16"]="." ["-20 -18"]="." ["-15 -3"]="1" ["-18 14"]="." ["-17 11"]="1" ["4 1"]="." ["6 -4"]="." ["-9 8"]="." ["5 -15"]="1" ["10 -4"]="." ["13 6"]="." ["-18 17"]="." ["-11 18"]="." ["15 13"]="1" ["-8 -8"]="." ["-17 12"]="1" ["4 2"]="." ["6 -7"]="." ["-1 0"]="." ["-1 1"]="1" ["4 3"]="1" ["-9 9"]="1" ["5 -14"]="." ["10 -5"]="." ["13 7"]="1" ["-18 16"]="." ["-11 19"]="1" ["15 12"]="1"
	["-8 -9"]="1" ["-15 -1"]="1" ["-17 13"]="1" ["6 -6"]="." ["1 -10"]="1" ["1 1"]="1" ["-11 3"]="1" ["-9 6"]="1" ["11 -5"]="1" ["10 -11"]="1" ["13 8"]="." ["12 10"]="." ["-18 19"]="1" ["6 -21"]="1" ["-8 -6"]="." ["-20 -15"]="." ["-11 16"]="." ["6 -9"]="1" ["-11 2"]="1" ["-9 7"]="1" ["13 9"]="1" ["11 -4"]="1" ["10 -10"]="." ["12 11"]="." ["-18 18"]="." ["6 -20"]="." ["-8 -7"]="." ["-20 -14"]="." ["-21 14"]="1" ["-11 17"]="1" ["6 -8"]="." ["1 0"]="1" ["-11 1"]="1" ["-11 14"]="1" ["-9 4"]="." ["-8 -4"]="." ["10 -13"]="1" ["10 -8"]="." ["11 -7"]="1" ["12 12"]="." ["-21 17"]="1" ["5 -19"]="1" ["-20 -17"]="." ["1 3"]="1" ["-11 15"]="1" ["-8 -5"]="1" ["-9 5"]="1" ["12 13"]="." ["10 -12"]="." ["10 -9"]="1" ["11 -6"]="." ["-21 16"]="1" ["5 -18"]="1" ["-20 -16"]="." ["-11 0"]="." ["1 2"]="." ["-9 2"]="1" ["-11 12"]="." ["-11 7"]="1" ["-8 -2"]="." ["12 14"]="." ["11 -1"]="1" ["-17 18"]="." ["4 8"]="." ["15 19"]="1" ["10 -15"]="." ["7 -20"]="." ["-20 -11"]="." ["-21 11"]="1" ["-9 3"]="1" ["-11 13"]="1" ["-11 6"]="." ["-8 -3"]="." ["12 15"]="." ["-17 19"]="1" ["4 9"]="1" ["15 18"]="." ["10 -14"]="." ["7 -21"]="1" ["-20 -10"]="." ["-21 10"]="1" ["1 4"]="1" ["-9 0"]="1" ["-11 5"]="1" ["-11 10"]="." ["12 16"]="." ["11 -3"]="1" ["1 7"]="1" ["-1 8"]="1" ["10 -17"]="1" ["1 -19"]="1" ["-12 -21"]="1" ["-20 -13"]="." ["-15 -8"]="1" ["-21 13"]="1" ["-9 1"]="1" ["-11 4"]="1" ["-11 11"]="1" ["-8 -1"]="." ["12 17"]="1"
	["11 -2"]="1" ["1 6"]="1" ["-1 9"]="1" ["10 -16"]="." ["1 -18"]="." ["-12 -20"]="." ["-20 -12"]="." ["-15 -9"]="1" ["-21 12"]="1" ["-13 9"]="1" ["-8 7"]="." ["-8 12"]="." ["15 6"]="1" ["15 -10"]="." ["13 -12"]="." ["13 -7"]="1" ["16 14"]="." ["19 -5"]="1" ["-4 -19"]="." ["-21 -18"]="1" ["-11 -2"]="." ["-7 13"]="1" ["-3 4"]="1" ["2 2"]="." ["-11 -3"]="1" ["-13 8"]="1" ["-8 13"]="1" ["-7 12"]="." ["-8 6"]="." ["15 7"]="1" ["15 -11"]="1" ["13 -13"]="1" ["13 -6"]="." ["-3 5"]="1" ["16 15"]="1" ["19 10"]="1" ["19 -4"]="1" ["-4 -18"]="." ["-21 -19"]="1" ["-17 -1"]="1" ["2 3"]="." ["2 0"]="." ["-7 11"]="1" ["-8 10"]="." ["-8 5"]="1" ["15 4"]="1" ["13 -5"]="1" ["15 -12"]="1" ["13 -10"]="1" ["-3 6"]="." ["19 13"]="1" ["16 16"]="." ["19 -7"]="1" ["-3 -9"]="1" ["-17 -2"]="." ["-19 -8"]="." ["2 1"]="." ["-7 10"]="1" ["-8 11"]="." ["-8 4"]="." ["15 -13"]="1" ["15 5"]="1" ["13 -11"]="1" ["-3 7"]="1" ["19 12"]="1" ["16 17"]="." ["13 -4"]="." ["19 -6"]="1" ["-3 -8"]="." ["-17 -3"]="1" ["-19 -9"]="1" ["-11 -1"]="1" ["-11 -6"]="1" ["-8 3"]="." ["15 -14"]="1" ["-7 17"]="1" ["2 6"]="." ["19 15"]="1" ["16 10"]="." ["19 -1"]="1" ["15 2"]="." ["13 -3"]="1" ["13 -16"]="1" ["-5 -9"]="1" ["-18 -18"]="." ["-17 -4"]="." ["-8 16"]="." ["-3 0"]="." ["-3 1"]="1" ["-11 -7"]="1" ["-8 2"]="." ["15 -15"]="1" ["15 3"]="1" ["2 7"]="." ["19 14"]="1" ["16 11"]="1" ["13 -2"]="." ["13 -17"]="1" ["-5 -8"]="1" ["-18 -19"]="."
	["-17 -5"]="1" ["-8 17"]="1" ["-7 16"]="1" ["-11 -4"]="1" ["-8 1"]="." ["9 -19"]="1" ["15 -16"]="1" ["13 -1"]="1" ["10 18"]="." ["19 17"]="1" ["16 12"]="." ["15 0"]="." ["13 -14"]="." ["-16 -18"]="." ["-17 -6"]="." ["-8 14"]="." ["-7 15"]="1" ["-3 2"]="." ["2 4"]="." ["-8 0"]="." ["15 -17"]="1" ["10 19"]="1" ["16 13"]="." ["19 16"]="1" ["19 -2"]="1" ["15 1"]="1" ["13 -15"]="1" ["9 -18"]="." ["-16 -19"]="1" ["-17 -7"]="1" ["-8 15"]="." ["-7 14"]="." ["-3 3"]="1" ["2 5"]="1" ["-3 -3"]="1" ["-18 -14"]="." ["-5 -5"]="1" ["15 -18"]="1" ["10 16"]="." ["9 -17"]="1" ["-4 -11"]="." ["-16 -16"]="." ["-21 -10"]="1" ["-19 -2"]="." ["-17 -8"]="." ["-13 1"]="1" ["-3 -2"]="1" ["-18 -15"]="." ["15 -19"]="1" ["10 17"]="." ["19 18"]="1" ["9 -16"]="1" ["-4 -10"]="." ["-16 -17"]="." ["-21 -11"]="1" ["-19 -3"]="1" ["-17 -9"]="1" ["-13 0"]="1" ["-5 -4"]="1" ["-3 -1"]="1" ["-18 -16"]="4" ["-11 -8"]="1" ["10 14"]="." ["-8 18"]="." ["-7 19"]="1" ["2 8"]="." ["9 -15"]="1" ["13 -18"]="1" ["-5 -7"]="1" ["-4 -13"]="." ["-16 -14"]="." ["-21 -12"]="1" ["-13 3"]="1" ["-18 -17"]="1" ["-11 -9"]="1" ["10 15"]="1" ["-8 19"]="1" ["-7 18"]="." ["2 9"]="1" ["9 -14"]="." ["13 -19"]="1" ["-5 -6"]="." ["-4 -12"]="." ["-16 -15"]="." ["-21 -13"]="1" ["-19 -1"]="1" ["-13 2"]="1" ["9 -13"]="1" ["10 12"]="." ["-3 8"]="1" ["16 18"]="." ["19 -9"]="1" ["-3 -7"]="1" ["-4 -15"]="1" ["-21 -14"]="1" ["-19 -6"]="." ["-18 -10"]="." ["-16 -12"]="." ["-13 5"]="1" ["-5 -1"]="1"
	["-16 -13"]="1" ["9 -12"]="." ["10 13"]="." ["-3 9"]="1" ["16 19"]="1" ["19 -8"]="1" ["-3 -6"]="." ["-4 -14"]="." ["-21 -15"]="1" ["-19 -7"]="1" ["-18 -11"]="1" ["-13 4"]="." ["-8 9"]="." ["-13 7"]="1" ["15 8"]="1" ["9 -11"]="1" ["13 -9"]="1" ["10 10"]="." ["-4 -17"]="." ["-21 -16"]="1" ["-19 -4"]="1" ["-16 -10"]="." ["-18 -12"]="." ["-3 -5"]="1" ["-5 -3"]="1" ["-18 -13"]="1" ["-13 6"]="1" ["-8 8"]="." ["15 9"]="1" ["9 -10"]="." ["13 -8"]="1" ["10 11"]="1" ["-4 -16"]="." ["-21 -17"]="1" ["-19 -5"]="1" ["-16 -11"]="1" ["-3 -4"]="." ["-5 -2"]="." ["3 -2"]="." ["-5 2"]="1" ["6 15"]="1" ["13 13"]="1" ["9 10"]="1" ["8 8"]="." ["-5 19"]="1" ["1 18"]="." ["18 -11"]="." ["14 -15"]="." ["3 -19"]="1" ["-1 -10"]="." ["-5 -14"]="." ["-7 -12"]="." ["-18 -5"]="1" ["-12 -7"]="." ["0 0"]="." ["3 -3"]="1" ["0 1"]="1" ["-5 3"]="1" ["-1 -11"]="1" ["13 12"]="1" ["9 11"]="1" ["8 9"]="." ["-5 18"]="." ["1 19"]="1" ["6 14"]="." ["18 -10"]="." ["14 -14"]="." ["3 -18"]="1" ["-5 -15"]="1" ["-7 -13"]="1" ["-18 -4"]="." ["-12 -6"]="." ["-12 -5"]="1" ["13 11"]="1" ["9 12"]="1" ["6 17"]="." ["14 18"]="." ["18 -13"]="." ["14 -17"]="." ["-5 -16"]="1" ["-1 -12"]="." ["-7 -10"]="." ["-18 -7"]="1" ["-18 8"]="." ["0 2"]="." ["-5 0"]="." ["-5 1"]="1" ["3 -1"]="1" ["-7 -11"]="1" ["13 10"]="1" ["9 13"]="1" ["6 16"]="." ["14 19"]="1" ["18 -12"]="." ["14 -16"]="." ["-5 -17"]="1" ["-1 -13"]="1" ["-18 -6"]="." ["-12 -4"]="." ["-18 9"]="."
	["0 3"]="." ["13 17"]="1" ["12 -8"]="." ["14 -11"]="." ["9 14"]="." ["-9 19"]="1" ["6 11"]="." ["18 -15"]="." ["-7 -16"]="." ["-8 -19"]="." ["-1 -14"]="." ["-5 -10"]="." ["-12 -3"]="." ["-18 -1"]="1" ["-5 6"]="1" ["0 4"]="." ["2 -9"]="." ["3 -6"]="1" ["3 -7"]="1" ["-5 -11"]="1" ["-1 -15"]="1" ["9 15"]="1" ["13 16"]="1" ["12 -9"]="1" ["14 -10"]="." ["-9 18"]="." ["6 10"]="." ["18 -14"]="." ["-7 -17"]="1" ["-8 -18"]="." ["-12 -2"]="." ["-5 7"]="1" ["0 5"]="1" ["2 -8"]="." ["3 -4"]="1" ["-5 -12"]="1" ["-1 -16"]="1" ["13 15"]="1" ["14 -13"]="1" ["0 6"]="." ["6 13"]="." ["9 16"]="." ["18 -17"]="." ["-2 -20"]="." ["-7 -14"]="1" ["-18 -3"]="1" ["-12 -1"]="1" ["-15 9"]="1" ["-5 4"]="." ["3 -5"]="1" ["-5 -13"]="1" ["-1 -17"]="1" ["13 14"]="1" ["14 -12"]="." ["0 7"]="1" ["6 12"]="." ["9 17"]="1" ["18 -16"]="." ["-2 -21"]="1" ["-7 -15"]="1" ["-18 -2"]="." ["-15 8"]="1" ["-5 5"]="1" ["-5 11"]="1" ["-9 15"]="1" ["-1 -18"]="." ["1 10"]="." ["0 8"]="." ["9 18"]="1" ["14 12"]="." ["12 -4"]="." ["18 -19"]="." ["-8 -15"]="1" ["-18 2"]="." ["-15 7"]="1" ["8 0"]="." ["3 -11"]="1" ["2 -5"]="." ["-18 3"]="1" ["-9 14"]="1" ["-1 -19"]="1" ["12 -5"]="1" ["1 11"]="1" ["0 9"]="." ["14 13"]="." ["18 -18"]="." ["-8 -14"]="." ["-15 6"]="." ["-5 10"]="." ["8 1"]="1" ["3 -10"]="." ["2 -4"]="." ["3 -8"]="1" ["-15 5"]="1" ["3 -13"]="1" ["12 -6"]="." ["1 12"]="." ["13 19"]="1" ["14 10"]="." ["-16 -21"]="1"
	["-8 -17"]="1" ["-7 -18"]="." ["-6 -20"]="." ["-18 0"]="." ["-9 17"]="1" ["-5 8"]="1" ["8 2"]="." ["2 -7"]="." ["3 -9"]="1" ["-5 12"]="1" ["3 -12"]="1" ["12 -7"]="1" ["1 13"]="1" ["13 18"]="." ["14 11"]="." ["-6 -21"]="1" ["-16 -20"]="." ["-8 -16"]="." ["-7 -19"]="1" ["-15 4"]="." ["-18 1"]="." ["-9 16"]="." ["-5 9"]="1" ["8 3"]="." ["2 -6"]="." ["2 -1"]="." ["-5 15"]="1" ["-8 -11"]="1" ["-9 11"]="1" ["3 -15"]="1" ["1 14"]="1" ["6 19"]="1" ["14 16"]="." ["14 -19"]="." ["11 -21"]="1" ["-5 -18"]="1" ["-18 -9"]="1" ["-15 3"]="1" ["-18 6"]="." ["8 4"]="." ["-5 14"]="1" ["-9 10"]="1" ["12 -1"]="1" ["14 17"]="1" ["3 -14"]="." ["1 15"]="1" ["6 18"]="." ["14 -18"]="." ["11 -20"]="." ["-5 -19"]="1" ["-8 -10"]="." ["-18 -8"]="." ["-15 2"]="." ["-18 7"]="." ["8 5"]="." ["2 -3"]="1" ["-15 1"]="1" ["-18 4"]="." ["-12 -9"]="1" ["-9 13"]="1" ["1 16"]="." ["14 14"]="." ["12 -2"]="." ["3 -17"]="1" ["-8 -13"]="." ["-5 17"]="1" ["8 6"]="." ["2 -2"]="." ["-18 5"]="1" ["-9 12"]="." ["1 17"]="1" ["14 15"]="." ["12 -3"]="." ["3 -16"]="." ["-8 -12"]="." ["-12 -8"]="." ["-15 0"]="." ["-5 16"]="." ["8 7"]="1" ["-1 -1"]="1" ["0 -7"]="." ["6 -10"]="." ["14 -6"]="." ["9 1"]="1" ["-1 15"]="1" ["-6 18"]="." ["5 14"]="." ["11 19"]="1" ["10 -20"]="." ["-9 -18"]="." ["-6 -17"]="." ["0 -12"]="." ["-2 -13"]="1" ["-15 -15"]="1" ["-21 -9"]="1" ["-19 -11"]="1" ["6 6"]="." ["-7 0"]="1" ["-7 1"]="1" ["0 -6"]="."
	["5 15"]="1" ["6 -11"]="." ["14 -7"]="." ["-6 19"]="1" ["11 18"]="." ["10 -21"]="1" ["-9 -19"]="1" ["-6 -16"]="." ["0 -13"]="." ["-2 -12"]="." ["-15 -14"]="." ["-21 -8"]="1" ["-19 -10"]="1" ["-1 14"]="1" ["6 7"]="1" ["9 0"]="1" ["-19 -13"]="1" ["-7 2"]="." ["6 -12"]="." ["-1 17"]="1" ["5 16"]="." ["8 19"]="1" ["14 -4"]="." ["-2 -11"]="." ["0 -10"]="." ["-6 -15"]="1" ["-15 -17"]="1" ["6 4"]="." ["9 3"]="1" ["0 -5"]="1" ["-1 -3"]="1" ["-7 3"]="1" ["0 -11"]="1" ["14 -5"]="1" ["6 -13"]="1" ["-1 16"]="1" ["5 17"]="1" ["8 18"]="." ["-2 -10"]="." ["-6 -14"]="." ["-15 -16"]="1" ["-19 -12"]="." ["6 5"]="." ["9 2"]="1" ["0 -4"]="." ["-1 -2"]="." ["-19 -15"]="1" ["-7 4"]="1" ["-2 -17"]="1" ["0 -16"]="." ["6 -14"]="." ["-2 9"]="." ["-1 11"]="1" ["5 10"]="1" ["14 -2"]="." ["-6 -8"]="." ["-6 -13"]="." ["-20 -20"]="." ["-15 -11"]="1" ["9 5"]="1" ["6 2"]="." ["0 -3"]="." ["6 3"]="1" ["-7 5"]="1" ["-19 -14"]="1" ["0 -17"]="1" ["6 -15"]="1" ["-2 8"]="." ["-1 10"]="." ["5 11"]="1" ["14 -3"]="1" ["-2 -16"]="." ["-6 -9"]="1" ["-6 -12"]="." ["-20 -21"]="1" ["-15 -10"]="1" ["9 4"]="1" ["0 -2"]="." ["-1 -4"]="1" ["-19 -17"]="1" ["-15 -13"]="1" ["-6 -11"]="1" ["-7 6"]="1" ["-1 -7"]="1" ["14 9"]="1" ["9 7"]="1" ["-3 19"]="1" ["3 18"]="." ["5 12"]="1" ["6 -16"]="." ["-2 -15"]="." ["0 -14"]="." ["-1 13"]="1" ["6 0"]="." ["0 -1"]="1" ["-19 -16"]="1" ["-7 7"]="1" ["-1 -6"]="1" ["0 -15"]="1" ["14 -1"]="1"
	["14 8"]="." ["-3 18"]="." ["3 19"]="1" ["5 13"]="1" ["6 -17"]="." ["-2 -14"]="." ["-6 -10"]="." ["-15 -12"]="." ["-1 12"]="1" ["9 6"]="1" ["6 1"]="1" ["-19 -19"]="1" ["-7 8"]="1" ["-6 -4"]="." ["14 7"]="." ["11 11"]="1" ["8 13"]="." ["9 9"]="1" ["-3 17"]="1" ["3 16"]="1" ["6 -18"]="." ["-14 -21"]="1" ["-1 -9"]="1" ["-9 -10"]="." ["-21 -1"]="1" ["-6 10"]="." ["-2 5"]="1" ["-19 -18"]="1" ["-9 -11"]="1" ["-6 11"]="1" ["-7 9"]="1" ["-6 -5"]="." ["14 6"]="." ["11 10"]="1" ["8 12"]="." ["9 8"]="1" ["3 17"]="1" ["6 -19"]="." ["-14 -20"]="." ["-1 -8"]="." ["-3 16"]="1" ["-2 4"]="." ["-9 -12"]="1" ["-6 12"]="." ["-2 -19"]="1" ["11 13"]="1" ["14 5"]="1" ["8 11"]="." ["-2 7"]="." ["3 14"]="1" ["0 -18"]="." ["-6 -6"]="." ["-21 -3"]="1" ["-3 15"]="1" ["-9 -13"]="1" ["-6 13"]="1" ["-2 -18"]="." ["11 12"]="." ["8 10"]="." ["-2 6"]="." ["3 15"]="1" ["14 4"]="." ["0 -19"]="." ["-6 -7"]="." ["-21 -2"]="1" ["-3 14"]="." ["-2 1"]="1" ["-3 13"]="1" ["11 15"]="1" ["-1 19"]="1" ["3 12"]="." ["5 18"]="1" ["8 17"]="." ["14 3"]="." ["-10 -21"]="1" ["-15 -19"]="1" ["-9 -14"]="." ["-21 -5"]="1" ["-6 14"]="." ["11 14"]="1" ["-1 18"]="." ["3 13"]="1" ["8 16"]="." ["14 2"]="." ["-10 -20"]="." ["-9 -15"]="1" ["-15 -18"]="1" ["-21 -4"]="1" ["-6 15"]="." ["-3 12"]="." ["-6 -1"]="." ["-2 0"]="." ["11 17"]="1" ["8 15"]="1" ["14 -8"]="." ["3 10"]="." ["6 8"]="." ["14 1"]="1" ["-6 -19"]="1" ["0 -9"]="."
	["-9 -16"]="1" ["-6 16"]="." ["-3 11"]="1" ["-2 3"]="." ["-6 -2"]="." ["11 16"]="1" ["14 -9"]="." ["8 14"]="." ["3 11"]="1" ["6 9"]="." ["14 0"]="." ["13 -20"]="1" ["-9 -17"]="1" ["-6 -18"]="." ["0 -8"]="." ["-21 -6"]="1" ["-6 17"]="1" ["-3 10"]="1" ["-2 2"]="." ["-6 -3"]="1" ["7 -15"]="1" ["-19 16"]="." ["0 13"]="." ["18 3"]="." ["-4 -20"]="." ["-14 6"]="." ["-2 14"]="." ["7 -14"]="1" ["-19 17"]="1" ["0 12"]="." ["18 2"]="." ["16 -1"]="." ["-4 -21"]="1" ["-14 7"]="." ["-2 15"]="1" ["7 -17"]="1" ["17 -9"]="1" ["0 11"]="1" ["-2 16"]="." ["7 18"]="." ["18 1"]="." ["16 -2"]="." ["18 -8"]="." ["8 -18"]="." ["-14 4"]="." ["-19 14"]="." ["-4 9"]="1" ["-14 5"]="1" ["8 -19"]="1" ["7 -16"]="1" ["17 -8"]="1" ["-4 8"]="." ["-2 17"]="." ["0 10"]="." ["7 19"]="1" ["18 0"]="." ["16 -3"]="1" ["18 -9"]="." ["-19 15"]="1" ["-19 12"]="1" ["16 9"]="1" ["7 -11"]="1" ["-2 10"]="." ["0 17"]="1" ["18 7"]="." ["16 -4"]="." ["19 -18"]="1" ["-14 2"]="." ["1 -8"]="1" ["-19 13"]="1" ["16 -5"]="1" ["7 -10"]="." ["0 16"]="." ["18 6"]="." ["16 8"]="." ["19 -19"]="1" ["-14 3"]="1" ["-2 11"]="1" ["1 -9"]="1" ["-19 10"]="1" ["16 -6"]="." ["7 -13"]="1" ["-4 18"]="." ["0 15"]="." ["17 19"]="1" ["18 5"]="." ["17 -18"]="1" ["-14 0"]="." ["-2 12"]="." ["-19 11"]="1" ["16 -7"]="." ["7 -12"]="." ["-4 19"]="1" ["0 14"]="." ["17 18"]="." ["18 4"]="." ["17 -19"]="1" ["-14 1"]="." ["-2 13"]="." ["7 12"]="1"
	["16 -8"]="." ["8 -12"]="." ["17 17"]="1" ["18 -2"]="." ["16 5"]="." ["17 -3"]="1" ["19 -14"]="1" ["17 -16"]="1" ["-4 16"]="." ["-4 3"]="." ["1 -4"]="." ["7 13"]="1" ["16 -9"]="." ["8 -13"]="1" ["17 16"]="1" ["16 4"]="." ["17 -2"]="1" ["18 -3"]="1" ["19 -15"]="1" ["17 -17"]="1" ["-4 17"]="1" ["-4 2"]="." ["1 -5"]="1" ["-4 1"]="1" ["7 10"]="1" ["8 -10"]="." ["0 19"]="1" ["17 15"]="1" ["18 9"]="." ["16 7"]="." ["17 -1"]="1" ["19 -16"]="1" ["17 -14"]="1" ["-4 14"]="." ["1 -6"]="1" ["7 11"]="1" ["8 -11"]="1" ["0 18"]="." ["17 14"]="1" ["18 -1"]="." ["18 8"]="." ["16 6"]="." ["19 -17"]="1" ["17 -15"]="1" ["-4 15"]="." ["1 -7"]="1" ["-4 0"]="." ["7 -19"]="1" ["7 16"]="1" ["17 -7"]="1" ["-4 7"]="." ["-2 18"]="." ["17 13"]="1" ["16 1"]="1" ["18 -6"]="." ["19 -10"]="1" ["17 -12"]="." ["8 -16"]="." ["2 -21"]="1" ["-4 12"]="." ["1 -1"]="1" ["-4 13"]="1" ["7 -18"]="1" ["7 17"]="1" ["17 -6"]="1" ["-4 6"]="." ["-2 19"]="1" ["17 12"]="." ["16 0"]="." ["18 -7"]="." ["19 -11"]="1" ["17 -13"]="1" ["8 -17"]="." ["2 -20"]="." ["1 -2"]="1" ["17 -5"]="1" ["7 14"]="1" ["17 -10"]="1" ["-19 18"]="1" ["17 11"]="1" ["16 3"]="." ["18 -4"]="." ["19 -12"]="1" ["8 -14"]="." ["-7 -21"]="1" ["-14 8"]="." ["-4 10"]="." ["-4 5"]="1" ["1 -3"]="1" ["17 10"]="." ["16 2"]="." ["17 -4"]="." ["18 -5"]="." ["19 -13"]="1" ["17 -11"]="1" ["8 -15"]="." ["-7 -20"]="." ["-14 9"]="." ["-4 11"]="." ["-4 4"]="."
	["-12 13"]="1" ["11 -14"]="1" ["2 19"]="1" ["18 16"]="." ["3 -20"]="." ["-11 -19"]="1" ["-9 -9"]="1" ["-16 4"]="." ["-6 9"]="." ["7 -6"]="." ["-4 -2"]="." ["-2 -1"]="1" ["-16 5"]="1" ["-12 12"]="." ["11 -15"]="1" ["2 18"]="." ["18 17"]="." ["3 -21"]="1" ["-11 -18"]="." ["-9 -8"]="1" ["-21 -20"]="1" ["-6 8"]="." ["7 -7"]="1" ["-4 -3"]="." ["-12 11"]="1" ["10 9"]="." ["-15 18"]="." ["18 14"]="." ["11 -16"]="." ["-16 -9"]="." ["-16 6"]="." ["7 -4"]="." ["-2 -2"]="." ["-4 -1"]="1" ["7 -5"]="1" ["-12 10"]="." ["10 8"]="." ["-15 19"]="1" ["18 15"]="." ["11 -17"]="1" ["-16 -8"]="." ["-16 7"]="1" ["-2 -3"]="." ["11 -10"]="." ["18 12"]="." ["-8 -20"]="." ["-4 -6"]="." ["-10 -9"]="." ["-18 -21"]="1" ["-16 0"]="." ["-12 17"]="1" ["7 -2"]="." ["-2 -4"]="." ["-16 1"]="1" ["11 -11"]="1" ["18 13"]="." ["-8 -21"]="1" ["-4 -7"]="1" ["-10 -8"]="." ["-18 -20"]="." ["-12 16"]="." ["7 -3"]="1" ["-2 -5"]="1" ["-3 -18"]="1" ["7 9"]="1" ["11 -12"]="1" ["8 -9"]="." ["18 10"]="." ["16 -20"]="." ["8 -21"]="1" ["-2 -6"]="." ["-16 2"]="." ["-12 15"]="." ["-4 -4"]="." ["7 -1"]="1" ["-3 -19"]="1" ["8 -8"]="." ["7 8"]="." ["18 11"]="1" ["16 -21"]="1" ["8 -20"]="." ["-2 -7"]="." ["-16 3"]="." ["-12 14"]="." ["-4 -5"]="1" ["-11 -11"]="1" ["-10 -5"]="1" ["-9 -1"]="1" ["-6 1"]="1" ["10 3"]="." ["2 11"]="1" ["-3 -16"]="." ["-2 -8"]="." ["-16 -3"]="." ["-15 12"]="." ["7 7"]="1" ["8 -7"]="1" ["-15 13"]="1" ["-11 -10"]="." ["-10 -4"]="."
  ["-3 -17"]="1" ["10 2"]="." ["2 10"]="." ["-2 -9"]="1" ["-16 -2"]="." ["7 6"]="." ["8 -6"]="." ["-6 0"]="." ["7 5"]="1" ["-11 -13"]="1" ["-9 -3"]="1" ["-6 3"]="1" ["10 1"]="." ["-12 19"]="1" ["2 13"]="1" ["12 -20"]="." ["-4 -8"]="." ["-10 -7"]="." ["-3 -14"]="1" ["-16 -1"]="1" ["-15 10"]="1" ["8 -5"]="." ["7 4"]="1" ["-11 -12"]="." ["-9 -2"]="1" ["-6 2"]="." ["10 0"]="." ["-12 18"]="." ["2 12"]="." ["17 -20"]="1" ["12 -21"]="1" ["-3 -15"]="1" ["-10 -6"]="." ["-4 -9"]="1" ["-15 11"]="1" ["8 -4"]="." ["7 3"]="1" ["-11 -15"]="1" ["-9 -5"]="1" ["10 7"]="." ["2 15"]="." ["11 -18"]="." ["-3 -12"]="1" ["-16 -7"]="." ["-10 -1"]="." ["-16 8"]="." ["-15 16"]="." ["-6 5"]="." ["8 -3"]="1" ["-11 -14"]="1" ["-9 -4"]="." ["11 -19"]="1" ["10 6"]="." ["2 14"]="." ["-3 -13"]="1" ["-16 -6"]="." ["-16 9"]="." ["-15 17"]="1" ["-6 4"]="." ["7 2"]="." ["8 -2"]="." ["-15 14"]="1" ["-10 -3"]="1" ["10 5"]="." ["2 17"]="." ["18 18"]="." ["0 -21"]="1" ["-9 -7"]="1" ["-3 -10"]="1" ["-11 -17"]="1" ["-16 -5"]="1" ["-6 7"]="." ["7 1"]="1" ["8 -1"]="." ["7 -8"]="1" ["-15 15"]="1" ["7 -9"]="1" ["10 4"]="." ["2 16"]="." ["18 19"]="1" ["0 -20"]="." ["-9 -6"]="." ["-3 -11"]="1" ["-11 -16"]="." ["-16 -4"]="." ["-10 -2"]="." ["-6 6"]="." ["7 0"]="." ["-12 -12"]="." ["-7 -7"]="1" ["-10 2"]="." ["15 -1"]="1" ["12 9"]="." ["-10 19"]="1" ["17 4"]="1" ["16 -13"]="." ["12 -17"]="1" ["-10 -14"]="." ["-14 -10"]="." ["5 -1"]="1"
 ["-12 -13"]="." ["-7 -6"]="1" ["-10 3"]="." ["12 8"]="." ["-10 18"]="." ["17 5"]="1" ["16 -12"]="." ["12 -16"]="." ["-10 -15"]="." ["-14 -11"]="." ["5 -2"]="1" ["-12 -10"]="." ["-7 -5"]="1" ["16 -11"]="1" ["17 6"]="1" ["15 -3"]="1" ["12 -15"]="." ["-10 -16"]="." ["-14 -12"]="." ["-10 0"]="." ["4 -9"]="." ["5 -3"]="1" ["-14 -13"]="1" ["-12 -11"]="." ["-10 1"]="1" ["-7 -4"]="." ["16 -10"]="." ["17 7"]="1" ["15 -2"]="." ["12 -14"]="." ["-10 -17"]="1" ["4 -8"]="." ["5 -4"]="1" ["-10 6"]="." ["-7 -3"]="1" ["15 -5"]="1" ["12 -13"]="1" ["5 9"]="1" ["17 0"]="1" ["16 -17"]="." ["-10 -10"]="." ["-12 -16"]="." ["-14 -14"]="." ["5 -5"]="1" ["-10 -11"]="1" ["-10 7"]="1" ["12 -12"]="." ["5 8"]="." ["17 1"]="1" ["15 -4"]="." ["16 -16"]="." ["-12 -17"]="1" ["-14 -15"]="." ["-7 -2"]="1" ["5 -6"]="1" ["-10 -12"]="." ["-12 -14"]="." ["-10 4"]="." ["12 -11"]="." ["15 -7"]="1" ["4 19"]="1" ["17 2"]="1" ["16 -15"]="." ["4 -18"]="." ["-14 -16"]="." ["-17 -20"]="1" ["-20 -8"]="." ["-21 8"]="1" ["-7 -1"]="1" ["-10 -13"]="1" ["-12 -15"]="1" ["-10 5"]="." ["15 -6"]="1" ["12 -10"]="." ["4 18"]="." ["17 3"]="1" ["16 -14"]="." ["4 -19"]="." ["-14 -17"]="1" ["-20 -9"]="." ["-21 9"]="1" ["5 -7"]="1" ["4 -3"]="." ["-10 11"]="." ["15 -9"]="1" ["4 17"]="1" ["12 1"]="." ["18 -20"]="." ["15 -21"]="1" ["4 -16"]="." ["-14 -18"]="." ["-20 -6"]="." ["-21 6"]="1" ["5 5"]="1" ["5 -8"]="." ["4 -2"]="." ["-10 10"]="." ["15 -8"]="1" ["4 16"]="." ["12 0"]="."
	["18 -21"]="1" ["15 -20"]="." ["4 -17"]="1" ["-14 -19"]="." ["-20 -7"]="1" ["-21 7"]="1" ["5 4"]="." ["5 -9"]="1" ["4 -1"]="1" ["-10 13"]="." ["-10 8"]="." ["4 -14"]="." ["5 7"]="1" ["4 15"]="." ["12 3"]="." ["16 -19"]="." ["-3 -21"]="1" ["-13 -20"]="." ["-12 -18"]="." ["-20 -4"]="." ["-21 4"]="1" ["-10 12"]="." ["-10 9"]="1" ["4 -15"]="1" ["4 14"]="." ["12 2"]="." ["16 -18"]="." ["-3 -20"]="." ["-13 -21"]="1" ["-12 -19"]="." ["-20 -5"]="." ["-21 5"]="1" ["5 6"]="1" ["4 -7"]="1" ["-10 15"]="1" ["12 5"]="1" ["4 -12"]="." ["4 13"]="1" ["17 8"]="." ["14 -20"]="." ["-10 -18"]="." ["-20 -2"]="." ["-21 2"]="1" ["5 1"]="1" ["4 -6"]="." ["-10 14"]="." ["17 9"]="1" ["4 -13"]="." ["4 12"]="." ["12 4"]="." ["14 -21"]="1" ["-10 -19"]="1" ["-20 -3"]="." ["-21 3"]="1" ["5 0"]="." ["5 3"]="1" ["4 -5"]="." ["12 7"]="1" ["4 11"]="." ["12 -19"]="." ["-7 -9"]="1" ["-21 0"]="1" ["-10 17"]="1" ["4 -10"]="." ["4 -4"]="." ["12 6"]="." ["4 10"]="." ["12 -18"]="." ["-7 -8"]="." ["-20 -1"]="." ["-10 16"]="." ["5 2"]="." ["4 -11"]="1" ["-19 3"]="1" ["-17 -13"]="1" ["11 2"]="1" ["2 -14"]="." ["-13 18"]="." ["-13 -17"]="1" ["-12 0"]="." ["-14 -1"]="1" ["-20 7"]="." ["-20 12"]="." ["-14 15"]="." ["9 -4"]="1" ["11 3"]="1" ["2 -15"]="1" ["-13 19"]="1" ["-9 -20"]="1" ["-13 -16"]="." ["-17 -12"]="." ["-12 1"]="." ["-19 2"]="." ["-20 6"]="." ["-20 13"]="." ["-14 14"]="." ["9 -5"]="1" ["-13 -15"]="1" ["11 0"]="1" ["3 9"]="1"
	["19 8"]="1" ["9 -20"]="." ["2 -16"]="." ["-17 -11"]="1" ["-14 -3"]="1" ["-12 2"]="." ["-19 1"]="1" ["-20 5"]="." ["-20 10"]="." ["-14 17"]="1" ["9 -6"]="1" ["-13 -14"]="1" ["11 1"]="1" ["9 -7"]="1" ["3 8"]="1" ["19 9"]="1" ["9 -21"]="1" ["2 -17"]="." ["-14 -2"]="." ["-17 -10"]="." ["-12 3"]="." ["-19 0"]="1" ["-20 4"]="." ["-20 11"]="." ["-14 16"]="." ["-19 7"]="1" ["-17 -17"]="1" ["-13 -13"]="1" ["11 6"]="." ["-20 16"]="." ["-13 -8"]="." ["-14 -5"]="." ["-12 4"]="." ["-20 3"]="." ["-17 9"]="1" ["-14 11"]="." ["2 -10"]="." ["-19 6"]="1" ["-13 -9"]="1" ["-17 -16"]="1" ["-13 -12"]="1" ["-12 5"]="1" ["11 7"]="1" ["-20 17"]="." ["-14 -4"]="." ["-20 2"]="." ["-17 8"]="1" ["-14 10"]="." ["9 -1"]="1" ["2 -11"]="1" ["-14 13"]="1" ["-19 5"]="1" ["-17 -15"]="1" ["-13 -11"]="1" ["-12 6"]="." ["11 4"]="1" ["2 -12"]="." ["-16 19"]="1" ["5 -20"]="." ["-14 -7"]="1" ["-20 1"]="1" ["-20 14"]="." ["9 -2"]="1" ["-19 4"]="1" ["-17 -14"]="." ["-13 -10"]="1" ["-12 7"]="." ["2 -13"]="." ["9 -3"]="1" ["11 5"]="1" ["-16 18"]="." ["5 -21"]="1" ["-20 0"]="." ["-14 -6"]="." ["-20 15"]="1" ["-14 12"]="." ["3 3"]="1" ["-17 5"]="1" ["-13 10"]="1" ["-12 8"]="." ["19 2"]="1" ["-1 -21"]="1" ["-19 -20"]="." ["-14 -9"]="." ["-13 -4"]="." ["-16 17"]="1" ["3 2"]="1" ["-13 11"]="1" ["-17 4"]="." ["-13 -5"]="1" ["-12 9"]="." ["19 3"]="1" ["-1 -20"]="." ["-19 -21"]="1" ["-14 -8"]="." ["-16 16"]="." ["-19 9"]="1" ["-13 12"]="1" ["11 8"]="1" ["-20 18"]="."
	["19 0"]="1" ["4 -21"]="1" ["1 -20"]="1" ["-17 -19"]="1" ["-13 -6"]="." ["-17 7"]="1" ["-16 15"]="." ["3 1"]="1" ["3 0"]="1" ["-13 13"]="1" ["-19 8"]="1" ["11 9"]="1" ["-20 19"]="1" ["19 1"]="1" ["4 -20"]="." ["-17 -18"]="." ["-13 -7"]="1" ["-17 6"]="." ["-16 14"]="." ["-17 1"]="1" ["9 -8"]="." ["-14 19"]="1" ["3 7"]="1" ["19 6"]="1" ["2 -18"]="." ["-5 -21"]="1" ["-15 -20"]="." ["-16 13"]="." ["-13 14"]="." ["9 -9"]="1" ["-14 18"]="." ["3 6"]="." ["19 7"]="1" ["2 -19"]="1" ["-15 -21"]="1" ["-5 -20"]="." ["-17 0"]="." ["-16 12"]="." ["-13 15"]="1" ["-17 3"]="1" ["19 4"]="1" ["-13 -19"]="1" ["-13 -2"]="1" ["-20 9"]="." ["-16 11"]="1" ["-13 16"]="1" ["3 5"]="1" ["-17 2"]="1" ["-13 17"]="1" ["19 5"]="1" ["-13 -18"]="1" ["-13 -3"]="1" ["-20 8"]="." ["-16 10"]="." ["3 4"]="." )

MAP["-18 -16"]=O
declare -A SPREAD_POINTS=(["-18 -16"]=1)
STEPS=0
while [[ ${#SPREAD_POINTS[@]} -gt 0 ]]; do
	SPREADING=0
	for POINT in "${!SPREAD_POINTS[@]}"; do
		POINT_COORD=($POINT)
		X=${POINT_COORD[0]}
		Y=${POINT_COORD[1]}
		ADJACENTS=("$X $((Y-1))" "$X $((Y+1))" "$((X-1)) $Y" "$((X+1)) $Y")
		for ADJ in "${ADJACENTS[@]}"; do
			if [[ ${MAP[$ADJ]} == . ]]; then
				SPREADING=1
				MAP[$ADJ]=O
				SPREAD_POINTS[$ADJ]=1
				echo ${ADJ% *}
				echo ${ADJ#* }
				echo 4
			fi
		done
		unset "SPREAD_POINTS[$POINT]"
	done
	STEPS=$((STEPS+SPREADING))
done
echo -1
echo 0
echo $STEPS
