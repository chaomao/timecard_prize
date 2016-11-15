require 'csv'
require 'date'
require 'pry'

@special_holidays = [
	{
		start: DateTime.parse('2016-01-01'), end: DateTime.parse('2016-01-03'),
		first: DateTime.parse('2015-12-31 23:59:59+8'), second: DateTime.parse('2016-01-03 23:59:59+8')
	},
	{
		start: DateTime.parse('2016-02-01'), end: DateTime.parse('2016-02-06'),
		first: DateTime.parse('2016-02-06 23:59:59+8'), second: DateTime.parse('2016-02-07 23:59:59+8')
	},
	{
		start: DateTime.parse('2016-02-08'), end: DateTime.parse('2016-02-14'),
		first: DateTime.parse('2016-02-14 23:59:59+8'), second: DateTime.parse('2016-02-14 23:59:59+8')
	},
	{
		start: DateTime.parse('2016-06-06'), end: DateTime.parse('2016-06-12'),
		first: DateTime.parse('2016-06-12 23:59:59+8'), second: DateTime.parse('2016-06-12 23:59:59+8')
	},
	{
		start: DateTime.parse('2016-09-12'), end: DateTime.parse('2016-09-18'),
		first: DateTime.parse('2016-09-18 23:59:59+8'), second: DateTime.parse('2016-09-18 23:59:59+8')
	},
	{
		start: DateTime.parse('2016-10-03'), end: DateTime.parse('2016-10-09'),
		first: DateTime.parse('2016-10-09 23:59:59+8'), second: DateTime.parse('2016-10-09 23:59:59+8')
	},
]

@result = {
	miss: {},
	first: {},
	second: {}
}

@new_hire_or_resignation =  [17847, 15760, 14504, 18559, 18555, 18556, 18557, 18558, 18561, 18546, 18560, 18583, 18585, 18620, 18619, 18618, 18623, 18629, 18638, 18632, 18628, 18657, 18659, 18662, 18692, 18711, 18708, 18709, 18712, 18660, 18723, 18710, 18728, 18733, 18729, 18743, 18764, 18765, 18753, 18754, 18774, 18757, 18815, 18819, 18780, 18834, 18838, 18835, 18767, 18846, 18836, 18870, 18851, 18871, 18895, 18869, 18908, 18910, 18905, 18906, 18816, 18927, 18904, 18945, 18750, 18944, 18907, 18977, 18980, 18982, 18957, 18909, 18979, 18981, 18978, 18837, 18983, 18999, 18877, 18998, 19005, 19013, 19014, 19015, 19062, 19052, 19064, 19065, 19079, 19091, 19092, 19093, 19063, 14706, 19081, 17473, 18868, 19138, 19148, 19165, 19143, 19144, 19145, 19141, 19142, 19146, 19119, 15612, 19139, 19191, 19207, 19190, 19234, 19224, 19225, 19229, 19244, 19226, 19260, 19315, 19271, 19258, 19270, 19319, 19261, 19279, 18713, 19272, 19338, 19323, 18911, 19344, 19324, 19000, 18912, 19346, 18783, 19368, 19345, 19326, 18782, 19334, 18462, 19332, 19333, 19331, 19363, 19382, 18839, 19328, 19361, 18714, 18820, 19327, 19362, 18731, 19360, 19077, 19383, 19206, 19325, 19259, 19274, 19365, 19366, 19381, 19420, 19421, 19409, 19329, 18748, 18747, 19335, 19330, 19336, 18751, 18800, 19423, 19422, 19430, 19442, 19424, 19469, 19471, 19364, 19486, 19431, 18749, 19249, 19247, 19367, 19245, 19246, 19248, 19515, 19500, 19508, 19514, 19501, 19281, 19499, 19542, 19503, 19284, 19546, 19534, 19285, 18799, 19540, 19533, 19543, 19282, 19280, 19539, 19541, 19322, 19565, 19564, 19567, 18730, 19566, 19561, 19502, 19588, 19547, 19589, 19601, 19591, 19519, 19600, 19619, 19592, 19603, 19617, 19635, 19548, 19616, 16030, 19602, 19590, 19652, 19687, 19644, 19647, 19646, 19658, 19688, 19654, 19648, 19653, 19700, 16542, 19727, 19721, 19760, 19752, 19722, 19732, 18761, 19759, 19761, 19751, 19797, 19796, 19814, 19825, 19863, 19794, 19864, 19816, 19817, 19815, 19821, 19826, 19865, 19866, 19823, 19822, 19862, 19877, 19879, 19824, 14334, 19896, 19892, 19904, 19897, 19890, 19891, 19893, 19894, 19911, 19918, 19913, 18817, 18872, 18993, 19166, 19278, 19549, 19569, 19639, 19733, 19808, 12706, 13334, 13451, 13570, 13606, 13663, 13664, 13707, 13937, 14022, 14296, 14301, 14502, 14536, 14606, 14629, 14635, 14684, 15037, 15113, 15148, 15161, 15202, 15318, 15332, 15392, 15402, 15426, 15427, 15707, 15778, 15800, 15877, 15906, 15947, 15966, 15988, 16109, 16143, 16162, 16165, 16211, 16297, 16310, 16364, 16401, 16452, 16526, 16656, 16675, 16712, 16761, 16793, 16817, 16819, 16825, 16858, 16879, 16889, 16919, 16921, 16942, 16996, 17095, 17138, 17159, 17161, 17184, 17193, 17320, 17325, 17410, 17433, 17436, 17450, 17454, 17519, 17553, 17564, 17566, 17615, 17646, 17736, 17757, 17759, 17792, 17893, 17933, 18055, 18057, 18062, 18080, 18102, 18113, 18114, 18117, 18181, 18190, 18241, 18253, 18311, 18326, 18327, 18349, 18362, 18467, 18497, 18498, 18547, 18605, 18621, 18622, 18693, 18715, 18725, 18745, 18746, 18755, 18766, 18770, 18781, 18802, 18814, 18941, 18942, 18950, 18951, 18987, 18989, 19080, 19094, 19105, 19147, 19151, 19192, 19227, 19233, 19235, 19250, 19269, 19273, 19286, 19289, 19292, 19293, 19295, 19296, 19343, 19355, 19470, 19649, 19885, 19898, 19899, 19914, 19916, 19917]
@new_hire_or_resignation = @new_hire_or_resignation.inject({}) do |memo, id|
	memo[id.to_s] = ''; memo
end

def find_in_special_duration(target_day)
	@special_holidays.find { |hash| hash[:start] <= target_day && target_day <= hash[:end] }
end

def check_missing(submit_time ,first_deadline, second_deadline)
	if submit_time <= first_deadline
		mark_as_first_prize
	elsif submit_time <= second_deadline
		mark_as_second_prize
	else
		mark_as_missing
	end
end

def end_of_this_friday(day)
	friday = day + (5 - day.wday)
	DateTime.new(friday.year, friday.month, friday.day, 23, 59, 59, '+8')
end

def end_of_this_sunday(day)
	sunday = day + (7 - day.wday)
	DateTime.new(sunday.year, sunday.month, sunday.day, 23, 59, 59, '+8')
end

def mark_as_first_prize
	return if @result[:miss].key?(@data[3]) || @result[:second].key?(@data[3])
	@result[:first][@data[3]] = {employee: @data[0], name: @data[1], detail: [], id: @data[3]} unless @result[:first].key?(@data[3])
end

def mark_as_second_prize
	@result[:first].delete(@data[3])
	return if @result[:miss].key?(@data[3])
	@result[:second].key?(@data[3]) ? 
		@result[:second][@data[3]][:detail] << @data :
		@result[:second][@data[3]] = { employee: @data[0], name: @data[1], detail: [@data], id: @data[3] }
end

def mark_as_missing
	@result[:first].delete(@data[3])
	@result[:second].delete(@data[3])
	@result[:miss].key?(@data[3]) ?
		@result[:miss][@data[3]][:detail] << @data :
		@result[:miss][@data[3]] = { employee: @data[0], name: @data[1], detail: [@data], id: @data[3] }
end

def print_result
	first_count = @result[:first].count
	second_count = @result[:second].count
	miss_count = @result[:miss].count
	puts "========总人数 #{first_count + second_count + miss_count}========"

	final_first = @result[:first].inject({new_hire: [], candidates: []}) do |memo, (id, value)|
		@new_hire_or_resignation.key?(id) ? 
			memo[:new_hire] << value :
			memo[:candidates] << value
		memo
	end

	final_second = @result[:second].inject({new_hire: [], candidates: []}) do |memo, (id, value)|
		@new_hire_or_resignation.key?(id) ? 
			memo[:new_hire] << value :
			memo[:candidates] << value
		memo
	end

	puts "========一等奖#{final_first[:candidates].count}========"
	final_first[:candidates].each do |value|
		if @all_data[value[:id]]['2016-01-01'].nil? || @all_data[value[:id]]['2016-10-31'].nil?
			puts "timecard不够 #{value[:id]}, #{value[:employee]}, #{value[:name]}, #{value[:detail].inspect}"
		else
			puts "一等奖 #{value[:id]}, #{value[:employee]}, #{value[:name]}"
		end
	end

	puts "========二等奖#{final_second[:candidates].count}========"
	final_second[:candidates].each do |value|
		if @all_data[value[:id]]['2016-01-01'].nil? || @all_data[value[:id]]['2016-10-31'].nil?
			puts "timecard不够 #{value[:id]}, #{value[:employee]}, #{value[:name]}, #{value[:detail].inspect}"
		else
			puts "二等奖 #{value[:id]}, #{value[:employee]}, #{value[:name]}"
			value[:detail].each { |item| puts item.inspect }
		end
	end

	puts "========鼓励一等奖#{final_first[:new_hire].count}========"
	final_first[:new_hire].each do |value|
		puts "鼓励一等奖 #{value[:id]}, #{value[:employee]}, #{value[:name]}"
	end

	puts "========鼓励二等奖#{final_second[:new_hire].count}========"
	final_second[:new_hire].each do |value|
		puts "鼓励二等奖 #{value[:id]}, #{value[:employee]}, #{value[:name]}"
		value[:detail].each { |item| puts item.inspect }
	end


	#{employee: @data[0], name: @data[1], detail: [@data], id: @data[3]}
	puts "========miss timecard#{miss_count}========"
	@result[:miss].sort {|h1, h2| h2[1][:detail].count <=> h1[1][:detail].count}.each do |value|
		puts "miss #{value[0]}, #{value[1][:employee]}, #{value[1][:name]} #{value[1][:detail].count}"
		value[1][:detail].each { |item| puts item.inspect }
		puts
	end
end

def calculate_dealline(duration, submit_time)
	[ 
		duration.nil? ? 
			end_of_this_friday(submit_time) : 
			duration[:first],
		duration.nil? ? 
			end_of_this_sunday(submit_time) :
			duration[:second]
	]
end

def valid_result?
	first = @result[:first].keys
	second = @result[:second].keys
	miss = @result[:miss].keys
	i1_i2 = (first & second)
	i1_i3 = (first & miss)
	i2_i3 = (second & miss)
	puts "first & second #{i1_i2.inspect}" unless i1_i2.empty?
	puts "first & miss #{i1_i3.inspect}" unless i1_i3.empty?
	puts "second & miss #{i2_i3.inspect}" unless i2_i3.empty?
	i1_i2.empty? && i1_i3.empty? && i2_i3.empty?
end
@all_data = {}
def run
	# ["Employee", "An,Cong", "2016-10-03", "18222", "2016-09-29 8:36"]
	CSV.read('/Users/chaomao/Desktop/timecard/timecard统计信息/01_10.csv').each_with_index do |data, index|
		begin
		@data = data
		@all_data[@data[3]] = {} unless @all_data.key?(@data[3])
		@all_data[@data[3]][@data[2]] = 1 
		submit_time = DateTime.parse(@data[4]).new_offset('+8')
		target_day = DateTime.parse(@data[2])
		first_deadline, second_deadline = calculate_dealline(find_in_special_duration(target_day), target_day)
		check_missing(submit_time, first_deadline, second_deadline)
	rescue Exception => e
		binding.pry
	end
	end
	print_result if valid_result?
end

run
