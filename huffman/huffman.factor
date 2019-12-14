! Copyright (C) 2019 A. Daniel
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences combinators accessors locals assocs math hashtables math.order sorting.slots bit-arrays classes formatting prettyprint ;

IN: huffman

TUPLE: huffman-node
    weight element encoding left right ;

! For nodes which are the product of combinations
: <huffman-tnode> ( left right -- huffman )
    huffman-node new
    [ left<< ] [ swap >>right ] bi ;

! For regular nodes
: <huffman-node> ( element -- huffman )
    1 swap f f f huffman-node boa ;

: huffman-gen ( element nodes  -- )
    2dup at
    [ [ [ 1 + ] change-weight ] change-at ] 
    [ [ dup <huffman-node> swap ] dip set-at ] if ;

! Curry node-hash and inc.  Then each over the seq
! to get the weighted values
: (huffman) ( nodes seq --  nodes )
    dup [ [ huffman-gen ] curry each ] dip ;

! Generate a priority queue from the hash-table
: (huffman-queue) ( nodes -- queue )
    values  ;

: (huffman-weight) ( node1 node2 -- weight )
    [ weight>> ] dup bi* + ;

! Combine two nodes into the children of a parent
! node which has a weight equal to their collective
! weight
: (huffman-combine) ( node1 node2 -- node3 )
    [ (huffman-weight) ]
    [ <huffman-tnode> ] 2bi
    swap >>weight ;

! Generate a tree by combining nodes
! in the priority queue until we're
! left with the root node
: (huffman-tree) ( nodes -- tree )
    dup rest empty?
    [ ] [
        { { weight>> <=> } } sort-by
        [ rest rest ] [ first ]
        [ second ] tri
        (huffman-combine) prefix
        (huffman-tree)
    ] if  ; recursive

: (huffman-leaf?) ( node -- bool )
    [ left>>  huffman-node instance? ]
    [ right>> huffman-node instance? ] bi and not ;

: (huffman-leaf) ( bit leaf -- )
    swap encoding<< ;

DEFER: (huffman-encoding)

! Probably a simpler way to do this
: (huffman-node) ( bit nodes -- )
    [ 0 suffix ] [ 1 suffix ] bi
    [ [ left>> ] [ right>> ] bi ] 2dip
    [ swap ] dip
    [ (huffman-encoding) ] 2bi@ ;

: (huffman-encoding) ( bit nodes -- )
    over (huffman-leaf?)
    [ (huffman-leaf) ]
    [ (huffman-node) ] if ;

! Holy hell batman
: huffman-print ( nodes -- )
    "Element" "Weight" "Code" "\n%10s\t%10s\t%6s\n" printf
    { { weight>> >=< } } sort-by
    [  [ encoding>> ] [ element>> ] [ weight>> ] tri
       "%8c\t%7d\t\t" printf  pprint "\n" printf 
    ] each ;

: huffman ( sequence -- nodes )
    H{ } clone
    (huffman) (huffman-queue) dup
    ! save a copy of the nodes before encoding
    ! so we can easily get it back
    (huffman-tree) first { } (huffman-encoding) ;
