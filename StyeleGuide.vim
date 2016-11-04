let g:STYLE_GUIDE_FILE_NAME = 'shell.xml'
let g:STYLE_GUIDE_WIN_TITLE= '__style_guide__'

function! XmlParser_GetNodeText(xml, node)
  let startIdx = a:node[0]
  let endIdx = a:node[1]

  let paddingShortestLen = 1000
  for idx in range(endIdx-startIdx)
  let lineIdx = idx+startIdx

    let text = substitute(a:xml[lineIdx], '<[^>]*>', '', 'g')
    let text = substitute(text, '^[[:space:]]*$', '', 'g')

    let paddingStr = matchstr(text, "^[[:space:]]*")

  let paddingLen = strlen(paddingStr)

  if paddingLen != 0
    if paddingShortestLen > paddingLen
        let paddingShortestLen = paddingLen
    endif
    endif
  endfor

  let text = ''
  let prevLine = ''
  for idx in range(endIdx-startIdx)
  let lineIdx = idx+startIdx

    let line = substitute(a:xml[lineIdx], '<[^>]*>', '', 'g')
    let line = substitute(line, '^[[:space:]]*$', '', 'g')
  
  if line == '' && prevLine == ''
    continue
  endif
  
  let prevLine = line
    let text = text . "\n" . strpart(line, paddingShortestLen)

  endfor

  return text
endfunction


function! XmlParser_GetAttribute(xml, node, attr)

  let startIdx = a:node[0]
  let endIdx = a:node[1]

  let value = ""
  for idx in range(endIdx-startIdx)

    let xmlLine = matchstr(a:xml[idx+startIdx], a:attr . "=\"[^\"]*\"")
    if xmlLine != ""
    let xmlLine = substitute(xmlLine, a:attr . "=", "", "")
    let xmlLine = substitute(xmlLine, "\"", "", "g")
  
      let value = xmlLine
    break
    endif
  endfor

  return value
endfunction

function! XmlParser_GetNodeList(xml, node, tag)
  
  if a:node == []
  let orgStartIdx = 0
  let orgEndIdx = len(a:xml)-1
  else
    let orgStartIdx = a:node[0]
  let orgEndIdx = a:node[1]
  endif
  
  let tagInfoList = []
  let tagStartIdx = -1
  let tagEndIdx   = -1

  for idx in range(orgEndIdx-orgStartIdx)

    let lineIdx = idx+orgStartIdx
  let line = a:xml[lineIdx]
  
  if matchstr(line, '<\<' . a:tag) != ''
    let tagStartIdx = lineIdx
  elseif matchstr(line, '<\/\<' . a:tag) != ''
    let tagEndIdx = lineIdx
  endif

  if tagStartIdx != -1 && tagEndIdx != -1
    call add(tagInfoList, [tagStartIdx, tagEndIdx])
    let tagStartIdx = -1
    let tagEndIdx   = -1
    endif

  endfor

  return tagInfoList
endfunction


function! GetStyleInfo(styleXml)
  
  "let styleInfo = {}
  let styleInfo = []

  let categoryNodeList = XmlParser_GetNodeList(a:styleXml, [], 'CATEGORY')

  for categoryNode in categoryNodeList

    let categoryTitle = XmlParser_GetAttribute(a:styleXml, categoryNode, 'title')
  "call extend(styleInfo, {categoryTitle : {}})

  let styleInfo = add(styleInfo, [categoryTitle, []])
  let curCategory = get(styleInfo, len(styleInfo)-1)

    let stylePointNodeList = XmlParser_GetNodeList(a:styleXml, categoryNode, 'STYLEPOINT')

  for stylePointNode in stylePointNodeList
      let stylePointTitle = XmlParser_GetAttribute(a:styleXml, stylePointNode, 'title')
    let stylePointText = XmlParser_GetNodeText(a:styleXml, stylePointNode)

    "call extend(get(styleInfo, categoryTitle), {stylePointTitle : stylePointText})
    let curCategory[1] = add(curCategory[1], [stylePointTitle, stylePointText])
    
  endfor

  if len(stylePointNodeList) == 0
    let categoryText = XmlParser_GetNodeText(a:styleXml, categoryNode)
    let curCategory[1] = add(curCategory[1], ['', categoryText])
  endif

  endfor
  
  return styleInfo
endfunction

function! SetSyntax()
  syntax match HelpText '^" .*'
  highlight default link HelpText Comment

  syntax match TitleText '^\* .*'
  highlight default link TitleText Title

  syntax match SubTitleText '^\*\* .*'
  highlight default link SubTitleText SpecialKey

  return
endfunction

let g:maxCategoryLen = 33
let g:maxStylePointLen = 80

function! s:ResizeOpen()
  exe 'silent! vertical resize ' . g:maxStylePointLen
endfunction

function! s:ResizeClose()
  exe 'silent! vertical resize ' . g:maxCategoryLen
endfunction

let s:helpCnt = 0
function! s:HelpToggle()
  
  if s:helpCnt != 0
    for help in range(s:helpCnt+1)
      exe '1,' . 1 . ' delete _'
    endfor
  endif
  
  call append(0, '')

  if s:helpCnt == 1
    call append(0, '" + : Open a fold')
    call append(1, '" - : Close a fold')
    call append(2, '" * : Open all folds')
    call append(3, '" = : Close all folds')
    call append(4, '" ? : Remove help text')
    let s:helpCnt = 5
  else
    call append(0, '" ? : Press ? to display help text')
    let s:helpCnt = 1
  endif
endfunction

function! s:StyleGuidClose()
    let winnum = bufwinnr(g:STYLE_GUIDE_WIN_TITLE)
    if winnum == -1
        return
    endif

    if winnr() == winnum
        if winbufnr(2) != -1
            close
        endif
    else
        let curbufnr = bufnr('%')
        exe winnum . 'wincmd w'
        close
        let winnum = bufwinnr(curbufnr)
        if winnr() != winnum
            exe winnum . 'wincmd w'
        endif
    endif
endfunction


function! s:PublicStyleGuide(styleFileName)
  let winnum = bufwinnr(g:STYLE_GUIDE_WIN_TITLE)
  if winnum != -1
    call s:StyleGuidClose()
    return
  endif

  if a:styleFileName == ''
    let styleFileName = g:STYLE_GUIDE_FILE_NAME
  else
  let styleFileName = a:styleFileName
  endif
  
  if !exists("g:StyleGuideXmlPath")
    let g:StyleGuideXmlPath = '.;'
  endif

  let styleFile = findfile(styleFileName, g:StyleGuideXmlPath)

  if styleFile == ''
  echo 'There is no ' . styleFileName
    return
  endif

  if !filereadable(styleFile)
  echo 'Unreadable ' . styleFile
  return
  endif

  exe 'silent! topleft vertical 50 split ' . g:STYLE_GUIDE_WIN_TITLE


  setlocal buftype=nofile
  set nonumber
  set nowrap
  set paste

  setlocal foldcolumn=3
  setlocal foldminlines=0
  setlocal foldmethod=manual
  setlocal foldlevel=9999
  setlocal foldtext=getline(v:foldstart)

  exe "1,1" . "fold"

  syntax match HelpText '^" .*'
  highlight default link HelpText Comment

  syntax match TitleText '^\* .*'
  highlight default link TitleText Special

  syntax match SubTitleText '^\*\* .*'
  highlight default link SubTitleText Identifier

  let styleInfo = GetStyleInfo(readfile(styleFile))
  
  exe "normal o" . ""
  for categoryInfo in styleInfo
    exe "normal o" . "* " . categoryInfo[0]

  if g:maxCategoryLen < strlen(categoryInfo[0])
    let g:maxCategoryLen = strlen(categoryInfo[0])
  endif

  let categoryStartLine = line(".")

    for stylePoint in categoryInfo[1]
      exe "normal o" . "** " . stylePoint[0]
    let stylePointStartLine= line(".")
      exe "normal o" . stylePoint[1]
    let stylePointEndLine = line(".")

    if g:maxCategoryLen < strlen(stylePoint[0])
      let g:maxCategoryLen = strlen(stylePoint[0])
      endif

      exe stylePointStartLine . "," . stylePointEndLine . "fold"
  endfor
  let categoryEndLine = line(".")

  endfor
  
  let g:maxCategoryLen = g:maxCategoryLen+5
  exe 'silent! vertical resize ' . g:maxCategoryLen

  normal gg

  call s:HelpToggle()

  nnoremap <buffer> <silent> + :silent! foldopen<CR> :call <SID>ResizeOpen()<CR>
  nnoremap <buffer> <silent> - :silent! foldclose<CR> :call <SID>ResizeClose()<CR>
  nnoremap <buffer> <silent> * :silent! %foldopen!<CR> :call <SID>ResizeOpen()<CR>
  nnoremap <buffer> <silent> = :silent! %foldclose<CR> :call <SID>ResizeClose()<CR>
  nnoremap <buffer> <silent> ? :call <SID>HelpToggle()<CR>

endfunction

command! -nargs=? -bar StyleGuide call s:PublicStyleGuide(<q-args>)
