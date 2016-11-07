# StyleGuide.vim
Code with [google-syleguide](https://github.com/google/styleguide).
Both readability, quality and unity of your code will be better

[google-syleguide](https://github.com/google/styleguide) 를 참고하면서 프로그래밍하세요. 
코드의 가독성과 품질이 좋아지고, 통일성이 유지될 것입니다.  
Korean 일 경우, [ltlkodae-syleguide](https://github.com/ltlkodae/styleguide) 의 번역본(*_kr.xml) 을 사용하셔도 됩니다. (진행중 ㅜㅜ)

## Introduction
This vim plugin comes with following features:
* Show the [google-syleguide](https://github.com/google/styleguide) in split window
* Good to see as folding by same contents
* Shortcuts to toggle folds and to navigate

# ScreenShots
![tutorial](res/styleguide_tutorial.gif)

# Usage

## Open StyleGuide
\<styleguide.xml\> could be a any file in g:StyleGuideXmlPath. Default is _shell.xml_
```vim
    :StyleGuide shell.xml
    :StyleGuide objcguide.xml
    :StyleGuide <styleguide.xml>
```

## Close StyleGuide
```vim
    :StyleGuide
```

## Shortcut
After opening the StyleGuide, can use shortcut like below
* \+ : Open a fold 
* \- : Close a fold                                                                                                                                                                           
* \* : Open all folds                                                                                                                                                                           
* = : Close all folds                                                                                                                                                                           
* ? : Display/Remove help text


# Installation

## Step 1 Vim installation

### Option 1: Manual installation

* Copy StyleGuide.vim to your ~/.vim/plugin

### Option 2: Vundle installation

* ~~Use Vundle to install it from ltlkodae/StyleGuide.vim~~ (will be update, not yet)

## Step 2 Store styleguide xml files
  
* Store styleguide xml files of [google-syleguide](https://github.com/google/styleguide) to g:StyleGuideXmlPath.

## Step 3 Modify .vimrc
* Put the following lines in your .vimrc

```vim
" the path where styleguide files are stored
let g:StyleGuideXmlPath = '/user/ltlkodae/.vim/doc/styleguide'
```

_Do not use '~', instead of /user/ltlkodae. It would be not work. I do not know the reason_  
_If you know the way to use, please let me know_


# History

* 1.0.0 (2016-11-07): inital version