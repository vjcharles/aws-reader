README
======

* How to run the application against a file.

  This is a ruby script which can be run with `./aws_reader.rb datafile.csv [0]`
  The optional 2nd argument allows the script to start later in the file.

* Any notes about approach that you think are relevant and tradeoffs you made in your solution.

  One-off script. The @report hash could get large with large data files.

* For the algorithms you implement, the time and space complexity in Big-O notation

  For parts 1 and 2 this runs in O(mn). A single-pass and data is summed and data structures are grown as needed. represents the number of rows, and m the number of custom tags. 

* Which constraint (time v. space) you optimized for and why.

  Time was optimized for. The file should be read per line, and the data structures grow as much as needed. For the required calculations. 
  Another approach would be to write out data periodically, clear out local memory, then read those in once the entire file was read, then tally those. An approach like that seemed excessive for this exercise.

* Bonus points: For the algorithms you implement, the best- and worst-case runtime complexity and the scenarios under which they occur.

 Best runtime complexity is when tag count is small (columns are few). Worst runtime would occur when tag count approaches the row count. It would approach O(n^2). AWS only allows 10 tags, so m will never be significantly large.


## Tasks ## 
* Count the unique types of EC2 instances within the file.
* Generate a report of total cost by day, by tag. (i.e. on March 3rd, Environment = Production cost $100.0) 
* Bonus points: Find instances that changed tags during the month, and the timestamp on which they changed

##Known Issues ##

* Dates that aren't parsed properly are given year zero 0000-01-01
* Some tags appear to have numeric data

