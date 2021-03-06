--классы типов
--специальный полиморфизм
module Demo2_3 where
  
import Prelude hiding (Eq, (==), (/=))
  
-- 7 :: Num a => a
-- => : справа тип выражения
-- => : слева - контекст. Контекст состоит из 2 частей: имени интерфейса (Num) и этот интерфейс применен к соотв. типу (a)

-- (>) :: Ord a => a -> a -> Bool
-- (> 7) :: (Ord a, Num a) => a -> Bool   на типа наложены 2 ограничения: Ord (из-за >) и Num (из-за 7)
-- (> (1,2)) :: (Ord t1, Ord t, Num t1, Num t) => (t, t1) -> Bool

----------

class MyEq a where
  -- только интерфейс, без реализации
  -- сигнатуры ф-ций должны начинаться с ненулевого отступа
  (==) :: a -> a -> Bool
  (/=) :: a -> a -> Bool
  
-- Eq - стандартный класс
-- (==) :: Eq a => a -> a -> Bool
-- (== 42) :: (Num a, Eq a) => a -> Bool   -- числовое значение полиморфно => сохраняется контекст Eq a и добавляется контекст Num a
-- (== 'a') :: Char -> Bool   -- полностью убрали полиморфизм  => контекст Eq пропадает

----------
-- представители (экземпляры) класса типов

--class MyEq a where
--  (==), (/=) :: a -> a -> Bool

-- сделать конкретный тип представителем класса типов Eq:
instance MyEq Bool where
  -- отступы обязательны
  True == True = True
  False == False = True
  -- _  означает образец который всегда подходит и ничего не связывает
  _ == _ = False  
  x /= y = not (x == y)



-- методы по умолчанию
-- например реализация неравенства через равенство - полиморфна
-- можно указать реализацию по умолчанию внутри объявления класса типов
--class Eq a where
--  (==), (/=) :: a -> a -> Bool
--  x /= y = not (x == y)

--instance Eq Bool where
--  True == True = True
--  False == False = True
--  _ == _ = False  



--можно сделать циклические реализации по умолчанию
--class Eq a where
--  (==), (/=) :: a -> a -> Bool
--  x /= y = not (x == y)
--  x == y = not (x /= y)

-- ==> можем создавать представителей класса Eq реализуя либо равенство, либо неравенство

----------

--Реализуйте класс типов Printable, предоставляющий один метод toString — функцию одной переменной, 
--которая преобразует значение типа, являющегося представителем Printable, в строковое представление.
--Сделайте типы данных Bool и () представителями этого класса типов, обеспечив следующее поведение:
--GHCi> toString True
--"true"
--GHCi> toString False
--"false"
--GHCi> toString ()
--"unit type"

class Printable p where
  toString :: p -> String
  
instance Printable Bool where
  toString True = "true"
  toString False = "false"
  
instance Printable () where
  toString _ = "unit type"
  
----------

--реализация представителя типа MyEq для пары
--в объявлении предствителя появляется контекст, т.е. мы говорим:
--тип пары объявляем представителем класса типов Eq, но это можно сделать только тогда, когда на типы a и b наложены ограничения (в виде контекста)
instance (MyEq a, MyEq b) => MyEq (a, b) where
  p1 == p2 = (fst p1 == fst p2) && (snd p1 == snd p2)
  x /= y = not (x == y)
  
--Функциональные типы не являются предствителями Eq
--id == (\x -> x)  ==> ошибка

----------
--Сделайте тип пары представителем класса типов Printable, реализованного вами в предыдущей задаче, обеспечив следующее поведение:
--GHCi> toString (False,())
--"(false,unit type)"
--GHCi> toString (True,False)
--"(true,false)"
--Примечание. Объявление класса типов Printable и представителей этого класса для типов () и  Bool заново реализовывать не надо — они присутствуют в программе, вызывающей ваш код.

instance (Printable a, Printable b) => Printable (a, b) where
  toString pair = "(" ++ toString (fst pair) ++ "," ++ toString (snd pair) ++ ")"
