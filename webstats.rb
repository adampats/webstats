#!/usr/bin/env ruby
#
# webstats
#

require 'optparse'
require 'pry-byebug'

usage_msg = "Usage: webstats.rb [-f ./access.log] [-n NUM_RESULTS] [-m METHOD]"

begin
  if ARGV[0].nil?
    raise "Missing command line args.\n " + usage_msg
  end

  opt = {}
  OptionParser.new do |opts|
    opts.banner = usage_msg
    opts.on('-f', '--file LOG_FILE',
      'Apache access.log file.') { |f| opt[:file] = f }
    opts.on('-n', '--number NUM_RESULTS',
      'Show top NUMBER matches. Default = 10') { |n| opt[:top] = n }
    opts.on('-m', '--method GET',
      'Specify HTTP method filter. Default = *') { |m| opt[:method] = m }
  end.parse!

  if ! File.exists?( opt[:file] )
    raise 'Exception: log file not found: ' + opt[:file]
  end

  # set defaults
  opt[:top].nil? ? opt[:top] = 10 : nil

  # read file line by line
  data = []
  IO.foreach( opt[:file] ) { |line|
    line = line.force_encoding('UTF-8')
    a = line.split( /\s|\[|"/ ) # TODO: more explicit regex
    if a[7].include?( opt[:method].to_s.upcase ) || opt[:method].nil?
      data.push( { ip: a[0], date: a[4], method: a[7], resp: a[11] } )
    end
  }

  count = Hash.new(0)
  data.each do |d|
    count[d[:ip]] += 1
  end

  results = count.sort_by { |k,v| v }.reverse[0..(opt[:top].to_i - 1)]
  results.each do |r|
    printf "%-40s %s\n", r[0], r[1]
  end

rescue Exception => e
  puts e.message
end
