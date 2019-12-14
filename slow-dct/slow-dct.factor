! Copyright (C) 2019 A. Daniel
! See http://factorcode.org/license.txt for BSD license.
USING: kernel sequences math locals math.constants math.functions  ;
IN: slow-dct

! This is an extremely naive dct attempt
! Gotta write it wrong first to write it
! better later right?

: matrix ( -- matrix )
    { { 144 139 149 155 153 155 155 155 }
      { 151 151 151 159 156 156 156 158 }
      { 151 156 160 162 159 151 151 151 }
      { 158 163 161 160 160 160 160 161 }
      { 158 160 161 162 160 155 155 156 }
      { 161 161 161 161 160 157 157 157 }
      { 162 162 161 160 161 157 157 157 }
      { 162 162 161 160 163 157 158 154 } } ;

: matrix2 ( -- matrix )
    { { 16  11  10  16  24  40  51  61 }
      { 12  12  14  19  26  58  60  55 }
      { 14  13  16  24  40  57  69  56 }
      { 14  17  22  29  51  87  80  62 }
      { 18  22  37  56  68 109 103  77 }
      { 24  35  55  64  81 104 113  92 }
      { 49  64  78  87 103 121 120 101 }
      { 72  92  95  98 112 100 103  99 } } ;

: quanti-matrix ( -- matrix )
    { { 5 3 4 4 4 3 5 4 } 
      { 4 4 5 5 5 6 7 12 } 
      { 8 7 7 7 7 15 11 11 } 
      { 9 12 13 15 18 18 17 15 } 
      { 20 20 20 20 20 20 20 20 } 
      { 20 20 20 20 20 20 20 20 } 
      { 20 20 20 20 20 20 20 20 } 
      { 20 20 20 20 20 20 20 20 } } ;

: matrix-x-cos ( x u -- n )
    pi * [ 2.0 * 1 + ] dip * 16 / cos  ;

:: matrix-uv-summand ( v u res -- res )
    v u res
    [ 0 = [ 1 2 sqrt / ] [ 1 ] if ] dip
    [ 0 = [ 1 2 sqrt / ] [ 1 ] if ] 2dip
    [ 1 4.0 / * * ] dip *
    u quanti-matrix nth v swap nth / floor
    ;

:: matrix-elem ( y x v u matrix -- matrix-elem )
    x matrix nth y swap nth
    x u matrix-x-cos 
    y v matrix-x-cos * * ;
    
: matrix-y ( x v u matrix -- matrix-y-n )
    [ matrix-elem ] 3curry curry
    { 0 1 2 3 4 5 6 7 } swap
    [ + ]
    map-reduce ;

: matrix-x ( v u matrix -- matrix-x-n )
    [ matrix-y ] 3curry
    { 0 1 2 3 4 5 6 7 } swap
    [ + ]
    map-reduce ;

: matrix-v ( u matrix -- matrix-v-n )
    [ [ 2dup ] dip matrix-x
    matrix-uv-summand ] 2curry
    { 0 1 2 3 4 5 6 7 } swap
    map ;

: matrix-dtc ( matrix -- matrix' )
    [ matrix-v ] curry
    { 0 1 2 3 4 5 6 7 } swap
    map ;


! u/v pairs { { 0 0 } { 0 1 } { 0 2 }
! { 1 0 } { 1 1 }

