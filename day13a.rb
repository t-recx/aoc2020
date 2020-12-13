#!/usr/bin/env ruby

lines = File.readlines(ARGV[0]).map(&:strip)

departing_ts = lines[0].to_i

ids = lines[1].split(',').reject { |id| id == 'x' }.map { |id| id.to_i }

id, waiting_time = 
    ids
    .map { |id| [id, id * (departing_ts / id + 1) - departing_ts] }
    .sort_by { |id, waiting_time| waiting_time }
    .first

p id * waiting_time