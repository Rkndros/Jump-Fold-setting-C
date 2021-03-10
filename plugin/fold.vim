set foldmethod=marker
"set foldtext={}

function! MyCreateFold(c)
	let l:l = a:c

	if l:l == '{'
		let l:r = '}'
	elseif l:l == '('
		let l:r = ')'
	else
		let l:r = ']'
	endif

	normal yl
	let l:curC = @0
	echo l:curC

	"get pos of cur 
	let l:curPos = getpos('.')

	let l:rec = 0

	let l:backFlag = (l:curC == '{')?(v:true):(v:false)
	while !l:backFlag
		execute 'normal ?\v(\' . l:l . '|\' . l:r . ')'
		normal yl
		let l:tmp = @0
		if l:tmp == l:r
			let l:rec += 1
		elseif l:tmp == l:l
			let l:rec -= 1
		endif
		if l:rec == -1
			break
		endif
	endwhile

	let l:backpos = (l:backFlag)?( line('.') ):( getpos('.')[1] )

	call setpos('.',l:curPos)
	let l:rec = 0

	let l:frontFlag = (l:curC == '}')?(v:true):(v:false)
	while !l:frontFlag
		execute 'normal /\v(\' . l:l . '|\' . l:r . ')'
		normal yl
		let l:tmp = @0
		if l:tmp == l:l
			let l:rec += 1
		elseif l:tmp == l:r
			let l:rec -= 1
		endif
		if l:rec == -1
			break
		endif
	endwhile

	let l:frontpos = (l:frontFlag)?( line('.') ):( getpos('.')[1] )

	call setpos('.',l:curPos)

	"execute l:backpos
	"execute 'normal zf' . l:frontpos . 'G'
	"call setpos('.',l:curPos)
	execute l:backpos . ',' . l:frontpos . 'fold'
	"return ':' . l:frontpos[1] . ',' . l:backpos[1] . 'fold' . '<CR>'
endfunction


"function! s:myFold( char )
"	return "zc"	
"endfunction

nnoremap zf{ @=MyCreateFold('{')<CR>
nnoremap zf( @=MyCreateFold('(')<CR>
nnoremap zf[ @=MyCreateFold('[')<CR>

nnoremap zf} @=MyCreateFold('{')<CR>
nnoremap zf) @=MyCreateFold('(')<CR>
nnoremap zf] @=MyCreateFold('[')<CR>

"nnoremap <expr> zc{ myFold({)
"nnoremap <expr> zc( myFold(()
"nnoremap <expr> zc[ myFold([)
"
"nnoremap <expr> zc} myFold(})
"nnoremap <expr> zc) myFold())
"nnoremap <expr> zc] myFold(])


