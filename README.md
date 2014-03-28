AutoLISP-Parser
===============

Parser and structure analysis tools for AutoLISP files

======================================================================================
Installation:

These files should be placed together into a common folder.

APPLOAD the file "LispIndex - Tokenizer.lsp" into AutoCAD to get access to the tools.

Add the files to your startup suite, or load them programatically from other sources, if desired


======================================================================================
Usage:

Presently, this only has the tokenize function:

(TokenizeLispFile FileLoc) - Given a FileLoc of a .lsp file, will return a list of all tokens from the file, with Line and Block comments in assoc pairs identifying them as comments.

