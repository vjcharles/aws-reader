#!/usr/bin/env ruby -i

require 'pp'

if ARGV[0].nil?
  puts "Usage: `./aws_reader.rb aws_data.csv [start line number. default 0]"
  exit(1)
end

@ec2_types = Hash.new(0)
@report = Hash.new(0.0)
@start_index = ARGV[1].to_i || 0
@lines_read = 0
@instance_tags = {}
@usage_type_index
@header_indices = {}

@instances = {}#by ResourceId

def report_to_s(details={})
  "On #{details[:date]}, #{details[:tag_key]} = #{details[:tag_val]} cost $#{details[:cost].round(2)}"
end

def init_header_and_tags(row)
  row.each_with_index do |header, i|
    tag = header.split("user:")
    if tag.length > 1
      tag_name = tag.last
      @instance_tags[tag_name] = i
      next
    end
    @header_indices[header] = i
  end
end

puts "Instance tag changes"

File.readlines(ARGV[0]).each_with_index do |line, i|
  row = line.split(',')
  row.map! {|h| h.gsub(/^"|"$/, '').chomp}

  if i == 0
    init_header_and_tags(row)
    next
  elsif @start_index > i
    i += 1
    next
  end

  # do work #
  # unique instance types count
  @ec2_types[row[@header_indices['UsageType']]] += 1

  # report cost by day by tag
  date = DateTime.parse(row[@header_indices['UsageStartDate']]).to_date.to_s rescue '0000-01-01'#invalid dates

  @instance_tags.each do |k, v|
    next if row[v] == '' #skip when tag not present
    
    key = [date, {tag_key: k, tag_val: row[v]}]
    @report[key] += row[@header_indices['UnBlendedCost']].to_f #TODO: not sure which cost type to use
  end

  #Instance Tag States
  resource_id = row[@header_indices['ResourceId']]
  @instances[resource_id] ||= {}
  @instance_tags.each do |tag_key, row_index|
    current_tag = @instances[resource_id][tag_key]    
    if !current_tag.nil?# &&
       !resource_id.empty? &&
       current_tag != row[row_index] &&
       !row[row_index].empty?
      #the tag is changing
      puts "Current: #{current_tag}, New: #{row[row_index]}. resource_id: #{resource_id} on #{row[@header_indices['UsageEndDate']]}"
      STDOUT.flush
      @instances[resource_id][tag_key] = row[row_index]
    end
  end

  @lines_read = i
end

puts
puts "EC2 Instance Type Count"
pp @ec2_types
puts

puts "Total cost by day by tag"
@report.each do |k, v|
  pp report_to_s({date: k.first, tag_key: k.last[:tag_key], tag_val: k.last[:tag_val], cost: v})
end
puts

puts "Lines read #{@lines_read}"

