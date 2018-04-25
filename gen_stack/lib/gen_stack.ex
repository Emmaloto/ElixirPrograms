defmodule GenStack do
  @moduledoc """
  Documentation for Stack API implemented with a GenServer.
  """
  
  use GenServer

  ### GenServer API

  @doc """
  GenServer.init/1 callback
  Initalize the state of the GenServer
  """
  @spec init(tuple()):: tuple()
  def init(state), do: {:ok, state}

  
  @doc """
  GenServer.handle_cast/2 callback
  Handles any synchronous requests to the GenServer.
  """
  @spec handle_cast(tuple(), list()):: tuple()
  def handle_cast({:push, value}, state) do
    {:noreply, [value] ++ state }
  end
  
  
  @doc """
  GenServer.handle_call/3 callback
  Handles any asynchronous requests to the GenServer for pop, peek, is_empty, stack operations.
  """
  @spec handle_call(atom(), any(), list()):: tuple()
  def handle_call(:pop, _from, [value | new_state]) do
    {:reply, value, new_state}
  end
  def handle_call(:pop, _from, []), do: {:reply, nil, []}

  
  def handle_call(:is_empty, _from, state) do 
    val = if state == [] do
      :true
    else
      :false
    end
    
    {:reply, val, state}
  end
  
  def handle_call(:peek, _from, [value | state]), do: {:reply, value, [value | state]}
  def handle_call(:peek, _from, []), do: {:reply, nil, []}
  
  def handle_call(:stack, _from, state), do: {:reply, state, state}
  
  
  
  ### Client API / Helper functions

  def start_link(state \\ []) do
    GenServer.start_link(__MODULE__, state, name: __MODULE__)
  end

  
  @doc """
  This calls the cast/call commands to the GenServer to carry out the 
  pop, peek, is_empty, stack operations.
  """
  def push(val),do: GenServer.cast(__MODULE__, {:push, val})
  def pop,      do: GenServer.call(__MODULE__, :pop)
  def is_empty, do: GenServer.call(__MODULE__, :is_empty)
  def peek,     do: GenServer.call(__MODULE__, :peek)
  def stack,    do: GenServer.call(__MODULE__, :stack)
  
end
