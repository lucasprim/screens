require 'open-uri'
require 'rexml/document'

include REXML

URL = "https://s3.amazonaws.com/zygo.screens/"
EXECUTABLE = if Gem::Platform.local.os == "darwin"
	"/Applications/Firefox.app/Contents/MacOS/firefox"
else
	"C:/Program Files/Mozilla Firefox/firefox.exe"
end

xml = URI.open(URL).read
doc = Document.new xml

files = []

doc.root.each_element('//Contents') { |e| files.push(e.elements['Key'].text) }

puts files

files.each do |f|
	puts f
	Kernel.system("#{EXECUTABLE} -kiosk -new-tab #{URL}#{f}")
	sleep 1
end
