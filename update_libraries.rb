#!/usr/bin/env ruby -wKU

# Use this inside your workspace root to automatically update desiccant
# 

branch_name = nil # Name your branch here

if branch_name
  if File.exists? "desiccant"
    Dir.chdir('desiccant')
    `git pull origin #{branch_name}`
  else 
    `git clone git@github.com:czgarrett/desiccant.git desiccant`
    Dir.chdir('desiccant')
    `git fetch`
    `git checkout -b #{branch_name} origin/#{branch_name}`
  end
else
  puts "No branch name defined.  Edit this script to define a branch"
end