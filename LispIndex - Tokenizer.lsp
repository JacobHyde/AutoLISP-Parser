;LispIndex - Tokenizer.lsp
;Function to tokenize a complete .lsp file

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun TokenizeLispFile (File / F ScanMode CurrentWord
						 ThisChar NextChar
						 TokenList

						 LispParse:CleanLineComment LispParse:CleanBlockComment
						 LispParse:RemoveLeadingAndTrailingWhitespace
						 LispParse:IsUselessString LispParse:IsAllWhitespace
						 LispParse:IsAllNewLine LispParse:AddToTokenList
						 LispParse:AddToCurrentWord LispParse:GetNextChar
						 )


  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun LispParse:CleanLineComment (Str / )
	(STR:RemoveTrailingChar
	  (STR:RemoveLeadingChar CurrentWord ";")
	  ";"
	  )
	);end defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun LispParse:CleanBlockComment (Str / Cnt Len CurrChar Mode ResStr)
	(setq Str (substr Str 1 (1- (strlen Str))))	;There's a | at the end, remove it.

	;;;Replace all combinations of \t and spaces with a single space
	(setq Cnt 0
		  Len (strlen Str)
		  Mode "NONE"
		  ResStr ""
		  );end setq

	(while (<= (Setq Cnt (1+ Cnt)) Len)
	  (if (vl-position (setq CurrChar (substr Str Cnt 1)) (vl-remove "\n" LispParse:WhiteSpace))
		(Setq Mode "WS")
		(setq ResStr (strcat ResStr
					   (if (= Mode "WS") " " "")
					   CurrChar
					   )
			  Mode "NONE"
			  );end setq
		);end if
	  );end while

	(LispParse:RemoveLeadingAndTrailingWhitespace ResStr)
	);end defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun LispParse:RemoveLeadingAndTrailingWhitespace (Str / )
	(Setq RT Str)
	(while (vl-position (substr Str 1 1) LispParse:Whitespace)
	  (setq Str (substr Str 2))
	  );end while

	(while (vl-position (substr Str (strlen Str)) LispParse:Whitespace)
	  (setq Str (substr Str 1 (1- (strlen Str))))
	  );end while
	Str
	);end defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun LispParse:IsUselessString (String / )
	(and (= (type String) 'STR)
		 (or (= String "")
			 (LispParse:IsAllWhitespace String)
			 (LispParse:IsAllNewLine String)
			 );end or
		 );end and
	);end defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun LispParse:IsAllWhitespace (String / )
	(if (= String "")
	  T
	  (and (vl-position (substr String 1 1) LispParse:Whitespace)
		   (LispParse:IsAllWhitespace (substr String 2))
		   );end and
	  );end if
	);end defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun LispParse:IsAllNewLine (String / )
	(if (= (strlen String) 1)
	  (= String "\n")
	  (and (LispParse:IsAllNewLine (substr String 1 1))
		   (LispParse:IsAllNewLine (Substr String 2)))
	  );end if
	);end defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun LispParse:AddToTokenList (Word / )
	(setq CurrentWord "")
	(if (not (LispParse:IsUselessString Word))
	  (setq TokenList (cons (if (= (type Word) 'STR)
							  (LispParse:RemoveLeadingAndTrailingWhitespace Word)
							  Word
							  );end if
							TokenList
							);end cons
			);end setq
	  );end if
	);end defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun LispParse:AddToCurrentWord (Char / )
	(setq CurrentWord (strcat CurrentWord Char))
	);end defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;

  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  (defun LispParse:GetNextChar ( / Char)
	(setq NextChar (if (setq Char (read-char F))
					 (chr Char)
					 );end if
		  );end setq
	);end defun
  ;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
  
  (setq F (open File "R")

		ScanMode "NORMAL"

		CurrentWord ""
		);end setq

  (LispParse:GetNextChar)
  (setq ThisChar NextChar)
  
  (while (LispParse:GetNextChar)

	(cond ((= ScanMode "BLOCKCOMMENT")
		   (if (and (= ThisChar "|")
					(= NextChar ";"))
			 (progn
			   (setq ScanMode "NORMAL")
			   (LispParse:AddToTokenList (cons "BLOCKCOMMENT" (LispParse:CleanBlockComment CurrentWord)))
			   );end progn
			 (LispParse:AddToCurrentWord NextChar)
			 );end if
		   );end BLOCKCOMMENT

		  ((= ScanMode "LINECOMMENT")
		   (if (= NextChar "\n")
			 (progn
			   (setq ScanMode "NORMAL"
					 NextChar ""
					 )
			   (if (/= (setq CurrentWord (LispParse:CleanLineComment CurrentWord)) "")
				 (LispParse:AddToTokenList (cons "LINECOMMENT" CurrentWord))
				 );end if
			   );end progn
			 (LispParse:AddToCurrentWord NextChar)
			 );end if
		   );end LINECOMMENT

		  ((= ScanMode "STRING")

		   ;;;if NextChar is "\"",
		   ;		and either ThisChar is not "\\", or it and prevchar are "\\"
		   (if (and (= NextChar "\"")
					(or (/= ThisChar "\\")
						(and (= ThisChar "\\")
							 (= PrevChar "\\")
							 );end and
						);end or
					);end and
			 (progn
			   (LispParse:AddToTokenList (LispParse:AddToCurrentWord NextChar))
			   (setq ScanMode "NORMAL"
					 NextChar ""
					 );end setq
			   );end progn
			 (LispParse:AddToCurrentWord NextChar)
			 );end if
		   );end STRING

		  ((= ScanMode "NORMAL")

		   (cond 

				 ((and (= ThisChar ";")
					   (= NextChar "|"))
				  (setq ScanMode "BLOCKCOMMENT"
						CurrentWord ""
						);end setq
				  )

				 ((= ThisChar ";")
				  (if (/= NextChar "\n")
					(progn
					  (setq CurrentWord NextChar
							ScanMode "LINECOMMENT"
							);end setq
					  );end progn
					);end if
				  );end LINECOMMENT

				 ((= ThisChar "\"")
				  (setq CurrentWord (strcat ThisChar NextChar))
				  (if (= NextChar "\"")
					(progn
					  (LispParse:AddToTokenList CurrentWord)
					  (setq NextChar "")
					  )
					(setq ScanMode "STRING")
					);end if
				  );end STRING


				 ((vl-position NextChar '("(" ")"))
				  (LispParse:AddToTokenList CurrentWord)
				  (LispParse:AddToTokenList NextChar)
				  )

				 ((vl-position NextChar LispParse:Whitespace)
				  (LispParse:AddToTokenList CurrentWord)
				  )


				 (T
				  (LispParse:AddToCurrentWord NextChar)
				  );end T
				 );end cond
		   );end NORMAL
		  );end conds
	(setq PrevChar ThisChar
		  ThisChar NextChar)
	);end while
  
  (close F)

  (reverse TokenList)
  );end defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(princ)
