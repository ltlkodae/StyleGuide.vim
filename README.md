# StyleGuide.vim
Code with [google-syleguide](https://github.com/google/styleguide)  
Both readability, quality and unity of your code will be better

## Introduction
This vim plugin comes with following features:
* Show the [google-syleguide](https://github.com/google/styleguide) in split window
* Good to see as folding by same contents
* Shortcuts to toggle folds and to navigate

# ScreenShots
![tutorial](res/styleguide_tutorial.gif)

# Usage

## Open StyleGuide
\<styleguide.xml\> Could be a any file in g:StyleGuideXmlPath. Default is _shell.xml_
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
After opening StyleGuide, can use shortcut like below
* \+ : Open a fold 
* \- : Close a fold                                                                                                                                                                           
* \* : Open all folds                                                                                                                                                                           
* \= : Close all folds                                                                                                                                                                           
* \? : Display/Remove help text


# Installation

## Option 1: Manual installation

1. Copy StyleGuide.vim to your ~/.vim/plugin

## Option 2: Vundle installation

1. ~~Use Vundle to install it from ltlkodae/StyleGuide.vim~~ (not yet)

## Store styeleguide and Modify .vimrc

After either _Option 1_ or _Option 2_ above,
1. Store styleguide xml files of [google-syleguide](https://github.com/google/styleguide) to g:StyleGuideXmlPath. If you are Korean, [ltlkodae-syleguide](https://github.com/ltlkodae/styleguide) 의 *_kr.xml 을 사용할수 있습니다 (번역 진행중 ㅜㅜ)
3. Put the following lines in your .vimrc

```vim
" the path where styleguide files are stored
let g:StyleGuideXmlPath = '/user/ltlkodae/.vim/doc/styleguide'
```
_Do not use '~', instead of /user/ltlkodae. It would be not work. I do not know the reason_  
_If you know the way to use, please let me know_


# History

* 1.0.0 (2016-11-07): inital version