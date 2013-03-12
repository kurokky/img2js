require 'base64'

class Image_to_js
	def logic_go
		if File.exists?("source")
			all = Array.new
			files = Dir.glob("source/*.*")
			main_logic = make_func(files)
			files.each do |f|
				all << trance_base64(f)
			end
			File.open("img.js" , "w") do |f|
				f.puts(main_logic.join("\n"))
				f.puts("\n")
				f.puts(all.join("\n\n"))
			end
		else
			p "source directory not found"
		end
	end
	def make_func(files)
		temp = Array.new
		temp << '$(function(){'
		files.each do |file|
			file_name = (File.basename(file)).split(".")
			temp << "\timg_#{file_name[0]}();"
		end
		temp << "});"
		return(temp)
	end
	def trance_base64(file)
		base = File.open(file,"r+b")
		base64_text = ([base.read].pack('m')).chop
		file_name = (File.basename(file)).split(".")
		text_name = "#{file_name[0]}.js"
		temp = Array.new
		js = "\t'" +  base64_text.gsub(/\n/, "' + \n\t'") + "';"
		func_header = "function img_#{file_name[0]}(){"
		temp << func_header
		temp << "\tvar data= 'data:image/#{file_name[1]};base64,' +"
		temp << js
		temp << "\t$('##{file_name[0]}').attr('src', data);"
		temp << '}'
		return(temp.join("\n"))
	end
end

main = Image_to_js.new
main.logic_go
