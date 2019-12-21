# factor-jpeg
jpeg encoding/decoder native to factor

## The Process Roadmap

### factor-jpeg0: The Naive Implementation

dct : working but needs to be written again

huffman: working -- seems pretty alright.  Apparently not necessary for decoding

quantizier: working 

marker: very naive, kind of working.  Can mostly do Huffman tables and DQT's now

TODO:

Decode DCT's 

Decode scan with huffman tables

Reverse quantization

Run IDCT on the matrices

Test with raylib

### factor-jpeg1: The Standard Implementation


### factor-jpeg2: Faster than Monkey Wu-Kong Edition


### Fields of Factor: Needs More JPEG Appendix

The Final Codex needed in explaining what the hell is going on in a JPEG encoding/decoder.  For some reason everyone has parts of an explanation but not a good full one.

You know.  I usually don't rant in incomplete english all the time.  (Although my hero of literature is Ezra Pound).  But this, this deserves a special treatment.  10 articles on jpg decoding all incomplete like holes in a bucket.  A standard that is filled with irrelevant details for implementation.  You know what the best source I've found so far is?  A weird russian site containing an article written by a college student from 20 years ago.  That's the current status of JPEG documentation.  Disgusting.  How does the modern world even exist?
