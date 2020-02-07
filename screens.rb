require 'open-uri'
require 'rexml/document'

include REXML

URL = "https://s3.amazonaws.com/zygo.screens/"
EXECUTABLE = if Gem::Platform.local.os == "darwin"
	"/Applications/Firefox.app/Contents/MacOS/firefox"
else
	"C:\\Program Files\\Mozilla Firefox\\firefox.exe"
end

xml = URI.open(URL).read
doc = Document.new xml

files = []

doc.root.each_element('//Contents') { |e| files.push(e.elements['Key'].text) }

extra_urls_present = false
urls = files.map do |f|
	extra_urls_present = true and next if f == 'urls.txt'
	"\"#{URL}#{f}\""
end.compact

if extra_urls_present
	extra_urls = URI.open("#{URL}urls.txt").read.split("\n")
	extra_urls.each { |eu| urls.push(eu) }
end

urls.each do |u|
	puts u
	Kernel.system("\"#{EXECUTABLE}\" -kiosk -new-tab #{u}")
	sleep 1
end
