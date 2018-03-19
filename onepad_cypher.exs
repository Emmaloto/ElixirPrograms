##  EMMANUEL OLULOTO
##  CS326
##  
##  3/3/2018





defmodule Encrypt do
@moduledoc """
This module encrypts a string using a one-time cipher.
"""
  
  @doc """
  Encrypts a string by converting it into integer representation according to the alphabet.
  It also encrypts spaces as well as other special characters. It encrypts messages in uppercase
  by converting the string to lowercase first.
  
    It also prints out the random integer list used to encrypt the string.
  
  """
  @spec cipher(String.t)::String.t  
  def cipher(stringVal) do
    
    message = String.downcase(stringVal)
    
    # Converts string into integer list by turning it into a charlist
    numList = Enum.map(String.codepoints(message), fn(<<char::utf8>>) -> char - 96 end)  
    
    # Creates a tupleList containing integer representation and random number
    pad = onepad(Enum.count(numList))
    tupleList = Enum.zip( numList,  pad) 
    
    # Adds integer representation and random number (making sure it is less than 26)
    encryptList = Enum.map(tupleList, fn({position, randNo}) -> rem(position + randNo, 26) end)
    
    IO.puts "Here is the list of random numbers used to encrypt:"
    IO.inspect pad
    
    # Concatenates new integer representations into a string
    Enum.reduce(encryptList, "", fn(charbit, acc) -> List.to_string( acc <> [charbit + 97])  end)
    
  end
  

  
  @doc """
  Returns a list of random integers of specific size 
  """
  @spec onepad(number)::list(number)  
  def onepad(num) do
    
    random_int_bound(num, 26)
    
  end  
  
  
  
  @doc """
  Generates a list of random integers ranging from 1 to limit
  """
  @spec random_int_bound(integer, integer) :: list(number)
  def random_int_bound(number, limit) do

    if number != 0 do
      [:rand.uniform(limit) ] ++ random_int_bound(number - 1, limit)
    else
      []    
    end  
    
  end
  
end


# Lists of random integers of a particular size
Encrypt.onepad(5)
Encrypt.onepad(7)

# Should generate a new string where all characters have been replaced by random characters
Encrypt.cipher("abc")
Encrypt.cipher("abc xyz")
Encrypt.cipher("The aliens are invading! Run!")
Encrypt.cipher("1, 2, three, four...")


