
       Ctl-Opt DFTACTGRP(*NO) ACTGRP(*NEW);

       Dcl-S X Char(2);
       Dcl-S O Char(2);

       Dcl-F TTTDSP Workstn;
       Dcl-S gGrid  Char(2) Dim(9);
       Dcl-S gTurn  Char(2);
       Dcl-S gExit  Ind;

       Dcl-S gAIT   Ind; //AI turn?

       X     = x'3A' + 'X';
       O     = x'28' + 'O';
       gTurn = X;
       gExit = *Off;
       gAIT  = *Off;

       Board_Reset();
       Dow (gExit = *Off);
         Game_Turn(); //Switch turn
         Board_Turn(gTurn:gAIT);
         Board_GridUpdate();
         Board_CheckWinner(gTurn);
         Board_CheckNoWin();
       ENDDO;

       *InLR = *On;
       Return;

       //*************************

       Dcl-Proc Board_Reset;
         gGrid(1) = '1';
         gGrid(2) = '2';
         gGrid(3) = '3';
         gGrid(4) = '4';
         gGrid(5) = '5';
         gGrid(6) = '6';
         gGrid(7) = '7';
         gGrid(8) = '8';
         gGrid(9) = '9';
         Board_GridUpdate();
       END-PROC;

       //*************************

       Dcl-Proc Board_GridUpdate;
         P1 = gGrid(1);
         P2 = gGrid(2);
         P3 = gGrid(3);
         P4 = gGrid(4);
         P5 = gGrid(5);
         P6 = gGrid(6);
         P7 = gGrid(7);
         P8 = gGrid(8);
         P9 = gGrid(9);

         POS = ' ';
       END-PROC;

       //************************

       Dcl-Proc Game_Turn; //Current turn
         Dcl-Pi *N Char(2) End-Pi;

         If (gTurn = X);
           gTurn = O;
         Else;
           gTurn = X;
         ENDIF;

         Return gTurn;
       END-PROC;

       //************************

       Dcl-Proc Board_Turn; //Player move
         Dcl-Pi *N;
           pTurn Char(2) Const;
           pAI   Ind     Const;
         END-PI;
         Dcl-S lExit  Ind;
         Dcl-S lValid Ind;
         Dcl-S lIndex Int(3);

         lExit = *Off;

         TEXT = pTurn + ' to move.';

         If (pAI);
           //If it's an AI move
         ENDIF;

         Dow (lExit = *Off);
           EXFMT Main;

           Select;
             When (*In03); //F3
               gExit = *On;
               lExit = *On;

             Other; //Enter
               Monitor;
                 lIndex = %Int(POS);

                 lValid = (gGrid(lIndex) <> X AND
                           gGrid(lIndex) <> O);

                 If (lValid);
                   gGrid(lIndex) = pTurn;
                   lExit = *On;
                 Else;
                 TEXT = 'Please valid space.';
                 ENDIF;
               On-Error;
                 TEXT = 'Please enter 1-9.';
               ENDMON;

           ENDSL;
         Enddo;

       END-PROC;

       //************************

       Dcl-Proc Board_CheckWinner;
         Dcl-Pi *N;
           pTurn Char(2) Const;
         END-PI;

         Dcl-S lWinner Ind Inz(*Off);

         If (gGrid(1) = pTurn AND
             gGrid(2) = pTurn AND
             gGrid(3) = pTurn);
           lWinner = *On;
         ENDIF;

         If (gGrid(4) = pTurn AND
             gGrid(5) = pTurn AND
             gGrid(6) = pTurn);
           lWinner = *On;
         ENDIF;

         If (gGrid(7) = pTurn AND
             gGrid(8) = pTurn AND
             gGrid(9) = pTurn);
           lWinner = *On;
         ENDIF;

         If (gGrid(1) = pTurn AND
             gGrid(4) = pTurn AND
             gGrid(7) = pTurn);
           lWinner = *On;
         ENDIF;

         If (gGrid(2) = pTurn AND
             gGrid(5) = pTurn AND
             gGrid(8) = pTurn);
           lWinner = *On;
         ENDIF;

         If (gGrid(3) = pTurn AND
             gGrid(6) = pTurn AND
             gGrid(9) = pTurn);
           lWinner = *On;
         ENDIF;

         If (gGrid(1) = pTurn AND
             gGrid(5) = pTurn AND
             gGrid(9) = pTurn);
           lWinner = *On;
         ENDIF;

         If (gGrid(3) = pTurn AND
             gGrid(5) = pTurn AND
             gGrid(7) = pTurn);
           lWinner = *On;
         ENDIF;

         If (lWinner = *On);
           WINTEXT = pTurn + ' is the winner.';
           EXFMT WIN;
           Board_Reset();
         ENDIF;
       END-PROC;

       //***************************

       Dcl-Proc Board_CheckNoWin;
         Dcl-S lReset Ind;
         Dcl-S lIndex Int(3);

         lReset = *On;

         For lIndex = 1 to 9;
           If (gGrid(lIndex) = %Char(lIndex));
             lReset = *Off;
           ENDIF;
         ENDFOR;

         If (lReset);
           Board_Reset();
         ENDIF;
       END-PROC; 
