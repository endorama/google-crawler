#!/bin/bash

#  To run the crawler and mapreducer, run executer.sh, passing a search term and 
#+ a comma separated list of dataset to be produced.
#+ The dataset is specified as the number of google page to be included in it, 
#+ so 50 means 50 google pages of results ( around 500 results ).
#
#  bash executer "search term" "50, 15"


#  Aggergate all mapreduced result of specified page number present in results 
#+ folder.
#
#  bash aggregate.sh "15"


#  Archive results after completion
#  bash archiver.sh

#  Send a mail to a specified address in order to inform when the task has
#+ finished.
# echo "I'm done" | mail -s "Task has finished" "your@mail.com"
