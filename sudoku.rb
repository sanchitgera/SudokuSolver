#!/usr/bin/env ruby
require './BetterMatrix'
N = 9

def main
  matrix = BetterMatrix[
    [7, 0, 0, 3, 0, 1, 0, 0, 0],
    [0, 4, 0, 8, 0, 7, 3, 0, 0],
    [9, 0, 5, 2, 0, 0, 1, 0, 0],
    [0, 0, 0, 0, 0, 0, 7, 9, 8],
    [1, 0, 9, 7, 0, 3, 4, 0, 5],
    [5, 7, 4, 0, 0, 0, 0, 0, 0],
    [0, 0, 3, 0, 0, 5, 8, 0, 2],
    [0, 0, 7, 4, 0, 2, 0, 1, 0],
    [0, 0, 0, 1, 0, 8, 0, 0, 9]
  ]

  print "Input: \n"
  print_board(matrix)

  if solve_sudoku(matrix)
    print "Puzzle Solved! Hazzaah!\n"
    print_board(matrix)
    return
  end
  print "Failed, try again\n"
end

def print_board(matrix)
  (0..(N-1)).each do |index|
    row = matrix.row(index)

    row.each_with_index do |num, col|
      print num.to_s + " "
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

def is_safe(num, row, col, matrix)
  if (!used_in_col(num, row, col, matrix) &&
      !used_in_row(num, row, col, matrix) &&
      !used_in_box(num, row - row % 3, col - col % 3, matrix) )
     return true
   end
  return false
end

def used_in_col(num, row, col, matrix)
  return matrix.column(col).include? num
end

def used_in_row(num, row, col, matrix)
  return matrix.row(row).include? num
end

def used_in_box(num, startRow, startCol, matrix)
    (0..1).each do |row|
      (0..1).each do |col|
        if matrix[row + startRow, col + startCol] == num
          return true
        end
      end
    end
    return false
end

main()
