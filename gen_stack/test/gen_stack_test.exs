defmodule GenStackTest do
  use ExUnit.Case
  doctest GenStack


  GenStack.start_link([1,2,3])
  
  setup do
    {:ok, pid} = GenStack.start_link([1,2,3])
    {:ok, process: pid}
  end
  
  
  
  
  test "Push onto Stack" do

    assert GenStack.push(0)  == :ok
    assert GenStack.push(52) == :ok
    assert GenStack.stack   == [52, 0, 1, 2, 3]
    assert GenStack.push("I'm the top") == :ok
    assert GenStack.stack   == ["I'm the top", 52, 0, 1, 2, 3]
    
  end
  
  test "Pop off Stack" do
    assert GenStack.stack  == [1, 2, 3]
    assert GenStack.pop  == 1
    assert GenStack.pop  == 2
    assert GenStack.pop  == 3
    assert GenStack.stack  == []
    assert GenStack.pop == nil
  end
  
  test "Check if Stack is Empty" do
    assert GenStack.is_empty == :false
    
    assert GenStack.pop  == 1
    assert GenStack.pop  == 2
    assert GenStack.pop  == 3
    assert GenStack.stack == []
    assert GenStack.is_empty == :true   
     
    assert GenStack.push("All alone") == :ok
    assert GenStack.is_empty == :false
    
    assert GenStack.pop  == "All alone"
    assert GenStack.is_empty == :true
    
  end  
  
  
  test "Peek at Topmost element in Stack" do
    assert GenStack.peek == 1
    assert GenStack.pop  == 1  
    assert GenStack.push("I'm the captain now") == :ok   
    assert GenStack.peek  == "I'm the captain now"
    assert GenStack.stack == ["I'm the captain now", 2, 3]
    
    assert GenStack.pop   == "I'm the captain now"
    assert GenStack.pop  == 2
    assert GenStack.pop  == 3
    assert GenStack.peek == nil
    assert GenStack.stack == []

    
  end   
  
  
  
end
