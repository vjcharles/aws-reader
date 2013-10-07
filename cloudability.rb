#!/usr/bin/env ruby -i

require 'pp'

if ARGV[0].nil?
  puts "Usage: `./cloudabilty aws_data.csv [start line number. default 0]"
  exit(1)
end

@ec2_types = Hash.new(0)
@report = {}
@start_index = ARGV[1].to_i || 0
@lines_read = 0
@instance_tags = {}
@usage_type_index

def report_to_s(details = {})
  "On #{details.date.to_s}, Environment = #{details.environment} cost $#{details.cost.to_s}"
end

def init_header_and_tags(row)
  row.each_with_index do |header, i|
    tag = header.split("user:")
    if tag.length > 1
      tag_name = tag.last
      @instance_tags[tag_name] = i
      next
    end

    if header == "UsageType"
      @usage_type_index = i 
    end
  end
end

File.readlines(ARGV[0]).each_with_index do |line, i|
  row = line.split(',')
  if i == 0
    init_header_and_tags(row)
    next
  elsif @start_index > i
    i += 1
    next
  end

  # do work #
  # unique instance types count
  @ec2_types[row[@usage_type_index]] += 1

  # report cost by day by tag
  
  
  @lines_read = i
end

##show results
#puts "Tags"
#pp @instance_tags
#puts

puts "EC2 Instance Type Count"
pp @ec2_types
puts

puts "Read #{@lines_read}"

