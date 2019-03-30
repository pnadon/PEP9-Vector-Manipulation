;; VectorManipulation.pep
;; 
;; AUCSC 250
;; OCT 30, 2018
;; Philippe Nadon
;;
;; A simple program for manipulating vectors
;; Starting method is main


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; METHODS HEADER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;
;; void main(): 
;;       Entry method, runs program
;;
;; void inVect ( int size, int[] vector):
;;       Obtains vector contents from user     
;;
;; void prinVect ( int size, int[] vector):
;;     Prints the vector
;;
;; void rotLeft ( int size, int[] vector):
;;     Shifts the vector's cells left
;;
;; void rotRight ( int size, int[] vector):
;;     Shifts the vector's cells right
;;
;; boolean exchange ( int loc1, int loc2,
;;            int size, int[] vector):
;;     Swaps vector[ loc1] and vector[ loc2]
;;
;; boolean chckInpt (int size), A = loc1, X = loc2:
;;     Ensures loc1 and loc2 are valid
;;
;; int malloc (), A = size:
;;     Moves the heap pointer to allocate
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

true: .EQUATE 1
false: .EQUATE 0

CALL main
STOP

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; void main ()
;;
;; Prompts for inputs and runs corresponding 
;; methods
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
size: .EQUATE 0 ;local var #2d
vector: .EQUATE 2;local var #2h
inptSize: .EQUATE -4; input param #2d
inptVect: .EQUATE -2; input param #2d
main:SUBSP 4,i ;push #vector #size

STRO sizeMsg, d 
DECI size, s
LDWA size, s
CPWA 0, i
BRGT allocVec, i
LDWA 1, i

allocVec: ASLA
STWA size, s
CALL malloc
STWX vector, s

; call inVect
LDWA size, s
STWA inptSize, s; -4 on SP

LDWA vector, s
STWA inptVect, s; -2 on SP
 
SUBSP 4, i ; push #vector #size
CALL inVect
ADDSP 4,i ;pop #vector #size 

;; call to prinVect
mLoop: LDWA size, s
STWA inptSize, s; -4 on SP

LDWA vector, s
STWA inptVect, s; -2 on SP 

SUBSP 4, i ; push #vector #size
CALL prinVect 
ADDSP 4,i ;pop #vector #size

STRO cmdPrmpt, d

; Evaluate input and branch
LDBX charIn, d ;Extra char in charIn 
SUBX 'E', i
BRLT caseErr, i 
CPWX 45, i 
BRGT caseErr, i
ASLX
BR choiceJT, x

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Default case
caseErr: STRO errInput, d 
LDBX charIn, d ;Extra char in charIn 
BR mLoop, i

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Case E / e: call exchange
inptLoc1: .EQUATE -8; input param for exchange #2h
inptLoc2: .EQUATE -6; input param for exchange #2h
caseE: STRO xchngMsg, d
DECI inptLoc1, s
LDWA inptLoc1, s
ADDA inptLoc1, s ; double the index
STWA inptLoc1, s

DECI inptLoc2, s
LDWA inptLoc2, s
ADDA inptLoc2, s ; double the index
STWA inptLoc2, s

LDWA size, s
STWA inptSize, s; -4 on SP

LDWA vector, s
STWA inptVect, s; -2 on SP

SUBSP 8, i ; push #exLoc2 #exLoc1 #vector #size
CALL exchange
ADDSP 8,i ;pop #exLoc2 #exLoc1 #vector #size

; check if input was valid
CPWX false, i
BRGT CaseEEnd, i

STRO errExMsg, d 

CaseEEnd: BR mLoop, i

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Case L / l: call rotLeft
caseL: LDWA size, s
STWA inptSize, s; -4 on SP

LDWA vector, s
STWA inptVect, s; -2 on SP 

SUBSP 4, i ; push #vector #size
CALL rotLeft
ADDSP 4,i ;pop #vector #size

LDBX charIn, d ;Extra char in charIn
BR mLoop, i

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
; Case Q / q: print quit message and return from main
caseQ: STRO exitMsg, d 

LDWA size, s
STWA inptSize, s; -4 on SP

LDWA vector, s
STWA inptVect, s; -2 on SP 

SUBSP 4, i ; push #vector #size
CALL prinVect 
ADDSP 4,i ;pop #vector #size

ADDSP 4,i ;pop #vector #size
RET ;main

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; Case R / r: call rotRight
caseR: LDWA size, s
STWA inptSize, s; -4 on SP

LDWA vector, s
STWA inptVect, s; -2 on SP 

SUBSP 4, i ; push #vector #size
CALL rotRight
ADDSP 4,i ;pop #vector #size

LDBX charIn, d ;Extra char in charIn 
BR mLoop, i



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; void inVect (int size, int[] vector)
;;
;; Takes inputs size and int[] vector, and 
;; fills each cell of the vector until the end 
;; is reached
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
index: .EQUATE 0; local parameter #2d
inSize: .EQUATE 4 ;formal parameter #2d
inVector: .EQUATE 6 ;formal parameter #2h
inVect: SUBSP 2, i ; push #index
LDWX 0, i
inVLoop: ASRX
ADDX 1, i

STRO inVectP1, d
STWX index, s
DECO index, s
STRO inVectP2, d

SUBX 1, i
ASLX
DECI inVector, sfx
ADDX 2, i
CPWX inSize, s
BRLT inVLoop, i
ADDSP 2, i ; pop #index
RET ;inVect



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; void prinVect (int size, int[] vector)
;; 
;; Takes inputs size and int[] vector, and 
;; prints each cell of the vector until the end
;; is reached
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;index: .EQUATE 0; local parameter
;inSize: .EQUATE 4 ;formal parameter
;inVector: .EQUATE 6 ;formal parameter
prinVect: SUBSP 2, i ; push #index
LDWX 0, i
STRO newLine, d
prinLoop: DECO inVector, sfx 

STRO spcIsSpc, d

ADDX 2, i
CPWX inSize, s
BRLT prinLoop, i

ADDSP 2, i ; pop #index
RET ;prinVect



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; boolean exchange (int size, int[] vector, 
;;               int exLoc1, int exLoc2)
;; 
;; Takes inputs size, int[] vector, int exLoc1, 
;; and int exLoc2, and swaps the two cells in 
;; vector defined by the values of exLoc1 and 
;; exLoc2, which represent indices
;;
;; Returns false via index register if exLoc1 or 
;; exLoc2 were invalid, true otherwise
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
chInSize: .EQUATE -2; chckInput param #2d
exVal: .EQUATE 0; local var #2d
exLoc1: .EQUATE 4 ; formal param #2d
exLoc2: .EQUATE 6 ; formal param #2d
exSize: .EQUATE 8; formal param #2d
exVect: .EQUATE 10; formal param #2h
exchange: SUBSP 2, i ;push #exVal 

; Call chckInput (int chckSize), A = exLoc1, X = exLoc2
LDWA exSize, s
STWA chInSize, s

LDWA exLoc1, s
LDWX exLoc2, s

SUBSP 2, i ;push #exSize 
CALL chckInpt
ADDSP 2, i; pop #exSize 

CPWX 0, i
BRLE xchngEnd

; Store exVect[ exLoc1] in exVal
LDWX exLoc1, s
LDWA exVect, sfx
STWA exVal, s

; Store exVect[ exLoc2] in exVect[ exLoc1]
LDWX exLoc2, s
LDWA exVect, sfx
LDWX exLoc1, s
STWA exVect, sfx

; Store exVal in exVect[ exLoc2]
LDWX exLoc2, s
LDWA exVal, s
STWA exVect, sfx 

; X = 1 if valiud input, 0 otherwise
LDWX true, i
xchngEnd: ADDSP 2, i ;pop #tempVal 
RET ;exchange



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; boolean chckInpt (int size)
;;
;; Takes int size via a parameter and int exLoc1
;; and int exLoc2 via accumulator and index 
;; register respectively
;;
;; Checks to see if exLoc1 and exLoc2 refer
;; to valid indices for a vector with a length
;; of size
;;
;; Returns 0 via index register if exLoc1 or exLoc2
;; were invalid, 1 otherwise
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
chckSize: .EQUATE 2; formal param #2d 
chckInpt: CPWX 0, i
BRLT badChck, i
ADDX 2, i
CPWX chckSize, s
BRGT badChck, i

CPWA 0, i
BRLT badChck, i
ADDA 2, i
CPWA chckSize, s
BRGT badChck, i

; no invalid input checks triggered
LDWX true, i
RET ;checkInpt

; invalid input check triggered
badChck: LDWX false, i
RET ;chckInput



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; void rotLeft (int size, int[] vector)
;; 
;; Takes inputs size and int[] vector, and 
;; sequentially replaces the next cell in
;; vector with the previous cell's content
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;index: .EQUATE 0
tempVal: .EQUATE 2 ; local param #2d
rotSize: .EQUATE 6 ; formal param #2d
rotVect: .EQUATE 8 ; formal param #2h
rotLeft: SUBSP 4, i ; push #vector #size 
LDWA rotVect, sf
STWA tempVal, s
LDWX 2, i

rotLLoop: CPWX rotSize, s
BRGE rotLEnd

LDWA rotVect, sfx
SUBX 2, i
STWA rotVect, sfx
ADDX 4, i
BR rotLLoop

rotLEnd: SUBX 2, i
LDWA tempVal, s
STWA rotVect, sfx
ADDSP 4, i ; pop #vector #size
RET ;rotLeft



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; void rotRight (int size, int[] vector)
;; 
;; Takes inputs size and int[] vector, and 
;; sequentially replaces the previous cell 
;; in vector with the next cell's content
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;index: .EQUATE 0
;tempVal: .EQUATE 2 ; local param 
;rotSize: .EQUATE 6 ; formal param
;rotVect: .EQUATE 8 ; formal param
rotRight: SUBSP 4, i ; push #vector #size
LDWX rotSize, s
SUBX 2, i 
LDWA rotVect, sfx
STWA tempVal, s

rotRLoop: CPWX 0, i
BRLE rotREnd

SUBX 2, i
LDWA rotVect, sfx
ADDX 2, i
STWA rotVect, sfx
SUBX 2, i
BR rotRLoop

rotREnd: LDWA tempVal, s 
STWA rotVect, sf
ADDSP 4, i ; pop #vector #size
RET ;rotRight



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; int malloc ()
;;
;; Takes int size via accumulator, and adds its
;; value to the heap pointer, thus reserving 
;; room for the new object
;;
;; Returns the new object's address within the
;; heap, via the index register
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
malloc: LDWX hpPtr, d
ADDA hpPtr, d
STWA hpPtr, d
RET



;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; OUTPUT MESSAGES
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

sizeMsg: .ASCII "How big is your vector? \x00"
cmdPrmpt: .ASCII "\n\nEnter command.  L = left R = right E = exchange Q = quit \x00"
errExMsg: .ASCII "\nCaution: Out of Bounds Exchange Attempted\n\x00"
errInput: .ASCII "\nIncorrect choice. Try again.\n\x00"
xchngMsg: .ASCII "\nExchange which 2 locations?\n\x00"
exitMsg: .ASCII "\nBye bye\x00"
inVectP1: .ASCII "\n[\x00"
inVectP2: .ASCII "]: \x00"
spcIsSpc: .ASCII " \x00"
newLine: .ASCII "\n\x00" 

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; JUMP TABLE
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

choiceJT: .ADDRSS caseE ; 'E' input
.ADDRSS caseErr
.ADDRSS caseErr
.ADDRSS caseErr  ; 'H' input
.ADDRSS caseErr
.ADDRSS caseErr
.ADDRSS caseErr  ; 'K' input
.ADDRSS caseL  ; 'L' input
.ADDRSS caseErr
.ADDRSS caseErr
.ADDRSS caseErr  ; 'O' input
.ADDRSS caseErr
.ADDRSS caseQ  ; 'Q' input
.ADDRSS caseR  ; 'R' input
.ADDRSS caseErr
.ADDRSS caseErr 
.ADDRSS caseErr  ; 'U' input
.ADDRSS caseErr
.ADDRSS caseErr
.ADDRSS caseErr  ; 'X' input
.ADDRSS caseErr
.ADDRSS caseErr
.ADDRSS caseErr  ; '[' input
.ADDRSS caseErr
.ADDRSS caseErr
.ADDRSS caseErr  ; '^' input
.ADDRSS caseErr
.ADDRSS caseErr
.ADDRSS caseErr  ; 'a' input
.ADDRSS caseErr
.ADDRSS caseErr
.ADDRSS caseErr  ; 'd' input
.ADDRSS caseE  ; 'e' input
.ADDRSS caseErr
.ADDRSS caseErr
.ADDRSS caseErr  ; 'h' input
.ADDRSS caseErr
.ADDRSS caseErr
.ADDRSS caseErr  ; 'k' input
.ADDRSS caseL  ; 'l' input
.ADDRSS caseErr
.ADDRSS caseErr
.ADDRSS caseErr  ; 'o' input
.ADDRSS caseErr
.ADDRSS caseQ  ; 'q' input
.ADDRSS caseR  ; 'r' input

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;; HEAP & HEAP POINTER
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

hpPtr: .ADDRSS heap
heap: .BLOCK 1
.END