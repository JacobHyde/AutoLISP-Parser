;LispIndex - Parser.lsp

(setq LispParse:Whitespace '("\n" "\t" " ")

	  LispStructure:GridSize 0.1
	  LispStructure:HeaderHeight 0.1
	  LispStructure:HeaderTSize 0.035
	  LispStructure:NoteTSize 0.02
	  LispStructure:ArgVarOffsetY 0.025
	  LispStructure:ArgVarOffsetX 0.025
	  
	  LispStructure:MinWidth 1.0
	  LispStructure:StartWidth 2.0
	  LispStructure:PLineWid 0.01

	  #Origin3D# (vlax-3d-point '(0.0 0.0 0.0))
	  );end setq


(load "LispIndex - Support.lsp")
(load "LispIndex - Tokenizer.lsp")


;|
Add code for parsing tokenized files
Add code for visual structure tools
|;
