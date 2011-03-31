#!/usr/bin/env ruby -wKU

libraries_path = '.'

  `git submodule add git@github.com:czgarrett/desiccant.git #{libraries_path}/desiccant`
  `git submodule init`
  `git submodule add git@github.com:czgarrett/cocoa-bucks.git #{libraries_path}/cocoa-bucks`
  `git submodule init`
  `git add .gitmodules`
  `git commit`
  `git push origin master`
  #Submodule is now checked out in a headless state.
  `git submodule update`
  
