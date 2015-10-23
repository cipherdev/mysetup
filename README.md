
# *****************************************
# Copyright  2014
# Inc. All Rights Reserved
# Proprietary and Confidential
# *****************************************
# <anhhuy@live.com>
# *****************************************

#@Setup vim and cscope
@1. sudo apt-get install cscope vim
@2. cp -rf .vimrc  > ~/ or "user/hcm/hule"
@3. vi .vimrc Change path < set csprg=/AMCC/hule/tools/bin/cscope >
@4. cscope -b -q -k -R
#http://cscope.sourceforge.net/cscope_vim_tutorial.html

#@Setup screen 
@1. apt-get install screen 
@2. cp -rf .screenrc ~/
@4. screen -RS huyle
@5. screen -xS huyle

#Setup env for Centos
cp -rf .cshrc ~/
#note for ubuntu: ~/.bashrc

#note for gitcodebase
mkdir codebase
cd codebase
git init --bare
cd ..
git clone codebase xuno
mv xuno/* xuno_wk/
git add -A ./
git commit
git push origin master
git diff ./   or  git diff HEAD


