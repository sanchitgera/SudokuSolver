#!/usr/bin/env ruby
require 'thor'
require './BetterMatrix'
class SudokuGem < Thor
  N = 9
  desc "Create a Sudoku puzzle given a difficulty", "fancy"
  method_options :difficulty => :numeric,:aliases => "-d", :default=> 0.5
  def create
    matrix = BetterMatrix.zero(N)
    say "Good Luck with this puzzle!", :yellow
    generate(matrix)
    diff = options[:difficulty]
    diff = diff.to_f
    empty_squares = (diff * 60).floor
    # Randomly pop 20 integers from the board
    empty_squares.times do
      while true
        location = [rand(N), rand(N)]
        next if matrix[location.first, location.last] == 0
        matrix[location.first, location.last] = 0
        break
      end
    end
    print_board(matrix)
  end

  desc "Solver", "solver"
  def solve_sudoku(matrix)
    empty_location = matrix.index(0)
    if empty_location.nil?
      return true
    end

    row, col = empty_location.first, empty_location.last
    (1..N).each do |num|
      if(is_safe num, row, col, matrix)
         matrix.set_element(row, col, num)

        if solve_sudoku(matrix)
          return true
        end

        matrix[row, col] = 0
      end
    end

    return false
  end

  desc "Make this method private", "ok"
  def generate(matrix)
    empty_location = matrix.index(0)
    if empty_location.nil?
      return true
    end

    row, col = empty_location.first, empty_location.last
    (1..N).to_a.shuffle.each do |num|
      if(is_safe num, row, col, matrix)
         matrix.set_element(row, col, num)

        if generate(matrix)
          return true
        end

        matrix[row, col] = 0
      end
    end

    return false
  end

  desc "whatever", "whatever"
  def is_safe(num, row, col, matrix)
    if (!used_in_col(num, row, col, matrix) &&
        !used_in_row(num, row, col, matrix) &&
        !used_in_box(num, row - row % 3, col - col % 3, matrix) )
       return true
     end
    return false
  end

  desc "whatever", "whatever"
  def used_in_col(num, row, col, matrix)
    return matrix.column(col).include? num
  end

  desc "whatever", "whatever"
  def used_in_row(num, row, col, matrix)
    return matrix.row(row).include? num
  end

  desc "whatever", "whatever"
  def used_in_box(num, startRow, startCol, matrix)
      (0..2).each do |row|
        (0..2).each do |col|
          if matrix[row + startRow, col + startCol] == num
            return true
          end
        end
      end
      return false
  end

  desc "whatever", "whatever"
  def print_board(matrix)
    (0..(N-1)).each do |index|
      row = matrix.row(index)

      row.each_with_index do |num, col|
        if num.eql? 0
          print '. '
        else
          print num.to_s + " "
        end
        if (col + 1) % 3 == 0 and not col.eql? (N-1)
          print "| "
        elsif col == (N - 1)
          print "\n"
        end
      end

      if (index + 1) % 3 == 0 and not index.eql? (N-1)
        print "------|-------|------\n"
      end
    end
  end
end

SudokuGem.start
