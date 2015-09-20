function! ExtractMethodFromVisualSelection(method_signature)
	let method_definition = GetTextFromVisualSelection()
	let [first_line, last_line] = GetLinesFromVisualSelection()

	call DeleteLines([first_line, last_line])

	let method_name = GetMethodNameFromSignature(a:method_signature)
	let argument_list = GetArgumentList(a:method_signature)
	let joined_arguments = join(argument_list, ", ")

	execute "normal! O" . method_name  . "(" . joined_arguments . ");" . "\<Esc>"
	let save_cursor = getpos(".")
	let save_cursor[1] = save_cursor[1] + 1 " Prepend method declaration

	call AppendMethodDefinitionToEndOfFile(a:method_signature, method_definition)
	call PrependMethodDeclarationToBeginningOfFile(a:method_signature)

	call setpos('.', save_cursor)

	return 0
endfunction

function! GetTextFromVisualSelection()
	let [lnum1, col1] = getpos("'<")[1:2]
	let [lnum2, col2] = getpos("'>")[1:2]

	let lines = getline(lnum1, lnum2)
	let lines[-1] = lines[-1][: col2 - (&selection == 'inclusive' ? 1 : 2)]
	let lines[0] = lines[0][col1 - 1:]

	return join(lines, "\n")
endfunction

function! GetLinesFromVisualSelection()
	let first_line = getpos("'<")[1]
	let last_line = getpos("'>")[1]

	let selection = [first_line, last_line]

	return selection
endfunction

function! DeleteLines(lines)
	let [first_line, last_line] = a:lines
	let total_lines = last_line - first_line + 1

	execute "normal! " . first_line . "G"
	execute "normal! " . total_lines . "dd"

	return 0
endfunction

function! GetMethodNameFromSignature(signature)
	let index_opening_paranthesis = stridx(a:signature, "(")
	let modifiers_return_value_and_name = strpart(a:signature, 0, index_opening_paranthesis)
	let index_space = strridx(modifiers_return_value_and_name, " ")

	let method_name = strpart(modifiers_return_value_and_name, index_space + 1)

	return method_name
endfunction

function! GetArgumentList(signature)
	let argument_list = []

	let index_opening_paranthesis = stridx(a:signature, "(")
	let index_closing_paranthesis = stridx(a:signature, ")")

	let length = index_closing_paranthesis - index_opening_paranthesis - 1

	if length == 0
		return argument_list
	endif

	let return_types_and_parameters = strpart(a:signature, index_opening_paranthesis + 1, length)

	let parameter_declaration_list = split(return_types_and_parameters, ",")

	for tuple in parameter_declaration_list
		let type_and_name = split(tuple, " ") " Leading space is ignored

		if len(type_and_name) == 2 " Also handles single 'void' correctly
			call add(argument_list, type_and_name[1])
		endif
	endfor

	return argument_list
endfunction

function! AppendMethodDefinitionToEndOfFile(method_signature, method_definition)
	let saved_register = @1

	execute "normal! G"
	execute "normal! A\n\n\<Esc>"
	execute "normal! I" . a:method_signature "\n" . "\<Esc>"
	execute "normal! I" . "{" . "\<Esc>"

	let @1 = a:method_definition 
	execute "normal! o\<C-R>1\<Esc>"

	execute "normal! G"
	execute "normal! A\n}\<Esc>"

	let @1 = saved_register

	return 0
endfunction

function! PrependMethodDeclarationToBeginningOfFile(method_declaration)
	let saved_register = @1

	let @1 = a:method_declaration

	execute "normal! gg"
	execute "normal! O\<C-R>1\<Esc>"
	execute "normal! A;\<Esc>"

	let @1 = saved_register

	return 0
endfunction
