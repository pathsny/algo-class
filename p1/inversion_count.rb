def merge_and_count(arr_left, arr_right)
  result = []
  inversion_count = 0
  arr_left = arr_left.reverse
  arr_right = arr_right.reverse
  while (!arr_left.empty? && !arr_right.empty?)
    if (arr_left.last <= arr_right.last)
      result << arr_left.pop
    else
      result << arr_right.pop
      inversion_count += arr_left.length
    end    
  end
  return [result + arr_left.reverse, inversion_count] unless (arr_left.empty?)
  [result + arr_right.reverse, inversion_count]
end 

def invert_and_sort(arr)
  return [arr, 0] if (arr.empty? || arr.length == 1)
  midway = arr.length / 2 - 1
  arr_left, invert_left = invert_and_sort(arr[0..midway])
  arr_right, invert_right = invert_and_sort(arr[(midway+1)..-1])
  return merge_and_count(arr_left, arr_right).tap{|a| a[1] += invert_left + invert_right}
end  
data = File.read('IntegerArray.txt').split("\n").map(&:to_i)

puts merge_and_count([1,3,5],[2,4,6]).inspect
puts 0 == invert_and_sort([])[1]
puts 0 == invert_and_sort([1])[1]
puts 0 == invert_and_sort([1,2,3])[1]
puts 3 == invert_and_sort([3,2,1])[1]
puts 15 == invert_and_sort([6,5,4,3,2,1])[1]
puts invert_and_sort(data).inspect
