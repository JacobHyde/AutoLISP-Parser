;LispIndex - Support.lsp
;Support functions for LispIndex tools


;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun AddToCount (Tag CountVar / );Custom counting routine.  Creates a tally

  (if (null (eval CountVar))	;If CountVar evaluates to nothing
    (set CountVar (list (cons Tag 1)))	;Start the CountVar with the Tag, and a 1, this must be the first instance of anything
    (if (not (assoc Tag (eval CountVar)))	;If Tag is not found within CountVar,
      (set CountVar (append (eval CountVar) (list (cons Tag 1))))	;Add a new item to CountVar, with a 1, this is the first instance of something new
      (set CountVar (subst (cons Tag (1+ (cdr (Assoc Tag (eval CountVar))))) (assoc Tag (eval CountVar)) (eval CountVar)))	;Else, we'll need to subtitute, add the number, rebuild the list.  woot
      );end if
    );end if

  CountVar	;Return the countvar
  );end defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun Str:RemoveLeadingChar (Str Char / )
  (if (/= Str "")
	(while (= (substr Str 1 1) Char)
	  (setq Str (substr Str 2))
	  );end while
	);end if
  Str
  );end defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(defun Str:RemoveTrailingChar (Str Char / )
  (if (/= Str "")
	(while (= (substr Str (strlen Str)) Char)
	  (Setq Str (substr Str 1 (1- (strlen Str))))
	  );end while
	);end if
  Str
  );end defun

;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;;
(princ)
