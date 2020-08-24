require 'pathname'

dir_path = File.expand_path(__dir__)
dir_path = Pathname.new(dir_path)
input_file_path = dir_path.join('input.txt')
output_file_path = dir_path.join('output.csv')
# File.truncate(output_file_path, 0)

File.open(output_file_path, 'w') do |file|
  File.readlines(input_file_path).each do |line|
    items = line.gsub(/\s+/, ' ').strip.split(' ')
    next if items.empty?

    new_line = "#{items.join(',')}\n"
    file.write(new_line)
  end
end
