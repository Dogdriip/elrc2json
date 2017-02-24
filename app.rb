require 'json'
require 'enumerator'

filepath = ARGV[0]
if File.file? filepath
  total_resarr = Array.new
  IO.foreach(filepath) do |line|
    line_resarr = Array.new
    linearr = line.split
    linearr.each_slice(2) do |time, lyric|
      if time[0] == '['
        time = time.split('[')[1].split(']')[0]
      else
        time = time.split('<')[1].split('>')[0]
      end
      lyric = lyric.strip
      a = time.split(':')[0].to_i
      a_r = time.split(':')[1]
      b = a_r.split('.')[0].to_i
      c = a_r.split('.')[1].to_i
      time = a * 60000 + b * 1000 + c
      hash_obj = {"time" => time, "lyric" => lyric};
      line_resarr.push hash_obj
    end
    total_resarr.push line_resarr
  end
  total_resarr.shift # ?????

  jsonfile = File.new("#{filepath.split('.')[0] + '.json'}", 'w')
  if jsonfile
    jsonfile.syswrite total_resarr.to_json
    puts "File successfully created: '#{filepath.split('.')[0] + '.json'}'"
  else
    raise 'Cannot create new file'
  end
else
  raise "File not found: '#{filepath}'"
end
