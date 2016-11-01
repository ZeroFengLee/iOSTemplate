
module ProSubStr

	#  substitute
	#  @param	path			file's path
	#  @param	src_str			original string
	#  @param   dst_str			target string
	def self.proj_sub_str(path, src_str, dst_str)
		File.open(path, 'r') do |f|
			buf = f.read.gsub(src_str, dst_str)
			File.open(path,'w'){ | line |
		    	line.write(buf)
		  	}
		end
	end
end