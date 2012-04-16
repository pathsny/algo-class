class QuickSort
  def initialize(arr, &pivot)
    @count = 0
    @arr = arr
    @choose_pivot = pivot
    sort(0, arr.length-1)
  end
  
  attr_reader :arr, :count  

  # def choose_pivot(l, r)
  #   return @arr[l]
  # end  
  
  def swap(i, j)
    tmp = @arr[i]
    @arr[i] = @arr[j]
    @arr[j] = tmp
  end  

  def sort(l, r)
    return if (r <= l)
    p, p_index = @choose_pivot[@arr, l, r]
    swap(l, p_index)
    i = l+1
    @count += (r-l)
    for j in (l+1..r)
      if (@arr[j] < p)
        swap(j, i)
        i = i+1
      end  
    end
    swap(l, i-1)
    sort(l, i-2)
    sort(i, r)
  end  
end  

data = File.read('QuickSort.txt').split("\n").map(&:to_i)
qs = QuickSort.new(data.dup) {|arr, l, r| [arr[l], l]}
puts (1..10000).to_a.zip(qs.arr).all? {|a, b| a == b}
puts qs.count
qs = QuickSort.new(data.dup) {|arr, l, r| [arr[r], r]}
puts (1..10000).to_a.zip(qs.arr).all? {|a, b| a == b}
puts qs.count
qs = QuickSort.new(data.dup) do |arr, l, r| 
  mid = (l + r)/2
  choices = [[arr[l], l], [arr[mid], mid], [arr[r], r]]
  choices.sort {|x, y| x.first <=> y.first}[1]
end  
puts (1..10000).to_a.zip(qs.arr).all? {|a, b| a == b}
puts qs.count    