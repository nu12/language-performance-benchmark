       IDENTIFICATION DIVISION.
       PROGRAM-ID. COBOL_A.

       ENVIRONMENT DIVISION.
       INPUT-OUTPUT SECTION.
       FILE-CONTROL.
           SELECT DATABASE ASSIGN TO "db/database.dat"
               ORGANIZATION IS LINE SEQUENTIAL.
           SELECT DATA-OUT ASSIGN TO "outputs/cobol_a.csv"
               ORGANIZATION IS SEQUENTIAL
               FILE STATUS FILE-STAT.
        
       DATA DIVISION.
       FILE SECTION.           
       FD DATABASE 
           RECORD CONTAINS 10 CHARACTERS
           BLOCK 0
           DATA RECORD IS DATA-LINE
           RECORDING MODE IS F.
       01  DATA-LINE       PIC Z9(7)V99.
           
      *
       FD  DATA-OUT 
           RECORD CONTAINS 44 CHARACTERS
           BLOCK 0
           DATA RECORD IS DATA-OUT-FIELDS
           RECORDING MODE IS F.
       01  DATA-OUT-FIELDS.
           05  HIGHEST-O   PIC 9(7).99.
           05  FIL-1       PIC X.
           05  SUMM-O      PIC 9(20).99.
           05  FIL-2       PIC X.
           05  COUNT-O     PIC 9(9).

       WORKING-STORAGE SECTION.
       01  CURRENT   PIC 9(7)V99 COMP-3.
       01  HIGHEST   PIC 9(7)V99 COMP-3.
       01  SUMM      PIC 9(20)V99 COMP-3.
       01  COUNTER   PIC 9(20).
       01  LASTREC   PIC X VALUE SPACE.
       01  FILE-STAT PIC XX.

       PROCEDURE DIVISION.
       
       OPEN-FILES.
           OPEN INPUT  DATABASE.
           OPEN EXTEND DATA-OUT.
      * FILE-STAT 35 MEANS FILE DOESN'T EXIST 
           IF FILE-STAT = "35" THEN
               OPEN OUTPUT DATA-OUT
           END-IF.
           MOVE 0 TO HIGHEST.
           MOVE 0 TO SUMM.
           MOVE 0 TO COUNTER.

       READ-NEXT-RECORD.
           PERFORM READ-RECORD
            PERFORM UNTIL LASTREC = 'Y'
            PERFORM CODE-BLOCK
            PERFORM READ-RECORD
            END-PERFORM.

       WRITE-OUTPUT.
           MOVE HIGHEST TO HIGHEST-O.
           MOVE "," TO FIL-1.
           MOVE SUMM TO SUMM-O.
           MOVE "," TO FIL-2.
           MOVE COUNTER TO COUNT-O.
           WRITE DATA-OUT-FIELDS.

       CLOSE-STOP.
           CLOSE DATABASE.
           CLOSE DATA-OUT.
           STOP RUN.

       READ-RECORD.
           READ DATABASE
           AT END MOVE 'Y' TO LASTREC
           END-READ.
       
       CODE-BLOCK.
           MOVE DATA-LINE TO CURRENT.
           IF CURRENT > HIGHEST THEN
            MOVE CURRENT TO HIGHEST
           END-IF.
           ADD CURRENT TO SUMM GIVING SUMM.
           ADD 1 TO COUNTER GIVING COUNTER.