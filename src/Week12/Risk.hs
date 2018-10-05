{-# LANGUAGE GeneralizedNewtypeDeriving #-}

module Week12.Risk where

import Control.Monad.Random
import Control.Arrow ((&&&))
import Data.List (reverse, sort)

------------------------------------------------------------
-- Die values
newtype DieValue = DV
  { unDV :: Int
  } deriving (Eq, Ord, Show, Num)

first :: (a -> b) -> (a, c) -> (b, c)
first f (a, c) = (f a, c)

instance Random DieValue where
  random = first DV . randomR (1, 6)
  randomR (low, hi) = first DV . randomR (max 1 (unDV low), min 6 (unDV hi))

die :: Rand StdGen DieValue
die = getRandom

------------------------------------------------------------
-- Risk
type Army = Int

data Battlefield = Battlefield
  { attackers :: Army
  , defenders :: Army
  } deriving (Show, Eq)

------------------------------------------------------------
-- Exercise 1
-- This is just installing the monad random module, you don't
-- have to worry about this due to the magic of nix

------------------------------------------------------------
-- Exercise 2

battle :: Battlefield -> Rand StdGen Battlefield
battle (Battlefield a d) =
  let 
    calculateOutcome (attackerRoll, defenderRoll) (attackerDeaths, defenderDeaths) =
      if attackerRoll < defenderRoll 
        then (attackerDeaths + 1, defenderDeaths) 
        else (attackerDeaths, defenderDeaths + 1)
  in
    do 
      attackerRolls <- replicateM (min 3 (max 0 (a - 1))) die
      defenderRolls <- replicateM (min 2 d) die
      let rolls = zip (sort attackerRolls) (sort defenderRolls)
      let (attackerDeaths, defenderDeaths) = foldr calculateOutcome (0, 0) rolls
      return (Battlefield (a - attackerDeaths) (d - defenderDeaths))


------------------------------------------------------------
-- Exercise 3

invade :: Battlefield -> Rand StdGen Battlefield
invade = error "Week12.Risk#invade not implemented"

------------------------------------------------------------
-- Exercise 4

successProb :: Battlefield -> Rand StdGen Double
successProb = error "Week12.Risk#successProb not implemented"

------------------------------------------------------------
-- Exercise 5

-- Anyone know probability theory :p

exactSuccessProb :: Battlefield -> Double
exactSuccessProb = error "Week12.Risk#exactSuccessProb not implemented"
