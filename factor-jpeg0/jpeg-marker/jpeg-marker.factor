! Copyright (C) 2019 A. Daniel
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences combinators io.files io.encodings.binary grouping io.binary math.parser math assocs sequences.deep splitting sequences.extras ;
IN: jpeg-marker

! Bad code.  Going to put it on github to keep it organized anyway.
! Slow.  Need to rewrite marker detection to handle stuff bytes 0xFF00

! TODO: Add reference material because this stuff is so poorly explained everywhere

TUPLE: jpg-header
    quant-table huffman scan ;

: <jpg-header> ( quant huffman scan -- jpg-header )
    jpg-header boa ;

: jpg-markers ( -- markers )
    { { "c0" "[HUFFMAN/Non-Diff] Baseline DCT"                    } 
      { "c1" "[HUFFMAN/Non-Diff] Extended sequential DCT"         }
      { "c2" "[HUFFMAN/Non-Diff] Progressive DCT"                 }
      { "c3" "[HUFFMAN/Non-Diff] Lossless (sequential)"           }
      { "c5" "[HUFFMAN] Differential sequential DCT"              }
      { "c6" "[HUFFMAN] Differential progressive DCT"             }
      { "c7" "[HUFFMAN]  Differential lossless (sequential)"      }
      { "c8" "[ARITHMETIC/Non-Diff] Reserved for JPEG extensions" }
      { "c9" "[ARITHMETIC/Non-Diff] Extended sequential DCT"      }
      { "ca" "[ARITHMETIC/Non-Diff] Progressive DCT"              }
      { "cb" "[ARITHMETIC/Non-Diff] Lossless (sequential)"        }
      { "cd" "[ARITHMETIC] Differential sequential DCT"           }
      { "ce" "[ARITHMETIC] Differential progressive DCT"          }
      { "cf" "[ARITHMETIC] Differential lossless (sequential)"    }
      { "c4" "Define Huffman table(s)"                            }
      { "cc" "Define arithmetic coding conditioning(s)"           }
      ! Weird modulo crap
      { "d0" "Restart with modulo 8 count 0"                      }
      { "d1" "Restart with modulo 8 count 1"                      }
      { "d2" "Restart with modulo 8 count 2"                      }
      { "d3" "Restart with modulo 8 count 3"                      }
      { "d4" "Restart with modulo 8 count 4"                      }
      { "d5" "Restart with modulo 8 count 5"                      }
      { "d6" "Restart with modulo 8 count 6"                      }
      { "d7" "Restart with modulo 8 count 7"                      }
      ! Other markers
      { "d8" "Start of image"                                     }
      { "d9" "End of image"                                       }
      { "da" "Start of scan"                                      }
      { "db" "Define quantization table(s)"                       }
      { "dc" "Define number of lines"                             }
      { "dd" "Define restart interval"                            }
      { "de" "Define heirarchical progression"                    }
      { "df" "Expand reference component(s)"                      }
      ! Skipping Reserved for application segments
      ! and Reserved for JPEG extensions
      { "fe" "Comment"                                            }
      { "01" "For temporary private use in arithmetic coding"     } } ;

: (read-jpg-contents) ( path -- contents )
    binary file-contents 1 group flatten [ >hex ] map ;

! Split markers
! Find the first 0xFF
! If it is followed by 0x00 then ignore it
! If it is 
! Simplify

: (marker) ( index seq -- val/f )
    [ 1 + ] dip nth jpg-markers at ;

: (markers-from-seq) ( seq -- seq' )
    dup [ "ff" = ] find-all [ first ] map ! Generate indexes of 0xFF
    swap [ (marker) ] curry filter ;
    
: (marker-split) ( seq -- seq' )
    dup (markers-from-seq) split-indices ;

: (markers) ( seq -- seq' )
    (marker-split)
    [ empty? ] reject
    [ rest ] map
    [ [ first jpg-markers at ] map ]
    [ [ rest ] map ] bi zip but-last ! Remove EOS ;
