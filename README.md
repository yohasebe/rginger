# RGinger

RGinger takes an English sentence and gives correction and rephrasing suggestions for it using Ginger proofreading API. It can be used both as a Ruby library and a command line application.

## Installation

    $ gem install rginger

## Command Line Usage

### Usage

    $ rginger [options] "input text"
     

### Options

         --coloring, --no-coloring, -c:   Get colorful output (default: true)
     --correction, --no-correction, -o:   Get suggestions for correcting the original
                                          sentence (default: true)
         --rephrase, --no-rephrase, -r:   Get suggestions for rephrasing the original
                                          sentence (default: true)
                         --version, -v:   Print version and exit
                            --help, -h:   Show this message

### Output Sample

<a href="http://www.flickr.com/photos/yo_hasebe/11097279325/" title="rginger by yo_hasebe, on Flickr"><img src="http://farm4.staticflickr.com/3673/11097279325_a382163d57_o.jpg" width="383" height="255" alt="rginger"></a>

## Library Usage 

    require 'rginger'
    
    ginger = RGinger::Parser.new
    result = ginger.correct "I looking forward meet you"

    # {"original"=>"I looking forward meet you",
    # "data"=>
    #  [{"old"=>"looking",
    #    "from"=>2,
    #    "to"=>8,
    #    "reverse_from"=>-24,
    #    "reverse_to"=>-18,
    #    "new"=>"am looking"},
    #   {"old"=>"meet",
    #    "from"=>18,
    #    "to"=>21,
    #    "reverse_from"=>-8,
    #    "reverse_to"=>-5,
    #    "new"=>"to meet"}],
    # "corrected"=>"I am looking forward to meet you"}

### References

Alif Rachmawadi's [Gingerice](https://github.com/subosito/gingerice) may be a better solution than RGinger for those who do not need colored command line output and "rephrase" functionality.

### Thanks

Ginger Software for the great software and services that support learners aspiring for skills of writing good English.