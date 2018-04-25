##  EMMANUEL OLULOTO
##  CS326
##  HW 5
##  
##  4/15/2018




defmodule Ant_March do
@moduledoc """
This module simulates Langton's ants and prints out its direction for a certain number of steps.
I am planning on representing this grid as a map of maps as accessing and changing things is much easier.
I got the idea from https://blog.danielberkompas.com/2016/04/23/multidimensional-arrays-in-elixir/.
"""

use Agent
use Task

@startPos {:up, 5, 5}
@agent_id __MODULE__
@grid_12_12 %{
  0  => %{0 => :white, 1 => :white, 2 => :white, 3 => :white, 4 => :white, 5 => :white, 6 => :white, 7 => :white, 8 => :white, 9 => :white, 10 => :white, 11 => :white},
  1  => %{0 => :white, 1 => :white, 2 => :white, 3 => :white, 4 => :white, 5 => :white, 6 => :white, 7 => :white, 8 => :white, 9 => :white, 10 => :white, 11 => :white},
  2  => %{0 => :white, 1 => :white, 2 => :white, 3 => :white, 4 => :white, 5 => :white, 6 => :white, 7 => :white, 8 => :white, 9 => :white, 10 => :white, 11 => :white},
  3  => %{0 => :white, 1 => :white, 2 => :white, 3 => :white, 4 => :white, 5 => :white, 6 => :white, 7 => :white, 8 => :white, 9 => :white, 10 => :white, 11 => :white},
  4  => %{0 => :white, 1 => :white, 2 => :white, 3 => :white, 4 => :white, 5 => :white, 6 => :white, 7 => :white, 8 => :white, 9 => :white, 10 => :white, 11 => :white},
  5  => %{0 => :white, 1 => :white, 2 => :white, 3 => :white, 4 => :white, 5 => :white, 6 => :white, 7 => :white, 8 => :white, 9 => :white, 10 => :white, 11 => :white},
  6  => %{0 => :white, 1 => :white, 2 => :white, 3 => :white, 4 => :white, 5 => :white, 6 => :white, 7 => :white, 8 => :white, 9 => :white, 10 => :white, 11 => :white},
  7  => %{0 => :white, 1 => :white, 2 => :white, 3 => :white, 4 => :white, 5 => :white, 6 => :white, 7 => :white, 8 => :white, 9 => :white, 10 => :white, 11 => :white},
  8  => %{0 => :white, 1 => :white, 2 => :white, 3 => :white, 4 => :white, 5 => :white, 6 => :white, 7 => :white, 8 => :white, 9 => :white, 10 => :white, 11 => :white},
  9  => %{0 => :white, 1 => :white, 2 => :white, 3 => :white, 4 => :white, 5 => :white, 6 => :white, 7 => :white, 8 => :white, 9 => :white, 10 => :white, 11 => :white},  
  10 => %{0 => :white, 1 => :white, 2 => :white, 3 => :white, 4 => :white, 5 => :white, 6 => :white, 7 => :white, 8 => :white, 9 => :white, 10 => :white, 11 => :white},
  11 => %{0 => :white, 1 => :white, 2 => :white, 3 => :white, 4 => :white, 5 => :white, 6 => :white, 7 => :white, 8 => :white, 9 => :white, 10 => :white, 11 => :white}
}


  @doc """
 
  """
  @spec start_ants(integer, integer):: any()
  def start_ants(num_ants, num_steps) do
    (1..num_ants)
    |> Enum.map(fn(ants_id) -> Task.start(@agent_id, :start_ant, [num_steps, ants_id]) end)
    
  end


  @doc """
  Starts the agent that stores the state of an ant, and initalizes the function to check and change its state.
  """
  @spec start_ant(integer, integer):: any()
  def start_ant(steps, ant_id) do
    Agent.start_link(fn  -> @startPos end, name: @agent_id)
    
    gridW =  Kernel.map_size(@grid_12_12)
    gridH =  Kernel.map_size(@grid_12_12[0])
    IO.puts "We're working with a #{gridW} by #{gridH} grid, starting at (#{get_x}, #{get_y})."
    IO.puts ""
    
    changeDirection(@grid_12_12, steps, ant_id)
  end
  
  @spec start_ant(integer):: any()
  def start_ant(steps), do: start_ant(steps, 1)
  

  @doc """
  Function to (possibly) stop the Agent and print out a message.
  """
  @spec kill_ant(String.t):: any()
  def kill_ant(message) do
    #Agent.stop(@agent_id)
    IO.puts(message)
  end
  
  
  
  @doc """
  Function to check what cell the ant is currently on and returns tuple containing a direction
  atom as well as a changed grid.
  """
  @spec check_cell(map(), integer, integer):: tuple()  
  def check_cell(grid, x, y) do
    grid_curr = grid[x][y]
    
    dir_grid = if grid_curr == :black do
      {:left, put_in(grid[x][y], :white)}
    else
      {:right, put_in(grid[x][y], :black)}
    end
     
     #IO.inspect grid_curr
     #IO.inspect elem(dir_grid, 0)
     
    
    dir_grid
  end  
  
  
  @doc """
  Function that changes the Agent state based on the current cell. It also prints out the state
  as well as the current cell color the ant is on. It then calls the changeDirection function again, or
  calls the kill_ant function if the steps are finished.
  """
  @spec changeDirection(map(), integer, integer):: any()  
  def changeDirection(grid, steps, ant_id) do
     
     # This sleep command is so that the processes check the grid at different times
     # so that they can have different values.
     :timer.sleep(ant_id * 100)
     
    {orientation, x, y} = get_info
    {new_direction, new_grid} = check_cell(grid, get_x, get_y)
    
    new_pos = case {orientation, new_direction} do
      {:up, :left}   -> {:left_side, x - 1, y}
      {:down,:right} -> {:left_side, x - 1, y}
      
      {:up, :right}  -> {:right_side, x + 1, y}
      {:down,:left}  -> {:right_side, x + 1, y}
      
      {:left_side, :right} -> {:up, x, y - 1}
      {:right_side, :left} -> {:up, x, y - 1}
      
      {:left_side,  :left}  -> {:down, x, y + 1} 
      {:right_side, :right} -> {:down, x, y + 1}
    end
    

    steps = steps - 1
    Agent.update(@agent_id, fn _ ->  new_pos end)
    
    # Print out path
    #IO.puts "ANT #{ant_id}: "  # Debugging
    #IO.inspect grid[get_x][get_y], label: "Color on Current Square for #{ant_id}"  # Debugging
    IO.puts "ANT #{ant_id} has #{steps} steps remaining."  # Debugging
    IO.inspect get_info, label: "{Ant #{ant_id} Facing, x, y}"

    IO.puts " "
    :timer.sleep(1000)
    
    
    # Makes sure index is not invalid
     cond do
      #new_pos[1] < 0 || new_pos[1] > 11 || -> kill_ant("Your ant #{ant_id} hit a wall and died!")
      #new_pos[2] < 0 || new_pos[2] > 11 || -> kill_ant("Your ant #{ant_id} hit a wall and died!")
      steps == 0                           -> kill_ant("Your ant #{ant_id} is done walking.")
      true  ->  changeDirection(new_grid, steps, ant_id)
    end
    
  end  
  
  @doc """
  Functions that return the x, y values or the entire tuple of the Agent state.
  """
  @spec get_x():: integer
  def get_x do
    Agent.get(@agent_id, fn {orientation, x, y} -> x end)
  end
  
  @spec get_y():: integer
  def get_y do
    Agent.get(@agent_id, fn {orientation, x, y} -> y end)
  end
  
  @spec get_info():: tuple
  def get_info do
    Agent.get(@agent_id, fn attributes -> attributes end)
  end
  
  
end  

#Ant_March.start_ant(5)

Ant_March.start_ants(5, 7)



