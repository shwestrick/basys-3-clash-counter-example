{-# OPTIONS_GHC -Wno-orphans #-}

module TopModule where

import Clash.Prelude

type State = (Unsigned 32, Unsigned 32, Unsigned 32, Unsigned 2)


get_digit :: Unsigned 32 -> Unsigned 2 -> Unsigned 32
get_digit n i =
  case i of
    0 -> n `mod` 10
    1 -> (n `div` 10) `mod` 10
    2 -> (n `div` 100) `mod` 10
    _ -> (n `div` 1000) `mod` 10


-- inspired by and adapted from
-- https://www.fpga4student.com/2017/09/seven-segment-led-display-controller-basys3-fpga.html

step :: State -> Bool -> (State, (BitVector 4, BitVector 7))
step (clock_ticks, elapsed, refresh_ticks, target_digit) _ =
  let
    -- output = elapsed `mod` 2 == 0
    (clock_ticks', elapsed') =
      if clock_ticks == 99999999 then
        (0, elapsed+1)
      else
        (clock_ticks+1, elapsed)

    (refresh_ticks', target_digit') =
      if refresh_ticks == 199999 then
        (0, target_digit+1)
      else
        (refresh_ticks+1, target_digit)

    anode :: BitVector 4
    anode =
      case target_digit of
        0 -> 0b1110
        1 -> 0b1101
        2 -> 0b1011
        _ -> 0b0111

    cathode :: BitVector 7
    cathode =
      case get_digit elapsed target_digit of
        0 -> 0b1000000
        1 -> 0b1111001
        2 -> 0b0100100
        3 -> 0b0110000
        4 -> 0b0011001
        5 -> 0b0010010
        6 -> 0b0000010
        7 -> 0b1111000
        8 -> 0b0000000
        _ -> 0b0010000

    output = (anode, cathode)

    new_state = (clock_ticks', elapsed', refresh_ticks', target_digit')
  in
    (new_state, output)





createDomain vXilinxSystem{vName="DomSys", vPeriod=hzToPeriod 100e6}

top_module ::
  HiddenClockResetEnable dom =>
  Signal dom (BitVector 4, BitVector 7)

top_module =
  mealy step (0, 0, 0, 0) (riseEvery d1)


topEntity ::
  Clock DomSys ->
  Reset DomSys ->
  Enable DomSys ->
  (Signal DomSys (BitVector 4), Signal DomSys (BitVector 7))
topEntity = exposeClockResetEnable (unbundle top_module)

{-# ANN topEntity
  (Synthesize
    { t_name = "main"
    , t_inputs = [ PortName "clk"
                 , PortName "btnC"
                 , PortName "sw"
                 ]
    , t_output = PortProduct ""
                  [ PortName "an"
                  , PortName "seg"
                  ]
    }) #-}

{-# OPAQUE topEntity #-}
