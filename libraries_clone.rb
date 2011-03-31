#!/usr/bin/env ruby -wKU

branch_name = nil # Name your branch here

if branch_name
  `git submodule init`
  `git submodule update`

  Dir.chdir('desiccant')
  `git fetch`
  `git checkout -b #{branch_name} origin/#{branch_name}`
  Dir.chdir('../cocoa-bucks')
  `git fetch`
  `git checkout master`
else
  puts "No branch name defined.  Edit this script to define a branch"
end

# git clone git@github.com:ntalbott/medaxion_mobile.git medaxion_test