## Behind The Scenes...
# Thorsten Ball's Vim Configuration

### Setup

```bash
git clone git://github.com/mrnugget/vimconfig.git ~/.vim
ln -s ~/.vim/vimrc ~/.vimrc
cd ~/.vim
git submodule update --init
```


### Updating plugins

```bash
cd ~/.vim
git submodule foreach git pull origin master
```

### Adding a new plugin

```bash
cd ~/.vim
git submodule add <path to repo> bundle/<name>
```


### Removing a plugin

```bash
cd ~/.vim
git submodule deinit bundle/<name>
git rm bundle/<name>
```
