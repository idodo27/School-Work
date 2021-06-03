
; MULTI-SEGMENT EXECUTABLE FILE TEMPLATE.

DSEG SEGMENT
    MSG1 DB 'PRESS ANY KEY TO START THE GAME$'
    MSG2 DB 'ENTER YOUR GUESS (4 DIGITS): $'
    MSG3 DB 'INVALID GUESS$'
    MSG4 DB 'WINNER + NUMOFGUESS: $'
    MSG5 DB 'NUMBER OF BULLSEYES/HITS: $' ;(AFTER EACH GUESS)
    MSG6 DB 'ZERO CANT BE THE FIRST NUMBER IN YOUR GUESS$'
    MSG7 DB 'YOU HAVE ENTERED THE SAME DIGIT TWICE.$'
    MSG8 DB 'TRY AGAIN$'
    MSG9 DB 'YOU HAVE LOST THE GAME, NUMBER OF TRIES: $'
    RES1 DB 'YOU HAVE $' 
    RES2 DB ' BULLSEYES & $'
    RES3 DB ' HITS$'
    RES4 DB 'THE NUMBER WAS: $'
    LOST DB ' 13$'
    
    HITCOUNTER DB 0H
    BULLCOUNTER DB 0H
    
    TRIES DB 0H
    
    
    
    DIGTOCHECK DB ?
    RESTCOUNTER DB 0H           
    VALIDDIGITCOUNTER DB 0H
    CHECKCOUNTER DB 0H
    COUNTER DB 0H              
    
    COMPUTERNUM DB 0,0,0,0
    USERGUESS DB 4+1,4+2 DUP (?)
DSEG ENDS

SSEG SEGMENT    
    
    DW   128  DUP(0)

SSEG ENDS

CSEG SEGMENT
ASSUME DS:DSEG,SS:SSEG,CS:CSEG

START:

    MOV AX, DSEG
    MOV DS, AX

    

PROGRAM_START:
;THIS PRINTS THE STRING 'STARTMSG' ON THE SCREEN   
                MOV DX, OFFSET MSG1
                MOV AH, 9
                INT 21H            
                MOV DL, 10
                MOV AH, 02H
                INT 21H
                MOV DL, 13
                MOV AH, 02H
                INT 21H
;THIS ASKS FOR USER INPUT WITHOUT SHOWING THE CHAR ON SCREEN.
                MOV AH, 7
                INT 21H 
                
    
RANDOM_NUMBER:
                MOV CX, 0004H
 
                CALL GENERATE
                MOV CX, 4 ; TO RESET THE COUNTER TO CHECK THE ARRAY FOR SAME NUMBERS
                MOV COUNTER, 0
                XOR AX, AX
                XOR DX, DX
                 
BACK:           JMP FINISHED_RANDOM
                
                               
                 
                
GENERATE:
               
               XOR AX,AX
               MOV AH,2CH
               INT 21H
               MOV AX,DX
               XOR DX,DX
               MOV BX, 000AH
               DIV BX
               MOV DIGTOCHECK, DL
               XOR BX,BX
               MOV BL, COUNTER
               MOV BYTE PTR COMPUTERNUM +[BX], DL
               CMP COUNTER, 00H
               MOV CHECKCOUNTER, 0
               JE FIRST_DIGIT_CHECK
               JNE DIGIT_CHECKER  
               
               
RETURNFROM:    
               MOV CX, 4
               
               INC COUNTER
               CMP COUNTER, 4
               JNE GENERATE
               JE FINISHED_RANDOM
               

               
FIRST_DIGIT_CHECK:
               CMP COMPUTERNUM[0] , 00H
               JE GENERATE
               JNE RETURNFROM
                            

                
                
                
DIGIT_CHECKER: 
                CMP CHECKCOUNTER, 04H
                JE RETURNFROM
                XOR BX, BX
                MOV BL, CHECKCOUNTER 
                INC CHECKCOUNTER
                CMP BL, COUNTER
                JE RETURNFROM 
                MOV AL, DIGTOCHECK
                CMP AL, BYTE PTR COMPUTERNUM + [BX]
                
                JE GENERATE
                JMP DIGIT_CHECKER


     
 
FINISHED_RANDOM:            ;PRINT MSG2:               
            MOV DX, OFFSET MSG2
            MOV AH, 9
            INT 21H
            MOV DL, 10
            MOV AH, 02H
            INT 21H
            MOV DL, 13
            MOV AH, 02H
            INT 21H         ;INPUT USER GUESS:
            MOV DX, OFFSET USERGUESS
            MOV AH, 0AH
            INT 21H
            MOV CX, 4
            MOV DL, 13
            MOV AH, 02H
            INT 21H
            MOV CHECKCOUNTER, 02H
            CALL INPUT_CHECK
                            ; USERGUESS = INPUT (FROM INDEX 2 TO 5>
            MOV COUNTER, 2H
            XOR BX, BX
            MOV BL, COUNTER
            JMP OUTER_LOOP

INPUT_CHECK:
            XOR BX, BX
            CMP CHECKCOUNTER, 06H
            JE HITS_AND_BULLS
            
            MOV BL, CHECKCOUNTER

            MOV AL, BYTE PTR USERGUESS + BX
            SUB AL, 30H
           
            MOV RESTCOUNTER, 02h
            CMP BL, 02H
            
            JE ZERO_CHECK
            
            
            JNE REST_OF_INPUT_CHECK
                
            
           

            RET 1
REST_OF_INPUT_CHECK:
            CMP RESTCOUNTER, 06H
            JE INC_CHECK_COUNTER
            XOR BX, BX
            MOV BL, RESTCOUNTER
            INC RESTCOUNTER
            MOV AH, BYTE PTR USERGUESS + BX
            SUB AH, 30h
            
            
            CMP BL, CHECKCOUNTER           
            JE  REST_OF_INPUT_CHECK            
            CMP AL, AH
            JE REPEATED_DIGITS_INPUT

            
            
            
            JNE REST_OF_INPUT_CHECK  

INC_CHECK_COUNTER:
            INC CHECKCOUNTER
            JMP INPUT_CHECK


    
REPEATED_DIGITS_INPUT:
            MOV DL, 10
            MOV AH, 02H
            INT 21H
            MOV DL, 13
            MOV AH, 02H
            INT 21H ;INPUT USER GUESS:
            MOV DX, OFFSET MSG3
            MOV AH, 9
            INT 21H
            MOV DL, 10
            MOV AH, 02H
            INT 21H
            MOV DL, 13
            MOV AH, 02H
            MOV DX, OFFSET MSG7  ;MSG7
            MOV AH, 9
            INT 21H
            MOV DL, 10
            MOV AH, 02H
            INT 21H
            MOV DL, 13
            MOV AH, 02H
            INT 21H
            JMP FINISHED_RANDOM


            


ZERO_CHECK: 

            
            
            
            CMP AL, 00H
            
            JNE REST_OF_INPUT_CHECK
            MOV DL, 10
            MOV AH, 02H
            INT 21H
            MOV DL, 13
            MOV AH, 02H
            INT 21H
            MOV DX, OFFSET MSG6
            MOV AH, 9
            INT 21H
            MOV DL, 10
            MOV AH, 02H
            INT 21H
            MOV DL, 13
            MOV AH, 02H
            INT 21H
            
            
            
            JMP FINISHED_RANDOM

HITS_AND_BULLS:
            MOV BX, 01H
            
OUTER_LOOP: 
            INC BX
            CMP BX, 06H
            JE HITCHECK
            XOR AX, AX
            MOV AL, BYTE PTR USERGUESS + [BX] ; AL = USERGUESS[2]
            SUB AL, 30H ; TO EQUALIZE
            
            MOV DI, 0
            
    INNER_LOOP:            
            
            CMP DI, 4
            JE OUTER_LOOP
            MOV AH, BYTE PTR COMPUTERNUM + [DI]; AH=  COMPUTERNUM[0]
            
            
            CMP AL, AH
            JE HIT
            INC DI
            JNE INNER_LOOP

HIT:
            SUB BX, 02H             
            CMP DI, BX
            JE BULLS_EYE
            INC DI
            ADD BX, 02H
            
            INC HITCOUNTER
            JMP INNER_LOOP
                
BULLS_EYE:                
          INC DI
          ADD BX, 02H
          
          INC BULLCOUNTER
          JMP INNER_LOOP
                
                


HITCHECK:
         
         CMP HITCOUNTER, 0
         JE BULLCHECK      
         

BULLCHECK:
         INC TRIES
         CMP BULLCOUNTER, 4
         JE WINNER
         
PRINT_RES:  
            
            
            MOV DX, OFFSET RES1
            MOV AH, 9
            INT 21H
             
            MOV AL, BULLCOUNTER
            ADD AL, 30H
            MOV DL, AL ;MSG7
            MOV AH, 2
            INT 21H
            MOV DX, OFFSET RES2
            MOV AH, 9
            INT 21H
           
            MOV AL, HITCOUNTER
            ADD AL, 30H
            MOV DL, AL
            MOV AH, 2
            INT 21H 
            MOV DX, OFFSET RES3
            MOV AH, 9
            INT 21H  
            
            MOV DL, 10
            MOV AH, 02H
            INT 21H
            MOV DL, 13
            MOV AH, 02H
            INT 21H                    
            
            
    
GAME_OVER:  
             
            CMP TRIES, 13
            
            JE LOSER
            MOV DX, OFFSET MSG8
            MOV AH, 9
            INT 21H
            MOV DL, 10
            MOV AH, 02H
            INT 21H
            MOV DL, 13
            MOV AH, 02H
            INT 21H 
            MOV BULLCOUNTER, 0
            MOV HITCOUNTER, 0
            JNE FINISHED_RANDOM
           
            
            MOV AX, 4C00H ; EXIT TO OPERATING SYSTEM.
            INT 21H    
        

CONVERTER: 
           
           MOV BX, 16
           XOR AX, AX
           MOV AL, TRIES
           ADD AL, 6    ;if tries is bigger then 10, we add 6 so it will count as decimal
                        ;division for the division of the number of tries for printing
           XOR DX, DX
           DIV BX
           MOV BH, DL
           MOV BL, AL
           ADD BL, 30H
           MOV DL, BL ;MSG7
           MOV AH, 2
           INT 21H               
           ADD BH, 30H
           MOV DL, BH ;MSG7
           MOV AH, 2
           INT 21H
           JMP CONTINUE

WINNER:
            
            MOV DX, OFFSET MSG4
            MOV AH, 9
            INT 21H 
            CMP  TRIES, 10
            JA CONVERTER
            
            MOV AL, TRIES
            ADD AL, 30H
            MOV DL, AL ;MSG7
            MOV AH, 2
            INT 21H
            
   CONTINUE:
            MOV BX, 00H
            MOV DL, 10
            MOV AH, 02H
            INT 21H
            MOV DL, 13
            MOV AH, 02H
            INT 21H
            MOV DX, OFFSET RES4
            MOV AH, 9
            INT 21H 
            PRINT_NUM:     
                     MOV AL, COMPUTERNUM + BX
                     INC BX
                     ADD AL, 30H
                     MOV DL, AL ;MSG7
                     MOV AH, 2
                     INT 21H
                     CMP BX, 4
                     JNE PRINT_NUM
            MOV AX, 4C00H ; EXIT TO OPERATING SYSTEM.
            INT 21H 

LOSER: 
            MOV DX, OFFSET MSG9
            MOV AH, 9
            INT 21H 
            MOV DX, OFFSET LOST
            MOV AH, 9
            INT 21H
            MOV AX, 4C00H ; EXIT TO OPERATING SYSTEM.
            INT 21H

CSEG ENDS

END START ; SET ENTRY POINT AND STOP THE ASSEMBLER.

